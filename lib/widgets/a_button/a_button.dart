part of '../../flutter_artis_ui_kit.dart';

enum _ButtonSize { large, normal, small }

class AButton extends StatelessWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final VoidCallback? onLongPressed;
  final BorderRadius borderRadius;
  final EdgeInsets padding;
  final bool filled;
  final Color? color;

  /// 명시하면 [filled] 여부와 무관하게 이 색으로 테두리를 그린다.
  /// null이면 기존 규칙(테두리는 `filled == false`일 때만)을 그대로 따른다.
  /// → `filled: true` + [borderColor] 지정 시 "채움 + 테두리" 조합이 가능하다.
  final Color? borderColor;

  /// 테두리 두께. [borderColor] 또는 outline 모드에서 사용.
  final double borderWidth;

  final double height;
  final double minWidth;
  final _ButtonSize _buttonSize;

  const AButton({
    super.key,
    required this.child,
    this.onPressed,
    this.onLongPressed,
    this.borderRadius = const BorderRadius.all(Radius.circular(999)),
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
    this.filled = false,
    this.color,
    this.borderColor,
    this.borderWidth = 1,
    this.height = 38,
    this.minWidth = 88,
  }) : _buttonSize = _ButtonSize.normal;

  const AButton.large({
    super.key,
    required this.child,
    this.onPressed,
    this.onLongPressed,
    this.borderRadius = const BorderRadius.all(Radius.circular(999)),
    this.padding = const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
    this.filled = false,
    this.color,
    this.borderColor,
    this.borderWidth = 1,
    this.height = 54,
    this.minWidth = 130,
  }) : _buttonSize = _ButtonSize.large;

  const AButton.small({
    super.key,
    required this.child,
    this.onPressed,
    this.onLongPressed,
    this.borderRadius = const BorderRadius.all(Radius.circular(999)),
    this.padding = const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    this.filled = false,
    this.color,
    this.borderColor,
    this.borderWidth = 1,
    this.height = 30,
    this.minWidth = 60,
  }) : _buttonSize = _ButtonSize.small;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    double fontSize = 14;
    FontWeight fontWeight = FontWeight.w500;
    if (_buttonSize == _ButtonSize.large) {
      fontSize = 18;
      fontWeight = FontWeight.w700;
    } else if (_buttonSize == _ButtonSize.small) {
      fontSize = 12;
      fontWeight = FontWeight.w500;
    }

    final Color finalFilledColor = filled ? color ?? colorScheme.primaryContainer : Colors.transparent;

    final bool isLightFilled = finalFilledColor.computeLuminance() > 0.5;

    final Color autoContentColor = isLightFilled ? Colors.black.withValues(alpha: 0.7) : Colors.white;

    final Color autoHighlightColor = isLightFilled ? Colors.black : Colors.white;

    final Color finalOutlineColor = filled ? finalFilledColor : color ?? colorScheme.outlineVariant;

    final Color finalContentColor = filled ? autoContentColor : color ?? colorScheme.onSurface;

    final Color finalHighlightColor = filled ? autoHighlightColor : colorScheme.onSurface;

    final bool isDisabled = onPressed == null && onLongPressed == null;

    // disabled는 채움색 정체성을 유지하되 흐리게: 채움색 @ 0.3을 surface에 합성해
    // 기존 색감 그대로(투명만 제거) 불투명으로 굳힌다. 라이트/다크는 surface가 자동 대응.
    final Color disabledContentColor = finalContentColor.withValues(alpha: 0.3);
    final Color disabledFilledColor = filled
        ? Color.alphaBlend(
            finalFilledColor.withValues(alpha: 0.5),
            colorScheme.surface,
          )
        : Colors.transparent;
    // 테두리 표시 여부: borderColor를 명시하면 filled와 무관하게 그린다.
    // 미지정 시 기존 규칙(테두리는 outline 모드에서만)을 그대로 따른다.
    final bool hasBorder = borderColor != null || !filled;
    final Color sideColor = borderColor ?? finalOutlineColor;
    final Color disabledSideColor = sideColor.withValues(alpha: 0.7);

    return MaterialButton(
      onPressed: onPressed,
      onLongPress: onLongPressed,
      child: DefaultTextStyle.merge(
        style: TextStyle(
          color: isDisabled ? disabledContentColor : finalContentColor,
          fontSize: fontSize,
          fontWeight: fontWeight,
        ),
        child: IconTheme.merge(
          data: IconThemeData(color: isDisabled ? disabledContentColor : finalContentColor),
          child: child,
        ),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: borderRadius,
        side: hasBorder
            ? BorderSide(
                color: isDisabled ? disabledSideColor : sideColor,
                width: borderWidth,
              )
            : BorderSide.none,
      ),
      elevation: 0,
      splashColor: Colors.transparent,
      color: finalFilledColor,
      disabledColor: disabledFilledColor,
      highlightColor: finalHighlightColor.withValues(alpha: 0.3),
      minWidth: minWidth,
      padding: padding,
      height: height,
      hoverElevation: 0,
      highlightElevation: 0,
      focusElevation: 0,
      disabledElevation: 0,
    );
  }
}
