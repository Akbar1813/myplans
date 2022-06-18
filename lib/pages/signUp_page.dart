import 'package:firebase_auth/firebase_auth.dart';
import 'package:myplans/pages/signIn_page.dart';
import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../services/pref_service.dart';
import '../services/utils_service.dart';
import 'home_page.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);
  static final String Id = 'signIn_page';

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  var _fullNameController = TextEditingController();
  var _emailController = TextEditingController();
  var _passwordController = TextEditingController();
  void _doSignUp() {
    String email = _emailController.text.toString().trim();
    String password = _passwordController.text.toString().trim();
    String name = _fullNameController.text.toString().trim();
    if (email.isEmpty || password.isEmpty || name.isEmpty) return Utils.fireToast("Not input data");
    AuthService.signUpUser(context, name, email, password)
        .then((user) => {_getUser(user!)});
  }

  _getUser(User user) async {
    if (user != null) {
      await Prefs.saveUserId(user.uid);
      Navigator.pushReplacementNamed(context, HomePage.Id);
    } else {
      Utils.fireToast("Check your Information");
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
              controller: _fullNameController,
              decoration: InputDecoration(
                hintText: 'Full Name',
              ),
            ),
            SizedBox(
              height: 10,
            ),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                hintText: 'Email',
              ),
            ),
            SizedBox(
              height: 10,
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                hintText: 'Password',
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: 45,
              padding: EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(22.5),
                color: Colors.deepOrange,
              ),
              child: TextButton(
                child: Text(
                  'Sign Up',
                  style: TextStyle(fontSize: 18, color: Colors.black),
                ),
                onPressed: _doSignUp,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text("Already have an Account?"),
                SizedBox(
                  width: 5,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushReplacementNamed(context, SignInPage.Id);
                  },
                  child: Text(
                    'Sign In',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
