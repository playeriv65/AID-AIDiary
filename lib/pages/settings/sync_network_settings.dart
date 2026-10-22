// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'dart:async';

import 'package:aid_diary/actions/app_actions.dart';
import 'package:aid_diary/l10n/generated/app_localizations.dart';
import 'package:aid_diary/sync/network_diagnostics.dart';
import 'package:aid_diary/sync/sync_service.dart';
import 'package:aid_diary/widgets/cloud_traffic_notice.dart';
import 'package:material_ui/material_ui.dart';

/// Operational details and retention receipts, separate from everyday sync state.
class SyncNetworkSettings extends StatefulWidget {
  const SyncNetworkSettings({super.key, this.load});
  final Future<Map<Object?, Object?>> Function()? load;

  @override
  State<SyncNetworkSettings> createState() => _SyncNetworkSettingsState();
}

class _SyncNetworkSettingsState extends State<SyncNetworkSettings> {
  SyncNetworkDiagnostics? _data;
  bool _loading = false;
  bool _again = false;
  bool _failed = false;

  @override
  void initState() {
    super.initState();
    SyncService.instance.addListener(_changed);
    unawaited(_refresh());
  }

  void _changed() => unawaited(_refresh());

  Future<void> _refresh() async {
    if (_loading) {
      _again = true;
      return;
    }
    setState(() => _loading = true);
    try {
      final json = widget.load != null
          ? await widget.load!()
          : (await AppActions.instance.run('sync.network', {})) as Map;
      if (mounted) {
        setState(() {
          _data = SyncNetworkDiagnostics.fromJson(json);
          _failed = false;
        });
      }
    } catch (_) {
      // Exception strings can contain storage URLs or account details.
      if (mounted) setState(() => _failed = true);
    } finally {
      if (mounted) {
        setState(() => _loading = false);
        if (_again) {
          _again = false;
          unawaited(_refresh());
        }
      }
    }
  }

  @override
  void dispose() {
    SyncService.instance.removeListener(_changed);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final data = _data;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.syncNetworkTitle), actions: [
        IconButton(
            key: const ValueKey('sync-network-refresh'),
            tooltip: l10n.syncNetworkRefresh,
            onPressed: _loading ? null : () => unawaited(_refresh()),
            icon: const Icon(Icons.refresh_rounded)),
      ]),
      body: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 840),
            child: ListView(padding: const EdgeInsets.all(16), children: [
              const CloudTrafficNotice(
                  key: ValueKey('sync-network-cloud-traffic')),
              if (_loading) const LinearProgressIndicator(),
              if (_failed)
                ListTile(
                    key: const ValueKey('sync-network-error'),
                    leading: const Icon(Icons.info_outline_rounded),
                    title: Text(l10n.syncNetworkUnavailable)),
              if (data != null) ...[
                ListTile(
                    title: Text(l10n.syncNetworkSelectedRoute),
                    trailing: Text(data.route ?? l10n.syncNetworkNoRoute,
                        key: const ValueKey('sync-network-route'))),
                ListTile(
                    title: Text(l10n.syncNetworkAvailableRoutes),
                    subtitle: Text(data.routes.isEmpty
                        ? l10n.syncNetworkNoRoute
                        : data.routes.join(' · '))),
                ListTile(
                    title: Text(l10n.syncNetworkSignaling),
                    trailing:
                        Text(data.signaling ?? l10n.syncNetworkUnavailable)),
                ListTile(
                    title: Text(l10n.syncNetworkRelayRemaining),
                    trailing: Text('${data.relayRemaining} B')),
                for (final (index, peer) in data.peers.indexed) ...[
                  ListTile(
                      title:
                          Text('${l10n.syncNetworkPeerTrusted} ${index + 1}'),
                      trailing: Icon(peer.trusted
                          ? Icons.verified_user_rounded
                          : Icons.shield_outlined)),
                  ListTile(
                      title: Text(l10n.syncNetworkIcePair),
                      subtitle: Text(peer.localType == null ||
                              peer.remoteType == null
                          ? l10n.syncNetworkUnavailable
                          : '${peer.localType} → ${peer.remoteType}${peer.protocol == null ? '' : ' · ${peer.protocol}'}')),
                ],
                const Divider(),
                Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Text(l10n.syncMediaCopiesTitle,
                        style: Theme.of(context).textTheme.titleLarge)),
                ListTile(
                    key: const ValueKey('sync-media-pending-count'),
                    title: Text(l10n.syncMediaPendingCount),
                    trailing: Text('${data.pending}')),
                ListTile(
                    key: const ValueKey('sync-media-durable-count'),
                    title: Text(l10n.syncMediaDurableCount),
                    trailing: Text('${data.durableReceipts}')),
                ListTile(
                    key: const ValueKey('sync-media-temporary-count'),
                    title: Text(l10n.syncMediaTemporaryCount),
                    trailing: Text('${data.temporaryReceipts}')),
                Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Text(l10n.syncMediaReceiptExplanation)),
                Text(l10n.syncMediaCacheExplanation),
              ],
            ]),
          )),
    );
  }
}
