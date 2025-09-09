part of '../../flutter_artis_ui_kit.dart';

class AEllipseButton extends StatelessWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final VoidCallback? onLongPress;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final Color? disabledBackgroundColor;
  final Color? disabledForegroundColor;
  final EdgeInsetsGeometry? padding;
  final double? height;
  final double? minWidth;
  final double elevation;
  final BoxBorder? border;
  final String? semanticsLabel;
  final String? semanticsHint;
  final String? tooltip;
  final TooltipTriggerMode? tooltipTriggerMode;

  const AEllipseButton({
    super.key,
    required this.child,
    this.onPressed,
    this.onLongPress,
    this.backgroundColor,
    this.foregroundColor,
    this.disabledBackgroundColor,
    this.disabledForegroundColor,
    this.padding,
    this.height,
    this.minWidth,
    this.elevation = 0,
    this.border,
    this.semanticsLabel,
    this.semanticsHint,
    this.tooltip,
    this.tooltipTriggerMode,
  });

  bool get _enabled => onPressed != null || onLongPress != null;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final Color bg = _enabled
        ? (backgroundColor ?? theme.colorScheme.primary)
        : (disabledBackgroundColor ?? theme.disabledColor.withValues(alpha: 0.3));

    final Color fg = _enabled
        ? (foregroundColor ?? theme.colorScheme.onPrimary)
        : (disabledForegroundColor ?? theme.disabledColor);

    final EdgeInsetsGeometry effectivePadding =
        padding ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 10);

    final double effectiveHeight = height ?? 40;
    final double effectiveMinWidth = minWidth ?? 72;

    final BorderRadius borderRadius =
        const BorderRadius.all(Radius.circular(9999));

    Widget content = DefaultTextStyle.merge(
      style: theme.textTheme.labelLarge?.copyWith(color: fg),
      child: IconTheme.merge(
        data: IconThemeData(color: fg),
        child: child,
      ),
    );

    content = Padding(
      padding: effectivePadding,
      child: content,
    );

    final Widget constrained = ConstrainedBox(
      constraints: BoxConstraints(
        minWidth: effectiveMinWidth,
        minHeight: effectiveHeight,
      ),
      child: content,
    );

    final Widget card = ACard(
      onPressed: onPressed,
      onLongPress: onLongPress,
      elevation: elevation,
      color: bg,
      borderRadius: borderRadius,
      border: border,
      child: constrained,
    );

    final Widget semanticWrapped = Semantics(
      button: true,
      enabled: _enabled,
      label: semanticsLabel,
      hint: semanticsHint,
      child: MouseRegion(
        cursor:
            _enabled ? SystemMouseCursors.click : SystemMouseCursors.basic,
        child: card,
      ),
    );

    if (tooltip != null && tooltip!.isNotEmpty) {
      return Tooltip(
        message: tooltip!,
        triggerMode:
            tooltipTriggerMode ?? TooltipTriggerMode.longPress,
        child: semanticWrapped,
      );
    }

    return semanticWrapped;
  }
}

