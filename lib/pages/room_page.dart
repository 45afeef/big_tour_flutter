import 'package:big_tour/data/room.dart';
import 'package:big_tour/widgets/facilities.dart';
import 'package:big_tour/pages/room_details_page.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../helpers/firebase.dart';
import '../providers/room_model.dart';

List roomList = [
  {
    "title": "Iduki1",
    "description": "super way1",
    "imageSrc":
        "https://images.unsplash.com/photo-1666860570907-bc54931a33f9?q=40&w=576"
  },
  {
    "title": "Iduki2",
    "description": "super way2",
    "imageSrc":
        "https://images.unsplash.com/photo-1666973225662-fe02ab2a1dc8?q=40&w=576"
  },
  {
    "title": "Iduki3",
    "description": "super way3",
    "imageSrc":
        "https://images.unsplash.com/photo-1664575197229-3bbebc281874?q=40&w=576"
  },
  {
    "title": "Iduki1",
    "description": "super way1",
    "imageSrc":
        "https://images.unsplash.com/photo-1666860570907-bc54931a33f9?q=40&w=576"
  },
  {
    "title": "Iduki2",
    "description": "super way2",
    "imageSrc":
        "https://images.unsplash.com/photo-1666973225662-fe02ab2a1dc8?q=40&w=576"
  },
  {
    "title": "Iduki3",
    "description": "super way3",
    "imageSrc":
        "https://images.unsplash.com/photo-1664575197229-3bbebc281874?q=40&w=576"
  },
  {
    "title": "Iduki1",
    "description": "super way1",
    "imageSrc":
        "https://images.unsplash.com/photo-1666860570907-bc54931a33f9?q=40&w=576"
  },
  {
    "title": "Iduki2",
    "description": "super way2",
    "imageSrc":
        "https://images.unsplash.com/photo-1666973225662-fe02ab2a1dc8?q=40&w=576"
  },
  {
    "title": "Iduki3",
    "description": "super way3",
    "imageSrc":
        "https://images.unsplash.com/photo-1664575197229-3bbebc281874?q=40&w=576"
  },
  {
    "title": "Iduki1",
    "description": "super way1",
    "imageSrc":
        "https://images.unsplash.com/photo-1666860570907-bc54931a33f9?q=40&w=576"
  },
  {
    "title": "Iduki2",
    "description": "super way2",
    "imageSrc":
        "https://images.unsplash.com/photo-1666973225662-fe02ab2a1dc8?q=40&w=576"
  },
  {
    "title": "Iduki3",
    "description": "super way3",
    "imageSrc":
        "https://images.unsplash.com/photo-1664575197229-3bbebc281874?q=40&w=576"
  },
];

class RoomPage extends StatelessWidget {
  const RoomPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        tooltip: 'Add new room',
        child: const Icon(Icons.add_business_rounded),
        onPressed: () => showDialog(
          barrierDismissible: false,
          context: context,
          builder: (_) => const RoomForm(),
        ),
      ),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          const SliverAppBar(
            pinned: true,
            expandedHeight: 250.0,
            flexibleSpace: FlexibleSpaceBar(
              title: Text('Rooms in Wayanad'),
            ),
          ),
          SliverList(
              delegate: SliverChildListDelegate(const [
            RoomItem(),
            RoomItem(),
            RoomItem(),
            RoomItem(),
            RoomItem(),
            RoomItem(),
            RoomItem(),
            RoomItem(),
          ]))
        ],
      ),
    );
  }
}

class RoomItem extends StatelessWidget {
  const RoomItem({
    Key? key,
    // required this.roomData,
  }) : super(key: key);

  // final Map<String, dynamic> roomData;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: (() => {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => RoomDetailsPage(Room(
                        name: "Wildy Mist",
                        price: 495,
                        description:
                            "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
                        phoneNumbers: ["9876543211"],
                        locationName: "chundale",
                        facilities: ["swimming pool", "kayak", "more"],
                        images: [
                          "https://images.unsplash.com/photo-1545239351-1141bd82e8a6?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=481&q=80",
                          "https://images.unsplash.com/photo-1499951360447-b19be8fe80f5?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1170&q=80",
                          "https://images.unsplash.com/photo-1666969295767-4db7ff1f8fec?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1332&q=80",
                          "https://images.unsplash.com/photo-1666730501852-189f6139d518?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1964&q=80",
                          "https://images.unsplash.com/photo-1666974316102-12699b826038?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=464&q=80",
                          "https://images.unsplash.com/photo-1667159590059-ef149c08a5fd?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1332&q=80"
                        ],
                        rating: 3.9,
                      ))))
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
                      "https://images.unsplash.com/photo-1664575197229-3bbebc281874?q=40&w=576",
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
                                'location',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                              // Spacer(),
                              Text('Resort Name',
                                  style: Theme.of(context).textTheme.headline6),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.favorite_outline,
                            color: Colors.pink,
                          ),
                          onPressed: () => {},
                        )
                      ],
                    ),
                    const Facilities(size: 30),
                    const Divider(),
                    Text(
                      "4-6 guests . Entire Home . 5 beds  . Wifi . Kitchen . 3 bathroom . Free Parking",
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
                          "4.7(9k reviews)",
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        const Spacer(),
                        const Text(
                          "\$495",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "/night",
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

class RoomForm extends StatefulWidget {
  const RoomForm({super.key});

  @override
  State<RoomForm> createState() => _RoomFormState();
}

class _RoomFormState extends State<RoomForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final priceController = TextEditingController();
  final descriptionController = TextEditingController();
  final phoneNumbersController = TextEditingController();
  final locationNameController = TextEditingController();
  final facilitiesController = TextEditingController();
  final imagesController = TextEditingController();
  final ratingController = TextEditingController();

  List<XFile> imageFiles = [];

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    nameController.dispose();
    priceController.dispose();
    descriptionController.dispose();
    phoneNumbersController.dispose();
    locationNameController.dispose();
    facilitiesController.dispose();
    imagesController.dispose();
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
              // Trigger image selection if not yet selected
              // then getn the image download urls as list in imageUrls variable
              List<String> imageUrls = await uploadImages(
                  imageFiles.isEmpty ? await selectImages() : imageFiles,
                  'rooms',
                  nameController.text);

              // Now time to save everything into firestore database
              saveToFireStore(
                Room(
                  name: nameController.text,
                  price: double.parse(priceController.text),
                  description: descriptionController.text,
                  phoneNumbers: [phoneNumbersController.text],
                  locationName: locationNameController.text,
                  facilities: [facilitiesController.text],
                  images: imageUrls,
                  rating: double.parse(ratingController.text),
                ),
              );
            }
          },
          child: const Text('Add new Room'),
        ),
      ],
      content: Form(
        key: _formKey,
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

  void saveToFireStore(Room room) {
    Provider.of<RoomModel>(context, listen: false)
        .save(room)
        .then((value) => Navigator.pop(context));
  }
}
