import 'package:beehub_flutter_app/Models/comment.dart';
import 'package:beehub_flutter_app/Models/recomment.dart';
import 'package:beehub_flutter_app/Provider/db_provider.dart';
import 'package:beehub_flutter_app/Utils/api_connection/http_post.dart';
import 'package:flutter/material.dart';

class BuildReComment extends StatefulWidget {
  final Comment comment;
  final VoidCallback refreshComments;
  final VoidCallback CountComment;
  final VoidCallback fecthReCommentCount;
  final String Function(DateTime?) formatDate;
  final String Function(String) stripTags;
  final String Function(String) restoreTags;
  final List<TextSpan> Function(String) parseComment;
  const BuildReComment({Key? key, required this.comment, required this.refreshComments, required this.CountComment, required this.formatDate, required this.fecthReCommentCount, required this.stripTags, required this.restoreTags, required this.parseComment}):super(key: key);
  @override
  State<BuildReComment> createState() => _BuildReCommentState();
}

class _BuildReCommentState extends State<BuildReComment> {
  late Future<List<ReComment>> _recommentsFuture;
  final Map<int, bool> _isEditReCommentMap = {};
  final Map<int, Future<ReComment?>> _recommentToEditFutureMap = {};
  final Map<int, TextEditingController> _editControllerMap = {};
  final Map<int, String> _tempReCommentMap = {};
  final Map<int, bool> _isSaveButtonEnabledMap = {};
  late int _checkUser;
  FocusNode _recommentTextFieldFocusNode = FocusNode();
  void _initializeUser() async {
    DatabaseProvider db = DatabaseProvider();
    _checkUser = await db.getUserId();
  }
  @override
    void initState(){
    super.initState();
    _recommentsFuture = ApiService.getReComment(widget.comment.id!);
    _initializeUser();
  }
  void _toggleEditReComment(int recommentId) {
    setState(() {
      _isEditReCommentMap[recommentId] = !(_isEditReCommentMap[recommentId] ?? false);
      if (_isEditReCommentMap[recommentId] == true) {
        _recommentToEditFutureMap[recommentId] = ApiService.getReCommentById(recommentId);
      }
    });
  }
  void _toggleEditReCommentAndPop(BuildContext context, int recommentId) {
    _toggleEditReComment(recommentId);
    Navigator.of(context).pop();
  }
  void _checkSaveButtonState(int recommentId) {
    setState(() {
      _isSaveButtonEnabledMap[recommentId] = _editControllerMap[recommentId]!.text.isNotEmpty;
    });
  }
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ReComment>>(
      future: _recommentsFuture, 
      builder: (context,snapShot){
        if(snapShot.connectionState == ConnectionState.waiting){
          return const Center(child: CircularProgressIndicator());
        }else if (snapShot.hasError){
          return const Center(child: Text('Failed to load recomment'));
        }else if (!snapShot.hasData || snapShot.data!.isEmpty){
          return const Center(child: Text(''));
        }else{
          List<ReComment> recomments = snapShot.data!;
          return Container(
            padding: EdgeInsets.only(left: 25.0),
            child: Column(
              children: recomments.map((recomment){
                bool isEditReComment = _isEditReCommentMap[recomment.id] ?? false;
                return Column(
                  children: [
                    Row(
                      children: [
                        Padding(padding: EdgeInsets.only(left: 10.0)),
                          Container(
                          margin: EdgeInsets.only(bottom: isEditReComment ? 45 : 20),
                          child: CircleAvatar( radius: 22,
                            child: recomment.userimage != null &&
                                    recomment.userimage!.isNotEmpty
                                ? Image.network(recomment.userimage!)
                                : Image.asset(recomment.usergender == "female"
                                    ? "assets/avatar/user_female.png"
                                    : "assets/avatar/user_male.png"),
                          ),
                        ),
                        SizedBox(
                          width: 1.0,
                        ),
                        isEditReComment?
                        Expanded(
                          child: FutureBuilder<ReComment?>(
                            future: _recommentToEditFutureMap[recomment.id],
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return const CircularProgressIndicator();
                              } else if (snapshot.hasError) {
                                return const Text('Failed to load comment');
                              } else if (!snapshot.hasData) {
                                return const Text('No comment data');
                              } else {
                                ReComment? recommentToEdit = snapshot.data;
                                if (!_editControllerMap.containsKey(recomment.id)) {
                                  _editControllerMap[recomment.id!] = TextEditingController(
                                    text:widget.stripTags(recomment.reaction),
                                  );
                                  _editControllerMap[recomment.id!]!.addListener(() {
                                    _checkSaveButtonState(recomment.id!);
                                  });
                                }
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      height: 42,
                                      margin: const EdgeInsets.only(top: 1.0),
                                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        border: Border.all(color: Colors.grey),
                                      ),
                                      child: TextField(
                                        focusNode: _recommentTextFieldFocusNode,
                                        controller: _editControllerMap[recomment.id],
                                        decoration: InputDecoration(
                                          hintText: 'Edit your reply comment...',
                                          border: InputBorder.none,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: 200,
                                      margin: EdgeInsets.only(left: 120),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          ElevatedButton(
                                            onPressed: _isSaveButtonEnabledMap[recomment.id] ?? false
                                            ? () async {
                                                try {
                                                  DatabaseProvider db = new DatabaseProvider();
                                                  int userId = await db.getUserId();
                                                  int postId = recommentToEdit!.post;
                                                  int recommentId = recommentToEdit.id!;
                                                  ReComment editReComment = ReComment(
                                                    id: recommentId,
                                                    reaction: widget.restoreTags(_editControllerMap[recommentId]!.text),
                                                    post: postId,
                                                    user: userId,
                                                    postComment: widget.comment.id!
                                                  );
                                                  await ApiService.editReComment(editReComment);
                                                  setState(() {
                                                    _isEditReCommentMap[recommentId] = false;
                                                  });
                                                } catch (e) {
                                                  print('Error edit comment: $e');
                                                }
                                                widget.refreshComments();
                                              }
                                            : null,
                                            style: ElevatedButton.styleFrom(
                                              minimumSize: Size(60, 30), // Adjust the width and height
                                              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5), // Adjust the padding
                                              textStyle: TextStyle(fontSize: 12), // Adjust the font size
                                            ),
                                            child: Text('Save'),
                                          ),
                                          SizedBox(width: 8.0),
                                          ElevatedButton(
                                            onPressed: () {
                                              _toggleEditReComment(recomment.id!);
                                            },
                                            style: ElevatedButton.styleFrom(
                                              minimumSize: Size(60, 30), // Adjust the width and height
                                              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5), // Adjust the padding
                                              textStyle: TextStyle(fontSize: 12), // Adjust the font size
                                            ),
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
                        :Container(
                          margin: EdgeInsets.only(bottom: 5),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ElevatedButton(
                                onPressed: (){
                                  _showModalReComment(context, recomment);
                                }, 
                                child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      recomment.fullname!,
                                      style: TextStyle(fontSize: 13.0,color: Colors.black, fontWeight: FontWeight.bold),
                                    ),
                                    RichText(
                                      text: TextSpan(
                                        style: TextStyle(fontSize: 13.0, color: Colors.black),
                                        children: widget.parseComment(recomment.reaction)
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
                                  Text(widget.formatDate(recomment.createdAt),
                                    style: TextStyle(fontSize: 12.0, color: Colors.deepPurpleAccent)),                              
                                ],
                              ), 
                            ],
                          )
                        ),
                      ],
                    ),SizedBox(height: 5.0),
                  ],
                );
              }).toList(),
            ),
          ); 
        }
      }
    ); 
  }
  void _showModalReComment(BuildContext context, ReComment recomment) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height:_checkUser != recomment.user ? 80: 150, // Đặt chiều cao mong muốn ở đây
          padding: EdgeInsets.all(16.0), // Đặt khoảng cách padding nếu cần thiết
          child: SingleChildScrollView(
            child:
            _checkUser != recomment.user ?
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
                  onPressed: () => _toggleEditReCommentAndPop(context, recomment.id!),
                  child: Center(
                    child: Text(
                      'Edit Reply Comment',
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
                          title: const Text('Confirm Delete Reply Comment'),
                          content: Text('Are you sure you want to delete reply comment ?'),
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
                      int recommentId = recomment.id!;
                      ApiService.deleteReComment(recommentId);
                      Navigator.of(context).pop();
                      widget.refreshComments();
                      widget.CountComment();
                      widget.fecthReCommentCount();
                    }
                  },
                  child: Center(
                    child: Text(
                      'Delete Reply Comment',
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
