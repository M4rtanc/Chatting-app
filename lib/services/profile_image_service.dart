import 'dart:io';
import 'dart:typed_data';

import 'package:chat_app/services/app_user_service.dart';
import 'package:chat_app/services/storage_service.dart';
import 'package:chat_app/shared/ioc_container.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class ProfileImageService {
  final _profileImagesRef = FirebaseStorage.instance.ref().child("profile_images");
  final _appUserService = get<AppUserService>();
  final _storageService = get<StorageService>();
  final String _defaultImagePath = "default_profile_image.png";

  Future<String> getCurrentProfImage() async {
    final String path = (await _appUserService.getCurrentUser()).imageUrl;
    if (path == "defaultImageUrl") {
      return _profileImagesRef.child(_defaultImagePath).getDownloadURL();
    }
    return path;
  }

  Future<String> getImageByUrl(String url) async {
    if (url == "defaultImageUrl") {
      return _profileImagesRef.child(_defaultImagePath).getDownloadURL();
    }
    return _profileImagesRef.child(url).getDownloadURL();
  }
  
  Future<String> updateCurrentUserImage(XFile imageFile) async {
    final uploadTask = await _storageService.uploadImage(imageFile, childPath: "profile_images/", contentType: "image/png");
    final downloadUrl = await (await uploadTask).ref.getDownloadURL();
    //var futureUrl = (await _storageService.uploadImage(imageFile, childPath: "profile_images/", contentType: "image/png")).snapshot.ref.getDownloadURL();
    // var taskSnapshot = await _profileImagesRef.putFile(imageFile);
    // return taskSnapshot.ref.getDownloadURL();
    print("returning doenloadUrl: $downloadUrl");
    return downloadUrl;
  }
}
