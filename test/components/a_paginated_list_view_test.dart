import 'package:flutter/material.dart';
import 'package:flutter_artis_ui_kit/flutter_artis_ui_kit.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _app(Widget child) => MaterialApp(
  theme: AThemeBuilder.light(tone: ATone.fromBrand(const Color(0xFF3182F6))),
  home: Scaffold(body: child),
);

Widget _item(BuildContext context, int i) =>
    SizedBox(height: 50, child: Text('item $i'));

void main() {
  testWidgets('calls onLoadMore when scrolled near the end', (tester) async {
    var calls = 0;
    await tester.pumpWidget(
      _app(
        APaginatedListView(
          itemCount: 100,
          itemBuilder: _item,
          onLoadMore: () => calls++,
          loadMoreThreshold: 100,
        ),
      ),
    );
    await tester.pump();
    expect(calls, 0);

    await tester.drag(find.byType(ListView), const Offset(0, -1000));
    await tester.pump();
    expect(calls, 0);

    await tester.fling(find.byType(ListView), const Offset(0, -10000), 5000);
    await tester.pumpAndSettle();
    expect(calls, greaterThan(0));
  });

  testWidgets('calls onLoadMore once when content is not scrollable', (
    tester,
  ) async {
    var calls = 0;
    await tester.pumpWidget(
      _app(
        APaginatedListView(
          itemCount: 2,
          itemBuilder: _item,
          onLoadMore: () => calls++,
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(calls, 1);
  });

  testWidgets('does not call onLoadMore while loading; rechecks after', (
    tester,
  ) async {
    var calls = 0;
    Widget list({required bool loading}) => _app(
      APaginatedListView(
        itemCount: 2,
        itemBuilder: _item,
        onLoadMore: () => calls++,
        isLoadingMore: loading,
      ),
    );

    await tester.pumpWidget(list(loading: true));
    await tester.pump();
    expect(calls, 0);

    await tester.pumpWidget(list(loading: false));
    await tester.pump();
    expect(calls, 1);
  });

  testWidgets('shows the footer only while loading more', (tester) async {
    Widget list({required bool loading}) => _app(
      APaginatedListView(
        itemCount: 3,
        itemBuilder: _item,
        separatorBuilder: (_, _) => const Divider(),
        onLoadMore: () {},
        isLoadingMore: loading,
      ),
    );

    await tester.pumpWidget(list(loading: false));
    expect(find.byType(ALoadMoreIndicator), findsNothing);
    expect(find.byType(Divider), findsNWidgets(2));

    await tester.pumpWidget(list(loading: true));
    expect(find.byType(ALoadMoreIndicator), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    // 마지막 항목과 푸터 사이에는 구분선이 없다.
    expect(find.byType(Divider), findsNWidgets(2));
  });
}
