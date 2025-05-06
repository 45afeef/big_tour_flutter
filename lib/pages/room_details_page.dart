import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:location/location.dart';

import '/data/room.dart';
import '/general/global_variable.dart';
import '/helpers/comon.dart';
import '/helpers/url_lancher.dart';
import '/pages/gallary.dart';
import '/widgets/activity_list.dart';
import '/widgets/hybrid_text_editor.dart';
import '../helpers/firebase.dart';

class RoomDetailsPage extends StatefulWidget {
  const RoomDetailsPage(
    this.room, {
    super.key,
  });

  final Room room;

  @override
  State<RoomDetailsPage> createState() => _RoomDetailsPageState();
}

class _RoomDetailsPageState extends State<RoomDetailsPage> {
  bool canEdit = false;

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
                    if (canEdit) {
                      if (formKey.currentState!.validate()) {
                        showToast(context, "I will add this soon");
                        formKey.currentState!.save();
                        FirebaseFirestore.instance
                            .collection("rooms")
                            .doc(widget.room.id)
                            .set(widget.room.toFirestore());
                        Navigator.pop(context);
                      } else {
                        showToast(
                            context, 'Not saved because of one or more errors');
                      }
                    } else {
                      setState(() {
                        canEdit = true;
                      });
                    }
                  }),
                  child: Icon(canEdit ? Icons.save : Icons.edit),
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
                          isEditable: canEdit,
                          text: "${canEdit ? "" : "₹"}${widget.room.price}",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                          keyboardType: TextInputType.number,
                          onSaved: (newPrice) =>
                              widget.room.price = int.parse(newPrice!),
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
                      makePhoneCall(canEdit
                          ? widget.room.phoneNumbers.elementAt(0)
                          : "7558009733")
                    },
                    child: const Row(
                      children: [
                        Icon(Icons.call),
                        Text("Call to book now"),
                      ],
                    ),
                  ),
                  // Share the details of the room by whatsApp
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all<Color>(
                          const Color(0xff00a884)),
                    ),
                    onPressed: widget.room.share,
                    child: const Row(
                      children: [
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
                  widget.room.images,
                  bottomPosition: -25,
                  isSquare: true,
                  onLongPress: ((selectedImageUrl) => showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                            content:
                                const Text("Do you want to delete this image?"),
                            actions: [
                              TextButton(
                                  onPressed: () => {
                                        Navigator.pop(context),
                                        // Delete the selected image from image list that is stored in firestore
                                        FirebaseFirestore.instance
                                            .collection("rooms")
                                            .doc(widget.room.id)
                                            .update({
                                          "images": FieldValue.arrayRemove(
                                              [selectedImageUrl])
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
                    Navigator.of(context).push(
                      PageRouteBuilder(
                        pageBuilder: (_, __, ___) => Gallary(
                          widget.room.images,
                        ),
                        transitionDuration: const Duration(seconds: 1),
                      ),
                    )
                  },
                  addNewImage: () async {
                    List<String> imageUrls = await uploadImages(
                      await selectImages(),
                      'rooms',
                      widget.room.name,
                    );
                    FirebaseFirestore.instance
                        .collection("rooms")
                        .doc(widget.room.id)
                        .update({"images": FieldValue.arrayUnion(imageUrls)});
                  },
                ),
                const SizedBox(
                  height: 30,
                ),
                HybridTextEditor(
                  isEditable: canEdit,
                  text: widget.room.name,
                  style: Theme.of(context).textTheme.headlineMedium,
                  onSaved: (newName) => widget.room.name = newName!,
                ),
                Row(
                  children: [
                    InkWell(
                      onTap: widget.room.launchLocationOnMap,
                      onLongPress: () => {
                        showToast(context, "Searching for current location"),
                        canEdit && _getLocation()
                      },
                      child: const Icon(
                        Icons.location_on,
                        color: Colors.amber,
                      ),
                    ),
                    SizedBox(
                      width: 100,
                      child: HybridTextEditor(
                        isEditable: canEdit,
                        text: widget.room.location.name,
                        style: Theme.of(context).textTheme.bodySmall,
                        onSaved: (newLocationName) =>
                            widget.room.location.name = newLocationName!,
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
                        isEditable: canEdit,
                        text:
                            widget.room.rating.toString(), //"4.7(9k reviews)",
                        style: Theme.of(context).textTheme.bodySmall,
                        keyboardType: TextInputType.number,
                        onSaved: (newRating) =>
                            widget.room.rating = double.parse(newRating!),
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.allow(RegExp(r'[\d.]'))
                        ],
                      ),
                    ),
                  ],
                ),
                const Divider(),
                const SizedBox(height: 20),
                Text("Activities",
                    style: Theme.of(context).textTheme.headlineLarge),
                Hero(
                  tag: 'activity-${widget.room.id}',
                  child: Activities(
                    size: 60,
                    activities: widget.room.activities,
                    onChangeActivity: (_, __, allActivities) =>
                        widget.room.activities = allActivities,
                    isEditable: canEdit,
                  ),
                ),
                const SizedBox(height: 20),
                Text("Description",
                    style: Theme.of(context).textTheme.headlineMedium),
                Hero(
                  tag: 'description-${widget.room.id}',
                  child: HybridTextEditor(
                    isEditable: canEdit,
                    text: widget.room.description,
                    minLines: 5,
                    maxLines: 15,
                    style: Theme.of(context).textTheme.bodyMedium,
                    onSaved: (newDescription) =>
                        widget.room.description = newDescription!,
                    keyboardType: TextInputType.multiline,
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

    widget.room.location.latitude = latitude;
    widget.room.location.longitude = longitude;

    widget.room.launchLocationOnMap();
  }
}
