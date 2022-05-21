import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'Lobby.dart';

class fullscreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // 원하는 방향으로 화면 고정
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);

    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Container(
          child: Center(
            child: Stack(
              children: [
                Container(
                  alignment: Alignment.center,
                  child: Image.asset('lib/images/Map.jpg'),
                ),
                Positioned(
                  left: 25,
                  bottom: 25,
                  child: Image.asset('lib/images/Blue_Egg.jpg',
                      height: 35, width: 35),
                ),
                Positioned(
                  left: 25,
                  bottom: 15,
                  child: Image.asset('lib/images/Red_Egg.jpg',
                      height: 35, width: 35),
                ),
                Positioned(
                  right: 75,
                  bottom: 20,
                  child: Image.asset('lib/images/Green_Egg.jpg',
                      height: 35, width: 35),
                ),
                Positioned(
                  left: 20,
                  top: 30,
                  child: IconButton(
                    icon:
                        Icon(CupertinoIcons.chevron_back, color: Colors.white),
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LobbyPage(),
                        ),
                      );
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
