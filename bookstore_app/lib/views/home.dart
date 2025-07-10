import 'package:bookstore_app/containers/category_container.dart';
import 'package:bookstore_app/containers/home_products_section.dart';
import 'package:bookstore_app/containers/promo_container.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
  appBar: AppBar(
    scrolledUnderElevation: 0,
    forceMaterialTransparency: true,
    title: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "BookShelf by Viraj",
          style: TextStyle(fontSize: 15, color: Colors.grey.shade800),
        ),
        SizedBox(height: 2),
        Text(
          "Best Books at Best Prices",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        ),
      ],
    ),
  ),
  body: SingleChildScrollView(
    child: Column(
      children: [
        PromoContainer(),
        CategoryContainer(),
        HomeProductsSection(),
      ],
    ),
  ),
);

  }
}
