part of '../../flutter_artis_ui_kit.dart';

enum _ButtonSize { large, normal, small }

class AButton extends StatefulWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final VoidCallback? onLongPressed;
  final BorderRadius borderRadius;
  final EdgeInsets padding;
  final bool filled;
  final Color? filledColor;
  final double minHeight;
  final double minWidth;
  final _ButtonSize _buttonSize;

  const AButton({
    super.key,
    required this.child,
    this.onPressed,
    this.onLongPressed,
    this.borderRadius = const BorderRadius.all(Radius.circular(999)),
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    this.filled = false,
    this.filledColor,
    this.minHeight = 34,
    this.minWidth = 80,
  }) : _buttonSize = _ButtonSize.normal;

  const AButton.large({
    super.key,
    required this.child,
    this.onPressed,
    this.onLongPressed,
    this.borderRadius = const BorderRadius.all(Radius.circular(999)),
    this.padding = const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
    this.filled = false,
    this.filledColor,
    this.minHeight = 54,
    this.minWidth = 130,
  }) : _buttonSize = _ButtonSize.large;

  const AButton.small({
    super.key,
    required this.child,
    this.onPressed,
    this.onLongPressed,
    this.borderRadius = const BorderRadius.all(Radius.circular(999)),
    this.padding = const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
    this.filled = false,
    this.filledColor,
    this.minHeight = 24,
    this.minWidth = 50,
  }) : _buttonSize = _ButtonSize.small;

  @override
  State<AButton> createState() => _AButtonState();
}

class _AButtonState extends State<AButton> {
  bool _isPressed = false;

  void _setPressed(bool value) {
    if (_isPressed == value) return;
    setState(() => _isPressed = value);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final enabled = widget.onPressed != null || widget.onLongPressed != null;

    final bool isFilled = widget.filled;

    final Color baseFillColor = widget.filledColor ?? colorScheme.primaryContainer;
    final Color backgroundColor = isFilled
        ? (_isPressed ? baseFillColor.withValues(alpha: 0.65) : baseFillColor)
        : (_isPressed ? colorScheme.outlineVariant.withValues(alpha: 0.3) : Colors.transparent);

    final Color contentColor = isFilled ? colorScheme.onPrimaryContainer : colorScheme.onSurface;

    double fontSize = 14;
    FontWeight fontWeight = FontWeight.w500;
    if (widget._buttonSize == _ButtonSize.large) {
      fontSize = 18;
      fontWeight = FontWeight.w700;
    }

    final Widget button = AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      padding: widget.padding,
      constraints: BoxConstraints(minHeight: widget.minHeight, minWidth: widget.minWidth),
      decoration: BoxDecoration(color: backgroundColor, borderRadius: widget.borderRadius),
      child: Align(
        alignment: Alignment.center,
        widthFactor: 1,
        child: DefaultTextStyle.merge(
          style: TextStyle(color: contentColor, fontSize: fontSize, fontWeight: fontWeight),
          child: IconTheme.merge(
            data: IconThemeData(color: contentColor),
            child: widget.child,
          ),
        ),
      ),
    );

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: enabled ? (_) => _setPressed(true) : null,
      onTapUp: enabled ? (_) => _setPressed(false) : null,
      onTapCancel: enabled ? () => _setPressed(false) : null,
      onTap: widget.onPressed,
      onLongPress: widget.onLongPressed,
      child: isFilled
          ? button
          : CustomPaint(
              painter: _InnerBorderPainter(
                color: colorScheme.outlineVariant,
                width: 1.3,
                borderRadius: widget.borderRadius,
              ),
              child: button,
            ),
    );
  }
}

class _InnerBorderPainter extends CustomPainter {
  final Color color;
  final double width;
  final BorderRadius borderRadius;

  const _InnerBorderPainter({required this.color, required this.width, required this.borderRadius});

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final innerRect = rect.deflate(width / 2);

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = width;

    canvas.drawRRect(borderRadius.toRRect(innerRect), paint);
  }

  @override
  bool shouldRepaint(covariant _InnerBorderPainter oldDelegate) {
    return color != oldDelegate.color || width != oldDelegate.width || borderRadius != oldDelegate.borderRadius;
  }
}
