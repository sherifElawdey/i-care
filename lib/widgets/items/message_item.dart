import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icare/helper/state/user_controller.dart';
import 'package:icare/helper/styles/colors.dart';
import 'package:icare/helper/styles/size.dart';
import 'package:icare/modules/message.dart';
import 'package:icare/widgets/custom_text.dart';
import 'package:intl/intl.dart';

class MessageItem extends StatelessWidget {
  MessageModel message;
  MessageItem({Key? key,required this.message}) : super(key: key);
  var myId = Get.put(UserController()).userData.value.id;
  @override
  Widget build(BuildContext context) {
      return Container(
        width: Sizes.widthScreen(context),
        padding: const EdgeInsets.all(16),
        margin: message.senderId==myId
          ? EdgeInsets.only(
            right: Sizes.widthScreen(context)*0.1,
          left: 4,
          top: 4,
          bottom: 4,
        )
          : EdgeInsets.only(
          left: Sizes.widthScreen(context)*0.1,
          right: 4,
          top: 4,
          bottom: 4,
        ),
        decoration: BoxDecoration(
          borderRadius:message.senderId==myId
            ?const BorderRadius.only(
                topRight: Radius.circular(30),
                bottomRight: Radius.circular(30),
                topLeft: Radius.circular(50),
          )
            :const BorderRadius.only(
              topRight: Radius.circular(40),
              bottomLeft: Radius.circular(30),
              topLeft: Radius.circular(30),
          ),
          color: message.senderId==myId?appColor.withOpacity(0.3):greyColor.withOpacity(0.2),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomText(
              text: message.message.toString(),
              size: Sizes.textSize(context)['h2'],
              maxLines: 10,
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: CustomText(
                text: DateFormat.Md().add_jm().format(message.date!.toDate()),
                size: Sizes.textSize(context)['h1'],
              ),
            )
          ],
        ),
      );
  }
}
