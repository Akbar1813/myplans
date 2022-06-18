import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:myplans/pages/detail_page.dart';
import 'package:myplans/pages/home_page.dart';
import 'package:myplans/pages/signIn_page.dart';
import 'package:myplans/pages/signUp_page.dart';
import 'package:myplans/services/pref_service.dart';

void main() async{

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  Widget _startPage(){
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (BuildContext context, snapshot) {
        if(snapshot.hasData){
          Prefs.saveUserId(snapshot.data!.uid);
          return HomePage();
        }else {
          Prefs.removeUserId();
          return SignInPage();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
      ),
      home: _startPage(),
      routes: {
        SignInPage.Id: (context) => SignInPage(),
        HomePage.Id: (context) => HomePage(),
        SignUpPage.Id: (context) => SignUpPage(),
        DetailPage.Id: (context) => DetailPage()
      },
    );
  }
}