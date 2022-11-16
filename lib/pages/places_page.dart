
import 'package:big_tour/data/place.dart';
import 'package:big_tour/helpers/firebase.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class PlacesPage extends StatelessWidget {
  const PlacesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Places in Wayanad")),
      body: Center(
        child: FirestoreListView<Place>(
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
              imageSrc: place.imageUrls.elementAt(0),
              title: place.name,
              description: place.description,
              align: Align.right,
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showDialog(
          barrierDismissible: false,
          context: context,
          builder: (_) => const PlaceForm(),
        ),
        tooltip: 'Add new place',
        child: const Icon(Icons.add_location_alt_outlined),
      ),
    );
  }
}

class PlaceItem extends StatelessWidget {
  const PlaceItem({
    Key? key,
    required this.imageSrc,
    required this.title,
    required this.description,
    this.align = Align.left,
  }) : super(key: key);

  final String title;
  final String description;
  final String imageSrc;
  final Align align;

  @override
  Widget build(BuildContext context) {
    Widget image = Expanded(
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(15)),
            child: Image.network(
              imageSrc,
              fit: BoxFit.cover,
            )),
      ),
    );
    Widget titleAndDescription = Expanded(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(title, style: Theme.of(context).textTheme.headline6),
        Text(description, style: Theme.of(context).textTheme.bodyText1),
      ],
    ));

    return Container(
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(15)),
        color: Colors.deepOrange[50],
      ),
      padding: const EdgeInsets.all(10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...(align == Align.right
              ? [image, const SizedBox(width: 10), titleAndDescription]
              : [titleAndDescription, const SizedBox(width: 10), image])
        ],
      ),
    );
  }
}

enum Align {
  right,
  left,
}

class PlaceForm extends StatefulWidget {
  const PlaceForm({super.key});

  @override
  State<PlaceForm> createState() => _PlaceFormState();
}

class _PlaceFormState extends State<PlaceForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  List<XFile> imageFiles = [];

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
            // Validate will return true if the form is valid, or false if
            // the form is invalid.
            if (_formKey.currentState!.validate()) {
              // Close the Alertdialog way before starting the upload process
              Navigator.pop(context);

              // Trigger image selection if not yet selected
              // then getn the image download urls as list in imageUrls variable
              List<String> imageUrls = await uploadImages(
                  imageFiles.isEmpty ? await selectImages() : imageFiles,
                  'places',
                  nameController.text);

              // Now time to save everything into firestore database
              saveToFireStore(Place(
                  name: nameController.text,
                  description: descriptionController.text,
                  imageUrls: imageUrls));
            }
          },
          child: const Text('Add new Place'),
        ),
      ],
      content: Form(
        key: _formKey,
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
            ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    imageFiles = await selectImages();
                  }
                },
                child: const Text("Select Images"))
          ],
        ),
      ),
    );
  }

  void saveToFireStore(Place place) {
    FirebaseFirestore.instance.collection("places").add(place.toMap());
  }
}
