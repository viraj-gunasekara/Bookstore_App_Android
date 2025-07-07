import 'package:bookstore_admin_app/models/books_model.dart';
import 'package:bookstore_admin_app/providers/admin_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BooksPage extends StatefulWidget {
  const BooksPage({super.key});

  @override
  State<BooksPage> createState() => _BooksPageState();
}

class _BooksPageState extends State<BooksPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Books")),
      body: Consumer<AdminProvider>(
        builder: (context, value, child) {
          List<BooksModel> books =
              BooksModel.fromJsonList(value.books) as List<BooksModel>;

          if (books.isEmpty) {
            return Center(child: Text("No Books Found"));
          }

          return ListView.builder(
            itemCount: books.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(
                  books[index].name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: Text("Rs. ${books[index].new_price.toString()}"),
              );
            },
          );
        },
      ),

      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.pushNamed(context, "/add_book");
        },
      ),
    );
  }
}
