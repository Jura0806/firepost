
class Post{

  String userId;
  String title;
  String content;

  Post(String userId, String title, String content){
    this.userId = userId;
    this.title = title;
    this.content = content;
  }

  Post.fromjson(Map<String, dynamic> json)
      :userId = json["userId"],
      title = json["title"],
      content = json["content"];

  Map<String, dynamic> toJson() => {
    "userId" : userId,
    "title" : title,
    "content" : content
  };
}