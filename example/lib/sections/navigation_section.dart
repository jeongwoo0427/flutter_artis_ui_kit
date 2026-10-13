import 'package:flutter/material.dart';
import 'package:flutter_artis_ui_kit/flutter_artis_ui_kit.dart';

const _destinations = [
  NavigationDestination(icon: Icon(Icons.home_rounded), label: 'Home'),
  NavigationDestination(icon: Icon(Icons.question_mark), label: 'Bank'),
  NavigationDestination(icon: Icon(Icons.quiz), label: 'Quiz'),
  NavigationDestination(icon: Icon(Icons.person), label: 'Me'),
];

/// 내비게이션 · 레이아웃 데모 — 제목 탭 · 브레드크럼 · 알약 하단 탭 · 창 너비.
List<Widget> navigationSection(BuildContext context) {
  final caption = Theme.of(context).textTheme.bodySmall;
  return [
    Text('Window size: ${context.windowSize.name}', style: caption),
    Text('ATitleTabs', style: caption),
    const _TabsDemo(),
    Text('ABreadcrumb — tap a parent to go up', style: caption),
    const _BreadcrumbDemo(),
    Text('AFloatingNavigationBar', style: caption),
    const _NavDemo(),
  ];
}

class _TabsDemo extends StatefulWidget {
  const _TabsDemo();

  @override
  State<_TabsDemo> createState() => _TabsDemoState();
}

class _TabsDemoState extends State<_TabsDemo> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    return ATitleTabs(
      labels: const ['Question bank', 'Workbooks'],
      selectedIndex: _index,
      onSelected: (i) => setState(() => _index = i),
    );
  }
}

class _BreadcrumbDemo extends StatefulWidget {
  const _BreadcrumbDemo();

  @override
  State<_BreadcrumbDemo> createState() => _BreadcrumbDemoState();
}

class _BreadcrumbDemoState extends State<_BreadcrumbDemo> {
  List<String> _path = const ['🏠 Bank', 'English', 'Grade 9', 'Vocabulary'];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ABreadcrumb(
          items: _path,
          onTap: (i) => setState(() => _path = _path.sublist(0, i + 1)),
        ),
        TextButton(
          onPressed: () =>
              setState(() => _path = [..._path, 'Folder ${_path.length}']),
          child: const Text('Open subfolder'),
        ),
      ],
    );
  }
}

class _NavDemo extends StatefulWidget {
  const _NavDemo();

  @override
  State<_NavDemo> createState() => _NavDemoState();
}

class _NavDemoState extends State<_NavDemo> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 140,
      child: MediaQuery.removePadding(
        context: context,
        removeBottom: true,
        child: Scaffold(
          extendBody: true,
          body: Center(child: Text('Selected: ${_destinations[_index].label}')),
          bottomNavigationBar: AFloatingNavigationBar(
            destinations: _destinations,
            selectedIndex: _index,
            onDestinationSelected: (i) => setState(() => _index = i),
          ),
        ),
      ),
    );
  }
}
