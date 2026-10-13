import 'dart:ui' show Color;

import 'package:flutter/foundation.dart';

/// 모서리 반경 스케일.
@immutable
class ARadii {
  /// 기본 스케일.
  const ARadii({
    this.xs = 6,
    this.sm = 8,
    this.md = 12,
    this.lg = 16,
    this.xl = 20,
    this.xxl = 24,
    this.sheet = 28,
    this.full = 999,
  });

  /// 작은 배지.
  final double xs;

  /// 칩 · 작은 버튼.
  final double sm;

  /// 중간 버튼 · 타일.
  final double md;

  /// 큰 버튼 · 입력창 · 선택지.
  final double lg;

  /// 큰 카드형 버튼.
  final double xl;

  /// 카드 · 다이얼로그.
  final double xxl;

  /// 바텀시트 위쪽.
  final double sheet;

  /// 알약.
  final double full;
}

/// 간격 스케일.
@immutable
class ASpacing {
  /// 기본 스케일.
  const ASpacing({
    this.xs = 4,
    this.sm = 8,
    this.md = 12,
    this.lg = 16,
    this.xl = 20,
    this.xxl = 24,
    this.xxxl = 32,
    this.screen = 16,
    this.card = 20,
  });

  /// 4.
  final double xs;

  /// 8.
  final double sm;

  /// 12 — 카드 사이.
  final double md;

  /// 16.
  final double lg;

  /// 20.
  final double xl;

  /// 24.
  final double xxl;

  /// 32 — 큰 숫자 위아래.
  final double xxxl;

  /// 화면 좌우 여백.
  final double screen;

  /// 카드 안쪽 여백.
  final double card;
}

/// 움직임.
@immutable
class AMotion {
  /// 기본값.
  const AMotion({
    this.pressScale = 0.98,
    this.short = const Duration(milliseconds: 120),
    this.medium = const Duration(milliseconds: 200),
    this.long = const Duration(milliseconds: 360),
  });

  /// 눌렀을 때 줄어드는 비율.
  final double pressScale;

  /// 눌림 · 작은 전환.
  final Duration short;

  /// 선택 표시 이동 같은 중간 전환.
  final Duration medium;

  /// 화면 가장자리의 바가 들고 나는 것처럼 멀리 움직이는 전환.
  final Duration long;
}

/// 유리 면 — 하단 탭(`AFloatingNavigationBar`) · 상단 바(`AAppBar`)처럼 내용 위에 떠 있는 바가
/// 반투명 면 뒤로 지나가는 내용을 흐려 비치게 하는 값과 그 테두리. 흐림 · 테두리는 두 바가 같고,
/// 불투명도만 바마다 따로 둔다(상단 바는 글자가 많은 제목 줄이라 조금 더 불투명하게).
///
/// 불투명도가 낮을수록, [blurSigma] 가 작을수록 뒤 내용이 더 잘 보인다.
/// 테두리는 하단 탭은 늘 알약을 두르고, 상단 바는 내용이 바 밑으로 스크롤됐을 때만 아래에 나타난다.
class AGlass {
  /// 기본값.
  const AGlass({
    this.appBarOpacity = 0.70,
    this.navigationBarOpacity = 0.56,
    this.blurSigma = 12,
    this.borderColor,
    this.borderWidth = 1,
  }) : assert(0 <= appBarOpacity && appBarOpacity <= 1),
       assert(0 <= navigationBarOpacity && navigationBarOpacity <= 1),
       assert(blurSigma >= 0),
       assert(borderWidth >= 0);

  /// 유리를 끈다 — 불투명한 면, 흐림 없음(흐림이 부담스러운 기기용).
  static const AGlass none = AGlass(
    appBarOpacity: 1,
    navigationBarOpacity: 1,
    blurSigma: 0,
  );

  /// 상단 바(`AAppBar`) 면 색에 곱하는 불투명도. `1` 이면 뒤가 보이지 않는다.
  final double appBarOpacity;

  /// 하단 탭(`AFloatingNavigationBar`) 면 색에 곱하는 불투명도. `1` 이면 뒤가 보이지 않는다.
  final double navigationBarOpacity;

  /// 뒤 내용을 흐리는 정도(가우시안 sigma). `0` 이면 흐리지 않는다.
  final double blurSigma;

  /// 테두리 색. `null` 이면 글자색(`onSurface`)의 8%.
  final Color? borderColor;

  /// 테두리 두께. `0` 이면 테두리가 없다.
  final double borderWidth;

  @override
  bool operator ==(Object other) =>
      other is AGlass &&
      other.appBarOpacity == appBarOpacity &&
      other.navigationBarOpacity == navigationBarOpacity &&
      other.blurSigma == blurSigma &&
      other.borderColor == borderColor &&
      other.borderWidth == borderWidth;

  @override
  int get hashCode => Object.hash(
    appBarOpacity,
    navigationBarOpacity,
    blurSigma,
    borderColor,
    borderWidth,
  );
}
