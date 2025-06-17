import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/service.dart';

class ApiCalls extends ChangeNotifier {
  String userId = '';
  String userName = '';
  String userEmail = '';

  userID() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');

    if (token != null) {
      Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
      userId = decodedToken['user_id'].toString();
      userName = decodedToken['username'].toString();
      userEmail = decodedToken['email'].toString();
    }

    notifyListeners();
  }

  //Provider ya kufetch Movies and season (Media)
  var movieData = [];
  fetchMovie() async {
    movieData = await getMovies();

    notifyListeners();
  }

  //Provider ya kufetch Reviews
  var reviews = [];
  fetchReview() async {
    reviews = await getreviews();

    notifyListeners();
  }

  //Provider ya kufetch WatchList
  var watchlist = [];
  fetchWatchlist() async {
    watchlist = await getwatchlist();

    notifyListeners();
  }

  //Provider ya kufetch WatchList
  var payment = [];
  fetchPayment() async {
    payment = await getpayment();

    notifyListeners();
  }

//Provider ya kufetch Carsole
  var carsole = [];
  fetchCarsole() async {
    carsole = await getcarsole();

    notifyListeners();
  }
  // //Provider ya kufetch 1 vs 1 chat message
  // var mesage = [];
  // fetchchat(sender, receiver) async {
  //   mesage = await getChats(sender, receiver);

  //   notifyListeners();
  // }

  // //Provider ya kufetch stories and articles
  // var articles = [];
  // fetcharticles() async {
  //   articles = await getnews();

  //   notifyListeners();
  // }

  // //Provider ya kuupdate number of views

  // fetchview(postId) async {
  //   await fetchvievs(postId);

  //   notifyListeners();
  // }
}
