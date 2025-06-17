import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../../models/providers/token_provider.dart';
import '../../models/services/utls.dart';
import 'package:http/http.dart' as http;

class AddWatchList extends StatefulWidget {
  final int movieId;

  const AddWatchList({super.key, required this.movieId});

  @override
  State<AddWatchList> createState() => _AddWatchListState();
}

class _AddWatchListState extends State<AddWatchList> {
  void createWatchlist() async {
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
      "movie": widget.movieId,
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
    }
  }

  void deleteWatchlist() async {
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
      "movie": widget.movieId,
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
    } else {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    List watch = context.watch<ApiCalls>().watchlist;
    var x = context.watch<ApiCalls>().userId;
    var data = watch
        .where((element) =>
            element['user'] == int.parse(x) &&
            element['movie'] == widget.movieId)
        .toList();

    return GestureDetector(
        onTap: () {
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
          data.isEmpty ? createWatchlist() : deleteWatchlist();
        },
        child: data.isEmpty
            ? Column(
                children: const [
                  Icon(
                    Icons.add,
                    size: 25,
                    color: Colors.white, // Color(0xffFF3B30),
                  ),
                  Padding(
                    padding: EdgeInsets.all(3.0),
                    child: Text(
                      'Watchlist',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              )
            : Column(
                children: const [
                  Icon(
                    Icons.check,
                    size: 25,
                    color: Color(0xffFF3B30),
                  ),
                  Padding(
                    padding: EdgeInsets.all(3.0),
                    child: Text(
                      'Watchlist',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ));
  }
}
