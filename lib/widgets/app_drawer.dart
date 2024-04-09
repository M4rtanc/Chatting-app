import 'package:chat_app/pages/chat_group_page.dart';
import 'package:chat_app/pages/edit_profile_page.dart';
import 'package:chat_app/pages/login_page.dart';
import 'package:chat_app/pages/users_page.dart';
import 'package:chat_app/services/app_user_service.dart';
import 'package:chat_app/services/authentication_service.dart';
import 'package:chat_app/services/profile_image_service.dart';
import 'package:chat_app/shared/const.dart';
import 'package:chat_app/shared/ioc_container.dart';
import 'package:chat_app/widgets/profile_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final profileImageService = get<ProfileImageService>();
    final appUserService = get<AppUserService>();
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [

          Container(
            padding: const EdgeInsets.only(
              top: MEDIUM_PADDING,
            ),
            color: Colors.grey.withOpacity(OPACITY),
            child: FutureBuilder(
                future: appUserService.getCurrentUser(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Text("");
                  }
                  return Text(snapshot.data!.username,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 22,
                    ),
                  );
                },
            ),
          ),
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(OPACITY),
            ),
            child: FutureBuilder(
              future: profileImageService.getCurrentProfImage(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ProfileImage(imageUrl: snapshot.data!);
                }
                return const Text("No data");
              }
            ),
            //child: const Text('Pages'),
          ),
          ListTile(
            title: const Text('Users'),
            onTap: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const UsersPage())
              );
            },
          ),
          ListTile(
            title: const Text('Chats'),
            onTap: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const ChatGroupPage())
              );
            },
          ),
          ListTile(
            title: const Text('Edit profile'),
            onTap: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const EditProfilePage())
              );
            },
          ),
          ListTile(
            title: const Text('Log out'),
            trailing: const Icon(Icons.login_outlined),
            onTap: () {
              final auth = get<AuthenticationService>();
              auth.signOutCurrentUser();
              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (BuildContext context){
                return const LoginPage();
              }), (r){
                return false;
              });
            },
          )
        ],
      ),
    );
  }
}
