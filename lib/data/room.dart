class Room {
  final String id;
  String name;
  double price;
  String description;
  List<String> phoneNumbers;
  String locationName;
  List<String> facilities;
  List<String> images;
  double? rating;

  Room({
    this.id = '',
    required this.name,
    required this.price,
    required this.description,
    required this.phoneNumbers,
    required this.locationName,
    required this.facilities,
    required this.images,
    this.rating,
  });

  // Empty room
  factory Room.empty() {
    return Room(
        name: "",
        price: 0,
        description: "",
        phoneNumbers: [],
        locationName: "",
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
      locationName: data.get('locationName'),
      facilities: [...data.get('facilities')],
      images: [...data.get('images')],
      rating: data.get('rating'),
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
      'locationName': locationName,
      'facilities': facilities,
      'images': images,
      'rating': rating,
    };
  }
}
