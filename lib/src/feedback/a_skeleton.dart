import 'package:flutter/material.dart';

import '../theme/a_theme_data.dart';

/// 불러오는 동안 내용 자리를 채우는 반짝이는 블록.
///
/// 애니메이션 줄이기 설정(`MediaQuery.disableAnimationsOf`)이 켜져 있으면 움직이지 않는다.
///
/// ```dart
/// const ASkeleton(width: 120, height: 16)
/// ```
class ASkeleton extends StatefulWidget {
  /// 사각 블록. [width] 가 없으면 부모 폭을 채운다.
  const ASkeleton({super.key, this.width, required this.height, this.radius});

  /// 원(아바타 자리).
  const ASkeleton.circle(double size, {super.key})
    : width = size,
      height = size,
      radius = size / 2;

  /// 폭. `null` 이면 부모 폭.
  final double? width;

  /// 높이.
  final double height;

  /// 모서리 반경. 기본은 `radii.sm`.
  final double? radius;

  @override
  State<ASkeleton> createState() => _ASkeletonState();
}

class _ASkeletonState extends State<ASkeleton>
    with SingleTickerProviderStateMixin {
  static const _period = Duration(milliseconds: 1400);

  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: _period,
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.disableAnimationsOf(context)) {
      _controller.stop();
    } else if (!_controller.isAnimating) {
      _controller.repeat();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final a = AThemeData.of(context);
    final base = cs.surfaceContainer;
    final highlight = cs.surfaceContainerLowest;
    final radius = BorderRadius.circular(widget.radius ?? a.radii.sm);
    final still = MediaQuery.disableAnimationsOf(context);

    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: still
          ? DecoratedBox(
              decoration: BoxDecoration(color: base, borderRadius: radius),
            )
          : AnimatedBuilder(
              animation: _controller,
              builder: (context, _) => DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: radius,
                  gradient: LinearGradient(
                    colors: [base, highlight, base],
                    stops: const [0.25, 0.5, 0.75],
                    transform: _Slide(_controller.value),
                  ),
                ),
              ),
            ),
    );
  }
}

/// 그라디언트를 왼쪽 밖(-1)에서 오른쪽 밖(+1)까지 민다.
class _Slide extends GradientTransform {
  const _Slide(this.t);

  final double t;

  @override
  Matrix4 transform(Rect bounds, {TextDirection? textDirection}) {
    final dx = bounds.width * (t * 2 - 1);
    final sign = textDirection == TextDirection.rtl ? -1 : 1;
    return Matrix4.translationValues(dx * sign, 0, 0);
  }
}
