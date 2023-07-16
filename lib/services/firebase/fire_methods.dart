import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:icare/helper/general_methods.dart';
import 'package:icare/helper/paths/strings.dart';
import 'package:icare/helper/state/user_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:icare/helper/styles/colors.dart';
import 'package:icare/login/login_screen.dart';
import 'package:icare/modules/user_model.dart';

class FirebaseMethods {

  Future<UserModel> getUserData()async{
    UserModel userModel = UserModel();
    var user = FirebaseAuth.instance.currentUser;
    if(user!=null){
      var fireStore=FirebaseFirestore.instance;
      var userFirestore =await fireStore.collection(user.displayName.toString()).doc(user.uid).get();
      if(userFirestore.data()!=null){
        userModel=UserModel.fromJson(userFirestore.data()!);
      }
    }

    return userModel;
  }

  bool checkUser(){
    User? user = FirebaseAuth.instance.currentUser;
    if(user != null){
      return true;
    }else{
      return false;
    }
  }

  Future<bool> signOut(BuildContext context) async{
    await FirebaseAuth.instance.signOut().whenComplete(() =>
        goToPageReplaceAll(context,const LogInPage()));
    return true;
  }

  Future<bool> signIn(String email, String password) async{
    bool isLoggedIn = false;
    try {
      var user = await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);

      if(user.user!=null){
        await FirebaseMethods().getUserData().then((value){
          Get.put(UserController()).userData.value=value;
        });
        isLoggedIn=true;
      }
    } on FirebaseAuthException catch (e) {
      Get.back(closeOverlays: true);
      if (e.code == 'user-not-found') {
        Get.snackbar(
          Strings.loginProblem,
          Strings.emailNotFound,
          margin:const EdgeInsets.only(top: 20),
          duration: const Duration(seconds: 4),
          icon: const Icon(CupertinoIcons.mail,color: errorColor,),
        );
      }else if (e.code == 'null-user'){
        Get.snackbar(
          Strings.loginProblem,
          'null-user',
          margin:const EdgeInsets.only(top: 20),
          duration: const Duration(seconds: 4),
          icon: const Icon(CupertinoIcons.padlock,color: errorColor,),
        );
      } else if (e.code == 'wrong-password'){
        Get.snackbar(
          Strings.loginProblem,
          Strings.passwordNotFound,
          margin:const EdgeInsets.only(top: 20),
          duration: const Duration(seconds: 4),
          icon: const Icon(CupertinoIcons.padlock,color: errorColor,),
        );
      }else{
        await customSnackBar(
          title: Strings.loginProblem,
          message: 'Something Error , please check your account data and try again',
          icon:  const Icon(CupertinoIcons.padlock,color: errorColor,),
        );
      }
      isLoggedIn=false;
    }
    return isLoggedIn;
  }

  Future<String>signUp(String email, String password,{String? administration ='user',UserModel? userModel})async{
    String id ='';
    try {
      var newUser = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      if(newUser.user!=null){
        newUser.user?.updateDisplayName(administration ?? 'user');
        if(userModel!=null){
          userModel.id=newUser.user!.uid.toString();
          id=newUser.user!.uid.toString();
          await FirebaseMethods().addModelToFirestore(
            collection: administration!,
            doc: newUser.user!.uid.toString(),
            model:userModel.toJson(),
            addReference: true,
          );
        }
      }

    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        customSnackBar(
          title: Strings.loginProblem,
          message: Strings.emailAlreadyExist,
          icon: const Icon(CupertinoIcons.mail,color: errorColor,)
        );
      } else if (e.code == 'invalid-email') {
        customSnackBar(
          title: Strings.loginProblem,
          message:  Strings.emailNotFound,
          icon: const Icon(CupertinoIcons.padlock,color: errorColor,),
        );
      }
      id='error';
    }
    return id;
  }

  Future<DocumentSnapshot<Map<String, dynamic>>?> addUserReference() async {
    var user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return await FirebaseFirestore.instance
          .collection(user.displayName.toString())
          .doc(user.uid)
          .get();
    } else {
      return null;
    }
  }

  Future<UserModel> getUserFromReference(DocumentReference reference) async {
    Map<String, dynamic> data =
        (await reference.get()).data() as Map<String, dynamic>;
    return UserModel.fromJson(data);
  }

  Future<Map<String, dynamic>> getModelFromReference( DocumentReference reference) async {
    Map<String, dynamic> data ={};
    await reference.get().then((value){
      if(value.data()!=null) data=value.data() as Map<String, dynamic>;
    });
    return data;
  }

  Future<String> addModelToFirestore({
    required String collection,
    String? doc,
    required Map<String, dynamic> model,
    bool? addReference,
  }) async {
    String message = '';
      if (doc == null) {
        try{
          await FirebaseFirestore.instance
            .collection(collection)
            .add(model)
            .then((value){
          value.update({
            'id': value.id,
          });
          message = value.id;
        }).catchError((err){
          });
        }on FirebaseException catch (e){
          message = e.code;
        }
      } else {
        try{
        DocumentReference ref =
        FirebaseFirestore.instance.collection(collection).doc(doc);
        await ref
            .set(model)
            .then((value) => message = 'done');
        if (addReference != null && addReference) {
          await ref.update({
            'reference': ref,
          });
        }
        }on FirebaseException catch (e){
          message = e.code;
        }
      }

    return message;
  }

  Future<void> updateModel({required String path,required Map<String, dynamic> data}) async {
    await FirebaseFirestore.instance.doc(path).update(data).onError(
        (error, stackTrace) => customSnackBar(title: error.toString()));
  }

  Future<Map<String, dynamic>> getModelFromFirestore(
    String collection,
    String path,
  ) async {
    var model =
        await FirebaseFirestore.instance.collection(collection).doc(path).get();
    return model.data()!;
  }

  Future<List<Map<String, dynamic>?>> getListFromFirestore(
    String collection, {
    String? whereField,
    Object? conditionEqual,
    dynamic conditionContains,
    String? whereField2,
    String? conditionEqual2,
    dynamic conditionContains2,
    String? whereField3,
    String? conditionEqual3,
    dynamic conditionContains3,
    dynamic whereInListCondition,
    int? limit,
    String? orderBy,
    bool? descending = true,
  }) async {
    List<Map<String, dynamic>?> list = [];
    QuerySnapshot ref;
    var instance = FirebaseFirestore.instance.collection(collection);
    if (whereField != null && whereField2 == null) {
      ref = await instance
          .where(
            whereField.toString(),
            isGreaterThanOrEqualTo: conditionContains,
            isEqualTo: conditionEqual)
          .limit(limit ?? 15)
          .get();
    } else if (whereField != null &&
        whereField2 != null &&
        whereField3 == null) {
      ref = await instance
          .where(
            whereField.toString(),
            isGreaterThanOrEqualTo: conditionContains,
            isEqualTo: conditionEqual,
          )
          .where(whereField2,
              isEqualTo: conditionEqual2,
              isGreaterThanOrEqualTo: conditionContains2)
          .limit(limit ?? 15)
          .get();
    } else if (whereField != null &&
        whereField2 != null &&
        whereField3 != null) {
      ref = await instance
          .where(
            whereField.toString(),
            isGreaterThanOrEqualTo: conditionContains,
            isEqualTo: conditionEqual,
          )
          .where(whereField2,
              isEqualTo: conditionEqual2,
              isGreaterThanOrEqualTo: conditionContains2)
          .where(
            whereField3,
            isEqualTo: conditionEqual3.toString(),
            isGreaterThanOrEqualTo: conditionContains3,
          )
          .limit(limit ?? 15)
          .get();
    } else {
        if (orderBy!=null) {
          ref = await instance.orderBy(orderBy.toString(), descending: descending ?? true).get();
        } else {
          ref = await instance.get();
        }
        ref = await instance.limit(limit ?? 15).get();
    }
    if(whereInListCondition!=null){
      ref = await instance
        .where(whereField.toString(),
          arrayContains: whereInListCondition,
        ).get();
    }

    for (var reference in ref.docs) {
      Map<String, dynamic>? item = reference.data() as Map<String, dynamic>? ?? {};

/*
      if (collection.split('/').last == postsCollection) {
        item.addAll({
          'writer':
              (await getUserFromReference(item['reference'])).toJson()
        });
      }
*/

/*
      if (collection== subjectsCollection){
        List<UserModel> instructors = [];
        for (var r in item['subInstructorsReference'].toList()) {
          instructors.add((await getUserFromReference(r)));
        }
        item.addAll({'subInstructors': instructors});
      }
*/
      list.add(item);
    }
    return list;
  }

  Future<bool> uploadListToFirestore(
      String path,
      List list,
      {bool? addWriter = false}) async {
    bool state = false;
    for (var item in list) {
      await FirebaseFirestore.instance
            .collection(path)
            .add(item.toJson())
            .then((value) async{
              if(addWriter??false){
                await value.update({
                  'writer':Get.put(UserController()).userData.value.reference,
                  'id': value.id,
                });
              }else{
                await value.update({

                  'id': value.id,
                });
              }
        });

      state = true;
    }

    return state;
  }

  Future<bool> deleteFromFireStore(String path) async {
    bool done = false;
    await FirebaseFirestore.instance
        .doc(path)
        .delete()
        .whenComplete(() => done = true)
        .onError((error, stackTrace) => done = false);
    return done;
  }

  Future<String> uploadFile(String path,File file)async{
    String done='error';
    final ref = FirebaseStorage.instance.ref().child(path);
    await ref.putFile(file).then((task)async{
      if(task.state==TaskState.success){
        done= await task.ref.getDownloadURL();
      }else{
        done='error';
      }
    });

    return done;
  }

  Future removeModel(String path)async{
    await FirebaseFirestore.instance.doc(path).delete();
  }
  Future removeCollection(String collection)async{

    await FirebaseFirestore.instance.collection('messages').get().then((snapshot)async {
      for (DocumentSnapshot ds in snapshot.docs) {
        await ds.reference.delete();
      }
    });
  }
}
