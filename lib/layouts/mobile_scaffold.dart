// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'dart:io';
import 'package:daily_you/config_provider.dart';
import 'package:daily_you/layouts/adaptive_diary_shell.dart';
import 'package:daily_you/layouts/fast_page_view_scroll_physics.dart';
import 'package:daily_you/pages/settings/notification_settings.dart';
import 'package:daily_you/l10n/generated/app_localizations.dart';
import 'package:daily_you/pages/statistics_page.dart';
import 'package:daily_you/pages/gallery_page.dart';
import 'package:daily_you/pages/calendar_page.dart';
import 'package:daily_you/pages/today_page.dart';
import 'package:daily_you/pages/settings_page.dart';
import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';

class MobileScaffold extends StatefulWidget {
  const MobileScaffold({super.key});
  @override
  State<MobileScaffold> createState() => _MobileScaffoldState();
}

class _MobileScaffoldState extends State<MobileScaffold> {
  int currentIndex = 0;
  final _navigatorKey = GlobalKey<NavigatorState>();
  final _pageController = PageController();
  late final pages = [
    TodayPage(onOpenJournal: () => _switchPage(1)),
    const GalleryPage(),
    const CalendarPage(),
    const StatsPage()
  ];
  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _switchPage(int index) {
    FocusManager.instance.primaryFocus?.unfocus();
    setState(() => currentIndex = index);
    if (_pageController.hasClients) _pageController.jumpToPage(index);
  }

  void _navigateToSettings() {
    _navigatorKey.currentState?.push(MaterialPageRoute<void>(
        settings: const RouteSettings(name: 'settings'),
        allowSnapshotting: false,
        builder: (_) => const SettingsPage()));
  }

  bool _shouldShowNotificationButton(ConfigProvider config) =>
      Platform.isAndroid &&
      !config.get(Settings.dailyReminders) &&
      !config.get(Settings.onThisDayNotifications) &&
      !config.get(Settings.dismissedNotificationOnboarding);

  void _showNotificationOnboardingPopup() {
    showDialog<void>(
        context: _navigatorKey.currentContext!,
        builder: (context) {
          final config = context.watch<ConfigProvider>();
          final l10n = AppLocalizations.of(context)!;
          return AlertDialog(
              actions: [
                TextButton(
                    onPressed: () async {
                      await config.set(
                          Settings.dismissedNotificationOnboarding, true);
                      if (context.mounted) Navigator.of(context).pop();
                    },
                    child: Text(
                        MaterialLocalizations.of(context).closeButtonLabel))
              ],
              content: SingleChildScrollView(
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                const Icon(Icons.notifications_on_rounded, size: 40),
                const SizedBox(height: 12),
                Text(l10n.settingsDailyReminderOnboarding),
                const SizedBox(height: 8),
                Text(l10n.settingsNotificationsPermissionsPrompt),
                const Divider(),
                ...NotificationSettings.buildCoreReminderSettings(context),
                const Divider(),
                ...NotificationSettings.buildOnThisDaySettings(context)
              ])));
        });
  }

  @override
  Widget build(BuildContext context) {
    final config = context.watch<ConfigProvider>();
    final l10n = AppLocalizations.of(context)!;
    final titles = [
      l10n.pageTodayTitle,
      l10n.pageJournalTitle,
      l10n.pageCalendarTitle,
      l10n.pageStatisticsTitle
    ];
    return AdaptiveDiaryShell(
        navigatorKey: _navigatorKey,
        title: l10n.appTitle,
        selectedIndex: currentIndex,
        destinations: [
          DiaryDestination(titles[0], Icons.wb_sunny_rounded),
          DiaryDestination(titles[1], Icons.auto_stories_rounded),
          DiaryDestination(titles[2], Icons.calendar_month_rounded),
          DiaryDestination(titles[3], Icons.insights_rounded)
        ],
        onDestinationSelected: _switchPage,
        settingsLabel: l10n.pageSettingsTitle,
        onSettings: _navigateToSettings,
        home: Builder(builder: (context) {
          final compact = MediaQuery.sizeOf(context).width < 600;
          // Today carries its own greeting header; wide windows need no
          // bar above it unless an action has to be shown.
          final showAppBar = currentIndex != 0 ||
              compact ||
              _shouldShowNotificationButton(config);
          return Scaffold(
              appBar: !showAppBar
                  ? null
                  : AppBar(
                      automaticallyImplyLeading: false,
                      title:
                          currentIndex == 0 ? null : Text(titles[currentIndex]),
                      actions: [
                          if (_shouldShowNotificationButton(config))
                            IconButton(
                                icon:
                                    const Icon(Icons.notifications_off_rounded),
                                onPressed: _showNotificationOnboardingPopup),
                          if (compact)
                            IconButton(
                                key: const ValueKey('diary-settings'),
                                tooltip: l10n.pageSettingsTitle,
                                icon: const Icon(Icons.settings_rounded),
                                onPressed: _navigateToSettings)
                        ]),
              body: PageView(
                  controller: _pageController,
                  physics: compact
                      ? const FastPageViewScrollPhysics()
                      : const NeverScrollableScrollPhysics(),
                  onPageChanged: (index) {
                    FocusManager.instance.primaryFocus?.unfocus();
                    if (index != currentIndex) {
                      setState(() => currentIndex = index);
                    }
                  },
                  children: pages));
        }));
  }
}
