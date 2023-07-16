import 'package:flutter/material.dart';
import 'package:get/get.dart';

showLoading({required BuildContext context,required bool dismissible}){
  showGeneralDialog(
    context: context,
    barrierDismissible: dismissible,
    pageBuilder: (context,animation,_){
      return const Center(
        child: CircularProgressIndicator(),
      );
    },
  );
}

showLoading2({required Future Function() future}){
  Get.showOverlay(
    asyncFunction:future,
    loadingWidget: const Center(
      child: CircularProgressIndicator(),
    ),
  );
}