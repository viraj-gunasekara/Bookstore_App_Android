import 'package:bookstore_app/controlllers/db_service.dart';
import 'package:bookstore_app/models/promo_banners_model.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

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
          List<PromoBannersModel> promos =
              PromoBannersModel.fromJsonList(snapshot.data!.docs)
                  as List<PromoBannersModel>;

          if (promos.isEmpty) {
            return SizedBox();
          } else {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
              child: CarouselSlider(
                items: promos
                    .map((promo) => GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, "/specific",
                                arguments: {"name": promo.category});
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Stack(
                              children: [
                                Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16),
                                    image: DecorationImage(
                                      image: NetworkImage(promo.image),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: 5,
                                  right: 5,
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.5),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      promo.category.toUpperCase(),
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ))
                    .toList(),
                options: CarouselOptions(
                  autoPlay: true,
                  autoPlayInterval: Duration(seconds: 6),
                  aspectRatio: 16 / 8,
                  enlargeCenterPage: true,
                  viewportFraction: 0.98,
                ),
              ),
            );
          }
        } else {
          return Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.white,
            child: Container(
              height: 200,
              margin: EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          );
        }
      },
    );
  }
}
