import 'package:beehub_flutter_app/Models/post.dart';
import 'package:flutter/material.dart';

class ShowCommentShare extends StatefulWidget {
  final Post post;
  final List<TextSpan> Function(String) parseComment;
  final Color Function(String? colorString) parseColor;
  final String Function(DateTime?) formatDate;
  const ShowCommentShare({Key? key,required this.post, required this.parseComment, required this.parseColor, required this.formatDate}): super(key: key);

  @override
  State<ShowCommentShare> createState() => _ShowCommentShareState();
}

class _ShowCommentShareState extends State<ShowCommentShare> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin:EdgeInsets.only(left: 5,top: 5) ,
          child:Row(
            children: [
              Padding(padding: EdgeInsets.only(right: 1.0)),
              CircleAvatar(radius: 22,
                child: widget.post.userImage != null &&
                        widget.post.userImage!.isNotEmpty
                    ? Image.network(widget.post.userImage!)
                    : Image.asset(widget.post.userGender == "female"
                        ? "assets/avatar/user_female.png"
                        : "assets/avatar/user_male.png"),
              ),
              SizedBox(
                width: 10.0,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.post.userFullname,
                    style: TextStyle(fontSize: 15.0),
                  ),
                  Text(widget.formatDate(widget.post.usershareCreatedAt), style: TextStyle(fontSize: 15.0))
                ],
              )
            ],
          ),
        ),
        
        widget.post.background != "ffffffff" && widget.post.background != "inherit"
        ?
        Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  height: 250,
                  color:widget.parseColor(widget.post.background),
                  child: Center(
                    child: RichText(
                      text: TextSpan(
                        style: TextStyle(
                          color: widget.parseColor(widget.post.color),
                          fontSize: 20),
                        children:widget.parseComment(widget.post.text),
                      ),
                    )
                  ),
                ),
              ),
            )
          ],
        ):
        Container(
          padding: EdgeInsets.only(right: 280.0,top: 10.0),
          child: RichText(
            text: TextSpan(
              style: TextStyle(fontSize: 18.0,color: Colors.black),
              children:widget.parseComment(widget.post.text)
            ),       
          ),
        ),
        SizedBox(height: 5.0),
        if(widget.post.medias != null)
        Container(
          height: 400.0,
          width: double.infinity,
          child: Image.network(
            widget.post.medias!,
            fit: BoxFit.cover,
          ),
        ),
      ],
    );
  }
}