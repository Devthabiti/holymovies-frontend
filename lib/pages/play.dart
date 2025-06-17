import 'package:flutter/material.dart';
import 'package:better_player/better_player.dart';
import 'package:flutter/services.dart';
import 'package:screen_protector/screen_protector.dart';

class MoviePlayerPage extends StatefulWidget {
  final String videoUrl;
  final String title;
  const MoviePlayerPage({Key? key, required this.videoUrl, required this.title})
      : super(key: key);

  @override
  State<MoviePlayerPage> createState() => _MoviePlayerPageState();
}

class _MoviePlayerPageState extends State<MoviePlayerPage> {
  late BetterPlayerController _betterPlayerController;
  @override
  void initState() {
    super.initState();

    BetterPlayerDataSource dataSource = BetterPlayerDataSource(
        BetterPlayerDataSourceType.network, widget.videoUrl,
        // subtitles: [
        //   BetterPlayerSubtitlesSource(
        //     type: BetterPlayerSubtitlesSourceType.network,
        //     urls: [
        //       "https://raw.githubusercontent.com/betterplayer/betterplayer/main/example/assets/subtitles/example_subtitles.srt"
        //     ], // Optional
        //   ),
        // ],
        notificationConfiguration: BetterPlayerNotificationConfiguration(
          showNotification: true,
          title: widget.title,
          author: "Holy Movies",
        ));

    _betterPlayerController = BetterPlayerController(
      const BetterPlayerConfiguration(
        autoPlay: true,
        looping: true,
        aspectRatio: 16 / 9,
        fit: BoxFit.contain,
        autoDetectFullscreenDeviceOrientation: true,
        deviceOrientationsAfterFullScreen: [DeviceOrientation.portraitUp],
        handleLifecycle: true,
        allowedScreenSleep: false,
        fullScreenByDefault: true,
        controlsConfiguration: BetterPlayerControlsConfiguration(
          enableSubtitles: true,
          enablePlaybackSpeed: true,
          enablePip: true,
          enableFullscreen: true,
          enableOverflowMenu: true,
          //controlBarColor: Colors.green.withOpacity(0.7),
          // iconsColor:
          //     Colors.redAccent, // color of buttons (play, pause, etc.)
          // textColor: Colors.blue,
          // progressBarPlayedColor: Colors.redAccent,
          progressBarPlayedColor: Color(0xffFF3B30),
          // progressBarHandleColor: Colors.white,
          // progressBarBufferedColor: Colors.pink,
          // progressBarBackgroundColor: Colors.grey,
          enableMute: true,

          //Controls icons
          //fullscreenDisableIcon: Icons.abc,

          //functionality
          //enableProgressText: false,
          //enableProgressBar: false,
          //enableProgressBarDrag: false,
          // enablePlayPause: false,
          playerTheme: BetterPlayerTheme.material,
        ),

        // controlsConfiguration: BetterPlayerControlsConfiguration(
        //   enableSubtitles: true,
        //   enablePlaybackSpeed: true,
        //   enablePip: true,
        //   enableFullscreen: true,
        //   //audioTracksIcon: Icons.audio_file,
        // ),
      ),
      betterPlayerDataSource: dataSource,
    );

    //screen shot detections
    // Prevent screenshots (Android only)
    ScreenProtector.preventScreenshotOn();

    // Detect screen recording (iOS)
    // ScreenProtector.detectScreenRecording(
    //   onRecording: () {
    //     setState(() {
    //       _isRecording = true;
    //     });
    //   },
    //   onStopRecording: () {
    //     setState(() {
    //       _isRecording = false;
    //     });
    //   },
    // );
  }

  @override
  void dispose() {
    _betterPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff121212),
      appBar: AppBar(
        backgroundColor: Color(0xff121212),
        title: Text(widget.title),
      ),
      body: AspectRatio(
        aspectRatio: 16 / 9,
        child: BetterPlayer(controller: _betterPlayerController),
      ),
    );
  }
}
