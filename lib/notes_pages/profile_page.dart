import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_notes_app/App_constants/App_constants.dart';
import 'package:firebase_notes_app/on_boarding/notes_login/login_page.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  String userId;

  ProfilePage({required this.userId});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late Stream<QuerySnapshot<Map<String, dynamic>>> userData;

  @override
  void initState() {
    super.initState();

    userData = FirebaseFirestore.instance
        .collection(AppUserConstants.collection_user_name)
        .where(AppUserConstants.user_id, isEqualTo: widget.userId)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile Page"),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
        actions: [
          OutlinedButton(
            onPressed: () async {
              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=> LoginPage()), (route) => false,);
            },
            style: OutlinedButton.styleFrom(
              backgroundColor: Colors.deepPurpleAccent,
              foregroundColor: Colors.white
            ),
            child: Text("Logout"),
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: userData,
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator(color: Colors.blue));
          }

          if (snap.hasError) {
            return Center(
              child: Text(
                snap.error.toString(),
                style: TextStyle(fontSize: 27, fontWeight: FontWeight.w500),
              ),
            );
          }

          if (snap.hasData) {
            var userData = snap.data!.docs;

            return snap.data != null ?  Padding(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "User Information",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: 27),
                  Row(
                    children: [
                      Icon(Icons.person, size: 39, color: Colors.black),
                      SizedBox(width: 45),
                      Text(
                        userData[0][AppUserConstants.user_name],
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 15),
                  Row(
                    children: [
                      Icon(Icons.mail, size: 39, color: Colors.black),
                      SizedBox(width: 45),
                      Text(
                        userData[0][AppUserConstants.user_email],
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 15),
                  Row(
                    children: [
                      Text(
                        "Age",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(width: 51),
                      Text(
                        userData[0][AppUserConstants.user_age],
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 15),
                  Row(
                    children: [
                      Icon(Icons.location_on, size: 39, color: Colors.black),
                      SizedBox(width: 48),
                      Text(
                        userData[0][AppUserConstants.user_city],
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 15),
                  Row(
                    children: [
                      Text(
                        "State",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(width: 45),
                      Text(
                        userData[0][AppUserConstants.user_state],
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 15),
                  Row(
                    children: [
                      Text(
                        "Country",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(width: 27),
                      Text(
                        userData[0][AppUserConstants.user_country],
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ) : Center(
              child: Text(
                "No User Profile",
                style: TextStyle(fontSize: 27, fontWeight: FontWeight.w500),
              ),
            );;
          }

          return Center(
            child: Text(
              "Unknown Error!!!",
              style: TextStyle(fontSize: 27, fontWeight: FontWeight.w500),
            ),
          );
        },
      ),
    );
  }
}
