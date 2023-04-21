import 'package:flutter/material.dart';
import 'package:telemedicine_doctor/videoCall/videoCallScreen.dart';

import '../api.dart';
import '../dataClass/dataClass.dart';

class videoCall extends StatelessWidget {

  final String roomId;
  final String role;
  final appointment appointmentData;
  final profile doctorProfile;

  const videoCall({Key? key, required this.roomId, required this.role, required this.appointmentData, required this.doctorProfile}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: api().getPrescription(appointmentData.id.toString()),
      builder: (context, snapshot) {
        if(snapshot.hasData){
          return videoCallScreen(pres: snapshot.data!,roomId: roomId, role: role, appointmentData: appointmentData, doctorProfile: doctorProfile);
        }
        return Scaffold(
          body: Container(
            alignment: Alignment.center,
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}
