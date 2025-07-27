import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart';
import 'package:qarin_mvvm/fieldview.dart';
import 'viewmodel.dart';
import 'view.dart';

//MVVM

//Model
//  API & Database

//ViewModel
//  State & manipulated data

//View
//  Ui

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MapViewModel()),
        ChangeNotifierProvider(create: (_) => FieldViewModel()),
      ],

      child: App(),
    ),
  );
}

// void main(List<String> args) {
//   runApp(App());
// }

class App extends StatelessWidget {
  const App({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(body: WholeMap()),
    );
  }
}

class MyWidget extends StatelessWidget {
  const MyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(child: Container(color: Colors.black, child: Text('data')));
  }
}
