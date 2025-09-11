part of '../../flutter_artis_ui_kit.dart';

class ACard extends StatefulWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final VoidCallback? onLongPress;
  final double elevation;
  final Color? color;
  final BorderRadius? borderRadius;
  final EdgeInsetsGeometry? padding;
  final BoxBorder? border;

  final double? width;
  final double? height;

  const ACard({
    super.key,
    required this.child,
    this.onPressed,
    this.onLongPress,
    this.elevation = 0,
    this.color,
    this.borderRadius,
    this.padding,
    this.border,
    this.width,
    this.height,
  });

  @override
  State<ACard> createState() => _ACardState();
}

class _ACardState extends State<ACard> {
  bool _pressed = false;
  Timer? _releaseTimer;

  void _handleTapDown(TapDownDetails details) {
    if (!_enabled) return;
    setState(() => _pressed = true);
  }

  void _handleTapUp(TapUpDetails details) {
    if (!_enabled) return;
    _releaseTimer?.cancel();
    _releaseTimer = Timer(const Duration(milliseconds: 100), () {
      if (mounted) {
        setState(() => _pressed = false);
      }
    });
  }

  void _handleTapCancel() {
    _releaseTimer?.cancel();
    setState(() => _pressed = false);
  }

  bool get _enabled => widget.onPressed != null || widget.onLongPress != null;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final borderRadius = widget.borderRadius ?? BorderRadius.circular(12);

    final body = DecoratedBox(
      decoration: BoxDecoration(
        color: widget.color ?? theme.colorScheme.surface,
        borderRadius: borderRadius,
        border: widget.border,
        boxShadow: widget.elevation > 0
            ? [
                BoxShadow(
                  color: Colors.black.withOpacity(
                    (0.4 / (1 + widget.elevation * 0.3)).clamp(0.05, 0.4),
                  ),
                  blurRadius: widget.elevation * 4,
                  offset: Offset(0, widget.elevation),
                ),
              ]
            : [],
      ),
      child: Padding(
        padding: widget.padding ?? const EdgeInsets.all(12),
        child: widget.child,
      ),
    );

    final scaled = AnimatedScale(
      scale: _pressed ? 0.97 : 1.0,
      duration: const Duration(milliseconds: 90),
      curve: Curves.easeOut,
      child: body,
    );

    // width, height 적용
    final sized = SizedBox(
      width: widget.width,
      height: widget.height,
      child: scaled,
    );

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: _handleTapDown,
      onTapUp: (d) {
        _handleTapUp(d);
        if (widget.onPressed != null) widget.onPressed!();
      },
      onTapCancel: _handleTapCancel,
      onLongPress: widget.onLongPress,
      child: sized,
    );
  }
}
