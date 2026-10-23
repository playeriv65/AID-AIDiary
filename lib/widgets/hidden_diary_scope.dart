// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'package:aid_diary/l10n/generated/app_localizations.dart';
import 'package:aid_diary/database/entry_store.dart';
import 'package:aid_diary/models/entry.dart';
import 'package:material_ui/material_ui.dart';

/// A local, short-lived authorization; never exposed to actions or settings.
class HiddenDiarySession extends ChangeNotifier with WidgetsBindingObserver {
  HiddenDiarySession() {
    WidgetsBinding.instance.addObserver(this);
  }

  bool _unlocked = false;
  bool get unlocked => _unlocked;

  void unlock() {
    _unlocked = true;
    notifyListeners();
  }

  void lock() {
    _unlocked = false;
    notifyListeners();
  }

  void _requireAccess(Entry entry) {
    if (!_unlocked || !entry.isHidden) {
      throw StateError('This operation requires an unlocked hidden diary.');
    }
  }

  Future<void> unhide(Entry entry) async {
    _requireAccess(entry);
    await EntryStore.instance.setHidden(entry, false);
  }

  Future<void> delete(Entry entry) async {
    _requireAccess(entry);
    await EntryStore.instance.delete(entry);
  }

  Future<void> restore(Entry entry) async {
    _requireAccess(entry);
    await EntryStore.instance.restore(entry);
  }

  Future<void> unseal(Entry entry) async {
    _requireAccess(entry);
    await EntryStore.instance.setOpenAt(entry, null);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state != AppLifecycleState.resumed) lock();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}

/// Propagates the protected section across its reader, editor and media routes.
class HiddenDiaryScope extends InheritedNotifier<HiddenDiarySession> {
  const HiddenDiaryScope({
    super.key,
    required HiddenDiarySession session,
    required super.child,
  }) : super(notifier: session);

  static HiddenDiarySession? of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<HiddenDiaryScope>()?.notifier;

  static WidgetBuilder protectRoute(BuildContext context, WidgetBuilder page) {
    final session =
        context.getInheritedWidgetOfExactType<HiddenDiaryScope>()?.notifier;
    return (routeContext) {
      final child = page(routeContext);
      return session == null
          ? child
          : HiddenDiaryGuard(session: session, child: child);
    };
  }
}

class HiddenDiaryGuard extends StatelessWidget {
  const HiddenDiaryGuard({
    super.key,
    required this.session,
    required this.child,
  });

  final HiddenDiarySession session;
  final Widget child;

  @override
  Widget build(BuildContext context) => ListenableBuilder(
        listenable: session,
        builder: (context, _) => HiddenDiaryScope(
          session: session,
          child: session.unlocked
              ? child
              : Scaffold(
                  appBar: AppBar(
                      title:
                          Text(AppLocalizations.of(context)!.hiddenDiaryTitle)),
                  body: const Center(child: Icon(Icons.lock_outline)),
                ),
        ),
      );
}
