import 'package:flutter/material.dart';

import '../theme/a_theme_data.dart';

import 'a_floating_navigation_bar.dart';

/// 떠 있는 알약 하단 탭([AFloatingNavigationBar])을 둔 탭 셸 [Scaffold].
///
/// 폰 · 태블릿 · 넓은 창 모두 같은 하단 탭이다 — 창 너비로 레일 등으로 바꾸지 않는다(본문 폭은 화면 쪽에서 묶는다).
/// 본문이 탭 뒤까지 이어지게 `extendBody: true` 로 두므로, 본문 아래 여백은 `MediaQuery.paddingOf(context).bottom` 을 쓴다.
///
/// ```dart
/// AFloatingNavigationScaffold(
///   destinations: destinations,
///   selectedIndex: index,
///   onDestinationSelected: (i) => setState(() => index = i),
///   body: pages[index],
/// )
/// ```
class AFloatingNavigationScaffold extends StatelessWidget {
  /// [body] 아래에 [destinations] 탭을 띄운다.
  const AFloatingNavigationScaffold({
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

  /// 항목을 눌렀을 때. 이미 선택된 항목을 눌러도 불린다.
  final ValueChanged<int>? onDestinationSelected;

  /// 본문.
  final Widget body;

  /// 하단 탭을 보일지. `false` 면 아래로 미끄러져 내려가 숨는다
  /// (선택 모드처럼 그 자리에 다른 바를 올릴 때).
  final bool navigationVisible;

  @override
  Widget build(BuildContext context) {
    // 탭 화면의 유리 상단 바(`AAppBar`)와 하단 탭은 겹치지 않고 흐림 값도 같다 —
    // 한 그룹으로 묶어 뒤 내용을 한 번만 흐린다(`BackdropFilter.grouped`).
    // 상세 화면은 이 셸 위(루트 내비게이터)에 쌓이므로 그룹에 들어오지 않는다.
    return BackdropGroup(
      child: Scaffold(
        extendBody: true,
        body: body,
        bottomNavigationBar: IgnorePointer(
          ignoring: !navigationVisible,
          child: AnimatedSlide(
            offset: navigationVisible ? Offset.zero : const Offset(0, 1.6),
            // 화면 밖까지 멀리 움직이므로 길게 · 양끝 부드럽게(짧으면 순간이동처럼 보인다).
            duration: AThemeData.of(context).motion.long,
            curve: Curves.easeInOutCubic,
            child: AFloatingNavigationBar(
              destinations: destinations,
              selectedIndex: selectedIndex,
              onDestinationSelected: onDestinationSelected,
            ),
          ),
        ),
      ),
    );
  }
}
