import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

class FeedComment extends StatefulWidget {
  const FeedComment({Key? key}) : super(key: key);

  @override
  _FeedCommentState createState() => _FeedCommentState();
}

class _FeedCommentState extends State<FeedComment> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                top: 32.0,
                left: 8.0,
              ),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: Icon(
                      Ionicons.md_arrow_round_back,
                    ),
                  ),
                  Text(
                    'Comments',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 1,
                      childAspectRatio: 9 / 12,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemCount: 10,
                    itemBuilder: (context, index) {
                      return Container(
                        child: Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CircleAvatar(
                                  radius: 20,
                                  backgroundImage: NetworkImage(
                                      'https://upload.wikimedia.org/wikipedia/commons/thumb/5/58/Alia_Bhatt_grace_the_screening_of_Netflix%E2%80%99s_film_Guilty_%282%29_%28cropped%29.jpg/220px-Alia_Bhatt_grace_the_screening_of_Netflix%E2%80%99s_film_Guilty_%282%29_%28cropped%29.jpg'),
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                Text(
                                  'Alia Bhatt',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  '42 min ago',
                                  style: TextStyle(
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                            Stack(
                              alignment: Alignment.topRight,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                    top: 12.0,
                                    right: 16.0,
                                  ),
                                  child: Container(
                                    width: 307,
                                    height: 432,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        image: DecorationImage(
                                          image: NetworkImage(
                                            'https://res.cloudinary.com/meanmachine/image/upload/v1624571586/profileImages/mwubbpf25oohhapp8vof.jpg',
                                          ),
                                          fit: BoxFit.cover,
                                        ),
                                        borderRadius: BorderRadius.circular(30),
                                        border:
                                            Border.all(color: Colors.black)),
                                  ),
                                ),
                                Container(
                                  width: 60,
                                  height: 30,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: Icon(
                                          MaterialIcons.favorite,
                                          color: Colors.red,
                                        ),
                                      ),
                                      Text('23'),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
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
