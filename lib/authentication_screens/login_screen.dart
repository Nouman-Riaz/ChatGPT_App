import 'package:chatgpt/authentication_screens/signup_screen.dart';
import 'package:chatgpt/circular_button_management/circular_indicator_for_google_button.dart';
import 'package:chatgpt/navigation_screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../circular_button_management/circular_indicator.dart';
import '../custom_buttons/google_button.dart';
import '../custom_buttons/round_button.dart';
import '../utils/utils.dart';
import 'package:get/get.dart';
import 'forgot_password_screen.dart';
import 'google_signin.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  CircularIndicator controller = Get.put(CircularIndicator());
  CircularIndicatorForGoogleButton googleController = Get.put(CircularIndicatorForGoogleButton());
  GoogleAuthSignIn signIn = GoogleAuthSignIn();
  final _formKey = GlobalKey<FormState>();
  late bool _passwordVisible;
  bool loading = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _passwordVisible = false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Login'),
          backgroundColor: Colors.orangeAccent,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 23),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 100,
                ),
                Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(
                            hintText: 'Email',
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.orangeAccent, width: 1),
                            ),
                            focusedBorder: OutlineInputBorder( // Customize focused border here
                              borderSide: BorderSide(color: Colors.orangeAccent, width: 2), // Example customization
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.red, width: 1),
                            ),
                            prefixIcon: Icon(Icons.email,color: Colors.grey,),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Enter Email';
                            }
                            if (!EmailValidator.validate(value)) {
                              //controller.setLoading(false);
                              return 'Please enter a valid email';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                            controller: passwordController,
                            keyboardType: TextInputType.text,
                            obscureText: !_passwordVisible,
                            decoration: InputDecoration(
                              hintText: 'password',
                              enabledBorder: const OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.orangeAccent, width: 1),
                              ),
                              focusedBorder: OutlineInputBorder( // Customize focused border here
                                borderSide: BorderSide(color: Colors.orangeAccent, width: 2), // Example customization
                              ),
                              errorBorder: const OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.red, width: 1),
                              ),
                              prefixIcon: const Icon(Icons.lock_outline,color: Colors.grey,),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _passwordVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: Colors.grey,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _passwordVisible = !_passwordVisible;
                                  });
                                },
                              ),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Enter Password';
                              }
                              return null;
                            }
                            ),
                      ],
                    )),
                const SizedBox(
                  height: 40,
                ),
                RoundButton(
                   title: 'Login',
                   loading: controller.loading.value,
                  onTap: () {
                    if (_formKey.currentState!.validate()) {
                      controller.setLoading(true);
                      _auth
                          .signInWithEmailAndPassword(
                              email: emailController.text.toString(),
                              password: passwordController.text.toString())
                          .then((value) {
                        Utils().toastMessage(value.user!.email.toString());
                        controller.setLoading(false);
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ChatScreen()));
                      }).onError((error, stackTrace) {
                        controller.setLoading(false);
                        debugPrint(error.toString());
                        Utils().toastMessage(error.toString());
                      });
                    }
                  },
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const ForgotPasswordScreen()));
                    },
                    child: const Text("Forgot Password?",
                        style: TextStyle(
                          color: Colors.orangeAccent,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                        )),
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don't have an account? "),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SignupScreen()));
                      },
                      child: const Text("SignUp",style: TextStyle(color: Colors.orangeAccent),),
                    )
                  ],
                ),
                SizedBox(
                  height: 30,
                ),
                const Row(
                  children: [
                    Expanded(
                      child: Divider(
                        thickness: 1, // Set the thickness of the Divider
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        'OR',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        thickness: 1, // Set the thickness of the Divider
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                Stack(
                  alignment: Alignment.centerLeft, // Align the icon and text vertically
                  children: [
                    GoogleButton(
                      title: 'Login with Google',
                      loading: googleController.loading.value,
                      onTap: () async {
                        try {
                          googleController.setLoading(true);
                          await GoogleSignIn().signOut();
                          UserCredential userCredential = await signIn.authenticateWithGoogle();
                          Utils().toastMessage('Google Sign-In Successful: ${userCredential.user!.email}');
                          googleController.setLoading(false);
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => ChatScreen()),
                          );
                        } catch (e) {
                          googleController.setLoading(false);
                          print(e.toString());
                        }
                      },
                    ),
                    Positioned(
                      left: 18,
                      child: Image.asset(
                        'images/google-icon.png',
                        width: 25, // Adjust the width as needed
                        height: 25, // Adjust the height as needed
                      ),
                    ),
                  ],
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
