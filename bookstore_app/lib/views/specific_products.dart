import 'package:bookstore_app/contents/discount.dart';
import 'package:bookstore_app/controlllers/db_service.dart';
import 'package:bookstore_app/models/books_model.dart';
import 'package:flutter/material.dart';

class SpecificProducts extends StatefulWidget {
  const SpecificProducts({super.key});

  @override
  State<SpecificProducts> createState() => _SpecificProductsState();
}

class _SpecificProductsState extends State<SpecificProducts> {
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    return Scaffold(
      appBar: AppBar(scrolledUnderElevation: 0, forceMaterialTransparency: true, title: Text("${args["name"].substring(0, 1).toUpperCase()}${args["name"].substring(1)} ")),
      body: StreamBuilder(
        stream: DbService().readBookItems(args["name"]),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<BooksModel> books = BooksModel.fromJsonList(snapshot.data!.docs) as List<BooksModel>;

            if (books.isEmpty) {
              return Center(child: Text("No books found."));
            } else {
              return GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // Number of items per row
                  crossAxisSpacing: 8.0, // Space between items horizontally
                  mainAxisSpacing: 8.0, // Space between items vertically
                ),
                itemCount: books.length,
                itemBuilder: (context, index) {
                  final book = books[index];
                  return GestureDetector(
                    onTap: (){
                      Navigator.pushNamed(context,"/view_book",arguments: book);
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
                                    image: DecorationImage(
                                        image: NetworkImage(book.image),
                                        fit: BoxFit.fitHeight)),
                              ),
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Text(
                              book.name,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(
                              height: 2,
                            ),
                            FittedBox(
                              // scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                   SizedBox(width: 2,),
                                                        Text("\Rs.${book.old_price}",style:  TextStyle(fontSize: 13,fontWeight: FontWeight.w500, decoration:  TextDecoration.lineThrough),),
                                                        SizedBox(width: 4,),
                                                        Text("\Rs.${book.new_price}",style:  TextStyle(fontSize: 15,fontWeight: FontWeight.w600),),
                                                        SizedBox(width: 2,),
                                                        Icon(Icons.arrow_downward,color: Colors.green, size: 14,),
                                        Text("${discountPercent(book.old_price,book.new_price)}%",style:  TextStyle(fontSize: 16,fontWeight: FontWeight.bold,color: Colors.green),),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            }
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
