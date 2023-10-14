import 'dart:math';
import 'package:another_flushbar/flushbar_helper.dart';
import 'package:second_opinion_app/utils/routes/routes.dart';
import 'package:timezone/data/latest.dart' as timezone;
import 'package:timezone/timezone.dart' as timezone;
import 'package:flutter/material.dart';
import 'package:otp/otp.dart';
import 'package:qr_flutter/qr_flutter.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  late String secretKey;
  late TextEditingController codeController;
  late bool isCodeValid;

  @override
  void initState() {
    super.initState();


    final now = DateTime.now();
    timezone.initializeTimeZones();

    final pacificTimeZone = timezone.getLocation('America/Los_Angeles');
    final date = timezone.TZDateTime.from(now, pacificTimeZone);

    secretKey= OTP.generateTOTPCodeString(
        'JBSWY3DPEHPK3PXP', date.millisecondsSinceEpoch,
        algorithm: Algorithm.SHA1, isGoogle: true);


    codeController = TextEditingController();
    isCodeValid = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Google Authenticator'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(28.0),
          child: Column(crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: codeController,
                onChanged: (value) {
                  final now = DateTime.now();
                  final pacificTimeZone = timezone.getLocation('America/Los_Angeles');
                  final date = timezone.TZDateTime.from(now, pacificTimeZone);

                  secretKey= OTP.generateTOTPCodeString(
                      'JBSWY3DPEHPK3PXP', date.millisecondsSinceEpoch,
                      algorithm: Algorithm.SHA1, isGoogle: true);
                  setState(() {
                    isCodeValid = OTP.constantTimeVerification(value, secretKey);
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Enter code',
                ),
              ),
              // SizedBox(height: 20),
              // ElevatedButton(
              //   onPressed: () {
              //     showDialog(
              //       context: context,
              //       builder: (BuildContext context) {
              //         return AlertDialog(
              //           content: SizedBox(
              //             width: 200,
              //             height: 200,
              //             child: QrImageView(
              //               data: 'otpauth://totp/Warehouse?secret=$secretKey',
              //               version: QrVersions.auto,
              //             ),
              //           ),
              //         );
              //       },
              //     );
              //   },
              //   child: Text('Display QR Code'),
              // ),
              SizedBox(height: 20),
              isCodeValid
                  ? ElevatedButton(
                onPressed: () {
                  final now = DateTime.now();
                  final pacificTimeZone = timezone.getLocation('America/Los_Angeles');
                  final date = timezone.TZDateTime.from(now, pacificTimeZone);

                  secretKey= OTP.generateTOTPCodeString(
                      'JBSWY3DPEHPK3PXP', date.millisecondsSinceEpoch,
                      algorithm: Algorithm.SHA1, isGoogle: true);

                    setState(() {
                      isCodeValid = OTP.constantTimeVerification(codeController.text, secretKey);
                    });


                  if (isCodeValid) {
                    Navigator.pushReplacementNamed(context, Routes.modeSelection);
                  }else{

                    FlushbarHelper.createError(message: 'The Code has expired, Enter the new code').show(context);

                  }
                },
                child: Text('Continue'),
              )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    codeController.dispose();
    super.dispose();
  }
}