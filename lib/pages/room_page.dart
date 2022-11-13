import 'package:big_tour/widgets/facilities.dart';
import 'package:big_tour/pages/room_details_page.dart';
import 'package:flutter/material.dart';

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
                  builder: (context) => const RoomDetailsPage()))
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
                          onPressed: () => {
                            
                          },
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
