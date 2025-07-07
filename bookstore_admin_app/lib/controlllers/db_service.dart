import 'package:cloud_firestore/cloud_firestore.dart';

class DbService {
  // CATEGORIES
  // read categories from database
  Stream<QuerySnapshot> readCategories() {
    return FirebaseFirestore.instance
        .collection("book_categories")
        .orderBy("priority", descending: true)
        .snapshots();
  }

  // create new category
  Future createCategories({required Map<String, dynamic> data}) async {
    await FirebaseFirestore.instance.collection("book_categories").add(data);
  }

  // update category
  Future updateCategories({
    required String docId,
    required Map<String, dynamic> data,
  }) async {
    await FirebaseFirestore.instance
        .collection("book_categories")
        .doc(docId)
        .update(data);
  }

  // delete category
  Future deleteCategories({required String docId}) async {
    await FirebaseFirestore.instance
        .collection("book_categories")
        .doc(docId)
        .delete();
  }

  //BOOKS
  // read book items from database
  Stream<QuerySnapshot> readBooks() {
    return FirebaseFirestore.instance
        .collection("book_items")
        .orderBy("category", descending: true)
        .snapshots();
  }

  // create a new book item
  Future createBook({required Map<String, dynamic> data}) async {
    await FirebaseFirestore.instance.collection("book_items").add(data);
  }

  // update a book item
  Future updateBook({
    required String docId,
    required Map<String, dynamic> data,
  }) async {
    await FirebaseFirestore.instance
        .collection("book_items")
        .doc(docId)
        .update(data);
  }

  // delete a book item
  Future deleteBook({required String docId}) async {
    await FirebaseFirestore.instance
        .collection("book_items")
        .doc(docId)
        .delete();
  }
}
