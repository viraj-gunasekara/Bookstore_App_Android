import 'dart:math';

import 'package:bookstore_app/contents/discount.dart';
import 'package:bookstore_app/controlllers/db_service.dart';
import 'package:bookstore_app/models/books_model.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class HomeProductsContainer extends StatefulWidget {
  final String category;
  const HomeProductsContainer({super.key, required this.category});

  @override
  State<HomeProductsContainer> createState() => _HomeProductsContainerState();
}

class _HomeProductsContainerState extends State<HomeProductsContainer> {
  Widget specialQuote({required int price, required int dis}) {
    int random = Random().nextInt(2);

    List<String> quotes = ["Starting at Rs.$price", "Get upto $dis% off"];

    return Text(quotes[random], style: TextStyle(color: Colors.green));
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: DbService().readBookItems(widget.category),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<BooksModel> books = BooksModel.fromJsonList(snapshot.data!.docs) as List<BooksModel>;

          if (books.isEmpty) {
            return Center(child: Text("No Books Found"));
          } else {
            return Container(
              margin: EdgeInsets.all(4),
              padding: EdgeInsets.symmetric(horizontal: 10),
              color: Colors.green.shade50,

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    child: Row(
                      children: [
                        Text("${widget.category.substring(0, 1).toUpperCase() + widget.category.substring(1)}", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
                        Spacer(),
                        IconButton(
                          onPressed: () {
                            Navigator.pushNamed(context, "/specific", arguments: {"name": widget.category});
                          },
                          icon: Icon(Icons.chevron_right),
                        ),
                      ],
                    ),
                  ),
                  // show max 2 books
                  Wrap(
                    spacing: 4,
                    children: [
                      for (int i = 0; i < (books.length > 2 ? 2 : books.length); i++)
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, "/view_book", arguments: books[i]);
                          },
                          child: Container(
                            width: MediaQuery.sizeOf(context).width * .43,
                            padding: EdgeInsets.all(8),

                            color: Colors.white,
                            height: 180,
                            margin: const EdgeInsets.all(5),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Center(child: Image.network(books[i].image, height: 120)),
                                Text(
                                  books[i].name,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                                ),
                                specialQuote(price: books[i].new_price, dis: int.parse(discountPercent(books[i].old_price, books[i].new_price))),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            );
          }
        } else {
          return Shimmer(
            child: Container(height: 400, width: double.infinity, color: Colors.white),
            gradient: LinearGradient(colors: [Colors.grey.shade200, Colors.white]),
          );
        }
      },
    );
  }
}
