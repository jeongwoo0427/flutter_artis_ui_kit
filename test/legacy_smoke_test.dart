// 옛 위젯이 legacy.dart 로 옮겨진 뒤에도 그대로 그려지는지 — 2.0.0 에서 legacy 와 함께 지운다.
import 'package:flutter/material.dart';
import 'package:flutter_artis_ui_kit/legacy.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('legacy widgets still build', (tester) async {
    var tapped = 0;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Column(
            children: [
              AButton.large(
                onPressed: () => tapped++,
                child: const Text('button'),
              ),
              const ATextFormField(hintText: 'hint'),
            ],
          ),
          bottomNavigationBar: ABottomNavigationBar(
            items: [
              ABottomNavigationBarItem(icon: Icons.home, label: 'home'),
              ABottomNavigationBarItem(icon: Icons.person, label: 'me'),
            ],
            selectedIndex: 0,
            onTapIndex: (_) {},
          ),
        ),
      ),
    );

    await tester.tap(find.text('button'));
    expect(tapped, 1);
    expect(find.text('home'), findsOneWidget);
  });
}
