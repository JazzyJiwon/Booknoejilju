import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

//구현 기능
// read_post : 포스트 불러오기
// create_post : 글 작성하기
// create_comment : 댓글 작성하기
// update_page : 페이지 수 업데이트
// delete_post : 글 삭제하기
// delete_comment : 댓글 삭제하기

class BookService extends ChangeNotifier {
  final BookCollection = FirebaseFirestore.instance.collection('Book');
  final BookClub = FirebaseFirestore.instance.collection('Bookclub');

  Future<QuerySnapshot> read(String uid) async {
    // 내 post 가져오기
    return BookCollection.where('uid', isEqualTo: uid).get();
  }

  void create(int pagenum, String uid) async {
    // post 작성하기
    await BookCollection.add({
      'uid': uid, // 유저 식별자
      'pagenum': pagenum, // page num
    });
    notifyListeners(); // 화면 갱신
  }

  void update(String docId, bool isDone) async {
    // post 업데이트
  }

  void delete(String docId) async {
    // post 삭제
  }
}




// class OurUser {
//   String uid;
//   String nickname;
//   Timestamp clubCreated;
//   String groupId;

//   OurUser({
//     required this.uid,
//     required this.nickname,
//     required this.clubCreated,
//     required this.groupId,
//   });