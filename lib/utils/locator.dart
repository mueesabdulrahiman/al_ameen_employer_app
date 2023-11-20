import 'package:al_ameen/data/repository/firebase_repository.dart';
import 'package:al_ameen/utils/shared_preference.dart';
import 'package:get_it/get_it.dart';

void setupLocator() {
  GetIt.instance.registerSingleton<FirebaseRepositoryImplementation>(
      FirebaseRepositoryImplementation());
  GetIt.instance.registerSingleton<SharedPreferencesServices>(
      SharedPreferencesServices());
}

FirebaseRepositoryImplementation firebaseRepo =
    GetIt.instance<FirebaseRepositoryImplementation>();
SharedPreferencesServices sharedPreferencesServices = GetIt.instance<SharedPreferencesServices>();
