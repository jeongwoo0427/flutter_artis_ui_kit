import 'package:flutter/material.dart';

import '../foundation/a_palette.dart';
import '../foundation/a_tokens.dart';
import '../foundation/a_tone.dart';
import '../foundation/a_typography.dart';
import 'a_theme_data.dart';

const _white = Color(0xFFFFFFFF);
const _black = Color(0xFF000000);

/// 톤 하나로 앱 전체 [ThemeData] 를 만든다.
///
/// `ColorScheme` 의 모든 역할을 채우고(정의 안 된 역할이 다른 역할로 떨어지지 않게),
/// 표준 Material 위젯의 컴포넌트 테마를 킷 모양으로 맞추고, [AThemeData] 를 확장으로 붙인다.
///
/// ```dart
/// MaterialApp(
///   theme: AThemeBuilder.light(tone: ATone.fromBrand(const Color(0xFF3182F6))),
///   darkTheme: AThemeBuilder.dark(tone: ATone.fromBrand(const Color(0xFF3182F6))),
/// )
/// ```
abstract final class AThemeBuilder {
  /// 라이트 테마.
  static ThemeData light({
    required ATone tone,
    String? fontFamily,
    ANeutrals neutrals = ANeutrals.light,
    ASemanticColors semantic = ASemanticColors.light,
    AGlass glass = const AGlass(),
  }) => _build(Brightness.light, tone, fontFamily, neutrals, semantic, glass);

  /// 다크 테마.
  static ThemeData dark({
    required ATone tone,
    String? fontFamily,
    ANeutrals neutrals = ANeutrals.dark,
    ASemanticColors semantic = ASemanticColors.dark,
    AGlass glass = const AGlass(),
  }) => _build(Brightness.dark, tone, fontFamily, neutrals, semantic, glass);

  static ThemeData _build(
    Brightness brightness,
    ATone tone,
    String? fontFamily,
    ANeutrals n,
    ASemanticColors semantic,
    AGlass glass,
  ) {
    final isDark = brightness == Brightness.dark;
    const radii = ARadii();

    final scheme = ColorScheme(
      brightness: brightness,
      primary: tone.primary,
      onPrimary: _white,
      primaryContainer: Color.alphaBlend(
        tone.brand.withValues(alpha: isDark ? 0.22 : 0.16),
        n.card,
      ),
      onPrimaryContainer: isDark
          ? Color.lerp(tone.brand, _white, 0.4)!
          : tone.ink,
      inversePrimary: Color.lerp(tone.brand, _white, 0.45)!,
      secondary: n.textSecondary,
      onSecondary: n.card,
      secondaryContainer: n.fill,
      onSecondaryContainer: n.text,
      tertiary: semantic.warning,
      onTertiary: _white,
      tertiaryContainer: semantic.warningContainer,
      onTertiaryContainer: semantic.onWarningContainer,
      error: semantic.negative,
      onError: _white,
      errorContainer: semantic.negativeContainer,
      onErrorContainer: semantic.onNegativeContainer,
      surface: n.card,
      onSurface: n.text,
      onSurfaceVariant: n.textSecondary,
      surfaceDim: n.fillHigh,
      surfaceBright: n.card,
      surfaceContainerLowest: isDark ? n.page : n.card,
      surfaceContainerLow: n.fillLow,
      surfaceContainer: n.fill,
      surfaceContainerHigh: n.fillHigh,
      surfaceContainerHighest: n.fillHighest,
      outline: n.disabled,
      outlineVariant: n.divider,
      inverseSurface: n.inverse,
      onInverseSurface: _white,
      shadow: _black,
      scrim: _black,
      surfaceTint: Colors.transparent,
    );

    final text = aTextTheme(
      text: n.text,
      textSecondary: n.textSecondary,
      fontFamily: fontFamily,
    );

    RoundedRectangleBorder rounded(double r) =>
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(r));
    OutlineInputBorder input(Color color, double width) => OutlineInputBorder(
      borderRadius: BorderRadius.circular(radii.lg),
      borderSide: width == 0
          ? BorderSide.none
          : BorderSide(color: color, width: width),
    );
    final buttonShape = WidgetStatePropertyAll<OutlinedBorder>(
      rounded(radii.md),
    );
    const buttonSize = WidgetStatePropertyAll(Size(64, 44));
    final buttonText = WidgetStatePropertyAll(text.labelLarge);

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      fontFamily: fontFamily,
      textTheme: text,
      scaffoldBackgroundColor: n.page,
      splashFactory: NoSplash.splashFactory,
      dividerColor: n.divider,
      appBarTheme: AppBarTheme(
        backgroundColor: n.page,
        foregroundColor: n.text,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: text.titleLarge,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: n.fill,
        hintStyle: TextStyle(color: n.textTertiary),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        border: input(n.fill, 0),
        enabledBorder: input(n.fill, 0),
        disabledBorder: input(n.fill, 0),
        focusedBorder: input(tone.brand, 2),
        errorBorder: input(semantic.negative, 1.5),
        focusedErrorBorder: input(semantic.negative, 2),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: ButtonStyle(
          shape: buttonShape,
          minimumSize: buttonSize,
          textStyle: buttonText,
          elevation: const WidgetStatePropertyAll(0),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: ButtonStyle(
          shape: buttonShape,
          minimumSize: buttonSize,
          textStyle: buttonText,
          side: WidgetStatePropertyAll(BorderSide(color: n.divider)),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(shape: buttonShape, textStyle: buttonText),
      ),
      cardTheme: CardThemeData(
        color: n.card,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: rounded(radii.xxl),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: n.card,
        modalBackgroundColor: n.card,
        surfaceTintColor: Colors.transparent,
        dragHandleColor: n.fillHighest,
        constraints: const BoxConstraints(maxWidth: 560),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(radii.sheet),
          ),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: n.card,
        surfaceTintColor: Colors.transparent,
        shape: rounded(radii.xxl),
        titleTextStyle: text.headlineSmall,
        contentTextStyle: text.bodyLarge?.copyWith(color: n.textSecondary),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: n.inverse,
        contentTextStyle: text.bodyLarge?.copyWith(color: _white),
        actionTextColor: scheme.inversePrimary,
        shape: rounded(radii.lg),
        elevation: 0,
      ),
      dividerTheme: DividerThemeData(color: n.divider, thickness: 1, space: 1),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: tone.brand,
        linearTrackColor: n.fill,
        circularTrackColor: n.fill,
        linearMinHeight: 6,
      ),
      popupMenuTheme: PopupMenuThemeData(
        color: n.card,
        surfaceTintColor: Colors.transparent,
        shape: rounded(radii.lg),
        textStyle: text.bodyLarge,
      ),
      searchBarTheme: SearchBarThemeData(
        elevation: const WidgetStatePropertyAll(0),
        backgroundColor: WidgetStatePropertyAll(n.card),
        surfaceTintColor: const WidgetStatePropertyAll(Colors.transparent),
        shape: WidgetStatePropertyAll(rounded(radii.lg)),
        hintStyle: WidgetStatePropertyAll(
          text.bodyLarge?.copyWith(color: n.textTertiary),
        ),
        textStyle: WidgetStatePropertyAll(text.bodyLarge),
      ),
      navigationRailTheme: NavigationRailThemeData(
        backgroundColor: n.page,
        indicatorColor: scheme.primaryContainer,
        selectedIconTheme: IconThemeData(color: scheme.onPrimaryContainer),
        unselectedIconTheme: IconThemeData(color: n.disabled),
        selectedLabelTextStyle: text.labelSmall?.copyWith(
          color: scheme.onPrimaryContainer,
        ),
        unselectedLabelTextStyle: text.labelSmall?.copyWith(
          color: n.textTertiary,
        ),
      ),
      // 고른 칸 = 연한 primary(AOptionTile 의 selected 와 같은 면). M3 기본 secondaryContainer 는
      // 회색 면과 거의 같은 색이라 카드 · 시트 위에서 고른 칸이 보이지 않는다.
      segmentedButtonTheme: SegmentedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.resolveWith(
            (states) => states.contains(WidgetState.selected)
                ? scheme.primaryContainer
                : Colors.transparent,
          ),
          foregroundColor: WidgetStateProperty.resolveWith(
            (states) => states.contains(WidgetState.selected)
                ? scheme.onPrimaryContainer
                : n.textSecondary,
          ),
        ),
      ),
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: n.inverse,
          borderRadius: BorderRadius.circular(radii.sm),
        ),
        textStyle: text.bodySmall?.copyWith(color: _white),
      ),
      extensions: [
        AThemeData(
          page: n.page,
          card: n.card,
          sunken: n.fill,
          brand: tone.brand,
          textTertiary: n.textTertiary,
          semantic: semantic,
          radii: radii,
          glass: glass,
        ),
      ],
    );
  }
}
