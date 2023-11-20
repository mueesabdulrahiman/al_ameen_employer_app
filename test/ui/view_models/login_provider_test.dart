import 'package:al_ameen/data/models/login.dart';
import 'package:al_ameen/ui/view_models/login_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'account_provider_test.dart';

class MockBuildContext extends Mock implements BuildContext {}

void main() {
  late MockFirebaseRepositoryImplementation mockFirebaseRepo;
  late LoginProvider loginProvider;
  late MockBuildContext mockBuildContext;
  late Login loginModel;

  setUp(() async {
    mockFirebaseRepo = MockFirebaseRepositoryImplementation();
    loginProvider = LoginProvider(mockFirebaseRepo);
    mockBuildContext = MockBuildContext();
    loginModel = Login('muees', 'admin123');
  });
  test('login test', () async {
    String name = 'muees';
    when(() => mockFirebaseRepo.signInUser(loginModel, mockBuildContext))
        .thenAnswer((_) async {});
    loginProvider.setCurrentUser(name);

    await loginProvider.userLogin(mockBuildContext, loginModel);
    verify(() => mockFirebaseRepo.signInUser(loginModel, mockBuildContext))
        .called(1);
    expect(loginProvider.currentUser, name);
  });
}
