import 'package:flutter/material.dart';

import '../theme/a_theme_data.dart';

import '../layout/a_window_size.dart';
import 'a_floating_navigation_bar.dart';

/// 창 너비에 따라 하단 알약 탭과 옆 레일을 바꿔 그리는 [Scaffold].
///
/// compact · medium 에서는 [AFloatingNavigationBar](`extendBody: true`),
/// expanded(≥ 840)에서는 같은 [destinations] 로 표준 [NavigationRail] 을 그린다.
///
/// ```dart
/// AAdaptiveNavigation(
///   destinations: destinations,
///   selectedIndex: index,
///   onDestinationSelected: (i) => setState(() => index = i),
///   body: pages[index],
/// )
/// ```
class AAdaptiveNavigation extends StatelessWidget {
  /// [body] 옆이나 아래에 [destinations] 탭을 둔다.
  const AAdaptiveNavigation({
    super.key,
    required this.destinations,
    required this.selectedIndex,
    this.onDestinationSelected,
    required this.body,
    this.navigationVisible = true,
  });

  /// 탭 항목.
  final List<NavigationDestination> destinations;

  /// 선택된 항목의 index.
  final int selectedIndex;

  /// 항목을 눌렀을 때. 이미 선택된 항목을 눌러도 불린다(알약 탭일 때).
  final ValueChanged<int>? onDestinationSelected;

  /// 본문.
  final Widget body;

  /// 좁은 창의 하단 탭을 보일지. `false` 면 아래로 미끄러져 내려가 숨는다
  /// (선택 모드처럼 그 자리에 다른 바를 올릴 때). 넓은 창의 레일은 늘 보인다.
  final bool navigationVisible;

  @override
  Widget build(BuildContext context) {
    if (context.windowSize != AWindowSize.expanded) {
      return Scaffold(
        extendBody: true,
        body: body,
        bottomNavigationBar: IgnorePointer(
          ignoring: !navigationVisible,
          child: AnimatedSlide(
            offset: navigationVisible ? Offset.zero : const Offset(0, 1.6),
            duration: AThemeData.of(context).motion.medium,
            curve: Curves.easeOutCubic,
            child: AFloatingNavigationBar(
              destinations: destinations,
              selectedIndex: selectedIndex,
              onDestinationSelected: onDestinationSelected,
            ),
          ),
        ),
      );
    }
    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
            labelType: NavigationRailLabelType.all,
            selectedIndex: selectedIndex,
            onDestinationSelected: onDestinationSelected,
            destinations: [
              for (final d in destinations)
                NavigationRailDestination(
                  icon: d.icon,
                  selectedIcon: d.selectedIcon,
                  label: Text(d.label),
                  disabled: !d.enabled,
                ),
            ],
          ),
          const VerticalDivider(width: 1),
          Expanded(child: body),
        ],
      ),
    );
  }
}
