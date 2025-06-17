import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:holy/pages/play.dart';
import 'package:lottie/lottie.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/providers/token_provider.dart';
import '../models/services/utls.dart';

class PaymentBottomSheet extends StatefulWidget {
  final Map movie;
  const PaymentBottomSheet({Key? key, required this.movie}) : super(key: key);

  @override
  State<PaymentBottomSheet> createState() => _PaymentBottomSheetState();
}

class _PaymentBottomSheetState extends State<PaymentBottomSheet>
    with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> formKey1 = GlobalKey<FormState>();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController phone = TextEditingController();
  TextEditingController phoneCard = TextEditingController();

  Widget showphone() {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
        child: TextFormField(
            controller: phone,
            validator: (val) =>
                val!.length < 10 ? 'Complete Phone Number' : null,
            style: const TextStyle(
              fontSize: 15,
              color: Color(0xff262626),
            ),
            keyboardType: TextInputType.phone,
            maxLength: 10,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(
                vertical: 12.0,
                horizontal: 10.0,
              ),
              border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(10)),
              filled: true,
              hintText: "Phone Number / Namba ya simu",
              hintStyle: TextStyle(
                fontSize: 15,
                color: const Color(0xff262626).withOpacity(0.25),
              ),
            )));
  }

  Widget showphoneCard() {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
        child: TextFormField(
            controller: phoneCard,
            validator: (val) =>
                val!.length < 10 ? 'Complete Phone Number' : null,
            style: const TextStyle(
              fontSize: 15,
              color: Color(0xff262626),
            ),
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(
                vertical: 12.0,
                horizontal: 10.0,
              ),
              border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(10)),
              filled: true,
              hintText: "Phone Number",
              hintStyle: TextStyle(
                fontSize: 15,
                color: const Color(0xff262626).withOpacity(0.25),
              ),
            )));
  }

  late Timer _timer;
  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 30), (timer) {});
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

//card payment
  void urlfetch(link) async {
    final Uri url = Uri.parse(link);
    if (await canLaunchUrl(url)) {
      await launchUrl(
        url,
        mode: LaunchMode.inAppWebView,
        webViewConfiguration: const WebViewConfiguration(
            headers: <String, String>{'my_header_key': 'my_header_value'}),
      );
    } else {
      throw 'error $url';
    }
  }

  void postPayCard() async {
    var url = Uri.parse('${Api.baseUrl}/show-pay-card/');
    var uid = context.read<ApiCalls>().userId;
    var username = context.read<ApiCalls>().userName;
    var emial = context.read<ApiCalls>().userEmail;
    final data = context.read<ApiCalls>();

    // Defined headers
    Map<String, String> headers = {
      //'Authorization': 'Basic bWF0aWt1OmJpcGFzMTIzNA==',
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    // Defined request body
    var body = {
      'user': uid,
      'movie': widget.movie['id'].toString(),
      'episode': widget.movie['seasons'].isEmpty
          ? 'null'
          : widget.movie['seasons'][0]['episodes'][0]['id'].toString(),
      'buyer_email': emial,
      'buyer_phone': phoneCard.text,
      'buyer_name': username,
      'amount': widget.movie['seasons'].isEmpty
          ? widget.movie['price']
          : widget.movie['seasons'][0]['episodes'][0]['price'],
    };

    // POST request
    var response = await http.post(
      url,
      headers: headers,
      body: json.encode(body),
      //encoding: Encoding.getByName('utf-8'),
    );

    // Check the status code of the response
    if (response.statusCode == 200) {
      var iyoo = json.decode(response.body);

      urlfetch(iyoo['payment_link']);
      //calling transaction model
      data.fetchPayment();

      _timer = Timer.periodic(const Duration(seconds: 30), (timer) {
        fetchStatus(
          iyoo['order_id'],
        );
      });
    } else {
      Navigator.pop(context);
      failMoadal();
    }
  }

  postPayMobile() async {
    var url = Uri.parse('${Api.baseUrl}/show-pay-mobile/');
    var uid = context.read<ApiCalls>().userId;
    var username = context.read<ApiCalls>().userName;
    var emial = context.read<ApiCalls>().userEmail;
    final data = context.read<ApiCalls>();

    // Defined request body
    var body = {
      'user': uid,
      'movie': widget.movie['id'].toString(),
      'episode': widget.movie['seasons'].isEmpty
          ? 'null'
          : widget.movie['seasons'][0]['episodes'][0]['id'].toString(),
      'buyer_email': emial,
      'buyer_name': username,
      'buyer_phone': phone.text,
      'amount': widget.movie['seasons'].isEmpty
          ? widget.movie['price']
          : widget.movie['seasons'][0]['episodes'][0]['price'],
    };

    // POST request
    var response = await http.post(
      url,
      body: body,
    );

    // Check the status code of the response
    if (response.statusCode == 200) {
      var iyoo = json.decode(response.body);
      //calling transaction model
      data.fetchPayment();

      _timer = Timer.periodic(const Duration(seconds: 10), (timer) {
        fetchStatus(
          iyoo['order_id'],
        );
      });
    } else {
      Navigator.pop(context);
      failMoadal();
    }
  }

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
      }
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
      _timer.cancel();
      Navigator.pop(context);
      Navigator.pop(context);
      //then nagivate kwenye play movies
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => MoviePlayerPage(
                    title: widget.movie['title'],
                    videoUrl: widget.movie['seasons'].isEmpty
                        ? widget.movie['video_url']
                        : widget.movie['seasons'][0]['episodes'][0]
                            ['video_url'],
                  )));
    }
  }

  void submit() async {
    final form = formKey1.currentState;

    if (form!.validate()) {
      showDialogy();

      postPayMobile();
    }
  }

  void validates() async {
    final form = formKey.currentState;

    if (form!.validate()) {
      //remove bottomsheat
      Navigator.pop(context);
      Navigator.pop(context);

      // //open card modal
      cardMoadal();
      // //redirect to payments
      postPayCard();
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: AnimatedPadding(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
        padding: EdgeInsets.only(bottom: bottomInset),
        child: DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.6,
          maxChildSize: 0.9,
          minChildSize: 0.4,
          builder: (context, scrollController) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                    "Make payment to access this content",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: Color(0xff121212),
                    ),
                  ),
                  Expanded(
                    child: ListView(
                      controller: scrollController,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(left: 20.0, top: 15),
                          child: Text(
                            "To watch this content, please make a one-time payment to access and enjoy the full experience.",
                            style: TextStyle(
                              color: Color(0xffB3B3B3),
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.all(15),
                          width: double.infinity,
                          //height: 200,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(7),
                          ),
                          child: Form(
                            key: formKey1,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Padding(
                                  padding: EdgeInsets.only(left: 20.0, top: 15),
                                  child: Text(
                                    'Payment Number',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xff121212),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 5.0,
                                ),
                                showphone(),
                                const SizedBox(
                                  height: 10.0,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text(
                                      'Or use ',
                                      style: TextStyle(
                                        color: Color(0xff121212),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        //open dialogy to fill the number
                                        payModal();
                                      },
                                      child: const Text(
                                        'Card',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                          color: Color(0xffFF3B30),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Center(
                                  child: GestureDetector(
                                    onTap: submit,
                                    child: Container(
                                      height: 45,
                                      width: 200,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(7),
                                        color: const Color(
                                            0xff121212), //Color(0xffFF3B30),
                                      ),
                                      child: Center(
                                        child: widget.movie['seasons'].isEmpty
                                            ? Text(
                                                'Pay TZS ${double.parse(widget.movie['price']).toStringAsFixed(0)}/=',
                                                style: const TextStyle(
                                                    // fontFamily: 'Manane',
                                                    color: Colors.white,
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              )
                                            : Text(
                                                'Pay TZS  ${double.parse(widget.movie['seasons'][0]['episodes'][0]['price']).toStringAsFixed(0)}/=',
                                                style: const TextStyle(
                                                    // fontFamily: 'Manane',
                                                    color: Colors.white,
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 10.0,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  showDialogy() {
    return showDialog(
        barrierDismissible: false,
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
                      padding: EdgeInsets.only(top: 10, bottom: 10),
                      child: Text(
                        'Payment Confimations',
                        style: TextStyle(
                          color: Color(0xff121212),
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 1),
                      child: Text(
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xffB3B3B3),
                            fontSize: 12,
                          ),
                          "A payment prompt will be sent to your phone. Enter your PIN to complete the transaction."),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Lottie.asset(
                        'assets/loading.json',
                        width: 50,
                        height: 50,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      "Don't leave this screen",
                      style: TextStyle(color: Color(0xffB3B3B3), fontSize: 10),
                    ),
                  ],
                ),
              ),
            )));
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
                          color: Color(0xff121212),
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Lottie.asset(
                        'assets/loading.json',
                        width: 50,
                        height: 50,
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 1),
                      child: Text(
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xffB3B3B3),
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
                                color: const Color(0xff121212),
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

  cardMoadal() {
    return showDialog(
        barrierDismissible: false,
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
                      padding: EdgeInsets.only(top: 10, bottom: 10),
                      child: Text(
                        'Payment Confimations',
                        style: TextStyle(
                          color: Color(0xff121212),
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 1),
                      child: Text(
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xffB3B3B3),
                            fontSize: 12,
                          ),
                          "Please wait while we verify your payment"),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Lottie.asset(
                        'assets/loading.json',
                        width: 50,
                        height: 50,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      "Don't leave this screen",
                      style: TextStyle(color: Color(0xffB3B3B3), fontSize: 10),
                    ),
                  ],
                ),
              ),
            )));
  }

  payModal() {
    return showDialog(
        // barrierDismissible: false,
        context: context,
        builder: ((context) => Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(7)),
              child: Container(
                padding: const EdgeInsets.all(40),
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(top: 10),
                        child: Text(
                          'Confimation',
                          style: TextStyle(
                            color: Color(0xff121212),
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: Text(
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color(0xffB3B3B3),
                              fontSize: 12,
                            ),
                            "Enter the phone number you'd like us to send the confirmation to after completing your payment"),
                      ),
                      showphoneCard(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Container(
                                  width: 80,
                                  height: 35,
                                  margin: const EdgeInsets.only(bottom: 20),
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                        color: const Color(0xffd12f26),
                                      ),
                                      borderRadius: BorderRadius.circular(5)),
                                  child: const Center(
                                      child: Text(
                                    'Cancel',
                                    style: TextStyle(
                                      color: Color(0xffd12f26),
                                      fontSize: 14,
                                    ),
                                  ))),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            child: GestureDetector(
                              onTap: validates,
                              child: Container(
                                  width: 80,
                                  height: 35,
                                  margin: const EdgeInsets.only(bottom: 20),
                                  decoration: BoxDecoration(
                                      color: const Color(0xff121212),
                                      borderRadius: BorderRadius.circular(5)),
                                  child: const Center(
                                      child: Text(
                                    'Proceed',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                    ),
                                  ))),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            )));
  }
}

   // Card Tab
                        // ListView(
                        //   controller: scrollController,
                        //   children: [
                        //     CreditCardWidget(
                        //       cardBgColor: Color(0xffFF3B30),
                        //       cardNumber: cardNumber,
                        //       expiryDate: expiryDate,
                        //       cardHolderName: cardHolderName,
                        //       cvvCode: cvvCode,
                        //       showBackView:
                        //           isCvvFocused, //true when you want to show cvv(back) view
                        //       onCreditCardWidgetChange: (CreditCardBrand
                        //           brand) {}, // Callback for anytime credit card brand is changed
                        //     ),
                        //     SingleChildScrollView(
                        //         child: Column(children: <Widget>[
                        //       CreditCardForm(
                        //         formKey: formKey,
                        //         obscureCvv: false,
                        //         obscureNumber: false,
                        //         cardNumber: cardNumber,
                        //         cvvCode: cvvCode,
                        //         isHolderNameVisible: true,
                        //         isCardNumberVisible: true,
                        //         isExpiryDateVisible: true,
                        //         cardHolderName: cardHolderName,
                        //         expiryDate: expiryDate,
                        //         themeColor: Color(0xff262626),
                        //         cardHolderDecoration: InputDecoration(
                        //           contentPadding: EdgeInsets.symmetric(
                        //             vertical: 12.0,
                        //             horizontal: 10.0,
                        //           ),
                        //           border: OutlineInputBorder(
                        //               borderSide: BorderSide.none,
                        //               borderRadius: BorderRadius.circular(10)),
                        //           filled: true,
                        //           labelText: "Card Holder",
                        //           labelStyle: TextStyle(
                        //             fontSize: 15,
                        //             color: Color(0xff262626).withOpacity(0.25),
                        //           ),
                        //         ),
                        //         cardNumberDecoration: InputDecoration(
                        //           contentPadding: EdgeInsets.symmetric(
                        //             vertical: 12.0,
                        //             horizontal: 10.0,
                        //           ),
                        //           border: OutlineInputBorder(
                        //               borderSide: BorderSide.none,
                        //               borderRadius: BorderRadius.circular(10)),
                        //           filled: true,
                        //           labelText: "Card Number",
                        //           labelStyle: TextStyle(
                        //             fontSize: 15,
                        //             color: Color(0xff262626).withOpacity(0.25),
                        //           ),
                        //           hintText: "XXXX XXXX XXXX XXXX",
                        //           hintStyle: TextStyle(
                        //             fontSize: 15,
                        //             color: Color(0xff262626).withOpacity(0.25),
                        //           ),
                        //         ),
                        //         expiryDateDecoration: InputDecoration(
                        //           contentPadding: EdgeInsets.symmetric(
                        //             vertical: 12.0,
                        //             horizontal: 10.0,
                        //           ),
                        //           border: OutlineInputBorder(
                        //               borderSide: BorderSide.none,
                        //               borderRadius: BorderRadius.circular(10)),
                        //           filled: true,
                        //           labelText: "Expired Date",
                        //           labelStyle: TextStyle(
                        //             fontSize: 15,
                        //             color: Color(0xff262626).withOpacity(0.25),
                        //           ),
                        //           hintText: "MM/YY",
                        //           hintStyle: TextStyle(
                        //             fontSize: 15,
                        //             color: Color(0xff262626).withOpacity(0.25),
                        //           ),
                        //         ),
                        //         cvvCodeDecoration: InputDecoration(
                        //           contentPadding: EdgeInsets.symmetric(
                        //             vertical: 12.0,
                        //             horizontal: 10.0,
                        //           ),
                        //           border: OutlineInputBorder(
                        //               borderSide: BorderSide.none,
                        //               borderRadius: BorderRadius.circular(10)),
                        //           filled: true,
                        //           labelText: "CVV",
                        //           labelStyle: TextStyle(
                        //             fontSize: 15,
                        //             color: Color(0xff262626).withOpacity(0.25),
                        //           ),
                        //           hintText: "XXX",
                        //           hintStyle: TextStyle(
                        //             fontSize: 15,
                        //             color: Color(0xff262626).withOpacity(0.25),
                        //           ),
                        //         ),
                        //         onCreditCardModelChange:
                        //             onCreditCardModelChange,
                        //       ),
                        //       const SizedBox(height: 20),
                        //     ])),
                        //     const SizedBox(height: 16),
                        //     Center(
                        //       child: GestureDetector(
                        //         onTap: _onValidate,
                        //         child: Container(
                        //           height: 50,
                        //           width: 200,
                        //           decoration: BoxDecoration(
                        //             borderRadius: BorderRadius.circular(7),
                        //             color:
                        //                 Color(0xff121212), //Color(0xffFF3B30),
                        //           ),
                        //           child: Center(
                        //             child: Text(
                        //               'Pay TZS  300/=',
                        //               style: TextStyle(
                        //                   // fontFamily: 'Manane',
                        //                   color: Colors.white,
                        //                   fontSize: 16,
                        //                   fontWeight: FontWeight.bold),
                        //             ),
                        //           ),
                        //         ),
                        //       ),
                        //     ),
                        //   ],
                        // )
  // void onCreditCardModelChange(CreditCardModel creditCardModel) {
  //   setState(() {
  //     cardNumber = creditCardModel.cardNumber;
  //     expiryDate = creditCardModel.expiryDate;
  //     cardHolderName = creditCardModel.cardHolderName;
  //     cvvCode = creditCardModel.cvvCode;
  //     isCvvFocused = creditCardModel.isCvvFocused;
  //   });
  // }

  // void _onValidate() {
  //   if (formKey.currentState?.validate() ?? false) {
  //     cardMoadal();
  //     _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
  //       Navigator.pop(context);
  //       Navigator.pop(context);
  //       Navigator.push(
  //         context,
  //         MaterialPageRoute(
  //             builder: (_) => MoviePlayerPage(
  //                   videoUrl: '',
  //                   title: '',
  //                 )),
  //       );
  //     });
  //   }
  // }

  //   bool isLightTheme = false;
  // String cardNumber = '';
  // String expiryDate = '';
  // String cardHolderName = '';
  // String cvvCode = '';
  // bool isCvvFocused = false;
  // bool useGlassMorphism = false;
  // bool useBackgroundImage = false;
  // bool useFloatingAnimation = true;
