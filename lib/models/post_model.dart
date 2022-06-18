class Post {
  String? userId;
  String? title;
  String? content;
  String? date;

  Post(this.userId,this.title, this.content, this.date,);
  Post.fromJson(Map<String, dynamic> json)
  : userId = json['userId'],
    title = json['title'],
    date = json['date'],
    content = json['content'];


  Map<String, dynamic> toJson() => {
    'userId' : userId,
    'title' : title,
    'date' : date,
    'content' : content,
  };
}