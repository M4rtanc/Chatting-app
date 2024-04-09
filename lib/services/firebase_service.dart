import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

// CRUD create, read, update, delete
// create, getById, getAll, update, deleteById
abstract class FirebaseService<T> {

  final CollectionReference<T> _collection;

  FirebaseService(this._collection);

  CollectionReference<T> get collection {
    return _collection;
  }

  Stream<List<T>> get stream {
    return collection
        .snapshots()
        .map((querySnapshot) =>
        querySnapshot.docs.map((it) => it.data()).toList());
  }

  Future<DocumentSnapshot<T>> getById(String id) async {
    final chatGroupDocRef = collection.doc(id);
    return await chatGroupDocRef.get();
  }

  Future<void> deleteById(String id) async {
    await _collection.doc(id).delete();
  }

  Future<void> deleteByChatGroupId(String chatGroupId) async {
    final querySnapshot = await _collection
        .where("chatGroupId", isEqualTo: chatGroupId)
        .get();

    for (final doc in querySnapshot.docs) {
      await doc.reference.delete();
    }
  }

  Future<DocumentSnapshot<T>> create(T data) async {
    final newData = await collection.add(data);
    return newData.get();
  }

  Future<T?> getFirstOrNullByEmail(String email) async {
    return getFirstOrNullByField("email", email);
  }

  Future<List<T>> getByUserId(String userId) async {
    return getByField("userId", userId);
  }

  Future<List<T>> getByChatGroupId(String chatGroupId) async {
    return getByField("chatGroupId", chatGroupId);
  }

  Future<List<T>> getByField(String fieldName, dynamic value) async {
    final chatGroupsQuery = await collection
        .where(fieldName, isEqualTo: value)
        .get();

    return chatGroupsQuery.docs.map((doc) => doc.data()).toList();
  }

  Future<T?> getFirstOrNullByField(String fieldName, dynamic value) async {
    final querySnapshot = await collection
        .where(fieldName, isEqualTo: value)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      return querySnapshot.docs.first.data();
    }

    return null;
  }
}
