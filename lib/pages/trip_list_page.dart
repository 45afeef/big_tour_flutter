import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:share_plus/share_plus.dart';

import '/helpers/firebase.dart';
import '/widgets/cached_image.dart';
import '../general/global_variable.dart';

class TripsListPage extends StatefulWidget {
  const TripsListPage({super.key});

  @override
  State<TripsListPage> createState() => _TripsListPageState();
}

class _TripsListPageState extends State<TripsListPage> {
  static List<String> tripsImagesUrlList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Trips in wayanad")),
      body: LayoutBuilder(builder: ((context, constraints) {
        int columnCount = (constraints.maxWidth / 100).floor();
        return GridView.count(
          crossAxisCount: columnCount,
          crossAxisSpacing: 1.0,
          mainAxisSpacing: 1.0,
          children: [
            ...tripsImagesUrlList.map((imageUrl) => InkWell(
                  onLongPress: () async {
                    // Share the trip to other apps
                    var file =
                        await DefaultCacheManager().getSingleFile(imageUrl);
                    Share.shareXFiles([XFile(file.path)]);
                  },
                  child: CachedImage(imageUrl: imageUrl),
                ))
          ],
        );
      })),
      floatingActionButton: isAdmin
          ? FloatingActionButton(
              onPressed: () async => {
                await uploadImages(await selectImages(), "Gallery", "TripMaps"),
                Navigator.pop(context)
              },
              tooltip: 'Upload Trip Images',
              child: const Icon(Icons.upload),
            )
          : null,
    );
  }

  void getFirebaseImageFolder() {
    final Reference storageRef =
        FirebaseStorage.instance.ref().child('Gallery').child('TripMaps');

    storageRef.listAll().then((result) async {
      List<String> allUrls = [];
      for (Reference i in result.items) {
        String url = await i.getDownloadURL();

        allUrls.add(url);
      }

      setState(() {
        tripsImagesUrlList = allUrls;
      });
    });
  }

  @override
  void initState() {
    super.initState();

    getFirebaseImageFolder();
  }
}
