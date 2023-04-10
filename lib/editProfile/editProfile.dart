import 'package:flutter/material.dart';
import 'package:telemedicine_doctor/editProfile/body.dart';

import '../api.dart';
import '../dataClass/dataClass.dart';

class editProfile extends StatefulWidget {

  final String id;
  final List<profile> data;
  const editProfile({Key? key, required this.id, required this.data}) : super(key: key);

  @override
  State<editProfile> createState() => _editProfileState();
}

class _editProfileState extends State<editProfile> {

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: api().getHospital(),
      builder: (context, snapshot) {
        if(snapshot.hasData){
          print(widget.id);
          return body(data: widget.data,id: widget.id, hospitals: snapshot.data!,);
        }
        else{
          return Scaffold(
            body: Container(
              alignment: Alignment.center,
              child: CircularProgressIndicator(backgroundColor: Colors.black,),
            ),
          );
        }
      },
    );
    // return body(data: data,);

  }
}

