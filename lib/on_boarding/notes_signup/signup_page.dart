import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../App_constants/App_constants.dart';

class SignupPage extends StatelessWidget {
  TextEditingController nameController = TextEditingController();
  TextEditingController mobNoController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController countryController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  FirebaseAuth firebaseAuthUser = FirebaseAuth.instance;

  bool isPassVisible = false;

  FirebaseAuth authUser = FirebaseAuth.instance;

  GlobalKey<FormState> signUpKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Signup Page"),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 27),
        child: Form(
          key: signUpKey,
          child: Column(
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(21),
                  ),
                  hintText: "Enter your name here...",
                  labelText: "Name",
                ),
              ),
              SizedBox(height: 15),
              TextFormField(
                controller: mobNoController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(21),
                  ),
                  hintText: "Enter your mobile number here...",
                  labelText: "Mobile Number",
                ),
                validator: (formValue) {
                  if (formValue == null || formValue.isEmpty) {
                    return "Enter your mobile number here...";
                  } else if (formValue.length != 10) {
                    return "Enter a valid mobile number";
                  } else {
                    return null;
                  }
                },
              ),
              SizedBox(height: 15),
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
                    return "Enter a valid age...";
                  } else {
                    return null;
                  }
                },
              ),
              SizedBox(height: 15),
              TextFormField(
                controller: cityController,
                decoration: InputDecoration(
                  hintText: "Enter your city here...",
                  labelText: "City",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(21)),
                  ),
                ),
                validator: (formValue) {

                  if (formValue == null || formValue.isEmpty) {
                    return "Please enter your city here...";
                  }else {
                    return null;
                  }
                },
              ),
              SizedBox(height: 15),
              TextFormField(
                controller: stateController,
                decoration: InputDecoration(
                  hintText: "Enter your state here...",
                  labelText: "State",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(21)),
                  ),
                ),
                validator: (formValue) {

                  if (formValue == null || formValue.isEmpty) {
                    return "Please enter your state here...";
                  }else {
                    return null;
                  }
                },
              ),
              SizedBox(height: 15),
              TextFormField(
                controller: countryController,
                decoration: InputDecoration(
                  hintText: "Enter your country here...",
                  labelText: "Country",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(21)),
                  ),
                ),
                validator: (formValue) {

                  if (formValue == null || formValue.isEmpty) {
                    return "Please enter your country here...";
                  }else {
                    return null;
                  }
                },
              ),
              SizedBox(height: 15),
              TextFormField(
                controller: ageController,
                decoration: InputDecoration(
                  hintText: "Enter your age here...",
                  labelText: "Age",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(21)),
                  ),
                ),
                validator: (formValue) {

                  RegExp myAge = RegExp(r'^[0-9]+$');

                  if (formValue == null || formValue.isEmpty) {
                    return "Please enter your age here...";
                  } else if (!myAge.hasMatch(formValue)) {
                    return "Enter a valid age...";
                  } else {
                    return null;
                  }
                },
              ),
              SizedBox(height: 15,),
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
                      suffixIcon: isPassVisible
                          ? Icon(Icons.visibility)
                          : Icon(Icons.visibility_off),
                    ),
                    obscureText: !isPassVisible,
                    obscuringCharacter: "#",
                    onTap: () {
                      isPassVisible = !isPassVisible;
                      sS(() {});
                    },
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
              Expanded(child: SizedBox(height: 15)),
              InkWell(
                onTap: () async {
                  if (signUpKey.currentState!.validate()) {

                    try {

                      UserCredential userCred = await FirebaseAuth.instance
                          .createUserWithEmailAndPassword(
                        email: emailController.text,
                        password: passwordController.text,
                      );

                      if (userCred.user != null) {

                        userCred.user!.sendEmailVerification();

                        FirebaseFirestore.instance
                            .collection(AppUserConstants.collection_user_name)
                            .doc(userCred.user!.uid)
                            .set({
                          AppUserConstants.user_name: nameController.text,
                          AppUserConstants.user_email: emailController.text,
                          AppUserConstants.user_mob_no: mobNoController.text,
                          AppUserConstants.user_id : userCred.user!.uid,
                          AppUserConstants.user_age : ageController.text,
                          AppUserConstants.user_city : cityController.text,
                          AppUserConstants.user_state : stateController.text,
                          AppUserConstants.user_country : countryController.text
                            });

                        Navigator.pop(context);
                      }
                    }
                    // Only to handle Firebase specific exceptions
                    on FirebaseAuthException catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(e.code.toString()),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                    catch (e) {
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text(e.toString()), backgroundColor: Colors.red,),);
                    }
                  }
                },
                child: Container(
                  alignment: Alignment(0, 0),
                  height: 63,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.blueAccent,
                    border: BoxBorder.fromBorderSide(BorderSide.none),
                    borderRadius: BorderRadius.circular(21),
                  ),
                  child: Text(
                    "Signup",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
