import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:social_mathematicians/services/auth_service.dart';
import 'package:social_mathematicians/widgets/logo.dart';
import 'package:social_mathematicians/widgets/my_button.dart';
import 'package:social_mathematicians/widgets/my_textfield.dart';
import 'package:social_mathematicians/widgets/triangle_animation.dart';

class LoginPage extends StatefulWidget {
  final void Function()? onTap;

  const LoginPage({super.key, this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with TickerProviderStateMixin {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

//get auth controller

  AuthService authController = Get.put(AuthService());
  void signIn() async {
    await authController.singInWithEmailAndPassword(
        emailController.text, passwordController.text);
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

            //email textfield
            MyTextfield(
              icon: const Icon(
                Icons.email_outlined,
                color: Color(0xFF9A9A9A),
              ),
              isObscured: false,
              hintText: 'emailHint'.tr,
              controller: emailController,
            ),
            //password textfield
            MyTextfield(
                icon: const Icon(
                  Icons.lock_outline,
                  color: Color(0xFF9A9A9A),
                ),
                isObscured: true,
                hintText: 'passwordHint'.tr,
                controller: passwordController),

            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 27.0, vertical: 25),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'forgotPassword'.tr,
                    style: const TextStyle(
                      color: Colors.blueGrey,
                    ),
                  ),
                ],
              ),
            ),

            // Sign In Button
            MyButton(
              buttonText: 'signIn'.tr,
              onTap: signIn,
            ),

            // navigate to register
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('createAccount'.tr),
                GestureDetector(
                  onTap: widget.onTap,
                  child: Text(
                    'create'.tr,
                    style: const TextStyle(
                        color: Colors.blueGrey, fontWeight: FontWeight.bold),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
