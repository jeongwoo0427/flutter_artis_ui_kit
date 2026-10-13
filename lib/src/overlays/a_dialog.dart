import 'package:flutter/material.dart';

import '../theme/a_theme_data.dart';

const double _maxWidth = 400;
const double _padding = 24;

/// 제목 · 본문 · 나란한 버튼으로 된 다이얼로그. `showDialog` 의 builder 에서 쓴다.
///
/// 배경 · 모서리는 `dialogTheme` 을 따른다. [actions] 는 같은 폭으로 한 줄에 놓인다.
/// 버튼은 호출하는 쪽이 만드므로 폼 다이얼로그의 "확인 가능 여부 · 처리 중" 은
/// 버튼의 `onPressed: null` · 로딩 표시로 직접 다룬다.
///
/// ```dart
/// showDialog<void>(
///   context: context,
///   builder: (context) => ADialog(
///     title: const Text('이름 바꾸기'),
///     content: TextField(controller: controller),
///     actions: [
///       FilledButton(onPressed: canSave ? save : null, child: const Text('저장')),
///     ],
///   ),
/// );
/// ```
class ADialog extends StatelessWidget {
  /// 다이얼로그를 만든다.
  const ADialog({
    super.key,
    this.title,
    this.content,
    required this.actions,
    this.scrollable = false,
  });

  /// 제목(`headlineSmall`).
  final Widget? title;

  /// 본문(`bodyLarge`, 보조 글자색).
  final Widget? content;

  /// 아래쪽 버튼들 — 같은 폭으로 나란히.
  final List<Widget> actions;

  /// 본문이 길 때 본문만 스크롤한다.
  final bool scrollable;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final a = AThemeData.of(context);
    final dialogTheme = theme.dialogTheme;

    Widget? body;
    if (content != null) {
      body = DefaultTextStyle.merge(
        style:
            dialogTheme.contentTextStyle ??
            theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
        child: content!,
      );
      if (scrollable) {
        body = Flexible(child: SingleChildScrollView(child: body));
      }
    }

    return Dialog(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: _maxWidth),
        child: Padding(
          padding: const EdgeInsets.all(_padding),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (title != null)
                Semantics(
                  header: true,
                  child: DefaultTextStyle.merge(
                    style:
                        dialogTheme.titleTextStyle ??
                        theme.textTheme.headlineSmall,
                    child: title!,
                  ),
                ),
              if (title != null && body != null) SizedBox(height: a.spacing.sm),
              ?body,
              if (actions.isNotEmpty) ...[
                SizedBox(height: a.spacing.xxl),
                Row(
                  spacing: a.spacing.sm,
                  children: [
                    for (final action in actions) Expanded(child: action),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// 확인 / 취소 다이얼로그를 띄운다. 확인을 눌렀을 때만 `true`, 취소 · 바깥 누름은 `false`.
///
/// [cancelLabel] 을 비우면 `MaterialLocalizations.cancelButtonLabel` 을 쓴다.
/// [destructive] 면 확인 버튼이 `colorScheme.error` 색이다.
///
/// ```dart
/// if (await showAConfirmDialog(context,
///     title: const Text('폴더를 삭제할까요?'), confirmLabel: '삭제', destructive: true)) {
///   delete();
/// }
/// ```
Future<bool> showAConfirmDialog(
  BuildContext context, {
  required Widget title,
  Widget? content,
  required String confirmLabel,
  String? cancelLabel,
  bool destructive = false,
}) async {
  final cs = Theme.of(context).colorScheme;
  final cancel =
      cancelLabel ?? MaterialLocalizations.of(context).cancelButtonLabel;
  final result = await showDialog<bool>(
    context: context,
    builder: (context) => ADialog(
      title: title,
      content: content,
      actions: [
        FilledButton.tonal(
          onPressed: () => Navigator.of(context).pop(false),
          style: FilledButton.styleFrom(
            backgroundColor: cs.secondaryContainer,
            foregroundColor: cs.onSecondaryContainer,
          ),
          child: Text(cancel),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(true),
          style: destructive
              ? FilledButton.styleFrom(
                  backgroundColor: cs.error,
                  foregroundColor: cs.onError,
                )
              : null,
          child: Text(confirmLabel),
        ),
      ],
    ),
  );
  return result ?? false;
}
