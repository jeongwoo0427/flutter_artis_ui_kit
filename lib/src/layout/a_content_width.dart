import 'package:flutter/widgets.dart';

/// 넓은 창에서 본문이 끝없이 늘어나지 않게 가운데 두고 최대 폭을 제한한다.
///
/// ```dart
/// AContentWidth(maxWidth: AContentWidth.list, child: ListView(...))
/// ```
class AContentWidth extends StatelessWidget {
  /// [child] 를 위쪽 가운데에 두고 폭을 [maxWidth] 이하로 제한한다.
  const AContentWidth({
    super.key,
    required this.child,
    this.maxWidth = reading,
  });

  /// 읽는 화면(문제 풀이 · 결과) 폭.
  static const double reading = 640;

  /// 목록 화면 폭.
  static const double list = 720;

  /// 두 칸 · 대시보드 폭.
  static const double wide = 1040;

  /// 제한할 내용.
  final Widget child;

  /// 최대 폭(논리 픽셀).
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional.topCenter,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: child,
      ),
    );
  }
}
