import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';
import 'screens/device_connection_page.dart';
import 'screens/home_page.dart';
import 'screens/create_room.dart';
import 'screens/join_room.dart';
import 'screens/avatar_setting_page.dart';
import 'screens/game_setting_page.dart';
import 'screens/help_page.dart';

void main() {
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
      initialRoute: '/',
      routes: {
        '/': (context) => SplashScreen(),
        '/login': (context) => LoginScreen(),
        '/device_connection': (context) => DeviceConnectionPage(),
        '/home': (context) => HomePage(),
        '/create_room': (context) => CreateRoomPage(),
        '/join_room': (context) => JoinRoomPage(),
        '/avatar_setting': (context) => AvatarSettingPage(),
        '/game_setting': (context) => GameSettingPage(),
        '/help': (context) => HelpPage(),
      },
    );
  }
}
