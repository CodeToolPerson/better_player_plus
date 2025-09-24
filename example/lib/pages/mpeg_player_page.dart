import 'package:better_player_plus/better_player_plus.dart';
import 'package:better_player_example/constants.dart';
import 'package:flutter/material.dart';

class MpegPlayerPage extends StatefulWidget {
  @override
  _MpegPlayerPageState createState() => _MpegPlayerPageState();
}

class _MpegPlayerPageState extends State<MpegPlayerPage> {
  late BetterPlayerController _controller;

  @override
  void initState() {
    super.initState();
    final config = BetterPlayerConfiguration(
      aspectRatio: 16 / 9,
      fit: BoxFit.contain,
    );
    _controller = BetterPlayerController(config);
    final dataSource = BetterPlayerDataSource(
      BetterPlayerDataSourceType.network,
      Constants.mpegStreamUrl,
      videoFormat: BetterPlayerVideoFormat.other,
    );
    _controller.setupDataSource(dataSource);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("MPEG Test"),
      ),
      body: Column(
        children: [
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              "MPEG Test stream playback page。",
              style: TextStyle(fontSize: 16),
            ),
          ),
          AspectRatio(
            aspectRatio: 16 / 9,
            child: BetterPlayer(
              controller: _controller,
            ),
          ),
        ],
      ),
    );
  }
}

