// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'dart:io';

import 'package:aid_diary/config_provider.dart';
import 'package:aid_diary/l10n/generated/app_localizations.dart';
import 'package:aid_diary/actions/settings_actions.dart';
import 'package:aid_diary/widgets/app_logo.dart';
import 'package:aid_diary/routing/destinations.dart';
import 'package:material_ui/material_ui.dart';

/// Welcome pages on first launch, like Journey's: welcome, what the diary
/// does, privacy with a passcode, reminders, then done. Opens [next] when
/// finished or skipped.
class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key, required this.next});
  final Widget next;

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final _pages = PageController();
  int _page = 0;
  bool _remindersOn = false;

  static const _count = 5;

  @override
  void dispose() {
    _pages.dispose();
    super.dispose();
  }

  void _go(int page) => _pages.animateToPage(page,
      duration: const Duration(milliseconds: 300), curve: Curves.easeOut);

  Future<void> _finish() async {
    await changeSetting(Settings.onboardingDone, true);
    if (!mounted) return;
    await Navigator.of(context).pushReplacement(MaterialPageRoute(
        allowSnapshotting: false, builder: (_) => widget.next));
  }

  Future<void> _turnOnReminders() async {
    if (!await changeSetting(Settings.dailyReminders, true)) return;
    if (mounted) setState(() => _remindersOn = true);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final last = _page == _count - 1;
    final pages = [
      _OnboardStep(
          icon: const AppLogo(size: 80),
          title: l10n.onboardWelcomeTitle,
          text: l10n.onboardWelcomeText),
      _OnboardStep(
          icon: const Icon(Icons.photo_album_outlined),
          title: l10n.onboardIntroTitle,
          text: l10n.onboardIntroText),
      _OnboardStep(
        icon: const Icon(Icons.lock_outline_rounded),
        title: l10n.onboardPrivateTitle,
        text: l10n.onboardPrivateText,
        action: OutlinedButton.icon(
          key: const ValueKey('onboard-passcode'),
          onPressed: () => openPlace(context, 'settings/security'),
          icon: const Icon(Icons.password_rounded),
          label: Text(l10n.onboardPrivateAction),
        ),
      ),
      _OnboardStep(
        icon: const Icon(Icons.notifications_active_outlined),
        title: l10n.onboardNotifyTitle,
        text: l10n.onboardNotifyText,
        // Notifications exist on Android only.
        action: Platform.isAndroid
            ? (_remindersOn
                ? Chip(
                    avatar: const Icon(Icons.check_rounded),
                    label: Text(l10n.onboardNotifyOn))
                : OutlinedButton.icon(
                    key: const ValueKey('onboard-reminders'),
                    onPressed: _turnOnReminders,
                    icon: const Icon(Icons.notifications_rounded),
                    label: Text(l10n.onboardNotifyAction),
                  ))
            : null,
      ),
      _OnboardStep(
          icon: const Icon(Icons.celebration_rounded),
          title: l10n.onboardDoneTitle,
          text: l10n.onboardDoneText),
    ];
    return Scaffold(
      body: SafeArea(
        child: Column(children: [
          Align(
            alignment: AlignmentDirectional.centerEnd,
            child: Visibility(
              visible: !last,
              maintainSize: true,
              maintainAnimation: true,
              maintainState: true,
              child: TextButton(
                key: const ValueKey('onboard-skip'),
                onPressed: _finish,
                child: Text(l10n.onboardSkip),
              ),
            ),
          ),
          Expanded(
            child: PageView(
              key: const ValueKey('onboard-pages'),
              controller: _pages,
              onPageChanged: (page) => setState(() => _page = page),
              children: pages,
            ),
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            for (var i = 0; i < _count; i++)
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.all(4),
                width: i == _page ? 20 : 8,
                height: 8,
                decoration: BoxDecoration(
                    color: i == _page ? cs.primary : cs.outlineVariant,
                    borderRadius: BorderRadius.circular(4)),
              ),
          ]),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
            child: Row(children: [
              if (_page > 0)
                TextButton(
                  key: const ValueKey('onboard-back'),
                  onPressed: () => _go(_page - 1),
                  child: Text(l10n.onboardBack),
                ),
              const Spacer(),
              FilledButton(
                key: const ValueKey('onboard-next'),
                onPressed: last ? _finish : () => _go(_page + 1),
                child: Text(last ? l10n.onboardStart : l10n.onboardNext),
              ),
            ]),
          ),
        ]),
      ),
    );
  }
}

class _OnboardStep extends StatelessWidget {
  const _OnboardStep(
      {required this.icon,
      required this.title,
      required this.text,
      this.action});
  final Widget icon;
  final String title;
  final String text;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Container(
              width: 160,
              height: 160,
              decoration: BoxDecoration(
                  color: cs.primaryContainer, shape: BoxShape.circle),
              alignment: Alignment.center,
              child: IconTheme(
                  data: IconThemeData(size: 72, color: cs.onPrimaryContainer),
                  child: icon),
            ),
            const SizedBox(height: 32),
            Text(title,
                textAlign: TextAlign.center,
                style: theme.textTheme.headlineSmall
                    ?.copyWith(fontWeight: FontWeight.w700)),
            const SizedBox(height: 12),
            Text(text,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyLarge
                    ?.copyWith(color: cs.onSurfaceVariant)),
            if (action != null) ...[const SizedBox(height: 24), action!],
          ]),
        ),
      ),
    );
  }
}
