import 'package:al_ameen/data/repository/firebase_repository.dart';
import 'package:get_it/get_it.dart';

void setupLocator() {
  GetIt.instance.registerSingleton<FirebaseRepositoryImplementation>(FirebaseRepositoryImplementation());
}

 FirebaseRepositoryImplementation firebaseRepo =
      GetIt.instance<FirebaseRepositoryImplementation>();
