import 'dart:async';
import 'dart:developer';
import 'package:booknoejilju/pages/Lobby_members.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../services/bookclub_service.dart';
import 'Lobby.dart';
import 'Writing.dart';

class ReadPage extends StatefulWidget {
  const ReadPage({Key? key}) : super(key: key);

  @override
  State<ReadPage> createState() => ReadPageState();
}

class ReadPageState extends State<ReadPage> {
  @override
  void initState() {
    if ((Provider.of<AuthService>(context, listen: false).readpage) != null) {
      pageController.text =
          Provider.of<AuthService>(context, listen: false).readpage as String;
    }
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      String? myUid = FirebaseAuth.instance.currentUser?.uid;
    });

    super.initState();
  }

  @override
  void didChangeDependencies() {
    inviteCode =
        Provider.of<AuthService>(context, listen: false).docId as String;

    if ((Provider.of<AuthService>(context, listen: false).readpage) != null) {
      pageController.text =
          Provider.of<AuthService>(context, listen: false).readpage as String;
    }

    super.didChangeDependencies();
  }

  int currentIndex = 0;
  int currentPage = 0;

  final _items = ['전체 피드', '내 비밀 피드'];

  final scrollController = ScrollController();

  String inviteCode = '';

  TextEditingController pageController = TextEditingController();

  Widget build(BuildContext context) {
    return Consumer<ClubService>(
      builder: (context, clubService, child) {
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(CupertinoIcons.chevron_back, color: Colors.white),
              onPressed: () => showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    backgroundColor: Colors.grey[850],
                    title: const Text('현재 페이지 입력은 완료하셨나요?',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                        textAlign: TextAlign.center),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text(
                          '이어서 보기',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      Consumer<AuthService>(
                          builder: (context, authService, child) {
                        return TextButton(
                          onPressed: () {
                            authService.readpage = pageController.text;
                            clubService.read_page_update(
                              authService.uid as String,
                              authService.docId as String,
                              authService.readpage as String,
                            );

                            Navigator.pop(context);
                            Navigator.pop(context);
                            if (authService.uid as String ==
                                authService.leader) {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: ((context) => LobbyPage()),
                                ),
                              );
                            } else {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: ((context) => Lobby_mem(
                                        docId: authService.docId as String,
                                      )),
                                ),
                              );
                            }
                          },
                          child: const Text(
                            '저장하고 나가기',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                            ),
                          ),
                        );
                      }),
                    ],
                  );
                },
              ),
            ),
            backgroundColor: Colors.black87,
            actions: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: IconButton(
                  icon: Icon(CupertinoIcons.bell),
                  onPressed: () {},
                ),
              ),
            ],
          ),
          body: Stack(
            children: [
              Consumer<AuthService>(builder: (context, authService, child) {
                return CustomScrollView(
                  shrinkWrap: true,
                  controller: scrollController,
                  slivers: [
                    SliverAppBar(
                      floating: true,
                      backgroundColor: Colors.black87,
                      expandedHeight: 300,
                      automaticallyImplyLeading: false,
                      pinned: true,
                      flexibleSpace: FlexibleSpaceBar(
                        background: Column(
                          children: [
                            SizedBox(
                              height: 30,
                            ),
                            Text(
                              '          지금 이쪽을 읽고 있는 중이에요.\n직접 입력하거나 버튼을 이용해 조절해 주세요.',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                      bottom: PreferredSize(
                        preferredSize: Size.fromHeight(220),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 30,
                                ),
                                Container(
                                  width: 130,
                                  height: 70,
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade800,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                  ),
                                  child: Consumer<AuthService>(
                                      builder: (context, authService, child) {
                                    return TextFormField(
                                      onEditingComplete: () async {
                                        clubService.read_page_update(
                                          authService.uid as String,
                                          authService.docId as String,
                                          pageController.text,
                                        );

                                        authService.rank =
                                            await clubService.get_my_rank(
                                                authService.docId as String,
                                                authService.uid as String);

                                        Provider.of<AuthService>(context,
                                                listen: false)
                                            .readpage = pageController.text;
                                      },
                                      controller: pageController,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 38,
                                      ),
                                      decoration: InputDecoration(
                                        fillColor: Colors.white,
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.red,
                                          ),
                                        ),
                                        labelText: '현재 페이지',
                                        labelStyle: TextStyle(
                                            color: Colors.grey, fontSize: 15),
                                      ),
                                    );
                                  }),
                                ),
                                Text(
                                  ' p ',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Column(
                                  children: [
                                    SizedBox(
                                      height: 30,
                                    ),
                                    Text(
                                      ' / ',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 60,
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  width: 70,
                                  height: 70,
                                  decoration: BoxDecoration(
                                    color: Colors.black87,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                  ),
                                  child: Center(
                                    child: Consumer<AuthService>(
                                        builder: (context, authService, child) {
                                      String pages =
                                          authService.totalpage as String;
                                      return RichText(
                                        text: TextSpan(
                                          children: [
                                            TextSpan(
                                              text: pages, //로비페이지의 전체 쪽수가져오기//
                                              style: TextStyle(
                                                fontSize: 20,
                                              ),
                                              children: [
                                                TextSpan(
                                                  text: '  p',
                                                  style: TextStyle(
                                                    fontSize: 20,
                                                  ),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      );
                                    }),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Column(children: [
                              Container(
                                width: MediaQuery.of(context).size.width * 0.9,
                                height: 50,
                                child: Center(
                                  child: Text(
                                    '현재 페이지까지 질주 피드들을 확인해보세요!',
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.red,
                                    ),
                                  ),
                                ),
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                  border:
                                      Border.all(color: Colors.red, width: 2),
                                ),
                              ),
                            ]),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                SizedBox(
                                  width: 20,
                                ),
                                Consumer<AuthService>(
                                    builder: (context, authService, child) {
                                  return DropdownButton(
                                    value: authService.selected as String,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                    ),
                                    dropdownColor: Colors.grey.shade700,
                                    underline: DropdownButtonHideUnderline(
                                        child: Container()),
                                    items: _items
                                        .map(
                                          (value) => DropdownMenuItem(
                                            child: Text(
                                              value,
                                              style: TextStyle(
                                                color: Colors.white,
                                                decorationColor: Colors.white,
                                              ),
                                            ),
                                            value: value,
                                          ),
                                        )
                                        .toList(),
                                    onChanged: (value) {
                                      clubService.which_feed(value as String);
                                      authService.selected = value;
                                      //두개로 나뉘지 않도록 provider 구성.
                                      //값 하나 바꿔서 하는 건데 2개 나오는 건 아님.
                                      //
                                    },
                                  );
                                })
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    authService.is_private ?? false
                        ? FutureBuilder<
                                List<
                                    QueryDocumentSnapshot<
                                        Map<String, dynamic>>>>(
                            future: clubService.readpost(
                                authService.docId as String,
                                authService.readpage as String),
                            builder: (context, snapshot) {
                              final posts = snapshot.data ?? [];
                              return SliverToBoxAdapter(
                                child: SizedBox(
                                  width: double.infinity,
                                  height: posts.length.toDouble() * 90,
                                  child: ListView.builder(
                                    controller: scrollController,
                                    itemCount: posts.length,
                                    itemBuilder: (context, index) {
                                      final post = posts[index];
                                      String? pagenum = post.get('page');
                                      String? content = post.get('post');
                                      bool? isPrivate = post.get('isPrivate');

                                      return Container(
                                        width: double.infinity,
                                        height: 90,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                  pagenum as String,
                                                  style: TextStyle(
                                                    fontSize: 17,
                                                    color: Colors.blue,
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 15,
                                                ),
                                                Container(
                                                  child: Center(
                                                    child: isPrivate ?? false
                                                        ? Text(
                                                            '비밀 피드',
                                                            style: TextStyle(
                                                                color:
                                                                    Colors.red,
                                                                fontSize: 13),
                                                          )
                                                        : Text(
                                                            '공개 피드',
                                                            style: TextStyle(
                                                                color:
                                                                    Colors.red,
                                                                fontSize: 13),
                                                          ),
                                                  ),
                                                  width: 80,
                                                  height: 20,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                      Radius.circular(
                                                        5,
                                                      ),
                                                    ),
                                                    border: Border.all(
                                                      width: 1,
                                                      color: Colors.red,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Text(
                                              content!,
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                  '00/00/00',
                                                  style: TextStyle(
                                                    color: Colors.grey.shade700,
                                                  ),
                                                ),
                                                Spacer(),
                                                Icon(
                                                  Icons.thumb_up_alt_outlined,
                                                  color: Colors.white,
                                                  size: 20,
                                                ),
                                                SizedBox(
                                                  width: 20,
                                                ),
                                                Divider(
                                                  color: Colors.grey,
                                                  height: 1,
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              );
                            })
                        : FutureBuilder<
                                List<
                                    QueryDocumentSnapshot<
                                        Map<String, dynamic>>>>(
                            future: clubService.readprivatepost(
                                authService.docId as String,
                                authService.uid as String),
                            builder: (context, snapshot) {
                              //불러오는 시간이 걸림..?? 왜 그럴까??
                              final posts = snapshot.data ?? [];
                              return SliverToBoxAdapter(
                                child: SizedBox(
                                  width: double.infinity,
                                  height: posts.length.toDouble() * 90,
                                  child: ListView.builder(
                                    controller: scrollController,
                                    itemCount: posts.length,
                                    itemBuilder: (context, index) {
                                      final post = posts[index];
                                      String? pagenum = post.get('page');
                                      String? content = post.get('post');
                                      bool? isPrivate = post.get('isPrivate');
                                      return Container(
                                        width: double.infinity,
                                        height: 90,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                  pagenum as String,
                                                  style: TextStyle(
                                                    fontSize: 17,
                                                    color: Colors.blue,
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 15,
                                                ),
                                                Container(
                                                  child: Center(
                                                      child: Text(
                                                    '비밀 피드',
                                                    style: TextStyle(
                                                        color: Colors.red,
                                                        fontSize: 13),
                                                  )),
                                                  width: 80,
                                                  height: 20,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                      Radius.circular(
                                                        5,
                                                      ),
                                                    ),
                                                    border: Border.all(
                                                      width: 1,
                                                      color: Colors.red,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Text(
                                              content!,
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                  '00/00/00',
                                                  style: TextStyle(
                                                    color: Colors.grey.shade700,
                                                  ),
                                                ),
                                                Spacer(),
                                                Icon(
                                                  Icons.thumb_up_alt_outlined,
                                                  color: Colors.white,
                                                  size: 20,
                                                ),
                                                SizedBox(
                                                  width: 20,
                                                ),
                                                Divider(
                                                  color: Colors.grey,
                                                  height: 1,
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              );
                            }),
                  ],
                );
              }),
            ],
          ),
          floatingActionButton: Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(
                30,
              )),
              color: Colors.red,
            ),
            child: IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => WritingPage()),
                );
              },
              icon: Icon(
                CupertinoIcons.pen,
                color: Colors.white,
              ),
            ),
          ),
        );
      },
    );
  }
}
