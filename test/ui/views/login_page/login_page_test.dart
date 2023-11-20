import 'package:al_ameen/data/models/api_status.dart';
import 'package:al_ameen/data/models/login.dart';
import 'package:al_ameen/data/repository/firebase_repository.dart';
import 'package:al_ameen/ui/view_models/login_provider.dart';
import 'package:al_ameen/ui/views/login_page/login_page.dart';
import 'package:al_ameen/utils/shared_preference.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class MockFirebaseRepositoryImplementation extends Mock
    implements FirebaseRepositoryImplementation {}

class MockSharedPreferenceServices extends Mock
    implements SharedPreferencesServices {}

class MockBuildContext extends Mock implements BuildContext {}

void main() {
  late MockFirebaseRepositoryImplementation mockFirebaseRepo;
  late MockSharedPreferenceServices mockSharedPref;
  late LoginProvider loginProvider;
  late MockBuildContext mockBuildContext;
  setUp(() {
    mockFirebaseRepo = MockFirebaseRepositoryImplementation();
    mockSharedPref = MockSharedPreferenceServices();
    mockBuildContext = MockBuildContext();
    loginProvider = LoginProvider(mockFirebaseRepo);
  });

  Widget createLoginPagePage() => ChangeNotifierProvider<LoginProvider>(
        create: (_) => loginProvider,
        child: Sizer(builder: (context, orientation, deviceType) {
          return MaterialApp(home: LoginPage(mockSharedPref));
        }),
      );
  group('Login Page test:', () {
    final usernameField = find.byKey(const Key('username-field'));
    final passwordField = find.byKey(const Key('password-field'));
    final loginButton = find.byKey(const Key('login-button'));

    final loginModel = Login('muees', 'admin123');
    void success() =>
        when(() => mockFirebaseRepo.signInUser(loginModel, mockBuildContext))
            .thenAnswer((_) async => Success(response: loginModel, code: 200));

    void failure() =>
        when(() => mockFirebaseRepo.signInUser(loginModel, mockBuildContext))
            .thenAnswer((_) async => Failure(response: 'error', code: 404));

    testWidgets('test enter username and password and get signedIn ',
        (tester) async {
      when(() => mockSharedPref.setLoggedIn(
              loginModel.username, loginModel.password))
          .thenAnswer((_) async => {});

      await tester.pumpWidget(createLoginPagePage());
      await tester.pump();
      await tester.enterText(usernameField, 'muees');
      await tester.pumpAndSettle();
      await tester.enterText(passwordField, 'admin123');
      await tester.pumpAndSettle();
      success();
      failure();
      await tester.tap(loginButton);
      await tester.pumpAndSettle();
    });

    testWidgets(
        'test validation messages are displayed if tap login button with empty data',
        (tester) async {
      await tester.pumpWidget(createLoginPagePage());
      await tester.pump();
      await tester.tap(loginButton);
      await tester.pumpAndSettle();
      expect(find.text('username should not be empty'), findsOneWidget);
      expect(find.text('password should not be empty'), findsOneWidget);
    });
  });
}
