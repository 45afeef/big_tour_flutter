import 'package:big_tour/components/facilities.dart';
import 'package:big_tour/components/imageList.dart';
import 'package:big_tour/helpers/urlLancher.dart';
import 'package:big_tour/pages/gallary.dart';
import 'package:flutter/material.dart';

class RoomDetailsPage extends StatelessWidget {
  const RoomDetailsPage({super.key});

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
                    const Text(
                      "\$495",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "/night",
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
                  // ignore: prefer_const_constructors
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Color(0xff00a884)),
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
              Container(
                alignment: Alignment.center,
                child: Stack(
                  alignment: AlignmentDirectional.bottomCenter,
                  clipBehavior: Clip.none,
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(15)),
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: InkWell(
                          onTap: () => {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => Gallary()))
                          },
                          child: Image.network(
                            "https://images.unsplash.com/photo-1664575197229-3bbebc281874?q=40&w=576",
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    const Positioned(
                      bottom: -39,
                      child: ImageList(),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              Text(
                "Wildy Mist",
                style: Theme.of(context).textTheme.headline2,
              ),
              Row(
                children: [
                  const Icon(
                    Icons.location_on,
                    color: Colors.amber,
                  ),
                  Text(
                    "location",
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const Spacer(),
                  const Icon(
                    Icons.star_outline,
                    color: Colors.amber,
                  ),
                  Text(
                    "4.7(9k reviews)",
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
              Text(
                  "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
                  style: Theme.of(context).textTheme.bodyText1),
            ],
          ),
        ));
  }
}
