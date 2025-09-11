part of '../../../flutter_artis_ui_kit.dart';

class AEllipseButton extends StatelessWidget {
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

  const AEllipseButton({
    super.key,
    required this.child,
    this.color,
    this.onPressed,
    this.onLongPress,
    this.elevation = 0,
    this.padding,
    this.width,
    this.height,
    this.border,
    this.textScale,
    this.fontWeight,
  });

  const AEllipseButton.large({
    super.key,
    required this.child,
    this.color,
    this.onPressed,
    this.onLongPress,
    this.elevation = 0,
    EdgeInsetsGeometry? padding,
    this.width,
    this.height,
    this.border,
  }) : padding =
           padding ?? const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
       textScale = 1.15,
       fontWeight = FontWeight.w600;

  const AEllipseButton.tiny({
    super.key,
    required this.child,
    this.color,
    this.onPressed,
    this.onLongPress,
    this.elevation = 0,
    EdgeInsetsGeometry? padding,
    this.width,
    this.height,
    this.border,
  }) : padding =
           padding ?? const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
       textScale = 0.9,
       fontWeight = null;

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

    return ACard(
      child: Center(child: mergedChild),
      onPressed: onPressed,
      onLongPress: onLongPress,
      elevation: elevation,
      color: color,
      borderRadius: BorderRadius.circular(9999),
      padding:
          padding ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      width: width,
      height: height,
      border: border,
    );
  }
}
