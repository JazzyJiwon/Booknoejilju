import 'dart:developer';

import 'package:booknoejilju/pages/Splash.dart';
import 'package:booknoejilju/services/auth_service.dart';
import 'package:booknoejilju/services/bookclub_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'Lobby.dart';

class CreateClub extends StatefulWidget {
  CreateClub({Key? key}) : super(key: key);

  @override
  State<CreateClub> createState() => _CreateClubState();
}

class _CreateClubState extends State<CreateClub> {
  TextEditingController _clubname = TextEditingController();
  @override
  Widget build(BuildContext context) {
    //
    return Consumer<AuthService>(builder: (context, authService, child) {
      final authService = context.read<AuthService>();
      final user = authService.currentUser()!;
      return Consumer<ClubService>(
        builder: (context, clubService, child) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.black87,
              title: Text('방 제목 입력'),
              centerTitle: true,
              leading: IconButton(
                icon: Icon(Icons.arrow_back_ios_new),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
            body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  controller: _clubname,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                  ),
                  decoration: InputDecoration(
                      hintText: '방 제목을 입력하세요',
                      hintStyle: TextStyle(
                        color: Colors.white,
                      )),
                ),
                SizedBox(
                  height: 100,
                ),
                ElevatedButton.icon(
                  onPressed: () async {
                    final id = clubService.create_club(
                      _clubname.text,
                      '',
                      user.uid,
                      'clubrule',
                      '목표달성일을\n설정해보세요    ',
                      '1',
                      '',
                    );
                    clubService.createmembers(
                      user.uid,
                      await id,
                    );
                    clubService.add_docId(await id);
                    //User collection에서 leader의 uid부분 update
                    clubService.updateleaderdocId(user.uid, await id);

                    //authservice에 default 변수 저장시키기
                    authService.goaldate = '목표달성일을\n설정해보세요    ';
                    authService.docId = await id;

                    authService.todaygoal = '페이지 입력';
                    authService.totalpage = '1';
                    authService.uid = user.uid;
                    authService.readpage = '0';
                    DocumentSnapshot<Map<String, dynamic>> snapshot =
                        await clubService.ClubCollection.doc(authService.docId)
                            .get();
                    authService.leader = snapshot.data()?['leader'];

                    authService.rank = await clubService.get_my_rank(
                        authService.docId, user.uid);
                    // LobbyPage로 이동
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LobbyPage(),
                      ),
                    );
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.red,
                    minimumSize: Size(380, 50),
                  ),
                  label: Text(
                    '북클럽 생성하기',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                  icon: Icon(Icons.add, size: 18, color: Colors.white),
                ),
              ],
            ),
          );
        },
      );
    });
  }
}
