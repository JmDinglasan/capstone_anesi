//import 'package:capstone_anesi/Login-Register/superAdminregisterScreen.dart';
import 'package:capstone_anesi/app.dart';
import 'package:capstone_anesi/constant.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:capstone_anesi/registerScreen/register.dart'; // Adjust paths as necessary
// import 'package:capstone_anesi/teacherScreen/teacher.dart';
// import 'package:capstone_anesi/studentScreen/student.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isObscure3 = true;
  bool visible = false;
  final _formkey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final _auth = FirebaseAuth.instance;

@override
Widget build(BuildContext context) {
  return Scaffold(
    body: Center( // Centers all content in the middle of the page
      child: SingleChildScrollView(  // Make the page scrollable
        child: Container(
          margin: const EdgeInsets.all(12),
          child: Form(
            key: _formkey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center, // Center vertically
              crossAxisAlignment: CrossAxisAlignment.center, // Center horizontally
              mainAxisSize: MainAxisSize.min, // Adjust size to fit content
              children: [
                // Circular container for logo
                Container(
                  height: 110,
                  width: 110,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 8,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: ClipOval(
                    child: Image.asset(
                      'assets/logo.jpg', // Replace this with an Image widget
                      fit: BoxFit.cover, // Ensures the logo fits within the circular container
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                const Column(
                  children: [
                    Text(
                      "ANESI",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: kprimaryColor,
                        fontSize: 40,
                        fontFamily: 'RobotoSlab', // Example custom font
                        letterSpacing: 1.0, // Adds some spacing between letters
                      ),
                    ),
                    SizedBox(height: 8), // Spacing between title and subtitle
                    Text(
                      "Sugar Road, Carmona Cavite",
                      style: TextStyle(
                        fontSize: 16, // Smaller font size for subtitle
                        color: kprimaryColor,
                        fontFamily: 'Poppins', // Match font style with title
                        fontStyle: FontStyle.normal, // Optional: adds stylish look
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: 'Email',
                    contentPadding:
                        const EdgeInsets.only(left: 14.0, bottom: 8.0, top: 8.0),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.green),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.green),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Email cannot be empty";
                    }
                    if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
                        .hasMatch(value)) {
                      return "Please enter a valid email";
                    }
                    return null;
                  },
                  onSaved: (value) {
                    emailController.text = value!;
                  },
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: passwordController,
                  obscureText: _isObscure3,
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isObscure3 ? Icons.visibility : Icons.visibility_off,
                        color: kprimaryColor,
                      ),
                      onPressed: () {
                        setState(() {
                          _isObscure3 = !_isObscure3;
                        });
                      },
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    hintText: 'Password',
                    contentPadding:
                        const EdgeInsets.only(left: 14.0, bottom: 8.0, top: 8.0),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.green),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.green),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Password cannot be empty";
                    }
                    if (!RegExp(r'^.{6,}$').hasMatch(value)) {
                      return "Please enter a valid password (min. 6 characters)";
                    }
                    return null;
                  },
                  onSaved: (value) {
                    passwordController.text = value!;
                  },
                  keyboardType: TextInputType.visiblePassword,
                ),
                const SizedBox(height: 45),
                MaterialButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  elevation: 5.0,
                  height: 40,
                  onPressed: () {
                    setState(() {
                      visible = true;
                    });
                    signIn(emailController.text, passwordController.text);
                  },
                  color: kprimaryColor,
                  child: const Text(
                    "Login",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Visibility(
                  maintainSize: true,
                  maintainAnimation: true,
                  maintainState: true,
                  visible: visible,
                  child: const CircularProgressIndicator(
                    color: kprimaryColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}


  void route() {
    User? user = FirebaseAuth.instance.currentUser;
    var kk = FirebaseFirestore.instance
        .collection('tbl_users')
        .doc(user!.uid)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        if (documentSnapshot.get('fld_role') == 0) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const MainScreen(),
            ),
          );
        } else if (documentSnapshot.get('fld_role') == 1) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const AdminMainScreen(),
            ),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const StaffMainScreen(),
            ),
          );
        }
      } else {
        print('Document does not exist on the database');
      }
    });
  }

  void signIn(String email, String password) async {
    if (_formkey.currentState!.validate()) {
      try {
        UserCredential userCredential =
            await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        route();
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          print('No user found for that email.');
        } else if (e.code == 'wrong-password') {
          print('Wrong password provided for that user.');
        }
      }
    }
  }
}
