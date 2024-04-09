import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'app_root.dart';
import 'shared/firebase_options.dart';
import 'shared/ioc_container.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  IoCContainer.setup();

  // checking firebase connection
  // User newUser = const User(
  //   email: 'nejakyEmail',
  //   id: 'faowifawofji',
  //   password: 'heslo',
  //   roleId: 1,
  //   username: 'Jan',
  // );
  //
  // bool result = await GetIt.I.get<RegistrationService>().registerUser(newUser);
  // if (result) {
  //   print("ano");
  // } else {
  //   print("ne");
  // }

  runApp(const AppRoot());
}
