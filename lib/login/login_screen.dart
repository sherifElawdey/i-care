import 'package:icare/helper/general_methods.dart';
import 'package:icare/helper/paths/images.dart';
import 'package:icare/helper/paths/strings.dart';
import 'package:icare/helper/styles/colors.dart';
import 'package:icare/helper/styles/size.dart';
import 'package:icare/helper/validators.dart';
import 'package:icare/login/forgot_password_screen.dart';
import 'package:icare/login/register/sign_up.dart';
import 'package:icare/pages/home/home.dart';
import 'package:icare/services/firebase/fire_methods.dart';
import 'package:icare/widgets/buttons.dart';
import 'package:icare/widgets/custom_text.dart';
import 'package:icare/widgets/loading.dart';
import 'package:icare/widgets/text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LogInPage extends StatefulWidget {
  const LogInPage({Key? key}) : super(key: key);

  @override
  State<LogInPage> createState() => LogInPageState();
}

class LogInPageState extends State<LogInPage>{
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  GlobalKey<FormState> formStateKey = GlobalKey<FormState>();
  bool _hidePass = true;
  @override
  Widget build(BuildContext context) {
    //Get.back();
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(
                top: Sizes.heightScreen(context) * 0.15,
                bottom: Sizes.heightScreen(context) * 0.03),
              child: Column(
                children: [
                  Image.asset(
                    ImagePath.appIcon,
                    width: Sizes.widthScreen(context) * 0.5,
                    height: Sizes.heightScreen(context) * 0.13,
                  ),
                  SizedBox(
                    height: Sizes.sizedBox(context)['h1'],
                  ),
                  CustomText(
                    text: 'Welcome back !',
                    size: Sizes.textSize(context)['h4'],
                    fontWeight: FontWeight.w600,
                  ),
                  CustomText(
                    text: 'sign in by your university email & password',
                    size: Sizes.textSize(context)['h2'],
                    fontWeight: FontWeight.w200,
                  ),
                ],
              ),
            ),
            loginForm(context),
            CustomButton(
              context: context,
              text: Strings.login,
              onTap: () async => loginPressed(context,
                  email: _emailController.text.toString(),
                  password: _passwordController.text.toString()),
              height: Sizes.heightScreen(context) * 0.06,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomText(
                  text: 'Don\`t have an account ? ',
                ),
                CustomTextButton(
                  text: Strings.signUp,
                  onTap:()=> Get.to(const SignUpPage()),
                  size: Sizes.textSize(context)['h2'],
                  color: appColor,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  loginForm(BuildContext context) => Form(
        key: formStateKey,
        child: Column(
          children:[
            CustomTextField(
              context,
              controller: _emailController,
              validator: Validators.instance.validateEmail(context),
              labelText: Strings.email,
              prefix: const Icon(Icons.email),
              hintText: Strings.hintEmail,
              textInputAction: TextInputAction.next,
            ),
            CustomTextField(
              context,
              controller: _passwordController,
              validator: Validators.instance.validateLoginPassword(context),
              labelText: Strings.password,
              keyboardType: TextInputType.text,
              maxLines: 1,
              textInputAction: TextInputAction.done,
              prefix: const Icon(Icons.key),
              /*margin: EdgeInsets.only(
            top:  Sizes.heightScreen(context)*0.02,
            left:  Sizes.widthScreen(context)*0.06,
            right: Sizes.widthScreen(context)*0.06),*/
              obscureText: _hidePass,
              suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      if (_hidePass) {
                        _hidePass = false;
                      } else {
                        _hidePass = true;
                      }
                    });
                  },
                  icon: Icon(_hidePass
                      ? Icons.remove_red_eye_outlined
                      : Icons.visibility_off)),
              hintText: Strings.hintPassword,
              underFieldWidget: CustomTextButton(
                text: Strings.forgotPassword,
                size: Sizes.textSize(context)['h1'],
                textDecoration: TextDecoration.underline,
                onTap: () {
                  Get.to(ForgotPasswordScreen());
                },
              ),
            ),
          ],
        ),
      );

  loginPressed(BuildContext context,{required String email,required String password}) async {
    var data = formStateKey.currentState;
    if (data != null && data.validate()) {
      showLoading(context: context,dismissible: false);
      await FirebaseMethods().signIn(email, password).then((value){
        if(value){
          Get.back();
          goToPageReplace(context,const Home());
        }
      });
    }
  }
}