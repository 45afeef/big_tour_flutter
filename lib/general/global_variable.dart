import 'package:firebase_auth/firebase_auth.dart';

final bool isAdmin =
    FirebaseAuth.instance.currentUser?.phoneNumber == "+917558009733";
