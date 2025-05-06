import 'package:flutter/material.dart';

import '/pages/trip_list_page.dart';
import '../widgets/imaged_button.dart';
import 'places_page.dart';
import 'room_page.dart';

class ChooseYourNeed extends StatelessWidget {
  const ChooseYourNeed({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          const Padding(
            padding: EdgeInsets.all(20.0),
            child: Text('What do you want ?'),
          ),
          ImagedButton(
              onPressed: () => {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const TripsListPage())),
                  },
              text: "Trips",
              url: "https://cdn-icons-png.flaticon.com/512/1257/1257385.png"),
          ImagedButton(
              onPressed: () => {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const PlacesPage()))
                  },
              text: "Places to visit",
              url: "https://cdn-icons-png.flaticon.com/512/854/854878.png"),
          ImagedButton(
              onPressed: () => {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const RoomPage()))
                  },
              text: "Rooms to stay",
              url: "https://cdn-icons-png.flaticon.com/512/1069/1069454.png"),
          ImagedButton(
              onPressed: () => {},
              text: "Restaurants to eat",
              url: "https://cdn-icons-png.flaticon.com/512/776/776443.png"),
        ],
      ),
    );
  }
}
