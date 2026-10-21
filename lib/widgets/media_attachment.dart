// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'dart:async';
import 'dart:io';

import 'package:aid_diary/config/app_config.dart';
import 'package:aid_diary/database/image_storage.dart';
import 'package:aid_diary/l10n/generated/app_localizations.dart';
import 'package:aid_diary/models/image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logging/logging.dart';
import 'package:material_ui/material_ui.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:video_player/video_player.dart';

final _logger = Logger('MediaAttachment');

/// Stands in for a thumbnail of a video or audio attachment.
class MediaTile extends StatelessWidget {
  const MediaTile({super.key, required this.kind});

  final MediaKind kind;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final video = kind == MediaKind.video;
    return ColoredBox(
      key: ValueKey('media-tile-${kind.name}'),
      color: video ? Colors.black87 : cs.secondaryContainer,
      child: Center(
        child: Icon(
            video
                ? Icons.play_circle_outline_rounded
                : Icons.graphic_eq_rounded,
            size: 40,
            color: video ? Colors.white : cs.onSecondaryContainer),
      ),
    );
  }
}

/// Adds videos and voice notes to an entry; [onAdded] gets the stored names.
class MediaActions {
  static Future<void> pickVideo(
      BuildContext context, ValueChanged<List<String>> onAdded,
      {bool camera = false}) async {
    final messenger = ScaffoldMessenger.maybeOf(context);
    final tooLarge = AppLocalizations.of(context)!.mediaTooLarge;
    final picked = await ImagePicker().pickVideo(
        source: camera ? ImageSource.camera : ImageSource.gallery,
        maxDuration: AppConfig.instance.maxVideoDuration);
    if (picked == null) return;
    await addPickedVideo(picked, onAdded,
        onTooLarge: () =>
            messenger?.showSnackBar(SnackBar(content: Text(tooLarge))));
  }

  /// Stores a video a picker handed over, unless it is too large.
  static Future<void> addPickedVideo(
      XFile picked, ValueChanged<List<String>> onAdded,
      {required VoidCallback onTooLarge}) async {
    final file = File(picked.path);
    try {
      if (await file.length() > AppConfig.instance.maxVideoBytes) {
        onTooLarge();
        return;
      }
      await _store(picked.name, file, onAdded);
    } finally {
      // Android hands over a cache copy; desktop pickers return the original.
      if (Platform.isAndroid && await file.exists()) await file.delete();
    }
  }

  static Future<void> pickAudio(ValueChanged<List<String>> onAdded) async {
    final result = await FilePicker.pickFiles(type: FileType.audio);
    final path = result.firstOrNull?.path;
    if (path == null) return;
    await _store(p.basename(path), File(path), onAdded);
  }

  static Future<void> recordAudio(
      BuildContext context, ValueChanged<List<String>> onAdded) async {
    final path = await showDialog<String>(
        context: context,
        barrierDismissible: false,
        builder: (_) => const _RecorderDialog());
    if (path == null) return;
    final file = File(path);
    try {
      await _store(p.basename(path), file, onAdded);
    } finally {
      if (await file.exists()) await file.delete();
    }
  }

  static Future<void> _store(
      String name, File file, ValueChanged<List<String>> onAdded) async {
    final stored =
        await ImageStorage.instance.create(name, await file.readAsBytes());
    if (stored == null) {
      _logger.warning('Could not store attachment $name');
      return;
    }
    onAdded([stored]);
  }
}

/// Records a voice note; pops with the recording's path.
class _RecorderDialog extends StatefulWidget {
  const _RecorderDialog();

  @override
  State<_RecorderDialog> createState() => _RecorderDialogState();
}

class _RecorderDialogState extends State<_RecorderDialog> {
  final _recorder = AudioRecorder();
  final _watch = Stopwatch();
  Timer? _ticker;
  bool _recording = false;
  String? _error;

  @override
  void dispose() {
    _ticker?.cancel();
    _recorder.dispose();
    super.dispose();
  }

  Future<void> _start() async {
    final l10n = AppLocalizations.of(context)!;
    if (!await _recorder.hasPermission()) {
      setState(() => _error = l10n.audioPermissionDenied);
      return;
    }
    final directory = await getTemporaryDirectory();
    final path = p.join(directory.path,
        'voice-${DateTime.now().millisecondsSinceEpoch}${AppConfig.instance.recordingExtension}');
    await _recorder.start(const RecordConfig(numChannels: 1), path: path);
    _watch
      ..reset()
      ..start();
    _ticker = Timer.periodic(
        const Duration(milliseconds: 250), (_) => setState(() {}));
    setState(() {
      _recording = true;
      _error = null;
    });
  }

  Future<void> _stop() async {
    _watch.stop();
    _ticker?.cancel();
    final path = await _recorder.stop();
    if (mounted) Navigator.of(context).pop(path);
  }

  Future<void> _cancel() async {
    if (_recording) await _recorder.cancel();
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    return AlertDialog(
      title: Text(l10n.audioRecordTitle),
      content: Column(mainAxisSize: MainAxisSize.min, children: [
        Text(formatMediaDuration(_watch.elapsed),
            key: const ValueKey('recorder-elapsed'),
            style: theme.textTheme.displaySmall),
        const SizedBox(height: 16),
        FilledButton.icon(
          key: const ValueKey('recorder-toggle'),
          onPressed: _recording ? _stop : _start,
          icon: Icon(_recording ? Icons.stop_rounded : Icons.mic_rounded),
          label: Text(_recording ? l10n.audioStop : l10n.audioStart),
        ),
        if (_error != null) ...[
          const SizedBox(height: 8),
          Text(_error!,
              style: theme.textTheme.bodySmall
                  ?.copyWith(color: theme.colorScheme.error)),
        ],
      ]),
      actions: [
        TextButton(
          onPressed: _cancel,
          child: Text(MaterialLocalizations.of(context).cancelButtonLabel),
        ),
      ],
    );
  }
}

/// "m:ss", or "h:mm:ss" past an hour.
String formatMediaDuration(Duration duration) {
  final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
  if (duration.inHours > 0) {
    final minutes = (duration.inMinutes % 60).toString().padLeft(2, '0');
    return '${duration.inHours}:$minutes:$seconds';
  }
  return '${duration.inMinutes}:$seconds';
}

/// Plays a video or audio attachment full screen.
class MediaPlayerPage extends StatefulWidget {
  const MediaPlayerPage({super.key, required this.name});

  final String name;

  @override
  State<MediaPlayerPage> createState() => _MediaPlayerPageState();
}

class _MediaPlayerPageState extends State<MediaPlayerPage> {
  VideoPlayerController? _controller;
  bool _failed = false;

  @override
  void initState() {
    super.initState();
    _open();
  }

  Future<void> _open() async {
    try {
      final file = await ImageStorage.instance.localFile(widget.name);
      if (file == null) throw StateError('${widget.name} is not available');
      final controller = VideoPlayerController.file(file);
      await controller.initialize();
      if (!mounted) {
        await controller.dispose();
        return;
      }
      controller.addListener(() => setState(() {}));
      setState(() => _controller = controller);
      await controller.play();
    } catch (error, stackTrace) {
      _logger.warning('Could not play ${widget.name}', error, stackTrace);
      if (mounted) setState(() => _failed = true);
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final video = MediaKind.of(widget.name) == MediaKind.video;
    final controller = _controller;
    final Widget body;
    if (_failed) {
      body = Center(
          child: Text(l10n.mediaUnavailable,
              style: const TextStyle(color: Colors.white)));
    } else if (controller == null) {
      body = const Center(child: CircularProgressIndicator());
    } else {
      final value = controller.value;
      body = Column(children: [
        Expanded(
          child: Center(
            child: video
                ? AspectRatio(
                    aspectRatio: value.aspectRatio,
                    child: VideoPlayer(controller))
                : const Icon(Icons.graphic_eq_rounded,
                    size: 120, color: Colors.white70),
          ),
        ),
        SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8, 8, 16, 16),
            child: Row(children: [
              IconButton(
                key: const ValueKey('media-play-pause'),
                color: Colors.white,
                iconSize: 36,
                icon: Icon(value.isPlaying
                    ? Icons.pause_rounded
                    : Icons.play_arrow_rounded),
                onPressed: () =>
                    value.isPlaying ? controller.pause() : controller.play(),
              ),
              Expanded(
                child: VideoProgressIndicator(controller,
                    allowScrubbing: true,
                    colors: const VideoProgressColors(
                        playedColor: Colors.white,
                        bufferedColor: Colors.white38,
                        backgroundColor: Colors.white24),
                    padding: const EdgeInsets.symmetric(horizontal: 8)),
              ),
              Text(
                  '${formatMediaDuration(value.position)} / '
                  '${formatMediaDuration(value.duration)}',
                  style: const TextStyle(color: Colors.white)),
            ]),
          ),
        ),
      ]);
    }
    return Scaffold(
      backgroundColor: Colors.black,
      appBar:
          AppBar(backgroundColor: Colors.black, foregroundColor: Colors.white),
      body: body,
    );
  }
}
