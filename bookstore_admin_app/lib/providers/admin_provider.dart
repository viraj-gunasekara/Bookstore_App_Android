import 'dart:async';

import 'package:bookstore_admin_app/controlllers/db_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AdminProvider extends ChangeNotifier {
  List<QueryDocumentSnapshot> categories = [];
  StreamSubscription<QuerySnapshot>? _categorySubscription;

  int totalCategories = 0;

  AdminProvider(){
    getCategories();
  }

  //GET all the categories
  void getCategories() {
    _categorySubscription?.cancel();
    _categorySubscription = DbService().readCategories().listen((snapshot) {
      categories = snapshot.docs;
      totalCategories=snapshot.docs.length;
      notifyListeners();
    });
  }

}
