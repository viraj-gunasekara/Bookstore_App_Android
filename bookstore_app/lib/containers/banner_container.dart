import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class BannerContainer extends StatelessWidget {
  final List<String> images;
  final String category;

  const BannerContainer({
    super.key,
    required this.images,
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      items: images
          .map((image) => GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, "/specific", arguments: {
                    "name": category,
                  });
                },
                child: Image.network(
                  image,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              ))
          .toList(),
      options: CarouselOptions(
        autoPlay: true,
        autoPlayInterval: Duration(seconds: 10),
        aspectRatio: 16 / 8,
        viewportFraction: 1,
        enlargeCenterPage: true,
      ),
    );
  }
}
