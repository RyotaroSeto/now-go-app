import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:gokon/providers/loginProvider.dart';
import 'package:gokon/providers/profileProvider.dart';
import 'package:gokon/views/menuScreen.dart';
import 'package:gokon/views/loginScreen.dart';
import 'package:gokon/views/signupScreen.dart';
import 'package:gokon/views/myProfileScreen.dart';
import 'package:gokon/views/approachedScreen.dart';
import 'package:gokon/views/approachingScreen.dart';
import 'package:gokon/views/matchingScreen.dart';
import 'package:gokon/views/messageScreen.dart';
import 'package:gokon/views/profileDetailScreen.dart';
import 'package:gokon/views/profilesScreen.dart';
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
        '/menu': (BuildContext context) => const MenuScreen(),
        '/login': (BuildContext context) => const LoginScreen(),
        '/signup': (BuildContext context) => const SignupScreen(),
        '/my-profile': (BuildContext context) => const MyProfileScreen(),
        '/looking': (BuildContext context) => const ProfilesScreen(),
        '/favorite': (BuildContext context) => const ApproachingScreen(),
        '/chance': (BuildContext context) => const ApproachedScreen(),
        '/matching': (BuildContext context) => const MatchingScreen(),
        '/message': (BuildContext context) => const MessageScreen(),
        '/profile-detail': (BuildContext context) =>
            const ProfileDetailScreen(),
      },
    );
  }
}
