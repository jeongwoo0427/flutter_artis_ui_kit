import 'package:flutter/painting.dart';
import 'package:flutter/material.dart' show TextTheme;

/// 글자 역할 → [TextTheme]. 크기 · 굵기 · 자간이 한 곳에 있다.
///
/// 큰 숫자(`displayLarge` · `displaySmall`)는 자릿수가 흔들리지 않게 고정폭 숫자를 쓴다.
TextTheme aTextTheme({
  required Color text,
  required Color textSecondary,
  String? fontFamily,
}) {
  TextStyle s(
    double size,
    FontWeight weight, {
    double letterSpacing = 0,
    double? height,
    Color? color,
    bool tabular = false,
  }) => TextStyle(
    fontFamily: fontFamily,
    fontSize: size,
    fontWeight: weight,
    letterSpacing: letterSpacing,
    height: height,
    color: color ?? text,
    fontFeatures: tabular ? const [FontFeature.tabularFigures()] : null,
  );

  return TextTheme(
    displayLarge: s(
      76,
      FontWeight.w800,
      letterSpacing: -3.8,
      height: 1.1,
      tabular: true,
    ),
    displayMedium: s(44, FontWeight.w800, letterSpacing: -1.6, tabular: true),
    displaySmall: s(31, FontWeight.w800, letterSpacing: -1.1, tabular: true),
    headlineLarge: s(26, FontWeight.w800, letterSpacing: -0.9, height: 1.3),
    headlineMedium: s(25, FontWeight.w700, letterSpacing: -0.9, height: 1.42),
    headlineSmall: s(22, FontWeight.w800, letterSpacing: -0.8, height: 1.3),
    titleLarge: s(18, FontWeight.w700, letterSpacing: -0.5),
    titleMedium: s(17, FontWeight.w700, letterSpacing: -0.3),
    titleSmall: s(16, FontWeight.w600, letterSpacing: -0.2),
    bodyLarge: s(16, FontWeight.w500, letterSpacing: -0.2, height: 1.5),
    // bodyMedium 은 Text 의 기본 스타일이라 본문 색(text)을 쓴다 — 회색으로 두면 모든 Text 가 흐려진다.
    bodyMedium: s(15, FontWeight.w500, letterSpacing: -0.2, height: 1.5),
    bodySmall: s(13.5, FontWeight.w500, height: 1.4, color: textSecondary),
    labelLarge: s(15, FontWeight.w700),
    labelMedium: s(12.5, FontWeight.w700),
    labelSmall: s(11, FontWeight.w600),
  );
}
