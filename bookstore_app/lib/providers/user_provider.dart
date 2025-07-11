import 'dart:async';

import 'package:bookstore_app/controlllers/db_service.dart';
import 'package:bookstore_app/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier{
  StreamSubscription<DocumentSnapshot>? _userSubscription;

  String name ="User";
  String email ="";
  String address ="";
  String phone ="";

  UserProvider(){
    loadUserData();
  }
  
  // load user profile data
  void loadUserData(){   

      _userSubscription?.cancel();
      _userSubscription = DbService().readUserData().listen((snapshot) {

      print(snapshot.data());
      final UserModel data = UserModel.fromJson(snapshot.data() as Map<String, dynamic>);
      name = data.name;
      email = data.email;
      address = data.address;
      phone = data.phone;
      notifyListeners();
    });
 
  }
}