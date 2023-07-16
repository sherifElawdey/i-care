import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_geocoder/geocoder.dart';
import 'package:get/get.dart';
import 'package:icare/helper/general_methods.dart';
import 'package:icare/helper/paths/images.dart';
import 'package:icare/helper/paths/links.dart';
import 'package:icare/helper/paths/strings.dart';
import 'package:icare/helper/state/user_controller.dart';
import 'package:icare/helper/styles/colors.dart';
import 'package:icare/helper/styles/size.dart';
import 'package:icare/helper/validators.dart';
import 'package:icare/modules/tile_item_model.dart';
import 'package:icare/modules/user_model.dart';
import 'package:icare/pages/home/home.dart';
import 'package:icare/services/firebase/fire_methods.dart';
import 'package:icare/widgets/buttons.dart';
import 'package:icare/widgets/custom_text.dart';
import 'package:icare/widgets/dialog.dart';
import 'package:icare/widgets/items/tile_item.dart';
import 'package:icare/widgets/loading.dart';
import 'package:icare/widgets/text_field.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';

class CompleteDataScreen extends StatefulWidget {
  UserModel userModel;
  CompleteDataScreen({Key? key,required this.userModel}) : super(key: key);

  @override
  State<CompleteDataScreen> createState() => _CompleteDataScreenState();
}

class _CompleteDataScreenState extends State<CompleteDataScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _disclosurePriceController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();

  bool locationService= false,loadingLocation = false;

  String openingTime='24 hur', closingTime='24hur';

  GlobalKey<FormState> formStateKey = GlobalKey<FormState>();
  File? profilePic ,idPicture;

  @override
  void initState() {
    super.initState();
    widget.userModel.administration =Administration.user.name;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        title: CustomText(
          text: 'Complete Your Data',
          size: Sizes.textSize(context)['h2'],
        ),
        leading: CustomBackButton(context),
      ),
      body: SingleChildScrollView(
        padding: Sizes.paddingScreenHorizontal(context),
        child: Column(
         children:[
           GestureDetector(
             onTap: (){
               getImage(true);
             },
             child: Container(
               height: Sizes.widthScreen(context)*0.3,
               width:  Sizes.widthScreen(context)*0.3,
               margin: EdgeInsets.only(
                   top: Sizes.heightScreen(context)*0.05,
                   bottom: Sizes.heightScreen(context)*0.01
               ),
               decoration: BoxDecoration(
                 border: Border.all(color: greyColor,width: 2),
                 shape: BoxShape.circle,
                 image:profilePic==null||profilePic!.path.isEmpty
                     ?const DecorationImage(
                     image: AssetImage(ImagePath.emptyProfile)
                 )
                     : DecorationImage(
                   image: FileImage(profilePic?? File('')),
                 ),
               ),
               alignment: Alignment.bottomRight,
               child:const Icon(Icons.add_a_photo_outlined,size: 30,),
             ),
           ),
           completeDataForm(context),
         ],
        ),
      ),
      bottomNavigationBar: CustomButton(
        context: context,
        text: 'Complete',
        onTap: (){
          completePressed(context);
        },
      ),
    );
  }

  completeDataForm(BuildContext context) => Form(
    key: formStateKey,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children:[
        CustomTextField(
          context,
          controller: _phoneController,
          validator: Validators.instance.validateMobileNumber(context),
          labelText: Strings.phone,
          prefix: const Icon(Icons.phone),
          keyboardType: TextInputType.phone,
          hintText: Strings.hintPhone,
          textInputAction: TextInputAction.next,
        ),
        Container(
          margin: Sizes.paddingScreenHorizontal(context),
          padding:const EdgeInsets.all(8),
          decoration: widget.userModel.address!=null
              ?BoxDecoration(
            borderRadius: Sizes.borderRadius(context)['r1'],
            border: Border.all(color: greyColor),
          ):null,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if(widget.userModel.address!=null)Expanded(
                child: CustomText(
                  text: '${widget.userModel.address}',
                  maxLines: 3,
                ),
              ),
              !loadingLocation? OutlinedButton(
                child: CustomTextIcon(
                  context: context,
                  text: 'Get Location',
                  icon: Icons.location_on_outlined,
                ),
                onPressed: ()async{
                  await getLocation();
                },
              ):const CircularProgressIndicator(),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: CustomText(
            text: 'Who Are You ?',
            size: Sizes.textSize(context)['h2'],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children:[
            Expanded(
              child: Container(
                margin: EdgeInsets.all(Sizes.widthScreen(context)*0.02),
                decoration: BoxDecoration(
                  color: widget.userModel.administration==Administration.user.name? appColor: null,
                  borderRadius: Sizes.borderRadius(context)['r1'],
                  border: Border.all(
                    color:widget.userModel.administration==Administration.user.name? appColor: greyColor
                  ),
                ),
                alignment: Alignment.center,
                child: CustomTextButton(
                  text: Administration.user.name,
                  onTap: (){
                    setState(() {
                      widget.userModel.administration=Administration.user.name;
                    });
                  },
                ),
              ),
            ),
            Expanded(
              child: Container(
                margin:EdgeInsets.all(Sizes.widthScreen(context)*0.02),
                decoration: BoxDecoration(
                  color: widget.userModel.administration==Administration.doctor.name? appColor: null,
                  borderRadius: Sizes.borderRadius(context)['r1'],
                  border: Border.all(
                    color:widget.userModel.administration==Administration.doctor.name? appColor: greyColor,
                  ),
                ),
                alignment: Alignment.center,
                child: CustomTextButton(
                  text: Administration.doctor.name,
                  onTap: (){
                    setState(() {
                      widget.userModel.administration=Administration.doctor.name;
                    });
                  },
                ),
              ),
            ),
            Expanded(
              child: Container(
                margin:EdgeInsets.all(Sizes.widthScreen(context)*0.02),
                decoration: BoxDecoration(
                  color: widget.userModel.administration==Administration.pharmacy.name? appColor: null,
                  borderRadius: Sizes.borderRadius(context)['r1'],
                  border: Border.all(color: widget.userModel.administration==Administration.pharmacy.name? appColor: greyColor),
                ),
                alignment: Alignment.center,
                child: CustomTextButton(
                  text: Administration.pharmacy.name,
                  onTap: (){
                    setState(() {
                      widget.userModel.administration=Administration.pharmacy.name;
                    });
                  },
                ),
              ),
            ),
          ],
        ),
        if(widget.userModel.administration!=Administration.user.name)
          customDataForm(context),
      ],
    ),
  );
  customDataForm(BuildContext context){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children:[
        CustomText(text: 'Days of work :',size: Sizes.textSize(context)['h2'],),
        SizedBox(
          height: Sizes.widthScreen(context)*0.15,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemBuilder: (context,index){
              widget.userModel.daysOfWork ??= [];
              return Container(
                padding: EdgeInsets.all(Sizes.widthScreen(context)*0.02),
                margin: EdgeInsets.all(Sizes.widthScreen(context)*0.02),
                decoration: BoxDecoration(
                  color: widget.userModel.daysOfWork!.any((element) => days[index]==element)? appColor: null,
                  borderRadius: Sizes.borderRadius(context)['r1'],
                  border: Border.all(
                      color:widget.userModel.daysOfWork!.any((element) => days[index]==element)? appColor: greyColor
                  ),
                ),
                alignment: Alignment.center,
                child: GestureDetector(
                  onTap: (){
                    setState((){
                      if(widget.userModel.daysOfWork!.any((element) => days[index]==element)){
                        widget.userModel.daysOfWork!.remove(days[index]);
                      }else{
                        widget.userModel.daysOfWork!.add(days[index]);
                      }
                    });
                  },
                  child: CustomText(
                    text: days[index],
                  ),
                ),
              );
            },
            itemCount: days.length,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(text: 'From',),
              OutlinedButton(
                child: CustomText(text: openingTime,),
                onPressed: (){
                  showTimePicker(
                    context: context,
                    helpText: 'opening Time',
                    initialTime: TimeOfDay.now(),
                  ).then((value){
                    if(value!=null){
                      setState(() {
                        openingTime=value.format(context).toString();
                      });
                    }
                  });
                },
              ),
              const SizedBox(
                child:Icon(CupertinoIcons.arrow_right),
              ),
              CustomText(text: 'To',),
              OutlinedButton(
                child: CustomText(text: closingTime,),
                onPressed: (){
                  showTimePicker(
                    context: context,
                    helpText: 'Closing Time',
                    initialTime: TimeOfDay.now(),
                  ).then((value){
                    if(value!=null){
                      setState(() {
                        closingTime=value.format(context).toString();
                      });
                    }
                  });
                },
              ),
            ],
          ),
        ),
        const Divider(),
        if(widget.userModel.administration==Administration.doctor.name)
          doctorForm(context),
      ],
    );
  }

  doctorForm(BuildContext context){
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children:[
        CustomTextField(
          context,
          controller: _titleController,
          validator: Validators.instance.validateName(context),
          labelText: Strings.doctorTitle,
          prefix: const Icon(Icons.subtitles_outlined),
          textInputAction: TextInputAction.next,
        ),
        Container(
          margin: Sizes.paddingScreenHorizontal(context),
          padding:const EdgeInsets.all(8),
          decoration: idPicture!=null
              ?BoxDecoration(
            borderRadius: Sizes.borderRadius(context)['r1'],
            border: Border.all(color: greyColor),
          ):null,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if(idPicture!=null)Expanded(
                child: CustomText(
                  text: '${idPicture?.path}',
                  maxLines: 1,
                ),
              ),
              OutlinedButton(
                child: CustomTextIcon(
                  context: context,
                  text: 'Picture card',
                  icon: Icons.add_a_photo_outlined,
                ),
                onPressed: ()async{
                  await getImage(false);
                },
              ),
            ],
          ),
        ),

        CustomText(
          text: 'Specialization :',
          size: Sizes.textSize(context)['h2'],
        ),
        PopupMenuButton(
          initialValue: widget.userModel.specialization==null||widget.userModel.specialization!.isEmpty
              ? specialization.first
              : widget.userModel.specialization,
          shape: RoundedRectangleBorder(
              borderRadius: Sizes.borderRadius(context)['r2']!),
          onSelected: (nValue) {
            setState(() {
              widget.userModel.specialization = nValue.toString();
            });
          },
          position: PopupMenuPosition.under,
          constraints: BoxConstraints.tightFor(
              width: Sizes.widthScreen(context) * 0.9),
          child: tileItem(context,TileItemModel(
              value: widget.userModel.specialization==null||widget.userModel.specialization!.isEmpty
                  ? 'specialization ( التخصص )'
                  : widget.userModel.specialization.toString(),
              trailingIcon:Icons.keyboard_arrow_down_sharp,
            padding: Sizes.paddingScreenHorizontal(context),
            margin: Sizes.paddingTextFields(context),
          )),
          itemBuilder: (context) => List.generate(
            specialization.length,
                (index) => PopupMenuItem(
              value: specialization[index],
              child: CustomText(
                text: specialization[index],
              ),
            ),
          ),
        ),
        CustomTextField(
          context,
          controller: _disclosurePriceController,
          labelText: Strings.disclosurePrice,
          prefix: const Icon(Icons.attach_money),
          keyboardType: TextInputType.number,
          textInputAction: TextInputAction.next,
          suffixText: 'EGP',
        ),
        SizedBox(height: Sizes.heightScreen(context)*0.15,),
      ],
    );
  }

  Future getImage(bool isProfile) async{
    customDialog(
        title: '${profilePic!=null||idPicture !=null?'Change':'Select'} Profile picture',
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomTextButton(
              text: 'Choose from gallery',
              onTap: ()async{
                var image = await ImagePicker().pickImage(source: ImageSource.gallery);
                if(image!=null){
                  if(isProfile){
                    profilePic=File(image.path);
                  }else{
                    idPicture=File(image.path);
                  }

                }
                Get.back();
                setState(() {});
              },
            ),
            CustomTextButton(
              text: 'Take from camera',
              onTap: ()async{
                var image = await ImagePicker().pickImage(source: ImageSource.camera);
                if(image!=null){
                  if(isProfile){
                    profilePic=File(image.path);
                  }else{
                    idPicture=File(image.path);
                  }
                }
                Get.back();
                setState(() {});
              },
            )
          ],
        )
    );
  }

  Future getLocation() async{
    setState(() {
      loadingLocation=true;
    });
      PermissionStatus permissionGranted;
      Location location =Location();

      bool serviceEnabled = await location.serviceEnabled();

      if(!serviceEnabled){
        serviceEnabled= await location.requestService();
        if(!serviceEnabled){
          locationService=false;
          return;
        }
      }

      permissionGranted=await location.hasPermission();
      if(permissionGranted==PermissionStatus.denied){
        permissionGranted=await location.requestPermission();
        if (permissionGranted != PermissionStatus.granted) {
          locationService=false;
          return ;
        }
      }
      await getAddress(await location.getLocation());

  }

  Future getAddress(LocationData position) async{
    final coordinates = Coordinates(position.latitude, position.longitude);
    var address = await Geocoder.local.findAddressesFromCoordinates(coordinates);
    widget.userModel.location =GeoPoint(position.latitude!, position.longitude!);
    widget.userModel.address =
    '${address.first.adminArea},${address.first.subAdminArea},${address.first.locality}';
    locationService=true;
    setState(() {
      loadingLocation=false;
    });
  }

  bool checkDone(){
    bool done=false;
    var data = formStateKey.currentState;
    if (data != null && data.validate()){
      if( widget.userModel.location==null && widget.userModel.address==null){
        customSnackBar(
            title: 'please add your location'
        );
        done=false;
      }else if(widget.userModel.administration==Administration.doctor.name){
        if(widget.userModel.specialization==null){
          done=false;
        }else if(_titleController.text.isEmpty){
          done=false;
        }else if(idPicture==null){
          done=false;
        }else if(_disclosurePriceController.text.isEmpty){
          done=false;
        }else{
          done=true;
        }
      }else{
        done=true;
      }
    }else{
      done=false;
    }
    return done;
  }

  completePressed(BuildContext context)async{
    if (checkDone()){
      widget.userModel.daysOfWork ??= ['daily'];
      if(widget.userModel.administration!=Administration.user.name){
        if(widget.userModel.timesOfWork!=null){
          widget.userModel.timesOfWork ='$openingTime,$closingTime';
        }else{
          widget.userModel.timesOfWork = '24 hur';
        }
        if(widget.userModel.administration==Administration.doctor.name){
          widget.userModel.disclosurePrice=_disclosurePriceController.text;
          widget.userModel.title=_titleController.text;
          widget.userModel.verified=false;
        }
      }
      widget.userModel.phoneNumber=_phoneController.text;

      final methods =FirebaseMethods();

      showLoading(context: context, dismissible: false);

      if(widget.userModel.email!=null && widget.userModel.password!=null){
        await methods.signUp(
          widget.userModel.email!,
          widget.userModel.password!,
          administration: widget.userModel.administration,
          userModel: widget.userModel,
        ).then((id)async{
          if(id!='error'){
            if(profilePic!=null){
              await methods.uploadFile('$userCollection/$id.jpg', profilePic!)
                  .then((value) async{
                await methods.updateModel(path: '${widget.userModel.administration}/$id', data: {
                  'picture' :value
                });
                widget.userModel.picture=value;
              } );
            }
            if(widget.userModel.administration==Administration.doctor.name &&idPicture!=null){
              await methods.uploadFile('$requestsCollection/$id.jpg', idPicture!)
                  .then((value) async{
                await methods.addModelToFirestore(collection: requestsCollection,model:{
                  'doctorId': id,
                  'idPicture' : value,
                  'title' : widget.userModel.title,
                  'name' : widget.userModel.name,
                });
                widget.userModel.idPicture=value;
              });
            }
            Get.put(UserController()).userData.value=widget.userModel;
            Get.back();
            goToPageReplaceAll(context,const Home());
          }
        }).whenComplete(() async{

        });
      }

    }
  }
}
