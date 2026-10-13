import 'package:flutter/material.dart';

import '../theme/a_theme_data.dart';

const double _indicatorSize = 24;

/// 끝에 가까워지면 [onLoadMore] 를 부르는 목록.
///
/// 끝에서 [loadMoreThreshold] 안으로 들어오거나, 항목이 화면보다 짧아 스크롤할 수 없을 때 부른다.
/// [isLoadingMore] 인 동안에는 부르지 않고 맨 아래에 [ALoadMoreIndicator] 를 보인다.
/// 더 불러올 것이 없으면 [onLoadMore] 를 `null` 로 넘긴다.
/// [physics] 기본값은 `AlwaysScrollableScrollPhysics` — 짧은 목록에서도 `RefreshIndicator` 가 동작한다.
///
/// ```dart
/// APaginatedListView(
///   itemCount: items.length,
///   itemBuilder: (context, i) => ItemRow(items[i]),
///   onLoadMore: hasMore ? notifier.loadMore : null,
///   isLoadingMore: isLoadingMore,
/// )
/// ```
class APaginatedListView extends StatefulWidget {
  /// 목록을 만든다.
  const APaginatedListView({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    this.separatorBuilder,
    this.onLoadMore,
    this.isLoadingMore = false,
    this.padding,
    this.controller,
    this.physics,
    this.loadMoreThreshold = 300,
  });

  /// 항목 수(푸터 제외).
  final int itemCount;

  /// 항목.
  final IndexedWidgetBuilder itemBuilder;

  /// 항목 사이 구분선.
  final IndexedWidgetBuilder? separatorBuilder;

  /// 끝에 가까워졌을 때. `null` 이면 더 불러올 것이 없다.
  final VoidCallback? onLoadMore;

  /// 불러오는 중 — 맨 아래 스피너를 보이고 [onLoadMore] 를 다시 부르지 않는다.
  final bool isLoadingMore;

  /// 목록 안쪽 여백.
  final EdgeInsetsGeometry? padding;

  /// 바깥에서 스크롤을 다룰 때.
  final ScrollController? controller;

  /// 스크롤 물리. 기본 `AlwaysScrollableScrollPhysics`.
  final ScrollPhysics? physics;

  /// 끝에서 이만큼(px) 남았을 때 부른다.
  final double loadMoreThreshold;

  @override
  State<APaginatedListView> createState() => _APaginatedListViewState();
}

class _APaginatedListViewState extends State<APaginatedListView> {
  ScrollController? _ownController;

  ScrollController get _controller =>
      widget.controller ?? (_ownController ??= ScrollController());

  @override
  void initState() {
    super.initState();
    _controller.addListener(_maybeLoadMore);
    // 첫 화면이 viewport 보다 짧아 스크롤할 수 없을 때도 한 번 검사한다.
    _checkAfterLayout();
  }

  @override
  void didUpdateWidget(covariant APaginatedListView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      (oldWidget.controller ?? _ownController)?.removeListener(_maybeLoadMore);
      _controller.addListener(_maybeLoadMore);
    }
    // 항목 수가 바뀌거나(줄어든 경우 포함) 로드 가능 여부 · 로딩이 끝나면 레이아웃 뒤 다시 검사한다 —
    // 스크롤 이벤트만으로는 짧아진 목록에서 다시 불리지 않는다.
    final countChanged = oldWidget.itemCount != widget.itemCount;
    final loadableToggled =
        (oldWidget.onLoadMore == null) != (widget.onLoadMore == null);
    final loadingEnded = oldWidget.isLoadingMore && !widget.isLoadingMore;
    if (countChanged || loadableToggled || loadingEnded) _checkAfterLayout();
  }

  @override
  void dispose() {
    widget.controller?.removeListener(_maybeLoadMore);
    _ownController?.dispose();
    super.dispose();
  }

  void _checkAfterLayout() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _maybeLoadMore();
    });
  }

  void _maybeLoadMore() {
    final onLoadMore = widget.onLoadMore;
    if (onLoadMore == null || widget.isLoadingMore) return;
    if (!_controller.hasClients) return;
    final pos = _controller.position;
    final nearEnd =
        pos.pixels >= pos.maxScrollExtent - widget.loadMoreThreshold;
    // 콘텐츠가 viewport 보다 짧아 스크롤 자체가 안 되는 경우의 폴백.
    final notScrollable = pos.maxScrollExtent <= 0;
    if (nearEnd || notScrollable) onLoadMore();
  }

  @override
  Widget build(BuildContext context) {
    final hasFooter = widget.isLoadingMore;
    final total = widget.itemCount + (hasFooter ? 1 : 0);

    return ListView.separated(
      controller: _controller,
      padding: widget.padding,
      physics: widget.physics ?? const AlwaysScrollableScrollPhysics(),
      itemCount: total,
      separatorBuilder: (context, index) {
        if (hasFooter && index == total - 2) return const SizedBox.shrink();
        return widget.separatorBuilder?.call(context, index) ??
            const SizedBox.shrink();
      },
      itemBuilder: (context, index) {
        if (hasFooter && index == total - 1) return const ALoadMoreIndicator();
        return widget.itemBuilder(context, index);
      },
    );
  }
}

/// 목록 맨 아래의 "더 불러오는 중" 스피너.
///
/// 직접 만든 `CustomScrollView` 에서는 `SliverToBoxAdapter(child: ALoadMoreIndicator())` 로 쓴다.
class ALoadMoreIndicator extends StatelessWidget {
  /// 스피너를 만든다.
  const ALoadMoreIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: AThemeData.of(context).spacing.lg,
      ),
      child: const Center(
        child: SizedBox.square(
          dimension: _indicatorSize,
          child: CircularProgressIndicator(strokeWidth: 3),
        ),
      ),
    );
  }
}
