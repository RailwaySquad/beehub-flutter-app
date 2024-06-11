import 'package:beehub_flutter_app/Models/comment.dart';
import 'package:beehub_flutter_app/Utils/api_connection/http_post.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

class BuildComment extends StatefulWidget {
  final int postId;
  const BuildComment({super.key, required this.postId}); 
  @override
  State<BuildComment> createState() => _BuildCommentState();
}

class _BuildCommentState extends State<BuildComment> {
   @override
   late Future<List<Comment>> _commentsFuture;

  void initState() {
    super.initState();
    _commentsFuture = ApiService.getComment(widget.postId);
  }
  String formatDate(DateTime? date){
    if(date == null) return '';
    return DateFormat('yyyy-MM-dd HH:mm:ss').format(date);
  }
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Comment>>(
      future: _commentsFuture, 
      builder: (context, snapShot){
        if(snapShot.connectionState == ConnectionState.waiting){
          return const Center(child: CircularProgressIndicator());
        }else if(snapShot.hasError){
          return const Center(child: Text('Faild to load comments'));
        }else if(!snapShot.hasData || snapShot.data!.isEmpty){
          return const Center(child: Text('No comments'));
        }else{
          List<Comment> comments = snapShot.data!;
          return Column(
            children: comments.map((comment){
              return Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Padding(padding: EdgeInsets.only(left: 10.0)),
                      Icon(
                        Icons.account_circle,
                        size: 50.0,
                      ),
                      SizedBox(
                        width: 10.0,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            comment.username!,
                            style: TextStyle(fontSize: 15.0),
                          ),
                          Text(comment.comment, style: TextStyle(fontSize: 15.0))
                        ],
                      )
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Padding(padding: EdgeInsets.only(left: 65.0)),
                      Text(formatDate(comment.createdAt),
                          style:
                              TextStyle(fontSize: 12.0, color: Colors.deepPurpleAccent)),
                      SizedBox(
                        width: 10.0,
                      ),
                      Text('Trả lời', style: TextStyle(fontSize: 12.0))
                    ],
                  ),
                  SizedBox(height: 5.0,),
                  Row(
                    children: [
                      Padding(
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
                                const Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      'Name',
                                      style: TextStyle(fontSize: 12.0),
                                    ),
                                    Text('Comment', style: TextStyle(fontSize: 12.0))
                                  ],
                                )
                              ],
                            ),
                            Row(
                              children: <Widget>[
                                Padding(padding: EdgeInsets.only(left: 65.0)),
                                Text('1 giờ',
                                    style: TextStyle(
                                        fontSize: 10.0, color: Colors.deepPurpleAccent)),
                                SizedBox(
                                  width: 10.0,
                                ),
                                Text('Trả lời', style: TextStyle(fontSize: 10.0))
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 5.0,)
                ],
              );
            }).toList(),
          );
        }
      }
    );

  }
}
