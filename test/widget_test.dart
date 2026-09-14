// Basic smoke test for PlantDoc app.

import 'package:flutter_test/flutter_test.dart';
import 'package:plant_disease_detector/main.dart';

void main() {
  testWidgets('App launches and shows splash screen',
      (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const AgroLuxApp());
    // Splash screen should be visible initially
    expect(find.text('PlantDoc – Crop Disease Detector'), findsNothing);
    await tester.pump(const Duration(milliseconds: 100));
  });
}
