import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:holy/pages/homepage/carsole.dart';
import 'package:holy/pages/homepage/see_all.dart';
import 'package:holy/pages/play_details.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../../models/providers/connectivity.dart';
import '../../models/providers/token_provider.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    var data = context.watch<ApiCalls>().movieData;
    final List popular = [...data]..shuffle(Random());
    final List global = [...data]..shuffle(Random());
    final List recommend = [...data]..shuffle(Random());
    final List news = [...data]..shuffle(Random());
    final List likes = [...data]..shuffle(Random());
    final isOnline = context.watch<ConnectivityProvider>().isOnline;
    return ListView(
      children: [
        CarsolePge(),

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
                      'Popular',
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
                        MaterialPageRoute(builder: (_) => const SeeAll()),
                      );
                    },
                    child: const Padding(
                      padding: EdgeInsets.only(right: 20.0, top: 20),
                      child: Text(
                        'See all',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xffFF3B30),
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

        global.isEmpty
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
                      'Global Treding',
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
                        MaterialPageRoute(builder: (_) => const SeeAll()),
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
        global.isEmpty
            ? Container()
            : SizedBox(
                height: 155,
                child: ListView.builder(
                  itemCount: global.length,
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
                                    data: global[index],
                                  )),
                        );
                      }
                    },
                    child: CachedNetworkImage(
                        imageUrl: '${global[index]['thumbnail']}',
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
                      'Recommended For You',
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

        news.isEmpty
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
                      'New Releases',
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
                        MaterialPageRoute(builder: (_) => const SeeAll()),
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
        likes.isEmpty
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
                      "Movies we think you'll like",
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
        likes.isEmpty
            ? Container()
            : SizedBox(
                height: 155,
                child: ListView.builder(
                  itemCount: likes.length,
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
                                    data: likes[index],
                                  )),
                        );
                      }
                    },
                    child: CachedNetworkImage(
                        imageUrl: '${likes[index]['thumbnail']}',
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
