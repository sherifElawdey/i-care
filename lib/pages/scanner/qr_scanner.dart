import 'dart:async';
import 'package:flutter/material.dart';
import 'package:icare/helper/general_methods.dart';
import 'package:icare/helper/paths/links.dart';
import 'package:icare/helper/paths/strings.dart';
import 'package:icare/helper/styles/colors.dart';
import 'package:icare/helper/styles/size.dart';
import 'package:icare/modules/appointment_model.dart';
import 'package:icare/modules/order_model.dart';
import 'package:icare/pages/scanner/scan_result_screen.dart';
import 'package:icare/widgets/buttons.dart';
import 'package:icare/widgets/custom_text.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QrScanner extends StatefulWidget {
  List list;
  String screen;
  QrScanner({Key? key,required this.list,required this.screen}) : super(key: key);
  @override
  State<QrScanner> createState() => _QrScannerState();
}

class _QrScannerState extends State<QrScanner> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  Barcode? result;
  String state ='Scan Qr Code inside frame';
  Color stateColor=greyColor;
  @override
  void reassemble() {
    super.reassemble();
    // if (Platform.isAndroid) {
    //   controller!.pauseCamera();
    // } else if (Platform.isIOS) {
    //   controller!.resumeCamera();
    // }
  }
  @override
  void initState() {
    super.initState();

  }
  @override
  void dispose(){
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body:Stack(
          fit: StackFit.expand,
          children:[
            Center(
              child:QRView(
                key: qrKey,
                onQRViewCreated: _onQRViewCreated,
                overlay: QrScannerOverlayShape(
                    borderColor: appColor,
                    borderRadius: 15,
                    borderLength: 40,
                    borderWidth: 10,
                    cutOutSize: Sizes.widthScreen(context)*0.8,
                  //overlayColor: stateColor.withOpacity(0.7),
                ),
                onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
              ),
            ),
            scannedState(context),
          ],
        ),
      bottomNavigationBar: CustomButton(
        context: context,
        text: Strings.finish,
        onTap: finishScan,
      ),
    );
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
        //checkCodeAndAddInList(context,scanData.code.toString());
      });
    },);
  }

  scannedState(BuildContext context) {
    if(result!=null){
      checkCodeAndAddInList(context,result!.code.toString());
    }else{
      setState(() {
        state='Scan Qr Code inside frame';
      });
    }
    return Positioned(
      top: Sizes.heightScreen(context)*0.15,
      left:Sizes.widthScreen(context)*0.1,
      right:Sizes.widthScreen(context)*0.1,
      height: Sizes.widthScreen(context)*0.2,
      child: Align(
        alignment: Alignment.center,
        child: Container(
            padding:const EdgeInsets.all(4),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: Sizes.borderRadius(context)['r1'],
              color:stateColor,
            ),
            child:CustomText(
              text: state,
              size: Sizes.textSize(context)['h3'],
            ),
          ),
      ),
    );
  }
  checkCodeAndAddInList(BuildContext context,String code) {
     widget.list.any((element){
      if(element['id']==code){
        setState(() {
          state='Scanned Successfully';
          stateColor=Colors.green;
        });
          Timer(const Duration(seconds: 1), ()=>goToPageReplace(context, ScannerResultScreen(
            item:widget.screen==ordersCollection
                ?OrderModel.fromJson(element)
                :AppointmentModel.fromJson(element),
            screen: widget.screen,)));

        return true;
      }else{
        setState((){
          state='Scan Qr Code inside frame';
          stateColor=greyColor;
        });
        return false;
      }
    });
  }
  finishScan(){}
}