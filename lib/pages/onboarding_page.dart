// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'package:aid_diary/actions/app_actions.dart';
import 'package:aid_diary/l10n/generated/app_localizations.dart';
import 'package:aid_diary/pages/tutorial_page.dart';
import 'package:aid_diary/routing/destinations.dart';
import 'package:aid_diary/sync/nearby_service.dart';
import 'package:aid_diary/widgets/app_logo.dart';
import 'package:material_ui/material_ui.dart';

/// First launch chooses a new diary or the existing nearby migration flow.
class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key, required this.next});
  final Widget next;

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  bool _tutorial = false;
  bool _finishing = false;
  bool _receiving = false;
  bool get _busy => _finishing || _receiving;

  void _failed() {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(AppLocalizations.of(context)!.onboardFailed)),
    );
  }

  Future<void> _finish() async {
    if (_finishing) return;
    setState(() => _finishing = true);
    try {
      await AppActions.instance.run('app.finish_onboarding', {});
      if (!mounted) return;
      await Navigator.of(context).pushReplacement(MaterialPageRoute(
          allowSnapshotting: false, builder: (_) => widget.next));
    } catch (_) {
      _failed();
    } finally {
      if (mounted) setState(() => _finishing = false);
    }
  }

  Future<void> _receive() async {
    if (_busy) return;
    setState(() => _receiving = true);
    try {
      await openPlace(context, 'settings/sync/nearby', {'receive': true});
      if (mounted && NearbyService.instance.state == NearbyState.complete) {
        await _finish();
      }
    } catch (_) {
      _failed();
    } finally {
      if (mounted) setState(() => _receiving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    if (_tutorial) {
      void back() {
        if (!_busy) setState(() => _tutorial = false);
      }

      return PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, _) {
          if (!didPop) back();
        },
        child: TutorialPage(onBack: back, onComplete: _finish, busy: _busy),
      );
    }
    final theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                const AppLogo(size: 88),
                const SizedBox(height: 28),
                Text(l10n.onboardWelcomeTitle,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.headlineSmall),
                const SizedBox(height: 12),
                Text(l10n.onboardWelcomeText,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyLarge),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    key: const ValueKey('onboard-new-diary'),
                    onPressed:
                        _busy ? null : () => setState(() => _tutorial = true),
                    icon: const Icon(Icons.edit_note_rounded),
                    label: Padding(
                        padding: const EdgeInsets.all(14),
                        child: Text(l10n.onboardNewDiary)),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    key: const ValueKey('onboard-nearby-receive'),
                    onPressed: _busy ? null : _receive,
                    icon: const Icon(Icons.move_to_inbox_outlined),
                    label: Padding(
                        padding: const EdgeInsets.all(14),
                        child: Text(l10n.onboardConnect)),
                  ),
                ),
              ]),
            ),
          ),
        ),
      ),
    );
  }
}
