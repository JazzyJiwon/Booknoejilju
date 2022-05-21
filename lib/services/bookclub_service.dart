import 'dart:async';
import 'dart:developer';

import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

//구현 기능
// read_post : 포스트 불러오기
// create_post : 글 작성하기
// create_comment : 댓글 작성하기
// update_page : 페이지 수 업데이트
// delete_post : 글 삭제하기
// delete_comment : 댓글 삭제하기

class ClubService extends ChangeNotifier {
  final ClubCollection = FirebaseFirestore.instance.collection('Book');
  final UserCollection = FirebaseFirestore.instance.collection('User');

  createuid(String uid) async {
    await UserCollection.add(
      {
        'uid': uid,
        'docId': 'unavailable',
      },
    );
  }
//docId치고 들어갔을 때, user의 docId값을 update시켜버림.

  updateuserdocId(String uid, String docId) async {
    CollectionReference<Map<String, dynamic>> user =
        FirebaseFirestore.instance.collection('User');
    user.get().then((querySnapshot) {
      querySnapshot.docs.forEach((document) {
        if (document.data()['uid'] == uid) {
          UserCollection.doc(document.id).update({
            'docId': docId,
          });
        }
      });
    });
  }

  updateleaderdocId(String uid, String docId) async {
    CollectionReference<Map<String, dynamic>> user =
        FirebaseFirestore.instance.collection('User');
    user.get().then((querySnapshot) {
      querySnapshot.docs.forEach((document) {
        if (document.data()['uid'] == uid) {
          UserCollection.doc(document.id).update({
            'docId': docId,
          });
        }
      });
    });
  }

  //책 제목 update
  updatebookname(String docId, String bookname) async {
    await ClubCollection.doc(docId).update({
      'bookname': bookname,
    });
  }

  getClub(String clubId) async {
    // 단하나의 스냅샷 조회
    DocumentSnapshot<Map<String, dynamic>> snapshot =
        await ClubCollection.doc(clubId).get();

    // 컬렉션의 스냅샷 리스트 조회
    QuerySnapshot<Map<String, dynamic>> snapshot2 =
        await ClubCollection.doc(clubId)
            .collection('members')
            .where('uid', isEqualTo: 'uid111')
            .get();

    // 컬렉션에 스냅샷 추가
    DocumentReference<Map<String, dynamic>> ref =
        await ClubCollection.add({"uid": "황성현이지롱"});

    inspect(ref);
    print('ID?????${ref.id}');

    // print('snapshot2 Exist? ${snapshot2.docs.length}');
    // snapshot2.docs.forEach((element) {
    //   print(element.data());
    // });

    return snapshot.data();
  }

//// docId와 초대코드가 같으면 lobby_mem으로 라우팅되도록 로직을 짬.
  getClubList() async {
    List docIdList = [];
    QuerySnapshot<Map<String, dynamic>> snapshot = await ClubCollection.get();
    List<QueryDocumentSnapshot<Map<String, dynamic>>> querySnapShotList =
        snapshot.docs;
    querySnapShotList.forEach(
      (QueryDocumentSnapshot<Map<String, dynamic>> element) {
        docIdList.add(element.data()['docId']);
      },
    );
    return docIdList;
    // return snapshot.data();
  }

/////
  getdocId(String uid) async {
    // QuerySnapshot<Map<String, dynamic>>
    QuerySnapshot<Map<String, dynamic>> snapshot = await ClubCollection.where(
      'leader',
      isEqualTo: uid,
    ).get();
    return snapshot;
  }
  //페이지를 불러올 때 document의 id값이 불러와져야함. 그런데 그 전페이지 없이
  //바로 이 페이지로 라우팅 될 수도 있음.
  //그럼 어떻게 해야하는가??

/////////////////////////////////////////
  Future<String> create_club(
    String name,
    String bookname,
    String leader,
    //초기에 지정 안되는 값
    String clubrule,
    String goaldate,
    String totalpages,
    String todaygoal,
  ) async {
    // post 작성하기
    DocumentReference<Map<String, dynamic>> ref = await ClubCollection.add({
      'name': name,
      'bookname': bookname,
      'leader': leader,
      //초기에 저장 안되는 값
      'club_rule': clubrule,
      'goal_date': goaldate,
      'total_pages': totalpages,
      'today_goal': todaygoal,
      'member_readpages': {leader: '0'},
    });

    return ref.id;
  }

  //Entrance에서 코드치고 들어갈 때,,
  void createmembers(
    String uid,
    String docId,
  ) async {
    await ClubCollection.doc(docId).collection('members').add({
      'uid': uid,
    });
    notifyListeners();
  }

  /////////////////////////////////////////////////////

  //docId를 추가해주는 함수.(방 생성시)
  void add_docId(
    String docId,
  ) async {
    await ClubCollection.doc(docId).update({
      'docId': docId,
    });
  }

//lobby에서 토탈페이지 업데이트
  void total_page_update(
    String docId,
    String page,
  ) async {
    await ClubCollection.doc(docId).update(
      {'total_pages': page},
    );
    notifyListeners();
  }

  void read_page_update(
    String uid,
    String docId,
    String currentpage,
  ) async {
    FirebaseFirestore.instance.collection('Book').doc(docId).set({
      'member_readpages': {uid: currentpage}
    }, SetOptions(merge: true));
  }

  Future<String> get_my_rank(
    String? docId,
    String? uid,
  ) async {
    DocumentSnapshot<Map<String, dynamic>> docusnap =
        await FirebaseFirestore.instance.collection('Book').doc(docId).get();

    Map member_readpages = docusnap.data()?['member_readpages'];

    String my_readpage = docusnap.data()?['member_readpages'][uid];

    List member_readpages_list = [];

    for (var page in member_readpages.values) {
      member_readpages_list.add(page);
    }

    member_readpages_list.sort((b, a) => a.compareTo(b));
    inspect(member_readpages_list);
    int my_rank = member_readpages_list.indexOf(my_readpage) + 1;

    return '$my_rank';
  }

  // CollectionReference<Map<String, dynamic>> member = FirebaseFirestore
  //     .instance
  //     .collection('Book')
  //     .doc(docId)
  //     .collection('members');
  // member.get().then(
  //   (querySnapshot) {
  //     querySnapshot.docs.forEach(
  //       (document) {
  //         if (document.data()['uid'] == uid) {
  //           ClubCollection.doc(docId)
  //               .collection('members')
  //               .doc(document.id)
  //               .update(
  //             {'readpages': currentpage},
  //           );
  //         }
  //       },
  //     );
  //   },
  // );

//lobby에서 오늘 목표 업데이트
  void today_page_update(
    String docId,
    String page,
  ) async {
    await ClubCollection.doc(docId).update(
      {'today_goal': page},
    );
    notifyListeners();
  }

  Future<dynamic> gettotalpages(String docId) async {
    DocumentSnapshot<Map<String, dynamic>> snapshot =
        await ClubCollection.doc(docId).get();

    return snapshot.data()?['total_pages'];
  }

  Future<dynamic> gettodaypages(String docId) async {
    DocumentSnapshot<Map<String, dynamic>> snapshot =
        await ClubCollection.doc(docId).get();

    return snapshot.data()?['today_goal'];
  }

  // 업뎃하고, 초깃값이 아니라면 textfield가 아니라 text를 띄워주는 방향으로
  //근데 수정 가능하게는 어떻게 하지??

  // void createFeed(String docId, String uid, int page, bool isprivate, String post, String timestamp) async {
  //   await ClubCollection.doc(docId).collection('members').
  // }

  Future<QuerySnapshot> clubread() async {
    return ClubCollection.get();
  }

  //////////////////////////////////////
  //로비페이지 목표달성일 업데이트
  void update_goal_date(
    String docId,
    String goalDate,
  ) async {
    await ClubCollection.doc(docId).update({'goal_date': goalDate});
  }

  void create_post(
      String text, String uid, String num, bool isSecret, String docId) async {
    // post 작성하기
    await ClubCollection.doc(docId).collection('Feed').add({
      'uid': uid, // 유저 식별자
      'post': text, // 포스트 작성
      'page': num, // 페이지 수
      'isPrivate': isSecret, // 완료 여부
    });
    notifyListeners(); // 화면 갱신
  }

  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>> readpost(
      String docID, String currentpage) async {
    // return ClubCollection.doc(docID).collection('Feed').get();
    CollectionReference<Map<String, dynamic>> clubCol =
        ClubCollection.doc(docID).collection('Feed');
    List<QueryDocumentSnapshot<Map<String, dynamic>>> QueryList = [];

    clubCol.get().then((querySnapshot) {
      querySnapshot.docs.forEach((document) {
        if (int.parse(document.data()['page']) <= int.parse(currentpage)) {
          QueryList.add(document);
        }
      });
    });
    inspect(QueryList);
    return QueryList;
  }

  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>> readprivatepost(
    String docID,
    String uid,
  ) async {
    CollectionReference<Map<String, dynamic>> snapshot =
        ClubCollection.doc(docID).collection('Feed');

    List<QueryDocumentSnapshot<Map<String, dynamic>>> QueryList = [];

    snapshot.get().then((querySnapshot) {
      querySnapshot.docs.forEach((document) {
        if (document.data()['uid'] == uid) {
          if (document.data()['isPrivate'] == true) {
            QueryList.add(document);
          }
        }
      });
    });
    inspect(QueryList);
    return QueryList;
  }

//코드 치고 들어갔을 때, members에 추가

  Future getCount(String? docId) async => FirebaseFirestore.instance
          .collection("Book")
          .doc(docId)
          .collection("members") //your collectionref
          .get()
          .then((value) {
        var count = 0;
        count = value.docs.length;
        print(value);
        return count;
      });
  void create(int readingpagenum, String uid) async {
    // post 작성하기
    await ClubCollection.add({
      // 유저 식별자
      'reading_pagenum': readingpagenum, // page num
    });
    notifyListeners(); // 화면 갱신
  }

  Future<dynamic> getreadpages(String docId) async {
    DocumentSnapshot<Map<String, dynamic>> snapshot =
        await ClubCollection.doc(docId).get();

    return snapshot.data()?['total_pages'];
  }
}




///
/// 모든 유저를 담는 컬랙션.
/// docId와 currentroomdocId 연결지어 저장.
///
///
/// FirebaseStore.instance .reference() .child('users') .child(FirebaseAuth.instance.currentUser?.uid ?? '') .child('currenDocId'); null != => Lobby(); null => Entrance();
/// 
/// 
/// 
/// 
/// 

/// 