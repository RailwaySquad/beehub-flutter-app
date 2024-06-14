import 'package:beehub_flutter_app/Models/comment.dart';
import 'package:beehub_flutter_app/Models/post.dart';
import 'package:beehub_flutter_app/Provider/db_provider.dart';
import 'package:beehub_flutter_app/Utils/api_connection/http_post.dart';
import 'package:beehub_flutter_app/Widgets/bulidcomment.dart';
import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_typedefs/rx_typedefs.dart';
import 'package:intl/intl.dart';


class ShowComment extends StatefulWidget {
  final Post post;
  final VoidCallback fetchCountComment; 
  const ShowComment({Key? key, required this.post, required this.fetchCountComment}) : super(key: key);

  @override
  State<ShowComment> createState() => _ShowCommentState();
}

class _ShowCommentState extends State<ShowComment> {
  var _userNameController1 = TextEditingController();
  var _userNameController2 = TextEditingController();
  bool _isButtonDisabled = true;
  bool _isKeyboardVisible = false;
  late Future<List<Comment>> _commentsFuture;
  final List<Map<String, dynamic>> _allUsers = [
    {"id": 1, "name": "Andy", "age": 29},
    {"id": 2, "name": "Aragon", "age": 40},
    {"id": 3, "name": "Bob", "age": 5},
    {"id": 4, "name": "Barbara", "age": 35},
    {"id": 5, "name": "Candy", "age": 21},
    {"id": 6, "name": "Colin", "age": 55},
    {"id": 7, "name": "Audra", "age": 30},
    {"id": 8, "name": "Banana", "age": 14},
    {"id": 9, "name": "Caversky", "age": 100},
    {"id": 10, "name": "Becky", "age": 32},
  ];
  List<Map<String, dynamic>> _foundUsers = [];
  String? _activeTextField;
  String formatDate(DateTime? date){
    if(date == null) return '';
    final now = DateTime.now();
    final difference = now.difference(date);
    if(difference.inDays > 365){
      final years = (difference.inDays / 365).floor();
      return '$years year ago'; 
    }else if(difference.inDays >= 30){
      final months = (difference.inDays / 30).floor();
      return '$months month ago';
    }else if(difference.inDays >= 1){
      return '${difference.inDays} day ago';
    }else if(difference.inHours >= 1){
      return '${difference.inHours} hours ago';
    }else if(difference.inMinutes >= 1){
      return '${difference.inMinutes} minutes ago';
    }else{
      return 'Now' ;
    }
  }
  @override
  void initState() {
    super.initState();
    _foundUsers = _allUsers;
    _userNameController2.addListener(() {
      if (_activeTextField == 'comment2') {
        _userNameController1.text = _userNameController2.text;
      }
    });
    _userNameController1.addListener(_onTextChanged);
    _commentsFuture = ApiService.getComment(widget.post.id);
  }
  void _handleFocusChange(bool hasFocus){
    setState(() {
      _isKeyboardVisible = hasFocus;
    });
  }
  void _onTextChanged(){
    setState(() {
      _isButtonDisabled = _userNameController1.text.isEmpty;
    });
  }
  void _sendComment() async{
    if(_isButtonDisabled) return;
    try{
      DatabaseProvider db = new DatabaseProvider();
      int userId = await db.getUserId();
      int postId = widget.post.id!;
      Comment newComment = Comment(
        comment: _userNameController1.text, 
        post: postId, 
        user: userId
      );
      await ApiService.createComment(newComment);
      _userNameController1.clear();
      
    }catch(e){
      print('Error create comment: $e');
    }
    setState(() {
      _userNameController1.clear();
      _isButtonDisabled = true; // Disable the button again
    });
    _refreshComments();
    widget.fetchCountComment();
  }
  bool _showList = false;
  void _runFilter(String enteredKeyword) {
    List<Map<String, dynamic>> results = [];
    if (enteredKeyword.isEmpty) {
      results = _allUsers;
      _showList = false;
    } else {
      final List<String> keyWords = enteredKeyword.split(' ');
      final String lastKey = keyWords.last;
      if (lastKey.startsWith('@')) {
        final String filterKeyword = lastKey.substring(1);
        results = _allUsers
            .where((user) => user["name"]
                .toLowerCase()
                .contains(filterKeyword.toLowerCase()))
            .toList();
        _showList = true;
      } else {
        results = _allUsers;
        _showList = false;
      }
    }
    setState(() {
      _foundUsers = results;
    });
  }
  void _refreshComments() {
    setState(() {
      _commentsFuture = ApiService.getComment(widget.post.id);
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Padding(
        padding: EdgeInsets.only(top: 1.0),
      )),
      body: SingleChildScrollView(
        reverse: true, // Cuộn nội dung ngược lại
        child: Column(
          children: [
            Row(
              children: [
                Padding(padding: EdgeInsets.only(right: 1.0)),
                Icon(
                  Icons.account_circle,
                  size: 50.0,
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
                    Text(formatDate(widget.post.createdAt), style: TextStyle(fontSize: 15.0))
                  ],
                )
              ],
            ),
            SizedBox(height: 5.0,),
            Container(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Column(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(right: 320.0),
                    child: Text(
                      widget.post.text,
                      style: TextStyle(fontSize: 18.0),
                    ),
                  ),
                  SizedBox(height: 10.0),
                  if(widget.post.medias != null)
                  Container(
                    height: 400.0,
                    width: double.infinity,
                    child: Image.network(
                      widget.post.medias!,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Container(
                    child: const Row(
                      children: <Widget>[
                        Icon(
                          Icons.favorite,
                          size: 15.0,
                        ),
                        Text('1000')
                      ],
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    child: Divider(
                      color: Colors.grey,
                    ),
                  ),
                  Container(
                    child: const Row(
                      children: <Widget>[
                        SizedBox(width: 10,),
                        Center(
                          child: Row(
                            children: <Widget>[
                              Icon(Icons.thumb_up_alt_outlined,
                                  size: 25.0, color: Colors.deepPurpleAccent),
                              Text('Like')
                            ],
                          ),
                        ),
                        SizedBox(width: 95.0),
                        Center(
                          child: Row(
                            children: <Widget>[
                              Icon(Icons.messenger_outline_rounded,
                                  size: 25.0, color: Colors.deepPurpleAccent),
                              Text('Comment')
                            ],
                          ),
                        ),
                        SizedBox(width: 95.0),
                        Center(
                          child: Row(
                            children: <Widget>[
                              Icon(Icons.share,
                                  size: 25.0, color: Colors.deepPurpleAccent),
                              Text('Share')
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    child: Divider(
                      color: Colors.grey,
                    ),
                  ),
                  Container(
                    child: SizedBox(
                      height: widget.post.medias!=null ? 200: 350.0, // Đặt kích thước cố định
                      child: SingleChildScrollView(
                        child: Column(
                          children: <Widget>[
                            BuildComment(postId:widget.post.id!, onFocusChange: _handleFocusChange,commentsFuture:_commentsFuture,
                            refreshComments:_refreshComments,formatDate:formatDate,CountComment:widget.fetchCountComment),
                          ],
                        ),
                      ),
                    ),
                  ),
                  if (_showList) // Hiển thị danh sách chỉ khi _showList là true
                    Container(
                      child: _buildListUser(),
                    ),
                  
                ],
              ),
            ),
          ],
        ),
      ),bottomNavigationBar: Container(
        color: Colors.white,
        child: Padding(
          padding: EdgeInsets.only(
            bottom: _isKeyboardVisible ? 0 : MediaQuery.of(context).viewInsets.bottom,
          ),
          child: BottomAppBar(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _userNameController1,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        hintText: 'Input Comment',
                        contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                      ),
                    ),
                  ),
                  SizedBox(width: 10.0),
                  ElevatedButton(
                    onPressed: _isButtonDisabled ? null : _sendComment,
                    child: Icon(Icons.send),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
        
    );
  }

  Widget _buildListUser() {
    return SizedBox(
      height: 200.0,
      child: _foundUsers.isNotEmpty
          ? ListView.builder(
              itemCount: _foundUsers.length,
              itemBuilder: (context, index) {
                if (index < _foundUsers.length) {
                  return Card(
                    key: ValueKey(_foundUsers[index]["id"]),
                    child: ListTile(
                      title: Text(
                        _foundUsers[index]['name'],
                        style: const TextStyle(color: Colors.black),
                      ),
                      onTap: () {
                        _pasteUserName(_foundUsers[index]['name'],
                            _foundUsers[index]['id']);
                        setState(() {
                          _showList =
                              false; // Ẩn danh sách khi người dùng được chọn
                        });
                      },
                    ),
                  );
                } else {
                  return SizedBox
                      .shrink(); // Trả về widget rỗng nếu chỉ mục không hợp lệ
                }
              },
            )
          : const Center(
              child: Text('No results found'),
            ),
    );
  }


  void _setActiveTextField(String textFiel) {
    setState(() {
      _activeTextField = textFiel;
    });
  }

  void _pasteUserName(String userName, int userId) {
    if (_activeTextField == 'comment1') {
      String currentText = _userNameController1.text;
      List<String> parts = currentText.split(' ');
      if (parts.isNotEmpty && parts.last.startsWith('@')) {
        parts.removeLast();
      }
      String newText = parts.join(' ').trim() + "tag=$userName&link=$userId";
      setState(() {
        _userNameController1.text = newText;
        _userNameController1.selection = TextSelection.fromPosition(
            TextPosition(offset: _userNameController1.text.length));
      });
    } else if (_activeTextField == 'comment2') {
      String currentText = _userNameController2.text;
      List<String> parts = currentText.split(' ');
      String newText = currentText + ' ' + userName;
      setState(() {
        _userNameController2.text = newText;
        _userNameController2.selection = TextSelection.fromPosition(
            TextPosition(offset: _userNameController2.text.length));
        String newText1 = parts.join(' ').trim() + "tag=$userName&link=$userId";
        _userNameController1.text = newText1;
      });
    }
  }
}
