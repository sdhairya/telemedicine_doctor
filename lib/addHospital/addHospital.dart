import 'package:flutter/material.dart';
import 'package:telemedicine_doctor/addHospital/body.dart';

class addHospital extends StatelessWidget {

  final String id;
  const addHospital({Key? key, required this.id}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return body(id: id,);
  }
}
