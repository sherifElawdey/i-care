import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icare/helper/general_methods.dart';
import 'package:icare/helper/paths/images.dart';
import 'package:icare/helper/paths/strings.dart';
import 'package:icare/helper/styles/colors.dart';
import 'package:icare/helper/styles/size.dart';
import 'package:icare/helper/validators.dart';
import 'package:icare/login/login_screen.dart';
import 'package:icare/login/register/complete_data.dart';
import 'package:icare/modules/user_model.dart';
import 'package:icare/widgets/buttons.dart';
import 'package:icare/widgets/custom_text.dart';
import 'package:icare/widgets/text_field.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage>{
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  GlobalKey<FormState> formStateKey = GlobalKey<FormState>();
  bool _hidePass = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(
                right: Sizes.widthScreen(context)*0.05,
                left: Sizes.widthScreen(context)*0.05,
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
                    text: 'Join Us !',
                    size: Sizes.textSize(context)['h4'],
                    fontWeight: FontWeight.w600,
                  ),
                  CustomText(
                    text: 'Create your first account and start your journey ',
                    size: Sizes.textSize(context)['h2'],
                    fontWeight: FontWeight.w200,
                    maxLines: 3,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            signUpForm(context),
            CustomButton(
              context: context,
              text: Strings.signUp,
              onTap: () async => signUpPressed(context,
                  email: _emailController.text.toString(),
                  password: _passwordController.text.toString()),
              height: Sizes.heightScreen(context) * 0.06,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomText(
                  text: 'Are you have an account ? ',
                ),
                CustomTextButton(
                  text: Strings.login,
                  onTap:()=> Get.back(),
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

  signUpForm(BuildContext context) => Form(
    key: formStateKey,
    child: Column(
      children:[
        CustomTextField(
          context,
          controller: _nameController,
          validator: Validators.instance.validateName(context),
          labelText: Strings.name,
          prefix: const Icon(Icons.person),
          hintText: Strings.hintName,
          textInputAction: TextInputAction.next,
        ),
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
        ),
      ],
    ),
  );

  signUpPressed(BuildContext context,{required String email,required String password}) async {
    var data = formStateKey.currentState;
    if (data != null && data.validate()) {
      UserModel user =UserModel(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      Get.to(CompleteDataScreen(userModel: user,));
    }
  }
}