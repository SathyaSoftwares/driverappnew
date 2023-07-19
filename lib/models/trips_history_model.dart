import 'package:firebase_database/firebase_database.dart';

class TripsHistoryModel
{
  String? BookedOn;
  String? originAddress;
  String? destinationAddress;
  String? status;
  String? fareAmount;
  String? userName;
  String? userPhone;

  TripsHistoryModel({
    this.BookedOn,
    this.originAddress,
    this.destinationAddress,
    this.status,
    this.userName,
    this.userPhone,
  });

  TripsHistoryModel.fromSnapshot(DataSnapshot dataSnapshot)
  {
    BookedOn = (dataSnapshot.value as Map)["BookedOn"];
    originAddress = (dataSnapshot.value as Map)["originAddress"];
    destinationAddress = (dataSnapshot.value as Map)["destinationAddress"];
    status = (dataSnapshot.value as Map)["status"];
    fareAmount = (dataSnapshot.value as Map)["fareAmount"];
    userName = (dataSnapshot.value as Map)["userName"];
    userPhone = (dataSnapshot.value as Map)["userPhone"];
  }
}