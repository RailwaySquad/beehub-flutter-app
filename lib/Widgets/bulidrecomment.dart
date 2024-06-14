import 'package:flutter/material.dart';

class BuildReComment extends StatefulWidget {
  const BuildReComment({super.key});

  @override
  State<BuildReComment> createState() => _BuildReCommentState();
}

class _BuildReCommentState extends State<BuildReComment> {
  @override
  Widget build(BuildContext context) {
    return Container( // Đảm bảo rằng Container có giới hạn kích thước rõ ràng
      padding: EdgeInsets.only(left: 20.0),
      child: Column(
        children: [
          Row(
            children: <Widget>[
              Padding(padding: EdgeInsets.only(left: 10.0)),
              Icon(
                Icons.account_circle,
                size: 45.0,
              ),
              SizedBox(
                width: 10.0,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Name',
                        style: TextStyle(fontSize: 12.0),
                      ),
                      Text('Comment', style: TextStyle(fontSize: 12.0)),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Padding(padding: EdgeInsets.only(left: 1.0)),
                      Text(
                        '1 giờ',
                        style: TextStyle(fontSize: 10.0, color: Colors.deepPurpleAccent),
                      ),
                      SizedBox(
                        width: 10.0,
                      ),
                      Text('Trả lời', style: TextStyle(fontSize: 10.0)),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
