import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:gokon/providers/loginProvider.dart';
import 'package:gokon/providers/profileProvider.dart';
import 'package:gokon/views/menuScreen.dart';
import 'package:gokon/views/loginScreen.dart';
import 'package:gokon/views/signupScreen.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env.dev");
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LoginProvider()),
        ChangeNotifierProvider(create: (_) => ProfileProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const MenuScreen(),
      routes: <String, WidgetBuilder>{
        '/menuScreen': (BuildContext context) => const MenuScreen(),
        '/loginScreen': (BuildContext context) => const LoginScreen(),
        '/signupScreen': (BuildContext context) => const SignupScreen(),
        '/signup': (BuildContext context) => const SignupScreen(),
      },
    );
  }
}
