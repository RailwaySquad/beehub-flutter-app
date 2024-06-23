import 'package:beehub_flutter_app/Models/comment.dart';
import 'package:beehub_flutter_app/Models/like.dart';
import 'package:beehub_flutter_app/Models/post.dart';
import 'package:beehub_flutter_app/Models/recomment.dart';
import 'package:beehub_flutter_app/Provider/db_provider.dart';
import 'package:beehub_flutter_app/Utils/api_connection/http_post.dart';
import 'package:beehub_flutter_app/Widgets/addpostShare_widget.dart';
import 'package:beehub_flutter_app/Widgets/bulidcomment.dart';
import 'package:beehub_flutter_app/Widgets/showcommentshare.dart';
import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_typedefs/rx_typedefs.dart';
import 'package:intl/intl.dart';


class ShowComment extends StatefulWidget {
  final Post post;
  final int countLike;
  final bool checkLike;
  final VoidCallback fetchCountComment; 
  final VoidCallback fetchCheckLike;
  final VoidCallback fetchCountLike;
  final VoidCallback addLike;
  final VoidCallback removeLike;
  final List<TextSpan> Function(String) parseComment;
  final void Function() onUpdatePostList;
  final Color Function(String? colorString) parseColor;
  const ShowComment({Key? key, required this.post, required this.fetchCountComment, required this.fetchCheckLike,required this.fetchCountLike, required this.countLike, required this.checkLike, required this.addLike, required this.removeLike, required this.parseComment, required this.parseColor, required this.onUpdatePostList}) : super(key: key);

  @override
  State<ShowComment> createState() => _ShowCommentState();
}

class _ShowCommentState extends State<ShowComment> {
  var _userNameController1 = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _isButtonDisabled = true;
  bool _isKeyboardVisible = false;
  bool _isReplying = false;
  String? _replyToUserName;
  int? _replyToCommentId;
  bool _checkLike = false;
  int _countLike = 0;
  final Map<int, int> _reCommentsCountMap = {};
  late Future<List<Comment>> _commentsFuture;
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

    _userNameController1.addListener(_onTextChanged);
    _commentsFuture = ApiService.getComment(widget.post.id);
    _fetchCheckLike();
    _fetchCountLike();
    _fecthReCommentCount();
    widget.fetchCheckLike();
    widget.fetchCountLike();
    _fecthReCommentCount();
  }
  void _addLike() async{
    try{
      DatabaseProvider db = DatabaseProvider();
      int userid = await db.getUserId();
      int postid = widget.post.id;
      Like like = Like(
        enumEmo: '👍',
        user: userid,
        post: postid
      );
      await ApiService.addLike(like);
    }catch(e){
      print('Error to add Like: $e');
    }
    _fetchCountLike();
    _fetchCheckLike();
    widget.fetchCheckLike();  
    widget.fetchCountLike();                             
  }
  void _removeLike() async{
    try{
      DatabaseProvider db = new DatabaseProvider();
      int userid = await db.getUserId();
      int postid = widget.post.id;
      await ApiService.removeLike(userid, postid);
    }catch(e){
      print('Error to remove Like: $e');
    }
    _fetchCountLike();
    _fetchCheckLike();
    widget.fetchCheckLike();  
    widget.fetchCountLike(); 
  }
  void _fetchCountLike() async{
    int count = await ApiService.countLike(widget.post.id);
    setState(() {
      _countLike = count;
    });
  }
  void _fetchCheckLike() async{
    DatabaseProvider db = DatabaseProvider();
    int userid = await db.getUserId();
    int postid = widget.post.id;
    bool checkLikePost = await ApiService.checkLike(userid,postid);
    setState(() {
      _checkLike = checkLikePost;
    });
  }
  void _fecthReCommentCount() {
    _commentsFuture.then((comments) {
      comments.forEach((comment) async {
        int count = await ApiService.countReComment(comment.id!);
        setState(() {
          _reCommentsCountMap[comment.id!] = count;
        });
      });
    });
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
  void _sendReComment() async{
    if(_isButtonDisabled) return;
    try{
      DatabaseProvider db = new DatabaseProvider();
      int userId = await db.getUserId();
      int postId = widget.post.id!;
      ReComment newReComment = ReComment(
        reaction: _userNameController1.text, 
        post: postId, 
        user: userId,
        postComment: _replyToCommentId!,
      );
      await ApiService.createReComment(newReComment);
      _userNameController1.clear();
      
    }catch(e){
      print('Error create comment: $e');
    }
    setState(() {
      _userNameController1.clear();
      _isButtonDisabled = true; // Disable the button again
      _isReplying = false;
    });
    _refreshComments();
    widget.fetchCountComment();
    _fecthReCommentCount();
  }
  void _startReplying(String userName,int commentId){
    setState(() {
       _replyToUserName = userName;
       _replyToCommentId = commentId;
      _isReplying = true;
      FocusScope.of(context).requestFocus(_focusNode);
    });
  }
  void _stopReplying(){
    setState(() {
      _isReplying = false;
    });
  }
  @override
  void dispose() {
    _userNameController1.dispose();
    _focusNode.dispose();
    super.dispose();
  }
  void _refreshComments() {
    setState(() {
      _commentsFuture = ApiService.getComment(widget.post.id);
    });
  }
  @override
  Widget build(BuildContext context) {
   
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        reverse: true, // Cuộn nội dung ngược lại
        child: Column(
          children: [
            Row(
              children: [
                Padding(padding: EdgeInsets.only(right: 1.0)),
                Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(color: Colors.black,width: 0.5),
                                borderRadius: BorderRadius.circular(45.0),
                                image: DecorationImage(
                                  fit: BoxFit.fill,
                                  image: (widget.post.userImage != null) ? NetworkImage(widget.post.userImage!)
                                  :(widget.post.userGender == 'female'?
                                const AssetImage("assets/avatar/user_female.png")  as ImageProvider: const AssetImage("assets/avatar/user_male.png") as ImageProvider
                                ))
                              ),
                              width: 40,
                              height: 40,
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
                  widget.post.share == true ?
                  Container(
                    margin: EdgeInsets.only(left: 30.0,right: 30),
                    padding: EdgeInsets.only(left: 5),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: const Color.fromARGB(255, 133, 131, 131).withOpacity(0.2),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: Offset(0, 3), // Thay đổi offset để điều chỉnh vị trí shadow
                        ),
                      ],
                    ),
                    child: ShowCommentShare(post:widget.post,parseColor:widget.parseColor,parseComment:widget.parseComment,formatDate:formatDate),
                  )
                  :
                  Column(
                    children: [
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
                                  style: TextStyle(color: Colors.black),
                                  children:widget.parseComment(widget.post.text),
                                ),
                              ),))
                        ],
                      )
                    ) ,
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
                    ],
                  ),
                  Container(
                    child: Row(
                      children: <Widget>[
                        Text('👍'),
                        SizedBox(width: 5),
                        Text('$_countLike')
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
                    padding: EdgeInsets.only(left: 20),
                    child:  Row(
                      children: <Widget>[
                        Expanded(
                          child: Center(
                            child: Row(
                              children: <Widget>[
                                _checkLike == true?
                                IconButton(
                                  onPressed: _removeLike,
                                  icon: const Text('👍'))
                                  :IconButton(
                                  onPressed: _addLike,
                                  icon: const Icon(
                                  Icons.thumb_up_alt_outlined),color:Colors.deepPurpleAccent ,) ,
                                const Text("Like")
                              ],
                            ),
                          ),
                        ),
                        //SizedBox(width: 85.0),
                        Expanded(
                          child: const Center(
                            child: Row(
                              children: <Widget>[
                                Icon(Icons.messenger_outline_rounded,
                                    size: 25.0, color: Colors.deepPurpleAccent),
                                Text('Comment')
                              ],
                            ),
                          ),
                        ),
                        //SizedBox(width: 65.0),
                        Expanded(
                          child: Center(
                            child: Row(
                              children: <Widget>[
                                IconButton(
                                  onPressed: (){
                                    ApiService.getPostById(widget.post.id).then((post){
                                      showModalBottomSheet(
                                        isScrollControlled: true,
                                        context: context, 
                                        builder: (BuildContext context){
                                          return AddPostShare(post: post,onUpdatePostList: widget.onUpdatePostList,parseComment:widget.parseComment);
                                        },
                                      );
                                    });
                                  },
                                  icon: const Icon(Icons.share,
                                    size: 25.0, color: Colors.deepPurpleAccent),
                                ),
                                Text('Share')
                              ],
                            ),
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
                            refreshComments:_refreshComments,formatDate:formatDate,CountComment:widget.fetchCountComment,onReply:_startReplying,
                            reCommentsCountMap:_reCommentsCountMap,fecthReCommentCount:_fecthReCommentCount,parseComment:widget.parseComment),
                          ],
                        ),
                      ),
                    ),
                  ),               
                ],
              ),
            ),
          ],
        ),
      ), resizeToAvoidBottomInset: false,
      bottomSheet: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: const Color.fromARGB(255, 133, 131, 131).withOpacity(0.2),
              spreadRadius: 5,
              blurRadius: 7,
              offset: Offset(0, 3), // Thay đổi offset để điều chỉnh vị trí shadow
            ),
          ],
        ),
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (_isReplying && _replyToUserName != null)
                Container(
                  margin: EdgeInsets.only(bottom: 5),
                  child: Row(
                    children: [
                      Text(
                        'Reply to $_replyToUserName',
                        style: TextStyle(fontSize: 12.0, color: Colors.deepPurpleAccent),
                      ),
                      SizedBox(width: 10),
                      GestureDetector(
                        onTap: _stopReplying,
                        child: Text(
                          'Cancel',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      )
                    ],
                  ),
                ),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _userNameController1,
                      focusNode: _focusNode,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Color.fromARGB(255, 248, 247, 247),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        hintText: _isReplying ? '$_replyToUserName :Reply comment' : 'Input Comment',
                        contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                      ),
                    ),
                  ),
                  SizedBox(width: 10.0),
                  ElevatedButton(
                    onPressed: _isButtonDisabled
                        ? null
                        : _isReplying
                            ? _sendReComment
                            : _sendComment,
                    child: Icon(Icons.send),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),    
    );
  }


}
