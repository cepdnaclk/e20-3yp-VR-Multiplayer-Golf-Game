import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'Screens/splash_screen.dart';
import 'Screens/login_screen.dart';
import 'Screens/device_connection_page.dart';
import 'Screens/home_page.dart';
import 'Screens/create_room.dart';
import 'Screens/join_room.dart';
import 'Screens/avatar_setting_page.dart';
import 'Screens/game_setting_page.dart';
import 'Screens/help_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

 

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'VR Golf Multiplayer',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      initialRoute: '/splash',
      routes: {
        '/splash': (context) => SplashScreen(),
        '/login': (context) => LoginScreen(),
        '/deviceConnection': (context) => DeviceConnectionPage(),
        '/home': (context) => HomePage(),
        '/createRoom': (context) => CreateRoomPage(),
        '/joinRoom': (context) => JoinRoomPage(),
        '/avatarSettings': (context) =>  AvatarSettingPage(),
        '/gameSettings': (context) => GameSettingPage(),
        '/help': (context) => HelpPage(),
      },
    );
  }
}
