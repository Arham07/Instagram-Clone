import 'package:flutter/material.dart';
import 'package:instagram_clone/screens/login_screen.dart';

class WebScreenLayout extends StatelessWidget {
  const WebScreenLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      // body: LoginScreen(),
      body:  Center(
        child: Text(
          'web',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
