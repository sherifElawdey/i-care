import 'package:firebase_auth/firebase_auth.dart';
import 'package:icare/helper/general_methods.dart';
import 'package:icare/helper/paths/strings.dart';
import 'package:icare/helper/styles/colors.dart';
import 'package:icare/helper/styles/size.dart';
import 'package:icare/helper/validators.dart';
import 'package:icare/widgets/buttons.dart';
import 'package:icare/widgets/custom_text.dart';
import 'package:icare/widgets/text_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ForgotPasswordScreen extends StatelessWidget {
  ForgotPasswordScreen({Key? key}) : super(key: key);
  final _emailController =TextEditingController();
  GlobalKey<FormState> formState =GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: CustomBackButton(context,color: appColor,)
      ),
      body: Padding(
        padding:EdgeInsets.only(
            top:Sizes.heightScreen(context)*0.08,
            right:Sizes.widthScreen(context)* 0.02,
            left: Sizes.widthScreen(context)* 0.02,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children :[
            Icon(CupertinoIcons.waveform_path_badge_plus,size: 90,color: appColor,),
            //Image.asset(ImagePath.IMAGE_ICON2,width:  Sizes.widthScreen(context)*0.5,height:  Sizes.heightScreen(context)*0.13,),
            CustomText(
              text: 'Forgot password !',
              size: Sizes.textSize(context)['h4'],
              fontWeight: FontWeight.w700,
            ),
            CustomText(
              text: 'Please enter your email to send verification code for adding new password ',
              size: Sizes.textSize(context)['h2'],
              fontWeight: FontWeight.w300,
              maxLines: 2,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: Sizes.sizedBox(context)['h3'],),
            Form(
              key: formState,
              child: CustomTextField(context,
                controller: _emailController,
                validator: Validators.instance.validateEmail(context),
                labelText: Strings.email,
                prefix:const Icon(Icons.email),
                hintText: Strings.hintEmail,
                //margin: EdgeInsets.symmetric(horizontal: Sizes.widthScreen(context)*0.06,vertical: Sizes.heightScreen(context)*0.02),
                textInputAction: TextInputAction.done,
              )
            ),
            CustomButton(
              context: context,
              text:Strings.send,
              onTap:()async{
                await forgotPassword();
              },
              ),
          ],
        ),
      ),
    );
  }

   Future forgotPassword() async{
       var data =formState.currentState;
       if(data!=null&&data.validate()){
         await FirebaseAuth.instance
             .sendPasswordResetEmail(email: _emailController.text).onError((error, stackTrace) => print(error))
             .whenComplete(() => customSnackBar(title: 'we will sent a link to your email account'));
       }else{
         customSnackBar(
           title: 'Please add your email first'
         );
       }
  }
}
