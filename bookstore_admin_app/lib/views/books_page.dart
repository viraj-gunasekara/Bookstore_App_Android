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
      appBar: AppBar(title: const Text("📘 All Books")),
      body: Consumer<AdminProvider>(
        builder: (context, provider, child) {
          List<BooksModel> books = BooksModel.fromJsonList(provider.books);

          if (books.isEmpty) {
            return const Center(
              child: Text("📭 No Books Found"),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: books.length,
            itemBuilder: (context, index) {
              final book = books[index];

              return GestureDetector(
                onTap: () => Navigator.pushNamed(
                  context,
                  "/view_book",
                  arguments: book,
                ),
                onLongPress: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text("Choose Action"),
                      content: const Text("Delete cannot be undone."),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            showDialog(
                              context: context,
                              builder: (context) => AdditionalConfirm(
                                contentText: "Are you sure you want to delete this book?",
                                onYes: () {
                                  DbService().deleteBook(docId: book.id);
                                  Navigator.pop(context);
                                },
                                onNo: () {
                                  Navigator.pop(context);
                                },
                              ),
                            );
                          },
                          child: const Text("🗑 Delete"),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            Navigator.pushNamed(
                              context,
                              "/add_book",
                              arguments: book,
                            );
                          },
                          child: const Text("✏️ Edit"),
                        ),
                      ],
                    ),
                  );
                },
                child: Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.08),
                        blurRadius: 6,
                        spreadRadius: 1,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      // 📷 Book image
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          book.image,
                          height: 70,
                          width: 55,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Container(
                            height: 70,
                            width: 55,
                            color: Colors.grey.shade300,
                            child: const Icon(Icons.broken_image),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),

                      // 📖 Book details
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              book.name,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                Text(
                                  "Rs. ${book.new_price}",
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.green,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).primaryColor,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    book.category.toUpperCase(),
                                    style: const TextStyle(fontSize: 10, color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      // ✏️ Edit Icon
                      IconButton(
                        icon: const Icon(Icons.edit_outlined),
                        onPressed: () {
                          Navigator.pushNamed(
                            context,
                            "/add_book",
                            arguments: book,
                          );
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),

      // ➕ Floating button to add book
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.pushNamed(context, "/add_book"),
        label: const Text("Add Book"),
        icon: const Icon(Icons.add),
      ),
    );
  }
}
