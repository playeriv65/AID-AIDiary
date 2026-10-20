// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'package:daily_you/l10n/generated/app_localizations.dart';
import 'package:daily_you/models/builtin_templates.dart';
import 'package:daily_you/models/template.dart';
import 'package:daily_you/providers/templates_provider.dart';
import 'package:daily_you/utils/entry_navigation.dart';
import 'package:daily_you/widgets/list_detail_layout.dart';
import 'package:daily_you/widgets/scaled_markdown.dart';
import 'package:daily_you/widgets/top_search_card.dart';
import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';

/// A short series of writing prompts.
class CoachProgram {
  const CoachProgram(
      {required this.id,
      required this.title,
      required this.description,
      required this.prompts});
  final String id;
  final String title;
  final String description;
  final List<String> prompts;

  static List<CoachProgram> all(AppLocalizations l10n) => [
        CoachProgram(
          id: 'everyday',
          title: l10n.coachProgramEverydayTitle,
          description: l10n.coachProgramEverydayDescription,
          prompts: [
            l10n.coachPrompt1,
            l10n.coachPrompt2,
            l10n.coachPrompt6,
            l10n.coachPrompt9,
            l10n.coachPrompt10,
          ],
        ),
        CoachProgram(
          id: 'reflect',
          title: l10n.coachProgramReflectTitle,
          description: l10n.coachProgramReflectDescription,
          prompts: [
            l10n.coachPrompt3,
            l10n.coachPrompt4,
            l10n.coachPrompt5,
            l10n.coachPrompt7,
            l10n.coachPrompt8,
          ],
        ),
      ];
}

enum _CoachFilter { all, programs, templates }

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

  void _open(
      BuildContext context, Widget Function() detail, Object key, bool split) {
    if (split) {
      setState(() => _selected = key);
    } else {
      Navigator.of(context).push(MaterialPageRoute(
          allowSnapshotting: false, builder: (_) => detail()));
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final l10n = AppLocalizations.of(context)!;
    final templates = context.watch<TemplatesProvider>().templates;
    final programs = CoachProgram.all(l10n);
    final cards = <({
      Object key,
      Widget Function(double) card,
      Widget Function() detail
    })>[];
    if (_filter != _CoachFilter.templates) {
      for (final program in programs) {
        Widget detail() => _ProgramDetail(program: program);
        cards.add((
          key: program.id,
          detail: detail,
          card: (headerAspectRatio) => _CoachCard(
                key: ValueKey('coach-program-${program.id}'),
                headerAspectRatio: headerAspectRatio,
                icon: Icons.lightbulb_outline_rounded,
                kind: l10n.coachKindProgram,
                title: program.title,
                description: program.description,
              ),
        ));
      }
    }
    if (_filter != _CoachFilter.programs) {
      for (final builtin in BuiltinTemplate.all(l10n)) {
        final template = builtin.toTemplate();
        Widget detail() => _TemplateDetail(template: template);
        cards.add((
          key: 'builtin-${builtin.id}',
          detail: detail,
          card: (headerAspectRatio) => _CoachCard(
                key: ValueKey('coach-builtin-${builtin.id}'),
                headerAspectRatio: headerAspectRatio,
                icon: Icons.auto_awesome_outlined,
                kind: l10n.templateFeatured,
                title: builtin.name,
                description: builtin.description,
              ),
        ));
      }
      for (final template in templates) {
        Widget detail() => _TemplateDetail(template: template);
        cards.add((
          key: template,
          detail: detail,
          card: (headerAspectRatio) => _CoachCard(
                key: ValueKey('coach-template-${template.id}'),
                headerAspectRatio: headerAspectRatio,
                icon: Icons.description_outlined,
                kind: l10n.coachKindTemplate,
                title: template.name,
                description: (template.text ?? '').replaceAll('\n', ' '),
              ),
        ));
      }
    }
    final selected = cards.where((c) => c.key == _selected).firstOrNull;

    return ListDetailLayout(
      detail: selected?.detail(),
      emptyDetailText: l10n.coachNothingSelected,
      listBuilder: (context, split) => CustomScrollView(slivers: [
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
        if (cards.isEmpty)
          SliverToBoxAdapter(
              child: EmptyState(
                  icon: Icons.description_outlined,
                  title: l10n.coachNoTemplates))
        else
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
            // Cards are as tall as their text; beside a detail pane two
            // share a row and match heights, phones show one per row.
            sliver: SliverList.separated(
              itemCount: (cards.length / (split ? 2 : 1)).ceil(),
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, row) {
                final perRow = split ? 2 : 1;
                Widget cell(int index) {
                  if (index >= cards.length) return const SizedBox.shrink();
                  final card = cards[index];
                  return GestureDetector(
                    onTap: () => _open(context, card.detail, card.key, split),
                    child: card.card(split ? 4 / 3 : 2),
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
      ]),
    );
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

class _ProgramDetail extends StatelessWidget {
  const _ProgramDetail({required this.program});
  final CoachProgram program;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(program.title)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        children: [
          Text(program.description, style: theme.textTheme.bodyLarge),
          const SizedBox(height: 16),
          for (var i = 0; i < program.prompts.length; i++)
            Card.outlined(
              child: ListTile(
                leading: CircleAvatar(child: Text('${i + 1}')),
                title: Text(program.prompts[i]),
                trailing: FilledButton.tonal(
                  key: ValueKey('coach-prompt-$i'),
                  onPressed: () => EntryNavigation.edit(context, null,
                      initialPrompt: program.prompts[i]),
                  child: Text(l10n.coachWritePrompt),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _TemplateDetail extends StatelessWidget {
  const _TemplateDetail({required this.template});
  final Template template;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(template.name)),
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
