import 'package:flutter/material.dart';
import 'package:telemedicine_doctor/api.dart';
import 'package:telemedicine_doctor/dataClass/dataClass.dart';

import 'body.dart';

class createProfile extends StatefulWidget {

  final String id;
  const createProfile({Key? key, required this.id}) : super(key: key);

  @override
  State<createProfile> createState() => _createProfileState();
}

class _createProfileState extends State<createProfile> {
  @override
  Widget build(BuildContext context) {
    // return body(hospitals: []);
    return FutureBuilder(
      future: api().getHospital(),
    builder: (context, snapshot) {
        print(widget.id);
      if(snapshot.hasData){
        snapshot.data!.add(hospital(id: 0, name: "+ Other Hospital", address: "", phone: "", email: ""));
        return body(hospitals: snapshot.data!,id:  widget.id,);
      }
      return Scaffold(
        body: Container(
          height: double.infinity,
          width: double.infinity,
          alignment: Alignment.center,
          child: CircularProgressIndicator(backgroundColor: Colors.black,),
        ),
      );

    },
    );
  }
}
