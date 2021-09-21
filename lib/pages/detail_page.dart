import 'package:firepost/models/post_model.dart';
import 'package:firepost/pages/rtdb_service.dart';
import 'package:firepost/service/prefs_service.dart';
import 'package:flutter/material.dart';

class DetailPage extends StatefulWidget {
  const DetailPage({Key key}) : super(key: key);
  static final String id = "detail_page";

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {

  var titleController = TextEditingController();
  var contentController = TextEditingController();

  _addPost() async{

    String title = titleController.text.toString().trim();
    String  content = contentController.text.toString().trim();
    if(title.isEmpty || content.isEmpty) return ;

    _apiAddPost(title, content);
  }

  _apiAddPost( String title, String content) async{
    var id = await Prefs.loadUserId();
    RTDBService.addPost(new Post(id, title, content)).then((response) => {
      _respAddPost()
    });
  }

  _respAddPost(){
    Navigator.of(context).pop({"data" : "done"});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    appBar:  AppBar(
      title: Text("Add post"),
    ),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.all(30),
          child: Column(
            children: [
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
    );
  }
}
