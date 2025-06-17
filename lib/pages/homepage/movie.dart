import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:holy/pages/homepage/see_movie.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../../models/providers/connectivity.dart';
import '../../models/providers/token_provider.dart';
import '../play_details.dart';

class Movies extends StatefulWidget {
  const Movies({super.key});

  @override
  State<Movies> createState() => _MoviesState();
}

class _MoviesState extends State<Movies> {
  @override
  Widget build(BuildContext context) {
    var data = context.watch<ApiCalls>().movieData;
    final isOnline = context.watch<ConnectivityProvider>().isOnline;
    List movie =
        data.where((element) => element['content_type'] == 'movie').toList();
    final List popular = [...movie]..shuffle(Random());
    final List trending = [...movie]..shuffle(Random());
    final List recommend = [...movie]..shuffle(Random());
    final List news = [...movie]..shuffle(Random());
    return ListView(
      children: [
        movie.isEmpty
            ? SizedBox(
                height: MediaQuery.of(context).size.height * 0.6,
                child: const Center(
                  child: Text(
                    'No Movies',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              )
            : Container(),
        news.isEmpty
            ? Container()
            : Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Padding(
                    padding: EdgeInsets.only(
                      left: 20.0,
                      top: 20,
                    ),
                    child: Text(
                      'Recently Added Movies',
                      style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
        const SizedBox(
          height: 20,
        ),
        news.isEmpty
            ? Container()
            : SizedBox(
                height: 155,
                child: ListView.builder(
                  itemCount: news.length,
                  itemBuilder: (context, index) => GestureDetector(
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
                                    data: news[index],
                                  )),
                        );
                      }
                    },
                    child: CachedNetworkImage(
                        imageUrl: '${news[index]['thumbnail']}',
                        imageBuilder: (context, imageProvider) => Container(
                              margin: const EdgeInsets.only(
                                  left: 15, top: 10, bottom: 10),
                              width: MediaQuery.of(context).size.width * 0.6,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: imageProvider, fit: BoxFit.cover),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                        placeholder: (context, url) => Container(
                              height: 155,
                              decoration: BoxDecoration(
                                color: Colors.blueGrey.withOpacity(0.5),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              margin: const EdgeInsets.only(
                                  left: 15, top: 10, bottom: 10),
                              width: MediaQuery.of(context).size.width * 0.6,
                              child: Shimmer.fromColors(
                                baseColor: Colors.white.withOpacity(0.2),
                                highlightColor: Colors.white.withOpacity(0.8),
                                enabled: true,
                                child:
                                    const Icon(FontAwesomeIcons.film, size: 50),
                              ),
                            )),
                  ),
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                )),

        //******************* */

        popular.isEmpty
            ? Container()
            : Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(
                      left: 20.0,
                      top: 20,
                    ),
                    child: Text(
                      'Popular Movies',
                      style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const SeeMovie()),
                      );
                    },
                    child: const Padding(
                      padding: EdgeInsets.only(right: 20.0, top: 20),
                      child: Text(
                        'See all',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xffd12f26),
                        ),
                      ),
                    ),
                  ),
                  // Padding(
                  //   padding: const EdgeInsets.only(right: 10.0, top: 23),
                  //   child: Icon(
                  //     Icons.arrow_forward_ios,
                  //     size: 20,
                  //     color: Colors.white,
                  //   ),
                  // )
                ],
              ),
        const SizedBox(
          height: 20,
        ),
        popular.isEmpty
            ? Container()
            : SizedBox(
                height: 155,
                child: ListView.builder(
                  itemCount: popular.length,
                  itemBuilder: (context, index) => GestureDetector(
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
                                    data: popular[index],
                                  )),
                        );
                      }
                    },
                    child: CachedNetworkImage(
                        imageUrl: '${popular[index]['thumbnail']}',
                        imageBuilder: (context, imageProvider) => Container(
                              margin: const EdgeInsets.only(
                                  left: 15, top: 10, bottom: 10),
                              width: MediaQuery.of(context).size.width * 0.6,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: imageProvider, fit: BoxFit.cover),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                        placeholder: (context, url) => Container(
                              height: 155,
                              decoration: BoxDecoration(
                                color: Colors.blueGrey.withOpacity(0.5),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              margin: const EdgeInsets.only(
                                  left: 15, top: 10, bottom: 10),
                              width: MediaQuery.of(context).size.width * 0.6,
                              child: Shimmer.fromColors(
                                baseColor: Colors.white.withOpacity(0.2),
                                highlightColor: Colors.white.withOpacity(0.8),
                                enabled: true,
                                child:
                                    const Icon(FontAwesomeIcons.film, size: 50),
                              ),
                            )),
                  ),
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                )),

        //******************* */

        recommend.isEmpty
            ? Container()
            : Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Padding(
                    padding: EdgeInsets.only(
                      left: 20.0,
                      top: 20,
                    ),
                    child: Text(
                      'Recommended Movies',
                      style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
        const SizedBox(
          height: 20,
        ),
        recommend.isEmpty
            ? Container()
            : SizedBox(
                height: 155,
                child: ListView.builder(
                  itemCount: recommend.length,
                  itemBuilder: (context, index) => GestureDetector(
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
                                    data: recommend[index],
                                  )),
                        );
                      }
                    },
                    child: CachedNetworkImage(
                        imageUrl: '${recommend[index]['thumbnail']}',
                        imageBuilder: (context, imageProvider) => Container(
                              margin: const EdgeInsets.only(
                                  left: 15, top: 10, bottom: 10),
                              width: MediaQuery.of(context).size.width * 0.6,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: imageProvider, fit: BoxFit.cover),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                        placeholder: (context, url) => Container(
                              height: 155,
                              decoration: BoxDecoration(
                                color: Colors.blueGrey.withOpacity(0.5),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              margin: const EdgeInsets.only(
                                  left: 15, top: 10, bottom: 10),
                              width: MediaQuery.of(context).size.width * 0.6,
                              child: Shimmer.fromColors(
                                baseColor: Colors.white.withOpacity(0.2),
                                highlightColor: Colors.white.withOpacity(0.8),
                                enabled: true,
                                child:
                                    const Icon(FontAwesomeIcons.film, size: 50),
                              ),
                            )),
                  ),
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                )),

        //******************* */

        trending.isEmpty
            ? Container()
            : Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(
                      left: 20.0,
                      top: 20,
                    ),
                    child: Text(
                      'Treding Movies',
                      style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const SeeMovie()),
                      );
                    },
                    child: const Padding(
                      padding: EdgeInsets.only(right: 20.0, top: 20),
                      child: Text(
                        'See all',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xffd12f26),
                        ),
                      ),
                    ),
                  ),
                  // Padding(
                  //   padding: const EdgeInsets.only(right: 10.0, top: 23),
                  //   child: Icon(
                  //     Icons.arrow_forward_ios,
                  //     size: 20,
                  //     color: Colors.white,
                  //   ),
                  // )
                ],
              ),
        const SizedBox(
          height: 20,
        ),
        trending.isEmpty
            ? Container()
            : SizedBox(
                height: 155,
                child: ListView.builder(
                  itemCount: trending.length,
                  itemBuilder: (context, index) => GestureDetector(
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
                                    data: trending[index],
                                  )),
                        );
                      }
                    },
                    child: CachedNetworkImage(
                        imageUrl: '${trending[index]['thumbnail']}',
                        imageBuilder: (context, imageProvider) => Container(
                              margin: const EdgeInsets.only(
                                  left: 15, top: 10, bottom: 10),
                              width: MediaQuery.of(context).size.width * 0.6,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: imageProvider, fit: BoxFit.cover),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                        placeholder: (context, url) => Container(
                              height: 155,
                              decoration: BoxDecoration(
                                color: Colors.blueGrey.withOpacity(0.5),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              margin: const EdgeInsets.only(
                                  left: 15, top: 10, bottom: 10),
                              width: MediaQuery.of(context).size.width * 0.6,
                              child: Shimmer.fromColors(
                                baseColor: Colors.white.withOpacity(0.2),
                                highlightColor: Colors.white.withOpacity(0.8),
                                enabled: true,
                                child:
                                    const Icon(FontAwesomeIcons.film, size: 50),
                              ),
                            )),
                  ),
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                )),
      ],
    );
  }
}
