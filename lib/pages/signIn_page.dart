import 'package:firebase_auth/firebase_auth.dart';
import 'package:myplans/pages/signUp_page.dart';
import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../services/pref_service.dart';
import '../services/utils_service.dart';
import 'home_page.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);
  static final String Id = 'signUp_page';

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  var isSignIn = false;
  var _emailController = TextEditingController();
  var _passwordController = TextEditingController();
  void _doSignIn () {
    String email = _emailController.text.toString().trim();
    String password = _passwordController.text.toString().trim();
    setState(() {
      isSignIn = true;
    });
    if(email.isEmpty || password.isEmpty) return Utils.fireToast("Not input email or password");
    AuthService.signInUser(context, email, password).then((user) => {
      _getUser(user!),
    });
  }

  _getUser(User user) async{
    setState(() {
      isSignIn = true;
    });
    if(user != null){
      await Prefs.saveUserId(user.uid);
      Navigator.pushReplacementNamed(context, HomePage.Id);
    }else{
      Utils.fireToast("Check your email or password");
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                hintText: 'Email',
              ),
            ),
            SizedBox(height: 10,),
            TextField(
              obscureText: true,
              controller: _passwordController,
              decoration: InputDecoration(
                hintText: 'Password',
              ),
            ),
            SizedBox(height: 20,),
            Container(
              width: MediaQuery.of(context).size.width,
              height: 45,
              padding: EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(22.5),
                color: Colors.deepOrange,
              ),
              child: TextButton(
                child: Text('Sign In',style: TextStyle(fontSize: 18,color: Colors.black),),
                onPressed: _doSignIn,
              ),
            ),
            SizedBox(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text("Don't have an Account?"),
                SizedBox(width: 5,),
                GestureDetector(
                  onTap: (){
                    Navigator.pushReplacementNamed(context, SignUpPage.Id);
                  },
                  child: Text('Sign Up',style: TextStyle(fontWeight: FontWeight.bold),),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
