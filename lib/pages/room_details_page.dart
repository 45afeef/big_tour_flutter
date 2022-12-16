import 'package:big_tour/data/room.dart';
import 'package:big_tour/general/global_variable.dart';
import 'package:big_tour/helpers/location.dart';
import 'package:big_tour/widgets/facilities.dart';
import 'package:big_tour/helpers/url_lancher.dart';
import 'package:big_tour/pages/gallary.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
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
    return Scaffold(
        floatingActionButton: isAdmin
            ? FloatingActionButton(
                tooltip: 'Save resort in cloud',
                child: const Icon(Icons.upload),
                onPressed: () async {
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
                const Spacer(flex: 1),
                Expanded(
                  flex: 3,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      HybridTextEditable(
                        text: "\$${room.price}",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      HybridTextEditable(
                        text: "/day",
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                const Spacer(flex: 1),
                Expanded(
                  flex: 3,
                  child: ElevatedButton(
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
                ),
                const Spacer(flex: 1),
                Expanded(
                  flex: 3,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          const Color(0xff00a884)),
                    ),
                    onPressed: () => {sendToWhatsApp()},
                    child: Row(
                      children: const [
                        Icon(Icons.send),
                        Text("WhatsApp"),
                      ],
                    ),
                  ),
                ),
                const Spacer(
                  flex: 1,
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
              HybridTextEditable(
                text: room.name,
                style: Theme.of(context).textTheme.headline2,
              ),
              Row(
                children: [
                  const Icon(
                    Icons.location_on,
                    color: Colors.amber,
                  ),
                  InkWell(
                    onTap: (() => _getLocation()),
                    child: Text(
                      room.location.name,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                  const Spacer(),
                  const Icon(
                    Icons.star_outline,
                    color: Colors.amber,
                  ),
                  Text(
                    room.rating.toString(), //"4.7(9k reviews)",
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
              const Divider(),
              const SizedBox(height: 20),
              Text("Faciliteis", style: Theme.of(context).textTheme.headline6),
              const Facilities(size: 60),
              const SizedBox(height: 20),
              Text("Description", style: Theme.of(context).textTheme.headline6),
              HybridTextEditable(
                  text: room.description,
                  style: Theme.of(context).textTheme.bodyText1),
              const SizedBox(height: 200),
            ],
          ),
        ));
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

    String pinnedPlaceLink =
        "https://www.google.com/maps/place/${decimalDegreesToDMS(locationData.latitude)}N+${decimalDegreesToDMS(locationData.longitude)}E";
    String morePreciseWithZoom = "/@11.6276889,76.0836722,18z/";

    launchInBrowser(Uri.parse("$pinnedPlaceLink$morePreciseWithZoom"));
  }
}

class HybridTextEditable extends StatefulWidget {
  const HybridTextEditable(
      {Key? key,
      this.text,
      this.hintText = "Enter here",
      this.style,
      this.validator})
      : super(key: key);

  final String? text;
  final String hintText;
  final TextStyle? style;
  final String? Function(String?)? validator;

  @override
  State<HybridTextEditable> createState() => _HybridTextEditableState();
}

class _HybridTextEditableState extends State<HybridTextEditable> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    // Initialize the controllers when the widget is first initialized.
    _controller = TextEditingController(text: widget.text);
  }

  @override
  void dispose() {
    super.dispose();
    // Clean up the controller when the widget is disposed.
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return isAdmin
        ? TextFormField(
            controller: _controller,
            decoration: InputDecoration(hintText: widget.hintText),
            style: widget.style,
            validator: widget.validator ??
                (String? value) {
                  return (value == null || value.isEmpty)
                      ? 'Please enter room name'
                      : null;
                },
          )
        : Text(
            widget.text ?? "",
            style: widget.style,
          );
  }
}
