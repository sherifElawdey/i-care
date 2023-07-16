import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_geocoder/geocoder.dart';
import 'package:get/get.dart';
import 'package:icare/helper/general_methods.dart';
import 'package:icare/helper/paths/links.dart';
import 'package:icare/helper/paths/strings.dart';
import 'package:icare/helper/state/user_controller.dart';
import 'package:icare/helper/styles/colors.dart';
import 'package:icare/helper/styles/size.dart';
import 'package:icare/helper/validators.dart';
import 'package:icare/modules/tile_item_model.dart';
import 'package:icare/modules/user_model.dart';
import 'package:icare/services/firebase/fire_methods.dart';
import 'package:icare/widgets/buttons.dart';
import 'package:icare/widgets/custom_text.dart';
import 'package:icare/widgets/dialog.dart';
import 'package:icare/widgets/items/tile_item.dart';
import 'package:icare/widgets/loading.dart';
import 'package:icare/widgets/text_field.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';

class AccountDetailsScreen extends StatefulWidget {
  const AccountDetailsScreen({Key? key}) : super(key: key);

  @override
  State<AccountDetailsScreen> createState() => _AccountDetailsScreenState();
}

class _AccountDetailsScreenState extends State<AccountDetailsScreen> {
  File? profilePic;
  final addressController = TextEditingController();
  var user = Get.put(UserController()).userData.value;
  bool locationService = false, loadingLocation = false;
  String openingTime='24 hur', closingTime='24hur';
  bool editMode = false;
  final GlobalKey<FormState> _formStateKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    addressController.text = user.address.toString();
    openingTime=user.timesOfWork?.split(',').first ??'24 hur';
    closingTime=user.timesOfWork?.split(',').last ??'24 hur';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: CustomText(
          text: user.name.toString(),
          size: Sizes.textSize(context)['h3'],
        ),
        leading: CustomBackButton(context),
        actions: [
          IconButton(
            icon: !editMode
                ? const Icon(
                    Icons.edit,
                  )
                : Icon(
                    Icons.done_all,
                    color: appColor,
                  ),
            onPressed: () async{
              if (editMode) {
               await saveData(context);
                editMode = false;
              } else {
                editMode = true;
              }
              setState((){

              });
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formStateKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Align(
                  alignment: Alignment.center,
                  child: GestureDetector(
                    onTap: () {
                      if (user.picture != null) {
                        expandProfileImage(user.picture ?? '');
                      } else {
                        getImage();
                      }
                    },
                    child: Container(
                      height: Sizes.widthScreen(context) * 0.35,
                      width: Sizes.widthScreen(context) * 0.35,
                      margin: EdgeInsets.only(
                          top: Sizes.heightScreen(context) * 0.05,
                          bottom: Sizes.heightScreen(context) * 0.01),
                      decoration: BoxDecoration(
                        border: Border.all(color: appColor, width: 3),
                        shape: BoxShape.circle,
                        image: profilePic == null || profilePic!.path.isEmpty
                            ? DecorationImage(
                                image: NetworkImage(user.picture ?? '',),
                                fit: BoxFit.cover,
                        )
                            : DecorationImage(
                                image: FileImage(profilePic ?? File('')),
                              ),
                      ),
                      alignment: Alignment.bottomRight,
                      child: IconButton(
                        icon: Icon(
                          Icons.add_a_photo_outlined,
                          size: 35,
                          color: Get.isDarkMode ? whiteColor : blackColor,
                        ),
                        onPressed: () {
                          getImage();
                        },
                      ),
                    ),
                  ),
                ),
              ),
              CustomTextField(context,
                  controller: TextEditingController(text: user.email),
                  enabled: false,
                  validator: Validators.instance.validateEmail(context),
                  labelText: 'Email',
                  prefix: const Icon(Icons.email_outlined)),
              CustomTextField(
                context,
                controller: addressController,
                enabled: false,
                validator: Validators.instance.validateName(context),
                labelText: 'Address',
                suffixIcon: loadingLocation
                  ? const CircularProgressIndicator()
                  : IconButton(
                        icon: Icon(
                          Icons.location_on_outlined,
                          color: appColor,
                        ),
                        onPressed: () async {
                          if (editMode) {
                            await getLocation();
                          }
                        },
                      ),
              ),
              CustomTextField(
                context,
                controller: TextEditingController(text: user.phoneNumber),
                enabled: editMode,
                validator: Validators.instance.validateMobileNumber(context),
                labelText: 'Phone Number',
                onChanged: (value){
                  user.phoneNumber=value;
                },
                prefixText: '+2  ',
                suffixIcon: const Icon(
                  Icons.phone_android,
                ),
              ),
              if (user.administration != Administration.user.name)
                timeOfWorkWidget(context),
              if (user.administration == Administration.doctor.name)
                doctorDetailsWidget(context),
            ],
          ),
        ),
      ),
    );
  }

  Future getLocation() async {
    setState(() {
      loadingLocation = true;
    });
    PermissionStatus permissionGranted;
    Location location = Location();

    bool serviceEnabled = await location.serviceEnabled();

    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        locationService = false;
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        locationService = false;
        return;
      }
    }
    await getAddress(await location.getLocation());
  }

  Future getAddress(LocationData position) async {
    final coordinates = Coordinates(position.latitude, position.longitude);
    var address =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    user.location = GeoPoint(position.latitude!, position.longitude!);
    user.address =
        '${address.first.adminArea},${address.first.subAdminArea},${address.first.locality}';
    locationService = true;
    setState((){
      loadingLocation = false;
    });
  }

  timeOfWorkWidget(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            text: 'Days of work :',
            size: Sizes.textSize(context)['h2'],
          ),
          SizedBox(
            height: Sizes.widthScreen(context) * 0.15,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                user.daysOfWork ??= [];
                return Container(
                  padding: EdgeInsets.all(Sizes.widthScreen(context) * 0.02),
                  margin: EdgeInsets.all(Sizes.widthScreen(context) * 0.02),
                  decoration: BoxDecoration(
                    color: user.daysOfWork!
                            .any((element) => days[index] == element)
                        ? appColor
                        : null,
                    borderRadius: Sizes.borderRadius(context)['r1'],
                    border: Border.all(
                        color: user.daysOfWork!
                                .any((element) => days[index] == element)
                            ? appColor
                            : greyColor),
                  ),
                  alignment: Alignment.center,
                  child: GestureDetector(
                    onTap: () {
                      if (editMode) {
                        setState(() {
                          if (user.daysOfWork!
                              .any((element) => days[index] == element)) {
                            user.daysOfWork!.remove(days[index]);
                          } else {
                            user.daysOfWork!.add(days[index]);
                          }
                        });
                      }
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
                CustomText(
                  text: 'From',
                ),
                OutlinedButton(
                  child: CustomText(
                    text: openingTime,
                  ),
                  onPressed: () {
                    if (editMode) {
                      showTimePicker(
                        context: context,
                        helpText: 'opening Time',
                        initialTime: TimeOfDay.now(),
                      ).then((value) {
                        if (value != null) {
                          setState(() {
                            openingTime = value.format(context).toString();
                          });
                        }
                      });
                    }
                  },
                ),
                const SizedBox(
                  child: Icon(CupertinoIcons.arrow_right),
                ),
                CustomText(
                  text: 'To',
                ),
                OutlinedButton(
                  child: CustomText(
                    text: closingTime,
                  ),
                  onPressed: () {
                    if (editMode) {
                      showTimePicker(
                        context: context,
                        helpText: 'Closing Time',
                        initialTime: TimeOfDay.now(),
                      ).then((value) {
                        if (value != null) {
                          setState(() {
                            closingTime = value.format(context).toString();
                          });
                        }
                      });
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  doctorDetailsWidget(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTextField(
          context,
          controller: TextEditingController(text: user.title),
          validator: Validators.instance.validateName(context),
          onChanged: (value){
            user.title=value;
          },
          enabled: editMode,
          labelText: 'Title',
        ),
        PopupMenuButton(
          initialValue:
              user.specialization == null || user.specialization!.isEmpty
                  ? specialization.first
                  : user.specialization,
          shape: RoundedRectangleBorder(
              borderRadius: Sizes.borderRadius(context)['r2']!),
          onSelected: (nValue) {
            if (editMode) {
              setState(() {
                user.specialization = nValue.toString();
              });
            }
          },
          enabled: editMode,
          position: PopupMenuPosition.under,
          constraints: BoxConstraints.tightFor(
              width: Sizes.widthScreen(context) * 0.9),
          child: tileItem(
              context,
              TileItemModel(
                value: user.specialization == null ||
                        user.specialization!.isEmpty
                    ? 'specialization ( التخصص )'
                    : user.specialization.toString(),
                trailingIcon: Icons.keyboard_arrow_down_sharp,
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
          controller: TextEditingController(text: user.disclosurePrice),
          labelText: Strings.disclosurePrice,
          onChanged: (value){
            user.disclosurePrice=value.toString();
          },
          enabled: editMode,
          prefix: const Icon(Icons.attach_money),
          keyboardType: TextInputType.number,
          textInputAction: TextInputAction.next,
          suffixText: 'EGP',
        ),
      ],
    );
  }

  Future getImage() async {
    customDialog(
        title: '${user.picture != null ? 'Change' : 'Select'} Profile picture',
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomTextButton(
              text: 'Choose from gallery',
              onTap: () async {
                var image =
                    await ImagePicker().pickImage(source: ImageSource.gallery);
                if (image != null) {
                  profilePic = File(image.path);
                }
                Get.back();
              },
            ),
            CustomTextButton(
              text: 'Take from camera',
              onTap: () async {
                var image =
                    await ImagePicker().pickImage(source: ImageSource.camera);
                if (image != null) {
                  profilePic = File(image.path);
                }
                Get.back();
              },
            )
          ],
        ));
  }

  Future saveData(BuildContext context) async {
    var data = _formStateKey.currentState;
    if (data != null && data.validate()) {
      user.timesOfWork ='$openingTime,$closingTime';
      showLoading(context: context, dismissible: false);
      await FirebaseMethods()
          .updateModel(path: '${user.reference?.path}', data: user.toJson()).whenComplete(()async {
            if(profilePic!=null){
              await FirebaseMethods().uploadFile('$userCollection/${user.id}.jpg', profilePic!)
                  .then((value) async{
                await FirebaseMethods().updateModel(path: '${user.administration}/$user', data: {
                  'picture' :value
                });
                user.picture=value;
              }).whenComplete(() {
                Get.put(UserController()).userData.update((val) {val=user;});
                Get.back();
              });
            }
          });
      Get.back();
    }else{
      customSnackBar(title: 'no Data[');
    }
  }
}
