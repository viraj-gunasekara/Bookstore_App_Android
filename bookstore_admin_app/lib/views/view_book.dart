import 'package:bookstore_admin_app/models/books_model.dart';
import 'package:flutter/material.dart';

class ViewBook extends StatefulWidget {
  const ViewBook({super.key});

  @override
  State<ViewBook> createState() => _ViewBookState();
}

class _ViewBookState extends State<ViewBook> {
  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context)!.settings.arguments as BooksModel;
    return Scaffold(
      appBar: AppBar(title: Text("User's View")),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.network(
              arguments.image,
              height: 300,
              width: double.infinity,
              fit: BoxFit.contain,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10),
                  Text(
                    arguments.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),

                  Row(
                    children: [
                      Text(
                        "Rs. ${arguments.old_price}",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey.shade700,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                      SizedBox(width: 10),
                      Text(
                        "Rs. ${arguments.new_price}",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      SizedBox(width: 10),
                      // discount
                      Icon(Icons.arrow_downward, color: Colors.green, size: 20),
                    ],
                  ),

                  SizedBox(height: 10),
                  arguments.maxQuantity == 0
                      ? Text(
                          "Out of Stock",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.red,
                          ),
                        )
                      : Text(
                          "Only ${arguments.maxQuantity} left in stock",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.green,
                          ),
                        ),
                  SizedBox(height: 10),
                  Text(
                    arguments.description,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey.shade700,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
