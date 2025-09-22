import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart';
import 'package:qarin_mvvm/fieldview.dart';
import 'viewmodel.dart';
import 'view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MapViewModel()),
        ChangeNotifierProvider(create: (_) => FieldViewModel()),
        ChangeNotifierProvider(create: (_) => MarkerkayerViewModel()),
      ],

      child: App(),
    ),
  );
}

class App extends StatelessWidget {
  const App({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(body: WholeMap()),
      theme: ThemeData(
        cardColor: Colors.white,
        cardTheme: CardThemeData(
          shape: BeveledRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            side: BorderSide(
              width: 1.8,
              color:
                  context.watch<FieldViewModel>().side == 'rsf'
                      ? Colors.yellow
                      : Colors.green,
            ),
          ),
        ),
      ),
    );
  }
}
