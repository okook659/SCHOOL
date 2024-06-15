import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expenses_tracker/components/my_button.dart';
import 'package:expenses_tracker/components/my_textfield.dart';
import 'package:expenses_tracker/components/square_tile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  final Function()? onTap;

  RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // text editing controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  // sign user UP method
  Future<void> signUserUp() async {
    // show loading circle
    showDialog(
        context: context,
        builder: (context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        });

    try {
      if (passwordController.text == confirmPasswordController.text) {
        // Create user with Firebase Authentication
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
                email: emailController.text, password: passwordController.text);

        // Get the UID of the newly created user
        String uid = userCredential.user!.uid;

        // Add user information to Firestore
        await FirebaseFirestore.instance.collection('users').doc(uid).set({
          'email': emailController.text,
          'password': passwordController
              .text, // Note: Storing passwords in plaintext is insecure. Consider hashing the password.
        });

        // Pop the loading circle
        Navigator.pop(context);
      } else {
        // Show error message
        showErrorMessage("Passwords don't match");
        Navigator.pop(context);
      }
    } on FirebaseAuthException catch (e) {
      // Pop the loading circle
      Navigator.pop(context);

      // Handle different auth errors
      if (e.code == 'email-already-in-use') {
        showErrorMessage("The email address is already in use.");
      } else if (e.code == 'invalid-email') {
        showErrorMessage("The email address is not valid.");
      } else if (e.code == 'operation-not-allowed') {
        showErrorMessage("Email/password accounts are not enabled.");
      } else if (e.code == 'weak-password') {
        showErrorMessage("The password is too weak.");
      } else {
        showErrorMessage(e.message ?? "An unknown error occurred.");
      }
    } catch (e) {
      // Pop the loading circle and show any other errors
      Navigator.pop(context);
      showErrorMessage(e.toString());
    }
  }

  // wrong email message popup
  void showErrorMessage(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.deepPurple,
          title: Text(
            message,
            style: const TextStyle(color: Colors.white),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 50),
                //logo
                const Icon(
                  Icons.lock,
                  size: 50,
                ),
                const SizedBox(height: 50),
                //welcome
                Text('Let\'s create an account for you!',
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 16,
                    )),

                const SizedBox(height: 25),

                // email textfield
                MyTextField(
                  controller: emailController,
                  hintText: 'Email',
                  obscureText: false,
                ),
                const SizedBox(height: 10),

                //password textfield
                MyTextField(
                  controller: passwordController,
                  hintText: 'Password',
                  obscureText: true,
                ),

                const SizedBox(height: 10),

                //confirm password textfield
                MyTextField(
                  controller: confirmPasswordController,
                  hintText: 'Confirm password',
                  obscureText: true,
                ),

                const SizedBox(height: 25),

                //sign up button
                MyButton(
                  onTap: signUserUp,
                  text: "Sign Up",
                ),

                const SizedBox(height: 25),
                //or continue with
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: Colors.grey[400],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Text(
                          'Or continue with',
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                      ),
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: Colors.grey[400],
                        ),
                      ),
                    ],
                  ),
                ),

                //google and apple sign in button
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // google button
                    SquareTile(imagePath: 'lib/assets/google.png'),

                    SizedBox(width: 10),

                    //apple button
                    SquareTile(imagePath: 'lib/assets/apple.png'),
                  ],
                ),
                const SizedBox(height: 25),

                //not a member? register now
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already have an account?',
                      style: TextStyle(
                        color: Colors.grey[700],
                      ),
                    ),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: const Text(
                        'Login now',
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
