import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:service_station/screens/work.dart';
import 'package:firebase_core/firebase_core.dart';

import 'models/cart_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => Cart(),
      child: MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          initialRoute: '/works',
          routes: {
            '/works': (context) => WorkScreen(),
          }),
    );
  }
}
