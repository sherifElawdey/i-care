import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icare/helper/paths/images.dart';
import 'package:icare/helper/paths/strings.dart';
import 'package:icare/helper/state/user_controller.dart';
import 'package:icare/helper/styles/colors.dart';
import 'package:qr_flutter/qr_flutter.dart';

class BackgroundClipper extends CustomClipper<Path>{
  @override
  getClip(Size size) {
    var path =Path();
    path.lineTo(0.0, size.height - 40);
    path.quadraticBezierTo(size.width / 4, size.height - 80, size.width / 2, size.height - 40);
    path.quadraticBezierTo(size.width - (size.width / 4), size.height,size.width, size.height - 40);
    path.lineTo(size.width, 0.0);
    path.close();
    return path;
  }
  @override
  bool shouldReclip(covariant CustomClipper<dynamic> oldClipper) {
    return true;
  }

}

void goToPageReplace(BuildContext context, Widget widget ) {
  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
    return widget;
  }));
}

void goToPageReplaceAll(BuildContext context, Widget widget ) {
  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (BuildContext context){
    return widget;
  }), (r){
    return false;
  });
}

customShadow ()=>BoxShadow(
  color:greyColor.withOpacity(0.3),
  blurRadius:6,
  offset: const Offset(-3, 3),

);

showQrCode(BuildContext context)=>Get.bottomSheet(
    Center(
      child: QrImage(
        data: Get.put(UserController()).userData.value.id.toString(),
        size: 250,
        version: 3,
        errorStateBuilder: (cxt, err) {
          return  const Center(
            child: Text(
              "Uh oh! Something went wrong...",
              textAlign: TextAlign.center,
            ),
          );
        },
        //foregroundColor: appColor,
        backgroundColor: whiteColor,
        embeddedImage: const AssetImage(ImagePath.appIcon),
        embeddedImageStyle: QrEmbeddedImageStyle(
          //color: whiteColor,
          size:const Size(50,50),
        ),
      ),
    ),
    shape:const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
    isScrollControlled: false,
    backgroundColor: Theme.of(context).scaffoldBackgroundColor
);

expandProfileImage(String path){
  Get.bottomSheet(
    Center(
      child: Image.network(path,),
    ),
    shape:const RoundedRectangleBorder(borderRadius:BorderRadius.vertical(top: Radius.circular(30))),
    backgroundColor:blackColor,
    isScrollControlled: true,
  );
}

customBottomSheet(BuildContext context,Widget widget,{bool? enableDrag,bool? isScroll}){
  Get.bottomSheet(
    widget,
    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
    shape:const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
    ),
    enableDrag: enableDrag?? true,
    isScrollControlled: isScroll ??false,
  );
}

customSnackBar({String? title,String? message,Widget? icon,SnackPosition? position,Color? background}){
  Get.snackbar(
      title ??'press back again to exit',
      message ??'',
      icon:icon,
      duration:const Duration(seconds: 3),
      margin:const EdgeInsets.symmetric(vertical: 20,horizontal: 5),
      colorText: whiteColor,
      backgroundColor:background ?? appColor.withOpacity(0.5),
      snackPosition:position,
  );
}

Future<bool> connectivity()async{
  try {
    final result = await InternetAddress.lookup('example.com');
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      return true;
    }else{
      return false;
    }
  } on SocketException catch (_) {
    return false;
  }
/*  var connectivityResult = await (Connectivity().checkConnectivity());
  if (connectivityResult == ConnectivityResult.mobile) {
    setState(() {
      connect = 'mobile';
    });
  } else if (connectivityResult == ConnectivityResult.wifi) {
    setState(() {
      connect = 'wifi';
    });
  }else if(connectivityResult == ConnectivityResult.none){
    setState(() {
      connect = 'none';
    });
  }*/
}
TextStyle customTextStyle({double? size, FontWeight? fontWeight,Color? color,TextDecoration? textDecoration,double? space}){
  return TextStyle(
    fontFamily: Strings.fontFamily,
    fontSize: size ?? 15,
    fontWeight: fontWeight ?? FontWeight.w400,
    color: color,
    decoration: textDecoration,

  );
}
