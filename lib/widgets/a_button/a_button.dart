part of '../../flutter_artis_ui_kit.dart';

enum _ButtonSize { large, normal, small }

class AButton extends StatefulWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final VoidCallback? onLongPressed;
  final BorderRadius borderRadius;
  final EdgeInsets padding;
  final bool fullFilled;
  final Color? filledColor;
  final Color? contentColor;
  final Color? outlineColor;
  final Color? splashColor;
  final double minHeight;
  final double minWidth;
  final _ButtonSize _buttonSize;

  const AButton({
    super.key,
    required this.child,
    this.onPressed,
    this.onLongPressed,
    this.borderRadius = const BorderRadius.all(Radius.circular(999)),
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
    this.fullFilled = false,
    this.filledColor,
    this.contentColor,
    this.outlineColor,
    this.splashColor,
    this.minHeight = 38,
    this.minWidth = 80,
  }) : _buttonSize = _ButtonSize.normal;

  const AButton.large({
    super.key,
    required this.child,
    this.onPressed,
    this.onLongPressed,
    this.borderRadius = const BorderRadius.all(Radius.circular(999)),
    this.padding = const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
    this.fullFilled = false,
    this.filledColor,
    this.contentColor,
    this.outlineColor,
    this.splashColor,
    this.minHeight = 54,
    this.minWidth = 130,
  }) : _buttonSize = _ButtonSize.large;

  const AButton.small({
    super.key,
    required this.child,
    this.onPressed,
    this.onLongPressed,
    this.borderRadius = const BorderRadius.all(Radius.circular(999)),
    this.padding = const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    this.fullFilled = false,
    this.filledColor,
    this.contentColor,
    this.outlineColor,
    this.splashColor,
    this.minHeight = 28,
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

    double fontSize = 14;
    FontWeight fontWeight = FontWeight.w500;
    if (widget._buttonSize == _ButtonSize.large) {
      fontSize = 18;
      fontWeight = FontWeight.w700;
    } else if (widget._buttonSize == _ButtonSize.small) {
      fontSize = 13;
      fontWeight = FontWeight.w500;
    }

    final Color filledColor =
        widget.filledColor ??
        (widget.fullFilled ? colorScheme.primaryContainer : Colors.transparent);

    final Color outlineColor =
        widget.outlineColor ??
        (widget.fullFilled ? filledColor : colorScheme.outlineVariant);

    final Color contentColor =
        widget.contentColor ??
        (widget.fullFilled
            ? colorScheme.onPrimaryContainer
            : colorScheme.onSurface);

    final Color splashColor =
        widget.splashColor ?? (widget.fullFilled ? colorScheme.onPrimaryContainer : colorScheme.onSurface);

    final Widget splashOverlay = IgnorePointer(
      ignoring: true,
      child: AnimatedOpacity(
        opacity: _isPressed ? 0.3 : 0,
        duration: Duration(milliseconds: 200),
        curve: Curves.ease,
        child: Container(
          decoration: BoxDecoration(
            color: splashColor,
            borderRadius: widget.borderRadius,
          ),
        ),
      ),
    );

    final Widget button = AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      curve: Curves.ease,
      padding: widget.padding,
      constraints: BoxConstraints(
        minHeight: widget.minHeight,
        minWidth: widget.minWidth,
      ),
      decoration: BoxDecoration(
        color: filledColor,
        borderRadius: widget.borderRadius,
        border: BoxBorder.all(color: outlineColor, width: 1.3),
      ),
      child: Align(
        alignment: Alignment.center,
        widthFactor: 1,
        child: DefaultTextStyle.merge(
          style: TextStyle(
            color: contentColor,
            fontSize: fontSize,
            fontWeight: fontWeight,
          ),
          child: IconTheme.merge(
            data: IconThemeData(color: contentColor),
            child: widget.child,
          ),
        ),
      ),
    );

    return Semantics(
      button: true,
      enabled: enabled,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: enabled ? (_) => _setPressed(true) : null,
        onTapUp: enabled ? (_) => _setPressed(false) : null,
        onTapCancel: enabled ? () => _setPressed(false) : null,
        onTap: widget.onPressed,
        onLongPress: widget.onLongPressed,
        child: Stack(
          children: [
            button,
            Positioned.fill(child: splashOverlay),
          ],
        ),
      ),
    );
  }
}
