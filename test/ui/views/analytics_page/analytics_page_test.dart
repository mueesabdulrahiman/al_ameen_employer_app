import 'package:al_ameen/data/models/api_status.dart';
import 'package:al_ameen/data/models/data.dart';
import 'package:al_ameen/data/repository/firebase_repository.dart';
import 'package:al_ameen/ui/view_models/account_provider.dart';
import 'package:al_ameen/ui/views/analytics_page/analytics_page.dart';
import 'package:al_ameen/ui/views/analytics_page/components/dashboard.dart';
import 'package:al_ameen/ui/views/analytics_page/components/employee_pageview.dart';
import 'package:al_ameen/ui/views/analytics_page/components/linechart.dart';
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
  final startDate = DateTime(
      2023, DateTime.now().subtract(const Duration(days: 30)).month, 03);
  final endDate = DateTime(2023, DateTime.now().month, 01);

  setUp(() {
    mockFirebaseRepo = MockFirebaseRepositoryImplementation();
    accountProvider = AccountProvider(mockFirebaseRepo, sharedPreferencesServices);
    
  });

  //analytics page
  Widget createAnalyticsPage() => ChangeNotifierProvider<AccountProvider>(
        create: (_) => accountProvider,
        child: Sizer(builder: (context, orientation, deviceType) {
          return const MaterialApp(home: AnalyticsPage());
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

  group('analytics page widget test:', () {
    
    final datePicker = find.byType(DatePickerDialog);

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

    testWidgets('Check every component widgets of analytics page are present',
        (tester) async {
      beforeSearch();

      await tester.pumpWidget(createAnalyticsPage());
      verify(() => mockFirebaseRepo.getDashBoardData()).called(1);
      verify(() => mockFirebaseRepo.getEachEmployeeData()).called(1);
      expect(find.byType(BuildAnalyticsDashboard), findsOneWidget);
      expect(find.byType(EmployeePageViewBuilder), findsOneWidget);
      expect(find.byType(LineChartAccountData), findsOneWidget);
    });

    testWidgets(
        'display initial data of dashboard and each employee card widgets ',
        (tester) async {
      beforeSearch();

      await tester.pumpWidget(createAnalyticsPage());
      await tester.pumpAndSettle();
      int netIncome = 0;
      int netExpense = 0;
      int netBalance = 0;
      final data = accountProvider.getAllData;
      for (final d in data) {
        d.type == 'income'
            ? netIncome += int.parse(d.amount)
            : netExpense += int.parse(d.amount);
      }
      netBalance = netIncome - netExpense;
      expect(find.text(netIncome.toString()), findsOneWidget);
      expect(find.text(netExpense.toString()), findsNWidgets(3));
      expect(find.text(netBalance.toString()), findsOneWidget);

      final anotherData = accountProvider.employersData;
      List<String> empNames = [];
      empNames = anotherData.keys.toList();
      final values = anotherData.values.toList();
      for (int i = 0; i < values.length; i++) {
        int netIncOffline = 0;
        int netExpOffline = 0;
        int netIncOnline = 0;
        int netExpOnline = 0;
        final value = values.elementAt(i);
        for (var element in value) {
          if (element.type == 'income') {
            if (element.payment == 'Money') {
              netIncOffline += int.parse(element.amount);
            } else {
              netIncOnline += int.parse(element.amount);
            }
          } else if (element.type == 'expense') {
            if (element.payment == 'Money') {
              netExpOffline += int.parse(element.amount);
            } else {
              netExpOnline += int.parse(element.amount);
            }
          }
        }
        expect(find.text(netIncOnline.toString()), findsWidgets);
        expect(find.text(netIncOffline.toString()), findsWidgets);
        expect(find.text(netExpOnline.toString()), findsWidgets);
        expect(find.text(netExpOffline.toString()), findsWidgets);
        expect(find.text(empNames[i]), findsOneWidget);
        final pageviewBuilder = find.byType(PageView);
        await tester.drag(pageviewBuilder, const Offset(-400, 0));
        await tester.pumpAndSettle();
      }
    });

    testWidgets(
        '''select from and to dates and tap search button then selected dates are displayed in datepicker,
         update and display filtered data of dashboard and each employee card widgets''',
        (tester) async {
      final searchButton = find.widgetWithText(ElevatedButton, 'Search');
      beforeSearch();
      await tester.pumpWidget(createAnalyticsPage());
      await tester.tap(find.text('From Date'));
      await tester.pumpAndSettle();
      await tester.drag(datePicker, const Offset(200, 0));
      await tester.pumpAndSettle();
      await tester.tap(find.text(startDate.day.toString()));
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('To Date'));
      await tester.pumpAndSettle();
      await tester.tap(find.text(endDate.day.toString()));
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();
      expect(find.text(accountProvider.aformattedFromDate!), findsOneWidget);
      expect(find.text(accountProvider.aformattedToDate!), findsOneWidget);
      afterSearch();
      await tester.tap(searchButton);
      await tester.pumpAndSettle();

      final data = accountProvider.getAllData;
      int netIncome = 0;
      int netExpense = 0;
      int netBalance = 0;
      for (final d in data) {
        d.type == 'income'
            ? netIncome += int.parse(d.amount)
            : netExpense += int.parse(d.amount);
      }
      netBalance = netIncome - netExpense;

      expect(find.text(netIncome.toString()), findsNWidgets(2));
      expect(find.text(netExpense.toString()), findsWidgets);
      expect(find.text(netBalance.toString()), findsWidgets);

      final anotherData = accountProvider.employersData;
      int netIncOffline = 0;
      int netExpOffline = 0;
      int netIncOnline = 0;
      int netExpOnline = 0;
      List<String> empNames = [];
      empNames = anotherData.keys.toList();
      final values = anotherData.values.toList();
      for (int i = 0; i < values.length; i++) {
        final value = values.elementAt(i);
        for (var element in value) {
          if (element.type == 'income') {
            if (element.payment == 'Money') {
              netIncOffline += int.parse(element.amount);
            } else {
              netIncOnline += int.parse(element.amount);
            }
          } else if (element.type == 'expense') {
            if (element.payment == 'Money') {
              netExpOffline += int.parse(element.amount);
            } else {
              netExpOnline += int.parse(element.amount);
            }
          }
        }
        expect(find.text(netIncOnline.toString()), findsWidgets);
        expect(find.text(netIncOffline.toString()), findsWidgets);
        expect(find.text(netExpOnline.toString()), findsWidgets);
        expect(find.text(netExpOffline.toString()), findsWidgets);
        expect(find.text(empNames[i]), findsOneWidget);
        final pageviewBuilder = find.byType(PageView);
        await tester.drag(pageviewBuilder, const Offset(-400, 0));
        await tester.pumpAndSettle();
      }
    });
  });
}
