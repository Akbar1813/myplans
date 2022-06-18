import 'package:firebase_database/firebase_database.dart';
import 'package:myplans/models/post_model.dart';

class RTDBService {
  static final _database = FirebaseDatabase.instance.ref();


  // Post Add
  static Future<Stream<DatabaseEvent>> addPost(Post post) async{
    _database.child("myplans").push().set(post.toJson());
    return _database.onChildAdded;
  }

  // Post Get
  static Future <List<Post>> getPost (String id) async {
    List <Post> items = [];
    Query _query = _database.ref.child("myplans").orderByChild("userId").equalTo(id);
    var snapshot = await _query.once();
    var result = snapshot.snapshot.children;
    items = result.map((snapshot) {
      Map<String, dynamic> post = Map<String, dynamic>.from(snapshot.value as Map);
      post['key'] = snapshot.key;
      return Post.fromJson(post);
    }).toList();
    return items;
  }
}