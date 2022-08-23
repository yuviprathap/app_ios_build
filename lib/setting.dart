import 'package:path/path.dart' as Path;
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';

final LocalStorage storage = new LocalStorage('localstorage_app');

var api_url =
    storage.getItem('api_url'); 



void showCommonAlert(BuildContext context, alertText, height) {
  var height1 = double.parse(height.toString());
  // show the dialog
  showDialog(
    context: context,
    // barrierDismissible: false,
    builder: (context) {
      return StatefulBuilder(builder: (context, setState) {
        return Dialog(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
            child: Container(
              // color: Colors.black,
              child: SizedBox(
                height: height1,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                        child: Text(
                          alertText,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontFamily: 'Nunito', fontSize: 22),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      });
    },
  );
}
