import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:icare/helper/general_methods.dart';
import 'package:icare/helper/paths/images.dart';
import 'package:icare/helper/paths/links.dart';
import 'package:icare/helper/styles/colors.dart';
import 'package:icare/helper/styles/size.dart';
import 'package:icare/modules/reminder.dart';
import 'package:icare/pages/reminder_medicine/notification_manager.dart';
import 'package:icare/pages/reminder_medicine/reminder_screen.dart';
import 'package:icare/services/local/sqlite.dart';
import 'package:icare/widgets/custom_text.dart';
import 'package:icare/widgets/dialog.dart';

class ReminderItem extends StatelessWidget {
  final ReminderModel item;
  const ReminderItem({Key? key,required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Sizes.widthScreen(context),
      padding:const EdgeInsets.all(8),
      margin:const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: Sizes.borderRadius(context)['r2'],
      ),
      child: Row(
        children: [
          SvgPicture.asset(
            '${ImagePath.icons}medicine.svg',
            height: 30,
            color: Get.isDarkMode?whiteColor:Colors.black,
          ),
          const SizedBox(
            width: 8,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children:[
                CustomText(
                  text: item.name.toString(),
                  size: Sizes.textSize(context)['h2'],
                  maxLines: 2,
                  fontWeight: FontWeight.w600,
                ),
                CustomText(
                  text: 'amount : ${item.amount}',
                  size: Sizes.textSize(context)['h1'],
                ),
              ],
            ),
          ),
          CustomText(
            text:TimeOfDay(
              hour: int.parse(item.hour.toString()),
              minute: int.parse(item.minute.toString())).format(context),
            size: Sizes.textSize(context)['h2'],
          ),
          IconButton(
            icon:const Icon(Icons.delete_outline,color: errorColor,),
            onPressed: (){
              customDialog(
                title: 'Delete Medicine',
                contentText: 'Do you want to delete ${item.name} ??',
                okText: 'Yes',
                cancelText: 'Cancel',
                okTap: ()async{
                  await deleteReminder(context);
                }
              );

            },
          )

        ],
      ),
    );
  }

  deleteReminder(BuildContext context) async{
    await DataBaseSql().deleteItem(sqlRemindersTable, item.id).whenComplete(()async{
      await NotificationService().cancelNotifications(item.id ?? 0).whenComplete((){
        Get.back();
        goToPageReplace(context, ReminderScreen());
      });
    });
  }

}
