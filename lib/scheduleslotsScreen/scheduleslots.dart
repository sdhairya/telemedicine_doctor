import 'package:flutter/material.dart';
import 'package:telemedicine_doctor/scheduleslotsScreen/bodyDays.dart';

import '../api.dart';
import 'body.dart';

class scheduleslots extends StatelessWidget {

  final String id;
  final int hospitalId;
  const scheduleslots({Key? key, required this.id, required this.hospitalId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // return bodyDays();
    return FutureBuilder(
      future: api().getHospital(),
      builder: (context, snapshot) {
        print(hospitalId);
        if(snapshot.hasData){
          return bodyDays(hospitals: snapshot.data!,id: id, hospitalId: hospitalId,);
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
