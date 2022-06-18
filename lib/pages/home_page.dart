import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myplans/models/post_model.dart';
import 'package:myplans/pages/detail_page.dart';
import 'package:myplans/services/auth_service.dart';
import 'package:myplans/services/pref_service.dart';
import 'package:myplans/services/rtdb_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  static final String Id = 'home_page';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  List <Post> items = [];
  var isLoading = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _apiGetPost();
  }
  _openDetail() async{
    Map results = await Navigator.of(context).push(
        MaterialPageRoute(builder: (BuildContext context) {
          return DetailPage();
        }));
    if (results.containsKey("data")) {
      _apiGetPost();
    }
  }
  _apiGetPost() async{
    setState(() {
      isLoading = true;
    });
    var id = await Prefs.loadUserId();
    RTDBService.getPost(id).then((posts) => {
      _respPosts(posts),
    });
  }
  _respPosts (List<Post> posts){
    setState(() {
      isLoading = false;
      items = posts;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Plans',style: TextStyle(color: Colors.white),),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(CupertinoIcons.square_arrow_right,color: Colors.white,),
            onPressed: (){
              AuthService.signOutUser(context);
            },
          )
        ],
      ),
      body: Stack(
        children: [
          ListView.builder(
            itemCount: items.length,
            itemBuilder: (ctx, i){
              return itemOfList(items[i]);
            },
          ),
          isLoading ? Center(
            child: CircularProgressIndicator(),
          ): SizedBox.shrink()
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openDetail,
        child: Icon(CupertinoIcons.add),
        backgroundColor: Colors.deepOrange,
      ),
    );
  }
  Widget itemOfList(Post post){
    return Card(
      margin: EdgeInsets.all(20),
      color: Colors.deepOrange,
      child: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Title: " + post.title!, style: TextStyle(color: Colors.black,fontSize: 16),),
            SizedBox(height: 5,),
            // Container(
            //  height: 2,
            //  width: double.infinity,
            //  color: Colors.deepOrange,
            // ),
            SizedBox(height: 5,),
            Text("Content: " + post.content!, style: TextStyle(color: Colors.black,fontSize: 16),),
            SizedBox(height: 5,),
            // Container(
            //   height: 2,
            //   width: double.infinity,
            //   color: Colors.deepOrange,
            // ),
            SizedBox(height: 5,),
            Text("Date: "+post.date!, style: TextStyle(color: Colors.black,fontSize: 14),),
            SizedBox(height: 5,),
            // Container(
            //   height: 2,
            //   width: double.infinity,
            //   color: Colors.deepOrange,
            // ),
            SizedBox(height: 10,),
          ],
        ),
      ),
    );
  }
}
