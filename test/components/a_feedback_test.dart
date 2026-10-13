import 'package:flutter/material.dart';
import 'package:flutter_artis_ui_kit/flutter_artis_ui_kit.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _wrap(Widget child, {bool disableAnimations = false}) => MaterialApp(
  theme: AThemeBuilder.light(tone: ATone.fromBrand(const Color(0xFF3182F6))),
  home: Builder(
    builder: (context) => MediaQuery(
      data: MediaQuery.of(
        context,
      ).copyWith(disableAnimations: disableAnimations),
      child: Scaffold(body: child),
    ),
  ),
);

void main() {
  testWidgets('AEmptyState — 기본형 · inline · sliver 안', (tester) async {
    await tester.pumpWidget(
      _wrap(
        CustomScrollView(
          slivers: [
            const SliverToBoxAdapter(
              child: AEmptyState.inline(
                icon: AEmojiTile(emoji: '📝'),
                title: Text('미리보기 없음'),
                message: Text('문제를 추가하면 여기에 보여요'),
              ),
            ),
            SliverFillRemaining(
              hasScrollBody: false,
              child: AEmptyState(
                icon: const AEmojiTile(emoji: '📭', size: AEmojiTileSize.large),
                title: const Text('아직 문제가 없어요'),
                message: const Text('첫 문제를 만들어 보세요'),
                action: FilledButton(
                  onPressed: () {},
                  child: const Text('만들기'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
    expect(tester.takeException(), isNull);
    expect(find.text('아직 문제가 없어요'), findsOneWidget);
    expect(find.text('미리보기 없음'), findsOneWidget);
    expect(find.text('만들기'), findsOneWidget);
  });

  testWidgets('AEmptyState — 제목은 header 시맨틱', (tester) async {
    final handle = tester.ensureSemantics();
    await tester.pumpWidget(_wrap(const AEmptyState(title: Text('비었어요'))));
    expect(tester.getSemantics(find.text('비었어요')), isSemantics(isHeader: true));
    handle.dispose();
  });

  testWidgets('AEmojiTile — 장식은 숨기고 라벨이 있으면 읽힌다', (tester) async {
    final handle = tester.ensureSemantics();
    await tester.pumpWidget(
      _wrap(
        const Column(
          children: [
            AEmojiTile(emoji: '📚'),
            AEmojiTile.icon(icon: Icons.star, semanticLabel: '즐겨찾기'),
            AEmojiTile(emoji: '🏆', size: AEmojiTileSize.hero),
          ],
        ),
      ),
    );
    expect(find.bySemanticsLabel('📚'), findsNothing);
    expect(find.bySemanticsLabel('즐겨찾기'), findsOneWidget);
    expect(tester.getSize(find.byType(AEmojiTile).last), const Size(64, 64));
    handle.dispose();
  });

  testWidgets('ASkeleton — 애니메이션 끔이면 멈춰 있다', (tester) async {
    await tester.pumpWidget(
      _wrap(
        const Column(
          children: [ASkeleton(width: 120, height: 16), ASkeleton.circle(40)],
        ),
        disableAnimations: true,
      ),
    );
    // 반복 애니메이션이 돌면 pumpAndSettle 이 시간 초과로 실패한다.
    await tester.pumpAndSettle();
    expect(tester.getSize(find.byType(ASkeleton).first), const Size(120, 16));
    expect(tester.getSize(find.byType(ASkeleton).last), const Size(40, 40));
  });

  testWidgets('ASkeleton — 애니메이션이 켜져 있으면 반짝인다', (tester) async {
    await tester.pumpWidget(_wrap(const ASkeleton(height: 16)));
    expect(tester.hasRunningAnimations, isTrue);
    await tester.pump(const Duration(milliseconds: 700));
    expect(tester.takeException(), isNull);
  });
}
