import 'package:bookstore_app/controlllers/db_service.dart';
import 'package:bookstore_app/models/promo_banners_model.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:carousel_slider/carousel_slider.dart';

class PromoContainer extends StatefulWidget {
  const PromoContainer({super.key});

  @override
  State<PromoContainer> createState() => _PromoContainerState();
}

class _PromoContainerState extends State<PromoContainer> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: DbService().readPromos(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<PromoBannersModel> promos = PromoBannersModel.fromJsonList(snapshot.data!.docs) as List<PromoBannersModel>;
          if (promos.isEmpty) {
            return SizedBox();
          } else {
            return CarouselSlider(
              items: promos.map((promo) => 
              Image.network(promo.image, fit: BoxFit.cover)).toList(),
              options: CarouselOptions(autoPlay: true, autoPlayInterval: const Duration(seconds: 15), aspectRatio: 16 / 8, viewportFraction: 1, enlargeCenterPage: true, scrollDirection: Axis.horizontal),
            );
          }
        } else {
          return Shimmer(
            child: Container(height: 300, width: double.infinity),
            gradient: LinearGradient(colors: [Colors.grey.shade200, Colors.white]),
          );
        }
      },
    );
  }
}
