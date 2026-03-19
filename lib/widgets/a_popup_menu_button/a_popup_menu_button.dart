part of '../../flutter_artis_ui_kit.dart';

/// [APopupMenuButton]에 표시할 메뉴 아이템 데이터.
///
/// [icon]과 [label]로 구성된 기본 레이아웃을 제공한다.
/// 완전히 커스텀한 레이아웃이 필요하면 [APopupMenuButton.custom]을 사용한다.
class APopupMenuItem<T> {
  /// 선택 시 [APopupMenuButton.onSelected]에 전달되는 값.
  final T value;

  /// 아이템 왼쪽에 표시되는 아이콘.
  final IconData icon;

  /// 아이콘 오른쪽에 표시되는 텍스트.
  final String label;

  /// false이면 아이템이 비활성화되어 선택할 수 없다.
  final bool enabled;

  const APopupMenuItem({
    required this.value,
    required this.icon,
    required this.label,
    this.enabled = true,
  });
}

/// 아이콘 + 라벨 구성의 팝업 메뉴 버튼.
///
/// Flutter의 [PopupMenuButton]을 래핑하여 둥근 모서리, 그림자 등
/// 일관된 스타일과 간결한 데이터 기반 API를 제공한다.
///
/// ## 기본 사용법
/// ```dart
/// APopupMenuButton<MyAction>(
///   items: [
///     APopupMenuItem(value: MyAction.edit, icon: Icons.edit, label: '편집'),
///     APopupMenuItem(value: MyAction.delete, icon: Icons.delete, label: '삭제'),
///   ],
///   onSelected: (action) { ... },
/// )
/// ```
///
/// ## 트리거 아이콘 변경
/// ```dart
/// APopupMenuButton<MyAction>(
///   icon: const Icon(Icons.add),
///   items: [...],
///   onSelected: (action) { ... },
/// )
/// ```
///
/// ## 완전 커스텀 아이템
/// ```dart
/// APopupMenuButton<MyAction>.custom(
///   itemBuilder: (context) => [
///     PopupMenuItem(value: MyAction.edit, child: MyCustomWidget()),
///   ],
///   onSelected: (action) { ... },
/// )
/// ```
class APopupMenuButton<T> extends StatelessWidget {
  /// 버튼을 탭했을 때 표시할 메뉴 아이템 목록.
  ///
  /// [APopupMenuItem]을 사용하는 기본 생성자에서만 유효하다.
  final List<APopupMenuItem<T>>? items;

  /// 완전히 커스텀한 아이템 빌더.
  ///
  /// [APopupMenuButton.custom] 생성자에서만 유효하다.
  final List<PopupMenuEntry<T>> Function(BuildContext)? itemBuilder;

  /// 아이템이 선택되었을 때 호출된다.
  final void Function(T value)? onSelected;

  /// 팝업 메뉴를 여는 트리거 위젯.
  ///
  /// 기본값은 [Icons.more_vert].
  final Widget icon;

  /// false이면 버튼이 비활성화되어 메뉴가 열리지 않는다.
  final bool enabled;

  /// 메뉴 카드의 그림자 깊이.
  final double elevation;

  /// 버튼 기준으로 메뉴가 열리는 위치 오프셋.
  final Offset offset;

  /// 메뉴 카드의 모서리 반경.
  final double borderRadius;

  /// 메뉴 카드의 배경색. null이면 테마 기본값을 사용한다.
  final Color? menuColor;

  /// 버튼의 스플래시 반경.
  final double? splashRadius;

  /// 버튼 주변 패딩.
  final EdgeInsetsGeometry padding;

  /// 메뉴가 열릴 때 호출된다.
  final VoidCallback? onOpened;

  /// 아이템 선택 없이 메뉴가 닫힐 때 호출된다.
  final VoidCallback? onCanceled;

  /// 접근성 툴팁 텍스트.
  final String? tooltip;

  const APopupMenuButton({
    super.key,
    required List<APopupMenuItem<T>> this.items,
    this.onSelected,
    this.icon = const Icon(Icons.more_vert),
    this.enabled = true,
    this.elevation = 8,
    this.offset = const Offset(0, 48),
    this.borderRadius = 12,
    this.menuColor,
    this.splashRadius,
    this.padding = const EdgeInsets.all(8),
    this.onOpened,
    this.onCanceled,
    this.tooltip,
  }) : itemBuilder = null;

  /// 완전히 커스텀한 [PopupMenuEntry] 목록을 사용하는 생성자.
  ///
  /// [APopupMenuItem]의 기본 레이아웃(아이콘 + 라벨) 대신
  /// 임의의 위젯을 메뉴 아이템으로 사용할 수 있다.
  const APopupMenuButton.custom({
    super.key,
    required List<PopupMenuEntry<T>> Function(BuildContext) this.itemBuilder,
    this.onSelected,
    this.icon = const Icon(Icons.more_vert),
    this.enabled = true,
    this.elevation = 8,
    this.offset = const Offset(0, 48),
    this.borderRadius = 12,
    this.menuColor,
    this.splashRadius,
    this.padding = const EdgeInsets.all(8),
    this.onOpened,
    this.onCanceled,
    this.tooltip,
  }) : items = null;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<T>(
      icon: icon,
      enabled: enabled,
      elevation: elevation,
      offset: offset,
      color: menuColor,
      splashRadius: splashRadius,
      padding: padding,
      tooltip: tooltip,
      onOpened: onOpened,
      onCanceled: onCanceled,
      onSelected: onSelected,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      itemBuilder: itemBuilder ?? _buildDefaultItems,
    );
  }

  List<PopupMenuEntry<T>> _buildDefaultItems(BuildContext context) {
    return items!
        .map(
          (item) => PopupMenuItem<T>(
            value: item.value,
            enabled: item.enabled,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(item.icon, size: 20),
                const SizedBox(width: 10),
                Text(item.label),
              ],
            ),
          ),
        )
        .toList();
  }
}
