part of '../flutter_artis_ui_kit.dart';

class AFloatingNavigationBar extends StatefulWidget {
  ///It is items what you want to add
  List<AFloatingNavigationItem> items;

  ///
  int selectedIndex;

  ///You can take what is current index when you tap navigation item
  Function(int index) onTapIndex;

  ///A double that determines how far it is from the bottom
  double bottomMargin;

  ///Determines how much evocation effect you want to add.
  double elevation;

  ///Decide the padding you want to put inside of NavigationBar
  double bottomPadding;

  ///Decide the padding you want to put inside of NavigationBar
  double leftPadding;

  ///Decide the padding you want to put inside of NavigationBar
  double rightPadding;

  ///Decide the padding you want to put inside of NavigationBar
  double topPadding;

  ///Decide how much flexion you want to give to the corner.
  BorderRadius? borderRadius;

  ///Set up how fast movement of Cursor
  Duration duration;

  ///The Curve of item movement
  Curve? curves;

  ///You can change the navigationbar color, but default color follows at the 'ThemeData.ColorScheme.SurfaceColor'
  Color? backgroundColor;

  double itemWidth;

  double itemHeight;

  double spacing;

  AFloatingNavigationBar({
    Key? key,
    required this.items,
    required this.selectedIndex,
    required this.onTapIndex,
    this.bottomMargin = 0,
    this.elevation = 5,
    this.bottomPadding = 2,
    this.rightPadding = 14,
    this.leftPadding = 14,
    this.topPadding = 10,
    this.duration = const Duration(milliseconds: 300),
    this.curves,
    this.borderRadius,
    this.backgroundColor,
    this.itemWidth = 40,
    this.itemHeight = 40,
    this.spacing = 5,
  }) : super(key: key);

  @override
  State<AFloatingNavigationBar> createState() =>
      _MainMenuBottomFloatingBarState();
}

class _MainMenuBottomFloatingBarState extends State<AFloatingNavigationBar>
    with TickerProviderStateMixin {
  final double _cursorWidth = 5;

  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);

    List<Widget> navigationItems = [];
    for (int i = 0; i < widget.items.length; i++) {
      navigationItems.add(
        _getNavigationItem(i, widget.items[i], widget.onTapIndex),
      );
    }

    return SafeArea(
      bottom: true,
      minimum: EdgeInsets.only(bottom: widget.bottomMargin),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.only(
              bottom: widget.bottomPadding,
              right: widget.rightPadding,
              left: widget.leftPadding,
              top: widget.topPadding,
            ),
            decoration: BoxDecoration(
              borderRadius: widget.borderRadius ?? BorderRadius.circular(30),
              color: widget.backgroundColor ?? themeData.colorScheme.surface,
              boxShadow: [
                BoxShadow(
                  color: themeData.colorScheme.shadow.withValues(alpha: 0.18),
                  blurRadius: 35,
                  spreadRadius: 1,
                  offset: const Offset(0, 7),
                ),
              ],
            ),
            child: IntrinsicWidth(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    height: 5,
                    child: Stack(
                      children: [
                        AnimatedPositioned(
                          left: _getCurrentCursorPosition(
                            widget.itemWidth,
                            _cursorWidth,
                            navigationItems.length,
                            widget.spacing,
                            widget.selectedIndex,
                          ),
                          top: 0,
                          bottom: 0,
                          duration: Duration(milliseconds: 200),
                          curve: widget.curves ?? Curves.easeInOut,
                          child: Container(
                            width: _cursorWidth,
                            decoration: BoxDecoration(
                              color: themeData.colorScheme.primary,
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    spacing: widget.spacing,
                    mainAxisSize: MainAxisSize.min,
                    children: navigationItems,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _getNavigationItem(
    int index,
    AFloatingNavigationItem item,
    Function(int index) onTap,
  ) {
    ThemeData themeData = Theme.of(context);
    Color? itemColor = widget.selectedIndex == index
        ? themeData.colorScheme.primary
        : null;
    return Container(
      width: widget.itemWidth,
      height: widget.itemHeight,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          customBorder: const CircleBorder(),
          child: Icon(item.icon, color: itemColor),
          onTap: () {
            if (item.onTap != null) {
              item.onTap!();
              return;
            }

            onTap(index);
            setState(() {});
          },
        ),
      ),
    );
  }

  double _getCurrentCursorPosition(
    double itemWidth,
    double cursorWidth,
    int itemCount,
    double spacing,
    int currentIndex,
  ) {
    final double defaultPosition = itemWidth / 2 - cursorWidth / 2;
    double currentPosition = 0;
    if (currentIndex <= itemCount) {
      currentPosition =
          defaultPosition +
          (itemWidth * currentIndex) +
          (spacing * currentIndex);
    }
    return currentPosition;
  }
}

class AFloatingNavigationItem {
  final IconData icon;
  final Function? onTap;

  AFloatingNavigationItem({required this.icon, this.onTap});
}
