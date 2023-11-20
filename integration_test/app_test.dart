import 'package:al_ameen/data/models/api_status.dart';
import 'package:al_ameen/data/models/data.dart';
import 'package:al_ameen/data/repository/firebase_repository.dart';
import 'package:al_ameen/ui/view_models/account_provider.dart';
import 'package:al_ameen/ui/views/add_details_page/add_details_page.dart';
import 'package:al_ameen/ui/views/navigation_page/home_page.dart';
import 'package:al_ameen/ui/views/transactions_page/transaction_page.dart';
import 'package:al_ameen/utils/shared_preference.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../test/utils/testing_data.dart';

class MockSharedPreferenceServices extends Mock
    implements SharedPreferencesServices {}

class MockFirebaseRepositoryImplementation extends Mock
    implements FirebaseRepositoryImplementation {}

void main() {
  late MockFirebaseRepositoryImplementation mockFirebaseRepo;
  late MockSharedPreferenceServices mockSharedPref;
  late AccountProvider accountProvider;

  setUp(() {
    mockFirebaseRepo = MockFirebaseRepositoryImplementation();
    mockSharedPref = MockSharedPreferenceServices();
    accountProvider = AccountProvider(mockFirebaseRepo, mockSharedPref);
  });

  Widget createHomePage() => ChangeNotifierProvider<AccountProvider>(
        create: (_) {
          accountProvider.getAccountsData();
          return accountProvider;
        },
        child: Sizer(builder: (context, orientation, deviceType) {
          return MaterialApp(home: HomePage(mockSharedPref));
        }),
      );

  //filter employees list data method
  Map<String, List<Data>> seperateListsByName(List<Data> employees) {
    Map<String, List<Data>> eachEmployeesData = {};
    if (employees.isNotEmpty) {
      for (final employee in employees) {
        if (eachEmployeesData.containsKey(employee.name)) {
          eachEmployeesData[employee.name]!.add(employee);
        } else {
          eachEmployeesData[employee.name] = [employee];
        }
      }
    }
    return eachEmployeesData;
  }

  group('app test', () {
    IntegrationTestWidgetsFlutterBinding.ensureInitialized();
    void getCurrentUser() => when(() => mockSharedPref.checkLoginStatus())
        .thenAnswer((_) async => ['jaleel', 'admin123']);

    void getData() => when(() => mockFirebaseRepo.getData())
        .thenAnswer((_) async => Success(response: newListOfData, code: 200));

    void beforeSearch() {
      when(() => mockFirebaseRepo.getDashBoardData()).thenAnswer((_) async {
        final data = Success(response: listOfData3, code: 200);
        return data;
      });
      when(() => mockFirebaseRepo.getEachEmployeeData()).thenAnswer((_) async {
        return seperateListsByName(listOfData3);
      });
    }

    void afterSearch() {
      when(() => mockFirebaseRepo.getDashBoardData(
          fromDate: accountProvider.afromDate,
          toDate: accountProvider.atoDate)).thenAnswer((_) async {
        final data = [listOfData3[4], listOfData3[5]];
        return data;
      });
      when(() => mockFirebaseRepo.getEachEmployeeData(
          fromDate: accountProvider.afromDate,
          toDate: accountProvider.atoDate)).thenAnswer((_) async {
        final data = [listOfData3[4], listOfData3[5]];
        return seperateListsByName(data);
      });
    }

    void insertData() =>
        when(() => mockFirebaseRepo.insert(any())).thenAnswer((_) async {
          newListOfData.add(accountProvider.model);
        });

    void deleteData() =>
        when(() => mockFirebaseRepo.deleteData(any())).thenAnswer((_) async {
          newListOfData.remove(accountProvider.model);
        });

    final transactionsPage = find.byType(TransactionPage);

    final detailsPage = find.byType(AddDetailsPage);

    final addDetails = find.byKey(const Key('open_add_details_page'));
    final search = find.byKey(const Key('search'));
    final transactions = find.byKey(const Key('transaction'));
    final analytics = find.byKey(const Key('analytics'));
    final dateField = find.byKey(const Key('date-field'));
    final amountField = find.byKey(const Key('amount-field'));
    final descriptionField = find.byKey(const Key('description-field'));
    final checkboxField = find.byKey(const Key('checkbox-field'));
    final radioButton1Field = find.byKey(const Key('radio-button1'));
    final submitButton = find.byKey(const Key('submit-button'));
    final today = DateTime.now();

    testWidgets(
        'enter details in add details page, update and display entered data in transactions and analytics page test',
        (tester) async {
      getData();
      beforeSearch();
      getCurrentUser();

      await tester.pumpWidget(createHomePage());
      await tester.pumpAndSettle();
      expect(transactionsPage, findsOneWidget);
      expect(find.byType(BottomAppBar), findsOneWidget);
      await tester.tap(search);
      await tester.pumpAndSettle();
      await tester.tap(analytics);
      await tester.pumpAndSettle();
      await tester.tap(transactions);
      await tester.pumpAndSettle();
      await tester.tap(addDetails);
      await tester.pumpAndSettle();
      expect(detailsPage, findsOneWidget);
      await tester.tap(dateField);
      await tester.pumpAndSettle();
      await tester.tap(find.text(today.day.toString()));
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();
      await tester.enterText(amountField, '160');
      await tester.pumpAndSettle();
      await tester.enterText(descriptionField, 'haircut + beard');
      await tester.pumpAndSettle();
      await tester.tap(radioButton1Field);
      await tester.pumpAndSettle();
      await tester.tap(checkboxField);
      await tester.pumpAndSettle();
      insertData();
      await tester.tap(submitButton);
      await tester.pumpAndSettle();
      expect(transactionsPage, findsOneWidget);
      expect(find.text(newListOfData.first.amount), findsNWidgets(3));
      expect(find.text(newListOfData.first.description!), findsOneWidget);
      expect(find.byType(Slidable), findsOneWidget);

      await tester.drag(find.byType(Slidable), const Offset(400, 0));
      await tester.pumpAndSettle();
      expect(find.byType(SlidableAction), findsOneWidget);
      deleteData();
      await tester.tap(find.byType(SlidableAction));
      await tester.pumpAndSettle();
    });
  });
}



