import 'room_page.dart';
import 'package:flutter/material.dart';
import 'places_page.dart';

class ChooseYourNeed extends StatelessWidget {
  const ChooseYourNeed({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Padding(
            padding: EdgeInsets.all(20.0),
            child: Text('What do you want ?'),
          ),
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

class ImagedButton extends StatelessWidget {
  const ImagedButton({
    Key? key,
    required this.text,
    required this.onPressed,
    required this.url,
  }) : super(key: key);

  final String text;
  final String url;
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            IconButton(
                icon: Image.network(url), onPressed: onPressed, iconSize: 50),
            TextButton(onPressed: onPressed, child: Text(text)),
          ],
        ));
  }
}
