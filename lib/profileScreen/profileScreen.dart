import 'package:flutter/material.dart';
import 'package:telemedicine_doctor/profileScreen/body.dart';

import '../dataClass/dataClass.dart';

class profileScreen extends StatelessWidget {

  final String id;
  final String? img;
  final List<profile> data;

  const profileScreen({Key? key, required this.id, required this.img, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return body(id: id,img: img, data: data,);
  }
}
