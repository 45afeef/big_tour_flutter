import 'package:big_tour/components/facilities.dart';
import 'package:big_tour/helpers/url_lancher.dart';
import 'package:big_tour/pages/gallary.dart';
import 'package:flutter/material.dart';

const List<String> images = [
  "https://images.unsplash.com/photo-1545239351-1141bd82e8a6?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=481&q=80",
  "https://images.unsplash.com/photo-1499951360447-b19be8fe80f5?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1170&q=80",
  "https://images.unsplash.com/photo-1666969295767-4db7ff1f8fec?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1332&q=80",
  "https://images.unsplash.com/photo-1666730501852-189f6139d518?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1964&q=80",
  "https://images.unsplash.com/photo-1666974316102-12699b826038?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=464&q=80",
  "https://images.unsplash.com/photo-1667159590059-ef149c08a5fd?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1332&q=80"
];

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
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(const Color(0xff00a884)),
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
                images,
                bottomPosition: -39,
                onTap: () => {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const Gallary(images)))
                },
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
