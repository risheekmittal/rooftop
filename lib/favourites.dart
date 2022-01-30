import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import 'home.dart';
import 'main.dart';

class Favourites extends StatefulWidget {
  Favourites({Key? key, required this.image}) : super(key: key);
  List image;

  @override
  State<Favourites> createState() => _FavouritesState();
}

class _FavouritesState extends State<Favourites> {
  bool isImage = false;
  List image = [];
  List videos = [];

  @override
  void initState() {
    super.initState();
    fetchAPI();
    fetchVideoAPI();
  }

  fetchAPI() async {
    await http.get(Uri.parse('https://api.pexels.com/v1/curated?per_page=80'),
        headers: {
          'Authorization':
              '563492ad6f91700001000001262456f94ffd41e29b92d74cbc67aa44'
        }).then((value) {
      Map result = jsonDecode(value.body);
      image = result['photos'];
    });
  }

  fetchVideoAPI() async {
    await http.get(
        Uri.parse('https://api.pexels.com/videos/popular?per_page=80'),
        headers: {
          'Authorization':
              '563492ad6f91700001000001262456f94ffd41e29b92d74cbc67aa44'
        }).then((value) {
      Map result = jsonDecode(value.body);
      videos = result['videos'];
    });
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
        backgroundColor: Colors.black,
        body: Container(
          color: Colors.black,
          child: ListView(
            shrinkWrap: true,
            physics: const ScrollPhysics(),
            children: [
              const SizedBox(
                height: 100,
              ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 70.0),
                    child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            isImage = true;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                            primary: Colors.red,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30))),
                        child: const Text("photos")),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 60.0),
                    child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            isImage = false;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                            primary: Colors.red,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30))),
                        child: const Text("videos")),
                  )
                ],
              ),
              const Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(left: 28.0, top: 30),
                  child: Text(
                    "Favourites",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 50,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(
                height: 100,
              ),
              isImage
                  ? FutureBuilder(
                      future:
                          Future.delayed(const Duration(milliseconds: 2000)),
                      builder: (context, snapshot) {
                        return ListView.builder(
                            padding: const EdgeInsets.only(left: 30, right: 30),
                            itemCount: context.read<HeartCount>().likes.length,
                            shrinkWrap: true,
                            physics: const ScrollPhysics(),
                            itemBuilder: (context, index) {
                              return Column(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      // Navigator.push(
                                      //     context,
                                      //     MaterialPageRoute(
                                      //         builder: (context) => Home(
                                      //               image: image,
                                      //               index: index,
                                      //             )));
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: Colors.grey[900],
                                          border: Border.all(
                                              width: 5, color: Colors.red),
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Image.network(
                                            image[context
                                                .read<HeartCount>()
                                                .likes[index]]['src']['large'],
                                            fit: BoxFit.fitWidth,
                                            height: 200,
                                            width: 500,
                                          ),
                                          const Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Text(
                                              "name: ",
                                              style: TextStyle(
                                                  color: Colors.grey,
                                                  fontWeight: FontWeight.w900),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              "${image[context.read<HeartCount>().likes[index]]['alt']}",
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              const Padding(
                                                padding: EdgeInsets.all(8.0),
                                                child: Text(
                                                  "photographed by: ",
                                                  style: TextStyle(
                                                      color: Colors.grey,
                                                      fontWeight:
                                                          FontWeight.w900),
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Center(
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(30),
                                                        color: Colors
                                                            .redAccent[700]),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Text(
                                                        "${image[context.read<HeartCount>().likes[index]]['photographer']}",
                                                        style: const TextStyle(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 50,
                                  )
                                ],
                              );
                            });
                      })
                  : FutureBuilder(
                      future:
                          Future.delayed(const Duration(milliseconds: 2000)),
                      builder: (context, snapshot) {
                        return ListView.builder(
                            padding: const EdgeInsets.only(left: 30, right: 30),
                            itemCount:
                                context.read<HeartCount>().videos1.length,
                            shrinkWrap: true,
                            physics: const ScrollPhysics(),
                            itemBuilder: (context, index) {
                              return Column(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => Home(
                                                    image: videos,
                                                    index: index,
                                                    isImage: 'video',
                                                  )));
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: Colors.grey[900],
                                          border: Border.all(
                                              width: 5, color: Colors.red),
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Image.network(
                                            videos[context
                                                .read<HeartCount>()
                                                .videos1[index]]['image'],
                                            height: 200,
                                            width: 500,
                                          ),
                                          const Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Text(
                                              "name: ",
                                              style: TextStyle(
                                                  color: Colors.grey,
                                                  fontWeight: FontWeight.w900),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              "${videos[context.read<HeartCount>().videos1[index]]['url']}",
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              const Padding(
                                                padding: EdgeInsets.all(8.0),
                                                child: Text(
                                                  "video by: ",
                                                  style: TextStyle(
                                                      color: Colors.grey,
                                                      fontWeight:
                                                          FontWeight.w900),
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Center(
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(30),
                                                        color: Colors
                                                            .redAccent[700]),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Text(
                                                        "${videos[context.read<HeartCount>().videos1[index]]['user']['name']}",
                                                        style: const TextStyle(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 50,
                                  )
                                ],
                              );
                            });
                      })
            ],
          ),
        ),
      ),
    );
  }
}
