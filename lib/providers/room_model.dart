import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../data/room.dart';

class RoomModel with ChangeNotifier {
  CollectionReference db = FirebaseFirestore.instance.collection("rooms");

  List<Room> allRooms = [];

  fetchRooms() async {
    // Wait untile the app fetch data from firestore
    QuerySnapshot qShot = await db.limit(30).get();

    allRooms = qShot.docs.map((e) => Room.fromFirestore(e)).toList();
  }

  // All get methods starts here
  //////////////////////////////
  List<Room> get getAllRooms => allRooms;

  // All get methods ends here
  ///////////////////////////

  Future<DocumentReference<Object?>> save(Room room) {
    return db.add(room.toMap());
  }
}
