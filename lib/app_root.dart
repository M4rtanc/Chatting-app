import 'package:chat_app/notifiers/chat_groups.dart';
import 'package:chat_app/pages/chat_group_page.dart';
import 'package:chat_app/pages/chat_page.dart';
import 'package:chat_app/pages/users_page.dart';
import 'package:chat_app/pages/login_page.dart';
import 'package:chat_app/services/app_user_service.dart';
import 'package:chat_app/services/authentication_service.dart';
import 'package:chat_app/shared/ioc_container.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppRoot extends StatelessWidget {
  const AppRoot({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final authenticationService = get<AuthenticationService>();
    final currentUser = authenticationService.getCurrentUser();

    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => ChatGroupsNotifier()),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          //home: currentUser != null ? UsersPage() : LoginPage(),
          home: Scaffold(
            body: currentUser != null ? ChatGroupPage() : LoginPage(),
          ),
        ),
    );
  }
}
