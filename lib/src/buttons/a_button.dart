import 'package:flutter/material.dart';

import '../theme/a_theme_data.dart';

const double _largeHeight = 56;
const double _mediumHeight = 44;
const double _smallHeight = 32;
const double _minWidth = 64;
const double _spinnerSize = 18;

/// [AButton] 의 크기 — 높이 · 모서리 · 글자.
enum AButtonSize {
  /// 56 · `radii.lg` · `titleMedium`. 화면 하단 CTA.
  large,

  /// 44 · `radii.md` · `labelLarge`. 카드 안 · 다이얼로그.
  medium,

  /// 32(터치 영역은 48) · `radii.sm` · 13.5. 행 끝 · 앱바.
  small,
}

enum _Variant { primary, tonal, neutral, danger, text }

/// 킷 버튼 — 변형(주 · 톤 · 회색 · 위험 · 텍스트) × 크기 × 로딩을 한 API 로.
///
/// 내부는 표준 [FilledButton] / [TextButton] 이고, [style] 은 킷 기본값 위에 덮인다.
/// [onPressed] 가 `null` 이면 비활성, [isLoading] 이면 색은 그대로 두고 스피너를 보이며 탭을 막는다.
/// 꽉 찬 폭이 필요하면 `SizedBox(width: double.infinity)` 로 감싼다.
///
/// ```dart
/// AButton(onPressed: save, isLoading: saving, child: const Text('저장'))
/// AButton.tonal(onPressed: share, icon: const Icon(Icons.share), child: const Text('공유'))
/// ```
class AButton extends StatefulWidget {
  /// 주 버튼(primary 면 · 흰 글자).
  const AButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.icon,
    this.size = AButtonSize.large,
    this.isLoading = false,
    this.style,
  }) : _variant = _Variant.primary;

  /// 톤 버튼(연한 primary 면).
  const AButton.tonal({
    super.key,
    required this.onPressed,
    required this.child,
    this.icon,
    this.size = AButtonSize.large,
    this.isLoading = false,
    this.style,
  }) : _variant = _Variant.tonal;

  /// 회색 버튼(보조 동작 · 취소).
  const AButton.neutral({
    super.key,
    required this.onPressed,
    required this.child,
    this.icon,
    this.size = AButtonSize.large,
    this.isLoading = false,
    this.style,
  }) : _variant = _Variant.neutral;

  /// 위험 버튼(삭제).
  const AButton.danger({
    super.key,
    required this.onPressed,
    required this.child,
    this.icon,
    this.size = AButtonSize.large,
    this.isLoading = false,
    this.style,
  }) : _variant = _Variant.danger;

  /// 텍스트 버튼(면 없음 · primary 글자).
  const AButton.text({
    super.key,
    required this.onPressed,
    required this.child,
    this.icon,
    this.size = AButtonSize.large,
    this.isLoading = false,
    this.style,
  }) : _variant = _Variant.text;

  /// 눌렀을 때. `null` 이면 비활성.
  final VoidCallback? onPressed;

  /// 라벨 — 보통 [Text].
  final Widget child;

  /// 라벨 앞 아이콘.
  final Widget? icon;

  /// 크기.
  final AButtonSize size;

  /// `true` 면 스피너를 보이고 탭을 무시한다.
  final bool isLoading;

  /// 킷 기본값 위에 덮을 스타일.
  final ButtonStyle? style;

  final _Variant _variant;

  @override
  State<AButton> createState() => _AButtonState();
}

class _AButtonState extends State<AButton> {
  final _states = WidgetStatesController();
  bool _pressed = false;

  @override
  void initState() {
    super.initState();
    _states.addListener(_onStates);
  }

  void _onStates() {
    final pressed = _states.value.contains(WidgetState.pressed);
    if (pressed != _pressed) setState(() => _pressed = pressed);
  }

  @override
  void dispose() {
    _states.dispose();
    super.dispose();
  }

  ButtonStyle _defaults(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    final a = AThemeData.of(context);
    final (bg, fg) = switch (widget._variant) {
      _Variant.primary => (cs.primary, cs.onPrimary),
      _Variant.tonal => (cs.primaryContainer, cs.onPrimaryContainer),
      _Variant.neutral => (cs.secondaryContainer, cs.onSecondaryContainer),
      _Variant.danger => (cs.error, cs.onError),
      _Variant.text => (Colors.transparent, cs.primary),
    };
    final isText = widget._variant == _Variant.text;
    // 로딩 중에는 onPressed 를 끊지만 색은 변형 그대로 둔다.
    bool disabled(Set<WidgetState> s) =>
        s.contains(WidgetState.disabled) && !widget.isLoading;
    final (height, radius, style, padding) = switch (widget.size) {
      AButtonSize.large => (
        _largeHeight,
        a.radii.lg,
        text.titleMedium,
        a.spacing.xl,
      ),
      AButtonSize.medium => (
        _mediumHeight,
        a.radii.md,
        text.labelLarge,
        a.spacing.lg,
      ),
      AButtonSize.small => (
        _smallHeight,
        a.radii.sm,
        text.labelLarge?.copyWith(fontSize: text.bodySmall?.fontSize),
        a.spacing.md,
      ),
    };
    return ButtonStyle(
      backgroundColor: WidgetStateProperty.resolveWith(
        (s) => disabled(s) && !isText ? cs.surfaceContainerHigh : bg,
      ),
      foregroundColor: WidgetStateProperty.resolveWith(
        (s) => disabled(s) ? cs.outline : fg,
      ),
      textStyle: WidgetStatePropertyAll(style),
      minimumSize: WidgetStatePropertyAll(Size(_minWidth, height)),
      padding: WidgetStatePropertyAll(
        EdgeInsets.symmetric(horizontal: padding),
      ),
      shape: WidgetStatePropertyAll(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius)),
      ),
      elevation: const WidgetStatePropertyAll(0),
      tapTargetSize: MaterialTapTargetSize.padded,
    );
  }

  @override
  Widget build(BuildContext context) {
    final a = AThemeData.of(context);
    final style = (widget.style ?? const ButtonStyle()).merge(
      _defaults(context),
    );
    final label = widget.icon == null
        ? widget.child
        : Row(
            mainAxisSize: MainAxisSize.min,
            spacing: a.spacing.sm,
            children: [
              widget.icon!,
              Flexible(child: widget.child),
            ],
          );
    final content = Stack(
      alignment: Alignment.center,
      children: [
        Opacity(
          opacity: widget.isLoading ? 0 : 1,
          alwaysIncludeSemantics: true,
          child: label,
        ),
        if (widget.isLoading)
          SizedBox.square(
            dimension: _spinnerSize,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: style.foregroundColor?.resolve(const {}),
            ),
          ),
      ],
    );
    final onPressed = widget.isLoading ? null : widget.onPressed;
    final button = widget._variant == _Variant.text
        ? TextButton(
            onPressed: onPressed,
            style: style,
            statesController: _states,
            child: content,
          )
        : FilledButton(
            onPressed: onPressed,
            style: style,
            statesController: _states,
            child: content,
          );
    final animate = !MediaQuery.disableAnimationsOf(context);
    return AnimatedScale(
      scale: _pressed && animate ? a.motion.pressScale : 1,
      duration: animate ? a.motion.short : Duration.zero,
      child: button,
    );
  }
}
