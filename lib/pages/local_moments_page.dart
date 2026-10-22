// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'dart:io';
import 'package:aid_diary/actions/app_action.dart';
import 'package:aid_diary/actions/app_actions.dart';
import 'package:aid_diary/actions/settings_actions.dart';
import 'package:aid_diary/config_provider.dart';
import 'package:aid_diary/device_info_service.dart';
import 'package:aid_diary/l10n/generated/app_localizations.dart';
import 'package:aid_diary/providers/entries_provider.dart';
import 'package:aid_diary/routing/entry_navigation.dart';
import 'package:aid_diary/widgets/haptics.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:file_picker/file_picker.dart';
import 'package:material_ui/material_ui.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class LocalMomentsPage extends StatefulWidget {
  const LocalMomentsPage({super.key});
  @override
  State<LocalMomentsPage> createState() => _LocalMomentsPageState();
}

class _LocalMomentsPageState extends State<LocalMomentsPage> {
  List<Map<String, dynamic>> cards = [];
  bool busy = false;
  bool scanned = false;
  Future<int> _sdk() async =>
      DeviceInfoService().androidSdk ??
      (await DeviceInfoPlugin().androidInfo).version.sdkInt;
  void _error([bool permission = false]) {
    if (!mounted) return;
    final l10n = AppLocalizations.of(context)!;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content:
            Text(permission ? l10n.momentsPermission : l10n.momentsError)));
  }

  Future<void> _folder() async {
    final path = await FilePicker.getDirectoryPath();
    if (path == null || !mounted) return;
    await changeSetting(Settings.localPhotoFolder, path);
    if (mounted) await _scan();
  }

  Future<void> _locations(bool value) async {
    if (value && Platform.isAndroid && await _sdk() >= 29) {
      if (!await Permission.accessMediaLocation.request().isGranted) return;
    }
    await changeSetting(Settings.photoSuggestionsLocation, value);
    if (mounted) {
      setState(() {
        cards = [];
        scanned = false;
      });
    }
  }

  Future<void> _scan() async {
    if (busy) return;
    if (Platform.isAndroid) {
      final permission =
          await _sdk() >= 33 ? Permission.photos : Permission.storage;
      final status = await permission.request();
      if (!status.isGranted && !status.isLimited) {
        _error(true);
        return;
      }
    } else if (ConfigProvider.instance.get(Settings.localPhotoFolder).isEmpty) {
      await _folder();
      return;
    }
    if (!mounted) return;
    setState(() => busy = true);
    try {
      final result =
          await AppActions.instance.run('moments.scan', {'days': 7}) as Map;
      if (!mounted) return;
      setState(() {
        cards = (result['cards'] as List)
            .map((item) => (item as Map).cast<String, dynamic>())
            .toList();
        scanned = true;
      });
    } catch (error) {
      _error(error is ActionException && error.code == 'permission');
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  Future<void> _create(Map<String, dynamic> card) async {
    if (busy) return;
    setState(() => busy = true);
    try {
      final result = await AppActions.instance
          .run('moments.create', {'id': card['id']}) as Map;
      if (!mounted) return;
      setState(() => cards.removeWhere((item) => item['id'] == card['id']));
      Haptics.success();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(AppLocalizations.of(context)!.momentsCreated)));
      final entry = EntriesProvider.instance.entries
          .where((entry) => entry.id == result['id'])
          .firstOrNull;
      if (entry != null && mounted) await EntryNavigation.edit(context, entry);
    } catch (_) {
      _error();
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  Future<void> _dismiss(Map<String, dynamic> card) async {
    if (busy) return;
    try {
      await AppActions.instance.run('moments.dismiss', {'id': card['id']});
      if (mounted) {
        setState(() => cards.removeWhere((item) => item['id'] == card['id']));
      }
    } catch (_) {
      _error();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final config = context.watch<ConfigProvider>();
    return Scaffold(
        appBar: AppBar(title: Text(l10n.momentsTitle)),
        body: Center(
            child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 800),
                child: ListView(padding: const EdgeInsets.all(20), children: [
                  Text(l10n.momentsHint),
                  const SizedBox(height: 12),
                  Text(l10n.momentsScope,
                      style: Theme.of(context).textTheme.bodySmall),
                  if (!Platform.isAndroid)
                    ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(l10n.momentsChooseFolder),
                        subtitle: config.get(Settings.localPhotoFolder).isEmpty
                            ? null
                            : Text(config.get(Settings.localPhotoFolder),
                                maxLines: 2),
                        trailing: const Icon(Icons.folder_open),
                        onTap: busy ? null : _folder),
                  SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(l10n.momentsLocation),
                      value: config.get(Settings.photoSuggestionsLocation),
                      onChanged: busy ? null : _locations),
                  FilledButton.icon(
                      key: const ValueKey('moments-scan'),
                      onPressed: busy ? null : _scan,
                      icon: const Icon(Icons.auto_awesome_outlined),
                      label: Text(l10n.momentsScan)),
                  if (busy)
                    const Padding(
                        padding: EdgeInsets.all(20),
                        child: LinearProgressIndicator()),
                  if (scanned && cards.isEmpty && !busy)
                    Padding(
                        padding: const EdgeInsets.all(24),
                        child: Text(l10n.momentsEmpty)),
                  for (final card in cards)
                    Card(
                        key: ValueKey('moment-card-${card['id']}'),
                        margin: const EdgeInsets.only(top: 16),
                        child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(children: [
                                    const Icon(Icons.photo_library_outlined),
                                    const SizedBox(width: 12),
                                    Expanded(
                                        child: Text(
                                            l10n.momentsPhotoCount(
                                                card['count'] as int),
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleMedium)),
                                    IconButton(
                                        tooltip: l10n.momentsDismiss,
                                        onPressed:
                                            busy ? null : () => _dismiss(card),
                                        icon: const Icon(Icons.close))
                                  ]),
                                  Text(MaterialLocalizations.of(context)
                                      .formatFullDate(DateTime.parse(
                                          card['day'] as String))),
                                  if (card['place'] is String)
                                    Text(card['place'] as String)
                                  else if (card['latitude'] is num &&
                                      card['longitude'] is num)
                                    Text(
                                        '${(card['latitude'] as num).toStringAsFixed(3)}, ${(card['longitude'] as num).toStringAsFixed(3)}'),
                                  const SizedBox(height: 12),
                                  OutlinedButton.icon(
                                      onPressed:
                                          busy ? null : () => _create(card),
                                      icon: const Icon(Icons.edit_note),
                                      label: Text(l10n.momentsCreate)),
                                ]))),
                ]))));
  }
}
