import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../theme/a_theme_data.dart';

const double _chipHeight = 32;
const double _chipPaddingHorizontal = 11;
const double _gap = 2;
const double _chevronSize = 14;
const Duration _scrollDuration = Duration(milliseconds: 300);

/// 폴더 경로를 칩으로 보여 주는 가로 스크롤 브레드크럼. `items[0]` 이 루트, 마지막이 지금 위치다.
///
/// 지금 위치 칩은 강조되고 누를 수 없다. 경로가 바뀌면 끝(지금 위치)으로 스크롤한다.
///
/// ```dart
/// ABreadcrumb(items: const ['🏠 문제은행', '영어', '중3'], onTap: (i) => goTo(i))
/// ```
class ABreadcrumb extends StatefulWidget {
  /// [items] 경로를 칩으로 그린다.
  const ABreadcrumb({super.key, required this.items, this.onTap})
    : assert(items.length > 0);

  /// 루트부터 지금 위치까지의 이름.
  final List<String> items;

  /// 지금 위치가 아닌 칩을 눌렀을 때 그 index. `null` 이면 누를 수 없다.
  final ValueChanged<int>? onTap;

  @override
  State<ABreadcrumb> createState() => _ABreadcrumbState();
}

class _ABreadcrumbState extends State<ABreadcrumb> {
  final ScrollController _scroll = ScrollController();

  @override
  void initState() {
    super.initState();
    // 처음 그릴 때도 지금 위치(마지막 칩)가 보여야 한다 — 폴더마다 새 화면이라 매번 처음이다.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && _scroll.hasClients) {
        _scroll.jumpTo(_scroll.position.maxScrollExtent);
      }
    });
  }

  @override
  void didUpdateWidget(ABreadcrumb oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (listEquals(oldWidget.items, widget.items)) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !_scroll.hasClients) return;
      final end = _scroll.position.maxScrollExtent;
      if (MediaQuery.disableAnimationsOf(context)) {
        _scroll.jumpTo(end);
      } else {
        _scroll.animateTo(
          end,
          duration: _scrollDuration,
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final a = AThemeData.of(context);
    final style = theme.textTheme.bodyMedium?.copyWith(
      fontSize: 14,
      fontWeight: FontWeight.w600,
    );
    final last = widget.items.length - 1;

    return SingleChildScrollView(
      controller: _scroll,
      scrollDirection: Axis.horizontal,
      padding: EdgeInsetsDirectional.symmetric(horizontal: a.spacing.screen),
      child: Row(
        spacing: _gap,
        children: [
          for (var i = 0; i <= last; i++) ...[
            if (i > 0)
              Icon(Icons.chevron_right, size: _chevronSize, color: cs.outline),
            if (i == last)
              Semantics(
                selected: true,
                child: Container(
                  constraints: const BoxConstraints(minHeight: _chipHeight),
                  padding: const EdgeInsetsDirectional.symmetric(
                    horizontal: _chipPaddingHorizontal,
                  ),
                  alignment: Alignment.center,
                  decoration: ShapeDecoration(
                    color: cs.primaryContainer,
                    shape: const StadiumBorder(),
                  ),
                  child: Text(
                    widget.items[i],
                    maxLines: 1,
                    style: style?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: cs.onPrimaryContainer,
                    ),
                  ),
                ),
              )
            else
              TextButton(
                onPressed: widget.onTap == null ? null : () => widget.onTap!(i),
                style: TextButton.styleFrom(
                  // 보이는 칩은 32, 누르는 영역은 48.
                  minimumSize: const Size(0, _chipHeight),
                  tapTargetSize: MaterialTapTargetSize.padded,
                  padding: const EdgeInsetsDirectional.symmetric(
                    horizontal: _chipPaddingHorizontal,
                  ),
                  shape: const StadiumBorder(),
                  backgroundColor: a.card,
                  disabledBackgroundColor: a.card,
                  foregroundColor: cs.onSurfaceVariant,
                  disabledForegroundColor: cs.onSurfaceVariant,
                  textStyle: style,
                ),
                child: Text(widget.items[i], maxLines: 1),
              ),
          ],
        ],
      ),
    );
  }
}
