import 'package:aid_diary/actions/app_actions.dart';
import 'package:aid_diary/l10n/generated/app_localizations.dart';
import 'package:aid_diary/sync/local_device.dart';
import 'package:aid_diary/widgets/text_input_dialog.dart';
import 'package:material_ui/material_ui.dart';

/// A useful default avoids making naming another step before connecting.
class DeviceNameTile extends StatefulWidget {
  const DeviceNameTile({super.key, this.onChanged});
  final VoidCallback? onChanged;
  @override
  State<DeviceNameTile> createState() => _DeviceNameTileState();
}

class _DeviceNameTileState extends State<DeviceNameTile> {
  Future<void> _edit() async {
    final l10n = AppLocalizations.of(context)!;
    final name = await showTextInputDialog(context,
        title: l10n.syncDeviceName,
        confirm: MaterialLocalizations.of(context).saveButtonLabel,
        initial: LocalDevice.name,
        hint: l10n.syncDeviceNameHint,
        maxLength: 32,
        capitalization: TextCapitalization.sentences,
        validate: (name) =>
            LocalDevice.validName(name) ? null : l10n.syncDeviceNameInvalid,
        fieldKey: const ValueKey('sync-device-name-input'),
        confirmKey: const ValueKey('sync-device-name-save'));
    if (name == null || !mounted) return;
    try {
      await AppActions.instance.run('sync.device_name', {'name': name});
      if (mounted) {
        setState(() {});
        widget.onChanged?.call();
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content:
                Text(AppLocalizations.of(context)!.syncDeviceNameSaveFailed)));
      }
    }
  }

  @override
  Widget build(BuildContext context) => ListTile(
      key: const ValueKey('sync-device-name'),
      leading: const Icon(Icons.devices_rounded),
      title: Text(LocalDevice.name),
      subtitle: Text(AppLocalizations.of(context)!.syncDeviceLocal),
      trailing: const Icon(Icons.edit_outlined, size: 20),
      onTap: _edit);
}
