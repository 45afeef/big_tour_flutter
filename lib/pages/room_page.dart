import 'package:big_tour/data/room.dart';
import 'package:big_tour/helpers/comon.dart';
import 'package:big_tour/widgets/facilities.dart';
import 'package:big_tour/pages/room_details_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../helpers/firebase.dart';

class RoomPage extends StatelessWidget {
  const RoomPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Rooms in wayanad")),
      floatingActionButton:
          FirebaseAuth.instance.currentUser?.phoneNumber == "+917558009733"
              ? FloatingActionButton(
                  tooltip: 'Add new room',
                  child: const Icon(Icons.add_business_rounded),
                  onPressed: () => showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (_) => const RoomForm(),
                  ),
                )
              : const SizedBox(),
      body: Center(
        child: FirestoreListView<Room>(
          query: FirebaseFirestore.instance
              .collection('rooms')
              .where("isAvailable", isEqualTo: true)
              .withConverter<Room>(
                fromFirestore: (snapshot, _) => Room.fromFirestore(snapshot),
                toFirestore: (room, _) => room.toFirestore(),
              ),
          errorBuilder: (_, __, ___) =>
              const Text("Error on Loading, check internet or wait some time"),
          itemBuilder: (ctx, snapshot) {
            Room room = snapshot.data();
            return RoomItem(room);
          },
        ),
      ),
    );
  }
}

class RoomItem extends StatelessWidget {
  const RoomItem(
    this.room, {
    Key? key,
  }) : super(key: key);

  final Room room;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: (() => {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => RoomDetailsPage(room)))
            }),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 15),
          child: Row(
            children: [
              SizedBox.square(
                dimension: 130,
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  child: Image.network(
                      room.images.isEmpty ? "" : room.images.elementAt(0),
                      fit: BoxFit.cover),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                room.locationName,
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                              Text(room.name,
                                  style: Theme.of(context).textTheme.headline6),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.favorite_outline,
                            color: Colors.pink,
                          ),
                          onPressed: () => {
                            // TODO: add the favorite functionality
                            showToast(context,
                                "This function is not added yet. We will add it soon")
                          },
                        )
                      ],
                    ),
                    const Facilities(size: 30),
                    const Divider(),
                    Text(
                      room.description,
                      // "4-6 guests . Entire Home . 5 beds  . Wifi . Kitchen . 3 bathroom . Free Parking",
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const Divider(),
                    Row(
                      children: [
                        const Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                        Text(
                          room.rating.toString(),
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        const Spacer(),
                        Text(
                          "\$${room.price}",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "/day",
                          style: Theme.of(context).textTheme.bodySmall,
                        )
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
        onLongPress: () => showDialog(
            context: context,
            builder: (_) => AlertDialog(
                  content:
                      const Text("You can either edit or delete the room here"),
                  actions: [
                    TextButton(
                        onPressed: () => {
                              Navigator.pop(context),
                              FirebaseFirestore.instance
                                  .collection('rooms')
                                  .doc(room.id)
                                  .delete()
                            },
                        child: const Text("Delete")),
                    TextButton(
                        onPressed: () => {
                              Navigator.pop(context),
                              showDialog(
                                context: context,
                                builder: (_) => RoomForm(room: room),
                              )
                            },
                        child: const Text("Edit")),
                    ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text("Cancel and Go Back"))
                  ],
                )),
      ),
    );
  }
}

class RoomForm extends StatefulWidget {
  const RoomForm({this.room, super.key});

  final Room? room;

  @override
  State<RoomForm> createState() => _RoomFormState();
}

class _RoomFormState extends State<RoomForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late TextEditingController nameController;
  late TextEditingController priceController;
  late TextEditingController descriptionController;
  late TextEditingController phoneNumbersController;
  late TextEditingController locationNameController;
  late TextEditingController facilitiesController;
  late TextEditingController ratingController;

  List<XFile> imageFiles = [];

  @override
  void initState() {
    super.initState();

    // initialize text editing controllers
    nameController = TextEditingController(text: widget.room?.name);
    priceController =
        TextEditingController(text: widget.room?.price.toString());
    descriptionController =
        TextEditingController(text: widget.room?.description);
    phoneNumbersController =
        TextEditingController(text: widget.room?.phoneNumbers.first);
    locationNameController =
        TextEditingController(text: widget.room?.locationName);
    facilitiesController =
        TextEditingController(text: widget.room?.facilities.first);
    ratingController =
        TextEditingController(text: widget.room?.rating.toString());
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    nameController.dispose();
    priceController.dispose();
    descriptionController.dispose();
    phoneNumbersController.dispose();
    locationNameController.dispose();
    facilitiesController.dispose();
    ratingController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Add new room"),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel")),
        ElevatedButton(
          onPressed: () async {
            // Validate will return true if the form is valid, or false if
            // the form is invalid.

            if (_formKey.currentState!.validate()) {
              // Now time to save everything into firestore database

               // save a new room
              if (widget.room == null) {
                // Trigger image selection if not yet selected
                if (imageFiles.isEmpty) imageFiles = await selectImages();

                // Stop working this block if no image is selected
                if (imageFiles.isEmpty) return;
                // Close the Alertdialog way before starting the upload process
                Navigator.pop(context);

                // then getn the image download urls as list in imageUrls variable
                List<String> imageUrls = await uploadImages(
                    imageFiles, 'rooms', nameController.text);

                saveToFireStore(
                  Room(
                    name: nameController.text,
                    price: double.parse(priceController.text),
                    description: descriptionController.text,
                    phoneNumbers: [phoneNumbersController.text],
                    locationName: locationNameController.text,
                    // TODO: make check box like multiple selection for facilities
                    facilities: [facilitiesController.text],
                    images: imageUrls,
                    rating: double.parse(ratingController.text),
                  ),
                );
              }
              // save an edit to existing room
              else {
                Navigator.pop(context);

                FirebaseFirestore.instance
                    .collection("rooms")
                    .doc(widget.room?.id)
                    .set(Room(
                      name: nameController.text,
                      price: double.parse(priceController.text),
                      description: descriptionController.text,
                      phoneNumbers: [phoneNumbersController.text],
                      locationName: locationNameController.text,
                      facilities: [facilitiesController.text],
                      images: [...?widget.room?.images],
                      rating: double.parse(ratingController.text),
                    ).toFirestore());
              }
            }
          },
          child: Text(widget.room == null ? 'Add new Room' : 'Save Edit'),
        ),
      ],
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Room Name
              TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(hintText: 'New Room Name'),
                  validator: (String? value) {
                    return (value == null || value.isEmpty)
                        ? 'Please enter room name'
                        : null;
                  }),
              // Room Description
              TextFormField(
                controller: descriptionController,
                decoration: const InputDecoration(hintText: 'Room description'),
                validator: (String? value) {
                  return (value == null || value.isEmpty)
                      ? 'Please enter room description'
                      : null;
                },
              ),
              // Room price
              TextFormField(
                  keyboardType: TextInputType.number,
                  controller: priceController,
                  decoration: const InputDecoration(hintText: 'Price eg. 320'),
                  validator: (String? value) {
                    return (value == null || value.isEmpty)
                        ? 'Please enter valid price'
                        : null;
                  }),
              // Room phone number
              TextFormField(
                  keyboardType: TextInputType.phone,
                  controller: phoneNumbersController,
                  decoration: const InputDecoration(hintText: 'Phone Number'),
                  validator: (String? value) {
                    return (value == null || value.isEmpty)
                        ? 'Please enter Phone Number'
                        : null;
                  }),
              // Room location
              TextFormField(
                  keyboardType: TextInputType.name,
                  controller: locationNameController,
                  decoration:
                      const InputDecoration(hintText: 'Where is the location'),
                  validator: (String? value) {
                    return (value == null || value.isEmpty)
                        ? 'Please enter your location'
                        : null;
                  }),
              // Room facilities
              TextFormField(
                  controller: facilitiesController,
                  decoration:
                      const InputDecoration(hintText: 'Facilities available')),
              // Room rating
              TextFormField(
                  keyboardType: TextInputType.number,
                  controller: ratingController,
                  decoration: const InputDecoration(hintText: 'Stars'),
                  validator: (String? value) {
                    return (value == null || value.isEmpty)
                        ? 'Please enter valid rating'
                        : null;
                  }),

              widget.room == null
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
      ),
    );
  }

  void saveToFireStore(Room room) {
    FirebaseFirestore.instance.collection("rooms").add(room.toMap());
  }
}
