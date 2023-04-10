import 'package:flutter/material.dart';
import 'package:telemedicine_doctor/api.dart';
import 'package:telemedicine_doctor/colors.dart';

import '../components.dart';
import '../dataClass/dataClass.dart';
import '../editProfile/editProfile.dart';
// import '../editProfile/editProfile.dart';

class body extends StatefulWidget {

  final String id;
  final String? img;
  final List<profile> data;
  const body({Key? key, required this.id, required this.img, required this.data}) : super(key: key);

  @override
  State<body> createState() => _bodyState();
}

class _bodyState extends State<body> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            child: Stack(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.3,
                  padding: EdgeInsets.only(top: 20),
                  decoration: BoxDecoration(
                      gradient: RadialGradient(
                          radius: 2,
                          center: Alignment.bottomLeft,
                          colors: [
                            colors().logo_lightBlue,
                            colors().logo_darkBlue
                          ]
                      )
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 25),
                  child: Column(
                    children: [
                      ListTile(
                        horizontalTitleGap: 80,
                        leading: components().backButton(context),
                        title: components().text("Account", FontWeight.w500, Colors.white, 26),
                      ),
                      SizedBox(
                        height: 100,
                      ),
                      Container(
                        alignment: Alignment.bottomCenter,
                        height: MediaQuery.of(context).size.width * 0.35,
                        width: MediaQuery.of(context).size.width * 0.35,
                        decoration: BoxDecoration(
                            border:
                            Border.all(color: colors().logo_darkBlue),
                            shape: BoxShape.circle,
                            color: Colors.white70),
                        child: CircleAvatar(
                            radius:
                            MediaQuery.of(context).size.width * 0.17,
                            child: ClipOval(
                                child: Image.network(
                                  api().uri+widget.img!,
                                  fit: BoxFit.fill,
                                  height: double.maxFinite,
                                  width: double.maxFinite,
                                ))
                        ),
                      ),
                      itemList(Icons.person_outline, "Profile Setting",editProfile(id: widget.id, data: widget.data,)),
                      itemList(Icons.notifications_none_outlined, "Notification",Container()),
                      itemList(Icons.schedule_outlined, "Appointments", Container()),
                      itemList(Icons.error_outline, "Terms & Condition",Container()),
                      itemList(Icons.info, "About Us",Container()),
                      Container(
                        padding: EdgeInsets.only(bottom: 5),
                        margin: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.06, right: MediaQuery.of(context).size.width * 0.06),
                        child:  ListTile(
                          leading: Icon(Icons.logout,color: colors().logo_darkBlue),
                          title: components().text("Logout", FontWeight.normal, colors().logo_darkBlue, 20),
                          trailing: Icon(Icons.arrow_forward_ios, color: colors().logo_darkBlue),
                        ),
                      )

                    ],
                  ),
                )

              ],
            ),
          )),
    );
  }

  Widget itemList(IconData icon, String data, Widget screen){

    return InkWell(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => screen,));
      },
      child: Container(
        decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: Color(0xffd1d1d1)))
        ),
        padding: EdgeInsets.only(bottom: 5),
        margin: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.06, right: MediaQuery.of(context).size.width * 0.06),
        child: ListTile(
          leading: Icon(icon,color: colors().logo_darkBlue),
          title: components().text(data, FontWeight.w500, colors().logo_darkBlue, 20),
          trailing: Icon(Icons.arrow_forward_ios, color: colors().logo_darkBlue),
        ),
      ),
    );

  }

}
