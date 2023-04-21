

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

  ElevatedButton backButton(BuildContext context){
    return ElevatedButton(
      child: Icon(Icons.arrow_back_ios_new, size: 30, color: Color(0xff383434)),
      style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xfff6f6f4),
          shape: CircleBorder(),
          padding: EdgeInsets.only(top: 10, bottom: 10,left: 5, right: 5)
      ),
      onPressed: () {

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
