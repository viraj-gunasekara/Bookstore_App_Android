import 'dart:async';

import 'package:bookstore_admin_app/controlllers/db_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AdminProvider extends ChangeNotifier {
  List<QueryDocumentSnapshot> categories = [];
  StreamSubscription<QuerySnapshot>? _categorySubscription;

  List<QueryDocumentSnapshot> books = [];
  StreamSubscription<QuerySnapshot>? _booksSubscription;

  int totalCategories = 0;
  int totalBooks = 0;

  AdminProvider() {
    getCategories();
    getBooks();
  }

  //GET all the categories
  void getCategories() {
    _categorySubscription?.cancel();
    _categorySubscription = DbService().readCategories().listen((snapshot) {
      categories = snapshot.docs;
      totalCategories = snapshot.docs.length;
      notifyListeners();
    });
  }

  // GET all the books
  void getBooks() {
    _booksSubscription?.cancel();
    _booksSubscription = DbService().readBooks().listen((snapshot) {
      books = snapshot.docs;
      totalBooks = snapshot.docs.length;
      notifyListeners();
    });
  }
}
