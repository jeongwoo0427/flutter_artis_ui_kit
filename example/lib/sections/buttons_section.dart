import 'package:flutter/material.dart';
import 'package:flutter_artis_ui_kit/flutter_artis_ui_kit.dart';

/// AButton — 변형 × 크기 × 상태(기본 · 아이콘 · 로딩 · 비활성).
List<Widget> buttonsSection(BuildContext context) {
  final a = AThemeData.of(context);
  final caption = Theme.of(context).textTheme.bodySmall;
  void noop() {}

  Widget label(String text) => Text(text, style: caption);
  Widget wrap(List<Widget> children) =>
      Wrap(spacing: a.spacing.sm, runSpacing: a.spacing.sm, children: children);

  return [
    label('Large (full width)'),
    SizedBox(
      width: double.infinity,
      child: AButton(onPressed: noop, child: const Text('Primary')),
    ),
    SizedBox(
      width: double.infinity,
      child: AButton.tonal(onPressed: noop, child: const Text('Tonal')),
    ),
    SizedBox(
      width: double.infinity,
      child: AButton.neutral(onPressed: noop, child: const Text('Neutral')),
    ),
    SizedBox(
      width: double.infinity,
      child: AButton.danger(onPressed: noop, child: const Text('Danger')),
    ),
    SizedBox(
      width: double.infinity,
      child: AButton(
        onPressed: noop,
        isLoading: true,
        child: const Text('Loading'),
      ),
    ),
    const SizedBox(
      width: double.infinity,
      child: AButton(onPressed: null, child: Text('Disabled')),
    ),
    label('Two buttons side by side'),
    Row(
      spacing: a.spacing.sm,
      children: [
        Expanded(
          child: AButton.neutral(onPressed: noop, child: const Text('Cancel')),
        ),
        Expanded(
          child: AButton(onPressed: noop, child: const Text('Confirm')),
        ),
      ],
    ),
    label('Medium'),
    wrap([
      AButton(
        onPressed: noop,
        size: AButtonSize.medium,
        icon: const Icon(Icons.add),
        child: const Text('Add'),
      ),
      AButton.tonal(
        onPressed: noop,
        size: AButtonSize.medium,
        icon: const Icon(Icons.share),
        child: const Text('Share'),
      ),
      AButton.neutral(
        onPressed: noop,
        size: AButtonSize.medium,
        child: const Text('Neutral'),
      ),
      AButton.danger(
        onPressed: noop,
        size: AButtonSize.medium,
        isLoading: true,
        child: const Text('Delete'),
      ),
      const AButton(
        onPressed: null,
        size: AButtonSize.medium,
        child: Text('Disabled'),
      ),
    ]),
    label('Small'),
    wrap([
      AButton(
        onPressed: noop,
        size: AButtonSize.small,
        child: const Text('Primary'),
      ),
      AButton.tonal(
        onPressed: noop,
        size: AButtonSize.small,
        child: const Text('Tonal'),
      ),
      AButton.neutral(
        onPressed: noop,
        size: AButtonSize.small,
        child: const Text('Neutral'),
      ),
      const AButton.neutral(
        onPressed: null,
        size: AButtonSize.small,
        child: Text('Disabled'),
      ),
    ]),
    label('Text'),
    wrap([
      AButton.text(
        onPressed: noop,
        size: AButtonSize.medium,
        child: const Text('More'),
      ),
      AButton.text(
        onPressed: noop,
        size: AButtonSize.small,
        isLoading: true,
        child: const Text('Save'),
      ),
      const AButton.text(
        onPressed: null,
        size: AButtonSize.medium,
        child: Text('Disabled'),
      ),
    ]),
  ];
}
