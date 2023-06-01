import 'package:flutter/material.dart';
import 'package:telemedicine_doctor/visitConsult/body.dart';

import '../dataClass/dataClass.dart';

class visitConsult extends StatelessWidget {
  final appointment appointmentData;
  final profile doctorProfile;

  const visitConsult({Key? key,required this.appointmentData, required this.doctorProfile}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return body(doctorProfile: doctorProfile, appointmentData: appointmentData,);
  }
}
