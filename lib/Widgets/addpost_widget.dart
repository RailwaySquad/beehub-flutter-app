import 'dart:io';
import 'package:beehub_flutter_app/Models/post.dart';
import 'package:beehub_flutter_app/Models/postMe.dart';
import 'package:beehub_flutter_app/Provider/db_provider.dart';
import 'package:beehub_flutter_app/Utils/api_connection/http_post.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CreatePostPage extends StatefulWidget {
  @override
  _CreatePostPageState createState() => _CreatePostPageState();
}

class _CreatePostPageState extends State<CreatePostPage> {
  final TextEditingController _textController = TextEditingController();
  Color _containerColor = Colors.black;
  Color _containerBackground = Colors.white;
  File? _selectedFile;
  void _changeContainerColor(Color color, Color background) {
    setState(() {
      _containerColor = color;
      _containerBackground = background;
    });
  }
  Future<void> _pickFile() async {
    try {
      final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
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
          'Tạo bài viết',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            const Row(
              children: <Widget>[
                Icon(
                  Icons.account_circle,
                  size: 60.0,
                ),
                Text('Name')
              ],
            ),
            SizedBox(
              height: 10.0,
            ),
            _containerBackground == Colors.white
                ? Container(
                    padding: EdgeInsets.only(left: 10),
                    height: 200.0,
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
            SizedBox(height: 10.0),
            Container(
              padding: EdgeInsets.only(left: 10.0),
              child: Row(
                children: [
                  SizedBox(
                    width: 40.0,
                    height: 35.0,
                    child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                        ),
                        child: Text(
                          'Aa',
                          style: TextStyle(color: Colors.yellow),
                        )),
                  ),
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
                          _changeContainerColor(Colors.black, Colors.amberAccent);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.amberAccent,
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
                          _changeContainerColor(Colors.black, Colors.pinkAccent);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.pinkAccent,
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
                          _changeContainerColor(Colors.black, Colors.cyanAccent);
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
                          _changeContainerColor(Colors.white, Colors.blueGrey);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueGrey,
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
                          _changeContainerColor(Colors.black, Colors.redAccent);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent,
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
                          _changeContainerColor(Colors.black, Colors.limeAccent);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.limeAccent,
                        ),
                        child: Text('Aa',
                            style: TextStyle(color: Colors.transparent))),
                  ),
                ],
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
                      try{
                        DatabaseProvider db = new DatabaseProvider();
                        int userId = await db.getUserId();

                        PostMe newPost = PostMe(
                          text: _textController.text,
                          color: _containerColor.value.toRadixString(16),
                          background: _containerBackground.value.toRadixString(16),
                          user:  userId
                        );
                        PostMe createdPost;
                        if (_selectedFile != null) {
                          createdPost = await ApiService.createPost( newPost, media: _selectedFile);
                        } else {
                          createdPost = await ApiService.createPost( newPost);
                        }
                        Navigator.pop(context);
                      }catch(e){
                        print('Error creating post: $e');
                      }
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
    );
  }
}
