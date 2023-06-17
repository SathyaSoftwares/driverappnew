import 'package:driverappnew/authentication/login_screen.dart';
import 'package:flutter/material.dart';

import '../SplashScreen/Splashscreen.dart';
import '../global/global.dart';

class ProfileTabPage extends StatefulWidget {
  const ProfileTabPage({Key? key}) : super(key: key);

  @override
  _ProfileTabPageState createState() => _ProfileTabPageState();
}

class _ProfileTabPageState extends State<ProfileTabPage> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        child: const Text(
          "Sign Out"
        ),
        onPressed: (){
          fAuth.signOut();
          Navigator.push(context, MaterialPageRoute(builder: (c)=>LoginScreen()));
        },
      ),
    );
  }
}
