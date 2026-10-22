// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'dart:io';

import 'package:aid_diary/actions/app_action.dart';
import 'package:aid_diary/actions/app_actions.dart';
import 'package:aid_diary/l10n/generated/app_localizations.dart';
import 'package:aid_diary/sync/pairing.dart';
import 'package:aid_diary/sync/sync_service.dart';
import 'package:aid_diary/widgets/haptics.dart';
import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:qr_flutter/qr_flutter.dart';

/// Pairs this device with another of the user's, the same on both: either
/// shows a code and the other types or scans it, and the master key goes
/// from whichever holds it (sync/pairing.dart).
class PairingDialog extends StatefulWidget {
  const PairingDialog({super.key});

  @override
  State<PairingDialog> createState() => _PairingDialogState();
}

class _PairingDialogState extends State<PairingDialog> {
  final _service = SyncService.instance;
  final _code = TextEditingController();
  var _showing = true;

  /// Whether this dialog's own pairing runs, so others' left over in the
  /// service do not show.
  var _started = false;
  var _accepting = false;
  String? _problem;

  /// Only phones and tablets have a camera to scan with.
  static final bool _canScan = Platform.isAndroid || Platform.isIOS;

  @override
  void initState() {
    super.initState();
    _offer();
  }

  @override
  void dispose() {
    if (_service.pairing?.stage == PairingStage.waiting) {
      AppActions.instance.run('sync.pair_cancel', {});
    }
    _code.dispose();
    super.dispose();
  }

  Future<void> _offer() async {
    setState(() {
      _started = true;
      _problem = null;
    });
    try {
      await AppActions.instance.run('sync.pair_offer', {});
    } on ActionException catch (e) {
      if (mounted) setState(() => _problem = e.message);
    }
  }

  Future<void> _accept(String code) async {
    if (code.trim().isEmpty) return;
    AppActions.instance.run('sync.pair_cancel', {});
    setState(() {
      _started = true;
      _accepting = true;
      _problem = null;
    });
    try {
      await AppActions.instance.run('sync.pair_accept', {'code': code});
      Haptics.success();
    } on ActionException catch (e) {
      Haptics.error();
      // Failures of the pairing itself show from its status.
      if (e.code != 'pairing_failed' && mounted) {
        setState(() => _problem = e.message);
      }
    } finally {
      if (mounted) setState(() => _accepting = false);
    }
  }

  Future<void> _scan() async {
    final scanned = await showDialog<String>(
        context: context, builder: (_) => const _ScanDialog());
    if (scanned == null || !mounted) return;
    _code.text = scanned;
    await _accept(scanned);
  }

  void _switch(bool showing) {
    if (showing == _showing) return;
    setState(() {
      _showing = showing;
      _problem = null;
    });
    if (showing) {
      _offer();
    } else {
      AppActions.instance.run('sync.pair_cancel', {});
    }
  }

  String _failure(PairingStatus status, AppLocalizations l10n) =>
      switch (status.failure) {
        PairingFailure.wrongCode => l10n.syncPairWrongCode,
        PairingFailure.noOffer => l10n.syncPairNoOffer,
        PairingFailure.timedOut => l10n.syncPairTimedOut,
        PairingFailure.neitherHoldsKey => l10n.syncPairNeither,
        PairingFailure.bothHoldKey => l10n.syncPairBoth,
        PairingFailure.cancelled => '',
        null => l10n.syncPairFailed('${status.error}'),
      };

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    return AlertDialog(
      title: Text(l10n.syncPairTitle),
      content: SizedBox(
        width: 360,
        child: ListenableBuilder(
          listenable: _service,
          builder: (context, _) {
            final status = _started ? _service.pairing : null;
            final paired = status?.stage == PairingStage.paired;
            return SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (!paired)
                    SegmentedButton<bool>(
                      segments: [
                        ButtonSegment(
                            value: true,
                            icon: const Icon(Icons.qr_code_rounded),
                            label: Text(l10n.syncPairShow)),
                        ButtonSegment(
                            value: false,
                            icon: const Icon(Icons.keyboard_rounded),
                            label: Text(l10n.syncPairEnter)),
                      ],
                      selected: {_showing},
                      onSelectionChanged: (choice) => _switch(choice.single),
                    ),
                  const SizedBox(height: 16),
                  if (paired)
                    ListTile(
                      key: const ValueKey('pairing-done'),
                      contentPadding: EdgeInsets.zero,
                      leading: Icon(Icons.check_circle_rounded,
                          color: theme.colorScheme.primary),
                      title: Text(l10n.syncPairDone(status!.otherDevice ?? '')),
                    )
                  else if (_showing)
                    ..._shownCode(status, l10n, theme)
                  else
                    ..._enterCode(l10n),
                  if (status?.stage == PairingStage.failed &&
                      status!.failure != PairingFailure.cancelled)
                    _message(_failure(status, l10n), theme),
                  if (_problem case final problem?) _message(problem, theme),
                ],
              ),
            );
          },
        ),
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(MaterialLocalizations.of(context).closeButtonLabel)),
      ],
    );
  }

  Widget _message(String text, ThemeData theme) => Padding(
        padding: const EdgeInsets.only(top: 12),
        child: Text(text,
            key: const ValueKey('pairing-problem'),
            style: TextStyle(color: theme.colorScheme.error)),
      );

  List<Widget> _shownCode(
      PairingStatus? status, AppLocalizations l10n, ThemeData theme) {
    final code = status?.code;
    final waiting = status?.stage == PairingStage.waiting;
    return [
      Text(l10n.syncPairShowHint),
      const SizedBox(height: 16),
      if (code != null && waiting) ...[
        Center(
          child: Container(
            color: Colors.white,
            padding: const EdgeInsets.all(8),
            child: QrImageView(data: code.scannable, size: 200),
          ),
        ),
        const SizedBox(height: 12),
        Center(
          child: SelectableText(code.typed,
              key: const ValueKey('pairing-code'),
              style: theme.textTheme.headlineMedium?.copyWith(
                  fontFeatures: const [FontFeature.tabularFigures()],
                  letterSpacing: 4)),
        ),
        const SizedBox(height: 12),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          const SizedBox.square(
              dimension: 16, child: CircularProgressIndicator(strokeWidth: 2)),
          const SizedBox(width: 12),
          Text(l10n.syncPairWaiting),
        ]),
      ] else if (status?.stage == PairingStage.failed || _problem != null)
        Align(
          child: FilledButton.tonal(
              key: const ValueKey('pairing-new-code'),
              onPressed: _offer,
              child: Text(l10n.syncPairShow)),
        )
      else
        const Center(child: CircularProgressIndicator()),
    ];
  }

  List<Widget> _enterCode(AppLocalizations l10n) => [
        Text(l10n.syncPairEnterHint),
        const SizedBox(height: 16),
        TextField(
          key: const ValueKey('pairing-enter'),
          controller: _code,
          enabled: !_accepting,
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[\d\s-]')),
          ],
          decoration: InputDecoration(
              labelText: l10n.syncPairCode, border: const OutlineInputBorder()),
          onSubmitted: _accept,
        ),
        const SizedBox(height: 12),
        Row(children: [
          if (_canScan)
            TextButton.icon(
                key: const ValueKey('pairing-scan'),
                icon: const Icon(Icons.qr_code_scanner_rounded),
                label: Text(l10n.syncPairScan),
                onPressed: _accepting ? null : _scan),
          const Spacer(),
          if (_accepting)
            const SizedBox.square(
                dimension: 24,
                child: CircularProgressIndicator(strokeWidth: 2.5))
          else
            FilledButton(
                key: const ValueKey('pairing-accept'),
                onPressed: () => _accept(_code.text),
                child: Text(l10n.syncPairStart)),
        ]),
      ];
}

/// The camera, until it sees a pairing code.
class _ScanDialog extends StatefulWidget {
  const _ScanDialog();

  @override
  State<_ScanDialog> createState() => _ScanDialogState();
}

class _ScanDialogState extends State<_ScanDialog> {
  var _done = false;

  @override
  Widget build(BuildContext context) {
    return Dialog.fullscreen(
      child: Stack(children: [
        MobileScanner(
          onDetect: (capture) {
            final value = capture.barcodes.firstOrNull?.rawValue;
            if (_done || value == null || !PairingCode.isScanned(value)) {
              return;
            }
            _done = true;
            Navigator.of(context).pop(value);
          },
        ),
        SafeArea(
          child: IconButton.filledTonal(
            tooltip: MaterialLocalizations.of(context).closeButtonTooltip,
            icon: const Icon(Icons.close_rounded),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
      ]),
    );
  }
}
