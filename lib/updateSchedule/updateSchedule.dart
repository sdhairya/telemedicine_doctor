import 'package:flutter/material.dart';
import 'package:telemedicine_doctor/updateSchedule/bodyDays.dart';

import '../api.dart';

class updateSchedule extends StatelessWidget {
  final String id;

  const updateSchedule({Key? key, required this.id}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: api().getHospital(),
      builder: (context, snapshot) {
        print(snapshot.data);
        if(snapshot.hasData){
          return bodyDays(hospitals: snapshot.data!,id: id);
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
