import 'dart:convert';
import 'dart:typed_data';
import 'package:better_player/better_player.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:holy/pages/play/payment_modal_episode.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:lottie/lottie.dart';
import 'package:http/http.dart' as http;

import '../../models/providers/token_provider.dart';
import '../../models/services/utls.dart';
import '../play.dart';

class EpisodeTile extends StatefulWidget {
  final Map episode;
  final Map userData;
  final Map series;

  const EpisodeTile({
    super.key,
    required this.episode,
    required this.userData,
    required this.series,
  });

  @override
  State<EpisodeTile> createState() => _EpisodeTileState();
}

class _EpisodeTileState extends State<EpisodeTile> {
  Uint8List? _thumbnail;

  @override
  void initState() {
    super.initState();
    _generateThumbnail();
  }

  Future<void> _generateThumbnail() async {
    final thumb = await VideoThumbnail.thumbnailData(
      video: widget.episode['video_url'],
      imageFormat: ImageFormat.JPEG,
      maxWidth: 320,
      timeMs: 3000,
      quality: 75,
    );
    if (mounted) {
      setState(() {
        _thumbnail = thumb;
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
        showSafePaymentBottomSheet(context);
      }
    } else {
      Navigator.pop(context);
    }
  }

// check for user payments

  bool paid = false;
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
                      title: widget.series['title'],
                      videoUrl: widget.episode['video_url'],
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
      showSafePaymentBottomSheet(context);
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
                    title: widget.series['title'],
                    videoUrl: widget.episode['video_url'],
                  )));
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

//format date
  String formatDate(String rawDate) {
    DateTime parsed = DateTime.parse(rawDate);
    return DateFormat('MMM d y').format(parsed);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text(
                  'Episode ${widget.episode['episode_number']}',
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text(
                  widget.episode['title'],
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
              ),
              ListTile(
                leading: _thumbnail != null
                    ? GestureDetector(
                        onTap: () async {
                          isEpisodePaid(widget.episode['id']);
                        },
                        child: Container(
                          width: 100,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: MemoryImage(_thumbnail!),
                              fit: BoxFit.cover,
                            ),
                          ),
                          child: Center(
                            child: Lottie.asset(
                              'assets/play.json',
                              height: 50,
                            ),
                          ),
                        ),
                      )
                    : GestureDetector(
                        onTap: () async {
                          isEpisodePaid(widget.episode['id']);
                        },
                        child: CachedNetworkImage(
                          imageUrl: '${widget.series['thumbnail']}',
                          imageBuilder: (context, imageProvider) => Container(
                            width: 100,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: imageProvider, fit: BoxFit.cover),
                            ),
                            child: Center(
                              child: Lottie.asset(
                                'assets/play.json',
                                height: 50,
                              ),
                            ),
                          ),
                          placeholder: (context, url) => Container(
                            decoration: const BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage('assets/m1.jpg'))),
                          ),
                        )),
                title: Row(
                  children: [
                    Text(
                      // '${widget.episode['title']} | 01h : 50min',
                      formatDate(widget.episode['created_at']),

                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xffB3B3B3),
                      ),
                    ),
                    Text(
                      ' | ',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      formatDuration(widget.episode['duration']),
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xffB3B3B3),
                      ),
                    ),
                  ],
                ),
                subtitle: Padding(
                  padding: EdgeInsets.only(top: 5),
                  child: Text(
                    widget.episode['description'],
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              )
            ],
          ),
        ),
        const Divider(
          color: Color(0xffB3B3B3),
          indent: 10,
          endIndent: 20,
        ),
      ],
    );
  }

  void showSafePaymentBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => PaymentBottomSheetEpisode(
        movie: widget.series,
        episode: widget.episode,
        userdata: widget.userData,
      ),
    );
  }
}
