import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../models/providers/token_provider.dart';
import '../play.dart';

class PaidMovies extends StatefulWidget {
  const PaidMovies({super.key});

  @override
  State<PaidMovies> createState() => _PaidMoviesState();
}

class _PaidMoviesState extends State<PaidMovies> {
  //format date
  String formatDate(String rawDate) {
    DateTime parsed = DateTime.parse(rawDate);
    return DateFormat('MMM d y').format(parsed);
  }

  //format duration
  String formatDuration(String input) {
    final parts = input.split(':');
    int hours = int.parse(parts[0]);
    int minutes = int.parse(parts[1]);

    if (hours > 0 && minutes > 0) {
      return '${hours}h ${minutes}m';
    } else if (hours > 0) {
      return '${hours}h';
    } else {
      return '${minutes}m';
    }
  }

  String formatAmount(double amount) {
    // This handles comma formatting: 1000 → 1,000.0 or 1000000 → 1,000,000.0
    final formatted = NumberFormat('#,##0.0', 'en_US').format(amount);
    return 'TZS $formatted';
  }

  @override
  Widget build(BuildContext context) {
    List payment = context.watch<ApiCalls>().payment;
    var x = context.watch<ApiCalls>().userId;
    List userTrans = payment
        .where((element) =>
            element['user'] == int.parse(x) && element['status'] == true)
        .toList();

    // Convert string amounts to double and sum them
    double totalAmount = userTrans.fold(0.0, (sum, item) {
      return sum + double.parse(item['amount']);
    });
    return Scaffold(
      backgroundColor: const Color(0xff121212),
      appBar: AppBar(
        // elevation: 0,
        backgroundColor: const Color(0xff121212),
      ),
      body: SafeArea(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 15.0,
          ),
          SizedBox(
            height: 135,
            child: ListView(
              // physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              children: [
                Container(
                    margin: const EdgeInsets.only(left: 5),
                    //padding: EdgeInsets.all(10),
                    //height: 30,
                    width: 300,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(7),
                        color: const Color(0xffFF3B30)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(top: 30, left: 25),
                          child: Text(
                            'Total Amount Spent',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10, left: 25),
                          child: Text(
                            formatAmount(totalAmount),
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    )),
                const SizedBox(
                  width: 15.0,
                ),
                Container(
                    margin: const EdgeInsets.only(left: 5),
                    //padding: EdgeInsets.all(10),
                    //height: 30,
                    width: 300,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(7),
                        color: Colors.white),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(top: 30, left: 25),
                          child: Text(
                            'Total Movies Paid',
                            style: TextStyle(
                              color: Color(0xff121212),
                              fontSize: 12,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10, left: 25),
                          child: Text(
                            userTrans.length.toString(),
                            style: const TextStyle(
                                color: Color(0xff121212),
                                fontSize: 22,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    )),
                const SizedBox(
                  width: 15.0,
                ),
              ],
            ),
          ), //after inside Listview
          const SizedBox(
            height: 25,
          ),
          userTrans.isEmpty
              ? Container()
              : const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: Text(
                    'MOVIES & SEASONS HISTORY',
                    style: TextStyle(
                      fontFamily: 'Heebo',
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
          userTrans.isEmpty
              ? SizedBox(
                  height: MediaQuery.of(context).size.height * 0.5,
                  child: const Center(
                    child: Text(
                      'No paid movie yet',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                )
              : Expanded(
                  child: ListView.builder(
                    // shrinkWrap: true,
                    // physics: NeverScrollableScrollPhysics(),
                    itemCount: userTrans.length,
                    itemBuilder: (context, index) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  String url = userTrans[index]['full_movie']
                                              ['content_type'] ==
                                          'movie'
                                      ? userTrans[index]['full_movie']
                                          ['video_url']
                                      : userTrans[index]['full_episode']
                                          ['video_url'];
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => MoviePlayerPage(
                                              videoUrl: url,
                                              title: userTrans[index]
                                                  ['full_movie']['title'],
                                            )),
                                  );
                                },
                                child: CachedNetworkImage(
                                  imageUrl:
                                      '${userTrans[index]['full_movie']['thumbnail']}',
                                  imageBuilder: (context, imageProvider) =>
                                      Container(
                                    margin: const EdgeInsets.only(
                                        left: 15, top: 10, bottom: 10),
                                    width:
                                        MediaQuery.of(context).size.width * 0.4,
                                    height: 90,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image: imageProvider,
                                          fit: BoxFit.cover),
                                    ),
                                  ),
                                  placeholder: (context, url) => Container(
                                    margin: const EdgeInsets.only(
                                        left: 15, top: 10, bottom: 10),
                                    width:
                                        MediaQuery.of(context).size.width * 0.4,
                                    height: 90,
                                    color: Colors.blueGrey,
                                    child: Container(
                                      color: const Color(0xffFF3B30)
                                          .withOpacity(0.6),
                                      child: const Center(
                                          child: Icon(FontAwesomeIcons.film,
                                              size: 50, color: Colors.white)),
                                    ),
                                  ),
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                //mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: 170,
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                        left: 15,
                                        top: 15,
                                      ),
                                      child: Text(
                                        userTrans[index]['full_movie']['title'],
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16.0,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 15, top: 5, bottom: 10),
                                    child: userTrans[index]['full_movie']
                                                ['duration'] ==
                                            null
                                        ? Text(
                                            formatDuration(userTrans[index]
                                                ['full_episode']['duration']),
                                            style: const TextStyle(
                                              color: Color(0xffB3B3B3),
                                              fontSize: 12.0,
                                            ),
                                          )
                                        : Text(
                                            formatDuration(userTrans[index]
                                                ['full_movie']['duration']),
                                            style: const TextStyle(
                                              color: Color(0xffB3B3B3),
                                              fontSize: 12.0,
                                            ),
                                          ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 15, top: 5, bottom: 10),
                                    child: userTrans[index]['full_movie']
                                                ['content_type'] ==
                                            'movie'
                                        ? const Text(
                                            'Movie',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12.0,
                                            ),
                                          )
                                        : Row(
                                            children: [
                                              const Text(
                                                'Episode ',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 12.0,
                                                ),
                                              ),
                                              Text(
                                                userTrans[index]['full_episode']
                                                        ['episode_number']
                                                    .toString(),
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 12.0,
                                                ),
                                              ),
                                            ],
                                          ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      );
                    },
                  ),
                )
        ],
      )),
    );
  }
}
