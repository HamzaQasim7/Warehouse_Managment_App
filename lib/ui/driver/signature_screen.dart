import 'dart:io';
import 'dart:typed_data';
import 'package:another_flushbar/flushbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:signature/signature.dart';

class SignatureScreen extends StatefulWidget {
  @override
  _SignatureScreenState createState() => _SignatureScreenState();
}

class _SignatureScreenState extends State<SignatureScreen> {
  File? _image;
  final SignatureController _controller = SignatureController(
    penStrokeWidth: 5,
    penColor: Colors.black,
    exportBackgroundColor: Colors.white,
  );

  Future _getImage() async {
    var image = await ImagePicker().pickImage(source: ImageSource.camera);

    setState(() {
      if (image != null) {
        _image = File(image.path);
      } else {
        print('No image selected.');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Confirmation'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 200,
                width: 300,
                child: Signature(
                  backgroundColor: Colors.blueGrey.shade200,
                  controller: _controller,
                  height: 200,

                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  _controller.clear();
                },
                child: Text('Clear'),
              ),
              SizedBox(height: 20),

              SizedBox(height: 20),
              _image == null
                  ? Text('No image selected.')
                  : Image.file(
                _image!,
                height: 200,
                width: 300,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _getImage,
                child: Text('Pick Image from Camera'),
              ),
              SizedBox(height: 80,),
              Expanded(
                child: ElevatedButton(
                  onPressed: (){

                    if(_image!=null && _controller.isNotEmpty){


                    }else{

                      FlushbarHelper.createError(message: 'Signature and picture are required').show(context);

                    }

                  },
                  child: Text('Confirm Delivery'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}