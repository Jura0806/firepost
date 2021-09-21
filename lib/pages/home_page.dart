
import 'package:firepost/models/post_model.dart';
import 'package:firepost/pages/detail_page.dart';
import 'package:firepost/pages/rtdb_service.dart';
import 'package:firepost/service/auth_service.dart';
import 'package:firepost/service/prefs_service.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);
  static final String id = "home_page";

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

   List<Post> items = [];
   
   @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _apiGetPosts();
  }

  Future _openDetail() async {
     Map results = await Navigator.of(context).push(new MaterialPageRoute(
       builder: (BuildContext context){
         return new DetailPage();
       }
     ));
     if(results != null || results.containsKey("data")){
       print(results["data"]);
       _apiGetPosts();
     }
  }

  _apiGetPosts() async{
   var id = await Prefs.loadUserId();
   RTDBService.getPosts(id).then((post) => {
     _respPosts(post)
   });
  }

  _respPosts(List<Post> posts){
     setState(() {
       items = posts;
     });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
        actions: [
          IconButton(
            onPressed: (){
              AuthService.SignOutUser(context);
            },
            icon: Icon(Icons.exit_to_app, color: Colors.white,),
          )
        ],
      ),
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (ctx, i){
          return itemOfList(items[i]);
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: IconButton(
          onPressed: _openDetail,
          icon: Icon(Icons.add),
        ),
      ),
    );
  }
  
  Widget itemOfList(Post post){
     return  Container(
       padding: EdgeInsets.all(20),
       child: Column(
         crossAxisAlignment: CrossAxisAlignment.start,
         children: [
           Text(post.title, style: TextStyle(color: Colors.black, fontSize: 20),),
           SizedBox(height: 10,),
           Text(post.content, style: TextStyle(color: Colors.black, fontSize: 16),),
         ],
       ),
     );
  }
}
