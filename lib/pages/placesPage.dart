import 'package:flutter/material.dart';

List placeList = [
  {
    "title": "Pookode Lake",
    "description": "Place importance with beautiful landscapes and good description",
    "imageSrc":
        "https://images.unsplash.com/photo-1666860570907-bc54931a33f9?q=40&w=576"
  },
  {
    "title": "Phantom Rock",
    "description": "Place importance with beautiful landscapes and good description",
    "imageSrc":
        "https://images.unsplash.com/photo-1666973225662-fe02ab2a1dc8?q=40&w=576"
  },
  {
    "title": "Edacal Caves",
    "description": "Place importance with beautiful landscapes and good description",
    "imageSrc":
        "https://images.unsplash.com/photo-1664575197229-3bbebc281874?q=40&w=576"
  },
  {
    "title": "Kuruva Dweep",
    "description": "Place importance with beautiful landscapes and good description",
    "imageSrc":
        "https://images.unsplash.com/photo-1666860570907-bc54931a33f9?q=40&w=576"
  },
  {
    "title": "Banasura",
    "description": "Place importance with beautiful landscapes and good description",
    "imageSrc":
        "https://images.unsplash.com/photo-1666973225662-fe02ab2a1dc8?q=40&w=576"
  },
  {
    "title": "Chembra peek",
    "description": "Place importance with beautiful landscapes and good description",
    "imageSrc":
        "https://images.unsplash.com/photo-1664575197229-3bbebc281874?q=40&w=576"
  },
  {
    "title": "Iduki1",
    "description": "Place importance with beautiful landscapes and good description",
    "imageSrc":
        "https://images.unsplash.com/photo-1666860570907-bc54931a33f9?q=40&w=576"
  },
  {
    "title": "Iduki2",
    "description": "Place importance with beautiful landscapes and good description",
    "imageSrc":
        "https://images.unsplash.com/photo-1666973225662-fe02ab2a1dc8?q=40&w=576"
  },
  {
    "title": "Iduki3",
    "description": "Place importance with beautiful landscapes and good description",
    "imageSrc":
        "https://images.unsplash.com/photo-1664575197229-3bbebc281874?q=40&w=576"
  },
  {
    "title": "Iduki1",
    "description": "Place importance with beautiful landscapes and good description",
    "imageSrc":
        "https://images.unsplash.com/photo-1666860570907-bc54931a33f9?q=40&w=576"
  },
  {
    "title": "Iduki2",
    "description": "Place importance with beautiful landscapes and good description",
    "imageSrc":
        "https://images.unsplash.com/photo-1666973225662-fe02ab2a1dc8?q=40&w=576"
  },
  {
    "title": "Iduki3",
    "description": "Place importance with beautiful landscapes and good description",
    "imageSrc":
        "https://images.unsplash.com/photo-1664575197229-3bbebc281874?q=40&w=576"
  },
];

class PlacesPage extends StatelessWidget {
  const PlacesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Places in Wayanad")),
      body: Center(
          child: ListView.separated(
        itemCount: placeList.length,
        itemBuilder: (ctx, i) => PlaceItem(
          imageSrc: placeList[i]["imageSrc"],
          title: placeList[i]["title"],
          description: placeList[i]["description"],
          align: i % 2 == 0 ? Align.left : Align.right,
        ),
        separatorBuilder: (BuildContext context, int index) =>
            const Divider(color: Colors.black26),
        padding: const EdgeInsets.all(10.0),
      )),
    );
  }
}

class PlaceItem extends StatelessWidget {
  const PlaceItem({
    Key? key,
    required this.imageSrc,
    required this.title,
    required this.description,
    this.align = Align.left,
  }) : super(key: key);

  final String title;
  final String description;
  final String imageSrc;
  final Align align;

  @override
  Widget build(BuildContext context) {
    Widget image = Expanded(
      child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(15)),
          child: Image.network(imageSrc)),
    );
    Widget titleAndDescription = Expanded(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(title, style: Theme.of(context).textTheme.headline6),
        Text(description, style: Theme.of(context).textTheme.bodyText1),
      ],
    ));

    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(15)),
        color: Colors.deepOrange[50],
      ),
      padding: const EdgeInsets.all(10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...(align == Align.right
              ? [image, const SizedBox(width: 10), titleAndDescription]
              : [titleAndDescription, const SizedBox(width: 10), image])
        ],
      ),
    );
  }
}

enum Align {
  right,
  left,
}
