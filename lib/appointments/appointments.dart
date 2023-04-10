import 'package:flutter/material.dart';
import 'package:telemedicine_doctor/appointments/body.dart';
import 'package:telemedicine_doctor/dataClass/dataClass.dart';

class appointments extends StatelessWidget {

  final String id;
  final profile doctorProfile;
  final int index;
  const appointments({Key? key, required this.id, required this.doctorProfile, required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return body(id: id, doctorProfile: doctorProfile,index: index,);
  }
}
