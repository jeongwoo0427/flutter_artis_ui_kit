part of '../../../flutter_artis_ui_kit.dart';

class ACardButton extends StatelessWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final VoidCallback? onLongPress;
  final Color? color;
  final double elevation;
  final EdgeInsetsGeometry? padding;
  final double? width;
  final double? height;
  final BoxBorder? border;
  final double? textScale;
  final FontWeight? fontWeight;
  final BorderRadius? borderRadius;
  final bool showBorder;
  final double? _defaultRadius; // internal default per size

  const ACardButton({
    super.key,
    required this.child,
    this.color,
    this.onPressed,
    this.onLongPress,
    this.elevation = 2,
    this.padding,
    this.width,
    this.height,
    this.border,
    this.textScale,
    this.fontWeight,
    this.borderRadius,
    this.showBorder = false,
  }) : _defaultRadius = 12;

  const ACardButton.large({
    super.key,
    required this.child,
    this.color,
    this.onPressed,
    this.onLongPress,
    this.elevation = 2,
    EdgeInsetsGeometry? padding,
    this.width,
    this.height,
    this.border,
    this.borderRadius,
    bool? showBorder,
  }) : padding =
           padding ?? const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
       textScale = 1.15,
       fontWeight = FontWeight.w600,
       showBorder = showBorder ?? false,
       _defaultRadius = 12;

  const ACardButton.tiny({
    super.key,
    required this.child,
    this.color,
    this.onPressed,
    this.onLongPress,
    this.elevation = 2,
    EdgeInsetsGeometry? padding,
    this.width,
    this.height,
    this.border,
    this.borderRadius,
    bool? showBorder,
  }) : padding =
           padding ?? const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
       textScale = 0.9,
       fontWeight = null,
       showBorder = showBorder ?? false,
       _defaultRadius = 6;

  @override
  Widget build(BuildContext context) {
    final baseTextStyle = DefaultTextStyle.of(context).style;
    final mergedChild = DefaultTextStyle.merge(
      style: baseTextStyle.copyWith(
        fontSize: (baseTextStyle.fontSize ?? 14) * (textScale ?? 1.0),
        fontWeight: fontWeight,
      ),
      child: child,
    );

    final BorderRadius effectiveRadius =
        borderRadius ?? BorderRadius.circular(_defaultRadius ?? 12);

    return ACardButton(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [mergedChild],
      ),
      onPressed: onPressed,
      onLongPress: onLongPress,
      elevation: elevation,
      color: color,
      borderRadius: effectiveRadius,
      padding:
          padding ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      width: width,
      height: height,
      border: border,
    );
  }
}
