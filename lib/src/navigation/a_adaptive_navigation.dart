import 'package:flutter/material.dart';

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
  });

  /// 탭 항목.
  final List<NavigationDestination> destinations;

  /// 선택된 항목의 index.
  final int selectedIndex;

  /// 항목을 눌렀을 때. 이미 선택된 항목을 눌러도 불린다(알약 탭일 때).
  final ValueChanged<int>? onDestinationSelected;

  /// 본문.
  final Widget body;

  @override
  Widget build(BuildContext context) {
    if (context.windowSize != AWindowSize.expanded) {
      return Scaffold(
        extendBody: true,
        body: body,
        bottomNavigationBar: AFloatingNavigationBar(
          destinations: destinations,
          selectedIndex: selectedIndex,
          onDestinationSelected: onDestinationSelected,
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
