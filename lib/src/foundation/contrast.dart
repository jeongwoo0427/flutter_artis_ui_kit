import 'dart:math' as math;

import 'package:flutter/painting.dart';

/// 두 색의 WCAG 2.x 명도 대비(1 ~ 21). 본문 글자는 4.5 이상, 큰 글자는 3 이상이 기준이다.
double contrastRatio(Color a, Color b) {
  final la = a.computeLuminance();
  final lb = b.computeLuminance();
  return (math.max(la, lb) + 0.05) / (math.min(la, lb) + 0.05);
}

/// [color] 를 HSL 명도만 낮춰 [background] 와의 대비가 [target] 이상이 되는 첫 색을 돌려준다.
/// 이미 만족하면 그대로 돌려준다.
Color darkenToContrast(Color color, Color background, double target) {
  var hsl = HSLColor.fromColor(color);
  while (contrastRatio(hsl.toColor(), background) < target &&
      hsl.lightness > 0) {
    hsl = hsl.withLightness(math.max(0, hsl.lightness - 0.01));
  }
  return hsl.toColor();
}
