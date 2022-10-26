import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'World Cities',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Home(),
    );
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late FirebaseFirestore firestore;
  bool loading = false;

  fetch() {
// // Create a new user with a first and last name
//     final user = <String, dynamic>{
//       "first": "Ada",
//       "last": "Lovelace",
//       "born": 1815
//     };

// // Add a new document with a generated ID
//     firestore.collection("world_cities").add(user).then(
//           (DocumentReference doc) =>
//               print('DocumentSnapshot added with ID: ${doc.id}'),
//         );

    firestore.collection('world_cities').get().then((event) {
      for (var doc in event.docs) {
        print("${doc.id} => ${doc.data()}");
      }
    });
  }

  @override
  void initState() {
    firestore = FirebaseFirestore.instance;

    super.initState();

    fetch();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('World Cities'),
      ),
    );
  }
}
