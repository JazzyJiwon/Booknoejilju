import 'dart:developer';

import 'package:booknoejilju/pages/Lobby_members.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/auth_service.dart';
import '../services/bookclub_service.dart';
import 'Entrance.dart';
import 'Lobby.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // main 함수에서 async 사용하기 위함
  await Firebase.initializeApp(); // firebase 앱 시작
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthService()),
      ],
      child: const LoginPage(),
    ),
  );
}

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthService>(
      builder: (context, authService, child) {
        final authService = context.read<AuthService>();
        final user = authService.currentUser();
        return Consumer<ClubService>(builder: (context, clubService, child) {
          return Scaffold(
            backgroundColor: Colors.black,
            body: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    height: 100.0,
                    width: 500.0,
                    color: Colors.black,
                  ),
                  Container(
                    child: Image.asset('lib/images/Splash_Character.png'),
                    height: 100.0,
                    width: 400.0,
                  ),
                  Container(
                    height: 20.0,
                    width: 500.0,
                    color: Colors.black,
                  ),
                  Text(
                    '북노의 질주',
                    style: TextStyle(
                        fontFamilyFallback: ['CookieRun'],
                        fontSize: 48.0,
                        color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                  Container(
                    height: 12.0,
                    width: 500.0,
                    color: Colors.black,
                  ),
                  Text(
                    '피드로 함께하는 독서 레이싱',
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Container(
                    height: 12.0,
                    width: 500.0,
                    color: Colors.black,
                  ),
                  TextField(
                    controller: emailController,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      hintText: 'ID를 입력해주세요',
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.grey,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        borderSide: BorderSide(
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: 10.0,
                    width: 500.0,
                    color: Colors.black,
                  ),
                  TextField(
                    controller: passwordController,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      hintText: 'PASSWORD를 입력해주세요',
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.grey,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        borderSide: BorderSide(
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: 10.0,
                    width: 500.0,
                    color: Colors.black,
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      // 로그인
                      authService.signIn(
                        email: emailController.text,
                        password: passwordController.text,
                        onSuccess: () async {
                          // print(user?.uid);
                          // print(authService.currentUser()?.uid);

                          QuerySnapshot<Map<String, dynamic>> data =
                              await clubService.UserCollection.where('uid',
                                      isEqualTo: authService.currentUser()?.uid)
                                  .get();
                          String userdocId = data.docs[0]['docId'];

                          DocumentSnapshot<Map<String, dynamic>>
                              documentsnapshot =
                              await clubService.ClubCollection.doc(userdocId)
                                  .get();
                          print(documentsnapshot.data()?['leader']);

                          // DocumentReference<Map<String, dynamic>> ref =
                          //     clubService.ClubCollection.doc(userdocId);
                          // inspect(ref);
                          if (userdocId != 'unavailable') {
                            if (documentsnapshot.data()?['leader'] ==
                                authService.currentUser()?.uid) {
                              Navigator.pushReplacement(
                                //push replacement는 전 context를 지움
                                context,
                                MaterialPageRoute(
                                  builder: (context) => LobbyPage(),
                                ),
                              );
                            } else {
                              Navigator.pushReplacement(
                                //push replacement는 전 context를 지움
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Lobby_mem(
                                    docId: userdocId,
                                  ),
                                ),
                              );
                            }
                          } else {
                            Navigator.pushReplacement(
                              //push replacement는 전 context를 지움
                              context,
                              MaterialPageRoute(
                                builder: (context) => EntrancePage(),
                              ),
                            );
                          }

                          // 로그인 성공
                          // if(clubService.UserCollection.where('uid', isEqualTo: user?.uid).get() != 'unavailable' ) {
                          //   if(그 docId에 leader의 uid가 얘의 uid랑 동일?){
                          //     방장 로비
                          //   }else{
                          //     멤버로비
                          //   }

                          // }

                          // else{
                          //   entrancepage로 라우팅
                          // }

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("로그인 성공"),
                            ),
                          );

                          // EntrancePage로 이동
                        },
                        onError: (err) {
                          // 에러 발생
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(err),
                          ));
                        },
                      );
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.red,
                      minimumSize: Size(200, 50),
                    ),
                    label: Text(
                      '로그인',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                    icon: Icon(Icons.door_front_door_sharp,
                        size: 18, color: Colors.white),
                  ),
                  Container(
                    height: 10.0,
                    width: 500.0,
                    color: Colors.black,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      authService.signUp(
                        email: emailController.text,
                        password: passwordController.text,
                        onSuccess: () {
                          clubService.createuid(
                              authService.currentUser()?.uid as String);
                          // 회원가입 성공
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text("회원가입 성공"),
                          ));
                        },
                        onError: (err) {
                          // 에러 발생
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(err),
                          ));
                        },
                      );
                      // Navigator.pop(context); //회원가입 페이지로 가야함 (추후 작업 예정)
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.red,
                      minimumSize: Size(200, 50),
                    ),
                    child: Text(
                      '회원가입',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  IconButton(
                    color: Colors.white,
                    onPressed: () async {
                      // 로그아웃
                      print(FirebaseAuth.instance.currentUser?.uid);
                      await FirebaseAuth.instance.signOut();
                      print(FirebaseAuth.instance.currentUser?.uid);
                    },
                    icon: Icon(Icons.logout_rounded),
                  ),
                ],
              ),
            ),
          );
        });
      },
    );
  }
}
