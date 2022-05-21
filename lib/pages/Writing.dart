import 'package:booknoejilju/pages/read_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../services/auth_service.dart';
import '../services/bookclub_service.dart';

class WritingPage extends StatefulWidget {
  const WritingPage({
    Key? key,
  }) : super(key: key);

  @override
  State<WritingPage> createState() => _WritingPageState();
}

class _WritingPageState extends State<WritingPage> {
  TextEditingController postController = TextEditingController();
  TextEditingController pageController = TextEditingController();
  bool isSecret = false;

  @override
  Widget build(BuildContext context) {
    final authService = context.read<AuthService>();
    final user = authService.currentUser()!;
    return Consumer<ClubService>(
      builder: (context, clubService, child) {
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(CupertinoIcons.chevron_back, color: Colors.white),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      backgroundColor: Colors.grey[850],
                      title: Text('''작성중인 글이 있어요! 
뒤로가면 저장되지 않아요. 
뒤로 갈까요?''',
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
                          child: Text(
                            "이어서 작성하기",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            Navigator.pop(context);
                          },
                          child: Text(
                            "뒤로가기",
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
            actions: [
              TextButton(
                onPressed: () {
                  //포스트 만들기
                  clubService.create_post(
                    postController.text,
                    user.uid,
                    pageController.text,
                    isSecret,
                    authService.docId as String,
                  );
                  Navigator.pop(context);
                },
                child: Text(
                  '저장',
                  style: TextStyle(color: Colors.white),
                ),
              )
            ],
            title: Text("피드 작성"),
            centerTitle: true,
            backgroundColor: Colors.black,
          ),
          backgroundColor: Colors.black,
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 1.0,
                    width: 500.0,
                    color: Colors.white,
                  ),
                  Row(
                    children: [
                      Text(
                        "페이지 수",
                        style: TextStyle(color: Colors.white),
                      ),
                      SizedBox(
                        width: 10.0,
                      ),
                      Expanded(
                        child: TextField(
                          controller: pageController,
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            labelText: "숫자를 입력해주세요.",
                            labelStyle: TextStyle(color: Colors.grey),
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    height: 1.0,
                    width: 500.0,
                    color: Colors.white,
                  ),
                  Row(
                    children: [
                      Text(
                        "공개여부",
                        style: TextStyle(color: Colors.white),
                      ),
                      SizedBox(
                        width: 10.0,
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            isSecret = !isSecret;
                          });
                        },
                        icon: Icon(
                          Icons.check_circle_outline,
                          color: isSecret ? Colors.red : Colors.grey,
                        ),
                      ),
                      SizedBox(
                        width: 10.0,
                      ),
                      Text(
                        '비밀 피드',
                        style: TextStyle(
                          fontSize: 16.0,
                          letterSpacing: 1.0,
                          color: isSecret ? Colors.red : Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    height: 5.0,
                    width: 500.0,
                    color: Colors.black,
                  ),
                  Container(
                    height: 1.0,
                    width: 500.0,
                    color: Colors.white,
                  ),
                  TextField(
                    controller: postController,
                    style: TextStyle(fontSize: 23, color: Colors.white),
                    decoration: InputDecoration(
                      labelText: "글을 입력해주세요.",
                      labelStyle: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
