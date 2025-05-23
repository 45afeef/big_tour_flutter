import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '/data/room.dart';
import '/general/global_variable.dart';
import '/pages/room_details_page.dart';
import '/widgets/activity_list.dart';
import '../helpers/firebase.dart';
import '../widgets/cached_image.dart';

class RoomForm extends StatefulWidget {
  final Room? room;

  const RoomForm({this.room, super.key});

  @override
  State<RoomForm> createState() => _RoomFormState();
}

class RoomItem extends StatelessWidget {
  final Room room;

  const RoomItem(
    this.room, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: (() => {
              Navigator.of(context).push(
                PageRouteBuilder(
                    pageBuilder: (_, __, ___) => RoomDetailsPage(room),
                    transitionDuration: const Duration(seconds: 1)),
              )
            }),
        onLongPress: isAdmin
            ? () => showDialog(
                context: context,
                builder: (_) => AlertDialog(
                      content: const Text(
                          "You can either edit or delete the room here"),
                      actions: [
                        TextButton(
                            onPressed: () => {
                                  Navigator.pop(context),
                                  FirebaseFirestore.instance
                                      .collection('rooms')
                                      .doc(room.id)
                                      .delete()
                                  // TOOD - delete the uploaded images as well
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
                    ))
            : null,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 15),
          child: Row(
            children: [
              // Square Image box
              SizedBox.square(
                dimension: 130,
                child: Hero(
                  tag: 'image-${room.images.first}',
                  child: ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    child: CachedImage(
                      imageUrl: room.images.isEmpty ? "" : room.images.first,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              // Contents
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Heading, Location, Favourite button
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                room.location.name,
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                              Text(room.name,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineMedium),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.share,
                            color: Colors.pink,
                          ),
                          onPressed: room.share,
                        )
                      ],
                    ),
                    // Activities
                    Hero(
                      tag: 'activity-${room.id}',
                      child: Activities(
                        size: 30,
                        activities: room.activities,
                      ),
                    ),
                    const Divider(),
                    // Description
                    Hero(
                      tag: 'description-${room.id}',
                      child: Text(
                        room.description,
                        // "4-6 guests . Entire Home . 5 beds  . Wifi . Kitchen . 3 bathroom . Free Parking",
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                    const Divider(),
                    // Footer with rating and price information
                    Row(
                      children: [
                        // Star Icon
                        const Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                        // Ratings
                        Text(
                          room.rating.toString(),
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        const Spacer(),
                        // Price
                        Text(
                          "₹ ${room.price}",
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
      ),
    );
  }
}

enum RoomItemViewType {
  nameOnly,
  full,
}

class RoomNameOnlyWidget extends StatelessWidget {
  final Room room;

  const RoomNameOnlyWidget(this.room, {super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: (() => Navigator.of(context).push(
            PageRouteBuilder(
                pageBuilder: (_, __, ___) => RoomDetailsPage(room),
                transitionDuration: const Duration(seconds: 1)),
          )),
      title: Text(room.name),
      subtitle: Text(
        room.location.name,
        style: const TextStyle(color: Colors.black38, fontSize: 11),
      ),
      trailing: IconButton(
        icon: const Icon(
          Icons.share,
          color: Colors.pink,
        ),
        onPressed: room.share,
      ),
    );
  }
}

class RoomPage extends StatefulWidget {
  const RoomPage({super.key});

  @override
  State<RoomPage> createState() => _RoomPageState();
}

class _RoomFormState extends State<RoomForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late TextEditingController nameController;
  late TextEditingController priceController;
  late TextEditingController descriptionController;
  late TextEditingController phoneNumbersController;
  late TextEditingController locationNameController;
  late TextEditingController latitudeController;
  late TextEditingController longitudeController;
  late TextEditingController ratingController;

  List<XFile> imageFiles = [];

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Add new room"),
      actions: [
        TextButton(onPressed: () => _accept(), child: const Text("Cancel")),
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
                _close();

                // then get the image download urls as list in imageUrls variable
                List<String> imageUrls = await uploadImages(
                    imageFiles, 'rooms', nameController.text);

                saveToFireStore(
                  Room(
                    name: nameController.text,
                    price: int.parse(priceController.text),
                    description: descriptionController.text,
                    phoneNumbers: [phoneNumbersController.text],
                    location: CustomBigooitLocation(
                        locationNameController.text,
                        double.parse(latitudeController.text),
                        double.parse(longitudeController.text)),
                    activities: {},
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
                      price: int.parse(priceController.text),
                      description: descriptionController.text,
                      phoneNumbers: [phoneNumbersController.text],
                      location: CustomBigooitLocation(
                          locationNameController.text,
                          double.parse(latitudeController.text),
                          double.parse(longitudeController.text)),
                      activities: {},
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
                decoration: const InputDecoration(
                    hintText: 'Room description',
                    icon: Icon(Icons.description)),
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
                  decoration: const InputDecoration(
                      hintText: 'Price eg. 320',
                      icon: Icon(Icons.monetization_on)),
                  validator: (String? value) {
                    return (value == null || value.isEmpty)
                        ? 'Please enter valid price'
                        : null;
                  }),
              // Room phone number
              TextFormField(
                  keyboardType: TextInputType.phone,
                  controller: phoneNumbersController,
                  decoration: const InputDecoration(
                      hintText: 'Phone Number', icon: Icon(Icons.phone)),
                  validator: (String? value) {
                    return (value == null || value.isEmpty)
                        ? 'Please enter Phone Number'
                        : null;
                  }),
              // Room location
              TextFormField(
                  keyboardType: TextInputType.name,
                  controller: locationNameController,
                  decoration: const InputDecoration(
                      hintText: 'Name of your location',
                      icon: Icon(Icons.location_on)),
                  validator: (String? value) {
                    return (value == null || value.isEmpty)
                        ? 'Please enter your location'
                        : null;
                  }),
              // Latitude
              TextFormField(
                  keyboardType: TextInputType.number,
                  controller: latitudeController,
                  decoration: const InputDecoration(
                      hintText: 'Latitude starts with 11'),
                  validator: (String? value) {
                    return (value == null || value.isEmpty)
                        ? 'Please enter your Latitude'
                        : null;
                  }),
              // Longitute
              TextFormField(
                  keyboardType: TextInputType.number,
                  controller: longitudeController,
                  decoration: const InputDecoration(
                      hintText: 'Longitude starts with 7'),
                  validator: (String? value) {
                    return (value == null || value.isEmpty)
                        ? 'Please enter your Longitude'
                        : null;
                  }),
              // Room rating
              TextFormField(
                  keyboardType: TextInputType.number,
                  controller: ratingController,
                  decoration: const InputDecoration(
                      hintText: 'Stars', icon: Icon(Icons.star)),
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

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    nameController.dispose();
    priceController.dispose();
    descriptionController.dispose();
    phoneNumbersController.dispose();
    locationNameController.dispose();
    latitudeController.dispose();
    longitudeController.dispose();
    ratingController.dispose();

    super.dispose();
  }

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
        TextEditingController(text: widget.room?.location.name);
    latitudeController =
        TextEditingController(text: widget.room?.location.latitude.toString());
    longitudeController =
        TextEditingController(text: widget.room?.location.longitude.toString());
    ratingController =
        TextEditingController(text: widget.room?.rating.toString());
  }

  void saveToFireStore(Room room) {
    FirebaseFirestore.instance.collection("rooms").add(room.toMap());
  }

  void _accept() {
    Navigator.pop(context, true); // dialog returns true
  }

  void _close() {
    Navigator.pop(context);
  }
}

class _RoomPageState extends State<RoomPage> {
  RoomItemViewType _viewType = RoomItemViewType.full;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Rooms in wayanad"),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                switch (_viewType) {
                  case RoomItemViewType.full:
                    _viewType = RoomItemViewType.nameOnly;
                    break;
                  case RoomItemViewType.nameOnly:
                  default:
                    _viewType = RoomItemViewType.full;
                    break;
                }
              });
            },
            icon: Icon(_viewType == RoomItemViewType.full
                ? Icons.list
                : Icons.view_list),
          )
        ],
      ),
      floatingActionButton: isAdmin
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
          padding: const EdgeInsets.only(top: 50, bottom: 150),
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

            switch (_viewType) {
              case RoomItemViewType.nameOnly:
                return RoomNameOnlyWidget(room);
              case RoomItemViewType.full:
              default:
                return RoomItem(room);
            }
          },
        ),
      ),
    );
  }
}
