// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'package:aid_diary/config_provider.dart';
import 'package:aid_diary/l10n/generated/app_localizations.dart';
import 'package:aid_diary/layouts/adaptive_diary_shell.dart';
import 'package:aid_diary/models/builtin_templates.dart';
import 'package:aid_diary/models/coach_program.dart';
import 'package:aid_diary/models/template.dart';
import 'package:aid_diary/providers/templates_provider.dart';
import 'package:aid_diary/services/coach_service.dart';
import 'package:aid_diary/utils/entry_navigation.dart';
import 'package:aid_diary/widgets/coach_widgets.dart';
import 'package:aid_diary/widgets/list_detail_layout.dart';
import 'package:aid_diary/widgets/scaled_markdown.dart';
import 'package:aid_diary/widgets/top_search_card.dart';
import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';

enum _CoachFilter { all, programs, templates }

/// A card in the catalog and the page it opens. The page gets a back action
/// when it replaces the catalog inside the list pane.
typedef _CoachItem = ({
  Object key,
  Widget Function(double headerAspectRatio) card,
  Widget Function(VoidCallback? onBack) detail,
});

/// Guided writing: built-in prompt programs and the user's templates.
class CoachPage extends StatefulWidget {
  const CoachPage({super.key});

  @override
  State<CoachPage> createState() => _CoachPageState();
}

class _CoachPageState extends State<CoachPage>
    with AutomaticKeepAliveClientMixin {
  _CoachFilter _filter = _CoachFilter.all;
  Object? _selected; // A CoachProgram id or a Template.

  @override
  bool get wantKeepAlive => true;

  // Wide windows open the page in the list pane, as Journey does, and keep
  // the detail pane empty; phones push it.
  void _open(BuildContext context, _CoachItem item, bool split) {
    if (split) {
      setState(() => _selected = item.key);
    } else {
      Navigator.of(context).push(MaterialPageRoute(
          allowSnapshotting: false, builder: (_) => item.detail(null)));
    }
  }

  List<_CoachItem> _items(AppLocalizations l10n) {
    final templates = context.watch<TemplatesProvider>().templates;
    return [
      if (_filter != _CoachFilter.templates)
        for (final program in CoachProgram.all(l10n))
          (
            key: program.id,
            detail: (onBack) =>
                _ProgramDetail(program: program, onBack: onBack),
            card: (headerAspectRatio) => _CoachCard(
                  key: ValueKey('coach-program-${program.id}'),
                  headerAspectRatio: headerAspectRatio,
                  icon: program.icon,
                  kind: l10n.coachKindProgram,
                  title: program.title,
                  description: program.tagline,
                ),
          ),
      if (_filter != _CoachFilter.programs) ...[
        for (final builtin in BuiltinTemplate.all(l10n))
          (
            key: 'builtin-${builtin.id}',
            detail: (onBack) =>
                _TemplateDetail(template: builtin.toTemplate(), onBack: onBack),
            card: (headerAspectRatio) => _CoachCard(
                  key: ValueKey('coach-builtin-${builtin.id}'),
                  headerAspectRatio: headerAspectRatio,
                  icon: Icons.auto_awesome_outlined,
                  kind: l10n.templateFeatured,
                  title: builtin.name,
                  description: builtin.description,
                ),
          ),
        for (final template in templates)
          (
            key: template,
            detail: (onBack) =>
                _TemplateDetail(template: template, onBack: onBack),
            card: (headerAspectRatio) => _CoachCard(
                  key: ValueKey('coach-template-${template.id}'),
                  headerAspectRatio: headerAspectRatio,
                  icon: Icons.description_outlined,
                  kind: l10n.coachKindTemplate,
                  title: template.name,
                  description: (template.text ?? '').replaceAll('\n', ' '),
                ),
          ),
      ],
    ];
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final l10n = AppLocalizations.of(context)!;
    final items = _items(l10n);
    final selected = items.where((c) => c.key == _selected).firstOrNull;
    void back() => setState(() => _selected = null);

    return PopScope(
      canPop: selected == null,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) back();
      },
      child: ListDetailLayout(
        detail: null,
        listBuilder: (context, split) => split && selected != null
            ? selected.detail(back)
            : _catalog(context, l10n, items, split),
      ),
    );
  }

  Widget _catalog(BuildContext context, AppLocalizations l10n,
      List<_CoachItem> items, bool split) {
    return CustomScrollView(slivers: [
      const SliverPadding(
        padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
        sliver: SliverToBoxAdapter(child: TopSearchCard(showSearch: false)),
      ),
      SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Center(
            child: SegmentedButton<_CoachFilter>(
              key: const ValueKey('coach-filter'),
              segments: [
                ButtonSegment(
                    value: _CoachFilter.all, label: Text(l10n.coachAll)),
                ButtonSegment(
                    value: _CoachFilter.programs,
                    label: Text(l10n.coachPrograms)),
                ButtonSegment(
                    value: _CoachFilter.templates,
                    label: Text(l10n.coachTemplates)),
              ],
              selected: {_filter},
              onSelectionChanged: (value) =>
                  setState(() => _filter = value.single),
            ),
          ),
        ),
      ),
      if (items.isEmpty)
        SliverToBoxAdapter(
            child: EmptyState(
                icon: Icons.description_outlined, title: l10n.coachNoTemplates))
      else
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
          // Cards are as tall as their text; beside a detail pane two
          // share a row and match heights, phones show one per row.
          sliver: SliverList.separated(
            itemCount: (items.length / (split ? 2 : 1)).ceil(),
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, row) {
              final perRow = split ? 2 : 1;
              Widget cell(int index) {
                if (index >= items.length) return const SizedBox.shrink();
                final item = items[index];
                return GestureDetector(
                  onTap: () => _open(context, item, split),
                  child: item.card(split ? 4 / 3 : 2),
                );
              }

              return IntrinsicHeight(
                child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      for (var i = 0; i < perRow; i++) ...[
                        if (i > 0) const SizedBox(width: 12),
                        Expanded(child: cell(row * perRow + i)),
                      ],
                    ]),
              );
            },
          ),
        ),
    ]);
  }
}

class _CoachCard extends StatelessWidget {
  const _CoachCard({
    super.key,
    required this.icon,
    required this.kind,
    required this.title,
    required this.description,
    required this.headerAspectRatio,
  });

  /// Width over height of the illustration area.
  final double headerAspectRatio;
  final IconData icon;
  final String kind;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    return Card.filled(
      margin: EdgeInsets.zero,
      color: cs.surfaceContainer,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        AspectRatio(
          aspectRatio: headerAspectRatio,
          child: ColoredBox(
            color: cs.primaryContainer,
            child: Icon(icon, size: 64, color: cs.onPrimaryContainer),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(kind.toUpperCase(),
                style: theme.textTheme.labelMedium
                    ?.copyWith(letterSpacing: 1.6, color: cs.onSurfaceVariant)),
            const SizedBox(height: 6),
            Text(title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.titleLarge
                    ?.copyWith(fontWeight: FontWeight.w700)),
            const SizedBox(height: 6),
            Text(description,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodyLarge
                    ?.copyWith(color: cs.onSurfaceVariant)),
          ]),
        ),
      ]),
    );
  }
}

/// A program: cover and enrolment, its facts, what it is about, who wrote
/// it. The prompts themselves arrive one at a time in the stories.
class _ProgramDetail extends StatelessWidget {
  const _ProgramDetail({required this.program, this.onBack});
  final CoachProgram program;
  final VoidCallback? onBack;

  Future<void> _enroll(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    final messenger = ScaffoldMessenger.of(context);
    final goTo = AdaptiveDiaryShell.selectorOf(context);
    await CoachService.enroll(l10n, program);
    if (!context.mounted) return;
    messenger.showSnackBar(SnackBar(
      key: const ValueKey('coach-enrolled-tip'),
      behavior: SnackBarBehavior.floating,
      duration: const Duration(seconds: 8),
      content: Row(children: [
        const CoachAvatar(),
        const SizedBox(width: 16),
        Expanded(child: Text(l10n.coachEnrolledTip)),
      ]),
      action: SnackBarAction(
        label: l10n.coachGoToStories,
        onPressed: () {
          goTo?.call(0);
          onBack?.call();
        },
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final l10n = AppLocalizations.of(context)!;
    context.watch<ConfigProvider>();
    final enrolled = CoachService.current(l10n)?.program.id == program.id;

    final action = enrolled
        ? FilledButton.icon(
            key: const ValueKey('coach-end'),
            onPressed: CoachService.end,
            icon: const Icon(Icons.stop_circle_outlined),
            label: Text(l10n.coachEndProgram),
          )
        : FilledButton.icon(
            key: const ValueKey('coach-enroll'),
            onPressed: () => _enroll(context),
            icon: const Icon(Icons.flag_outlined),
            label: Text(l10n.coachEnroll),
          );

    return Scaffold(
      body: CustomScrollView(slivers: [
        SliverAppBar.large(
          leading: onBack == null ? null : BackButton(onPressed: onBack),
          title: Text(program.title),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
          sliver: SliverList.list(children: [
            // Cover beside its tagline and the enrol button; stacked when
            // narrow.
            LayoutBuilder(builder: (context, constraints) {
              final cover = AspectRatio(
                  aspectRatio: 276 / 200,
                  child: ProgramCover(program: program));
              final side = Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(program.tagline, style: theme.textTheme.bodyLarge),
                    const SizedBox(height: 16),
                    action,
                  ]);
              if (constraints.maxWidth < 480) {
                return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [cover, const SizedBox(height: 16), side]);
              }
              return Row(children: [
                SizedBox(width: constraints.maxWidth * .48, child: cover),
                const SizedBox(width: 16),
                Expanded(child: side),
              ]);
            }),
            const SizedBox(height: 24),
            const Divider(height: 1),
            const SizedBox(height: 16),
            _ProgramFacts(program: program),
            const SizedBox(height: 16),
            Text(program.description, style: theme.textTheme.bodyLarge),
            const SizedBox(height: 24),
            Text(l10n.coachAuthor,
                style:
                    theme.textTheme.titleMedium?.copyWith(color: cs.primary)),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const CoachAvatar(radius: 28),
              title: Text(l10n.appTitle,
                  style: theme.textTheme.titleSmall
                      ?.copyWith(fontWeight: FontWeight.w700)),
              subtitle: Text(l10n.coachAuthorBio),
            ),
          ]),
        ),
      ]),
    );
  }
}

/// Duration | interval | difficulty | kind | author, divided like a ruler.
class _ProgramFacts extends StatelessWidget {
  const _ProgramFacts({required this.program});
  final CoachProgram program;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final l10n = AppLocalizations.of(context)!;
    Widget fact(String label, String value) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(label,
                  style: theme.textTheme.labelSmall
                      ?.copyWith(color: cs.onSurfaceVariant)),
              const SizedBox(height: 4),
              Text(value, style: theme.textTheme.titleSmall),
            ]);
    const divider = VerticalDivider(width: 32);
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: IntrinsicHeight(
        child: Row(children: [
          fact(l10n.coachDuration, program.durationLabel(l10n)),
          divider,
          fact(l10n.coachInterval, program.intervalLabel(l10n)),
          divider,
          fact(l10n.coachDifficulty, program.difficultyLabel(l10n)),
          divider,
          Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Icon(Icons.flag_outlined, size: 20, color: cs.onSurfaceVariant),
            const SizedBox(height: 2),
            Text(l10n.coachKindProgram, style: theme.textTheme.labelSmall),
          ]),
          divider,
          const CoachAvatar(radius: 16),
          const SizedBox(width: 8),
          Text(l10n.appTitle,
              style: theme.textTheme.titleSmall
                  ?.copyWith(fontWeight: FontWeight.w700)),
        ]),
      ),
    );
  }
}

class _TemplateDetail extends StatelessWidget {
  const _TemplateDetail({required this.template, this.onBack});
  final Template template;
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
          leading: onBack == null ? null : BackButton(onPressed: onBack),
          title: Text(template.name)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        children: [
          ScaledMarkdown(data: template.text ?? '', selectable: false),
          const SizedBox(height: 24),
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: FilledButton.icon(
              key: const ValueKey('coach-use-template'),
              onPressed: () =>
                  EntryNavigation.edit(context, null, template: template),
              icon: const Icon(Icons.edit_rounded),
              label: Text(l10n.coachUseTemplate),
            ),
          ),
        ],
      ),
    );
  }
}
