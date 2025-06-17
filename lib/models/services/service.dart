import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import './utls.dart';

//fetching list of movies
getMovies() async {
  var url = Uri.parse('${Api.baseUrl}/show-media/');
  // Defined headers
  Map<String, String> headers = {
    //'Authorization': ' Bearer $token',
    'Content-Type': 'application/json; charset=utf-8',
    'Accept': 'application/json',
  };
  try {
    // Get request
    var response = await http.get(
      url,
      headers: headers,
    );
    // Check the status code of the response
    if (response.statusCode == 200) {
      // var iyoo = json.decode(response.body);
      var iyoo = json.decode(utf8.decode(response.bodyBytes));

      return iyoo;
    } else {
      return [];
    }
  } on SocketException catch (_) {
    return []; // or return an error indicator
  } catch (e) {
    return [];
  }
}

//fetching reviews
getreviews() async {
  try {
    var response = await http.get(
      Uri.parse('${Api.baseUrl}/show-reviews/'),
    );
    if (response.statusCode == 200) {
      List iyoo = json.decode(utf8.decode(response.bodyBytes));

      return iyoo;
    } else {
      return [];
    }
  } on SocketException catch (_) {
    return []; // or return an error indicator
  } catch (e) {
    return [];
  }
}

getwatchlist() async {
  try {
    var response = await http.get(
      Uri.parse('${Api.baseUrl}/show-watchlist/'),
    );
    if (response.statusCode == 200) {
      List iyoo = json.decode(utf8.decode(response.bodyBytes));

      return iyoo;
    } else {
      return [];
    }
  } on SocketException catch (_) {
    return []; // or return an error indicator
  } catch (e) {
    return [];
  }
}

getpayment() async {
  try {
    var response = await http.get(
      Uri.parse('${Api.baseUrl}/show-payment/'),
    );
    if (response.statusCode == 200) {
      List iyoo = json.decode(utf8.decode(response.bodyBytes));

      return iyoo;
    } else {
      return [];
    }
  } on SocketException catch (_) {
    return []; // or return an error indicator
  } catch (e) {
    return [];
  }
}

getcarsole() async {
  try {
    var response = await http.get(
      Uri.parse('${Api.baseUrl}/show-carsole/'),
    );
    if (response.statusCode == 200) {
      List iyoo = json.decode(utf8.decode(response.bodyBytes));

      return iyoo;
    } else {
      return [];
    }
  } on SocketException catch (_) {
    return []; // or return an error indicator
  } catch (e) {
    return [];
  }
}


// //fetching articles and story
// getstory() async {
//   var response = await http.get(
//     Uri.parse('${Api.baseUrl}/story-time/'),
//   );
//   if (response.statusCode == 200) {
//     Map data = json.decode(utf8.decode(response.bodyBytes));
//     List iyoo = data['results'];
//     return iyoo;
//   } else {
//     return null;
//   }
// }

// //fetching Most 10 articles with views
// getmostviews() async {
//   var response = await http.get(
//     Uri.parse('${Api.baseUrl}/most-viewed/'),
//   );
//   if (response.statusCode == 200) {
//     List iyoo = json.decode(utf8.decode(response.bodyBytes));
//     return iyoo;
//   } else {
//     return null;
//   }
// }

// //fetching Most liked articles with random concept
// getrandom() async {
//   var response = await http.get(
//     Uri.parse('${Api.baseUrl}/random-article/'),
//   );
//   if (response.statusCode == 200) {
//     List iyoo = json.decode(utf8.decode(response.bodyBytes));
//     return iyoo;
//   } else {
//     return null;
//   }
// }

// //fetching Most liked articles
// getmostliked() async {
//   var response = await http.get(
//     Uri.parse('${Api.baseUrl}/most-liked/'),
//   );
//   if (response.statusCode == 200) {
//     List iyoo = json.decode(utf8.decode(response.bodyBytes));
//     return iyoo;
//   } else {
//     return null;
//   }
// }

// //fetching Hot articles
// gethotarticle() async {
//   var response = await http.get(
//     Uri.parse('${Api.baseUrl}/hot-article/'),
//   );
//   if (response.statusCode == 200) {
//     List iyoo = json.decode(utf8.decode(response.bodyBytes));
//     return iyoo;
//   } else {
//     return null;
//   }
// }

// //fetching majonjwa
// getmagonjwa() async {
//   var response = await http.get(
//     Uri.parse('${Api.baseUrl}/show-magonjwa/'),
//   );
//   if (response.statusCode == 200) {
//     List iyoo = json.decode(utf8.decode(response.bodyBytes));
//     return iyoo;
//   } else {
//     return null;
//   }
// }

// //fetching food & fruits
// getfood() async {
//   var response = await http.get(
//     Uri.parse('${Api.baseUrl}/food-fruit/'),
//   );
//   if (response.statusCode == 200) {
//     List iyoo = json.decode(utf8.decode(response.bodyBytes));
//     return iyoo;
//   } else {
//     return null;
//   }
// }

// //fetching articles and story
// gettransaction() async {
//   var response = await http.get(
//     Uri.parse('${Api.baseUrl}/show-transaction/'),
//   );
//   if (response.statusCode == 200) {
//     List iyoo = json.decode(response.body);
//     return iyoo;
//   } else {
//     return null;
//   }
// }

// //fetching 1 vs 1 chat
// fetchvievs(postId) async {
//   var response = await http
//       .post(Uri.parse('${Api.baseUrl}/views/'), body: {"post_id": postId});
//   if (response.statusCode == 200) {
//     var iyoo = json.decode(response.body);
//     return iyoo;
//   } else {
//     return null;
//   }
// }

// //fetching all ads
// getads() async {
//   var response = await http.get(
//     Uri.parse('${Api.baseUrl}/ads/'),
//   );
//   if (response.statusCode == 200) {
//     List iyoo = json.decode(response.body);

//     return iyoo;
//   } else {
//     return null;
//   }
// }

// //fetching all phamacy iamges
// getphamacy() async {
//   var response = await http.get(
//     Uri.parse('${Api.baseUrl}/phamacy/'),
//   );
//   if (response.statusCode == 200) {
//     List iyoo = json.decode(response.body);

//     return iyoo;
//   } else {
//     return null;
//   }
// }
