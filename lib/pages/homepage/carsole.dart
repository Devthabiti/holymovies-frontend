import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../models/providers/connectivity.dart';
import '../../models/providers/token_provider.dart';
import '../play_details.dart';

class CarsolePge extends StatefulWidget {
  CarsolePge({Key? key}) : super(key: key);

  @override
  State<CarsolePge> createState() => _CarsolePgeState();
}

class _CarsolePgeState extends State<CarsolePge> {
  int activeIndex = 0;
  @override
  Widget build(BuildContext context) {
    var movie = context.watch<ApiCalls>().carsole;
    final isOnline = context.watch<ConnectivityProvider>().isOnline;

    final List<Widget> imageSliders = movie
        .map((item) => GestureDetector(
              onTap: () {
                if (!isOnline) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Center(
                          child: Text(
                        'No internet connection',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      )),
                      backgroundColor: Colors.white,
                      duration: Duration(seconds: 3),
                    ),
                  );
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => PlayDetails(
                              data: item,
                            )),
                  );
                }
              },
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 5.0),
                child: CachedNetworkImage(
                    imageUrl: item['thumbnail'],
                    imageBuilder: (context, imageProvider) => Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(2),
                            image: DecorationImage(
                                image: imageProvider, fit: BoxFit.cover))),
                    placeholder: (context, url) => AspectRatio(
                          aspectRatio: 16 / 9,
                          child: Center(
                            child: Lottie.asset(
                              'assets/loading.json',
                              width: 40,
                              height: 40,
                            ),
                          ),
                        )),
              ),
            ))
        .toList();
    return Column(
      children: [
        CarouselSlider(
          options: CarouselOptions(
            aspectRatio: 16 / 9,
            viewportFraction: 1.0,
            enlargeCenterPage: true,
            enableInfiniteScroll: true,
            enlargeStrategy: CenterPageEnlargeStrategy.zoom,
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 7),
            onPageChanged: (index, reason) {
              setState(() {
                activeIndex = index;
              });
            },
          ),
          items: imageSliders,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedSmoothIndicator(
              activeIndex: activeIndex,
              count: 3,
              effect: const ExpandingDotsEffect(
                expansionFactor: 2,
                dotWidth: 6,
                dotHeight: 6,
                spacing: 5,
                dotColor: Color(0xffB3B3B3),
                activeDotColor: Colors.white,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
