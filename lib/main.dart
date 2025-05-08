import 'package:firebase_auth/firebase_auth.dart' hide PhoneAuthProvider;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/firebase_options.dart';
import '/pages/choose_your_need.dart';
import '/providers/place_model.dart';
import '/providers/room_model.dart';
import 'helpers/url_lancher.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PlaceModel()),
        ChangeNotifierProvider(create: (_) => RoomModel()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Map Your Trip',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.pink,
        textTheme: TextTheme(
            headlineMedium: TextStyle(
                color: Colors.deepPurple[600],
                fontSize: 16.0,
                fontWeight: FontWeight.bold),
            bodyMedium: const TextStyle(
                color: Colors.black45, fontWeight: FontWeight.normal)),
      ),
      home: const MyHomePage(title: 'Map Your Trip'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  const MyHomePage({super.key, required this.title});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.

    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData) {
          return SignInScreen(
            providers: [PhoneAuthProvider()],
          );
        }
        if (!snapshot.hasData) {
          return MaterialApp(
            theme: ThemeData(
                colorScheme: ColorScheme.fromSeed(seedColor: Colors.red)),
            home: SignInScreen(
              showAuthActionSwitch: false,
              providers: [PhoneAuthProvider()],
            ),
          );
        }
        return Scaffold(
          appBar: AppBar(
            title: Text(widget.title),
            actions: [
              IconButton(
                icon: const Icon(Icons.logout),
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();
                },
              ),
            ],
          ),
          body: const ChooseYourNeed(),
          floatingActionButton: FloatingActionButton(
            onPressed: () => makePhoneCall("7558009733"),
            tooltip: 'Call now',
            child: const Icon(Icons.call),
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();

    _loadDataFromServer();
  }

  _loadDataFromServer() {
    // commenting this as I have started using firebase_ui packages
    // TODO: needs to learn more about it soon
    Provider.of<PlaceModel>(context, listen: false); //.fetchPlaces();
    Provider.of<RoomModel>(context, listen: false); //.fetchPlaces();
  }
}
