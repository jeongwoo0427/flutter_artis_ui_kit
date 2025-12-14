part of '../../flutter_artis_ui_kit.dart';

class AButton extends StatefulWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final VoidCallback? onLongPressed;
  final BorderRadius borderRadius;
  final EdgeInsets padding;

  const AButton({
    super.key,
    required this.child,
    this.onPressed,
    this.onLongPressed,
    this.borderRadius = const BorderRadius.all(Radius.circular(999)),
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
  });

  const AButton.large({
    super.key,
    required this.child,
    this.onPressed,
    this.onLongPressed,
    this.borderRadius = const BorderRadius.all(Radius.circular(999)),
    this.padding = const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
  });

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

    final Color backgroundColor = _isPressed ? colorScheme.outlineVariant.withValues(alpha: 0.3) : Colors.transparent;
    final Color textColor = colorScheme.onSurface;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: enabled ? (_) => _setPressed(true) : null,
      onTapUp: enabled ? (_) => _setPressed(false) : null,
      onTapCancel: enabled ? () => _setPressed(false) : null,
      onTap: widget.onPressed,
      onLongPress: widget.onLongPressed,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.decelerate,
        padding: widget.padding,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: widget.borderRadius,
          border: Border.all(color: colorScheme.outlineVariant, width: 1.3),
        ),
        child: DefaultTextStyle.merge(
          style: TextStyle(color: textColor, fontWeight: FontWeight.w500, fontSize: 14),
          child: IconTheme.merge(
            data: IconThemeData(color: textColor),
            child: widget.child,
          ),
        ),
      ),
    );
  }
}
