import 'package:al_ameen/data/models/api_status.dart';
import 'package:al_ameen/data/repository/firebase_repository.dart';
import 'package:al_ameen/ui/view_models/account_provider.dart';
import 'package:al_ameen/ui/views/transactions_page/transaction_page.dart';
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

  mockFirebaseRepo = MockFirebaseRepositoryImplementation();

  Widget createTransactionPage() => ChangeNotifierProvider<AccountProvider>(
        create: (_) {
          accountProvider = AccountProvider(mockFirebaseRepo, sharedPreferencesServices);
          accountProvider.getAccountsData();
          return accountProvider;
        },
        child: Sizer(builder: (context, orientation, deviceType) {
          return const MaterialApp(
            home: TransactionPage(),
          );
        }),
      );

  group('Transactions page widget test', () {
    testWidgets('''Testing if progress indicator displays,
                Testing if main container data widgets displays,
                Testing if ListView shows up ''', (tester) async {
      when(() => mockFirebaseRepo.getData())
          .thenAnswer((_) async => Success(response: listofData2, code: 200));
      await tester.pumpWidget(createTransactionPage());
      expect(find.byKey(const Key('balance')), findsOneWidget);
      expect(find.byKey(const Key('income')), findsOneWidget);
      expect(find.byKey(const Key('expense')), findsOneWidget);
      expect(find.byKey(const Key('transactions-progress loader')),
          findsOneWidget);
      await tester.pumpAndSettle();
      expect(find.byType(ListView), findsOneWidget);
    });

    testWidgets(
        'Testing dashboardContainer and listview widgets and its values',
        (tester) async {
      int income = 0;
      int expense = 0;
      int balance = 0;
      when(() => mockFirebaseRepo.getData())
          .thenAnswer((_) async => Success(response: listofData2, code: 200));
      await tester.pumpWidget(createTransactionPage());
      await tester.pumpAndSettle();

      for (final data in listofData2) {
        data.type == 'income'
            ? income += int.parse(data.amount)
            : expense += int.parse(data.amount);

        expect(find.text(data.amount), findsOneWidget);
      }
      balance = (income - expense);
      expect(find.text(income.toString()), findsOneWidget);
      expect(find.text(expense.toString()), findsOneWidget);
      expect(find.text(balance.toString()), findsOneWidget);
      expect(find.byType(ListView), findsOneWidget);
    });
  });
}
