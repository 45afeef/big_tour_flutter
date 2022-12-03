class Room {
  final String id;
  String name;
  double price;
  String description;
  List<String> phoneNumbers;
  CustomBigooitLocation location;
  List<String> facilities;
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
    required this.facilities,
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
        facilities: [],
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
      facilities: [...data.get('facilities')],
      images: [...data.get('images')],
      rating: data.get('rating'),
      isAvailable: data.get('isAvailable'),
    );
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
      'facilities': facilities,
      'images': images,
      'rating': rating,
      'isAvailable': isAvailable,
    };
  }
}

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
