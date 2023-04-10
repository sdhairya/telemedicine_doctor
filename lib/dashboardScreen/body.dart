import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:telemedicine_doctor/colors.dart';
import 'package:telemedicine_doctor/components.dart';
import 'package:telemedicine_doctor/dataClass/dataClass.dart';
import 'package:telemedicine_doctor/loginScreen/loginScreen.dart';
import 'package:telemedicine_doctor/scheduleslotsScreen/scheduleslots.dart';
import 'package:telemedicine_doctor/updateSchedule/updateSchedule.dart';

import '../api.dart';
import '../appointments/appointments.dart';
import '../audioCallScreen.dart';
import '../editProfile/editProfile.dart';
import '../profileScreen/profileScreen.dart';
import '../videoCallScreen.dart';

class body extends StatefulWidget {
  final String id;
  final List<profile> data;
  const body({Key? key, required this.id, required this.data}) : super(key: key);

  @override
  State<body> createState() => _bodyState();
}

class _bodyState extends State<body> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          height: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(image: AssetImage("assets/images/doctorDashboard.png"),fit: BoxFit.fill),
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  alignment: Alignment.bottomRight,
                  margin: EdgeInsets.only(top: 20, right: 20),
                  child: Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Container(
                          padding: EdgeInsets.only(right: 0,top: 0),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                shape: CircleBorder(),
                                padding: EdgeInsets.all(5),
                                backgroundColor: Color(0xfff6f6f4)
                            ),
                            child: Icon(Icons.notifications_none_outlined,color: Colors.black, size: 32),
                            onPressed: () {

                            },
                          )
                      ),
                      InkWell(
                        child: Container(
                            height: MediaQuery.of(context).size.width * 0.13,
                            width: MediaQuery.of(context).size.width * 0.13,
                            decoration: BoxDecoration(
                                border:
                                Border.all(color: colors().logo_darkBlue),
                                shape: BoxShape.circle,
                                color: Colors.white70),
                            child: CircleAvatar(
                              radius:
                              MediaQuery.of(context).size.width * 0.17,
                              child: widget.data[0].image!.isEmpty ?
                              Icon(Icons.person,color: Color(0xff383434),size: 30):
                              ClipOval(
                                  child: Image.network(
                                    api().uri + widget.data[0].image!,
                                    fit: BoxFit.fill,
                                    height: double.maxFinite,
                                    width: double.maxFinite,
                                  )),

                            )

                        ),
                        onTap: () {
                         },
                      ),
                    ],
                  ),
                ),
                Container(
                    margin: EdgeInsets.only(left: 20),
                    alignment: Alignment.bottomLeft,
                    width: double.infinity,
                    child: Wrap(
                      direction: Axis.vertical,
                      children: [
                        components().text("Welcome !", FontWeight.w700, Colors.white, 38),
                        components().text("Doctor", FontWeight.w700, Colors.white, 38),
                      ],
                    )

                ),
                Container(
                    width: double.infinity,
                    margin: EdgeInsets.only(top: 20),
                    padding: EdgeInsets.only(top: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20)),
                      color: Colors.white,
                    ),
                    child: Column(
                      children: [
                        Wrap(
                          children: [
                            Container(
                              margin: EdgeInsets.only(top: 15,right: 5),
                              child: Wrap(
                                alignment: WrapAlignment.center,
                                children: [
                                  SvgPicture.asset('assets/images/totalPatient.svg',),
                                  SizedBox(width: 5,),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      components().text("Total Patients", FontWeight.normal, Color(0xff262626), 16),
                                      components().text(widget.data[0].stat!.totalPatients.toString(), FontWeight.w500, Color(0xff262626), 24),
                                      components().text("Till Today", FontWeight.w100, Color(0xff262626), 14),
                                    ],
                                  )
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 15,left: 5),
                              child: Wrap(
                                alignment: WrapAlignment.center,
                                children: [
                                  SvgPicture.asset('assets/images/pendingAppointment.svg',),
                                  SizedBox(width: 5,),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      components().text("Pending Appointments", FontWeight.normal, Color(0xff262626), 16),
                                      components().text(widget.data[0].stat!.pendingAppointments.toString(), FontWeight.w500, Color(0xff262626), 24),
                                      components().text(DateFormat.yMMMd().format(DateTime.now()), FontWeight.w200, Color(0xff262626), 14),
                                    ],
                                  )
                                ],
                              ),
                            ),
                            Container(
                              // width: MediaQuery.of(context).size.width * 0.5,
                              margin: EdgeInsets.all(10),
                              child: Wrap(
                                children: [
                                  SvgPicture.asset('assets/images/todayPatient.svg',),
                                  SizedBox(width: 5,),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      components().text("Today Patients", FontWeight.normal, Color(0xff262626), 16),
                                      components().text(widget.data[0].stat!.todayPatients.toString(), FontWeight.w500, Color(0xff262626), 24),
                                      components().text(DateFormat.yMMMd().format(DateTime.now()), FontWeight.w200, Color(0xff262626), 14),
                                    ],
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                        ListTile(
                          leading: components().text("Upcoming", FontWeight.bold, Colors.black, 26),
                          trailing: InkWell(
                            child: components().text("See all", FontWeight.normal, Colors.black, 18),
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(builder: (context) => appointments(id: widget.id, doctorProfile: widget.data[0],index: 1),));
                            },
                          ),
                        ),
                        buildAppointmentCard(),
                        Wrap(
                          children: [
                            buildButton("appointment.png", "Appointments", 0.15, appointments(id: widget.id, doctorProfile: widget.data[0],index: 0,)),
                            buildButton("history.png", "Patients",0.13, Container()),
                            buildButton("review.png", "Reviews", 0.15, Container()),
                            buildButton("schedule.png", "Schedule",0.15, updateSchedule(id: widget.id)),
                            buildButton("profile.png", "Profile",0.15, profileScreen(id: widget.id, img: widget.data[0].image, data: widget.data)),
                            buildButton("logout.png", "logout",0.15, loginScreen())
                          ],
                        )
                      ],
                    )

                ),

              ],
            ),
          )
        ),
      ),
    );
  }

  Widget buildButton(String image, String data, double size, Widget screen) {
    return InkWell(
      child: Container(
        margin: EdgeInsets.all(12),
        height: MediaQuery.of(context).size.height * 0.15,
        width: MediaQuery.of(context).size.width * 0.4,
        decoration: BoxDecoration(
          borderRadius:BorderRadius.circular(5),
          color: Color(0xfff6f6f4),
          boxShadow: [BoxShadow(color: Colors.black26,blurRadius: 5, blurStyle: BlurStyle.outer)]
        ),
        child: Column(
          children: [
            // SvgPicture.asset("assets/images/appointment.png",),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.11,
              child:Image(image: AssetImage("assets/images/"+image),width: MediaQuery.of(context).size.width * size, fit: BoxFit.fitWidth),
            ),
            components().text(data, FontWeight.w300, colors().logo_darkBlue, 18)
          ],
        ),
      ),
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => screen,));
      },
    );
  }

  Widget buildAppointmentCard(){

    if(widget.data[0].app != null){
      return Container(
        // height: MediaQuery.of(context).size.height * 0.2,
        width: MediaQuery.of(context).size.width * 0.86,
        margin: EdgeInsets.only(top: 10,bottom: 5, left: 10, right: 10),
        padding: EdgeInsets.only(left: 10, right: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Color(0xfff6f6f4),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.only(left: 10, top: 10, right: 10,bottom: 10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  components().text(widget.data[0].app!.date!.substring(0,10), FontWeight.w400, Colors.grey, 16),

                  Wrap(
                    children: [
                      Icon(Icons.access_time_outlined, size: 19,),
                      components().text(widget.data[0].app!.time!, FontWeight.normal, Colors.black, 16),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          ClipOval(
                            child: CircleAvatar(
                              radius: MediaQuery.of(context).size.width * 0.1,
                              child: Image(image: NetworkImage(api().uri + widget.data[0].app!.image!)),
                            ),
                          ),
                          Container(
                            height: MediaQuery.of(context).size.width * 0.18,
                            margin: EdgeInsets.only(left: 10),
                            child:  Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                components().text(widget.data[0].app!.name!, FontWeight.bold, Colors.black, 16),
                                components().text(widget.data[0].app!.mode!, FontWeight.normal, Colors.grey, 16),
                              ],
                            ),
                          )
                        ],
                      ),
                      ElevatedButton(
                        child: components().text("Join", FontWeight.normal, Colors.white, 16),
                        onPressed: () async {
                          await api().joinAppointment(int.parse(widget.data[0].app!.id!));
                          if( widget.data[0].app!.mode == "video"){
                            Navigator.of(context).push(MaterialPageRoute(builder: (context) => callScreen(roomId: widget.data[0].app!.link!, role: "host", appointmentData: widget.data[0].app!, doctorProfile: widget.data[0]),));
                          }
                          if(widget.data[0].app!.mode! == "audio"){
                            Navigator.of(context).push(MaterialPageRoute(builder: (context) => audiCallScreen(roomId: widget.data[0].app!.link!, role: "host", appointmentData: widget.data[0].app!, doctorProfile: widget.data[0]),));
                          }
                        },
                      ),
                    ],
                  )
                ],
              ),
            ),






          ],
        ),
      );
    }
    return Container(
      height: MediaQuery.of(context).size.height * 0.198,
      width: double.infinity,
      margin: EdgeInsets.only(top: 10,bottom: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        gradient: new LinearGradient(
            stops: [0.02, 0.02],
            colors: [Colors.blue, Color(0xfff6f6f4)]
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          components().text("No Appointment Scheduled", FontWeight.w500, Colors.black, 20)
        ],
      ),
    );

  }

}
