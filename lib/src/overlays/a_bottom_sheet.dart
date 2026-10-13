import 'package:flutter/material.dart';

import '../theme/a_theme_data.dart';

const double _sideInset = 22;
const Size _handleSize = Size(40, 4);
const double _handleRadius = 2;
const double _maxHeightFactor = 0.85;
const double _actionRowMinHeight = 56;

/// 핸들 · 제목 · 부제 · 본문 · 하단 버튼으로 된 바텀시트를 띄운다.
///
/// 내부는 표준 `showModalBottomSheet` — 모양 · 최대 폭 · 색은 `bottomSheetTheme` 이 정한다.
/// [useRootNavigator] 기본값이 `true` 라 떠 있는 하단 탭바 위로 올라온다.
/// [builder] 의 context 로 `Navigator.pop(context, value)` 하면 그 값이 결과가 된다.
///
/// ```dart
/// final name = await showABottomSheet<String>(
///   context,
///   title: const Text('무엇을 추가할까요?'),
///   builder: (context) => FolderPicker(onPicked: (v) => Navigator.pop(context, v)),
/// );
/// ```
Future<T?> showABottomSheet<T>(
  BuildContext context, {
  Widget? title,
  Widget? subtitle,
  required WidgetBuilder builder,
  Widget? action,
  bool isScrollControlled = true,
  bool useRootNavigator = true,
}) {
  return showModalBottomSheet<T>(
    context: context,
    isScrollControlled: isScrollControlled,
    useRootNavigator: useRootNavigator,
    builder: (context) => ABottomSheetScaffold(
      title: title,
      subtitle: subtitle,
      action: action,
      child: builder(context),
    ),
  );
}

/// 바텀시트 안쪽 틀 — 핸들, 제목, 부제, 본문, 하단 [action].
///
/// 화면 높이의 85% 를 넘으면 제목 · 본문이 스크롤되고 [action] 은 아래에 남는다.
/// 그래서 [child] 는 스스로 무한히 늘어나는 스크롤 뷰가 아니어야 한다(`ListView` 라면 `shrinkWrap`).
/// 키보드가 올라오면 그만큼 위로 밀린다.
class ABottomSheetScaffold extends StatelessWidget {
  /// 틀을 만든다.
  const ABottomSheetScaffold({
    super.key,
    this.title,
    this.subtitle,
    required this.child,
    this.action,
  });

  /// 제목(`headlineSmall`).
  final Widget? title;

  /// 제목 아래 설명(`bodyMedium`, 보조 글자색).
  final Widget? subtitle;

  /// 본문.
  final Widget child;

  /// 맨 아래 위젯 — 보통 꽉 찬 폭의 버튼 하나.
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final a = AThemeData.of(context);
    final media = MediaQuery.of(context);

    return Padding(
      padding: EdgeInsets.only(bottom: media.viewInsets.bottom),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: media.size.height * _maxHeightFactor,
        ),
        child: SafeArea(
          top: false,
          minimum: EdgeInsets.only(bottom: a.spacing.xxl),
          child: Padding(
            padding: EdgeInsetsDirectional.only(
              start: _sideInset,
              end: _sideInset,
              top: a.spacing.md,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Container(
                    width: _handleSize.width,
                    height: _handleSize.height,
                    margin: EdgeInsets.only(bottom: a.spacing.lg),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(_handleRadius),
                    ),
                  ),
                ),
                Flexible(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        if (title != null)
                          Semantics(
                            header: true,
                            child: DefaultTextStyle.merge(
                              style: theme.textTheme.headlineSmall,
                              child: title!,
                            ),
                          ),
                        if (subtitle != null)
                          Padding(
                            padding: EdgeInsets.only(top: a.spacing.xs),
                            child: DefaultTextStyle.merge(
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                              child: subtitle!,
                            ),
                          ),
                        if (title != null || subtitle != null)
                          SizedBox(height: a.spacing.md),
                        child,
                      ],
                    ),
                  ),
                ),
                if (action != null) ...[
                  SizedBox(height: a.spacing.lg),
                  action!,
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// [showAActionSheet] 의 한 줄.
@immutable
class AActionSheetItem<T> {
  /// 한 줄을 만든다.
  const AActionSheetItem({
    required this.label,
    required this.value,
    this.icon,
    this.destructive = false,
    this.subtitle,
  });

  /// 이름.
  final String label;

  /// 눌렀을 때 시트가 돌려주는 값.
  final T value;

  /// 앞쪽 아이콘.
  final Widget? icon;

  /// 삭제처럼 되돌리기 어려운 동작 — 아이콘 · 이름이 `colorScheme.error`.
  final bool destructive;

  /// 이름 아래 한 줄 설명.
  final String? subtitle;
}

/// 고를 수 있는 동작 목록을 시트로 띄우고, 누른 줄의 [AActionSheetItem.value] 를 돌려준다.
///
/// 바깥을 누르거나 끌어내려 닫으면 `null`.
///
/// ```dart
/// final action = await showAActionSheet<String>(context, items: const [
///   AActionSheetItem(label: '이름 바꾸기', value: 'rename', icon: Icon(Icons.edit)),
///   AActionSheetItem(label: '삭제', value: 'delete', icon: Icon(Icons.delete), destructive: true),
/// ]);
/// ```
Future<T?> showAActionSheet<T>(
  BuildContext context, {
  Widget? title,
  required List<AActionSheetItem<T>> items,
}) {
  return showABottomSheet<T>(
    context,
    title: title,
    builder: (context) => Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [for (final item in items) _ActionRow<T>(item)],
    ),
  );
}

class _ActionRow<T> extends StatelessWidget {
  const _ActionRow(this.item);

  final AActionSheetItem<T> item;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final a = AThemeData.of(context);
    final cs = theme.colorScheme;
    final iconColor = item.destructive ? cs.error : cs.onSurfaceVariant;
    final labelColor = item.destructive ? cs.error : cs.onSurface;

    return Semantics(
      button: true,
      child: InkWell(
        onTap: () => Navigator.of(context).pop(item.value),
        borderRadius: BorderRadius.circular(a.radii.md),
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: _actionRowMinHeight),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: a.spacing.md),
            child: Row(
              children: [
                if (item.icon != null) ...[
                  IconTheme.merge(
                    data: IconThemeData(color: iconColor),
                    child: item.icon!,
                  ),
                  SizedBox(width: a.spacing.md),
                ],
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        item.label,
                        style: theme.textTheme.titleSmall?.copyWith(
                          color: labelColor,
                        ),
                      ),
                      if (item.subtitle != null)
                        Text(item.subtitle!, style: theme.textTheme.bodySmall),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
