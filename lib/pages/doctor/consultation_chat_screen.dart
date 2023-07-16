import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icare/helper/paths/links.dart';
import 'package:icare/helper/state/user_controller.dart';
import 'package:icare/helper/styles/colors.dart';
import 'package:icare/helper/styles/size.dart';
import 'package:icare/modules/message.dart';
import 'package:icare/modules/user_model.dart';
import 'package:icare/services/firebase/fire_methods.dart';
import 'package:icare/widgets/buttons.dart';
import 'package:icare/widgets/custom_images.dart';
import 'package:icare/widgets/custom_text.dart';
import 'package:icare/widgets/items/message_item.dart';
import 'package:icare/widgets/loading.dart';
import 'package:icare/widgets/text_field.dart';

class ChatScreen extends StatefulWidget {
  final ConsultModel receiver;

  const ChatScreen({Key? key, required this.receiver}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {

  var methods= FirebaseMethods();
  var currentUser = Get.put(UserController()).userData.value;
  final messageController = TextEditingController();
  bool isReceiver=false;
  @override
  void initState() {
    super.initState();
    isReceiver=currentUser.id==widget.receiver.receiverPath?.split('/').last;
  }
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: CustomText(
          text:!isReceiver
              ? widget.receiver.receiverName.toString()
              :widget.receiver.senderName.toString(),
          size: Sizes.textSize(context)['h3'],
        ),
        leading: CustomBackButton(context),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: profilePicture(isReceiver
                ? widget.receiver.receiverPicture.toString()
                :widget.receiver.senderPicture.toString(), 40),
          )
        ],
      ),
      body: FutureBuilder<List>(
          future: getChatList(),
          builder: (context, snapshot) {
            if (snapshot.hasData &&
                snapshot.data != null &&
                snapshot.data!.isNotEmpty){
              return Container(
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
                    )),
                child: Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        padding:const EdgeInsets.only(top: 8),
                        itemBuilder: (context, index) {
                          return MessageItem(message:MessageModel.fromJson(snapshot.data![index]));
                        },
                        itemCount: snapshot.data?.length ?? 0,
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: CustomTextField(
                            context,
                            controller: messageController,
                            hintText: 'write your consult...',
                            textInputAction: TextInputAction.newline,
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.send_outlined,
                            color: appColor,
                            size: 30,
                          ),
                          onPressed: ()async{
                            await sendMessage(messageController.text.trim()).whenComplete((){
                              setState((){
                                messageController.clear();
                              });
                            });
                          },
                        )
                      ],
                    ),

                  ],
                ),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: CustomText(
                  text:
                      'Something Error ,${snapshot.error}Please try again',
                ),
              );
            } else if (snapshot.connectionState ==
                ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return Center(
                child: CustomButton(
                  context: context,
                  text: 'Start your first Consultation',
                  onTap: ()async{
                    await firstConsultation(context);
                  },
                ),
              );
            }
          }),
    );
  }

  Future<List> getChatList() async {
    if (currentUser.administration == Administration.doctor.name &&isReceiver) {
        return await methods.getListFromFirestore(
            '${currentUser.reference?.path}/$consultationsCollection/${widget.receiver.senderPath?.split('/').last}/$chatsCollection',
          orderBy:'date',
          descending: false,

        );
      } else {
      return await methods.getListFromFirestore(
          '${widget.receiver.receiverPath}/$consultationsCollection/${currentUser.id}/$chatsCollection',
        orderBy:'date',
        descending: false,
      );
    }
  }

  Future firstConsultation(BuildContext context) async {
    showLoading(context: context, dismissible: false);
    await methods.addModelToFirestore(
      collection: '${currentUser.reference?.path}/$consultationsCollection',
      doc: '${widget.receiver.receiverPath?.substring(widget.receiver.receiverPath?.indexOf('/')??28)}',
      model: ConsultModel(
        receiverPicture: widget.receiver.receiverPicture,
        receiverName: widget.receiver.receiverName,
        senderName: currentUser.name,
        senderPicture: currentUser.picture,
        senderPath: currentUser.reference?.path,
        receiverPath: widget.receiver.receiverPath,
        read: true,
      ).toJson(),
    ).whenComplete(() async{
      await methods.addModelToFirestore(
          collection: '${widget.receiver.receiverPath}/$consultationsCollection',
          doc: '${currentUser.id}',
          model: ConsultModel(
          receiverPicture: widget.receiver.receiverPicture,
          receiverName: widget.receiver.receiverName,
          receiverPath:  widget.receiver.receiverPath,
          senderName: currentUser.name,
          senderPicture: currentUser.picture,
          senderPath: currentUser.reference?.path,
          read: false,
      ).toJson());
    }).whenComplete(() async {
      await sendMessage('السلام عليكم').whenComplete((){
        setState(() {
          Get.back();
        });
      });
    });
  }

  Future sendMessage(String message) async {
    if (currentUser.administration == Administration.doctor.name && isReceiver){
      await methods.addModelToFirestore(
        collection:'${currentUser.reference?.path}/$consultationsCollection/${widget.receiver.senderPath?.split('/').last}/$chatsCollection',
        model: MessageModel(
          message: message,
          date: Timestamp.now(),
          senderId: currentUser.id.toString(),
        ).toJson(),
      );
    } else {
      await methods.addModelToFirestore(
          collection:'${widget.receiver.receiverPath}/$consultationsCollection/${currentUser.id}/$chatsCollection',
          model: MessageModel(
            message: message,
            date: Timestamp.now(),
            senderId: currentUser.id.toString(),
          ).toJson(),
      );
    }
  }
}
