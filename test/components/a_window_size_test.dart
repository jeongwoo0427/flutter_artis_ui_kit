import 'package:flutter_artis_ui_kit/flutter_artis_ui_kit.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('fromWidth boundaries', () {
    expect(AWindowSize.fromWidth(599), AWindowSize.compact);
    expect(AWindowSize.fromWidth(600), AWindowSize.medium);
    expect(AWindowSize.fromWidth(839), AWindowSize.medium);
    expect(AWindowSize.fromWidth(840), AWindowSize.expanded);
  });
}
