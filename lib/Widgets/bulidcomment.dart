import 'package:beehub_flutter_app/Models/comment.dart';
import 'package:beehub_flutter_app/Provider/db_provider.dart';
import 'package:beehub_flutter_app/Utils/api_connection/http_post.dart';
import 'package:beehub_flutter_app/Widgets/bulidrecomment.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

class BuildComment extends StatefulWidget {
  final int postId;
  final String Function(DateTime?) formatDate;
  final Function(bool) onFocusChange;
  final commentsFuture;
  final VoidCallback refreshComments;
  final VoidCallback CountComment;
  final VoidCallback fecthReCommentCount;
  final Function(String,int) onReply;
  final Map<int,int> reCommentsCountMap;
  final List<TextSpan> Function(String) parseComment;
  const BuildComment({Key? key, required this.postId, required this.onFocusChange, required this.commentsFuture,required this.refreshComments,required this.formatDate, required this.CountComment, required this.onReply, required this.fecthReCommentCount, required this.reCommentsCountMap, required this.parseComment}):super(key: key);

  @override
  State<BuildComment> createState() => _BuildCommentState();
}

class _BuildCommentState extends State<BuildComment> {
  final Map<int, bool> _isEditCommentMap = {};
  final Map<int, Future<Comment?>> _commentToEditFutureMap = {};
  final Map<int, TextEditingController> _editControllerMap = {};
  final Map<int, String> _tempCommentMap = {};
  final Map<int, bool> _isSaveButtonEnabledMap = {};
  final Map<int, bool> _isShowReCommentMap = {};
  final Map<String, String> _tagMap = {};
  late int _checkUser;
  FocusNode _commentTextFieldFocusNode = FocusNode();
  void _initializeUser() async {
    DatabaseProvider db = DatabaseProvider();
    _checkUser = await db.getUserId();
  }
  void _toggleEditComment(int commentId) {
    setState(() {
      _isEditCommentMap[commentId] = !(_isEditCommentMap[commentId] ?? false);
      if (_isEditCommentMap[commentId] == true) {
        _commentToEditFutureMap[commentId] = ApiService.getCommentById(commentId);
      }
    });
  }
  void _toggleShowReComment(int commentId) {
    setState(() {
      _isShowReCommentMap[commentId] = !(_isShowReCommentMap[commentId] ?? false);
    });
  }
  void _toggleEditCommentAndPop(BuildContext context, int commentId) {
    _toggleEditComment(commentId);
    Navigator.of(context).pop();
  }
  @override
  void initState() {
    super.initState();
    widget.commentsFuture;
    _commentTextFieldFocusNode.addListener(_onFocusChange);
    widget.fecthReCommentCount();
    _initializeUser();
  }
  @override
  void dispose() {
    _commentTextFieldFocusNode.removeListener(_onFocusChange);
    _commentTextFieldFocusNode.dispose();
    _editControllerMap.forEach((key, controller) {
      controller.dispose();
    });
    super.dispose();
  }
  String _stripTags(String text) {
    final regex = RegExp(r'tag=(.*?)&link=(.*?)(?=\s+|$)');
    return text.replaceAllMapped(regex, (match){
      String tag = match.group(1) ?? '';
      String link = match.group(2) ?? '';
      String displayText = tag;
      _tagMap[displayText] = 'tag=$tag&link=$link';
      return displayText;
    });
  }
  String _restoreTags(String text){
    String restoredText = text;
    _tagMap.forEach((displayText, tagLink) {
      restoredText = restoredText.replaceAll(displayText, tagLink);
    });
    return restoredText;
  }
  void _onFocusChange() {
    widget.onFocusChange(_commentTextFieldFocusNode.hasFocus);
    if (!_commentTextFieldFocusNode.hasFocus) {
      _editControllerMap.forEach((commentId, controller) {
        _tempCommentMap[commentId] = controller.text;
      });
    }
  }
  void _checkSaveButtonState(int commentId) {
    setState(() {
      _isSaveButtonEnabledMap[commentId] = _editControllerMap[commentId]!.text.isNotEmpty;
    });
  }
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Comment>>(
      future: widget.commentsFuture,
      builder: (context, snapShot) {
        if (snapShot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapShot.hasError) {
          return const Center(child: Text('Failed to load comments'));
        } else if (!snapShot.hasData || snapShot.data!.isEmpty) {
          return const Center(child: Text('No comments'));
        } else {
          List<Comment> comments = snapShot.data!;
          return Column(
            children: comments.map((comment) {
              bool isEditComment = _isEditCommentMap[comment.id] ?? false;
              bool isShowReComment = _isShowReCommentMap[comment.id] ?? false;
              int reCommentCount = widget.reCommentsCountMap[comment.id] ?? 0;
              return Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Padding(padding: EdgeInsets.only(left: 10.0)),
                      Container(
                        margin: EdgeInsets.only(bottom: isEditComment ? 40 : 10),
                        child: CircleAvatar( radius: 22,
                          child: comment.userimage != null &&
                                  comment.userimage!.isNotEmpty
                              ? Image.network(comment.userimage!)
                              : Image.asset(comment.usergender == "female"
                                  ? "assets/avatar/user_female.png"
                                  : "assets/avatar/user_male.png"),
                        ),
                      ),
                      const SizedBox(
                        width: 1.0,
                      ),
                      isEditComment
                      ? Expanded(
                          child: FutureBuilder<Comment?>(
                            future: _commentToEditFutureMap[comment.id],
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return const CircularProgressIndicator();
                              } else if (snapshot.hasError) {
                                return const Text('Failed to load comment');
                              } else if (!snapshot.hasData) {
                                return const Text('No comment data');
                              } else {
                                Comment? commentToEdit = snapshot.data;
                                if (!_editControllerMap.containsKey(comment.id)) {
                                   _editControllerMap[comment.id!] = TextEditingController(
                                     text: _stripTags(comment.comment),
                                  );
                                  _editControllerMap[comment.id!]!.addListener(() {
                                    _checkSaveButtonState(comment.id!);
                                  });
                                }
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.only(top: 10.0),
                                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        border: Border.all(color: Colors.grey),
                                      ),
                                      child: TextField(
                                        focusNode: _commentTextFieldFocusNode,
                                        controller: _editControllerMap[comment.id],
                                        decoration: InputDecoration(
                                          hintText: 'Edit your comment...',
                                          border: InputBorder.none,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: 200,
                                      margin: EdgeInsets.only(left: 140),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          ElevatedButton(
                                            onPressed: _isSaveButtonEnabledMap[comment.id] ?? false
                                            ? () async {
                                                try {
                                                  DatabaseProvider db = new DatabaseProvider();
                                                  int userId = await db.getUserId();
                                                  int postId = commentToEdit!.post;
                                                  int commentId = commentToEdit.id!;
                                                  Comment editComment = Comment(
                                                    id: commentId,
                                                    comment: _restoreTags(_editControllerMap[commentId]!.text),
                                                    post: postId,
                                                    user: userId,
                                                  );
                                                  await ApiService.editComment(editComment);
                                                  setState(() {
                                                    _isEditCommentMap[commentId] = false;
                                                  });
                                                } catch (e) {
                                                  print('Error edit comment: $e');
                                                }
                                                widget.refreshComments();
                                              }
                                            : null,
                                            child: Text('Save'),
                                          ),
                                          SizedBox(width: 8.0),
                                          ElevatedButton(
                                            onPressed: () {
                                              _toggleEditComment(comment.id!);
                                            },
                                            child: Text('Cancel'),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                );
                              }
                            },
                          ),
                        )
                      : Container(
                          margin: EdgeInsets.only(bottom: 5),
                          height: 80,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 15),
                              ElevatedButton(
                                onPressed: () {
                                  _showModalComment(context, comment);
                                },
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      comment.fullname!,
                                      style: TextStyle(fontSize: 15.0, color: Colors.black, fontWeight: FontWeight.bold),
                                    ),
                                     RichText(
                                      text: TextSpan(
                                        style: TextStyle(fontSize: 15.0, color: Colors.black),
                                        children: widget.parseComment(comment.comment)
                                      )
                                    )
                                  ],
                                ),
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                  backgroundColor: Colors.grey.shade200,
                                  elevation: 0,
                                  shadowColor: Colors.transparent,
                                  side: BorderSide.none,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                ),
                              ),
                              Row(
                                children: <Widget>[
                                  Padding(padding: EdgeInsets.only(left: 5.0)),
                                  Text(widget.formatDate(comment.createdAt),
                                      style: TextStyle(fontSize: 12.0, color: Colors.deepPurpleAccent)),
                                  SizedBox(
                                    width: 10.0,
                                  ),GestureDetector(
                                    onTap:()=> widget.onReply(comment.fullname!,comment.id!),
                                    child: Text('Trả lời', style: TextStyle(fontSize: 12.0)),
                                  )
                                  
                                ],
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                  if(reCommentCount!= 0)
                  Container(
                    margin: EdgeInsets.only(right: 220,bottom: 1),
                    child: GestureDetector(
                      onTap: () => _toggleShowReComment(comment.id!),
                      child: Text('See $reCommentCount reply'),
                    )  
                  ),
                  if(isShowReComment)
                  Container(
                    child: BuildReComment(comment:comment,refreshComments:widget.refreshComments,CountComment:widget.CountComment,formatDate:widget.formatDate,
                    fecthReCommentCount:widget.fecthReCommentCount,stripTags:_stripTags,restoreTags:_restoreTags,parseComment:widget.parseComment),
                  ),
                ],
              );
            }).toList(),
          );
        }
      },
    );
  }
  void _showModalComment(BuildContext context, Comment comment) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: _checkUser != comment.user ?75 :150, // Đặt chiều cao mong muốn ở đây
          padding: EdgeInsets.all(16.0), // Đặt khoảng cách padding nếu cần thiết
          child: SingleChildScrollView(
            child:
            _checkUser != comment.user ?
            Column(
              children: [
                ElevatedButton(
                  onPressed: () {},
                  child: Center(
                    child: Text(
                      'Report Comment',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    backgroundColor: Colors.grey.shade200, // Bỏ màu nền mặc định
                    elevation: 0, // Bỏ shadow
                    shadowColor: Colors.transparent, // Bỏ shadow màu
                    side: BorderSide.none, // Bỏ border
                    shape: RoundedRectangleBorder( // Bỏ border radius mặc định
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                )
              ]
            )
            :Column(
              children: [
                ElevatedButton(
                  onPressed: () => _toggleEditCommentAndPop(context, comment.id!),
                  child: Center(
                    child: Text(
                      'Edit Comment',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    backgroundColor: Colors.grey.shade200, // Bỏ màu nền mặc định
                    elevation: 0, // Bỏ shadow
                    shadowColor: Colors.transparent, // Bỏ shadow màu
                    side: BorderSide.none, // Bỏ border
                    shape: RoundedRectangleBorder( // Bỏ border radius mặc định
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    bool confirmDelete = await showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Confirm Delete Comment'),
                          content: Text('Are you sure you want to delete comment ?'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop(false);
                              },
                              child: Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop(true);
                              },
                              child: Text('Ok'),
                            ),
                          ],
                        );
                      },
                    );
                    if (confirmDelete == true) {
                      int commentId = comment.id!;
                      ApiService.deleteComment(commentId);
                      Navigator.of(context).pop();
                      widget.refreshComments();
                      widget.CountComment();
                    }
                  },
                  child: Center(
                    child: Text(
                      'Delete Comment',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    backgroundColor: Colors.grey.shade200,
                    elevation: 0, // Bỏ shadow
                    shadowColor: Colors.transparent, // Bỏ shadow màu
                    side: BorderSide.none, // Bỏ border
                    shape: RoundedRectangleBorder( // Bỏ border radius mặc định
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
