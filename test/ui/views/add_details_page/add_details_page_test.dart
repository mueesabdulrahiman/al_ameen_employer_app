import 'package:al_ameen/data/models/api_status.dart';
import 'package:al_ameen/data/repository/firebase_repository.dart';
import 'package:al_ameen/ui/view_models/account_provider.dart';
import 'package:al_ameen/ui/views/add_details_page/add_details_page.dart';
import 'package:al_ameen/utils/locator.dart';
import 'package:al_ameen/utils/shared_preference.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../../utils/testing_data.dart';

class MockFirebaseRepositoryImplementation extends Mock
    implements FirebaseRepositoryImplementation {}

class MockSharedPreferenceServices extends Mock
    implements SharedPreferencesServices {}

void main() {
  late MockFirebaseRepositoryImplementation mockFirebaseRepo;
  late MockSharedPreferenceServices mockSharedPref;
  late AccountProvider accountProvider;

  setUp(() {
    mockFirebaseRepo = MockFirebaseRepositoryImplementation();
    accountProvider = AccountProvider(mockFirebaseRepo, sharedPreferencesServices);
    mockSharedPref = MockSharedPreferenceServices();
  });

  Widget createAddDetailsPage() => ChangeNotifierProvider<AccountProvider>(
        create: (_) => accountProvider,
        child: Sizer(builder: (context, orientation, deviceType) {
          return MaterialApp(
              home: AddDetailsPage(mockSharedPref.checkLoginStatus()));
        }),
      );

  group('add details page test:', () {
    final dateField = find.byKey(const Key('date-field'));
    final amountField = find.byKey(const Key('amount-field'));
    final descriptionField = find.byKey(const Key('description-field'));
    final radioButton1 = find.byKey(const Key('radio-button1'));
    final radioButton2 = find.byKey(const Key('radio-button2'));
    final checkboxField = find.byKey(const Key('checkbox-field'));
    final submitButton = find.byKey(const Key('submit-button'));
    final submit = find.widgetWithText(ElevatedButton, 'Submit');

    void getData() => when(() => mockFirebaseRepo.getData())
        .thenAnswer((_) async => Success(response: newListOfData, code: 200));

    void insertData() =>
        when(() => mockFirebaseRepo.insert(any())).thenAnswer((_) async {
          newListOfData.add(accountProvider.model);
        });

    testWidgets('check widgets in the form are displayed test', (tester) async {
      await tester.pumpWidget(createAddDetailsPage());
      await tester.pump();
      expect(dateField, findsOneWidget);
      expect(amountField, findsOneWidget);
      expect(descriptionField, findsOneWidget);
      expect(radioButton1, findsOneWidget);
      expect(radioButton2, findsOneWidget);
      expect(checkboxField, findsOneWidget);
      expect(submitButton, findsOneWidget);
    });

    testWidgets('validate add details page form data ', (tester) async {
      final date = DateTime.now();

      when(() async => await mockSharedPref.checkLoginStatus())
          .thenAnswer((_) async => ['muees', 'admin123']);
      await tester.pumpWidget(createAddDetailsPage());
      await tester.pump();
      await tester.tap(dateField);
      await tester.pumpAndSettle();
      await tester.tap(find.text(date.day.toString()));
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();
      await tester.enterText(amountField, '100');
      await tester.enterText(descriptionField, 'haircut');
      await tester.tap(radioButton1);
      await tester.pumpAndSettle();
      await tester.tap(checkboxField);

      insertData();
      getData();

      await tester.tap(submit);
      await tester.pumpAndSettle();
      verify(() => mockSharedPref.checkLoginStatus()).called(1);
      verify(() => mockFirebaseRepo.insert(any())).called(1);
      verify(() => mockFirebaseRepo.getData()).called(1);
      expect(accountProvider.getData, newListOfData);
    });

    testWidgets('tap submit button without adding data test', (tester) async {
      await tester.pumpWidget(createAddDetailsPage());
      await tester.pump();
      await tester.tap(submitButton);
      await tester.pumpAndSettle();
      expect(find.text('amount should not be empty'), findsOneWidget);
    });
  });
}
