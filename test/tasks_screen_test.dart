import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tally_task/screens/tasks_screen.dart';

void main() {
  Widget createApp() {
    return const MaterialApp(home: TasksScreen());
  }

  testWidgets('shows empty state when no tasks exist', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(createApp());

    expect(find.text('No tasks yet'), findsOneWidget);
    expect(
      find.text('Tap Add Task to create your first task.'),
      findsOneWidget,
    );
  });

  testWidgets('adds task and changes its status to done', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(createApp());

    await tester.tap(find.text('Add Task'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextFormField).first, 'Pay bills');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Add'));
    await tester.pumpAndSettle();

    expect(find.text('Pay bills'), findsOneWidget);
    expect(find.text('Pending'), findsAtLeastNWidgets(1));

    await tester.tap(find.byIcon(Icons.more_vert).first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Done').last);
    await tester.pumpAndSettle();

    expect(find.text('Done'), findsAtLeastNWidgets(1));
  });

  testWidgets('deletes a task with swipe', (WidgetTester tester) async {
    await tester.pumpWidget(createApp());

    await tester.tap(find.text('Add Task'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextFormField).first, 'Buy milk');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Add'));
    await tester.pumpAndSettle();

    expect(find.text('Buy milk'), findsOneWidget);

    await tester.drag(find.text('Buy milk'), const Offset(-600, 0));
    await tester.pumpAndSettle();

    expect(find.text('Buy milk'), findsNothing);
    expect(find.textContaining('Removed "Buy milk"'), findsOneWidget);
  });
}
