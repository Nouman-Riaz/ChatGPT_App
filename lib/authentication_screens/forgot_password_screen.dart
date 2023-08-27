import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../custom_buttons/round_button.dart';
import '../utils/utils.dart';
import 'package:email_validator/email_validator.dart';
import 'package:get/get.dart';
import '../circular_button_management/circular_indicator.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final emailController =  TextEditingController();
  CircularIndicator controller = Get.put(CircularIndicator());
  bool loading = false;
  FirebaseAuth auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Forgot Password'),
        backgroundColor: Colors.orangeAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 50,
            ),
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
            SizedBox(
              height: 40,
            ),
            RoundButton(title: 'Proceed', loading: controller.loading.value,onTap: (){
              controller.setLoading(true);
              auth.sendPasswordResetEmail(email: emailController.text.toString()).then((value){
                controller.setLoading(false);
                Utils().toastMessage('We have sent an email to you, please check to reset your password');
              }).onError((error, stackTrace){
                controller.setLoading(false);
                Utils().toastMessage(error.toString());
              });
            }),
          ],
        ),
      ),
    );
  }
}
