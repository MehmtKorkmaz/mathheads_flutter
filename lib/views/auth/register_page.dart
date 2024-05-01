import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:social_mathematicians/services/auth_service.dart';
import 'package:social_mathematicians/widgets/logo.dart';

import '../../widgets/my_textfield.dart';
import '../../widgets/my_button.dart';
import '../../widgets/triangle_animation.dart';

class RegisterPage extends StatefulWidget {
  final void Function()? onTap;

  const RegisterPage({super.key, this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmController = TextEditingController();
  TextEditingController nameController = TextEditingController();

  // get auth controller
  AuthService authService = Get.put(AuthService());

  void signUp() {
    if (passwordController.text == confirmController.text) {
      authService.singUpWithEmailAndPassword(
          emailController.text, passwordController.text, nameController.text);
    } else {
      Get.snackbar('Error!', 'Passwords do not match');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            color: context.theme.primaryColor,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(25),
              topRight: Radius.circular(25),
            )),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // L O G O
            const Logo(),
            //TRİANGLE ANİMATİON

            const TriangleAnimation(),
            MyTextfield(
              icon: const Icon(
                Icons.person,
                color: Color(0xFF9A9A9A),
              ),
              isObscured: false,
              hintText: 'userName'.tr,
              controller: nameController,
            ),
            MyTextfield(
              icon: const Icon(
                Icons.email_outlined,
                color: Color(0xFF9A9A9A),
              ),
              isObscured: false,
              hintText: 'emailHint'.tr,
              controller: emailController,
            ),
            MyTextfield(
                icon: const Icon(
                  Icons.lock_outline,
                  color: Color(0xFF9A9A9A),
                ),
                isObscured: true,
                hintText: 'passwordHint'.tr,
                controller: passwordController),
            MyTextfield(
                icon: const Icon(
                  Icons.lock_outline,
                  color: Color(0xFF9A9A9A),
                ),
                isObscured: true,
                hintText: 'passwordHint'.tr,
                controller: confirmController),
            const SizedBox(
              height: 20,
            ),
            MyButton(
              buttonText: 'signUp'.tr,
              onTap: signUp,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('accountText'.tr),
                GestureDetector(
                  onTap: widget.onTap,
                  child: Text(
                    'loginText'.tr,
                    style: TextStyle(color: Colors.blueGrey),
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
