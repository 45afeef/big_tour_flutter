import 'package:big_tour/data/place.dart';
import 'package:big_tour/general/global_variable.dart';
import 'package:big_tour/helpers/firebase.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:image_picker/image_picker.dart';

import '../widgets/cached_image.dart';

class PlacesPage extends StatelessWidget {
  const PlacesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Places in Wayanad")),
      backgroundColor: Colors.grey[300],
      body: Center(
        child: FirestoreListView<Place>(
          padding: const EdgeInsets.only(bottom: 150),
          query: FirebaseFirestore.instance
              .collection('places')
              .orderBy('name')
              .withConverter<Place>(
                fromFirestore: (snapshot, _) => Place.fromFirestore(snapshot),
                toFirestore: (place, _) => place.toFirestore(),
              ),
          loadingBuilder: (_) => const Text("Loading"),
          errorBuilder: (_, __, ___) =>
              const Text("Error on Loading, check internet or wait some time"),
          itemBuilder: (ctx, snapshot) {
            Place place = snapshot.data();
            return PlaceItem(
              place: place,
            );
          },
        ),
      ),
      floatingActionButton: isAdmin
          ? FloatingActionButton(
              onPressed: () => showDialog(
                barrierDismissible: false,
                context: context,
                builder: (_) => const PlaceForm(),
              ),
              tooltip: 'Add new place',
              child: const Icon(Icons.add_location_alt_outlined),
            )
          : const SizedBox(),
    );
  }
}

class PlaceItem extends StatefulWidget {
  const PlaceItem({Key? key, required this.place}) : super(key: key);
  final Place place;

  @override
  _PlaceItemState createState() => _PlaceItemState();
}

class _PlaceItemState extends State<PlaceItem> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => setState(() {
        isExpanded = !isExpanded;
      }),
      child: Container(
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.white,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.network(
                    widget.place.imageUrls.isNotEmpty
                        ? widget.place.imageUrls.first
                        : 'https://via.placeholder.com/150',
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    widget.place.name,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                IconButton(
                  onPressed: widget.place.share,
                  icon: const Icon(
                    Icons.share,
                    color: Colors.pink,
                  ),
                ),
              ],
            ),
            if (isExpanded)
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (widget.place.imageUrls.isNotEmpty)
                      AspectRatio(
                        aspectRatio: 16 / 9,
                        child: ImageSlideshow(
                          autoPlayInterval: 6000,
                          isLoop: true,
                          children: widget.place.imageUrls
                              .map((url) => CachedImage(
                                    imageUrl: url,
                                    fit: BoxFit.cover,
                                  ))
                              .toList(),
                        ),
                      ),
                    const SizedBox(height: 10),
                    Text(
                      widget.place.description,
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.justify,
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class PlaceForm extends StatefulWidget {
  const PlaceForm({this.place, super.key});

  final Place? place;

  @override
  State<PlaceForm> createState() => _PlaceFormState();
}

class _PlaceFormState extends State<PlaceForm> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  late TextEditingController nameController;
  late TextEditingController descriptionController;

  List<XFile> imageFiles = [];

  @override
  void initState() {
    super.initState();

    // initialize text editing controllers
    nameController = TextEditingController(text: widget.place?.name);
    descriptionController =
        TextEditingController(text: widget.place?.description);
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    nameController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Add new place"),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel")),
        ElevatedButton(
          onPressed: () async {
            // Validate the form. This will make use of individual validation declared in every input field
            if (formKey.currentState!.validate()) {
              // Close the Alertdialog way before starting the upload process
              Navigator.pop(context);

              // Time to save to firebase

              // save a new place
              FirebaseFirestore.instance
                  .collection("places")
                  .doc(widget.place?.id)
                  .set(Place(
                    name: nameController.text,
                    description: descriptionController.text,
                    imageUrls: [...?widget.place?.imageUrls],
                  ).toFirestore());
            }
          },
          child: Text(widget.place == null ? 'Add new Place' : 'Save Edit'),
        ),
      ],
      content: Form(
        key: formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Place Name
            TextFormField(
              controller: nameController,
              decoration: const InputDecoration(hintText: 'New Place Name'),
              validator: (String? value) {
                return (value == null || value.isEmpty)
                    ? 'Please enter place name'
                    : null;
              },
            ),
            // Place Description
            TextFormField(
              controller: descriptionController,
              decoration: const InputDecoration(hintText: 'Place description'),
              validator: (String? value) {
                return (value == null || value.isEmpty)
                    ? 'Please enter place description'
                    : null;
              },
            ),
            // show "Select Images" button only if there is no already selected images are available
            // whcih means the "Select Images" button will show only while creating room and not while editing
            widget.place == null
                ? ElevatedButton(
                    onPressed: () async {
                      if (formKey.currentState!.validate()) {
                        imageFiles = await selectImages();
                      }
                    },
                    child: const Text("Select Images"))
                : const SizedBox()
          ],
        ),
      ),
    );
  }

  void saveToFireStore(Place place) {
    FirebaseFirestore.instance.collection("places").add(place.toMap());
  }
}
