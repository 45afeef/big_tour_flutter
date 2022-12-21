import 'package:big_tour/data/place.dart';
import 'package:big_tour/general/global_variable.dart';
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
              place: place,
              align: Align.right,
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

class PlaceItem extends StatelessWidget {
  const PlaceItem({
    Key? key,
    required this.place,
    this.align = Align.left,
  }) : super(key: key);

  final Place place;
  final Align align;

  @override
  Widget build(BuildContext context) {
    Widget image = Expanded(
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(15)),
            child: Image.network(
              place.imageUrls.elementAt(0),
              fit: BoxFit.cover,
            )),
      ),
    );
    Widget titleAndDescription = Expanded(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(place.name, style: Theme.of(context).textTheme.headline6),
        Text(place.description, style: Theme.of(context).textTheme.bodyText1),
      ],
    ));

    return InkWell(
      onLongPress: () =>
          showDialog(context: context, builder: (_) => PlaceForm(place: place)),
      child: Container(
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
      ),
    );
  }
}

enum Align {
  right,
  left,
}

class PlaceForm extends StatefulWidget {
  const PlaceForm({this.place, super.key});

  final Place? place;

  @override
  State<PlaceForm> createState() => _PlaceFormState();
}

class _PlaceFormState extends State<PlaceForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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
            if (_formKey.currentState!.validate()) {
              // Close the Alertdialog way before starting the upload process
              Navigator.pop(context);

              // Time to save to firebase

              // save a new place
              if (widget.place == null) {
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
              // save an edit to the existiong place
              else {
                FirebaseFirestore.instance
                    .collection("places")
                    .doc(widget.place?.id)
                    .set(Place(
                      name: nameController.text,
                      description: descriptionController.text,
                      imageUrls: [...?widget.place?.imageUrls],
                    ).toFirestore());
              }
            }
          },
          child: Text(widget.place == null ? 'Add new Place' : 'Save Edit'),
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
            // show "Select Images" button only if there is no already selected images are available
            // whcih means the "Select Images" button will show only while creating room and not while editing
            widget.place == null
                ? ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
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
