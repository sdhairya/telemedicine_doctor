

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'api.dart';

class components extends StatefulWidget {
  const components({Key? key}) : super(key: key);

  @override
  State<components> createState() => _componentsState();

  TextField textField(String hint, TextInputType type, TextEditingController controller) {
    return  TextField(
      keyboardType: type,
      controller: controller,
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15),borderSide: BorderSide(color: Color(
            0x52003879))),
        enabled: true,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
        ),
        hintText: hint,
        hintStyle: TextStyle(color: Color(0xff959595)),
      ),
    );
  }

  TextField textField_prescription(String hint, TextInputType type, TextEditingController controller, String columnName, String id) {
    return  TextField(
      keyboardType: type,
      controller: controller,
      decoration: InputDecoration(
        fillColor: Colors.white,
        filled: true,
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15),borderSide: BorderSide(color: Color(
            0x52003879))),
        enabled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        hintText: hint,
        hintStyle: TextStyle(color: Color(0xff959595)),
      ),
      onChanged: (value) async {
        print(value);
       await api().prescribe(id, columnName, value);
      },
      onSubmitted: null,
    );
  }

  TextField textField_underline(String hint, TextInputType type, TextEditingController controller) {
    return  TextField(
      keyboardType: type,
      controller: controller,
      decoration: InputDecoration(
        fillColor: Color(0xfff6f4f4),
        enabled: true,
        hintText: hint,
      ),
    );
  }

  Text text(String data, FontWeight fontWeight, Color color, double fontsize) {
    return Text(
      data,
      style: GoogleFonts.poppins(
        fontWeight: fontWeight,
        color: color,
        fontSize: fontsize,
      )
      // style: font == "poppins" ? GoogleFonts.poppins(
      //   fontWeight: fontWeight,
      //   color: color,
      //   fontSize: fontsize,
      // ) : GoogleFonts.inter(
      //   fontWeight: fontWeight,
      //   color: color,
      //   fontSize: fontsize,
      // )
    );
  }

  InkWell backButton(BuildContext context){

    return InkWell(
      child: Container(
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          shape: BoxShape.rectangle,
          color: Color(0xfff6f6f4),
          boxShadow: [
            BoxShadow(color: Colors.grey,blurRadius: 2)
          ]
        ),
        child: Icon(Icons.arrow_back_ios_new, size: 30, color: Color(0xff383434)),
      ),
      onTap: () {
        Navigator.of(context).pop();
      },
    );
  }

}

class _componentsState extends State<components> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
