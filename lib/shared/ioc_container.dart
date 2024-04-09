import 'package:chat_app/notifiers/chat_groups.dart';
import 'package:chat_app/services/app_user_service.dart';
import 'package:chat_app/services/authentication_service.dart';
import 'package:chat_app/services/chat_group_service.dart';
import 'package:chat_app/services/edit_profile_service.dart';
import 'package:chat_app/services/friends_service.dart';
import 'package:chat_app/services/message_service.dart';
import 'package:chat_app/services/profile_image_service.dart';
import 'package:get_it/get_it.dart';

import '../services/storage_service.dart';
import '../services/user_chat_group_service.dart';

final get = GetIt.instance;

class IoCContainer {
  IoCContainer._();

  static void setup() {
    get.registerSingleton(StorageService());
    get.registerSingleton(UserChatGroupService());
    get.registerSingleton(AuthenticationService());
    get.registerSingleton(AppUserService());
    get.registerSingleton(MessageService());
    get.registerSingleton(ChatGroupService());
    get.registerSingleton(FriendsService());
    get.registerSingleton(EditProfileService());
    get.registerSingleton(ProfileImageService());
  }
}
