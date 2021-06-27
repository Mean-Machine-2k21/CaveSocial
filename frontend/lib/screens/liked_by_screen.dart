import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class LikedByScreen extends StatelessWidget {
  final List<String> items;

  LikedByScreen({Key? key, required this.items}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final title = 'Liked By ';

    return MaterialApp(
      title: title,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          title: Text(
            title,
            style: TextStyle(color: Colors.black),
          ),
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
          ),
        ),
        body: ListView.builder(
          itemCount: 60,
          itemBuilder: (context, index) {
            return Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Colors.grey),
                ),
              ),
              child: ListTile(
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                title: Container(
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundImage: NetworkImage('url'),
                        backgroundColor: Colors.red,
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Text(
                        '@' + 'adaind',
                        maxLines: 1,
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
