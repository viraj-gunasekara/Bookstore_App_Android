import 'package:bookstore_app/controlllers/db_service.dart';
import 'package:bookstore_app/models/categories_model.dart';
import 'package:bookstore_app/models/books_model.dart';
import 'package:bookstore_app/contents/discount.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'dart:math';

class HomeProductsSection extends StatefulWidget {
  const HomeProductsSection({super.key});

  @override
  State<HomeProductsSection> createState() => _HomeProductsSectionState();
}

class _HomeProductsSectionState extends State<HomeProductsSection> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: DbService().readCategories(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<CategoriesModel> categories = CategoriesModel.fromJsonList(snapshot.data!.docs);
          if (categories.isEmpty) return const SizedBox();

          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              return ProductsContainer(category: categories[index].name);
            },
          );
        } else {
          return Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.white,
            child: Container(height: 200, width: double.infinity),
          );
        }
      },
    );
  }
}

class ProductsContainer extends StatefulWidget {
  final String category;
  const ProductsContainer({super.key, required this.category});

  @override
  State<ProductsContainer> createState() => _ProductsContainerState();
}

class _ProductsContainerState extends State<ProductsContainer> {
  Widget specialQuote({required int price, required int dis}) {
    int random = Random().nextInt(2);
    List<String> quotes = ["From Rs.$price", "$dis% off"];
    return Text(
      quotes[random],
      style: const TextStyle(color: Colors.green, fontSize: 12),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: DbService().readBookItems(widget.category),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<BooksModel> books = BooksModel.fromJsonList(snapshot.data!.docs);
          if (books.isEmpty) return const SizedBox();

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Section header
                Row(
                  children: [
                    Text(
                      "${widget.category[0].toUpperCase()}${widget.category.substring(1)}",
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () {
                        Navigator.pushNamed(context, "/specific", arguments: {
                          "name": widget.category,
                        });
                      },
                      icon: const Icon(Icons.chevron_right),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                // Compact product cards
                SizedBox(
                  height: 120,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: books.length > 4 ? 4 : books.length,
                    itemBuilder: (context, i) {
                      final book = books[i];
                      return GestureDetector(
                        onTap: () => Navigator.pushNamed(context, "/view_book", arguments: book),
                        child: Container(
                          margin: const EdgeInsets.only(right: 12),
                          padding: const EdgeInsets.all(8),
                          width: 200,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 4,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  book.image,
                                  width: 65,
                                  height: 100,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(width: 8),
                              // Book info
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      book.name,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    specialQuote(
                                      price: book.new_price,
                                      dis: int.parse(discountPercent(book.old_price, book.new_price)),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                )
              ],
            ),
          );
        } else {
          return Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.white,
            child: Container(
              height: 120,
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          );
        }
      },
    );
  }
}