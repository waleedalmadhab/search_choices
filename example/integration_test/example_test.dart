import 'package:flutster/flutster.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:search_choices_example/main.dart' as app;

void main() async {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Integration testing based on API', (WidgetTester tester) async {
    List<int> ids = [
      4,
      6,
      8,
      10,
      12,
      14,
      16,
      18,
      20,
      22,
      24,
      26,
      28,
      30,
      36,
      38,
      40,
      42,
      44,
      46,
      48,
      50,
      52,
      54,
      56,
      58,
      60,
      64,
      66,
      68,
      70,
      72,
      74,
      76,
      78,
      80,
      // 82,// contains an intentional error that breaks the test
      84,
      86,
      88,
      90,
    ];
    List<int> failedTests = [];
    app.main(testing: true);
    await tester.pumpAndSettle();
    for (int i = 0; i < ids.length; i++) {
      int id = ids[i];
      FlutsterTestRecord record = FlutsterTestRecord.defaultRecord;
      String loadResult = await record.fromApi(id, tester: tester);
      if (loadResult != "Test record loaded from API") {
        expect(false, true, reason: loadResult);
      }
      bool result = await record.playToApi(tester);
      debugPrint("API test over with : $id and result: $result");
      if (!result) {
        failedTests.add(id);
      }
    }
    expect(
      failedTests.isEmpty,
      true,
      reason: "Some tests failed with ids: ${failedTests.join(" ")}",
    );
  });
}
