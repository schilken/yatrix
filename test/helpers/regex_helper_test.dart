import 'package:flutter_test/flutter_test.dart';
import 'package:yatrix/helpers/regex_helper.dart';

void main() {
  testWidgets('regex finds is in message', (tester) async {
    final message = '''
Here is your ServerId for YaTriX: Copy the whole message unchanged to your clipboard -> j2_EE06
Open the game at https://schilken.de/yatrix, select "Two-Player-Mode" and tap on "Connect"
''';
    final id = RegexHelper.extractIdFromMessage(message);
    expect(id, 'j2_EE06');
  });
}
