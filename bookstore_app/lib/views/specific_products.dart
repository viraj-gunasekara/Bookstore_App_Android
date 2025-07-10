import 'package:bookstore_app/contents/discount.dart';
import 'package:bookstore_app/controlllers/db_service.dart';
import 'package:bookstore_app/models/books_model.dart';
import 'package:bookstore_app/models/promo_banners_model.dart';
import 'package:bookstore_app/containers/banner_container.dart';
import 'package:flutter/material.dart';

class SpecificProducts extends StatefulWidget {
  const SpecificProducts({super.key});

  @override
  State<SpecificProducts> createState() => _SpecificProductsState();
}

class _SpecificProductsState extends State<SpecificProducts> {
  String category = "";

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    category = args["name"].toLowerCase();

    return Scaffold(
      appBar: AppBar(scrolledUnderElevation: 0, forceMaterialTransparency: true, title: Text("${category[0].toUpperCase()}${category.substring(1)}")),
      body: StreamBuilder(
        stream: DbService().readBanners(),
        builder: (context, bannerSnapshot) {
          List<PromoBannersModel> banners = [];
          if (bannerSnapshot.hasData) {
            banners = bannerSnapshot.data!.docs.map((doc) => PromoBannersModel.fromJson(doc.data() as Map<String, dynamic>, doc.id)).where((banner) => banner.category.toLowerCase() == category).toList();
          }

          return StreamBuilder(
            stream: DbService().readBookItems(category),
            builder: (context, bookSnapshot) {
              if (bookSnapshot.hasData) {
                List<BooksModel> books = BooksModel.fromJsonList(bookSnapshot.data!.docs) as List<BooksModel>;

                if (books.isEmpty) {
                  return Center(child: Text("No books found."));
                } else {
                  return ListView(
                    padding: EdgeInsets.all(8),
                    children: [
                      // ✅ Conditionally show banner at the top
                      if (banners.isNotEmpty) BannerContainer(images: banners.map((b) => b.image).toList(), category: banners.first.category),

                      // ✅ Wrap GridView in Sliver-like widget (shrinkWrap + physics fix scroll)
                      GridView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(), // Let ListView handle scroll
                        itemCount: books.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 8, mainAxisSpacing: 8),
                        itemBuilder: (context, index) {
                          final book = books[index];
                          return GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, "/view_book", arguments: book);
                            },
                            child: Card(
                              color: Colors.grey.shade50,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(8),
                                          image: DecorationImage(image: NetworkImage(book.image), fit: BoxFit.fitHeight),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    Text(book.name, maxLines: 2, overflow: TextOverflow.ellipsis),
                                    SizedBox(height: 2),
                                    FittedBox(
                                      child: Row(
                                        children: [
                                          SizedBox(width: 2),
                                          Text(
                                            "\Rs.${book.old_price}",
                                            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, decoration: TextDecoration.lineThrough),
                                          ),
                                          SizedBox(width: 4),
                                          Text("\Rs.${book.new_price}", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                                          SizedBox(width: 2),
                                          Icon(Icons.arrow_downward, color: Colors.green, size: 14),
                                          Text(
                                            "${discountPercent(book.old_price, book.new_price)}%",
                                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.green),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  );
                }
              } else {
                return Center(child: CircularProgressIndicator());
              }
            },
          );
        },
      ),
    );
  }
}
