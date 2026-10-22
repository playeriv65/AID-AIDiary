import 'dart:async';

import 'package:aid_diary/actions/app_actions.dart';
import 'package:aid_diary/l10n/generated/app_localizations.dart';
import 'package:aid_diary/sync/sync_service.dart';
import 'package:aid_diary/time_manager.dart';
import 'package:intl/intl.dart';
import 'package:material_ui/material_ui.dart';

/// Shows only the server's monthly byte counters and reset date. Arbitrary
/// policy fields and errors may contain credentials and are never rendered.
class CloudTrafficNotice extends StatefulWidget {
  const CloudTrafficNotice(
      {super.key,
      this.load,
      this.changes,
      this.expanded = false,
      this.refreshDelay = const Duration(milliseconds: 500)});

  final Future<Map<Object?, Object?>?> Function()? load;
  final Listenable? changes;
  final Duration refreshDelay;
  final bool expanded;

  @override
  State<CloudTrafficNotice> createState() => _CloudTrafficNoticeState();
}

class _CloudTrafficNoticeState extends State<CloudTrafficNotice> {
  late Listenable _changes;
  _CloudTraffic? _data;
  Timer? _pending;
  bool _loading = false;
  bool _showDetails = false;
  int _generation = 0;

  @override
  void initState() {
    super.initState();
    _changes = widget.changes ?? SyncService.instance;
    _changes.addListener(_changed);
    unawaited(_refresh());
  }

  @override
  void didUpdateWidget(covariant CloudTrafficNotice oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.load == widget.load && oldWidget.changes == widget.changes) {
      return;
    }
    _changes.removeListener(_changed);
    _changes = widget.changes ?? SyncService.instance;
    _changes.addListener(_changed);
    _pending?.cancel();
    _generation++;
    _loading = false;
    _data = null;
    unawaited(_refresh());
  }

  void _changed() {
    // Reading policy must not feed a service notification back into another
    // request. Progress bursts settle before one fresh usage read is made.
    if (_loading || !mounted) return;
    _pending?.cancel();
    _pending = Timer(widget.refreshDelay, () => unawaited(_refresh()));
  }

  Future<void> _refresh() async {
    if (_loading || !mounted) return;
    _loading = true;
    final generation = _generation;
    try {
      final Object? result = widget.load != null
          ? await widget.load!()
          : await AppActions.instance.run('sync.cloud_usage', {});
      final data = _CloudTraffic.parse(result);
      if (mounted && generation == _generation) {
        setState(() => _data = data);
      }
    } catch (_) {
      if (mounted && generation == _generation) {
        setState(() => _data = null);
      }
    } finally {
      if (generation == _generation) _loading = false;
    }
  }

  @override
  void dispose() {
    _generation++;
    _pending?.cancel();
    _changes.removeListener(_changed);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final data = _data;
    if (data == null) return const SizedBox.shrink();
    final l10n = AppLocalizations.of(context)!;
    final locale = TimeManager.currentLocale(context);
    if (!widget.expanded && !_showDetails) {
      return ListTile(
          key: const ValueKey('cloud-traffic-summary'),
          leading: const Icon(Icons.cloud_outlined),
          title: Text(l10n.cloudTrafficTitle),
          subtitle: Text(data.remaining == 0
              ? l10n.cloudTrafficExhausted
              : l10n.cloudTrafficSummary(
                  formatCloudTrafficBytes(data.remaining, locale),
                  formatCloudTrafficBytes(data.limit, locale))),
          trailing: const Icon(Icons.expand_more_rounded),
          onTap: () => setState(() => _showDetails = true));
    }
    final reset =
        '${DateFormat.yMMMd(locale).add_Hm().format(data.resetsAt)} UTC';
    Widget amount(String label, int bytes, String key) => Padding(
        padding: const EdgeInsets.only(top: 6),
        child: Wrap(spacing: 8, children: [
          Text(label),
          Text(formatCloudTrafficBytes(bytes, locale), key: ValueKey(key))
        ]));
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
          padding: const EdgeInsets.all(16),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(l10n.cloudTrafficTitle,
                style: Theme.of(context).textTheme.titleMedium),
            amount(l10n.cloudTrafficLimit, data.limit, 'cloud-traffic-limit'),
            amount(l10n.cloudTrafficUsed, data.used, 'cloud-traffic-used'),
            amount(l10n.cloudTrafficRemaining, data.remaining,
                'cloud-traffic-remaining'),
            const SizedBox(height: 12),
            LinearProgressIndicator(
                value: data.limit == 0
                    ? 1
                    : (data.used / data.limit).clamp(0.0, 1.0)),
            const SizedBox(height: 8),
            Text(l10n.cloudTrafficResetsAt(reset),
                key: const ValueKey('cloud-traffic-reset')),
            const SizedBox(height: 8),
            Text(l10n.cloudTrafficExplanation),
            if (data.remaining == 0)
              Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(l10n.cloudTrafficExhausted,
                      key: const ValueKey('cloud-traffic-exhausted'))),
          ])),
    );
  }
}

/// Decimal units match the server's advertised monthly traffic allowance.
String formatCloudTrafficBytes(int bytes, String locale) {
  final gigabytes = bytes >= 1000000000;
  final number = bytes / (gigabytes ? 1000000000 : 1000000);
  return '${NumberFormat(number > 0 && number < 0.01 ? '0.######' : '0.##', locale).format(number)} ${gigabytes ? 'GB' : 'MB'}';
}

class _CloudTraffic {
  const _CloudTraffic(this.limit, this.used, this.remaining, this.resetsAt);
  final int limit;
  final int used;
  final int remaining;
  final DateTime resetsAt;

  static _CloudTraffic? parse(Object? json) {
    if (json is! Map) return null;
    final limit = json['monthlyLimitBytes'];
    final used = json['monthlyUsedBytes'];
    final remaining = json['monthlyRemainingBytes'];
    final reset = json['resetsAt'];
    if (limit is! int ||
        limit < 0 ||
        used is! int ||
        used < 0 ||
        remaining is! int ||
        remaining < 0 ||
        reset is! String ||
        reset.length > 64) {
      return null;
    }
    final date = DateTime.tryParse(reset);
    if (date == null || !date.isUtc) return null;
    return _CloudTraffic(limit, used, remaining, date.toUtc());
  }
}
