import 'package:al_ameen/data/models/api_status.dart';
import 'package:al_ameen/data/models/data.dart';
import 'package:al_ameen/data/repository/firebase_repository.dart';
import 'package:al_ameen/ui/view_models/account_provider.dart';
import 'package:al_ameen/utils/shared_preference.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import '../../utils/testing_data.dart';

class MockFirebaseRepositoryImplementation extends Mock
    implements FirebaseRepositoryImplementation {}

class MockSharedPreferenceServices extends Mock
    implements SharedPreferencesServices {}

void main() {
  late MockFirebaseRepositoryImplementation mockFirebaseRepo;
  late AccountProvider accountProvider;
  late MockSharedPreferenceServices mocksharedPref;

  setUp(() async {
    mockFirebaseRepo = MockFirebaseRepositoryImplementation();
    mocksharedPref = MockSharedPreferenceServices();
    accountProvider = AccountProvider(mockFirebaseRepo, mocksharedPref);
  });

  group('AccountProvider class test', () {
    group('getAccountsData() method test', () {
      void successData() => when(() => mockFirebaseRepo.getData())
          .thenAnswer((_) async => Success(response: listofData1, code: 200));
      void failureData() => when(() => mockFirebaseRepo.getData())
          .thenAnswer((_) async => Failure(response: 'Error', code: 404));

      test('verify', () async {
        successData();
        await accountProvider.getAccountsData();
        verify(() => mockFirebaseRepo.getData()).called(1);
      });

      test(' success data', () async {
        successData();
        final future = accountProvider.getAccountsData();
        expect(accountProvider.loading, true);
        await future;
        expect(accountProvider.getData, listofData1);
        expect(accountProvider.loading, false);
      });

      test(' failure data', () async {
        failureData();
        final future = accountProvider.getAccountsData();
        expect(accountProvider.loading, true);
        await future;
        expect(accountProvider.errorText, 'Error');
        expect(accountProvider.loading, false);
      });
    });

    group('getAllUsersList() method test', () {
      const data = {'Muees-Admin', 'Jaleel-Director', 'Anchu-Staff'};
      void successData() => when(() => mockFirebaseRepo.getAllUsers())
          .thenAnswer((_) async => data);
      void failureData() => when(() => mockFirebaseRepo.getAllUsers())
          .thenAnswer((_) async => Failure(response: 'Error', code: 404));

      test('success data', () async {
        successData();
        final future = accountProvider.getAllUsersList();
        expect(accountProvider.loading, true);
        await future;
        expect(accountProvider.allUsersList, data);
        expect(accountProvider.loading, false);
      });

      test('failure data', () async {
        failureData();
        final future = accountProvider.getAllUsersList();
        expect(accountProvider.loading, true);
        await future;
        expect(accountProvider.errorText, 'Error');
        expect(accountProvider.loading, false);
      });
    });

    group('addAccountsData() method test', () {
      final insertedData = [listofData1.first];

      void insertData() =>
          when(() => mockFirebaseRepo.insert(listofData1.first)).thenAnswer(
              (_) async => accountProvider.setAccountDataList(insertedData));

      void successData() => when(() => mockFirebaseRepo.getData())
          .thenAnswer((_) async => Success(response: insertedData, code: 200));

      test('insert data test', () async {
        insertData();
        successData();
        await accountProvider.addAccountsData(listofData1.first);
        await accountProvider.getAccountsData();
        expect(accountProvider.getData, insertedData);
      });
    });

    group('deleteAccountsData() method test', () {
      String deleteDataId = '3';

      void deleteData() =>
          when((() => mockFirebaseRepo.deleteData(deleteDataId))).thenAnswer(
              (_) async => listofData1
                  .removeWhere((element) => element.id == deleteDataId));

      void getData() => when(() => mockFirebaseRepo.getData())
          .thenAnswer((_) async => Success(response: listofData1, code: 200));

      test('delete data test', () async {
        accountProvider.setAccountDataList(listofData1);
        final dataCount = accountProvider.getData.length;
        deleteData();
        getData();
        await accountProvider.deleteAccountsData(deleteDataId);
        expect(accountProvider.getData.length, equals((dataCount - 1)));
      });
    });

    group('deleteSearchedData() method test', () {
      String deleteDataId = '2';
      DateTime startDate = DateTime(2023, 07, 09);
      DateTime endDate = DateTime(2023, 08, 02);

      void deleteData() =>
          when((() => mockFirebaseRepo.deleteData(deleteDataId))).thenAnswer(
              (_) async => listofData1
                  .removeWhere((element) => element.id == deleteDataId));
      void searchData() => when(() => mockFirebaseRepo.searchData(
          start: startDate,
          end: endDate,
          type: 'income')).thenAnswer((_) async => listofData1);

      void getData() => when(() => mockFirebaseRepo.getData())
          .thenAnswer((_) async => Success(response: listofData1, code: 200));

      test('delete one of the  searched data test', () async {
        accountProvider.setAccountDataList(listofData1);
        accountProvider.setFromDate(startDate);
        accountProvider.setToDate(endDate);
        accountProvider.setDropDownValue('income');
        deleteData();
        searchData();
        getData();
        await accountProvider.deleteSearchedData(deleteDataId);
      });
    });

    group('searchAccountsData() method test', () {
      DateTime startDate = DateTime(2023, 07, 09);
      DateTime endDate = DateTime(2023, 08, 02);

      void searchData() => when((() => mockFirebaseRepo.searchData(
          start: accountProvider.fromDate!,
          end: accountProvider.toDate!,
          type: 'income'))).thenAnswer((_) async => listofData1);
      test('search data test ', () async {
        accountProvider.setAccountDataList(listofData1);
        accountProvider.setFromDate(startDate);
        accountProvider.setToDate(endDate);
        searchData();
        await accountProvider.searchAccountsData('income');
        expect(accountProvider.getData.length,
            accountProvider.searchedData.length);
        verify(
          () => mockFirebaseRepo.searchData(
              start: startDate, end: endDate, type: 'income'),
        ).called(1);
      });
    });

    group('getEachEmployeeData() method test ', () {
      DateTime startDate = DateTime(2023, 07, 09);
      DateTime endDate = DateTime(2023, 08, 02);
      Map<String, List<Data>> empData = {};

      Map<String, List<Data>> listOfEmpData() {
        for (var employee in listOfData3) {
          if (empData.containsKey(employee.name)) {
            empData[employee.name]!.add(employee);
          } else {
            empData[employee.name] = [employee];
          }
        }
        return empData;
      }

      void getData() => when(() => mockFirebaseRepo.getEachEmployeeData(
          fromDate: startDate,
          toDate: endDate)).thenAnswer((_) async => listOfEmpData());

      test('get each employee statistics data test using filter option',
          () async {
        getData();
        await accountProvider.getEachEmployeeData(
            fromDate: startDate, toDate: endDate);
        expect(accountProvider.employersData, empData);
      });
    });

    group('getAllAccountsData() method test', () {
      final searchedData = [listofData1[1], listofData1[2]];
      DateTime startDate = DateTime(2023, 07, 09);
      DateTime endDate = DateTime(2023, 07, 29);
      void getData1() => when(() => mockFirebaseRepo.getDashBoardData(
          fromDate: startDate,
          toDate: endDate)).thenAnswer((_) async => searchedData);
      void getData2() => when(() => mockFirebaseRepo.getDashBoardData())
          .thenAnswer((_) async => listofData1);
      test('get data based on using filter option test', () async {
        getData1();
        await accountProvider.getAllAccountsData(
            start: startDate, end: endDate);
        expect(accountProvider.getAllData, searchedData);
      });

      test('get complete data without filter option test', () async {
        getData2();
        await accountProvider.getAllAccountsData();
        expect(accountProvider.getAllData, listofData1);
      });
    });
  });
}
