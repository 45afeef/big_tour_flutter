import 'package:big_tour/data/room.dart';
import 'package:big_tour/general/global_variable.dart';
import 'package:big_tour/helpers/comon.dart';
import 'package:big_tour/helpers/location.dart';
import 'package:big_tour/widgets/hybrid_text_editor.dart';
import 'package:big_tour/widgets/activity_list.dart';
import 'package:big_tour/helpers/url_lancher.dart';
import 'package:big_tour/pages/gallary.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:location/location.dart';

import '../helpers/firebase.dart';

class RoomDetailsPage extends StatelessWidget {
  const RoomDetailsPage(
    this.room, {
    super.key,
  });

  final Room room;

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    return Form(
      key: formKey,
      child: Scaffold(
          // Save or Edit the room details in firestore
          floatingActionButton: isAdmin
              ? FloatingActionButton(
                  tooltip: 'Save room in cloud',
                  onPressed: (() {
                    if (formKey.currentState!.validate()) {
                      showToast(context, "I will add this soon");
                      formKey.currentState?.save();
                      FirebaseFirestore.instance
                          .collection("rooms")
                          .doc(room.id)
                          .set(room.toFirestore())
                          .whenComplete(() => Navigator.pop(context));
                    }
                  }),
                  child: const Icon(Icons.upload),
                )
              : const SizedBox(),
          bottomSheet: BottomSheet(
            onClosing: () {
              //  Do what you wanna do when the bottom sheet closes.
            },
            builder: (context) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  // Price for the room
                  SizedBox(
                    width: 50,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        HybridTextEditor(
                          text: "${isAdmin ? "" : "₹"}${room.price}",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                          keyboardType: TextInputType.number,
                          onSaved: (newPrice) =>
                              room.price = int.parse(newPrice!),
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly,
                          ], // Only numbers can be entered
                        ),
                        Text(
                          "/day",
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  // Let's call the room owner if admin is using this app
                  // If the app is using by user, let them call us
                  ElevatedButton(
                    onPressed: () => {
                      makePhoneCall(isAdmin
                          ? room.phoneNumbers.elementAt(0)
                          : "7558009733")
                    },
                    child: Row(
                      children: const [
                        Icon(Icons.call),
                        Text("Call to book now"),
                      ],
                    ),
                  ),
                  // Share the details of the room by whatsApp
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          const Color(0xff00a884)),
                    ),
                    onPressed: () => {sendToWhatsApp(room.whatsAppMessage())},
                    child: Row(
                      children: const [
                        Icon(Icons.send),
                        Text("WhatsApp"),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
          body: Padding(
            padding: const EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 50),
            child: ListView(
              children: [
                Gallary(
                  room.images,
                  bottomPosition: -15,
                  isSquare: true,
                  onLongPress: ((selectedImageIndex) => showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                            content: const Text(
                                "You can either edit or delete the room here"),
                            actions: [
                              TextButton(
                                  onPressed: () => {
                                        Navigator.pop(context),
                                        // Delete the selected image from image list that is stored in firestore
                                        FirebaseFirestore.instance
                                            .collection("rooms")
                                            .doc(room.id)
                                            .update({
                                          "images": FieldValue.arrayRemove(
                                              [selectedImageIndex])
                                        }).then((value) => showToast(context,
                                                "The Image is just deleted"))
                                      },
                                  child: const Text("Delete")),
                              ElevatedButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text("Cancel and Go Back"))
                            ],
                          ))),
                  onTap: () => {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => Gallary(room.images)))
                  },
                  addNewImage: () async {
                    List<String> imageUrls = await uploadImages(
                      await selectImages(),
                      'rooms',
                      room.name,
                    );
                    FirebaseFirestore.instance
                        .collection("rooms")
                        .doc(room.id)
                        .update({"images": FieldValue.arrayUnion(imageUrls)});
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                HybridTextEditor(
                  text: room.name,
                  style: Theme.of(context).textTheme.headline2,
                  onSaved: (newName) => room.name = newName!,
                ),
                Row(
                  children: [
                    InkWell(
                      onTap: (() => {
                            showToast(
                                context, "Searching for current location"),
                            _getLocation()
                          }),
                      child: const Icon(
                        Icons.location_on,
                        color: Colors.amber,
                      ),
                    ),
                    SizedBox(
                      width: 100,
                      child: HybridTextEditor(
                        text: room.location.name,
                        style: Theme.of(context).textTheme.bodySmall,
                        onSaved: (newLocationName) =>
                            room.location.name = newLocationName!,
                      ),
                    ),
                    const Spacer(),
                    const Icon(
                      Icons.star_outline,
                      color: Colors.amber,
                    ),
                    SizedBox(
                      width: 30,
                      child: HybridTextEditor(
                        text: room.rating.toString(), //"4.7(9k reviews)",
                        style: Theme.of(context).textTheme.bodySmall,
                        keyboardType: TextInputType.number,
                        onSaved: (newRating) =>
                            room.rating = double.parse(newRating!),
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.allow(RegExp(r'[\d.]'))
                        ],
                      ),
                    ),
                    // Text(
                    //   room.rating.toString(), //"4.7(9k reviews)",
                    //   style: Theme.of(context).textTheme.bodySmall,
                    // ),
                  ],
                ),
                const Divider(),
                const SizedBox(height: 20),
                Text("Activities",
                    style: Theme.of(context).textTheme.headline6),
                Hero(
                  tag: 'activity-${room.id}',
                  child: Activities(
                    size: 60,
                    activities: room.activities,
                    onChangeActivity: (_, __, allActivities) =>
                        room.activities = allActivities,
                    isEditable: isAdmin,
                  ),
                ),
                const SizedBox(height: 20),
                Text("Description",
                    style: Theme.of(context).textTheme.headline6),
                Hero(
                  tag: 'description-${room.id}',
                  child: HybridTextEditor(
                    text: room.description,
                    style: Theme.of(context).textTheme.bodyText1,
                    onSaved: (newDescription) =>
                        room.description = newDescription!,
                  ),
                ),
                const SizedBox(height: 200),
              ],
            ),
          )),
    );
  }

  _getLocation() async {
    Location location = Location();

    // Check location serviceEnabled
    // wait to enable the location service
    bool serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      // As the location service is not enabled for the app
      // We can request the location service now
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        // Do nothing follows, if the request denied
        return;
      }
    }

    // Ask for location permission
    // check the current allowed permission
    PermissionStatus permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      // request access using requestPermission as permission not granted
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        // Do nothing follows, if the request denied
        return;
      }
    }

    // call getLocation to get the current location
    LocationData locationData = await location.getLocation();

    double latitude = locationData.latitude!;
    double longitude = locationData.longitude!;

    room.location.latitude = latitude;
    room.location.longitude = longitude;

    _getLocationUrl(latitude, longitude);
  }

  _getLocationUrl(double latitude, double longitude) {
    String pinnedPlaceLink =
        "https://www.google.com/maps/place/${decimalDegreesToDMS(latitude)}N+${decimalDegreesToDMS(longitude)}E";
    String morePreciseWithZoom = "/@$latitude,$longitude,18z/";

    launchInBrowser(Uri.parse("$pinnedPlaceLink$morePreciseWithZoom"));
  }
}
