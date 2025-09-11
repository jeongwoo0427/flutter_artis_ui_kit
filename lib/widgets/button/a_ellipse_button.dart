part of '../../flutter_artis_ui_kit.dart';

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

  const AEllipseButton({
    super.key,
    required this.child,
    this.color,
    this.onPressed,
    this.onLongPress,
    this.elevation = 1,
    this.padding,
    this.width,
    this.height,
    this.border,
  });

  @override
  Widget build(BuildContext context) {
    return ACard(
      child: Center(child: child),
      onPressed: onPressed,
      onLongPress: onLongPress,
      elevation: elevation,
      color: color,
      borderRadius: BorderRadius.circular(9999),
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      width: width,
      height: height,
      border: border,
    );
  }
}


