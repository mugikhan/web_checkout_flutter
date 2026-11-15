import 'package:flutter_test/flutter_test.dart';
import 'package:ui/ui.dart';

import '../support/pump_themed.dart';

void main() {
  Widget timeline(List<TimelineStep> steps) =>
      SizedBox(width: 360, child: StatusTimeline(steps: steps));

  const created = TimelineStep(
    label: 'Created',
    state: TimelineStepState.reached,
    timeText: '10:30',
  );
  const upcoming = TimelineStep(
    label: 'Confirmed',
    state: TimelineStepState.upcoming,
  );
  const confirmed = TimelineStep(
    label: 'Confirmed',
    state: TimelineStepState.reached,
    timeText: '10:33',
  );
  const failed = TimelineStep(
    label: 'Failed',
    state: TimelineStepState.failed,
    timeText: '10:33',
  );

  Color? marker(WidgetTester tester, int index) =>
      tester.widget<Icon>(find.byKey(StatusTimeline.markerKey(index))).color;

  for (final (brightness, colors) in [
    (Brightness.light, AppColors.light),
    (Brightness.dark, AppColors.dark),
  ]) {
    testWidgets('${brightness.name}: steps use primary, onSurfaceVariant '
        'and error', (tester) async {
      await pumpThemed(
        tester,
        timeline([created, upcoming, failed]),
        brightness: brightness,
      );

      expect(marker(tester, 0), colors.primary);
      expect(marker(tester, 1), colors.onSurfaceVariant);
      expect(marker(tester, 2), colors.error);
    });
  }

  testWidgets('shows the time of a reached step and none for an upcoming one', (
    tester,
  ) async {
    await pumpThemed(tester, timeline([created, upcoming]));

    expect(find.text('Created'), findsOneWidget);
    expect(find.text('10:30'), findsOneWidget);
    expect(find.text('Confirmed'), findsOneWidget);
    expect(find.text('10:33'), findsNothing);
  });

  testWidgets('confirmed and failed look different', (tester) async {
    await pumpThemed(tester, timeline([created, confirmed]));
    final confirmedIcon = tester
        .widget<Icon>(find.byKey(StatusTimeline.markerKey(1)))
        .icon;

    await pumpThemed(tester, timeline([created, failed]));
    final failedIcon = tester
        .widget<Icon>(find.byKey(StatusTimeline.markerKey(1)))
        .icon;

    expect(confirmedIcon, Icons.check_circle);
    expect(failedIcon, Icons.cancel);
  });

  testWidgets('a step that turns reached animates over the long token', (
    tester,
  ) async {
    await pumpThemed(tester, timeline([created, upcoming]));
    await pumpThemed(tester, timeline([created, confirmed]));
    await tester.pump();

    await tester.pump(AppMotion.long ~/ 2);
    final midway = tester.widget<Opacity>(
      find.ancestor(of: find.text('10:33'), matching: find.byType(Opacity)),
    );
    expect(midway.opacity, inExclusiveRange(0, 1));
    expect(tester.hasRunningAnimations, isTrue);

    await tester.pump(AppMotion.long);
    expect(tester.hasRunningAnimations, isFalse);
    final done = tester.widget<Opacity>(
      find.ancestor(of: find.text('10:33'), matching: find.byType(Opacity)),
    );
    expect(done.opacity, 1);
  });

  testWidgets('a step shown already reached does not animate', (tester) async {
    await pumpThemed(tester, timeline([created, confirmed]));

    expect(tester.hasRunningAnimations, isFalse);
  });

  testWidgets('a step turns reached at once when animations are disabled', (
    tester,
  ) async {
    tester.platformDispatcher.accessibilityFeaturesTestValue =
        const FakeAccessibilityFeatures(disableAnimations: true);
    addTearDown(tester.platformDispatcher.clearAccessibilityFeaturesTestValue);
    await pumpThemed(tester, timeline([created, upcoming]));

    await pumpThemed(tester, timeline([created, failed]));
    await tester.pump();

    final time = tester.widget<Opacity>(
      find.ancestor(of: find.text('10:33'), matching: find.byType(Opacity)),
    );
    expect(time.opacity, 1);
    expect(marker(tester, 1), AppColors.light.error);
  });

  testWidgets('announces each row with its time or that it is not reached', (
    tester,
  ) async {
    final semantics = tester.ensureSemantics();
    await pumpThemed(tester, timeline([created, upcoming]));

    expect(find.bySemanticsLabel('Created, 10:30'), findsOneWidget);
    expect(find.bySemanticsLabel('Confirmed, not reached yet'), findsOneWidget);
    semantics.dispose();
  });
}
