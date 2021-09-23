import 'dart:io';

import 'package:firepost/models/post_model.dart';
import 'package:firepost/pages/rtdb_service.dart';
import 'package:firepost/pages/stor_service.dart';
import 'package:firepost/service/prefs_service.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class DetailPage extends StatefulWidget {
  const DetailPage({Key key}) : super(key: key);
  static final String id = "detail_page";

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {

  bool isLoading = false;

  File _image;
  final picker = ImagePicker();

  var titleController = TextEditingController();
  var contentController = TextEditingController();

  _addPost() async{

    String title = titleController.text.toString().trim();
    String  content = contentController.text.toString().trim();
    if(title.isEmpty || content.isEmpty) return ;
    if(_image == null) return;

    _apiUploadImage(title, content);
  }

  void _apiUploadImage(String title, String content){
    setState(() {
      isLoading = true;
    });
    StoreService.uploadImage(_image).then((img_url) => {
      _apiAddPost(title, content, img_url),
    });
  }

  _apiAddPost( String title, String content, String img_url) async{
    var id = await Prefs.loadUserId();
    RTDBService.addPost(new Post(id, title, content, img_url)).then((response) => {
      _respAddPost()
    });
  }

  _respAddPost(){
    setState(() {
      isLoading = false;
    });
    Navigator.of(context).pop({"data" : "done"});
  }

  _getImage() async{
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if(pickedFile != null){
        _image = File(pickedFile.path);
      }else{
        print("No image selected");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
    appBar:  AppBar(
      title: Text("Add post"),
    ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).size.height,
              padding: EdgeInsets.all(30),
              child: Column(
                children: [

                  GestureDetector(
                    onTap: _getImage,
                    child: Container(
                      height: 100,
                      width: 100,
                      child: _image != null ?
                      Image.file(_image, fit: BoxFit.cover,) :
                      Image.asset("assets/images/ic_image.jpeg"),
                    ),
                  ),
                  SizedBox(height: 15,),
                  TextField(
                    controller: titleController,
                    decoration: InputDecoration(
                        hintText: "Title"
                    ),
                  ),
                  SizedBox(height: 15,),
                  TextField(
                    controller: contentController,
                    decoration: InputDecoration(
                        hintText: "Content"
                    ),
                  ),
                  SizedBox(height: 15,),
                  Container(
                    width: double.infinity,
                    child: MaterialButton(
                      color: Colors.blue,
                      onPressed: _addPost,
                      child: Text("Add", style: TextStyle(color: Colors.white),),
                    ),
                  )

                ],
              ),
            ),
          ),
          isLoading ? Center(
            child: CircularProgressIndicator(),
          ) :
              SizedBox.shrink()
        ],
      ),
    );
  }
}
