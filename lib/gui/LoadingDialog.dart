import 'package:flutter/material.dart';
import 'package:scrabble/gui/GeneralUtilities.dart';

class LoadingDialog extends StatelessWidget {
  LoadingDialog({Key? key, required this.future, required this.successWidget, required this.errorWidget}): super(key: key);

  final Future future;
  final Widget successWidget;
  final Widget errorWidget;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: future,
      builder: (BuildContext context, AsyncSnapshot snapShot) {
        if (snapShot.hasError) {
          print(snapShot.error!.toString());
          return errorWidget;
        }
        if (snapShot.connectionState == ConnectionState.waiting) {
          return const Center(child: SizedBox(
            width: 60,
            height: 80,
            child: CircularProgressIndicator(),
          ));
        }
        return successWidget;
      },
    );
  }
}
