import 'package:flutter/material.dart';
//import 'dart:typed_data';
import 'package:audioplayers/audioplayers.dart';
//import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const Birds_Home());
  }
}

class Birds_Home extends StatefulWidget {
  const Birds_Home({super.key});

  @override
  State<Birds_Home> createState() => _Birds_HomeState();
}

class _Birds_HomeState extends State<Birds_Home> {
  AudioPlayer player = AudioPlayer();
  bool isPlaying = false;
  Duration duration = Duration.zero; //duration for how long to be played
  Duration position = Duration.zero; //current position

  @override
  void initState() {
    super.initState();

    setAudio();

    //Listen to the states:playing, paused, stopped
    player.onPlayerStateChanged.listen((state) {
      setState(() {
        isPlaying = state == PlayerState.playing;
      });
    });

    //Listen to audio duration
    player.onDurationChanged.listen((newDuration) {
      setState(() {
        duration = newDuration;
      });
    });

    //Listen to audio position changers
    player.onPositionChanged.listen((newPosition) {
      setState(() {
        position = newPosition;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Play the sound of Wild Babbler bird"),
        backgroundColor: Colors.redAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.network(
                'https://cdn.pixabay.com/photo/2022/10/27/13/26/yellow-billed-babbler-7550869__340.jpg',
                width: double.infinity,
                height: 350,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              'the Wild Babbler sings',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'free source',
              style: TextStyle(fontSize: 20),
            ),
            Slider(
              min: 0,
              max: duration.inSeconds.toDouble(),
              value: position.inSeconds.toDouble(),
              onChanged: (value) async {
                final position = Duration(seconds: value.toInt());
                await player.seek(position);

                //optional: Play audio if it was paused
                await player.resume();
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(formatTime(position)),
                  Text(formatTime(duration)),
                ],
              ),
            ),
            CircleAvatar(
              radius: 35,
              child: IconButton(
                icon: Icon(
                  isPlaying ? Icons.pause : Icons.play_arrow,
                ),
                iconSize: 50,
                onPressed: () async {
                  if (isPlaying) {
                    await player.pause();
                  } else {
                    //String url = "assets/audio/wild_babbler_bird.mp3";
                    //await player.play(url);
                    // final myplayer = AudioCache(prefix: 'assets/audio/');
                    //final url = await myplayer.load('wild_babbler_bird.mp3');
                    //player.setSourceUrl(url.path);
                    // await myplayer.load('wild_babbler_bird.mp3');
                    await player.resume();
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  String formatTime(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));

    return [
      if (duration.inHours > 0) hours,
      minutes,
      seconds,
    ].join(':');
  }

  Future setAudio() async {
    //Repeat song when completed
    player.setReleaseMode(ReleaseMode.loop);

    //load audio from url code goes here
    // String url = "assets/audio/wild_babbler_bird.mp3";
    //player.setSourceUrl(url);

    //load audio from file using file picker
    //final file = File(...);
    //player.setSourceUrl(file.path, isLocal:true);

    final myplayer = AudioCache(prefix: 'assets/audio/');
    final url = await myplayer.load('wild_babbler_bird.mp3');
    player.setSourceUrl(url.path);
  }
}
