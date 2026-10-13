import 'package:flutter/material.dart';
import 'package:flutter_artis_ui_kit/flutter_artis_ui_kit.dart';

/// ACard · ASectionCard · ASectionHeader · AListRow · AKeyValueRow · AStatGroup.
///
/// 갤러리 섹션이 이미 카드 안이라, 카드 데모는 페이지색(`page`) 위에 올려 경계를 보인다.
List<Widget> surfacesSection(BuildContext context) {
  final a = AThemeData.of(context);
  final cs = Theme.of(context).colorScheme;
  final caption = Theme.of(context).textTheme.bodySmall;
  void noop() {}

  Widget label(String text) => Text(text, style: caption);
  Widget onPage(Widget child) => DecoratedBox(
    decoration: BoxDecoration(
      color: a.page,
      borderRadius: BorderRadius.circular(a.radii.lg),
    ),
    child: Padding(padding: EdgeInsets.all(a.spacing.md), child: child),
  );
  Widget emoji(String e) => Text(e, style: const TextStyle(fontSize: 24));

  return [
    label('ACard — plain / tappable'),
    onPage(
      Column(
        spacing: a.spacing.md,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const ACard(child: Text('Plain card')),
          ACard(
            onTap: noop,
            onLongPress: noop,
            child: const Text('Tappable card — press to scale'),
          ),
        ],
      ),
    ),
    label('ASectionCard with count and trailing link'),
    onPage(
      ASectionCard(
        title: const Text('Folders'),
        count: const Text('3'),
        trailing: AButton.text(
          onPressed: noop,
          size: AButtonSize.small,
          child: const Text('All ›'),
        ),
        child: Column(
          children: [
            AListRow(
              leading: emoji('📘'),
              title: const Text('English vocabulary'),
              subtitle: const Text('48 questions · edited today'),
              showChevron: true,
              onTap: noop,
            ),
            AListRow(
              leading: emoji('🧪'),
              title: const Text('Science — selected row'),
              subtitle: const Text('12 questions'),
              selected: true,
              onTap: noop,
            ),
            AListRow(
              leading: emoji('📐'),
              title: const Text(
                'A very long title that wraps onto a second line and is then '
                'clipped with an ellipsis',
              ),
              trailing: const Text('128'),
              onTap: noop,
            ),
            const AListRow(title: Text('Not tappable')),
          ],
        ),
      ),
    ),
    label('ASectionHeader — page / group / field'),
    const ASectionHeader('Page title', variant: ASectionHeaderVariant.page),
    ASectionHeader(
      'Group',
      trailing: Icon(Icons.more_horiz, color: cs.outline),
    ),
    const ASectionHeader('Field label', variant: ASectionHeaderVariant.field),
    label('AKeyValueRow'),
    const AKeyValueRow(label: Text('Time limit'), value: Text('10 min')),
    const AKeyValueRow(
      label: Text('Questions'),
      value: Text('A long value that wraps to the next line, right aligned'),
    ),
    label('AStatGroup'),
    AStatGroup(
      stats: [
        const AStat(label: 'Solved', value: '1,284'),
        const AStat(label: 'Created', value: '156'),
        AStat(label: 'Active', value: '3', valueColor: cs.primary),
      ],
    ),
  ];
}
