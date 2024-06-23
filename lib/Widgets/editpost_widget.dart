import 'package:beehub_flutter_app/Models/post.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:beehub_flutter_app/Models/postMe.dart';
import 'package:beehub_flutter_app/Provider/db_provider.dart';
import 'package:beehub_flutter_app/Utils/api_connection/http_post.dart';
class EditPostPage extends StatefulWidget {
  final Post post;
  final void Function() onUpdatePostList;
  final List<TextSpan> Function(String) parseComment;
  const EditPostPage({Key? key, required this.post, required this.onUpdatePostList, required this.parseComment}): super(key: key);

  @override
  State<EditPostPage> createState() => _EditPostPageState();
}

class _EditPostPageState extends State<EditPostPage> {
  final TextEditingController _textController = TextEditingController();
  Color _containerColor = Colors.black;
  Color _containerBackground = Colors.white;
  File? _selectedFile;
  final Map<String, String> _tagMap = {};
  @override
  void initState(){
    super.initState();
    _textController.text = _stripTags(widget.post.text);
    _containerColor = parseColor(widget.post.color);
    _containerBackground =  parseBackGround(widget.post.background);
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
  Color parseColor(String? colorString) {
      if (colorString == null || colorString.isEmpty) {
        return Colors.transparent;
      } else if (colorString == "inherit") {
        return Colors.black;
      }else if (colorString == "ff000000") {
        return Colors.black;
      }else {
        if (colorString.startsWith('#')) {
          colorString = 'ff' + colorString.substring(1);
        }
        return Color(int.parse(colorString, radix: 16) + 0xFF000000);
      }
    }
    Color parseBackGround(String? colorString) {
      if (colorString == null || colorString.isEmpty) {
        return Colors.transparent;
      } else if (colorString == "inherit") {
        return Colors.white;
      }else if (colorString == "ffffffff") {
        return Colors.white;
      }else {
        if (colorString.startsWith('#')) {
          colorString = 'ff' + colorString.substring(1);
        }
        return Color(int.parse(colorString, radix: 16) + 0xFF000000);
      }
    }
  void _changeContainerColor(Color color, Color background) {
    setState(() {
      _containerColor = color;
      _containerBackground = background;
    });
  }
  Future<void> _pickFile() async {
    try {
      final pickedFile =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _selectedFile = File(pickedFile.path);
        });
      } else {
        print('No file selected.');
      }
    } catch (e) {
      print('Error picking file: $e');
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurpleAccent,
        centerTitle: true,
        title: const Text(
          'Edit post',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body:SingleChildScrollView(
        child: Container(
          child: Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: 10),
                child: Row(
                  children: <Widget>[
                    CircleAvatar(radius: 25,
                      child: widget.post.userImage != null &&
                              widget.post.userImage!.isNotEmpty
                          ? ClipOval(
                             child: Image.network(widget.post.userImage!))
                          : Image.asset(widget.post.userGender == "female"
                              ? "assets/avatar/user_female.png"
                              : "assets/avatar/user_male.png")
                    ),
                    SizedBox(width: 5.0),
                    Text(widget.post.userFullname)
                  ],
                ),
              ),       
              SizedBox(
                height: 15.0,
              ),
              _containerBackground == Colors.white
                  ? 
                  Container(
                      padding: EdgeInsets.only(left: 10),
                      height: _selectedFile != null || widget.post.medias != null ? 20.0 : 200.0,
                      child: TextField(
                        controller: _textController,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Bạn đang nghĩ gì ?',
                        ),
                      ),
                    )
                  : Container(
                      padding: EdgeInsets.only(top: 85.0),
                      height: 300.0,
                      color: _containerBackground,
                      child: TextField(
                        controller: _textController,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Bạn đang nghĩ gì ?',
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 50.0, horizontal: 10.0),
                        ),
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 20.0, color: _containerColor),
                        maxLines: 5,
                      ),
                    ),
                    if(_selectedFile !=null)
                    Container(
                      padding: EdgeInsets.all(10),
                      child: Image.file(
                        _selectedFile!,
                        height: 300,
                        width: 370,
                        fit: BoxFit.cover,
                      ),
                    ),
                    if(_selectedFile ==null && widget.post.medias != null)
                    Container(
                      padding: EdgeInsets.all(10),
                      child: Image.network(
                        widget.post.medias!,
                        height: 300,
                        width: 370,
                        fit: BoxFit.cover,
                      ),
                    ),
              SizedBox(height: 10.0),
              if(_selectedFile == null)
              Container(
                padding: EdgeInsets.only(left: 10.0),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      SizedBox(
                          child: InkWell(
                        onTap: () {},
                        child: Ink(
                          decoration: const BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5.0)),
                              gradient: LinearGradient(
                                  colors: [Colors.pink, Colors.blueAccent])),
                          child: Container(
                              padding: const EdgeInsets.all(8.0),
                              child: const Text('aa')),
                        ),
                      )),
                      SizedBox(width: 10.0),
                      SizedBox(
                        width: 40.0,
                        height: 35.0,
                        child: ElevatedButton(
                            onPressed: () {
                              _changeContainerColor(Colors.black, Colors.white);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                            ),
                            child: Text('Aa',
                                style: TextStyle(color: Colors.transparent))),
                      ),
                      SizedBox(width: 10.0),
                      SizedBox(
                        width: 40.0,
                        height: 35.0,
                        child: ElevatedButton(
                            onPressed: () {
                              _changeContainerColor(
                                  Colors.white, Colors.deepPurpleAccent);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.deepPurpleAccent,
                            ),
                            child: Text('Aa',
                                style: TextStyle(color: Colors.transparent))),
                      ),
                      SizedBox(width: 10.0),
                      SizedBox(
                        width: 40.0,
                        height: 35.0,
                        child: ElevatedButton(
                            onPressed: () {
                              _changeContainerColor(
                                  Colors.black, Colors.cyanAccent);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.cyanAccent,
                            ),
                            child: Text('Aa',
                                style: TextStyle(color: Colors.transparent))),
                      ),
                      SizedBox(width: 10.0),
                      SizedBox(
                        width: 40.0,
                        height: 35.0,
                        child: ElevatedButton(
                            onPressed: () {
                              _changeContainerColor(
                                  Colors.white, Colors.brown.shade600);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.brown.shade600,
                            ),
                            child: Text('Aa',
                                style: TextStyle(color: Colors.transparent))),
                      ),
                      SizedBox(width: 10.0),
                      SizedBox(
                        width: 40.0,
                        height: 35.0,
                        child: ElevatedButton(
                            onPressed: () {
                              _changeContainerColor(
                                  Colors.white, Colors.pink.shade300);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.pink.shade300,
                            ),
                            child: Text('Aa',
                                style: TextStyle(color: Colors.transparent))),
                      ),
                      SizedBox(width: 10.0),
                      SizedBox(
                        width: 40.0,
                        height: 35.0,
                        child: ElevatedButton(
                            onPressed: () {
                              _changeContainerColor(
                                  Colors.white, Colors.red);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                            ),
                            child: Text('Aa',
                                style: TextStyle(color: Colors.transparent))),
                      ),
                      SizedBox(width: 10.0),
                      SizedBox(
                        width: 40.0,
                        height: 35.0,
                        child: ElevatedButton(
                            onPressed: () {
                              _changeContainerColor(
                                  Colors.black, Colors.lightGreenAccent.shade400);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.lightGreenAccent.shade400,
                            ),
                            child: Text('Aa',
                                style: TextStyle(color: Colors.transparent))),
                      ),
                      SizedBox(width: 10.0),
                      SizedBox(
                        width: 40.0,
                        height: 35.0,
                        child: ElevatedButton(
                            onPressed: () {
                              _changeContainerColor(
                                  Colors.white, Colors.blue.shade900);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue.shade900,
                            ),
                            child: Text('Aa',
                                style: TextStyle(color: Colors.transparent))),
                      ),
                      SizedBox(width: 10.0),
                      SizedBox(
                        width: 40.0,
                        height: 35.0,
                        child: ElevatedButton(
                            onPressed: () {
                              _changeContainerColor(
                                  Colors.white, Colors.blue.shade400);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue.shade400,
                            ),
                            child: Text('Aa',
                                style: TextStyle(color: Colors.transparent))),
                      ),
                      SizedBox(width: 10.0),
                      SizedBox(
                        width: 40.0,
                        height: 35.0,
                        child: ElevatedButton(
                            onPressed: () {
                              _changeContainerColor(
                                  Colors.white, Colors.blueGrey);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blueGrey,
                            ),
                            child: Text('Aa',
                                style: TextStyle(color: Colors.transparent))),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              Container(
                  padding: EdgeInsets.only(left: 10.0),
                  child: GestureDetector(
                    onTap: _pickFile,
                    child: const Row(
                      children: [
                        Icon(
                          Icons.add_link,
                          size: 40.0,
                        ),
                        SizedBox(
                          width: 5.0,
                        ),
                        Text("Attach Media")
                      ],
                    ),
                  )),
                  
              Container(
                padding: EdgeInsets.all(10),
                child: Align(
                  alignment: Alignment.center,
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        try {
                          DatabaseProvider db = new DatabaseProvider();
                          int userId = await db.getUserId();
                          int postId = widget.post.id;
                          int groupId = 0;
                          String restoredText = _restoreTags(_textController.text);
                          PostMe newPost = PostMe(
                              id: postId,
                              text: restoredText,
                              color: _containerColor.value.toRadixString(16),
                              background:
                                  _containerBackground.value.toRadixString(16),
                              user: userId,
                              group:groupId);
                          PostMe editPost;
                          if (_selectedFile != null) {
                            editPost = await ApiService.editPost(newPost,
                                file: _selectedFile);
                          } else {
                            editPost = await ApiService.editPost(newPost);
                          }
                          
                        } catch (e) {
                          print('Error edit post: $e');
                        }
                        widget.onUpdatePostList();
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Edit Post Success'))
                          );
                        Navigator.pop(context);
                      },
                      child: const Text(
                        'Post',
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurpleAccent,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ), 
    );
  }
}