import 'package:flutter/painting.dart';
import 'package:flutter/foundation.dart';

import 'contrast.dart';

const _white = Color(0xFFFFFFFF);
const _nearBlack = Color(0xFF191919);

/// 앱의 강조색 한 벌. 이 값만 바꾸면 테마 전체의 강조색이 바뀐다.
///
/// ```dart
/// final tone = ATone.fromBrand(const Color(0xFF3182F6));
/// ```
@immutable
class ATone {
  /// 값을 직접 지정한다. 손으로 맞춘 프리셋에 쓴다.
  const ATone({
    required this.brand,
    required this.primary,
    required this.primaryPressed,
    required this.ink,
    this.brandFill = false,
    this.onBrand = _white,
    this.containerAlpha = 0.16,
  }) : assert(0 < containerAlpha && containerAlpha < 1);

  /// 브랜드 색 하나로 나머지를 계산한다.
  /// [primary] 와 [ink] 는 흰 바탕(또는 연한 강조 면) 대비 4.5:1 을 만족하도록 어둡게 맞춘다.
  ///
  /// [brandFill] 이면 버튼처럼 색이 채워진 면을 어둡게 맞춘 [primary] 가 아니라 **브랜드 색 그대로** 칠하고,
  /// 그 위 글자는 [onBrand](흰색 · 검정 중 대비가 큰 쪽)로 쓴다 — 노랑처럼 밝은 브랜드용.
  /// [containerAlpha] 는 연한 강조 면(`primaryContainer`)에 섞는 브랜드 비율(다크는 +0.06).
  factory ATone.fromBrand(
    Color brand, {
    bool brandFill = false,
    double containerAlpha = 0.16,
  }) {
    final primary = darkenToContrast(brand, _white, 4.5);
    final weak = Color.alphaBlend(
      brand.withValues(alpha: containerAlpha),
      _white,
    );
    return ATone(
      brand: brand,
      brandFill: brandFill,
      containerAlpha: containerAlpha,
      onBrand: contrastRatio(brand, _white) >= contrastRatio(brand, _nearBlack)
          ? _white
          : _nearBlack,
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

  /// 색이 채워진 강조 면(버튼 · 강조 카드)을 [brand] 그대로 칠할지. `false` 면 [primary] + 흰 글자.
  final bool brandFill;

  /// [brandFill] 면 위 글자 · 아이콘.
  final Color onBrand;

  /// 연한 강조 면에 섞는 브랜드 비율(라이트). 다크는 여기에 0.06 을 더한다.
  final double containerAlpha;

  @override
  bool operator ==(Object other) =>
      other is ATone &&
      other.brand == brand &&
      other.primary == primary &&
      other.primaryPressed == primaryPressed &&
      other.ink == ink &&
      other.brandFill == brandFill &&
      other.onBrand == onBrand &&
      other.containerAlpha == containerAlpha;

  @override
  int get hashCode => Object.hash(
    brand,
    primary,
    primaryPressed,
    ink,
    brandFill,
    onBrand,
    containerAlpha,
  );
}
