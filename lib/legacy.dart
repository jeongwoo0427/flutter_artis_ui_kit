/// 1.0 이전의 옛 위젯 모음 — 새 코드에서 쓰지 않는다.
///
/// 새 디자인 시스템(`package:flutter_artis_ui_kit/flutter_artis_ui_kit.dart`)으로 옮기는 동안만
/// 남겨 두고 **2.0.0 에서 삭제한다.** 옮기는 방법은 `doc/migration_from_legacy.md`.
///
/// `@Deprecated` 는 붙이지 않는다 — 앱이 단계적으로 옮기는 동안 사용처마다 경고가 쏟아져
/// 다른 경고가 묻히기 때문이다. 대신 import 경로(`legacy.dart`)로 남은 사용처를 찾는다.
library;

import 'package:flutter/material.dart';
import 'dart:async';

part 'src/legacy/a_well/a_well.dart';
part 'src/legacy/text/a_sample_text.dart';
part 'src/legacy/a_card/a_card.dart';
part 'src/legacy/a_card/a_card_button/a_card_button.dart';
part 'src/legacy/a_bottom_navigation_bar/a_bottom_navigation_bar.dart';
part 'src/legacy/a_button/a_button.dart';
part 'src/legacy/a_text_form_field/a_text_form_field.dart';
part 'src/legacy/a_popup_menu_button/a_popup_menu_button.dart';

