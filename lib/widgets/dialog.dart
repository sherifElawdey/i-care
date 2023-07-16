import 'package:icare/helper/styles/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void customDialog(
    {String? title,String? contentText,Widget? content,String? okText,String? cancelText,
      VoidCallback? okTap,VoidCallback? cancelTap,bool? dismissible})=> Get.defaultDialog(
  title: title.toString(),
  middleText: contentText?? '',
  content: content,
  contentPadding:const EdgeInsets.all(10),
  buttonColor: appColor,
  textCancel: cancelText,
  cancelTextColor:errorColor,
  textConfirm: okText,
  onConfirm: okTap,
  confirm: okText==''?const SizedBox():null,
  onCancel: cancelTap,
  confirmTextColor:whiteColor,
  barrierDismissible: dismissible ?? true,
  onWillPop:<bool>()async{
        return dismissible ?? true ;
  },
);

/*
customAlertDialog(BuildContext context,{String? title,String? content,}){
  List<SettingItem> information=[
    SettingItem('لو خرجت من الامتحان سيتم حفظ النتيجه كما عليها ولن تمتحن مره اخري', CupertinoIcons.xmark,(){}),
    SettingItem('لو خرجت من التطبيق سيتم حفظ النتيجه كما عليها ولن تمتحن مره اخري', CupertinoIcons.square_arrow_left,(){}),
    SettingItem('تأكد من الاتصال بالانترنت حتي لا تخرج من الامتحان بسبب انقطاع الاتصال', CupertinoIcons.wifi,(){}),
    SettingItem('اذا انتهي الوقت المحدد سوف يتم انهاء الامتحان تلقائيا وتعتمد النتيجه', CupertinoIcons.timer,(){}),
  ];
  Get.dialog(
    Center(
      child: Card(
        margin: EdgeInsets.all(Sizes.widthScreen(context)*0.1),
        shape: RoundedRectangleBorder(borderRadius: Sizes.borderRadius(context)['r2']!),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomText(
                text: 'Read this ',
                fontWeight: FontWeight.w600,
                size: Sizes.textSize(context)['h2'],
              ),
              CustomText(
                text: 'Before starting the exam ',
              ),
              ListView.separated(
                shrinkWrap: true,
                itemCount: information.length,
                separatorBuilder: (context,index)=>const SizedBox(height: 20,),
                itemBuilder: (context,index)=> Wrap(
                  direction: Axis.vertical,
                  children: [
                    CustomTextIcon(
                        context: context,
                        icon: information[index].icon,
                        text:  information[index].title
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    ),
    useSafeArea: true,

  );
}*/
