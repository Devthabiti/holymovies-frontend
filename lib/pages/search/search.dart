import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shimmer/shimmer.dart';

import '../../models/providers/connectivity.dart';
import '../../models/providers/token_provider.dart';
import '../../models/services/utls.dart';
import '../play_details.dart';
import 'package:http/http.dart' as http;

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController s = TextEditingController();
  List movie = [];
  void searchArticles(String query) {
    var data = context.read<ApiCalls>().movieData;
    if (s.text.isNotEmpty) {
      final sug = data.where((article) {
        var tittle = article['title'].toLowerCase();

        var input = query.toLowerCase();
        return tittle.contains(input);
      }).toList();
      setState(() {
        movie = sug;
      });
    } else {
      setState(() {
        movie = [];
      });
    }
  }

  AppBar buildSearchField() {
    return AppBar(
      backgroundColor: const Color(0xff121212),
      automaticallyImplyLeading: false,
      elevation: 0,
      toolbarHeight: 100,
      centerTitle: true,
      title: TextFormField(
        controller: s,
        // autofocus: true,
        cursorColor: const Color(0xff262626).withOpacity(0.5),
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(15),
          border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(10)),
          filled: true,
          fillColor: Colors.white,
          hintText: "Search movies and series",
          hintStyle: TextStyle(color: const Color(0xff262626).withOpacity(0.5)),
          prefixIcon: Icon(
            Icons.search,
            color: const Color(0xff262626).withOpacity(0.5),
          ),
          suffixIcon: IconButton(
            icon: const Icon(Icons.clear),
            color: const Color(0xff262626).withOpacity(0.5),
            onPressed: () {
              // Navigator.pop(context);
              s.clear();
              setState(() {
                movie = [];
              });
            },
          ),
        ),
        onChanged: searchArticles,
      ),
    );
  }

  void createWatchlist(movieId) async {
    var url = Uri.parse('${Api.baseUrl}/create-watchlist/');
    var uid = context.read<ApiCalls>().userId;

    // Defined headers
    Map<String, String> headers = {
      //'Authorization': 'Basic bWF0aWt1OmJpcGFzMTIzNA==',
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    // Defined request body
    var body = {
      "user": uid,
      "movie": movieId,
    };

    // POST request
    var response = await http.post(
      url,
      headers: headers,
      body: json.encode(body),
      //encoding: Encoding.getByName('utf-8'),
    );

    // Check the status code of the response
    if (response.statusCode == 201) {
      final data = context.read<ApiCalls>();
      data.fetchWatchlist();
      Navigator.pop(context);
      Navigator.pop(context);
    } else {
      Navigator.pop(context);
      Navigator.pop(context);
    }
  }

  void deleteWatchlist(movieId) async {
    var url = Uri.parse('${Api.baseUrl}/remove-watchlist/');
    var uid = context.read<ApiCalls>().userId;

    // Defined headers
    Map<String, String> headers = {
      //'Authorization': 'Basic bWF0aWt1OmJpcGFzMTIzNA==',
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    // Defined request body
    var body = {
      "user": uid,
      "movie": movieId,
    };

    // POST request
    var response = await http.post(
      url,
      headers: headers,
      body: json.encode(body),
      //encoding: Encoding.getByName('utf-8'),
    );

    // Check the status code of the response
    if (response.statusCode == 204) {
      final data = context.read<ApiCalls>();
      data.fetchWatchlist();
      Navigator.pop(context);
      Navigator.pop(context);
    } else {
      Navigator.pop(context);
      Navigator.pop(context);
    }
  }

  //share logic
  void shareMovie({
    required String title,
    required String description,
    required String link,
  }) {
    final message = '''
🎬 $title

$description

Watch it now on our app 👇
$link
''';

    Share.share(message, subject: title);
  }

  Future<String?> showSeasonPickerBottomSheet(
      BuildContext context, data, online) async {
    List watch = context.read<ApiCalls>().watchlist;
    var x = context.read<ApiCalls>().userId;
    var movie = watch
        .where((element) =>
            element['user'] == int.parse(x) && element['movie'] == data['id'])
        .toList();
    return showModalBottomSheet<String>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      isScrollControlled: true,
      builder: (context) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.3,
          minChildSize: 0.2,
          maxChildSize: 0.7,
          builder: (_, controller) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 15, top: 10),
                    child: Row(
                      children: [
                        Text(
                          "${data['title']} - ",
                          style: const TextStyle(
                              color: Color(0xff121212),
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                        data['content_type'] == 'movie'
                            ? const Text(
                                'Movie',
                                style: TextStyle(
                                    color: Color(0xff121212),
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              )
                            : const Text(
                                'Seasons',
                                style: TextStyle(
                                    color: Color(0xff121212),
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      if (!online) {
                        Navigator.pop(context);
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
                        showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (context) {
                              return AlertDialog(
                                title: Center(
                                  child: Lottie.asset(
                                    'assets/loading.json',
                                    width: 40,
                                    height: 40,
                                  ),
                                ),
                                elevation: 0,
                                backgroundColor: Colors.transparent,
                                // shape: RoundedRectangleBorder(
                                //     borderRadius: BorderRadius.circular(20)),
                              );
                            });
                        movie.isEmpty
                            ? createWatchlist(data['id'])
                            : deleteWatchlist(data['id']);
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left: 15, top: 15),
                      child: movie.isEmpty
                          ? Row(
                              children: const [
                                Icon(Icons.add,
                                    size: 25,
                                    color:
                                        Color(0xff121212) //Color(0xffFF3B30),
                                    ),
                                SizedBox(width: 5),
                                Text(
                                  "Watchlist",
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: Color(0xff121212),
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            )
                          : Row(
                              children: const [
                                Icon(Icons.check,
                                    size: 25, color: Color(0xff121212)),
                                SizedBox(width: 5),
                                Text(
                                  "Watchlist",
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: Color(0xff121212),
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Platform.isAndroid
                          ? shareMovie(
                              title: data['title'],
                              description: data['description'],
                              link: Api.androidLink,
                            )
                          : shareMovie(
                              title: data['title'],
                              description: data['description'],
                              link: Api.iosLink,
                            );
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left: 15, top: 20),
                      child: Row(
                        children: const [
                          Icon(Icons.share_outlined,
                              size: 22, color: Color(0xff121212)),
                          SizedBox(width: 8),
                          Text(
                            "Share",
                            style: TextStyle(
                                fontSize: 12,
                                color: Color(0xff121212),
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      if (!online) {
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
                                    data: data,
                                  )),
                        );
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left: 15, top: 20),
                      child: Row(
                        children: const [
                          Icon(Icons.info_outline,
                              size: 25, color: Color(0xff121212)),
                          SizedBox(width: 5),
                          Text(
                            "View  Details",
                            style: TextStyle(
                                fontSize: 12,
                                color: Color(0xff121212),
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

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

  @override
  Widget build(BuildContext context) {
    final isOnline = context.watch<ConnectivityProvider>().isOnline;
    return Scaffold(
        backgroundColor: const Color(0xff121212),
        appBar: buildSearchField(),
        body: movie.isEmpty
            ? Shimmer.fromColors(
                baseColor: Colors.white.withOpacity(0.2),
                highlightColor: Colors.white.withOpacity(0.6),
                enabled: true,
                child: Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: 20,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) => ListTile(
                          leading: Container(
                            width: 170.0,
                            height: 80.0,
                            color: Colors.white,
                          ),
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 80.0,
                                height: 20.0,
                                color: Colors.white,
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Container(
                                width: 50.0,
                                height: 12.0,
                                color: Colors.white,
                              ),
                              const SizedBox(
                                height: 25,
                              ),
                            ],
                          ),
                          subtitle: Container(
                            width: 10.0,
                            height: 8.0,
                            color: Colors.white,
                          ),
                          trailing: const Icon(
                            FontAwesomeIcons.ellipsisVertical,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                  ],
                ))
            : ListView.builder(
                itemCount: movie.length,
                itemBuilder: (context, index) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GestureDetector(
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
                                            data: movie[index],
                                          )),
                                );
                              }
                            },
                            child: CachedNetworkImage(
                              imageUrl: '${movie[index]['thumbnail']}',
                              imageBuilder: (context, imageProvider) =>
                                  Container(
                                margin: const EdgeInsets.only(
                                    left: 15, top: 10, bottom: 10),
                                width: MediaQuery.of(context).size.width * 0.4,
                                height: 90,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: imageProvider, fit: BoxFit.cover),
                                ),
                              ),
                              placeholder: (context, url) => Container(
                                margin: const EdgeInsets.only(
                                    left: 15, top: 10, bottom: 10),
                                width: MediaQuery.of(context).size.width * 0.4,
                                height: 90,
                                color: Colors.white,
                                child: const Center(
                                    child: Icon(
                                  FontAwesomeIcons.video,
                                  size: 50,
                                  color: Colors.red,
                                )),
                              ),
                            ),
                          ),
                          GestureDetector(
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
                                            data: movie[index],
                                          )),
                                );
                              }
                            },
                            child: Column(
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
                                      movie[index]['title'],
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
                                  child: movie[index]['duration'] == null
                                      ? Text(
                                          formatDate(
                                              movie[index]['release_year']),
                                          style: const TextStyle(
                                            color: Color(0xffB3B3B3),
                                            fontSize: 12.0,
                                          ),
                                        )
                                      : Text(
                                          formatDuration(
                                              movie[index]['duration']),
                                          style: const TextStyle(
                                            color: Color(0xffB3B3B3),
                                            fontSize: 12.0,
                                          ),
                                        ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 15, top: 5, bottom: 10),
                                  child: movie[index]['content_type'] == 'movie'
                                      ? const Text(
                                          'Movie',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 12.0,
                                          ),
                                        )
                                      : const Text(
                                          'Seasons',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 12.0,
                                          ),
                                        ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () {
                          showSeasonPickerBottomSheet(
                              context, movie[index], isOnline);
                        },
                        child: Container(
                          color: const Color(0xff121212),
                          padding: const EdgeInsets.only(right: 10, bottom: 20),
                          child: const Icon(
                            FontAwesomeIcons.ellipsisVertical,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ));
  }
}
