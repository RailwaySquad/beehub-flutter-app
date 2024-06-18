import 'package:beehub_flutter_app/Models/post.dart';
import 'package:beehub_flutter_app/Provider/user_provider.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'dart:developer';

class PostShare extends StatefulWidget {
  final Post post;
  final Color Function(String? colorString) parseColor;
  final List<TextSpan> Function(String) parseComment;
  final String Function(DateTime?) formatDate;
  const PostShare({Key? key, required this.post, required this.parseColor, required this.parseComment, required this.formatDate}):super(key: key);

  @override
  State<PostShare> createState() => _PostShareState();
}

class _PostShareState extends State<PostShare> {
  
  @override
  Widget build(BuildContext context) {
    return Column(
        children: [
          SizedBox(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                SizedBox(
                      child: Row(
                        children: <Widget>[
                          //Avatar
                          CircleAvatar(
                            child: widget.post.usershareImage != null &&
                                    widget.post.usershareImage!.isNotEmpty
                                ? Image.network(widget.post.usershareImage!)
                                : Image.asset(widget.post.usershareGender == "female"
                                    ? "assets/avatar/user_female.png"
                                    : "assets/avatar/user_male.png"),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          //Fullname
                          SizedBox(
                              child: widget.post.usershareGroupName != null &&
                                      widget.post.usershareGroupName!.isNotEmpty
                                  ? Column(
                                     crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Row(children: [
                                          Text(
                                            widget.post.usershareFullname!,
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleMedium!
                                                .copyWith(
                                                    fontWeight: FontWeight.bold),
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                            textAlign: TextAlign.left,
                                          ),
                                          Text.rich(TextSpan(
                                              text: " in ",
                                              children: <InlineSpan>[
                                                TextSpan(
                                                  text: widget.post.usershareGroupName!,
                                                  style: const TextStyle(
                                                      fontWeight: FontWeight.bold),recognizer: TapGestureRecognizer()..onTap = () => Get.toNamed("/group/${widget.post.usershareGroupId!}")
                                                )
                                              ]))
                                        ]),
                                        Text(widget.formatDate(widget.post.usershareCreatedAt))
                                    ],
                                  )
                                  : InkWell(
                                     onTap: (){
                                      Provider.of<UserProvider>(context, listen: false).setUsername(widget.post.usershareUserName!);
                                      log(Provider.of<UserProvider>(context, listen: false).username!);
                                      Get.toNamed("/userpage/${widget.post.usershareUserName!}");
                                    },
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          widget.post.usershareFullname!,
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium!
                                              .copyWith(
                                                  fontWeight: FontWeight.bold),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                          textAlign: TextAlign.left,
                                        ),
                                        Text(widget.formatDate(widget.post.usershareCreatedAt))
                                      ],
                                    ),
                                  ))
                        ],
                      ),
                    ),
                widget.post.background != "ffffffff" &&
                        widget.post.background != "inherit"
                    ? Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: SingleChildScrollView(
                              child: Container(
                                height: 200,
                                margin: EdgeInsets.only(right: 10,bottom: 10),
                                color: widget.parseColor(widget.post.background),
                                child: Center(
                                  child: RichText(
                                    text: TextSpan(
                                      style: TextStyle(
                                        color:
                                          widget.parseColor(widget.post.color),
                                        fontSize: 20),
                                      children:widget.parseComment(widget.post.text),
                                    ),
                                  )
                                ),
                              ),
                            ),
                          )
                        ],
                      )
                    :Container(
                      height: 30,
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                              child: SingleChildScrollView(
                                child: RichText(
                                text: TextSpan(
                                  style: Theme.of(context).textTheme.bodyText2,
                                  children:widget.parseComment(widget.post.text),
                                ),
                              ),))
                        ],
                      )
                    )  
              ],
            ),
          ),
          if (widget.post.medias != null &&
            widget.post.medias!.isNotEmpty)
          Image.network(
            widget.post.medias!,
            fit: BoxFit.cover,
          ),
        ],
      );
  }
}