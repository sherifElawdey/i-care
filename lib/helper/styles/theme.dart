import 'package:icare/helper/styles/colors.dart';
import 'package:flutter/material.dart';

class MyTheme{
  static final darkTheme =ThemeData(
    scaffoldBackgroundColor: const Color(0xff232323),//Color(0xff16161e),
    colorScheme: ColorScheme.dark(primary: appColor),
    primaryColor:Colors.black,
    shadowColor:const Color(0x31ffffff),
    primaryIconTheme:const IconThemeData(color: Colors.white),
    iconTheme:const IconThemeData(color: Colors.white),
    appBarTheme: AppBarTheme(
      iconTheme: IconThemeData(color: whiteColor,size: 30),
      backgroundColor: Colors.transparent,
      elevation: 0,
      titleTextStyle: TextStyle(color:whiteColor,fontSize: 30 ),
      actionsIconTheme: IconThemeData(color:whiteColor),
      toolbarTextStyle: TextStyle(color: whiteColor),
    ),

    fontFamily: 'Montserrat',
    cardColor:const Color(0xff181818),
    textButtonTheme: TextButtonThemeData(style: ButtonStyle(foregroundColor: MaterialStateProperty.all(Colors.white))),

  );

  static final lightTheme =ThemeData(
    scaffoldBackgroundColor: Colors.grey.shade100,
    colorScheme: ColorScheme.light(primary: appColor),
    primaryColor:Colors.white,
    shadowColor:const Color(0x6b525151),
    primaryIconTheme:const IconThemeData(color:Colors.black),
    iconTheme: IconThemeData(color: Colors.grey.shade600),
    fontFamily: 'Montserrat',
    appBarTheme: AppBarTheme(
      iconTheme: IconThemeData(color: blackColor,size: 30),
      backgroundColor: Colors.transparent,
      elevation: 0,
      titleTextStyle: TextStyle(color:blackColor,fontSize: 30 ),
      actionsIconTheme: IconThemeData(color:blackColor),
      toolbarTextStyle: TextStyle(color: blackColor),
    ),
    textButtonTheme: TextButtonThemeData(style: ButtonStyle(foregroundColor: MaterialStateProperty.all(Colors.black))),

  );
}
