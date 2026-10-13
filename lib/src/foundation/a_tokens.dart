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
