/// Artis UI Kit — Flutter Material 위에 얹는 디자인 시스템.
///
/// 표준 위젯은 [AThemeBuilder] 가 만든 `ThemeData` 로 모양을 맞추고, 표준에 없는 부품만 `A` 접두사 위젯으로 제공한다.
/// 구성과 원칙은 README.md 를 본다.
///
/// 옛 위젯(`AButton.large` 등 1.0 이전 API)은 `package:flutter_artis_ui_kit/legacy.dart` 에 있다.
library;

// foundation
export 'src/foundation/a_palette.dart';
export 'src/foundation/a_tokens.dart';
export 'src/foundation/a_tone.dart';
export 'src/foundation/a_typography.dart';
export 'src/foundation/contrast.dart';
// theme
export 'src/theme/a_theme_builder.dart';
export 'src/theme/a_theme_data.dart';
// layout
export 'src/layout/a_content_width.dart';
export 'src/layout/a_window_size.dart';
// navigation
export 'src/navigation/a_floating_navigation_scaffold.dart';
export 'src/navigation/a_breadcrumb.dart';
export 'src/navigation/a_floating_navigation_bar.dart';
export 'src/navigation/a_title_tabs.dart';
// buttons
export 'src/buttons/a_button.dart';
// surfaces
export 'src/surfaces/a_card.dart';
export 'src/surfaces/a_section_card.dart';
// lists
export 'src/lists/a_key_value_row.dart';
export 'src/lists/a_list_row.dart';
export 'src/lists/a_stat_group.dart';
// selection
export 'src/selection/a_option_tile.dart';
export 'src/selection/a_pick_card.dart';
export 'src/selection/a_segmented_control.dart';
// display
export 'src/display/a_emoji_tile.dart';
export 'src/display/a_tag.dart';
// feedback
export 'src/feedback/a_empty_state.dart';
export 'src/feedback/a_skeleton.dart';
// overlays
export 'src/overlays/a_bottom_sheet.dart';
export 'src/overlays/a_dialog.dart';
// bars
export 'src/bars/a_app_bar.dart';
export 'src/bars/a_bottom_bar.dart';
export 'src/bars/a_selection_bar.dart';
// scroll
export 'src/scroll/a_paginated_list_view.dart';
