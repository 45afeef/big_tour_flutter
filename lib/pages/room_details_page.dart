import 'package:big_tour/data/room.dart';
import 'package:big_tour/widgets/facilities.dart';
import 'package:big_tour/helpers/url_lancher.dart';
import 'package:big_tour/pages/gallary.dart';
import 'package:flutter/material.dart';

class RoomDetailsPage extends StatelessWidget {
  const RoomDetailsPage(
    this.room, {
    super.key,
  });

  final Room room;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomSheet: BottomSheet(
          onClosing: () {
            //  Do what you wanna do when the bottom sheet closes.
          },
          builder: (context) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "\$${room.price}",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "/day",
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: () => {makePhoneCall("7558009733")},
                  child: Row(
                    children: const [
                      Icon(Icons.call),
                      Text("Call to book now"),
                    ],
                  ),
                ),
                ElevatedButton(
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
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                room.name,
                style: Theme.of(context).textTheme.headline2,
              ),
              Row(
                children: [
                  const Icon(
                    Icons.location_on,
                    color: Colors.amber,
                  ),
                  Text(
                    room.locationName,
                    style: Theme.of(context).textTheme.bodySmall,
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
              Text(room.description,
                  style: Theme.of(context).textTheme.bodyText1),
            ],
          ),
        ));
  }
}
