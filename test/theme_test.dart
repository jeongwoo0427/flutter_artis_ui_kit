import 'package:flutter/material.dart';
import 'package:flutter_artis_ui_kit/flutter_artis_ui_kit.dart';
import 'package:flutter_test/flutter_test.dart';

const _white = Color(0xFFFFFFFF);

void main() {
  group('ATone.fromBrand', () {
    // 대비가 낮은 밝은 브랜드색들 — primary 를 어둡게 맞춰야 한다.
    const brands = [
      Color(0xFF3182F6),
      Color(0xFF00B8A9),
      Color(0xFFFF6B5A),
      Color(0xFFFF7A1A),
      Color(0xFFFFD43B),
    ];

    for (final brand in brands) {
      test('${brand.toARGB32().toRadixString(16)} — 흰 글자 4.5:1', () {
        final tone = ATone.fromBrand(brand);
        expect(contrastRatio(tone.primary, _white), greaterThanOrEqualTo(4.5));
        final weak = Color.alphaBlend(brand.withValues(alpha: 0.16), _white);
        expect(contrastRatio(tone.ink, weak), greaterThanOrEqualTo(4.5));
        expect(tone.brand, brand);
      });
    }
  });

  group('AThemeBuilder', () {
    final tone = ATone.fromBrand(const Color(0xFF3182F6));

    test('보조 역할이 다른 역할로 떨어지지 않는다', () {
      for (final theme in [
        AThemeBuilder.light(tone: tone),
        AThemeBuilder.dark(tone: tone),
      ]) {
        final cs = theme.colorScheme;
        expect(cs.onSurfaceVariant, isNot(cs.onSurface));
        expect(cs.surfaceContainerHighest, isNot(cs.surface));
        expect(cs.errorContainer, isNot(cs.error));
        expect(cs.inverseSurface, isNot(cs.onSurface));
      }
    });

    test('밝기 · 확장 · 톤', () {
      final light = AThemeBuilder.light(tone: tone);
      final dark = AThemeBuilder.dark(tone: tone);
      expect(light.brightness, Brightness.light);
      expect(dark.brightness, Brightness.dark);
      expect(light.colorScheme.primary, tone.primary);
      expect(light.extension<AThemeData>()?.brand, tone.brand);
      expect(dark.scaffoldBackgroundColor, ANeutrals.dark.page);
    });

    test('세그먼트 버튼 — 고른 칸은 연한 primary, 나머지는 투명', () {
      final theme = AThemeBuilder.light(tone: tone);
      final style = theme.segmentedButtonTheme.style!;
      expect(
        style.backgroundColor!.resolve({WidgetState.selected}),
        theme.colorScheme.primaryContainer,
      );
      expect(style.backgroundColor!.resolve({}), Colors.transparent);
    });

    testWidgets('확장이 없는 테마에서도 AThemeData.of 가 동작한다', (tester) async {
      late AThemeData data;
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              data = AThemeData.of(context);
              return const SizedBox();
            },
          ),
        ),
      );
      expect(data.radii.lg, 16);
    });
  });

  group('brandFill — 밝은 브랜드는 채운 면을 브랜드 그대로', () {
    const golden = Color(0xFFFFC800);

    test('채운 면 = 브랜드, 그 위 글자 = 대비 큰 쪽(검정), 글자 강조색은 4.5:1', () {
      final tone = ATone.fromBrand(golden, brandFill: true);
      final theme = AThemeBuilder.light(tone: tone);
      final a = theme.extension<AThemeData>()!;
      expect(a.primaryFill, golden);
      expect(contrastRatio(a.onPrimaryFill, a.primaryFill), greaterThan(7));
      // 글자로 쓰는 primary 는 그대로 흰 바탕 4.5:1
      expect(
        contrastRatio(theme.colorScheme.primary, const Color(0xFFFFFFFF)),
        greaterThanOrEqualTo(4.5),
      );
      final filled = theme.filledButtonTheme.style!;
      expect(filled.backgroundColor!.resolve({}), golden);
      expect(filled.foregroundColor!.resolve({}), a.onPrimaryFill);
    });

    test('다크에서는 브랜드 그대로가 글자 강조색 — 어두운 면에서 흐리지 않게', () {
      final tone = ATone.fromBrand(golden, brandFill: true);
      final dark = AThemeBuilder.dark(tone: tone);
      expect(dark.colorScheme.primary, golden);
      expect(
        contrastRatio(dark.colorScheme.primary, ANeutrals.dark.card),
        greaterThanOrEqualTo(4.5),
      );
      expect(dark.colorScheme.onPrimary, tone.onBrand);
    });

    test('기본(brandFill 없음)은 예전과 같다 — 채운 면 = primary + 흰 글자', () {
      final tone = ATone.fromBrand(const Color(0xFF3182F6));
      final theme = AThemeBuilder.light(tone: tone);
      final a = theme.extension<AThemeData>()!;
      expect(a.primaryFill, theme.colorScheme.primary);
      expect(a.onPrimaryFill, const Color(0xFFFFFFFF));
      expect(theme.filledButtonTheme.style!.backgroundColor, isNull);
    });

    test('containerAlpha 가 강조 면 진하기를 정한다(다크는 +0.06)', () {
      final tone = ATone.fromBrand(golden, containerAlpha: 0.2);
      final light = AThemeBuilder.light(tone: tone).colorScheme;
      final card = ANeutrals.light.card;
      expect(
        light.primaryContainer,
        Color.alphaBlend(golden.withValues(alpha: 0.2), card),
      );
      expect(
        contrastRatio(tone.ink, light.primaryContainer),
        greaterThanOrEqualTo(4.5),
      );
    });
  });
}
