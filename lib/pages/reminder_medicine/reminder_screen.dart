import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:icare/helper/general_methods.dart';
import 'package:icare/helper/paths/images.dart';
import 'package:icare/helper/paths/links.dart';
import 'package:icare/helper/state/user_controller.dart';
import 'package:icare/helper/styles/colors.dart';
import 'package:icare/helper/styles/size.dart';
import 'package:icare/helper/validators.dart';
import 'package:icare/modules/reminder.dart';
import 'package:icare/pages/reminder_medicine/notification_manager.dart';
import 'package:icare/services/local/sqlite.dart';
import 'package:icare/widgets/buttons.dart';
import 'package:icare/widgets/custom_text.dart';
import 'package:icare/widgets/items/reminder_item.dart';
import 'package:icare/widgets/text_field.dart';
import 'package:intl/intl.dart';

class ReminderScreen extends StatefulWidget {
  ReminderScreen({Key? key}) : super(key: key);

  @override
  State<ReminderScreen> createState() => _ReminderScreenState();
}

class _ReminderScreenState extends State<ReminderScreen> {
  GlobalKey<FormState> formStateKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: CustomText(
          text: DateFormat.MMMMEEEEd().format(DateTime.now()).toString(),
          size: Sizes.textSize(context)['h3'],
        ),
        leading: CustomBackButton(context),
      ),
      body: Container(
        height: Sizes.heightScreen(context),
        width: Sizes.widthScreen(context),
        decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomRight,
              end: Alignment.topLeft,
              colors: [
                appColor.withOpacity(0.2),
                Colors.transparent,
                appColor.withOpacity(0.1),
                appColor.withOpacity(0.3),
                appColor.withOpacity(0.6),
              ],
            )
        ),
        child: FutureBuilder<List>(
            future: getReminderList(),
            builder: (context,snapshot) {
              if(snapshot.hasData && snapshot.data!=null && snapshot.data!.isNotEmpty){
                return ListView.builder(
                  itemBuilder:(context, index) {
                    var reminder= ReminderModel.fromJson(snapshot.data?[index] ?? {});
                    return ReminderItem(item:reminder);
                  },
                  itemCount: snapshot.data?.length ?? 0,
                );
              }else if(snapshot.hasError){
                return Center(child: CustomText(text: '${snapshot.error} Something Error ,Please try again',),);
              }else if (snapshot.connectionState==ConnectionState.waiting){
                return const Center(child: CircularProgressIndicator(),);
              }else{
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset('${ImagePath.icons}medicine.svg',
                      height: Sizes.heightScreen(context)*0.2,
                      color: appColor.withOpacity(0.3),
                    ),
                    const SizedBox(height: 16,),
                    CustomText(
                      text: 'No Medicines to remember you',
                      size: Sizes.textSize(context)['h2'],
                      maxLines: 2,
                    ),
                  ],
                );
              }
            }
        )
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: appColor,
        child:Icon(Icons.add,color: whiteColor,),
        onPressed: (){
          addMedicineToReminderWidget(context);
        },
      ),
    );
  }

  addMedicineToReminderWidget(BuildContext context){
    String? date;
    var reminder =ReminderModel();
    customBottomSheet(context,
      Form(
        key: formStateKey,
        child: ListView(
          primary: false,
          shrinkWrap: false,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: SvgPicture.asset('${ImagePath.icons}medicine.svg',
                color: appColor,
                height: Sizes.heightScreen(context)*0.1,
              ),
            ),
            CustomTextField(context,
              labelText: 'Medicine Name',
              validator: Validators.instance.validateName(context),
              onChanged: (value){
                 reminder.name=value;
              },
            ),
            CustomTextField(context,
              labelText: 'Amount',
              onChanged: (value){
                 reminder.amount=value;
              },
            ),
            Padding(
              padding: Sizes.paddingTextFieldHorizontal(context),
              child: StatefulBuilder(
                builder: (context,onState) {
                  return OutlinedButton(
                    child: CustomText(text: date ?? 'Add date',),
                    onPressed: (){
                      showTimePicker(
                        context: context,
                        helpText: 'Reminder Time',
                        initialTime: TimeOfDay.now(),
                      ).then((value){
                        if(value!=null){
                            date=value.format(context).toString();
                            reminder.hour=value.hour.toString();
                            reminder.minute=value.minute.toString();
                            onState((){});
                        }
                      });
                    },
                  );
                }
              ),
            ),
            CustomButton(
              context: context,
              text: 'Remember Me',
              onTap: () async {
                await addMedicineToReminder(reminder);
              },
            ),
          ],
        ),
      ),
    );
  }

  addMedicineToReminder(ReminderModel reminder)async{
    var data = formStateKey.currentState;
    if (data != null && data.validate()) {
      var notificationService= NotificationService();
      if(reminder.amount==null || reminder.amount!.isEmpty){
        reminder.amount='1';
      }
      if(reminder.hour==null||reminder.minute==null){
        reminder.hour=DateTime.now().hour.toString();
        reminder.minute=DateTime.now().minute.toString();
      }
      reminder.id=makeId();
      await DataBaseSql().addItem(sqlRemindersTable,reminder.toJson()).whenComplete(()async{
        notificationService.showNotificationDaily(reminder);
        setState(() {
          Get.back();
        });
      });
    }
  }

  int makeId(){
    var rng =Random();
    int id=0;
    id = rng.nextInt(1000);
    return id;
  }

  Future<List> getReminderList()async{
    try{
      return await DataBaseSql().getAllItems(sqlRemindersTable);
    }catch(e){
      return [];
    }

  }
}
