import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:share_plus/share_plus.dart';

import '/helpers/location.dart';
import '/widgets/activity_list.dart';
import '../helpers/url_lancher.dart';

class CustomBigooitLocation {
  String name;
  double latitude;
  double longitude;

  CustomBigooitLocation(this.name, this.latitude, this.longitude);

  factory CustomBigooitLocation.empty() => CustomBigooitLocation("", 0, 0);

  factory CustomBigooitLocation.fromMap(Map<String, dynamic> datamap) {
    return CustomBigooitLocation(
      datamap["name"],
      datamap["latitude"],
      datamap["longitude"],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}

class Room {
  final String id;
  String name;
  int price;
  String description;
  List<String> phoneNumbers;
  CustomBigooitLocation location;
  Set<ActivityType> activities;
  List<String> images;
  double? rating;
  bool isAvailable;

  Room({
    this.id = '',
    required this.name,
    required this.price,
    required this.description,
    required this.phoneNumbers,
    required this.location,
    required this.activities,
    required this.images,
    this.isAvailable = true,
    this.rating,
  });

  // Empty room
  factory Room.empty() {
    return Room(
        name: "",
        price: 0,
        description: "",
        phoneNumbers: [],
        location: CustomBigooitLocation.empty(),
        activities: {},
        images: []);
  }

  // Used to convert data from firebase-firestore
  factory Room.fromFirestore(data) {
    return Room(
      id: data.id,
      name: data.get('name'),
      price: data.get('price'),
      description: data.get('description'),
      phoneNumbers: [...data.get('phoneNumbers')],
      location: CustomBigooitLocation.fromMap(data.get('location')),
      // Convert back the array of activities into set of activities
      activities: {
        ...data
            .get('activities')
            .map((value) => ActivityType.getTypeByValue(value))
      },
      images: [...data.get('images')],
      rating: data.get('rating'),
      isAvailable: data.get('isAvailable'),
    );
  }

  launchLocationOnMap() =>
      launchInBrowser(getLocationUrl(location.latitude, location.longitude));
  share() async {
    List<XFile> xFiles = [];

    for (var url in images) {
      var file = await DefaultCacheManager().getSingleFile(url);
      xFiles.add(XFile(file.path));
    }
    String activites = "";
    for (var act in activities) {
      activites += '${act.value}, ';
    }

    Share.shareXFiles(xFiles, subject: name);
    Share.share('*$name* \n\n$description \n\n*Facilities* \n\n$activites \n');
  }

  // Used to send data to firebase-firestore
  Map<String, dynamic> toFirestore() => toMap();

  Map<String, dynamic> toJson() => toMap();

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'price': price,
      'description': description,
      'phoneNumbers': phoneNumbers,
      'location': location.toMap(),
      // Convert the set of activities into array of activitys
      'activities': [...activities.map((e) => e.value)],
      'images': images,
      'rating': rating,
      'isAvailable': isAvailable,
    };
  }
}
