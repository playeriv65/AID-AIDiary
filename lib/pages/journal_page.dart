// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'dart:async';
import 'dart:io';

import 'package:aid_diary/utils/diary_day.dart';
import 'package:aid_diary/config/app_config.dart';
import 'package:aid_diary/config_provider.dart';
import 'package:aid_diary/models/builtin_templates.dart';
import 'package:aid_diary/widgets/quick_check_in.dart';
import 'package:aid_diary/device_info_service.dart';
import 'package:aid_diary/flashback_manager.dart';
import 'package:aid_diary/l10n/generated/app_localizations.dart';
import 'package:aid_diary/launch_intent.dart';
import 'package:aid_diary/models/entry.dart';
import 'package:aid_diary/models/flashback.dart';
import 'package:aid_diary/notification_manager.dart';
import 'package:aid_diary/pages/random_review_page.dart';
import 'package:aid_diary/pages/review_story_page.dart';
import 'package:aid_diary/pages/today_story_page.dart';
import 'package:aid_diary/pages/entry_view_page.dart';
import 'package:aid_diary/pages/share_page.dart';
import 'package:aid_diary/providers/entries_provider.dart';
import 'package:aid_diary/providers/entry_images_provider.dart';
import 'package:aid_diary/services/coach_service.dart';
import 'package:aid_diary/services/home_widget_service.dart';
import 'package:aid_diary/time_manager.dart';
import 'package:aid_diary/utils/entry_navigation.dart';
import 'package:aid_diary/widgets/coach_widgets.dart';
import 'package:aid_diary/widgets/journal_entry_row.dart';
import 'package:aid_diary/widgets/list_detail_layout.dart';
import 'package:aid_diary/widgets/top_search_card.dart';
import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';
import 'package:share_receiver/share_receiver.dart';

/// Stories, then every entry grouped by day. It is the first page, so it
/// also handles launch intents, notifications and shares.
class JournalPage extends StatefulWidget {
  const JournalPage({super.key});

  @override
  State<JournalPage> createState() => _JournalPageState();
}

class _JournalPageState extends State<JournalPage>
    with AutomaticKeepAliveClientMixin {
  int? _selectedId;
  StreamSubscription<SharePayload>? _shareSubscription;
  StreamSubscription<Uri?>? _widgetTapSubscription;
  StreamSubscription<void>? _newEntryTapSubscription;
  Timer? _homeWidgetTimer;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _checkForLaunchIntent();
    _checkForNotificationLaunch();
    if (Platform.isAndroid) {
      _shareSubscription = ShareReceiver.instance.shares.listen(_handleShare);
      _newEntryTapSubscription = NotificationManager
          .instance.newEntryTaps.stream
          .listen((_) => _writeNew());
    }
    if (HomeWidgetService.supported) {
      EntriesProvider.instance.addListener(_pushHomeWidget);
      EntryImagesProvider.instance.addListener(_pushHomeWidget);
      WidgetsBinding.instance.addPostFrameCallback((_) => _pushHomeWidget());
      _widgetTapSubscription = HomeWidgetService.taps.listen((uri) {
        if (!mounted) return;
        if (HomeWidgetService.isWrite(uri)) _writeToday();
        if (HomeWidgetService.isNewEntry(uri)) _writeNew();
        if (HomeWidgetService.entryOf(uri) case final id?) _showEntry(id);
      });
    }
  }

  @override
  void dispose() {
    _shareSubscription?.cancel();
    _widgetTapSubscription?.cancel();
    _newEntryTapSubscription?.cancel();
    _homeWidgetTimer?.cancel();
    EntriesProvider.instance.removeListener(_pushHomeWidget);
    EntryImagesProvider.instance.removeListener(_pushHomeWidget);
    super.dispose();
  }

  /// Coalesces bursts of changes, such as autosaves while typing.
  void _pushHomeWidget() {
    _homeWidgetTimer?.cancel();
    _homeWidgetTimer = Timer(const Duration(seconds: 1), () {
      if (!mounted) return;
      final l10n = AppLocalizations.of(context)!;
      final entries = EntriesProvider.instance.entries;
      HomeWidgetService.push(HomeWidgetSnapshot.from(entries, l10n));
      HomeWidgetService.pushPhotos(
          photoCandidates(entries, EntryImagesProvider.instance.getForEntry,
              AppConfig.instance.photoWidgetCandidates),
          (entry) => TimeManager.formatDateWithWeekday(entry.day, context),
          l10n.photoWidgetEmpty);
    });
  }

  Future<void> _showEntry(int id) async {
    final entry =
        EntriesProvider.instance.entries.where((e) => e.id == id).firstOrNull;
    if (entry == null) return;
    Navigator.of(context).popUntil((route) => route.isFirst);
    await EntryNavigation.view(context, entry);
  }

  Future<void> _writeNew() async {
    if (!mounted) return;
    Navigator.of(context).popUntil((route) => route.isFirst);
    await EntryNavigation.edit(context, null);
  }

  Future<void> _writeToday() async {
    Navigator.of(context).popUntil((route) => route.isFirst);
    await EntryNavigation.edit(
        context, EntriesProvider.instance.getEntryForToday());
  }

  Future<void> _checkForLaunchIntent() async {
    final intent = DeviceInfoService().launchIntent;
    if (intent == null) return;
    DeviceInfoService().launchIntent = null;
    if (intent is OpenEntryIntent) return _showEntry(intent.id);
    if (intent is NewEntryIntent) return _writeNew();
    final today = EntriesProvider.instance.getEntryForToday();
    await EntryNavigation.edit(context, today,
        openCamera: intent is TakePhotoIntent);
  }

  Future<void> _handleShare(SharePayload payload) async {
    if (!mounted) return;
    Navigator.of(context).popUntil((route) => route.isFirst);
    // SharePage turns into the editor, which is full screen.
    await Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(
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
      final referenceDate = DateTime.tryParse(payload) ?? DiaryDay.today();
      await NotificationManager.instance.dismissOnThisDayNotification();
      if (mounted) await EntryNavigation.onThisDay(context, referenceDate);
    } else if (notifId == quickWriteNotificationId ||
        notifId == nudgeNotificationId) {
      await EntryNavigation.edit(context, null);
    } else if (notifId == 0) {
      final targetDate = DateTime.tryParse(payload) ?? DateTime.now();
      await EntryNavigation.edit(
          context, EntriesProvider.instance.getEntryForDate(targetDate),
          diaryDay: DiaryDay.forNewEntry(targetDate));
    }
  }

  String get _sort => ConfigProvider.instance.get(Settings.journalSort);

  List<Entry> _ordered() {
    final entries = EntriesProvider.instance.entries;
    return switch (_sort) {
      'oldest' => entries.reversed.toList(),
      'updated' => List.of(entries)
        ..sort((a, b) => b.timeModified.compareTo(a.timeModified)),
      _ => entries,
    };
  }

  void _open(Entry entry, bool split) {
    if (split) {
      setState(() => _selectedId = entry.id);
    } else {
      EntryNavigation.view(context, entry, entries: _ordered);
    }
  }

  Widget? _detail(List<Entry> ordered) {
    final index = ordered.indexWhere((e) => e.id == _selectedId);
    if (index < 0) return null;
    return EntryViewPage(
      key: ValueKey('journal-detail-$_selectedId'),
      entryId: _selectedId!,
      embedded: true,
      onPrevious: index > 0
          ? () => setState(() => _selectedId = ordered[index - 1].id)
          : null,
      onNext: index < ordered.length - 1
          ? () => setState(() => _selectedId = ordered[index + 1].id)
          : null,
      onEntryEdited: (id) => setState(() => _selectedId = id),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final l10n = AppLocalizations.of(context)!;
    final config = context.watch<ConfigProvider>();
    context.watch<EntriesProvider>();
    final images = context.watch<EntryImagesProvider>();
    final ordered = _ordered();
    final groups = groupEntriesByDay(ordered,
        timeOf: _sort == 'updated' ? (e) => e.timeModified : null);
    final hideImages = config.get(Settings.hideImagesInGallery);

    return ListDetailLayout(
      detail: _detail(ordered),
      listBuilder: (context, split) => CustomScrollView(
        key: const PageStorageKey('journal-list'),
        slivers: [
          const SliverPadding(
            padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
            sliver: SliverToBoxAdapter(child: TopSearchCard()),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverToBoxAdapter(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SectionLabel(l10n.journalStories),
                    _Stories(
                        flashbacks: config.get(Settings.showFlashbacks)
                            ? FlashbackManager.getFlashbacks(
                                context, EntriesProvider.instance.entries)
                            : const []),
                    const SizedBox(height: 12),
                    SectionLabel(l10n.journalEntries,
                        trailing: PopupMenuButton<String>(
                          key: const ValueKey('journal-sort'),
                          tooltip: l10n.journalSortTitle,
                          icon: Icon(switch (_sort) {
                            'oldest' => Icons.arrow_upward_rounded,
                            'updated' => Icons.update_rounded,
                            _ => Icons.arrow_downward_rounded,
                          }),
                          initialValue: _sort,
                          onSelected: (value) =>
                              config.set(Settings.journalSort, value),
                          itemBuilder: (context) => [
                            for (final (value, label) in [
                              ('newest', l10n.sortOrderDescendingTitle),
                              ('oldest', l10n.sortOrderAscendingTitle),
                              ('updated', l10n.journalSortUpdated),
                            ])
                              PopupMenuItem(
                                  key: ValueKey('journal-sort-$value'),
                                  value: value,
                                  child: Text(label)),
                          ],
                        )),
                  ]),
            ),
          ),
          if (groups.isEmpty)
            SliverToBoxAdapter(
              child: EmptyState(
                  icon: Icons.bookmark_border_rounded,
                  title: l10n.noLogs,
                  hint: l10n.journalEmptyHint),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 96),
              sliver: SliverList.builder(
                itemCount: groups.length,
                itemBuilder: (context, index) {
                  final (day, dayEntries) = groups[index];
                  return EntryDayGroup(day: day, rows: [
                    for (final entry in dayEntries)
                      JournalEntryRow(
                        entry: entry,
                        images: images.getForEntry(entry),
                        hideImage: hideImages,
                        selected: split && entry.id == _selectedId,
                        onTap: () => _open(entry, split),
                      ),
                  ]);
                },
              ),
            ),
        ],
      ),
    );
  }
}

class _Stories extends StatelessWidget {
  const _Stories({required this.flashbacks});
  final List<Flashback> flashbacks;

  /// The morning or evening template to suggest now, with its card title.
  static (BuiltinTemplate, String)? _routine(BuildContext context) {
    if (!ConfigProvider.instance.get(Settings.routinePrompts)) return null;
    final l10n = AppLocalizations.of(context)!;
    final config = AppConfig.instance;
    final hour = DateTime.now().hour;
    if (hour < config.morningEndsHour) {
      return (BuiltinTemplate.byId(l10n, 'morning'), l10n.routineMorning);
    }
    if (hour >= config.eveningStartsHour) {
      return (BuiltinTemplate.byId(l10n, 'evening'), l10n.routineEvening);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final cs = Theme.of(context).colorScheme;
    final now = DiaryDay.today();
    final flashback = flashbacks.firstOrNull;
    // Two cards fit side by side on a phone; wider panes keep a fixed width.
    final cardWidth =
        ((MediaQuery.sizeOf(context).width - 32 - 8) / 2).clamp(120.0, 200.0);
    return SizedBox(
      height: 128,
      child: ListView(
          key: const ValueKey('journal-stories'),
          scrollDirection: Axis.horizontal,
          children: [
            _StoryCard(
              key: const ValueKey('story-today'),
              width: cardWidth,
              icon: Icons.bookmark_rounded,
              title: l10n.storyToday,
              subtitle: TimeManager.formatDate(now, context),
              background: cs.tertiaryContainer,
              foreground: cs.onTertiaryContainer,
              onTap: () => TodayStory.open(context),
            ),
            if (CoachService.current(l10n) case final enrollment?) ...[
              const SizedBox(width: 8),
              _StoryCard(
                key: const ValueKey('story-coach'),
                width: cardWidth,
                icon: Icons.flag_outlined,
                title: enrollment.program
                    .stepLabel(l10n, enrollment.schedule.stepOn(now)),
                subtitle: enrollment.program.title,
                background: cs.primaryContainer,
                foreground: Colors.white,
                backdrop: ProgramCover(
                    program: enrollment.program, iconSize: 56, radius: 0),
                onTap: () => TodayStory.open(context, from: TodayStory.coach),
              ),
            ],
            for (final capsule in EntriesProvider.instance.entries.where((e) =>
                e.openAt != null &&
                !e.isSealed &&
                now.difference(e.openAt!) < const Duration(days: 7))) ...[
              const SizedBox(width: 8),
              _StoryCard(
                key: ValueKey('story-capsule-${capsule.id}'),
                width: cardWidth,
                icon: Icons.lock_open_rounded,
                title: l10n.capsuleOpened,
                subtitle: l10n.capsuleWrittenOn(
                    TimeManager.formatDate(capsule.day, context)),
                background: cs.secondaryContainer,
                foreground: cs.onSecondaryContainer,
                onTap: () => EntryNavigation.view(context, capsule),
              ),
            ],
            const SizedBox(width: 8),
            _StoryCard(
              key: const ValueKey('story-throwback'),
              width: cardWidth,
              icon: Icons.history_rounded,
              title: l10n.storyThrowback,
              subtitle: flashback?.title ?? l10n.storyNoThrowback,
              background: cs.surfaceContainerHighest,
              foreground: cs.onSurfaceVariant,
              onTap: flashback == null
                  ? null
                  : () => TodayStory.open(context, from: TodayStory.throwback),
            ),
            if (_routine(context) case (final template, final title)) ...[
              const SizedBox(width: 8),
              _StoryCard(
                key: const ValueKey('story-routine'),
                width: cardWidth,
                icon: now.hour < 12
                    ? Icons.wb_twilight_rounded
                    : Icons.nights_stay_rounded,
                title: title,
                subtitle: template.description,
                background: cs.secondaryContainer,
                foreground: cs.onSecondaryContainer,
                onTap: () => EntryNavigation.edit(context, null,
                    template: template.toTemplate()),
              ),
            ],
            const SizedBox(width: 8),
            _StoryCard(
              key: const ValueKey('story-check-in'),
              width: cardWidth,
              icon: Icons.add_reaction_outlined,
              title: l10n.checkInTitle,
              subtitle: l10n.checkInSubtitle,
              background: cs.secondaryContainer,
              foreground: cs.onSecondaryContainer,
              onTap: () => showQuickCheckIn(context),
            ),
            for (final (key, icon, title, subtitle, onTap) in [
              (
                'story-random',
                Icons.shuffle_rounded,
                l10n.randomTitle,
                l10n.randomSubtitle,
                () => RandomReviewPage.open(context),
              ),
              (
                'story-week',
                Icons.date_range_rounded,
                l10n.reviewWeekTitle,
                l10n.reviewWeekSubtitle,
                () => ReviewStoryPage.open(context, ReviewSpan.week),
              ),
              (
                'story-year',
                Icons.calendar_month_rounded,
                l10n.reviewYearTitle,
                '${now.year}',
                () => ReviewStoryPage.open(context, ReviewSpan.year),
              ),
            ]) ...[
              const SizedBox(width: 8),
              _StoryCard(
                key: ValueKey(key),
                width: cardWidth,
                icon: icon,
                title: title,
                subtitle: subtitle,
                background: cs.primaryContainer,
                foreground: cs.onPrimaryContainer,
                onTap: onTap,
              ),
            ],
            for (final extra in flashbacks.skip(1)) ...[
              const SizedBox(width: 8),
              _StoryCard(
                width: cardWidth,
                icon: Icons.auto_awesome_rounded,
                title: extra.title,
                subtitle: TimeManager.formatDate(extra.firstEntry.day, context),
                background: cs.secondaryContainer,
                foreground: cs.onSecondaryContainer,
                onTap: () => EntryNavigation.flashback(context, extra),
              ),
            ],
          ]),
    );
  }
}

class _StoryCard extends StatelessWidget {
  const _StoryCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.background,
    required this.foreground,
    required this.width,
    this.backdrop,
    this.onTap,
  });

  final double width;

  /// Art behind the text, darkened at the bottom so the text reads.
  final Widget? backdrop;
  final IconData icon;
  final String title;
  final String subtitle;
  final Color background;
  final Color foreground;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      width: width,
      child: Material(
        color: background,
        borderRadius: BorderRadius.circular(12),
        clipBehavior: Clip.antiAlias,
        child: Stack(fit: StackFit.expand, children: [
          if (backdrop != null) ...[
            backdrop!,
            const DecoratedBox(
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.transparent, Colors.black54]))),
          ],
          // Its own Material, so the ripple paints over the backdrop.
          Material(
            type: MaterialType.transparency,
            child: InkWell(
              onTap: onTap,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Icon(icon, size: 18, color: foreground),
                    const SizedBox(height: 8),
                    Text(title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.titleSmall?.copyWith(
                            color: foreground, fontWeight: FontWeight.w700)),
                    Text(subtitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.labelMedium?.copyWith(
                            color: foreground.withValues(alpha: .8))),
                  ],
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
