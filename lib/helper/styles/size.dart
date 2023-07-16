import 'package:flutter/material.dart';

class Sizes{
    //screen size
  static double heightScreen(BuildContext context){
    return MediaQuery.of(context).size.height;
  }

  static double widthScreen(BuildContext context){
    return MediaQuery.of(context).size.width;
  }

  static EdgeInsets paddingScreenHorizontal(BuildContext context){
    return EdgeInsets.symmetric(horizontal:widthScreen(context)*0.02);
  }
  static EdgeInsets paddingTextFieldHorizontal(BuildContext context){
    return EdgeInsets.symmetric(horizontal:widthScreen(context)*0.03);
  }
  static EdgeInsets paddingScreenVertical(BuildContext context){
    return EdgeInsets.symmetric(vertical:heightScreen(context)*0.01);
  }

  static Map<String,EdgeInsets> paddingAll(BuildContext context)=>{
    'p1': EdgeInsets.all(widthScreen(context)*0.01),
    'p2': EdgeInsets.all(widthScreen(context)*0.02),
    'p3': EdgeInsets.all(widthScreen(context)*0.03),
    'p4': EdgeInsets.all(widthScreen(context)*0.04),
    'p5': EdgeInsets.all(widthScreen(context)*0.06),
  };

  static EdgeInsets paddingTextFields(BuildContext context){
    return EdgeInsets.symmetric(horizontal:widthScreen(context)*0.03,vertical: widthScreen(context)*0.045);
  }

  static EdgeInsets marginTextFields(BuildContext context){

    return EdgeInsets.all(widthScreen(context)*0.03);
  }

  ///text size
  static Map<String,double> textSize(BuildContext context)=>{
  'h1':widthScreen(context)*0.032,
  'h2':widthScreen(context)*0.045,
  'h3':widthScreen(context)*0.05,
  'h4':widthScreen(context)*0.055,
  'h5':widthScreen(context)*0.06,
  };

  ///icons size
  static Map<String,double> iconSize(BuildContext context)=>{
    's1':widthScreen(context)*0.05,
    's2':widthScreen(context)*0.07,
    's3':widthScreen(context)*0.09,
    's4':widthScreen(context)*0.15,
    's5':widthScreen(context)*0.2,
  };

  ///border radius
  static Map<String,BorderRadius> borderRadius(BuildContext context)=>{
  'r1': BorderRadius.all(Radius.circular(widthScreen(context)*0.02)),
  'r2': BorderRadius.all(Radius.circular(widthScreen(context)*0.04)),
  'r3': BorderRadius.all(Radius.circular(widthScreen(context)*0.06)),
  'r4': BorderRadius.all(Radius.circular(widthScreen(context)*0.1)),
  'r5': BorderRadius.all(Radius.circular(widthScreen(context)*0.2)),
};

 /* static Map<String,EdgeInsets> marginWidgetOnly (BuildContext context)=>{

  };*/

  ///sizedBox sizes
  static Map<String,double> sizedBox(BuildContext context)=>{
    'w1':5,
    'w2':10,
    'w3':15,
    'w4':20,
    'w5':25,
    'h1':10,
    'h2':20,
    'h3':30,
    'h4':40,
    'h5':55,
  };

}
