import 'package:big_tour/data/place.dart';
import 'package:big_tour/helpers/firebase.dart';
import 'package:big_tour/providers/place_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

List placeList = [
  {
    "title": "Pookode Lake",
    "description":
        "Place importance with beautiful landscapes and good description",
    "imageSrc":
        "https://images.unsplash.com/photo-1666860570907-bc54931a33f9?q=40&w=576"
  },
  {
    "title": "Phantom Rock",
    "description":
        "Place importance with beautiful landscapes and good description",
    "imageSrc":
        "https://images.unsplash.com/photo-1666973225662-fe02ab2a1dc8?q=40&w=576"
  },
  {
    "title": "Edacal Caves",
    "description":
        "Place importance with beautiful landscapes and good description",
    "imageSrc":
        "https://images.unsplash.com/photo-1664575197229-3bbebc281874?q=40&w=576"
  },
  {
    "title": "Kuruva Dweep",
    "description":
        "Place importance with beautiful landscapes and good description",
    "imageSrc":
        "https://images.unsplash.com/photo-1666860570907-bc54931a33f9?q=40&w=576"
  },
  {
    "title": "Banasura",
    "description":
        "Place importance with beautiful landscapes and good description",
    "imageSrc":
        "https://images.unsplash.com/photo-1666973225662-fe02ab2a1dc8?q=40&w=576"
  },
  {
    "title": "Chembra peek",
    "description":
        "Place importance with beautiful landscapes and good description",
    "imageSrc":
        "https://images.unsplash.com/photo-1664575197229-3bbebc281874?q=40&w=576"
  },
  {
    "title": "Iduki1",
    "description":
        "Place importance with beautiful landscapes and good description",
    "imageSrc":
        "https://images.unsplash.com/photo-1666860570907-bc54931a33f9?q=40&w=576"
  },
  {
    "title": "Iduki2",
    "description":
        "Place importance with beautiful landscapes and good description",
    "imageSrc":
        "https://images.unsplash.com/photo-1666973225662-fe02ab2a1dc8?q=40&w=576"
  },
  {
    "title": "Iduki3",
    "description":
        "Place importance with beautiful landscapes and good description",
    "imageSrc":
        "https://images.unsplash.com/photo-1664575197229-3bbebc281874?q=40&w=576"
  },
  {
    "title": "Iduki1",
    "description":
        "Place importance with beautiful landscapes and good description",
    "imageSrc":
        "https://images.unsplash.com/photo-1666860570907-bc54931a33f9?q=40&w=576"
  },
  {
    "title": "Iduki2",
    "description":
        "Place importance with beautiful landscapes and good description",
    "imageSrc":
        "https://images.unsplash.com/photo-1666973225662-fe02ab2a1dc8?q=40&w=576"
  },
  {
    "title": "Iduki3",
    "description":
        "Place importance with beautiful landscapes and good description",
    "imageSrc":
        "https://images.unsplash.com/photo-1664575197229-3bbebc281874?q=40&w=576"
  },
];

class PlacesPage extends StatelessWidget {
  const PlacesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Places in Wayanad")),
      body: Center(
          child: ListView.separated(
        itemCount: placeList.length,
        itemBuilder: (ctx, i) => PlaceItem(
          imageSrc: placeList[i]["imageSrc"],
          title: placeList[i]["title"],
          description: placeList[i]["description"],
          align: i % 2 == 0 ? Align.left : Align.right,
        ),
        separatorBuilder: (_, __) => const Divider(color: Colors.black26),
        padding: const EdgeInsets.all(10.0),
      )),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showDialog(
          barrierDismissible: false,
          context: context,
          builder: (_) => PlaceForm(),
        ),
        tooltip: 'Add new place',
        child: const Icon(Icons.add),
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
      child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(15)),
          child: Image.network(imageSrc)),
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

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    nameController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    saveToFirebase() {
      Provider.of<PlaceModel>(context, listen: false)
          .save(Place(
              name: nameController.text,
              description: descriptionController.text,
              imageUrls: ["No image url"]))
          .then(
            (docRef) => Navigator.pop(context),
          );
    }

    return AlertDialog(
      title: const Text("Add new place"),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel")),
        ElevatedButton(
          onPressed: () {
            // Validate will return true if the form is valid, or false if
            // the form is invalid.
            if (_formKey.currentState!.validate()) {
              // Process data.
              saveToFirebase();
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
                onPressed: () => uploadImageToCloudStorageFromGallery(
                    path: "places/more/is/comming", name: nameController.text),
                child: const Text("Upload images"))
          ],
        ),
      ),
    );
  }
}
