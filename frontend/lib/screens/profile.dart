import 'dart:ui';

import 'package:frontend/global.dart';

import './edit_profile.dart';
import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    final avatarUrl = localRead('avatar_url');

    return Scaffold(
      body: Container(
        child: Column(
          children: [
            Container(
              child: Stack(
                //alignment: Alignment.bottomCenter,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 50.0),
                    child: Container(
                      width: double.infinity,
                      height: 173,
                      color: Colors.red,
                    ),
                  ),
                  Positioned(
                    right: 0,
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: IconButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => EditProfile(),
                            ),
                          );
                        },
                        icon: Icon(
                          Icons.menu,
                          color: Colors.white,
                          size: 36.0,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 120,
                    left: MediaQuery.of(context).size.width / 2.7,
                    child: Container(
                      height: 95,
                      width: 95,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.blue,
                      ),
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                '@username',
                style: TextStyle(
                  fontSize: 24,
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'My Murals',
                style: TextStyle(
                  fontSize: 32,
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 9 / 16,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemBuilder: (context, index) {
                      return Container(
                        width: 107,
                        height: 332,
                        decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.black)),
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
