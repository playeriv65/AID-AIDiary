// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'dart:async';
import 'dart:io';

import 'package:daily_you/config_provider.dart';
import 'package:daily_you/device_info_service.dart';
import 'package:daily_you/flashback_manager.dart';
import 'package:daily_you/l10n/generated/app_localizations.dart';
import 'package:daily_you/launch_intent.dart';
import 'package:daily_you/models/entry.dart';
import 'package:daily_you/models/image.dart';
import 'package:daily_you/notification_manager.dart';
import 'package:daily_you/pages/share_page.dart';
import 'package:daily_you/providers/entries_provider.dart';
import 'package:daily_you/providers/entry_images_provider.dart';
import 'package:daily_you/stats/streaks.dart';
import 'package:daily_you/time_manager.dart';
import 'package:daily_you/utils/entry_navigation.dart';
import 'package:daily_you/utils/entry_preview.dart';
import 'package:daily_you/widgets/entry_timeline_tile.dart';
import 'package:daily_you/widgets/flashbacks_row.dart';
import 'package:daily_you/widgets/local_image_loader.dart';
import 'package:daily_you/widgets/mood_icon.dart';
import 'package:daily_you/widgets/new_entry_fab.dart';
import 'package:daily_you/widgets/support_banner.dart';
import 'package:daily_you/widgets/writing_heatmap.dart';
import 'package:intl/intl.dart';
import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';
import 'package:share_receiver/share_receiver.dart';
import 'package:word_count/word_count.dart';

/// Dashboard for the current day: what to write, how it is going, and what
/// came before. It is the first page, so it also handles launch intents.
class TodayPage extends StatefulWidget {
  const TodayPage({super.key, this.onOpenJournal});

  /// Switches to the full journal list.
  final VoidCallback? onOpenJournal;

  @override
  State<TodayPage> createState() => _TodayPageState();
}

class _TodayPageState extends State<TodayPage>
    with AutomaticKeepAliveClientMixin {
  int _promptOffset = 0;
  StreamSubscription<SharePayload>? _shareSubscription;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _checkForLaunchIntent();
    _checkForNotificationLaunch();
    if (Platform.isAndroid) {
      _shareSubscription = ShareReceiver.instance.shares.listen(_handleShare);
    }
  }

  @override
  void dispose() {
    _shareSubscription?.cancel();
    super.dispose();
  }

  Future<void> _checkForLaunchIntent() async {
    final intent = DeviceInfoService().launchIntent;
    if (intent == null) return;
    DeviceInfoService().launchIntent = null;
    final today = EntriesProvider.instance.getEntryForToday();
    if (intent is TakePhotoIntent) {
      await EntryNavigation.edit(context, today, openCamera: true);
    } else {
      await EntryNavigation.edit(context, today);
    }
  }

  Future<void> _handleShare(SharePayload payload) async {
    if (!mounted) return;
    Navigator.of(context).popUntil((route) => route.isFirst);
    await Navigator.of(context).push(MaterialPageRoute(
      allowSnapshotting: false,
      builder: (context) => SharePage(payload: payload),
    ));
  }

  Future<void> _checkForNotificationLaunch() async {
    if (!Platform.isAndroid) return;
    final launchDetails = await NotificationManager.instance.notifications
        .getNotificationAppLaunchDetails();
    if (!NotificationManager.instance.justLaunched) return;
    NotificationManager.instance.justLaunched = false;

    final notifId = launchDetails?.notificationResponse?.id;
    final payload = launchDetails?.notificationResponse?.payload ?? '';
    if (!mounted) return;
    if (notifId == 1) {
      final referenceDate = DateTime.tryParse(payload) ?? DateTime.now();
      await NotificationManager.instance.dismissOnThisDayNotification();
      if (mounted) await EntryNavigation.onThisDay(context, referenceDate);
    } else if (notifId == 0) {
      final targetDate = DateTime.tryParse(payload) ?? DateTime.now();
      final entry = EntriesProvider.instance.getEntryForDate(targetDate);
      await EntryNavigation.edit(context, entry,
          overrideCreateDate: TimeManager.isToday(targetDate)
              ? DateTime.now()
              : TimeManager.currentTimeOnDifferentDate(targetDate));
    }
  }

  String _greeting(AppLocalizations l10n, DateTime now) => switch (now.hour) {
        >= 5 && < 12 => l10n.todayGreetingMorning,
        >= 12 && < 18 => l10n.todayGreetingAfternoon,
        >= 18 && < 23 => l10n.todayGreetingEvening,
        _ => l10n.todayGreetingNight,
      };

  void _openDay(DateTime day) {
    final entries = EntriesProvider.instance.getEntriesForDate(day);
    if (entries.isNotEmpty) {
      EntryNavigation.view(context, entries.first);
    } else if (!day.isAfter(DateTime.now())) {
      EntryNavigation.addForDay(context, day);
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final l10n = AppLocalizations.of(context)!;
    final config = context.watch<ConfigProvider>();
    final entriesProvider = context.watch<EntriesProvider>();
    context.watch<EntryImagesProvider>();
    final entries = entriesProvider.entries;
    final now = DateTime.now();
    final todayEntries = entriesProvider.getEntriesForDate(now);

    final flashbacks = config.get(Settings.showFlashbacks)
        ? FlashbackManager.getFlashbacks(context, entries)
        : const [];
    final showBanner = SupportBanner.shouldShowBanner(
      entryCount: entries.length,
      lastDismissedIso: config.get(Settings.lastDismissedSupportBannerDate),
    );
    final streaks = calculateStreaks(entries, now: now);
    final hideImages = config.get(Settings.hideImagesInGallery);

    final header = _Header(
        greeting: _greeting(l10n, now), date: now, streak: streaks.current);
    final todayCard = _TodayCard(entries: todayEntries);
    final stats = _StatsRow(entries: entries, streaks: streaks, now: now);
    final prompts = _prompts(l10n);
    final dayOfYear = now.difference(DateTime(now.year)).inDays;
    final prompt = prompts[(dayOfYear + _promptOffset) % prompts.length];
    final promptCard = _PromptCard(
        prompt: prompt,
        onAnother: () => setState(() => _promptOffset++),
        onWrite: () =>
            EntryNavigation.edit(context, null, initialPrompt: prompt));
    final activity = _Section(
        title: l10n.todayActivityTitle,
        child: WritingHeatmap(entries: entries, onDayTap: _openDay));
    final flashbackSection = flashbacks.isEmpty
        ? null
        : _Section(
            title: l10n.flashbacksTitle,
            child: FlashbacksRow(flashbacks: [...flashbacks]));
    final recent = entries.take(5).toList();
    final recentSection = recent.isEmpty
        ? null
        : _Section(
            title: l10n.todayRecentTitle,
            action: widget.onOpenJournal == null
                ? null
                : TextButton(
                    key: const ValueKey('today-see-all'),
                    onPressed: widget.onOpenJournal,
                    child: Text(l10n.todaySeeAll)),
            child: _RecentEntries(entries: recent, hideImages: hideImages));
    final photos = hideImages ? const <EntryImage>[] : _recentPhotos(entries);
    final photoSection = photos.isEmpty
        ? null
        : _Section(
            title: l10n.todayRecentPhotos, child: _PhotoStrip(images: photos));

    return Stack(children: [
      LayoutBuilder(builder: (context, constraints) {
        final wide = constraints.maxWidth >= 900;
        const gap = SizedBox(height: 20);
        final List<Widget> children;
        if (wide) {
          children = [
            header,
            gap,
            Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Expanded(
                  flex: 3,
                  child: Column(children: [
                    todayCard,
                    gap,
                    promptCard,
                    if (recentSection != null) ...[gap, recentSection],
                  ])),
              const SizedBox(width: 24),
              Expanded(
                  flex: 2,
                  child: Column(children: [
                    stats,
                    gap,
                    activity,
                    if (flashbackSection != null) ...[gap, flashbackSection],
                    if (photoSection != null) ...[gap, photoSection],
                  ])),
            ]),
          ];
        } else {
          children = [
            header,
            gap,
            todayCard,
            gap,
            stats,
            gap,
            promptCard,
            if (flashbackSection != null) ...[gap, flashbackSection],
            gap,
            activity,
            if (recentSection != null) ...[gap, recentSection],
            if (photoSection != null) ...[gap, photoSection],
          ];
        }
        return ListView(
          key: const PageStorageKey('today-list'),
          padding: EdgeInsets.fromLTRB(wide ? 32 : 16, 8, wide ? 32 : 16, 96),
          children: [
            if (showBanner) SupportBanner(configProvider: config),
            Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1200),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: children),
              ),
            ),
          ],
        );
      }),
      const PositionedDirectional(end: 16, bottom: 16, child: NewEntryFab()),
    ]);
  }

  List<EntryImage> _recentPhotos(List<Entry> entries) {
    final images = EntryImagesProvider.instance;
    final result = <EntryImage>[];
    for (final entry in entries) {
      if (entry.id == null) continue;
      final image = images.getFirstImageForEntry(entry.id!);
      if (image != null) result.add(image);
      if (result.length >= 12) break;
    }
    return result;
  }

  static List<String> _prompts(AppLocalizations l10n) => [
        l10n.todayPrompt1,
        l10n.todayPrompt2,
        l10n.todayPrompt3,
        l10n.todayPrompt4,
        l10n.todayPrompt5,
        l10n.todayPrompt6,
        l10n.todayPrompt7,
        l10n.todayPrompt8,
        l10n.todayPrompt9,
        l10n.todayPrompt10,
      ];
}

class _Header extends StatelessWidget {
  const _Header(
      {required this.greeting, required this.date, required this.streak});
  final String greeting;
  final DateTime date;
  final int streak;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
        Expanded(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(TimeManager.formatDateWithWeekday(date, context),
                style: theme.textTheme.titleSmall
                    ?.copyWith(color: cs.onSurfaceVariant)),
            const SizedBox(height: 4),
            Text(greeting,
                style: theme.textTheme.headlineMedium
                    ?.copyWith(fontWeight: FontWeight.w600)),
          ]),
        ),
        if (streak > 0)
          Tooltip(
            message: l10n.streakCurrent(streak),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                  color: cs.tertiaryContainer,
                  borderRadius: BorderRadius.circular(20)),
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                Icon(Icons.local_fire_department_rounded,
                    size: 18, color: cs.onTertiaryContainer),
                const SizedBox(width: 4),
                Text(l10n.todayStreakDays(streak),
                    style: theme.textTheme.labelLarge
                        ?.copyWith(color: cs.onTertiaryContainer)),
              ]),
            ),
          ),
      ]),
    );
  }
}

class _TodayCard extends StatelessWidget {
  const _TodayCard({required this.entries});
  final List<Entry> entries;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final l10n = AppLocalizations.of(context)!;
    final latest = entries.firstOrNull;

    final Widget content;
    if (latest == null) {
      content = Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(l10n.todayHowWasDay,
            style: theme.textTheme.titleLarge
                ?.copyWith(color: cs.onSecondaryContainer)),
        const SizedBox(height: 16),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          for (final mood in const [-2, -1, 0, 1, 2])
            _MoodButton(
                mood: mood,
                onTap: () =>
                    EntryNavigation.edit(context, null, initialMood: mood)),
        ]),
        const SizedBox(height: 16),
        Wrap(spacing: 8, runSpacing: 8, children: [
          FilledButton.icon(
              key: const ValueKey('today-write'),
              onPressed: () => EntryNavigation.edit(context, null),
              icon: const Icon(Icons.edit_rounded),
              label: Text(l10n.todayWrite)),
          OutlinedButton.icon(
              onPressed: () =>
                  EntryNavigation.edit(context, null, openCamera: true),
              icon: const Icon(Icons.camera_alt_rounded),
              label: Text(l10n.actionTakePhoto)),
        ]),
      ]);
    } else {
      final preview = entryPreview(latest.text);
      final words = entries.fold<int>(0, (n, e) => n + wordsCount(e.text));
      content = Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Icon(Icons.check_circle_rounded, size: 18, color: cs.primary),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
                '${l10n.todayWrittenCount(entries.length)} · ${l10n.wordCount(words)}',
                style: theme.textTheme.labelLarge
                    ?.copyWith(color: cs.onSecondaryContainer)),
          ),
          MoodIcon(moodValue: latest.mood, size: 22),
        ]),
        const SizedBox(height: 12),
        InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: () => EntryNavigation.view(context, latest),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            if (preview.title != null)
              Text(preview.title!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: cs.onSecondaryContainer)),
            Text(
                preview.snippet.isEmpty && preview.title == null
                    ? l10n.writeSomethingHint
                    : preview.snippet,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodyMedium?.copyWith(
                    height: 1.45,
                    color: cs.onSecondaryContainer.withValues(alpha: .8))),
          ]),
        ),
        const SizedBox(height: 16),
        Wrap(spacing: 8, runSpacing: 8, children: [
          FilledButton.icon(
              key: const ValueKey('today-continue'),
              onPressed: () => EntryNavigation.edit(context, latest),
              icon: const Icon(Icons.edit_rounded),
              label: Text(l10n.todayContinue)),
          OutlinedButton.icon(
              onPressed: () => EntryNavigation.edit(context, null),
              icon: const Icon(Icons.add_rounded),
              label: Text(l10n.todayAddAnother)),
        ]),
      ]);
    }
    return Card.filled(
      key: const ValueKey('today-card'),
      margin: EdgeInsets.zero,
      color: cs.secondaryContainer,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Padding(padding: const EdgeInsets.all(20), child: content),
    );
  }
}

class _MoodButton extends StatelessWidget {
  const _MoodButton({required this.mood, required this.onTap});
  final int mood;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).colorScheme.surface.withValues(alpha: .6),
      shape: const CircleBorder(),
      child: InkWell(
        key: ValueKey('today-mood-$mood'),
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: SizedBox(
            width: 52,
            height: 52,
            child: Center(
                child:
                    MoodIcon(moodValue: mood, size: 26, allowScaling: false))),
      ),
    );
  }
}

class _StatsRow extends StatelessWidget {
  const _StatsRow(
      {required this.entries, required this.streaks, required this.now});
  final List<Entry> entries;
  final Streaks streaks;
  final DateTime now;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final locale = TimeManager.currentLocale(context);
    final thisMonth =
        entries.where((e) => TimeManager.isSameMonth(e.timeCreate, now)).length;
    final words = entries.fold<int>(0, (n, e) => n + wordsCount(e.text));
    final tiles = [
      (
        Icons.local_fire_department_rounded,
        '${streaks.current}',
        l10n.todayStatStreak
      ),
      (Icons.emoji_events_rounded, '${streaks.longest}', l10n.todayStatLongest),
      (Icons.calendar_month_rounded, '$thisMonth', l10n.todayStatThisMonth),
      (
        Icons.notes_rounded,
        NumberFormat.compact(locale: locale).format(words),
        l10n.todayStatWords
      ),
    ];
    return Row(children: [
      for (var i = 0; i < tiles.length; i++) ...[
        if (i > 0) const SizedBox(width: 8),
        Expanded(
            child: _StatTile(
                icon: tiles[i].$1, value: tiles[i].$2, label: tiles[i].$3)),
      ],
    ]);
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile(
      {required this.icon, required this.value, required this.label});
  final IconData icon;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
          color: cs.surfaceContainer, borderRadius: BorderRadius.circular(16)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Icon(icon, size: 18, color: cs.primary),
        const SizedBox(height: 8),
        FittedBox(
          fit: BoxFit.scaleDown,
          alignment: AlignmentDirectional.centerStart,
          child: Text(value,
              style: theme.textTheme.titleLarge
                  ?.copyWith(fontWeight: FontWeight.w700)),
        ),
        Text(label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.labelSmall
                ?.copyWith(color: cs.onSurfaceVariant)),
      ]),
    );
  }
}

class _PromptCard extends StatelessWidget {
  const _PromptCard(
      {required this.prompt, required this.onAnother, required this.onWrite});
  final String prompt;
  final VoidCallback onAnother;
  final VoidCallback onWrite;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final l10n = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 12, 12),
      decoration: BoxDecoration(
          border: Border.all(color: cs.outlineVariant),
          borderRadius: BorderRadius.circular(24)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Icon(Icons.lightbulb_outline_rounded, size: 18, color: cs.tertiary),
          const SizedBox(width: 6),
          Text(l10n.todayPromptTitle,
              style: theme.textTheme.labelLarge?.copyWith(color: cs.tertiary)),
        ]),
        const SizedBox(height: 10),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: Text(prompt,
              key: ValueKey(prompt),
              style: theme.textTheme.titleMedium?.copyWith(height: 1.4)),
        ),
        const SizedBox(height: 8),
        Row(mainAxisAlignment: MainAxisAlignment.end, children: [
          TextButton.icon(
              key: const ValueKey('today-prompt-another'),
              onPressed: onAnother,
              icon: const Icon(Icons.refresh_rounded),
              label: Text(l10n.todayPromptAnother)),
          const SizedBox(width: 4),
          FilledButton.tonal(
              key: const ValueKey('today-prompt-write'),
              onPressed: onWrite,
              child: Text(l10n.todayPromptWrite)),
        ]),
      ]),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.child, this.action});
  final String title;
  final Widget child;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      SizedBox(
        height: 40,
        child: Row(children: [
          Expanded(
              child: Text(title,
                  style: theme.textTheme.titleMedium
                      ?.copyWith(fontWeight: FontWeight.w600))),
          if (action != null) action!,
        ]),
      ),
      const SizedBox(height: 4),
      child,
    ]);
  }
}

class _RecentEntries extends StatelessWidget {
  const _RecentEntries({required this.entries, required this.hideImages});
  final List<Entry> entries;
  final bool hideImages;

  @override
  Widget build(BuildContext context) {
    final images = EntryImagesProvider.instance;
    return Column(children: [
      for (var i = 0; i < entries.length; i++)
        EntryTimelineTile(
          entry: entries[i],
          images: images.getForEntry(entries[i]),
          hideImage: hideImages,
          isFirst: i == 0,
          isLast: i == entries.length - 1,
          showDate: i == 0 ||
              !TimeManager.isSameDay(
                  entries[i - 1].timeCreate, entries[i].timeCreate),
          onTap: () => EntryNavigation.view(context, entries[i]),
        ),
    ]);
  }
}

class _PhotoStrip extends StatelessWidget {
  const _PhotoStrip({required this.images});
  final List<EntryImage> images;

  @override
  Widget build(BuildContext context) {
    final entries = EntriesProvider.instance.entries;
    return SizedBox(
      height: 96,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: images.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final image = images[index];
          final entry = entries.where((e) => e.id == image.entryId).firstOrNull;
          return ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: SizedBox(
              width: 96,
              child: Stack(fit: StackFit.expand, children: [
                LocalImageLoader(imagePath: image.imgPath, cacheSize: 250),
                Material(
                  type: MaterialType.transparency,
                  child: InkWell(
                      onTap: entry == null
                          ? null
                          : () => EntryNavigation.view(context, entry)),
                ),
              ]),
            ),
          );
        },
      ),
    );
  }
}
