import 'package:aid_diary/actions/app_actions.dart';
import 'package:aid_diary/l10n/generated/app_localizations.dart';
import 'package:aid_diary/routing/destinations.dart';
import 'package:aid_diary/time_manager.dart';
import 'package:aid_diary/widgets/cloud_traffic_notice.dart';
import 'package:aid_diary/widgets/device_name_tile.dart';
import 'package:intl/intl.dart';
import 'package:material_ui/material_ui.dart';

/// Location and last-confirmation details are opened deliberately, not shown
/// in the journal or in the ordinary sync status.
class SyncCopySettings extends StatefulWidget {
  const SyncCopySettings({super.key, this.load});
  final Future<Map<Object?, Object?>> Function()? load;
  @override
  State<SyncCopySettings> createState() => _SyncCopySettingsState();
}

class _SyncCopySettingsState extends State<SyncCopySettings> {
  Map<Object?, Object?>? _data;
  bool _failed = false, _loading = false;
  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    if (_loading) return;
    setState(() => _loading = true);
    try {
      final data = widget.load == null
          ? (await AppActions.instance.run('sync.copies', {})) as Map
          : await widget.load!();
      if (mounted) {
        setState(() {
          _data = data;
          _failed = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _failed = true);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Widget _device(Map copy, {bool local = false}) {
    final l10n = AppLocalizations.of(context)!;
    final complete =
        (local || copy['current'] == true) && copy['present'] == copy['total'];
    final at = DateTime.tryParse('${copy['checkedAt']}');
    return ListTile(
        leading:
            Icon(complete ? Icons.check_circle_outline : Icons.sync_rounded),
        title:
            Text('${copy['name']}${local ? ' · ${l10n.syncDeviceLocal}' : ''}'),
        subtitle: Text([
          complete
              ? l10n.syncCopyComplete
              : copy['current'] == false
                  ? l10n.syncCopyOlder
                  : l10n.syncCopyPartial,
          if (!local && at != null)
            l10n.syncCopyChecked(
                DateFormat.yMd(TimeManager.currentLocale(context))
                    .add_Hm()
                    .format(at.toLocal()))
        ].join('\n')));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final data = _data;
    return Scaffold(
        appBar: AppBar(title: Text(l10n.syncDetailsTitle), actions: [
          IconButton(
              key: const ValueKey('sync-copies-refresh'),
              onPressed: _loading ? null : _load,
              tooltip: l10n.syncNetworkRefresh,
              icon: const Icon(Icons.refresh_rounded))
        ]),
        body: Center(
            child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 840),
                child: ListView(children: [
                  if (_loading) const LinearProgressIndicator(),
                  if (_failed) ListTile(title: Text(l10n.syncCopyUnavailable)),
                  if (data?['local'] == null) const DeviceNameTile(),
                  if (data != null) ...[
                    if (data['local'] case final Map local)
                      _device(local, local: true),
                    for (final copy in data['devices'] as List? ?? const [])
                      if (copy is Map) _device(copy),
                    Padding(
                        padding: const EdgeInsets.all(16),
                        child: Text(l10n.syncCopyLastKnown)),
                    if (data['storage'] != null)
                      ListTile(
                        leading: const Icon(Icons.cloud_outlined),
                        title: Text(data['storage'] == 'googleDrive'
                            ? l10n.syncGoogleDrive
                            : (data['storageHost'] as String? ??
                                l10n.syncServer)),
                        subtitle: Text(data['temporaryStorage'] == true
                            ? l10n.syncCopyTemporary
                            : l10n.syncCopyStorage),
                      ),
                  ],
                  const CloudTrafficNotice(expanded: true),
                  ExpansionTile(
                      key: const ValueKey('sync-copy-advanced'),
                      title: Text(l10n.syncMore),
                      children: [
                        DeviceNameTile(onChanged: _load),
                        ListTile(
                            key: const ValueKey('sync-network-settings'),
                            leading: const Icon(Icons.hub_outlined),
                            title: Text(l10n.syncNetworkTitle),
                            onTap: () =>
                                openPlace(context, 'settings/sync/network'))
                      ]),
                ]))));
  }
}
