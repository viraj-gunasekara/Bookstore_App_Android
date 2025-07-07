import 'package:bookstore_admin_app/containers/additional_confirm.dart';
import 'package:bookstore_admin_app/controlllers/db_service.dart';
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
      appBar: AppBar(title: Text("All Books")),
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
                onLongPress: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text("Choose what action to do"),
                      content: Text("Delete cannot be undone"),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            showDialog(
                              context: context,
                              builder: (context) => AdditionalConfirm(
                                contentText:
                                    "Are you sure you want to delete this book",
                                onYes: () {
                                  DbService().deleteBook(
                                    docId: books[index].id,
                                  );
                                  Navigator.pop(context);
                                },
                                onNo: () {
                                  Navigator.pop(context);
                                },
                              ),
                            );
                          },
                          child: Text("Delete Book"),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            Navigator.pushNamed(
                              context,
                              "/add_book",
                              arguments: books[index],
                            );
                          },
                          child: Text("Edit Book"),
                        ),
                      ],
                    ),
                  );
                },
                onTap: () => Navigator.pushNamed(
                  context,
                  "/view_book",
                  arguments: books[index],
                ),
                leading: Container(
                  height: 50,
                  width: 50,
                  child: Image.network(books[index].image),
                ),
                title: Text(
                  books[index].name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text("Rs. ${books[index].new_price.toString()}"),
                    Container(
                      padding: EdgeInsets.all(4),
                      color: Theme.of(context).primaryColor,
                      child: Text(
                        books[index].category.toUpperCase(),
                        style: TextStyle(color: Colors.white, fontSize: 10),
                      ),
                    ),
                  ],
                ),
                trailing: IconButton(
                  icon: Icon(Icons.edit_outlined),
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      "/add_book",
                      arguments: books[index],
                    );
                  },
                ),
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
