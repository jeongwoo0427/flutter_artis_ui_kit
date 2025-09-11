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


class ALargeEllipseButton extends StatelessWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final VoidCallback? onLongPress;
  final Color? color;
  final double elevation;
  final EdgeInsetsGeometry? padding;
  final double? width;
  final double? height;
  final BoxBorder? border;

  const ALargeEllipseButton({
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
    final baseTextStyle = DefaultTextStyle.of(context).style;
    final mergedChild = DefaultTextStyle.merge(
      style: baseTextStyle.copyWith(
        fontSize: (baseTextStyle.fontSize ?? 14) * 1.15,
        fontWeight: FontWeight.w600
      ),
      child: child,
    );

    return AEllipseButton(
      child: mergedChild,
      color: color,
      onPressed: onPressed,
      onLongPress: onLongPress,
      elevation: elevation,
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      width: width,
      height: height,
      border: border,
    );
  }
}


class ATinyEllipseButton extends StatelessWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final VoidCallback? onLongPress;
  final Color? color;
  final double elevation;
  final EdgeInsetsGeometry? padding;
  final double? width;
  final double? height;
  final BoxBorder? border;

  const ATinyEllipseButton({
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
    final baseTextStyle = DefaultTextStyle.of(context).style;
    final mergedChild = DefaultTextStyle.merge(
      style: baseTextStyle.copyWith(
        fontSize: (baseTextStyle.fontSize ?? 14) * 0.9,
      ),
      child: child,
    );

    return AEllipseButton(
      child: mergedChild,
      color: color,
      onPressed: onPressed,
      onLongPress: onLongPress,
      elevation: elevation,
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      width: width,
      height: height,
      border: border,
    );
  }
}


