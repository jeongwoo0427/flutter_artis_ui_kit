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

    final Color autoHighlightColor = isLightFilled ? Colors.black.withValues(alpha: 0.3) : Colors.white;

    final Color finalOutlineColor = filled ? finalFilledColor : color ?? colorScheme.outlineVariant;

    final Color finalContentColor = filled ? autoContentColor : color ?? colorScheme.onSurface;

    final Color finalHighlightColor = filled ? autoHighlightColor : colorScheme.onSurface;

    return MaterialButton(
      onPressed: onPressed,
      child: DefaultTextStyle.merge(
        style: TextStyle(color: finalContentColor, fontSize: fontSize, fontWeight: fontWeight),
        child: IconTheme.merge(
          data: IconThemeData(color: finalContentColor),
          child: child,
        ),
      ),
      shape: filled
          ? RoundedRectangleBorder(borderRadius: borderRadius)
          : RoundedRectangleBorder(
              borderRadius: borderRadius,
              side: BorderSide(color: finalOutlineColor, width: 1),
            ),
      elevation: 0,
      splashColor: Colors.transparent,
      color: finalFilledColor,
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
