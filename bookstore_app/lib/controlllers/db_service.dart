import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DbService {
  User? user = FirebaseAuth.instance.currentUser;

  // USER DATA
  // save user data in firestore db, when creating new account
  Future saveUserData({required String name, required String email}) async {
    try {
      Map<String, dynamic> data = {
        "name": name,
        "email": email,
      };
      await FirebaseFirestore.instance
          .collection("bookshop_users")
          .doc(user!.uid)
          .set(data);
    } catch (e) {
      print("error on saving user data: $e");
    }
  }

  // update user data in firestore database
  Future updateUserData({required Map<String, dynamic> extraData}) async {
    await FirebaseFirestore.instance
        .collection("bookshop_users")
        .doc(user!.uid)
        .update(extraData);
  }

  // read user data from db
  Stream<DocumentSnapshot> readUserData() {
    return FirebaseFirestore.instance
        .collection("bookshop_users")
        .doc(user!.uid)
        .snapshots();
  }


  // READ PROMOTIONS AND BANNERS FROM DB
  Stream<QuerySnapshot> readPromos() {
    return FirebaseFirestore.instance.collection("book_promos").snapshots();
  }

  Stream<QuerySnapshot> readBanners() {
    return FirebaseFirestore.instance.collection("book_banners").snapshots();
  }


  // CATEGORIES
  Stream<QuerySnapshot> readCategories() {
    return FirebaseFirestore.instance
        .collection("book_categories")
        .orderBy("priority", descending: true)
        .snapshots();
  }


  // BOOKS
  // read books of specific categories
  Stream<QuerySnapshot> readBookItems(String category) {
    return FirebaseFirestore.instance
        .collection("book_items")
        .where("category", isEqualTo: category.toLowerCase())
        .snapshots();
  }
  
}