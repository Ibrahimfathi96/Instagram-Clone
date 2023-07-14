import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/responsive/mobile_screen_layout.dart';
import 'package:instagram_clone/responsive/responsive_layout_screen.dart';
import 'package:instagram_clone/responsive/web_screen_layout.dart';
import 'package:instagram_clone/screens/login_screen.dart';
import 'package:instagram_clone/utils/colors.dart';

class AppMainStreamBuilder extends StatelessWidget {
  const AppMainStreamBuilder({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          if (snapshot.hasData) {
            return const ResponsiveLayout(
              mobileScreenLayout: MobileScreenLayout(),
              webScreenLayout: WebScreenLayout(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Column(
                children: [
                  const CircularProgressIndicator(
                    color: primaryColor,
                  ),
                  Text("${snapshot.error}"),
                ],
              ),
            );
          }
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: Column(
              children: [
                CircularProgressIndicator(
                  color: primaryColor,
                ),
                Text("please wait..."),
              ],
            ),
          );
        }
        return const LoginScreen();
      },
    );
  }
}
