import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(BookClubRule());
}

class BookClubRule extends StatelessWidget {
  const BookClubRule({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(CupertinoIcons.chevron_back, color: Colors.white),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          actions: [
            TextButton(
              onPressed: () {},
              child: Text(
                '작성',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            )
          ],

          ///초대받은 사람은 작성 누르는 란이 없어야함   편집페이지는 굳이 필요없을듯?
          title: Text("북클럽 룰"),
          centerTitle: true,
          backgroundColor: Colors.black,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: 80.0,
                width: 500.0,
                color: Colors.grey[850],
                child: Padding(
                  padding: const EdgeInsets.only(left: 40, top: 25),
                  child: Text(
                    '북클럽 룰을 확인해보세요!',
                    style: TextStyle(fontSize: 18.0, color: Colors.white),
                  ),
                ),
              ),
              Container(height: 20.0, width: 500.0, color: Colors.black),
              TextField(
                keyboardType: TextInputType.multiline,
                minLines: 1,
                maxLines: 10,
                style: TextStyle(
                  color: Colors.grey,
                ),
                decoration: InputDecoration(
                  focusedBorder: InputBorder.none,
                  hintText: '작성된 룰이 없어요! 북클럽 룰을 자유롭게 적어주세요!',
                  hintStyle: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
