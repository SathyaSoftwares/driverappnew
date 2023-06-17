import 'package:driverappnew/SplashScreen/Splashscreen.dart';
import 'package:driverappnew/authentication/signup_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../Widgets/TextBoxBorder.dart';
import '../Widgets/progress_dialog.dart';
import '../global/global.dart';

class LoginScreen extends StatefulWidget {

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController txtEmailController = TextEditingController();
  TextEditingController txtPasswordController = TextEditingController();

  final googleSignIn = GoogleSignIn();
  GoogleSignInAccount? _user;
  GoogleSignInAccount get user=>_user!;

  valiadteLogin(){
    if(!txtEmailController.text.contains("@")){
      Fluttertoast.showToast(msg: "Enter Valid Email ID.");
    }
    else if(txtPasswordController.text.isEmpty){
      Fluttertoast.showToast(msg: "Enter Phone Number. Phone Number is Mandatory");
    }
    else{
      loginDriver();
    }
  }

  loginDriver() async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext c){
          return ProgressDialog(message: "Signing In, Please wait...",);
        }
    );
    final User? firebaseUser = (
        await fAuth.signInWithEmailAndPassword(
          email: txtEmailController.text.trim(),
          password: txtPasswordController.text.trim(),
        ).catchError((msg){
          Navigator.pop(context);
          Fluttertoast.showToast(msg: "Error: "+msg.toString());
        })
    ).user;

    if(firebaseUser != null){
      DatabaseReference driverRef = FirebaseDatabase.instance.ref().child("drivers");
      driverRef.child(firebaseUser.uid).once().then((driverKey){
        final snap = driverKey.snapshot;
        if(snap.value != null){
          currentFirebaseUser = firebaseUser;
          Fluttertoast.showToast(msg: "Login Successfull.");
          Navigator.push(context, MaterialPageRoute(builder: (c)=>MySplashScreen()));
        }
        else{
          Fluttertoast.showToast(msg: "No record exist with this email");
          fAuth.signOut();
          Navigator.push(context, MaterialPageRoute(builder: (c)=>LoginScreen()));
        }
      });


    }
    else{
      Navigator.pop(context);
      Fluttertoast.showToast(msg: "Error occured while Logging In.");
    }
  }

  googleLogin() async{
    final googleUser = await googleSignIn.signIn();
    if(googleUser==null) return;
    _user = googleUser;

    final googleAuth = await googleUser.authentication;



    final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken
    );

    await FirebaseAuth.instance.signInWithCredential(credential);

    final FirebaseAuth _firebaseAuth=FirebaseAuth.instance;

    if(_user!.email!=null)
    {
      Map userDatamap={
        "name":_user!.displayName,
        "email":_user!.email,
        "phone":"",
        "photoURL":_user!.photoUrl,
      };
      DatabaseReference driverRef=FirebaseDatabase.instance.ref().child("drivers");
      driverRef.child(_firebaseAuth.currentUser!.uid).set(userDatamap);
      driverRef.child(_firebaseAuth.currentUser!.uid).once().then((userKey){
        final snap = userKey.snapshot;
        if(snap.value != null){
          currentFirebaseUser = _firebaseAuth.currentUser;
          Fluttertoast.showToast(msg: "Login Successfull.");
          Navigator.push(context, MaterialPageRoute(builder: (c)=>MySplashScreen()));
        }
        else{
          Fluttertoast.showToast(msg: "No record exist with this email");
          fAuth.signOut();
          Navigator.push(context, MaterialPageRoute(builder: (c)=>LoginScreen()));
        }
      });
    }
    else{
      Fluttertoast.showToast(msg: "No record exist with this email!!!!");
      Navigator.push(context, MaterialPageRoute(builder: (c)=>LoginScreen()));
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFe2fefc),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const SizedBox(height: 10,),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Image.asset("images/medilogin.png"),
              ),
              const SizedBox(height: 10,),

              TextField(
                controller: txtEmailController,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                    labelText: "Email ID*",
                    labelStyle: TextStyle(
                      fontSize: 14.0,
                    ),
                    hintStyle: TextStyle(
                        color: Colors.grey,
                        fontSize: 10.0
                    ),
                    border:TextBoxBorder.txtBorder(),
                    focusedBorder: TextBoxBorder.txtFocus()
                ),
                style: TextStyle(
                  fontSize: 14.0,
                ),
              ),
              SizedBox(height: 30.0,),
              TextField(
                controller: txtPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                    labelText: "Password",
                    labelStyle: TextStyle(
                      fontSize: 14.0,
                    ),
                    hintStyle: TextStyle(
                        color: Colors.grey,
                        fontSize: 10.0
                    ),
                    border:TextBoxBorder.txtBorder(),
                    focusedBorder: TextBoxBorder.txtFocus()
                ),
                style: TextStyle(
                  fontSize: 14.0,
                ),
              ),
              SizedBox(height: 30,),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF94D7D2),
                ),
                //textColor: Colors.black,
                child:Container(
                    height: 50.0,
                    child:Center(
                      child: Text(
                        "Login as Driver",
                        style: TextStyle(
                            fontSize: 18.0,
                            fontFamily: "open-sans",
                            fontWeight: FontWeight.normal
                        ),
                      ),
                    )
                ),
                /*shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(4.0)
                        ),*/
                onPressed: (){
                  valiadteLogin();
                },
              ),
              SizedBox(height: 50.0,),
              Center(
                child: Text("Or Login With",
                  style: TextStyle(
                      fontSize: 14.0,
                      fontFamily: "open-sans",
                      fontWeight: FontWeight.normal
                  ),),
              ),
              /*SizedBox(height: 20.0,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  IconButton(onPressed:() async {
                    googleLogin();

                  }, icon: Image.asset("images/google.png")),
                  Visibility(
                    visible: false,
                    child: IconButton(onPressed:() {

                    }, icon: Image.asset("images/facebook.png"),),
                  ),
                ],
              ),*/
              SizedBox(height: 30,),
              RichText(text: TextSpan(
                  children: [
                    TextSpan(
                        text: 'New Driver ',style: TextStyle(fontFamily: "open-sans",fontWeight: FontWeight.normal,fontSize: 14.0,color: Color(0XFF1A2D3B))
                    ),
                    TextSpan(
                        text: 'Sign Up ',
                        style: TextStyle(fontFamily: "open-sans",fontWeight: FontWeight.bold,fontSize: 18.0,color: Color(0XFF94D7D2)),
                        recognizer: TapGestureRecognizer()
                          ..onTap=(){
                            Navigator.push(context, MaterialPageRoute(builder: (c)=>SignUpScreen()));
                          }
                    ),
                    TextSpan(
                        text: 'here ',style: TextStyle(fontFamily: "open-sans",fontWeight: FontWeight.normal,fontSize: 14.0,color: Color(0XFF1A2D3B))
                    ),
                  ]
              )),
            ],
          ),
        ),
      ),
    );
  }
}
