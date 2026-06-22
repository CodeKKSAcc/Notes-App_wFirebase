import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_notes_app/App_constants/App_constants.dart';
import 'package:firebase_notes_app/notes_pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../notes_signup/signup_page.dart';

class LoginPage extends StatelessWidget {
  TextEditingController emailController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  bool isVisible = false;

  GlobalKey<FormState> loginKey = GlobalKey();

  FirebaseAuth authUser = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login Page"),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 36),
        child: Form(
          key: loginKey,
          child: Column(
            children: [
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(
                  hintText: "Enter your email here...",
                  labelText: "Email",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(21)),
                  ),
                ),
                validator: (formValue) {
                  RegExp varifyEmail = RegExp(
                    r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                  );

                  if (formValue == null || formValue.isEmpty) {
                    return "Please enter your email here...";
                  } else if (!varifyEmail.hasMatch(formValue)) {
                    return "Enter a your email...";
                  } else {
                    return null;
                  }
                },
              ),
              SizedBox(height: 15),
              StatefulBuilder(
                builder: (context, sS) {
                  return TextFormField(
                    controller: passwordController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(21)),
                      ),
                      hintText: "Enter your password here... ",
                      labelText: "Password",
                      suffixIcon: IconButton(onPressed: (){isVisible = !isVisible;
                      sS(() {});}, icon: isVisible ?  Icon(Icons.visibility)
                          : Icon(Icons.visibility_off)),
                    ),
                    obscureText: !isVisible,
                    obscuringCharacter: "#",
                    validator: (formValue) {
                      RegExp varifyPassword = RegExp(
                        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$',
                      );

                      if (formValue == null || formValue.isEmpty) {
                        return "Please enter your password...";
                      } else if (!varifyPassword.hasMatch(formValue)) {
                        return "Please enter a valid password";
                      } else {
                        return null;
                      }
                    },
                  );
                },
              ),
              Expanded(child: SizedBox(height: 45)),
              InkWell(
                onTap: () async {
                  if (loginKey.currentState!.validate()) {
                    try {
                      // Also we can use the where() method to find if the particular email exist's in our email-collection
                      // FirebaseFirestore.instance.collection(AppConstants.collection_user_name).where(AppConstants.collection_user_name, isEqualTo: emailController.text);

                      UserCredential userCred = await authUser
                          .signInWithEmailAndPassword(
                            email: emailController.text,
                            password: passwordController.text,
                          );

                      if (userCred.user != null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("User logged in successfully"),
                            backgroundColor: Colors.green,
                          ),
                        );

                        SharedPreferences myPref =
                            await SharedPreferences.getInstance();
                        myPref.setBool(AppUserConstants.logged_in_key, true);
                        myPref.setString(AppUserConstants.user_id, userCred.user!.uid);

                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => HomePage()),
                        );
                      }
                    } on FirebaseAuthException catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(e.code),
                          backgroundColor: Colors.red,
                        ),
                      );
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(e.toString()),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  }
                },
                child: Container(
                  alignment: Alignment(0, 0),
                  height: 57,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.blueAccent,
                    border: Border.fromBorderSide(BorderSide.none),
                    borderRadius: BorderRadius.circular(21),
                  ),
                  child: Text(
                    "Login",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 9),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Don't have an account?"),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SignupPage()),
                      );
                    },
                    child: Text(
                      " Signup",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
