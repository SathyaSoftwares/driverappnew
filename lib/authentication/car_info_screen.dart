import 'package:driverappnew/SplashScreen/Splashscreen.dart';
import 'package:driverappnew/global/global.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../Widgets/TextBoxBorder.dart';

class CarInfoScreen extends StatefulWidget {
  @override
  _CarInfoScreenState createState() => _CarInfoScreenState();
}

class _CarInfoScreenState extends State<CarInfoScreen> {
  TextEditingController txtAmbulanceModelController = TextEditingController();
  TextEditingController txtAmbulanceNumberController = TextEditingController();

  List<String> ambulancetypesList = ["Ambulance Type - A","Ambulance Type - B"];
  String? selectedAmbulanceType;

  saveCarInfo(){
    Map driverCarInfoMap =
    {
      "ambulance_model": txtAmbulanceModelController.text.trim(),
      "ambulance_number": txtAmbulanceNumberController.text.trim(),
      "ambulance_type":selectedAmbulanceType
    };

    DatabaseReference driverRef = FirebaseDatabase.instance.ref().child("drivers");
    driverRef.child(currentFirebaseUser!.uid).child("Ambulance_details").set(driverCarInfoMap);

    Fluttertoast.showToast(msg: "Ambulance Details has been saved");
    Navigator.push(context, MaterialPageRoute(builder: (c)=>MySplashScreen()));
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
              Divider(
                height: 1.0,
                thickness: 2.0,
                color: Color(0XFFC6F0ED),
              ),
              SizedBox(height: 10.0,),
              Text(
                "Enter Your Ambulance Details Here",
                style: TextStyle(fontSize: 18.0,fontFamily: "open-sans"),
                textAlign: TextAlign.left,
              ),
              SizedBox(height: 5.0,),
              Visibility(
                visible: false,
                child: TextField(
                  controller: txtAmbulanceModelController,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      labelText: "Ambulance Model",
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
              ),
              SizedBox(height: 15.0,),
              TextField(
                controller: txtAmbulanceNumberController,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                    labelText: "Ambulance Number",
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

              DropdownButtonFormField(
                iconSize: 26,
                dropdownColor: Colors.teal,
                hint: const Text(
                    "Please Choose Ambulance Type",
                  style: TextStyle(
                    fontSize: 14.0,
                    color: Colors.black
                  ),
                ),
                value: selectedAmbulanceType,
                onChanged: (newValue){
                  setState(() {
                    selectedAmbulanceType=newValue;
                  });
                },
                items: ambulancetypesList.map((ambulance){
                  return DropdownMenuItem(child: Text(
                    ambulance,
                    style: const TextStyle(color: Colors.black),
                  ),
                  value: ambulance,
                  );
                }).toList(),
                decoration: InputDecoration(
                    labelText: "Ambulance Type",
                    labelStyle: TextStyle(
                      fontSize: 14.0,
                      color: Colors.black
                    ),
                    hintStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 10.0
                    ),
                    border:TextBoxBorder.txtBorder(),
                    focusedBorder: TextBoxBorder.txtFocus()
                ),
                style: TextStyle(
                  fontSize: 14.0,
                ),
              ),
              SizedBox(height: 16,),
              ElevatedButton(
                style:ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF94D7D2),
                ),
                //textColor: Colors.black,
                child:Container(
                    height: 50.0,
                    child:Center(
                      child: Text(
                        "Update Ambulance Details",
                        style: TextStyle(
                          fontSize: 18.0,
                          fontFamily: "open-sans",
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                ),

                onPressed: (){
                  if(txtAmbulanceNumberController.text.isNotEmpty &&  selectedAmbulanceType != null)
                  {
                    saveCarInfo();
                  }
                  else{
                    Fluttertoast.showToast(msg: "Check all Details");
                  }

                },
              ),

            ],
          ),
        ),
      ),
    );
  }
}
