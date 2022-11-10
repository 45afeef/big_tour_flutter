import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../data/place.dart';

class PlaceModel with ChangeNotifier {
  CollectionReference db = FirebaseFirestore.instance.collection("places");

  List<Place> allPlaces = [];

  fetchPlaces() async {
    // Wait untile the app fetch data from firestore
    QuerySnapshot qShot = await db.limit(30).get();

    allPlaces = qShot.docs.map((e) => Place.fromFirestore(e)).toList();
  }

  // All get methods starts here
  //////////////////////////////
  List<Place> get getAllPlaces => allPlaces;

  // All get methds ends here
  ///////////////////////////
  
  Future<DocumentReference<Object?>> save(Place place) {
    return db.add(place.toMap());
  }
}
