import 'package:aid_diary/actions/app_actions.dart';
import 'package:aid_diary/l10n/generated/app_localizations.dart';
import 'package:aid_diary/sync/local_device.dart';
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
    final name = await showDialog<String>(
        context: context, builder: (_) => const _DeviceNameDialog());
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

class _DeviceNameDialog extends StatefulWidget {
  const _DeviceNameDialog();
  @override
  State<_DeviceNameDialog> createState() => _DeviceNameDialogState();
}

class _DeviceNameDialogState extends State<_DeviceNameDialog> {
  final _controller = TextEditingController(text: LocalDevice.name);
  final _form = GlobalKey<FormState>();
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _save() {
    if (_form.currentState!.validate()) {
      Navigator.pop(context, _controller.text.trim());
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return AlertDialog(
        title: Text(l10n.syncDeviceName),
        content: Form(
            key: _form,
            child: TextFormField(
                key: const ValueKey('sync-device-name-input'),
                controller: _controller,
                autofocus: true,
                maxLength: 32,
                textCapitalization: TextCapitalization.sentences,
                decoration: InputDecoration(hintText: l10n.syncDeviceNameHint),
                validator: (value) => LocalDevice.validName(value ?? '')
                    ? null
                    : l10n.syncDeviceNameInvalid,
                onFieldSubmitted: (_) => _save())),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(MaterialLocalizations.of(context).cancelButtonLabel)),
          FilledButton(
              key: const ValueKey('sync-device-name-save'),
              onPressed: _save,
              child: Text(MaterialLocalizations.of(context).saveButtonLabel))
        ]);
  }
}
