import 'dart:async';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class StorageService {

  final _instance = FirebaseStorage.instance;
  final _uuid = const Uuid();


  Future<UploadTask> uploadImage(XFile file, {String childPath = "", String contentType = ""}) async {
    final ref = _instance.ref(childPath)
        .child("${_uuid.v4()} - ${file.name}");

    final uploadTask = ref.putData(await file.readAsBytes(),SettableMetadata(contentType:contentType));
    return Future.value(uploadTask);
  }

  Reference getRef(String fileName) {
    return _instance.ref()
        .child(fileName);
  }
}
