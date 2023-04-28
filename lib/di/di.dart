import 'package:book_app/firebase/my_store.dart';
import 'package:get_it/get_it.dart';
import 'package:firebase_core/firebase_core.dart';

final di = GetIt.instance;

Future<void> setup() async {
  await Firebase.initializeApp();
  di.registerSingleton(MyStore());
}
