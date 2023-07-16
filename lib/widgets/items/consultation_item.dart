import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icare/helper/paths/links.dart';
import 'package:icare/helper/state/user_controller.dart';
import 'package:icare/helper/styles/colors.dart';
import 'package:icare/helper/styles/size.dart';
import 'package:icare/modules/message.dart';
import 'package:icare/pages/doctor/consultation_chat_screen.dart';
import 'package:icare/widgets/custom_images.dart';
import 'package:icare/widgets/custom_text.dart';

class ConsultationItem extends StatelessWidget {
  ConsultModel consultModel;
  ConsultationItem({Key? key,required this.consultModel}) : super(key: key);
  var currentUser=Get.put(UserController()).userData.value;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: Sizes.borderRadius(context)['r2'],
        color: Theme.of(context).cardColor.withOpacity(0.5),
      ),
      child: GestureDetector(
        onTap: ()async {
         Get.to(ChatScreen(receiver: consultModel));
        },
        child: Row(
          children:[
            profilePicture(currentUser.id==consultModel.receiverPath?.split('/').last
                ? consultModel.senderPicture.toString()
                :consultModel.receiverPicture.toString(),
              50,),
            const SizedBox(width: 8,),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: '${consultModel.senderPath?.split('/').first==doctorsCollection
                        ?'Dr :'
                        :consultModel.senderPath?.split('/').first==pharmacyCollection
                        ?'Dr : '
                        : ''} ${currentUser.id==consultModel.receiverPath?.split('/').last
                        ? consultModel.senderName.toString()
                        :consultModel.receiverName.toString()}',
                  ),
                ],
              ),
            ),
            if(consultModel.read==false)
              Icon(Icons.circle,color: appColor,size: 16,),
          ],
        ),
      ),
    );
  }

  Future openChat({String? id}) async {

  }
}
