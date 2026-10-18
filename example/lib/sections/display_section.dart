import 'package:flutter/material.dart';
import 'package:flutter_artis_ui_kit/flutter_artis_ui_kit.dart';

/// 표시 · 선택 · 피드백 — 태그 · 이모지 타일 · 선택지 · 픽 카드 · 빈 상태 · 스켈레톤.
List<Widget> displaySection(BuildContext context) {
  final a = AThemeData.of(context);
  final s = a.semantic;
  Widget label(String text) =>
      Text(text, style: Theme.of(context).textTheme.labelMedium);

  return [
    label('ATag — neutral / primary / positive / negative / warning × size'),
    for (final size in ATagSize.values)
      Wrap(
        spacing: a.spacing.sm,
        runSpacing: a.spacing.sm,
        children: [
          ATag('Neutral', size: size),
          ATag.primary('Primary', size: size),
          ATag('Correct', color: s.positive, size: size),
          ATag('Wrong', color: s.negative, size: size),
          ATag(
            '120',
            color: s.warning,
            size: size,
            icon: const Icon(Icons.monetization_on),
          ),
        ],
      ),
    label('AEmojiTile — small / medium / large / hero · icon'),
    Wrap(
      spacing: a.spacing.sm,
      runSpacing: a.spacing.sm,
      crossAxisAlignment: WrapCrossAlignment.end,
      children: [
        for (final size in AEmojiTileSize.values)
          AEmojiTile(emoji: '📚', size: size),
        AEmojiTile.icon(
          icon: Icons.bolt,
          background: Theme.of(context).colorScheme.primaryContainer,
          iconColor: Theme.of(context).colorScheme.primary,
        ),
      ],
    ),
    label('AOptionTile — idle / selected / positive / negative'),
    AOptionTile.numbered(number: 1, label: const Text('Seoul'), onTap: () {}),
    AOptionTile.numbered(
      number: 2,
      label: const Text('Busan'),
      state: AOptionState.selected,
      onTap: () {},
    ),
    AOptionTile.numbered(
      number: 3,
      label: const Text('Incheon'),
      state: AOptionState.positive,
      trailing: Icon(Icons.check_circle, color: s.positive),
    ),
    AOptionTile.numbered(
      number: 4,
      label: const Text('Daegu'),
      state: AOptionState.negative,
      trailing: Icon(Icons.cancel, color: s.negative),
    ),
    AOptionTile(
      leading: const Text('🅰️'),
      label: const Text('Custom leading, no number'),
      onTap: () {},
    ),
    label(
      'ASegmentedControl — tap · drag the thumb · subtitle · disabled · Switch',
    ),
    const _SegmentedDemo(),
    label('APickCard — 2 columns'),
    Row(
      spacing: a.spacing.sm,
      children: [
        Expanded(
          child: APickCard(
            leading: const Text('📝'),
            title: const Text('Choice'),
            subtitle: const Text('Pick one'),
            selected: true,
            onTap: () {},
          ),
        ),
        Expanded(
          child: APickCard(
            leading: const Text('✏️'),
            title: const Text('Short answer'),
            subtitle: const Text('Type it'),
            onTap: () {},
          ),
        ),
      ],
    ),
    label('AEmptyState / AEmptyState.inline'),
    AEmptyState(
      icon: const AEmojiTile(emoji: '📭', size: AEmojiTileSize.large),
      title: const Text('No quizzes yet'),
      message: const Text('Create your first question.'),
      action: FilledButton(onPressed: () {}, child: const Text('Create')),
    ),
    const AEmptyState.inline(
      icon: AEmojiTile(emoji: '👀'),
      title: Text('Nothing to preview'),
      message: Text('Add questions to see them here.'),
    ),
    label('ASkeleton'),
    Row(
      spacing: a.spacing.md,
      children: [
        const ASkeleton.circle(44),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: a.spacing.sm,
            children: const [
              ASkeleton(height: 16),
              ASkeleton(width: 120, height: 12),
            ],
          ),
        ),
      ],
    ),
  ];
}

class _SegmentedDemo extends StatefulWidget {
  const _SegmentedDemo();

  @override
  State<_SegmentedDemo> createState() => _SegmentedDemoState();
}

class _SegmentedDemoState extends State<_SegmentedDemo> {
  var _kind = 0;
  var _style = 0;
  var _on = true;

  @override
  Widget build(BuildContext context) {
    final a = AThemeData.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: a.spacing.sm,
      children: [
        ASegmentedControl<int>(
          segments: const [
            ASegment(
              value: 0,
              label: Text('Paper'),
              subtitle: Text('A4 · all'),
            ),
            ASegment(
              value: 1,
              label: Text('Summary'),
              subtitle: Text('One page'),
            ),
          ],
          selected: _kind,
          onChanged: (v) => setState(() => _kind = v),
        ),
        ASegmentedControl<int>(
          segments: const [
            ASegment(value: 0, label: Text('All')),
            ASegment(value: 1, label: Text('Wrong')),
            ASegment(value: 2, label: Text('Locked'), enabled: false),
          ],
          selected: _style,
          onChanged: (v) => setState(() => _style = v),
        ),
        Row(
          children: [
            const Expanded(child: Text('Intrinsic width in a Row')),
            ASegmentedControl<int>(
              segments: const [
                ASegment(value: 0, label: Text('Basic')),
                ASegment(value: 1, label: Text('Exam')),
              ],
              selected: _style.clamp(0, 1),
              onChanged: (v) => setState(() => _style = v),
            ),
          ],
        ),
        Row(
          children: [
            const Expanded(child: Text('Switch (theme)')),
            Switch(value: _on, onChanged: (v) => setState(() => _on = v)),
            const Switch(value: false, onChanged: null),
          ],
        ),
      ],
    );
  }
}
