import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:provider/provider.dart';
import 'package:rooftop/main.dart';
import 'package:video_player/video_player.dart';

import 'favourites.dart';

class Home extends StatefulWidget {
  Home(
      {Key? key,
      required this.image,
      required this.index,
      required this.isImage})
      : super(key: key);
  List image;
  int index;
  String isImage;
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool fav = false;
  VideoPlayerController _controller = VideoPlayerController.network('');
  late Future<void> _initializeVideoPlayerFuture;

  void isLiked() {
    if (fav == true) {
      fav = false;
    } else {
      fav = true;
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.isImage == 'image') {
      if (context.read<HeartCount>().likes.contains(widget.index)) {
        fav = true;
      }
    } else {
      if (context.read<HeartCount>().videos1.contains(widget.index)) {
        fav = true;
      }
    }
    if (widget.isImage != 'image') {
      _controller = VideoPlayerController.network(
          '${widget.image[widget.index]['video_files'][0]['link']}');
      _initializeVideoPlayerFuture = _controller.initialize();

    }
  }

  @override
  Widget build(BuildContext context) {
    return OfflineBuilder(
      debounceDuration: Duration.zero,
      connectivityBuilder: (
        BuildContext context,
        ConnectivityResult connectivity,
        Widget child,
      ) {
        if (connectivity == ConnectivityResult.none) {
          return const Scaffold(
            backgroundColor: Colors.black,
            body: Center(
                child: Text(
              'Please check your internet connection!',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 20),
            )),
          );
        }
        return child;
      },
      child: Scaffold(
        backgroundColor: Colors.greenAccent,
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              actions: [
                IconButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  Favourites(image: widget.image)));
                    },
                    icon: Padding(
                      padding: const EdgeInsets.only(right: 18.0),
                      child: fav
                          ? const Icon(
                              Icons.star,
                              size: 30,
                            )
                          : const Icon(
                              Icons.star_border_outlined,
                              size: 30,
                            ),
                    ))
              ],
              pinned: true,
              backgroundColor: Colors.white,
              expandedHeight: 350,
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  color: Colors.greenAccent,
                  child: Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: widget.isImage == 'image'
                        ? Image.network(
                            widget.image[widget.index]['src']['large'],
                            fit: BoxFit.cover,
                          )
                        : FutureBuilder(
                            future: _initializeVideoPlayerFuture,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.done) {
                                return AspectRatio(
                                  aspectRatio: _controller.value.aspectRatio,
                                  child: VideoPlayer(_controller),
                                );
                              } else {
                                return const Center(
                                    child: CircularProgressIndicator());
                              }
                            },
                          ),
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.black,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: IconButton(
                        onPressed: () {
                          setState(() {
                            if (widget.isImage == 'image') {
                              if (fav == false) {
                                fav = true;
                                context.read<HeartCount>().index = widget.index;
                                context.read<HeartCount>().increment();
                              } else {
                                fav = false;
                                context.read<HeartCount>().index = widget.index;
                                context.read<HeartCount>().decrement();
                              }
                            } else {
                              if (fav == false) {
                                fav = true;
                                context.read<HeartCount>().index = widget.index;
                                context.read<HeartCount>().incrementVideo();
                              } else {
                                fav = false;
                                context.read<HeartCount>().index = widget.index;
                                context.read<HeartCount>().decrementVideo();
                              }
                            }
                          });
                        },
                        icon: fav
                            ? const Icon(
                                Icons.star,
                                size: 30,
                                color: Colors.white,
                              )
                            : const Icon(
                                Icons.star_border_outlined,
                                size: 30,
                                color: Colors.white,
                              ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.all(18.0),
                      child: Text(
                        "name:",
                        style: TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.w900,
                            fontSize: 17),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 38.0, right: 18, bottom: 10),
                      child: Text(
                        widget.isImage == 'image'
                            ? "${widget.image[widget.index]['alt']}"
                            : "${widget.image[widget.index]['url']}",
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Row(
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(18.0),
                          child: Text(
                            "photographer name:",
                            style: TextStyle(
                                color: Colors.grey,
                                fontSize: 17,
                                fontWeight: FontWeight.w900),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  color: Colors.redAccent[700]),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  widget.isImage == 'image'
                                      ? "${widget.image[widget.index]['photographer']}"
                                      : "${widget.image[widget.index]['user']['name']}",
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Padding(
                      padding: EdgeInsets.all(18.0),
                      child: Text(
                        "photographer url:",
                        style: TextStyle(
                            color: Colors.grey,
                            fontSize: 17,
                            fontWeight: FontWeight.w900),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 38.0, right: 18, bottom: 10),
                      child: Text(
                        widget.isImage == 'image'
                            ? "${widget.image[widget.index]['photographer_url']}"
                            : "${widget.image[widget.index]['user']['url']}",
                        style: const TextStyle(
                            color: Colors.blue,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
        floatingActionButton: widget.isImage == 'image'
            ? null
            : FloatingActionButton(
                backgroundColor: Colors.redAccent[700],
                onPressed: () {
                  setState(() {
                    _controller.value.isPlaying
                        ? _controller.pause()
                        : _controller.play();
                  });
                },
                child: Icon(
                  _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
                ),
              ),
      ),
    );
  }
}
