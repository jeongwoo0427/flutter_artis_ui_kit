import 'package:flutter/painting.dart';
import 'package:flutter/foundation.dart';

import 'contrast.dart';

const _white = Color(0xFFFFFFFF);

/// 앱의 강조색 한 벌. 이 값만 바꾸면 테마 전체의 강조색이 바뀐다.
///
/// ```dart
/// final tone = ATone.fromBrand(const Color(0xFF3182F6));
/// ```
@immutable
class ATone {
  /// 네 값을 직접 지정한다. 손으로 맞춘 프리셋에 쓴다.
  const ATone({
    required this.brand,
    required this.primary,
    required this.primaryPressed,
    required this.ink,
  });

  /// 브랜드 색 하나로 나머지를 계산한다.
  /// [primary] 와 [ink] 는 흰 바탕(또는 연한 강조 면) 대비 4.5:1 을 만족하도록 어둡게 맞춘다.
  factory ATone.fromBrand(Color brand) {
    final primary = darkenToContrast(brand, _white, 4.5);
    final weak = Color.alphaBlend(brand.withValues(alpha: 0.11), _white);
    return ATone(
      brand: brand,
      primary: primary,
      primaryPressed: HSLColor.fromColor(primary)
          .withLightness(
            (HSLColor.fromColor(primary).lightness - 0.08).clamp(0.0, 1.0),
          )
          .toColor(),
      ink: darkenToContrast(brand, weak, 4.5),
    );
  }

  /// 글자가 올라가지 않는 면 — 진행도 · 선택 테두리 · 라디오 · 링. 대비 제약이 없다.
  final Color brand;

  /// 흰 글자가 올라가는 버튼 면(흰 글자 대비 4.5:1 이상).
  final Color primary;

  /// [primary] 를 눌렀을 때.
  final Color primaryPressed;

  /// 연한 강조 면(`primaryContainer`) 위 글자 · 아이콘.
  final Color ink;

  @override
  bool operator ==(Object other) =>
      other is ATone &&
      other.brand == brand &&
      other.primary == primary &&
      other.primaryPressed == primaryPressed &&
      other.ink == ink;

  @override
  int get hashCode => Object.hash(brand, primary, primaryPressed, ink);
}
