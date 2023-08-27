import 'package:chatgpt/authentication_screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:email_validator/email_validator.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../custom_buttons/round_button.dart';
import '../utils/utils.dart';
import '../circular_button_management/circular_indicator.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  CircularIndicator controller = Get.put(CircularIndicator());
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

  void signup() {
    if (_formKey.currentState!.validate()) {
      controller.setLoading(true);
      _auth
          .createUserWithEmailAndPassword(
          email: emailController.text.toString(),
          password: passwordController.text.toString())
          .then((value) {
        controller.setLoading(false);
      }).onError((error, stackTrace) {
        Utils().toastMessage(error.toString());
        controller.setLoading(false);
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SignUp'),
        backgroundColor: Colors.orangeAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 23),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 100,),
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
                            borderSide: BorderSide(color: Colors.orangeAccent, width: 1),
                          ),
                          focusedBorder: OutlineInputBorder( // Customize focused border here
                            borderSide: BorderSide(color: Colors.orangeAccent, width: 2), // Example customization
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.red, width: 1),
                          ),
                          prefixIcon: Icon(Icons.email,color: Colors.grey,),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Enter Email';
                          }
                          if (!EmailValidator.validate(value)){
                            setState(() {
                              loading = false;
                            });
                            return 'Please enter a valid email';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 15,
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
                              borderSide: BorderSide(color: Colors.red, width: 1),
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
                            if (value!.isEmpty) return 'Enter Password';
                            return null;
                          }),
                    ],
                  )),
              const SizedBox(
                height: 20,
              ),
              RoundButton(
                title: 'Sign Up',
                loading: controller.loading.value,
                onTap: () => signup(),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Already have an account?'),
                  TextButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => const LoginScreen()));
                    },
                    child: const Text('Login',style: TextStyle(color: Colors.orangeAccent),),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
