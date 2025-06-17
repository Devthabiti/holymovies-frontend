import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:holy/errors/error_screen.dart';
import 'package:holy/pages/favorate/watchlist.dart';
import 'package:holy/pages/homepage.dart';
import 'package:holy/pages/search/search.dart';
import 'package:holy/pages/settings/setting.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';

import 'models/providers/token_provider.dart';

class NavPage extends StatefulWidget {
  const NavPage({Key? key}) : super(key: key);

  @override
  State<NavPage> createState() => _NavPageState();
}

class _NavPageState extends State<NavPage> {
  late PageController pageController;
  int pageIndex = 0;

  @override
  void initState() {
    final data = context.read<ApiCalls>();

    data.fetchReview();
    data.fetchMovie();
    data.fetchWatchlist();
    data.fetchPayment();
    data.fetchCarsole();

    context.read<ApiCalls>().userID();
    pageController = PageController();

    super.initState();
  }

  @override
  void dispose() {
    pageController.dispose();

    super.dispose();
  }

  onPageChanged(int pageIndex) {
    setState(() {
      this.pageIndex = pageIndex;
    });
  }

  onTap(int pageIndex) {
    pageController.jumpToPage(
      pageIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    var data = context.watch<ApiCalls>().movieData;
    return data.isEmpty
        ? const ErrorScreenPage()
        : Scaffold(
            body: PageView(
              controller: pageController,
              onPageChanged: onPageChanged,
              physics: const NeverScrollableScrollPhysics(),
              children: const <Widget>[
                Homepage(),
                SearchPage(),
                WatchList(),
                Settings()
              ],
            ),
            bottomNavigationBar: Container(
              decoration: const BoxDecoration(
                color: Color(0xff1E1E1E),
                // borderRadius: BorderRadius.only(
                //     topLeft: Radius.circular(10), topRight: Radius.circular(10)),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 35),
                child: GNav(
                    backgroundColor: const Color(0xff1E1E1E),
                    color: Colors.white,
                    activeColor: Colors.white,
                    tabBackgroundColor: const Color(0xffd12f26),
                    gap: 8,
                    onTabChange: onTap,
                    selectedIndex: pageIndex,
                    padding: const EdgeInsets.all(10),
                    tabs: const [
                      GButton(
                        text: 'Home',
                        icon: Iconsax.home_25,
                      ),
                      GButton(text: 'Search', icon: Iconsax.search_normal_14),
                      GButton(
                        text: 'WatchList',
                        icon: Iconsax.heart,
                      ),
                      GButton(
                        text: 'My Stuff',
                        icon: Iconsax.user,
                      ),
                    ]),
              ),
            ),
          );
  }
}



     // Scaffold(
        //     backgroundColor: Color(0xff121212),
        //     body: SafeArea(
        //       child: Shimmer.fromColors(
        //           baseColor: Colors.white.withOpacity(0.2),
        //           highlightColor: Colors.white.withOpacity(0.6),
        //           enabled: true,
        //           child: Column(
        //             children: [
        //               Expanded(
        //                 child: ListView.builder(
        //                   itemCount: 6,
        //                   physics: NeverScrollableScrollPhysics(),
        //                   itemBuilder: (context, index) => ListTile(
        //                     leading: Container(
        //                       width: 70.0,
        //                       height: 56.0,
        //                       color: Colors.white,
        //                     ),
        //                     title: Column(
        //                       crossAxisAlignment: CrossAxisAlignment.start,
        //                       children: [
        //                         Container(
        //                           width: 250.0,
        //                           height: 20.0,
        //                           color: Colors.white,
        //                         ),
        //                         SizedBox(
        //                           height: 5,
        //                         ),
        //                         Container(
        //                           width: 200.0,
        //                           height: 15.0,
        //                           color: Colors.white,
        //                         ),
        //                         SizedBox(
        //                           height: 5,
        //                         ),
        //                       ],
        //                     ),
        //                     subtitle: Container(
        //                       width: 170.0,
        //                       height: 86.0,
        //                       color: Colors.white,
        //                     ),
        //                   ),
        //                 ),
        //               ),
        //             ],
        //           )),
        //     ),
        //   )