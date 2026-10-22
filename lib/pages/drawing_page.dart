// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'dart:convert';
import 'package:aid_diary/actions/app_actions.dart';
import 'package:aid_diary/l10n/generated/app_localizations.dart';
import 'package:aid_diary/widgets/drawing_canvas.dart';
import 'package:aid_diary/widgets/haptics.dart';
import 'package:material_ui/material_ui.dart';

class DrawingPage extends StatefulWidget {
  const DrawingPage({super.key, this.entryId});
  final int? entryId;
  @override
  State<DrawingPage> createState() => _DrawingPageState();
}

class _DrawingPageState extends State<DrawingPage> {
  final controller = DrawingCanvasController();
  int color = 0xff263238;
  double width = 6;
  bool eraser = false;
  bool stylusOnly = false;
  bool saving = false;
  bool saved = false;
  @override
  void initState() {
    super.initState();
    controller.addListener(_changed);
  }

  void _changed() {
    // Pointer movement repaints the canvas directly; toolbar state only
    // changes at a stroke boundary.
    if (controller.revision != _revision) {
      _revision = controller.revision;
      if (mounted) setState(() {});
    }
  }

  int _revision = 0;
  @override
  void dispose() {
    controller.removeListener(_changed);
    controller.dispose();
    super.dispose();
  }

  Future<void> _leave() async {
    if (controller.isEmpty || saved) {
      Navigator.of(context).pop();
      return;
    }
    final l10n = AppLocalizations.of(context)!;
    final discard = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
                title: Text(l10n.drawingDiscardTitle),
                content: Text(l10n.drawingDiscardBody),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: Text(
                          MaterialLocalizations.of(context).cancelButtonLabel)),
                  TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: Text(MaterialLocalizations.of(context)
                          .deleteButtonTooltip)),
                ]));
    if (discard == true && mounted) {
      setState(() => saved = true);
      await WidgetsBinding.instance.endOfFrame;
      if (mounted) Navigator.of(context).pop();
    }
  }

  Future<void> _save() async {
    if (saving || controller.isEmpty) return;
    controller.end();
    setState(() => saving = true);
    try {
      final result = await AppActions.instance
          .run(widget.entryId == null ? 'drawing.render' : 'drawing.attach', {
        'spec': jsonEncode(controller.document.toJson()),
        if (widget.entryId != null) 'id': widget.entryId
      }) as Map;
      if (!mounted) return;
      Haptics.success();
      setState(() => saved = true);
      await WidgetsBinding.instance.endOfFrame;
      if (mounted) Navigator.pop(context, result['name'] as String);
    } catch (_) {
      if (!mounted) return;
      setState(() => saving = false);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(AppLocalizations.of(context)!.drawingSaveError)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return PopScope(
        canPop: saved || controller.isEmpty,
        onPopInvokedWithResult: (didPop, _) {
          if (!didPop && !saving) _leave();
        },
        child: Scaffold(
            appBar: AppBar(
                title: Text(l10n.drawingTitle),
                leading: IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: saving ? null : _leave),
                actions: [
                  IconButton(
                      key: const ValueKey('drawing-save'),
                      tooltip:
                          MaterialLocalizations.of(context).saveButtonLabel,
                      onPressed: saving || controller.isEmpty ? null : _save,
                      icon: saving
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2))
                          : const Icon(Icons.check))
                ]),
            body: Column(children: [
              SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(children: [
                    IconButton(
                        tooltip: l10n.drawingPen,
                        isSelected: !eraser,
                        onPressed: () => setState(() => eraser = false),
                        icon: const Icon(Icons.edit_outlined)),
                    IconButton(
                        tooltip: l10n.drawingEraser,
                        isSelected: eraser,
                        onPressed: () => setState(() => eraser = true),
                        icon: const Icon(Icons.cleaning_services_outlined)),
                    IconButton(
                        key: const ValueKey('drawing-undo'),
                        tooltip: l10n.drawingUndo,
                        onPressed: controller.canUndo ? controller.undo : null,
                        icon: const Icon(Icons.undo)),
                    IconButton(
                        tooltip: l10n.drawingClear,
                        onPressed: controller.isEmpty ? null : controller.clear,
                        icon: const Icon(Icons.delete_sweep_outlined)),
                    for (final ink in [
                      0xff263238,
                      0xff426a9a,
                      0xff517b60,
                      0xffa6546c,
                      0xffa77d32
                    ])
                      IconButton(
                          onPressed: () => setState(() {
                                color = ink;
                                eraser = false;
                              }),
                          tooltip: '#${ink.toRadixString(16).substring(2)}',
                          icon: Icon(
                              color == ink && !eraser
                                  ? Icons.circle
                                  : Icons.circle_outlined,
                              color: Color(ink))),
                  ])),
              Row(children: [
                const SizedBox(width: 16),
                Text(l10n.drawingWidth),
                Expanded(
                    child: Slider(
                        value: width,
                        min: 2,
                        max: 28,
                        onChanged: (value) => setState(() => width = value))),
                Icon(Icons.draw_outlined,
                    semanticLabel: l10n.drawingStylusOnly),
                Switch(
                    value: stylusOnly,
                    onChanged: (value) => setState(() => stylusOnly = value)),
                const SizedBox(width: 16)
              ]),
              Expanded(
                  child: ColoredBox(
                      color: Theme.of(context).colorScheme.surfaceContainer,
                      child: Center(
                          child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: DrawingCanvas(
                                  controller: controller,
                                  color: eraser ? 0xffffffff : color,
                                  width: eraser ? width * 2 : width,
                                  stylusOnly: stylusOnly,
                                  enabled: !saving))))),
            ])));
  }
}
