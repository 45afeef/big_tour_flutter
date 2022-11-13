class Place {
  final String id;
  final String name;
  final String description;
  final List<String> imageUrls;

  Place({
    this.id = '',
    required this.name,
    this.description = 'No description entered',
    this.imageUrls = const [],
  });

  // Used to convert data from firebase-firestore
  factory Place.fromFirestore(data) {
    return Place(
      id: data.id,
      name: data.get('name'),
      description: data.get('description'),
      imageUrls: [...data.get('imageUrls')],
    );
  }

  // Used to send data to firebase-firestore
  Map<String, dynamic> toFirestore() => toMap();
  Map<String, dynamic> toJson() => toMap();
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'imageUrls': imageUrls,
    };
  }
}
