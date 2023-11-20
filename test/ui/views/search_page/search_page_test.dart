import 'package:al_ameen/data/repository/firebase_repository.dart';
import 'package:al_ameen/ui/view_models/account_provider.dart';
import 'package:al_ameen/ui/views/search_page/search_page.dart';
import 'package:al_ameen/utils/locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import '../../../utils/testing_data.dart';

class MockFirebaseRepositoryImplementation extends Mock
    implements FirebaseRepositoryImplementation {}

void main() {
  late MockFirebaseRepositoryImplementation mockFirebaseRepo;
  late AccountProvider accountProvider;

  setUp(() {
    mockFirebaseRepo = MockFirebaseRepositoryImplementation();
    accountProvider = AccountProvider(mockFirebaseRepo, sharedPreferencesServices);
  });

  Widget createSearchPage() => ChangeNotifierProvider<AccountProvider>(
        create: (_) => accountProvider,
        child: Sizer(builder: (context, orientation, deviceType) {
          return const MaterialApp(
            home: SearchPage(),
          );
        }),
      );
  group('search page widget test: ', () {
    final startDate = DateTime(2023, 09, 01);
    final endDate = DateTime(2023, 09, 14);
    final fromDateButton = find.widgetWithText(GestureDetector, 'From Date');
    final toDateButton = find.widgetWithText(GestureDetector, 'To Date');
    final dropDownButton = find.byType(DropdownButton<String>);
    final applyButton = find.widgetWithText(ElevatedButton, 'Apply');
    final clearButton = find.widgetWithText(ElevatedButton, 'Clear');

    testWidgets('check buttons are present or not', (tester) async {
      await tester.pumpWidget(createSearchPage());
      expect(fromDateButton, findsOneWidget);
      expect(toDateButton, findsOneWidget);
      expect(dropDownButton, findsOneWidget);
      expect(applyButton, findsOneWidget);
      expect(clearButton, findsOneWidget);
      expect(find.byType(ListView), findsNothing);
    });

    testWidgets(
        'select and display from date,to date and dropdown menu from search filter option ',
        (tester) async {
      await tester.pumpWidget(createSearchPage());
      await tester.tap(fromDateButton);
      await tester.pumpAndSettle();
      await tester.tap(find.text(startDate.day.toString()));
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();
      await tester.tap(toDateButton);
      await tester.pumpAndSettle();
      await tester.tap(find.text(endDate.day.toString()));
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();
      await tester.tap(dropDownButton);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Income'));
      await tester.pumpAndSettle();
      expect(find.text(accountProvider.formattedFromDate!), findsOneWidget);
      expect(find.text(accountProvider.formattedToDate!), findsOneWidget);
      expect(find.text(accountProvider.dropDownValue!), findsOneWidget);
    });

    testWidgets('''display listview with data, 
    clear listview searchdata by selecting clear button''', (tester) async {
      when(() => mockFirebaseRepo.searchData(
          start: startDate,
          end: endDate,
          type: 'Income')).thenAnswer((_) async => [listOfData3[4]]);
      await tester.binding.setSurfaceSize(const Size(800, 400));
      tester.binding.platformDispatcher.textScaleFactorTestValue = 0.8;
      await tester.pumpWidget(createSearchPage());
      accountProvider.setFromDate(startDate);
      accountProvider.setToDate(endDate);
      accountProvider.setDropDownValue('Income');
      await tester.tap(applyButton);
      await tester.pump();
      verify(() => mockFirebaseRepo.searchData(
          start: startDate, end: endDate, type: 'Income')).called(1);
      expect(accountProvider.didSearch, true);
      expect(accountProvider.searchedData, hasLength(1));
      expect(find.byType(ListView), findsOneWidget);
      expect(
          find.text(accountProvider.searchedData.first.amount), findsOneWidget);
      await tester.tap(clearButton);
      await tester.pump();
      expect(accountProvider.searchedData, isEmpty);
      expect(accountProvider.didSearch, false);
      expect(find.text("Search For Data"), findsOneWidget);
      await tester.binding.setSurfaceSize(null);
    });

    testWidgets(
        'check search data showing empty while checking with inaccurate dates ',
        (tester) async {
      when(() => mockFirebaseRepo.searchData(
          start: DateTime(2023, 09, 01),
          end: DateTime(2023, 09, 02),
          type: 'Income')).thenAnswer((_) async => []);

      await tester.pumpWidget(createSearchPage());
      accountProvider.setFromDate(DateTime(2023, 09, 01));
      accountProvider.setToDate(DateTime(2023, 09, 02));
      accountProvider.setDropDownValue('Income');
      await tester.tap(applyButton);
      await tester.pumpAndSettle();
      expect(find.text('Searched data not found'), findsOneWidget);
    });
  });
}
