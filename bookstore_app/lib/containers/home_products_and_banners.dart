import 'package:bookstore_app/containers/banner_container.dart';
import 'package:bookstore_app/containers/home_products_container.dart';
import 'package:bookstore_app/controlllers/db_service.dart';
import 'package:bookstore_app/models/categories_model.dart';
import 'package:bookstore_app/models/promo_banners_model.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class HomeProductsAndBanners extends StatefulWidget {
  const HomeProductsAndBanners({super.key});

  @override
  State<HomeProductsAndBanners> createState() => _HomeProductsAndBannersState();
}

class _HomeProductsAndBannersState extends State<HomeProductsAndBanners> {
  int min = 0;

  minCalculator(int a, int b) {
    return min = a > b ? b : a;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: DbService().readCategories(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<CategoriesModel> categories = CategoriesModel.fromJsonList(snapshot.data!.docs) as List<CategoriesModel>;
          if (categories.isEmpty) {
            return SizedBox();
          } else {
            return StreamBuilder(
              stream: DbService().readBanners(),
              builder: (context, bannerSnapshot) {
                if (bannerSnapshot.hasData) {
                  List<PromoBannersModel> banners = PromoBannersModel.fromJsonList(snapshot.data!.docs) as List<PromoBannersModel>;
                  if (banners.isEmpty) {
                    return SizedBox();
                  } else {
                    return Column(
                      children: [
                        for (int i = 0; i < minCalculator(snapshot.data!.docs.length, bannerSnapshot.data!.docs.length); i++)
                          Column(
                            children: [
                              HomeProductsContainer(category: snapshot.data!.docs[i]["name"]),
                              // BannerContainer(image: bannerSnapshot.data!.docs[i]["image"], category: bannerSnapshot.data!.docs[i]["category"]),
                            ],
                          ),
                      ],
                    );
                  }
                } else {
                  return SizedBox();
                }
              },
            );
          }
        } else {
          return Shimmer(
            child: Container(height: 400, width: double.infinity),
            gradient: LinearGradient(colors: [Colors.grey.shade200, Colors.white]),
          );
        }
      },
    );
  }
}
