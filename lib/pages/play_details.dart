import 'dart:convert';
import 'dart:io';

import 'package:better_player/better_player.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:holy/errors/network_error.dart';
import 'package:holy/pages/favorate/add_watchlist.dart';
import 'package:holy/pages/payment_modal.dart';
import 'package:holy/pages/play.dart';
import 'package:holy/pages/play/episode_tile.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:http/http.dart' as http;

import '../models/providers/connectivity.dart';
import '../models/providers/token_provider.dart';
import '../models/services/utls.dart';

class PlayDetails extends StatefulWidget {
  final Map data;
  const PlayDetails({super.key, required this.data});

  @override
  State<PlayDetails> createState() => _PlayDetailsState();
}

class _PlayDetailsState extends State<PlayDetails> with WidgetsBindingObserver {
  BetterPlayerController? _betterPlayerController;

  loadVideo() {
    final String? videoUrl = widget.data['trailer_url'];

    if (videoUrl != null && videoUrl.isNotEmpty) {
      BetterPlayerDataSource dataSource = BetterPlayerDataSource(
          BetterPlayerDataSourceType.network, videoUrl,
          notificationConfiguration:
              const BetterPlayerNotificationConfiguration(
            showNotification: false,
          ));

      _betterPlayerController = BetterPlayerController(
        const BetterPlayerConfiguration(
          autoPlay: true,
          looping: false,
          aspectRatio: 16 / 9,
          fit: BoxFit.contain,
          autoDetectFullscreenDeviceOrientation: true,
          deviceOrientationsAfterFullScreen: [DeviceOrientation.portraitUp],
          handleLifecycle: false,
          allowedScreenSleep: false,
          fullScreenByDefault: false,
          controlsConfiguration: BetterPlayerControlsConfiguration(
            enableSubtitles: true,
            enablePlaybackSpeed: true,
            enablePip: true,
            enableFullscreen: false,
            enableOverflowMenu: false,
            progressBarPlayedColor: Color(0xffFF3B30),
            enableMute: true,
            playerTheme: BetterPlayerTheme.material,
          ),
        ),
        betterPlayerDataSource: dataSource,
      );
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    episodeInit();
    loadVideo();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      _betterPlayerController?.pause();
    }
  }

  @override
  void dispose() {
    _betterPlayerController?.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  TextEditingController phone = TextEditingController();

  final formKey = GlobalKey<FormState>();

  void submit() async {
    final form = formKey.currentState;

    if (form!.validate()) {
      showDialogy();
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

  // Api for creating reviews **************************
  TextEditingController comment = TextEditingController();
  void postComments() async {
    var url = Uri.parse('${Api.baseUrl}/create-reviews/');
    var uid = context.read<ApiCalls>().userId;

    // Defined headers
    Map<String, String> headers = {
      //'Authorization': 'Basic bWF0aWt1OmJpcGFzMTIzNA==',
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    // Defined request body
    var body = {
      "user_id": uid,
      "movie": widget.data['id'],
      "comment": comment.text
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
      data.fetchReview();
      comment.clear();
      Navigator.pop(context);
    }
  }

//create thumbnails
  Uint8List? thumbnail;
  Future<void> generateVideoThumbnail(String url) async {
    final Uint8List? bytes = await VideoThumbnail.thumbnailData(
      video: url,
      imageFormat: ImageFormat.JPEG,
      maxWidth: 128,
      timeMs: 10000,
      quality: 75,
    );

    if (mounted) {
      thumbnail = bytes;
      // setState(() {
      //   _thumbnail = bytes;
      // });
    }
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

  Future showSeasonPickerBottomSheet(
      BuildContext context, List seasons, String selectedSeason) async {
    return showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      isScrollControlled: true,
      builder: (context) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.4,
          minChildSize: 0.2,
          maxChildSize: 0.7,
          builder: (_, controller) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[400],
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    "Select Season",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: ListView.builder(
                      controller: controller,
                      itemCount: seasons.length,
                      itemBuilder: (context, index) {
                        final season = seasons[index];

                        return ListTile(
                          title: Text('Season ${season['season_number']}'),
                          trailing: selectedSeason ==
                                  season['season_number'].toString()
                              ? const Icon(Icons.check, color: Colors.green)
                              : null,
                          onTap: () {
                            setState(() {
                              episodes = season['episodes'];
                            });
                            Navigator.pop(
                                context, season['season_number'].toString());
                          },
                        );
                      },
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

  String selectedSeason = "1";
  List episodes = [];

  //call initi episode
  episodeInit() {
    if (widget.data['seasons'].isNotEmpty) {
      List series = widget.data['seasons'];
      var data = series
          .where((element) => element['season_number'] == 1)
          .toList()
          .first;
      episodes = data['episodes'];
    }
  }

  void _pickSeason(List seasons) async {
    final result =
        await showSeasonPickerBottomSheet(context, seasons, selectedSeason);
    if (result != null && result != selectedSeason) {
      setState(() {
        selectedSeason = result;
        // Load episodes for this season
      });
    }
  }

//check payments status
  void fetchStatus(orderId) async {
    var url = Uri.parse('https://api.zeno.africa/order-status');

    // Defined request body
    var statusData = {
      'check_status': '905676',
      'order_id': orderId,
      'api_key': 'df25c136cc849e98ec46516ea5f6fed5',
      'secret_key':
          '29f6cc74c960079172bb2ed16fb61cdf5e86fb98a3bb2ed16fb61cdf5e86fb98a31658e79'
    };

    // POST request
    var response = await http.post(
      url,
      body: statusData,
    );

    // Check the status code of the response
    if (response.statusCode == 200) {
      var iyoo = json.decode(response.body);
      if (iyoo['payment_status'] == 'COMPLETED') {
        // send data to my backend
        updatePayment(orderId);
      } else {
        //show pop up
        Navigator.pop(context);
        showSafePaymentBottomSheet(context, widget.data);
      }
      // print(iyoo);
    } else {
      Navigator.pop(context);
    }
  }

//update payment data
  void updatePayment(order) async {
    var url = Uri.parse('${Api.baseUrl}/update-payment/');

    // Defined headers
    Map<String, String> headers = {
      //'Authorization': 'Basic bWF0aWt1OmJpcGFzMTIzNA==',
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    // Defined request body
    var body = {
      'transaction_id': order,
    };

    // POST request
    var response = await http.patch(
      url,
      headers: headers,
      body: json.encode(body),
    );

    // Check the status code of the response
    if (response.statusCode == 200) {
      final data = context.read<ApiCalls>();
      data.fetchPayment();
      Navigator.pop(context);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => MoviePlayerPage(
                    title: widget.data['title'],
                    videoUrl: widget.data['seasons'].isEmpty
                        ? widget.data['video_url']
                        : widget.data['seasons'][0]['episodes'][0]['video_url'],
                  )));
    }
  }
  //hapa sasa atalipia au ataend kungalia movie

  // if (paid) {
  //   await Future.delayed(const Duration(milliseconds: 200));

  // } else { 6830968c2df5f

  // }
// check for user payments
  bool paid = false;
  isMoviePaid(int movieId) {
    List payment = context.read<ApiCalls>().payment;
    var x = context.read<ApiCalls>().userId;
    List userTrans =
        payment.where((element) => element['user'] == int.parse(x)).toList();
    var lipa = userTrans.any((item) => item['movie'] == movieId);
    if (lipa) {
      Map da = userTrans.firstWhere((element) => element['movie'] == movieId);
      if (da['status'] == true) {
        // paid = da['status'];
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => MoviePlayerPage(
                    title: widget.data['title'],
                    videoUrl: widget.data['video_url'])));
      } else {
        //small doading
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
        //then ni update payment
        fetchStatus(da['transaction_id']);
        // kisha ni sate paid == true
      }
    } else {
      showSafePaymentBottomSheet(context, widget.data);
    }
  }

  isEpisodePaid(int episodeId) {
    List payment = context.read<ApiCalls>().payment;
    var x = context.read<ApiCalls>().userId;
    List userTrans =
        payment.where((element) => element['user'] == int.parse(x)).toList();
    var lipa = userTrans.any((item) => item['episode'] == episodeId);
    if (lipa) {
      Map da =
          userTrans.firstWhere((element) => element['episode'] == episodeId);
      if (da['status'] == true) {
        // paid = da['status'];
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => MoviePlayerPage(
                      title: widget.data['title'],
                      videoUrl: widget.data['seasons'][0]['episodes'][0]
                          ['video_url'],
                    )));
      } else {
        //small doading
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
        //then ni update payment
        fetchStatus(da['transaction_id']);
        // kisha ni sate paid == true
      }
    } else {
      showSafePaymentBottomSheet(context, widget.data);
    }
  }

  void showReviewBottomSheet(BuildContext context, reviews) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // enables full height
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.7,
          minChildSize: 0.4,
          maxChildSize: 0.95,
          builder: (_, controller) {
            return Padding(
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                top: 16,
                bottom: MediaQuery.of(context).viewInsets.bottom + 16,
              ),
              child: Column(
                children: [
                  Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: Colors.grey[400],
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const Text("User Reviews",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  reviews.isEmpty
                      ? const Expanded(
                          child: Center(
                            child: Text(
                              'No Review for this movie',
                              style: TextStyle(
                                fontSize: 13,
                                color: Color(0xff121212),
                              ),
                            ),
                          ),
                        )
                      : Expanded(
                          child: ListView.builder(
                            controller: controller,
                            itemCount: reviews.length,
                            itemBuilder: (_, index) => ListTile(
                              leading: const CircleAvatar(
                                  backgroundColor: Color(0xffFF3B30),
                                  child: Icon(
                                    Iconsax.profile_circle,
                                    color: Colors.white,
                                  )),
                              title: Text(
                                reviews[index]['user']['username'],
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: Color(0xff121212),
                                ),
                              ),
                              subtitle: Text(
                                reviews[index]['comment'],
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: Color(0xff121212),
                                ),
                              ),
                            ),
                          ),
                        ),
                  const Divider(),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: comment,
                          decoration: InputDecoration(
                            hintText: "Write a review...",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                              12,
                            )),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: Color(0xff121212),
                                width: 2.0,
                              ),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 10),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      CircleAvatar(
                        backgroundColor: const Color(0xff121212),
                        child: IconButton(
                          onPressed: comment.text.isEmpty
                              ? null
                              : () {
                                  // Handle submit
                                  postComments();
                                },
                          icon: const Icon(Icons.send, color: Colors.white),
                        ),
                      )
                    ],
                  ),
                  Container(
                    height: 20,
                  )
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isOnline = context.watch<ConnectivityProvider>().isOnline;
    // Parse the date string
    DateTime date = DateTime.parse(
      widget.data['release_year'],
    );
    String year = DateFormat('yyyy').format(date);

    var data = context.watch<ApiCalls>().reviews;

    var review =
        data.where((element) => element['movie'] == widget.data['id']).toList();

    return !isOnline
        ? const NetworkErrorScreen()
        : Scaffold(
            backgroundColor: const Color(0xff121212),
            appBar: AppBar(
              backgroundColor: const Color(0xff121212),
            ),
            body: Column(
              children: [
                widget.data['trailer_url'] == null
                    ? AspectRatio(
                        aspectRatio: 16 / 9,
                        child: CachedNetworkImage(
                          imageUrl: '${widget.data['thumbnail']}',
                          imageBuilder: (context, imageProvider) => Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: imageProvider, fit: BoxFit.cover),
                            ),
                          ),
                          placeholder: (context, url) => AspectRatio(
                            aspectRatio: 16 / 9,
                            child: Container(
                              color: Colors.blueGrey.withOpacity(0.5),
                              child: const Center(
                                  child: Icon(
                                FontAwesomeIcons.video,
                                size: 50,
                                color: Colors.white,
                              )),
                            ),
                          ),
                        ))
                    : AspectRatio(
                        aspectRatio: 16 / 9,
                        child:
                            BetterPlayer(controller: _betterPlayerController!),
                      ),
                Expanded(
                    child: ListView(
                        // shrinkWrap: true,
                        children: [
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Text(
                          widget.data['title'],
                          style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Text(
                              year,
                              style: const TextStyle(
                                  color: Color(0xffB3B3B3), fontSize: 12),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(left: 10, right: 10),
                            padding: const EdgeInsets.symmetric(
                                vertical: 2, horizontal: 4),
                            decoration: BoxDecoration(
                                color: const Color(0xffFF3B30),
                                borderRadius: BorderRadius.circular(5)),
                            child: Text(
                              ' ${widget.data['age_rating']}+',
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 12),
                            ),
                          ),
                          widget.data['seasons'].isEmpty
                              ? Text(
                                  formatDuration(widget.data['duration']),
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 14),
                                )
                              : Text(
                                  '${widget.data['seasons'].length} Seasons',
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 14),
                                ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () async {
                          _betterPlayerController?.pause();
                          //hapa natakiwa ni check kwanza kama kalipia au vp?
                          widget.data['seasons'].isEmpty
                              ? isMoviePaid(widget.data['id'])
                              : isEpisodePaid(widget.data['seasons'][0]
                                  ['episodes'][0]['id']);
                        },
                        child: Container(
                          width: double.infinity,
                          height: 45,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10)),
                          margin: const EdgeInsets.all(15),
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Lottie.asset(
                                  'assets/play.json',
                                  height: 40,
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  widget.data['seasons'].isEmpty
                                      ? 'Watch Full Movie'
                                      : 'Watch Episode 1',
                                  style: const TextStyle(
                                      color: Colors.black, fontSize: 14),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          AddWatchList(movieId: widget.data['id']),
                          GestureDetector(
                            onTap: () {
                              showReviewBottomSheet(context, review);
                            },
                            child: Column(
                              children: const [
                                Icon(
                                  //Icons.edit_note,
                                  Icons.comment_outlined,
                                  size: 25,
                                  color: Colors.white, // Color(0xffFF3B30),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(3.0),
                                  child: Text(
                                    'Reviews',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Platform.isAndroid
                                  ? shareMovie(
                                      title: widget.data['title'],
                                      description: widget.data['description'],
                                      link: Api.androidLink,
                                    )
                                  : shareMovie(
                                      title: widget.data['title'],
                                      description: widget.data['description'],
                                      link: Api.iosLink,
                                    );
                            },
                            child: Column(
                              children: const [
                                Icon(
                                  Icons.share_outlined,
                                  size: 25,
                                  color: Colors.white, // Color(0xffFF3B30),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(3.0),
                                  child: Text(
                                    'share',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          widget.data['description'],
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      widget.data['seasons'].isEmpty
                          ? Container()
                          : GestureDetector(
                              onTap: widget.data['seasons'].length > 1
                                  ? () {
                                      _pickSeason(widget.data['seasons']);
                                    }
                                  : null,
                              child: Container(
                                height: 45,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10)),
                                margin: const EdgeInsets.all(15),
                                child: Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Season $selectedSeason',
                                        style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      widget.data['seasons'].length > 1
                                          ? const Icon(
                                              Icons.arrow_drop_down_outlined,
                                              size: 30,
                                              color: Color(0xffFF3B30),
                                            )
                                          : Container()
                                    ],
                                  ),
                                ),
                              ),
                            ),
                      const SizedBox(
                        height: 20,
                      ),
                      widget.data['seasons'].isEmpty
                          ? Container()
                          : ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: episodes.length,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () {
                                    _betterPlayerController?.pause();
                                  },
                                  child: EpisodeTile(
                                    episode: episodes[index],
                                    series: widget.data,
                                    userData: const {},
                                  ),
                                );
                              })
                    ])),
              ],
            ),
          );
  }

  showDialogy() {
    return showDialog(
        // barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            scrollable: true,
            title: const Text(
              'Payment Confimations',
              style: TextStyle(
                  fontFamily: 'Manane',
                  color: Color(0xff262626),
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
            content: Column(
              children: [
                Text(
                    style: TextStyle(
                      fontFamily: 'Manane',
                      color: const Color(0xff262626).withOpacity(0.6),
                    ),
                    '1. You will receive a prompt from your  mobile money enter your PIN to approve the amount to be deducted.\n\n2. Please Enter your mobile money PIN'),
                const SizedBox(
                  height: 15,
                ),
                Container(
                  margin: const EdgeInsets.all(15),
                  height: 50,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: const LinearGradient(
                      colors: [Color(0xff0071e7), Color(0xff262626)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      stops: [0.0, 1.0],
                      tileMode: TileMode.clamp, // This is the default
                    ),
                  ),
                  child: Center(
                      child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(1.0),
                        child: Lottie.asset(
                          'assets/loading.json',
                          width: 50,
                          height: 50,
                        ),
                      ),
                      const Text(
                        'Awaiting confirmation',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  )),
                ),
              ],
            ),

            elevation: 10.0,

            // backgroundColor: Colors.amber,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          );
        });
  }

  failMoadal() {
    return showDialog(
        // barrierDismissible: false,
        context: context,
        builder: ((context) => Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(7)),
              child: Container(
                padding: const EdgeInsets.all(40),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: Text(
                        'Something went Wrong',
                        style: TextStyle(
                          color: Color(0xff262626),
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 1),
                      child: Lottie.asset(
                        'assets/loading.json',
                        width: 100,
                        height: 100,
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 1),
                      child: Text(
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Manane',
                            color: Color(0xff262626),
                            fontSize: 12,
                          ),
                          "Oops! Payment was not completed. \nPlease try again later "),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                            width: 120,
                            height: 35,
                            margin: const EdgeInsets.only(bottom: 20),
                            decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xff0071e7),
                                    Color(0xff262626)
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  stops: [0.0, 1.0],
                                  tileMode:
                                      TileMode.clamp, // This is the default
                                ),
                                borderRadius: BorderRadius.circular(5)),
                            child: const Center(
                                child: Text(
                              'Close',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                              ),
                            ))),
                      ),
                    ),
                  ],
                ),
              ),
            )));
  }

  void showSafePaymentBottomSheet(BuildContext context, data) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => PaymentBottomSheet(movie: data),
    );
  }
}
