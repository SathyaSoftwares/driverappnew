import 'package:driverappnew/Widgets/progress_dialog.dart';
import 'package:driverappnew/authentication/car_info_screen.dart';
import 'package:driverappnew/authentication/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../Widgets/TextBoxBorder.dart';
import '../global/global.dart';

class SignUpScreen extends StatefulWidget {

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController txtNameController = TextEditingController();
  TextEditingController txtEmailController = TextEditingController();
  TextEditingController txtPhoneController = TextEditingController();
  TextEditingController txtPasswordController = TextEditingController();
  TextEditingController txtCPasswordController = TextEditingController();

  validateForm(){
    if(txtNameController.text.length<5){
      Fluttertoast.showToast(msg: "Name must be atleast 5 characters");
    }
    else if(!txtEmailController.text.contains("@")){
      Fluttertoast.showToast(msg: "Enter Valid Email ID.");
    }
    else if(txtPhoneController.text.isEmpty){
      Fluttertoast.showToast(msg: "Enter Phone Number. Phone Number is Mandatory");
    }
    else if(txtPasswordController.text.length<6){
      Fluttertoast.showToast(msg: "Password must be atleast 6 characters");
    }
    else if(txtPasswordController.text.trim()!=txtCPasswordController.text.trim())
    {
      //displayMessage("Password and Confirm password are not same", context);
      Fluttertoast.showToast(msg:"Password and Confirm password are not same");
    }
    else{
        saveDriverInfo();
    }
  }

  saveDriverInfo() async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext c){
          return ProgressDialog(message: "Processing, Please wait...",);
        }
    );
    final User? firebaseUser = (
        await fAuth.createUserWithEmailAndPassword(
          email: txtEmailController.text.trim(),
          password: txtPasswordController.text.trim(),
        ).catchError((msg){
          Navigator.pop(context);
          Fluttertoast.showToast(msg: "Error: "+msg.toString());
        })
    ).user;

    if(firebaseUser != null){
      Map driverMap =
      {
        "id":firebaseUser.uid,
        "name":txtNameController.text.trim(),
        "email": txtEmailController.text.trim(),
        "phone":txtPhoneController.text.trim()
      };
      DatabaseReference driverRef = FirebaseDatabase.instance.ref().child("drivers");
      driverRef.child(firebaseUser.uid).set(driverMap);

      currentFirebaseUser = firebaseUser;
      Fluttertoast.showToast(msg: "Account has been created.");
      Navigator.push(context, MaterialPageRoute(builder: (c)=>CarInfoScreen()));

    }
    else{
      Navigator.pop(context);
      Fluttertoast.showToast(msg: "Account has not been created.");
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
              Divider(
                height: 1.0,
                thickness: 2.0,
                color: Color(0XFFC6F0ED),
              ),
              SizedBox(height: 10.0,),
              Text(
                "Enter Your Details Here",
                style: TextStyle(fontSize: 18.0,fontFamily: "open-sans"),
                textAlign: TextAlign.left,
              ),
              SizedBox(height: 5.0,),
              TextField(
                controller: txtNameController,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                    labelText: "Name",
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
              SizedBox(height: 15.0,),
              TextField(
                controller: txtEmailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                    labelText: "Email",
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

              SizedBox(height: 15.0,),
              TextField(
                controller: txtPhoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                    prefix: Text("+60",style: TextStyle(fontWeight: FontWeight.w900,fontSize: 18.0,color: Colors.black),),
                    labelText: "Phone No.",
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
                  fontSize: 18.0,
                ),
              ),

              SizedBox(height: 15.0,),
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

              SizedBox(height: 15.0,),
              TextField(
                controller: txtCPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                    labelText: "Confirm Password",
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
              ElevatedButton(
                style:ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF94D7D2),
                ),
                //textColor: Colors.black,
                child:Container(
                    height: 50.0,
                    child:Center(
                      child: Text(
                        "Sign up",
                        style: TextStyle(
                          fontSize: 18.0,
                          fontFamily: "open-sans",
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                ),
                /*shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(24.0)
                        ),*/
                onPressed: (){
                  validateForm();

                },
              ),
              SizedBox(height: 50.0,),

              RichText(text: TextSpan(
                  children: [
                    TextSpan(
                        text: 'Already have an Account ',style: TextStyle(fontFamily: "open-sans",fontWeight: FontWeight.normal,fontSize: 14.0,color: Color(0XFF1A2D3B))
                    ),
                    TextSpan(
                        text: 'Sign In ',
                        style: TextStyle(fontFamily: "open-sans",fontWeight: FontWeight.normal,fontSize: 14.0,color: Color(0XFF94D7D2)),
                        recognizer: TapGestureRecognizer()
                          ..onTap=(){
                            Navigator.push(context, MaterialPageRoute(builder: (c)=>LoginScreen()));
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
