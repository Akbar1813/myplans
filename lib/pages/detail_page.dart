import 'dart:io';
import 'package:flutter/material.dart';
import 'package:myplans/services/pref_service.dart';
import 'package:myplans/services/rtdb_service.dart';
import 'package:myplans/services/utils_service.dart';
import '../models/post_model.dart';

class DetailPage extends StatefulWidget {
  const DetailPage({Key? key}) : super(key: key);
  static final String Id = 'detail_page';
  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  var isLoading =  false;
  var dateController = TextEditingController();
  var contentController = TextEditingController();
  var titleController = TextEditingController();
  _addPost() async {
    String date = dateController.text.toString();
    String content = contentController.text.toString();
    String title = titleController.text.toString();
    if (date.isEmpty || title.isEmpty || content.isEmpty) return {Utils.fireToast("Please input all data")};
    _apiAddPost(title,content,date);
  }
  _apiAddPost(String title,String content, String date,) async{
    var id = await Prefs.loadUserId();
    RTDBService.addPost(Post(id,title,content,date,)).then((response) => {
      _respAddPost(),
    });
  }
  _respAddPost () {
    setState(() {
      isLoading = false;
    });
    Navigator.of(context).pop({'data': 'done'});
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Plan'),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Container(
                height: MediaQuery.of(context).size.height,
                padding: EdgeInsets.all(30),
                child: Column(
                  children: [
                    TextField(
                      controller: titleController,
                      decoration: InputDecoration(
                        hintText: 'Title',
                      ),
                    ),
                    SizedBox(height: 15,),
                    TextField(
                      controller: contentController,
                      decoration: InputDecoration(
                        hintText: 'Plan',
                      ),
                    ),
                    SizedBox(height: 15,),
                    TextField(
                      controller: dateController,
                      decoration: InputDecoration(
                        hintText: 'Date',
                      ),
                    ),
                    SizedBox(height: 15,),
                    Container(
                      width: double.infinity,
                      height: 45,
                      decoration: BoxDecoration(
                        color: Colors.deepOrange,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextButton(
                        child: Text('Add Plan',style: TextStyle(color: Colors.white),),
                        onPressed: _addPost,
                      ),
                    )
                  ],
                )
            ),
          ),
          isLoading ? Center(
            child: CircularProgressIndicator(),
          ): SizedBox.shrink()
        ],
      )
    );
  }
}
