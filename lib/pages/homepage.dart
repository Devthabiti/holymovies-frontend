import 'package:flutter/material.dart';
import 'package:holy/pages/homepage/dashboard.dart';
import 'homepage/movie.dart';
import 'homepage/series.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: const Color(0xff121212),
        appBar: AppBar(
          elevation: 0,
          backgroundColor: const Color(0xff121212),
          toolbarHeight: 100,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: const [
              Text(
                'HOLY ',
                style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    color: Colors.white),
              ),
              Text(
                'MOVIES',
                style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    color: Color(0xffE50914)),
              ),
            ],
          ),
          centerTitle: false,
          bottom: TabBar(
              //indicatorWeight: 1,
              indicatorPadding:
                  const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              indicator: BoxDecoration(
                  border: Border.all(
                    color: const Color(0xffd12f26),
                  ),
                  borderRadius: BorderRadius.circular(50)),
              // indicator: ShapeDecoration(
              //     color: const Color(0xffd12f26),
              //     shape: RoundedRectangleBorder(
              //         borderRadius: BorderRadius.circular(50))),
              overlayColor: MaterialStateProperty.all(Colors.transparent),
              labelColor: Colors.white,
              labelStyle: const TextStyle(
                  //fontFamily: 'Inter',
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
              unselectedLabelColor: const Color(0xffB3B3B3),
              unselectedLabelStyle: const TextStyle(
                  // fontFamily: 'Inter',
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
              padding: const EdgeInsets.all(10),
              tabs: const [
                Tab(
                  text: 'Home',
                ),
                Tab(
                  text: 'Movies',
                ),
                Tab(
                  text: 'Series',
                ),
              ]),
        ),
        body: const TabBarView(
            physics: NeverScrollableScrollPhysics(),
            children: [Dashboard(), Movies(), Series()]),
      ),
    );
  }
}
