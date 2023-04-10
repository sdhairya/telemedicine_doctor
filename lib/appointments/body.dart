import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:telemedicine_doctor/api.dart';
import 'package:telemedicine_doctor/audioCallScreen.dart';

import '../colors.dart';
import '../components.dart';
import '../dataClass/dataClass.dart';
import '../videoCallScreen.dart';

class body extends StatefulWidget {
  final String id;
  final profile doctorProfile;
  final int index;


  const body({Key? key, required this.id, required this.doctorProfile, required this.index}) : super(key: key);

  @override
  State<body> createState() => _bodyState();
}

class _bodyState extends State<body> {
  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.03,
            ),
            ListTile(
              leading: const components().backButton(context),
            ),
            Container(
              padding: const EdgeInsets.only(
                  top: 10, bottom: 10, right: 10, left: 10),
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(10),
              ),
              margin: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.02),
              child: DefaultTabController(
                length: 2,
                initialIndex: widget.index,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.only(
                          top: 10, bottom: 10, right: 10, left: 10),
                      margin: const EdgeInsets.only(
                          bottom: 10, left: 10, right: 10),
                      decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(10),
                          color: colors().logo_darkBlue),
                      child: TabBar(
                        labelPadding:
                            const EdgeInsets.only(top: 10, bottom: 10),
                        indicator: BoxDecoration(
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white),
                        unselectedLabelColor: Colors.white,
                        labelColor: colors().logo_darkBlue,
                        onTap: (value) {},
                        tabs: [
                          const Text("Pending", style: TextStyle(fontSize: 20)),
                          const Text("Approved",
                              style: TextStyle(fontSize: 20)),
                        ],
                      ),
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.72,
                      child: TabBarView(
                        children: [
                          FutureBuilder(
                            future: api().getAppointments(widget.id),
                            builder: (context, snapshot) {
                              print(widget.id);
                              if (snapshot.hasData) {
                                return ListView.builder(
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  itemCount: snapshot.data!.length,
                                  itemBuilder: (context, index) {
                                    return InkWell(
                                      child: Container(
                                          width: double.infinity,
                                          padding: const EdgeInsets.only(
                                              top: 10,
                                              bottom: 10,
                                              left: 20,
                                              right: 15),
                                          margin: const EdgeInsets.only(
                                              top: 5,
                                              bottom: 5,
                                              left: 10,
                                              right: 10),
                                          decoration: BoxDecoration(
                                              color: const Color(0xfff6f6f4),
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Wrap(
                                                crossAxisAlignment:
                                                    WrapCrossAlignment.center,
                                                children: [
                                                  const Icon(
                                                      Icons.access_time_filled,
                                                      color: Color(0xff474747),
                                                      size: 15),
                                                  const SizedBox(
                                                    width: 5,
                                                  ),
                                                  const components().text(
                                                      snapshot
                                                          .data![index].date!,
                                                      FontWeight.normal,
                                                      Color(0xff474747),
                                                      14),
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                  const components().text(
                                                      snapshot
                                                          .data![index].time!,
                                                      FontWeight.normal,
                                                      Color(0xff474747),
                                                      14)
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  Container(
                                                      alignment: Alignment
                                                          .bottomCenter,
                                                      height:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.2,
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.2,
                                                      decoration:
                                                          const BoxDecoration(
                                                              shape: BoxShape
                                                                  .circle,
                                                              color: Colors
                                                                  .white70),
                                                      child: Stack(
                                                        children: [
                                                          CircleAvatar(
                                                              radius: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  0.17,
                                                              child: Image(
                                                                  image: NetworkImage(api()
                                                                          .uri +
                                                                      snapshot
                                                                          .data![
                                                                              index]
                                                                          .image!))),
                                                          Container(
                                                            alignment: Alignment.bottomRight,
                                                            child: ClipOval(
                                                              child: CircleAvatar(
                                                                  radius: MediaQuery.of(context).size.width * 0.035,
                                                                  backgroundColor: const Color(0xff003879),
                                                                  child: Image(image: AssetImage("assets/images/"+snapshot.data![index].mode!+"Consult.png"), )),
                                                            ),
                                                          ),
                                                        ],
                                                      )),
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      const components().text(
                                                          snapshot.data![index]
                                                              .name!,
                                                          FontWeight.w500,
                                                          Colors.black,
                                                          16),
                                                      const components().text(
                                                          "Mode: " +
                                                              snapshot
                                                                  .data![index]
                                                                  .mode!,
                                                          FontWeight.w400,
                                                          Color(0xff474747),
                                                          14),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          SizedBox(
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.23,
                                                          ),
                                                          InkWell(
                                                            child: Container(
                                                              height: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  0.085,
                                                              width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  0.1,
                                                              decoration:
                                                                  BoxDecoration(
                                                                shape: BoxShape
                                                                    .rectangle,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            5),
                                                                color: const Color(
                                                                    0xffBDEAF8),
                                                              ),
                                                              child: Icon(
                                                                  Icons
                                                                      .remove_red_eye_outlined,
                                                                  color: colors()
                                                                      .logo_darkBlue),
                                                            ),
                                                            onTap: () {
                                                              showDialog(
                                                                context:
                                                                    context,
                                                                builder:
                                                                    (context) {
                                                                  return AlertDialog(
                                                                    contentPadding:
                                                                        const EdgeInsets.all(
                                                                            15),
                                                                    content:
                                                                        Column(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      mainAxisSize:
                                                                          MainAxisSize
                                                                              .min,
                                                                      children: [
                                                                        ListTile(
                                                                          dense:
                                                                              true,
                                                                          leading: const components().text(
                                                                              "Appointment Details",
                                                                              FontWeight.w500,
                                                                              Color(0xff676767),
                                                                              22),
                                                                          trailing:
                                                                              const Icon(Icons.cancel_outlined),
                                                                        ),
                                                                        const Divider(),
                                                                        Container(
                                                                          child:
                                                                              Column(
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.start,
                                                                            children: [
                                                                              const components().text(snapshot.data![index].name!, FontWeight.normal, Color(0xff696969), 18),
                                                                              const SizedBox(
                                                                                height: 10,
                                                                              ),
                                                                              const components().text("Mode", FontWeight.normal, Color(0xff101010), 18),
                                                                              const components().text(snapshot.data![index].mode!, FontWeight.normal, Color(0xff696969), 18),
                                                                              const SizedBox(
                                                                                height: 10,
                                                                              ),
                                                                              const components().text("Date & Time", FontWeight.normal, Color(0xff101010), 18),
                                                                              const components().text(snapshot.data![index].date! + "  " + snapshot.data![index].time!, FontWeight.normal, Color(0xff696969), 18),
                                                                              const SizedBox(
                                                                                height: 10,
                                                                              ),
                                                                              const components().text("Paid Amount", FontWeight.normal, Color(0xff101010), 18),
                                                                              const components().text(snapshot.data![index].fees.toString(), FontWeight.normal, Color(0xff696969), 18),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    actions: [
                                                                      InkWell(
                                                                        child:
                                                                            Container(
                                                                          height:
                                                                              MediaQuery.of(context).size.height * 0.05,
                                                                          width:
                                                                              MediaQuery.of(context).size.width * 0.3,
                                                                          decoration:
                                                                              BoxDecoration(
                                                                            shape:
                                                                                BoxShape.rectangle,
                                                                            borderRadius:
                                                                                BorderRadius.circular(5),
                                                                            color:
                                                                                const Color(0xffB8FFB2),
                                                                          ),
                                                                          alignment:
                                                                              Alignment.center,
                                                                          child:
                                                                              Wrap(
                                                                            children: [
                                                                              const Icon(Icons.check, color: Color(0xff32AE27)),
                                                                              const components().text("Accept", FontWeight.normal, Colors.green, 18)
                                                                            ],
                                                                          ),
                                                                        ),
                                                                        onTap:
                                                                            () async {
                                                                          print("ACCEPT");
                                                                          var result = await api().manageAppointments(snapshot.data![index].id!, widget.id, "Aproved");
                                                                          if(result == 200){
                                                                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                                                              content: components().text("Appointment Approved", FontWeight.w500, Colors.white, 20),
                                                                            ));
                                                                            setState(() {

                                                                            });
                                                                          }
                                                                          else{
                                                                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                                                              content: components().text("Error", FontWeight.w500, Colors.white, 20),
                                                                            ));
                                                                          }
                                                                        },
                                                                      ),
                                                                      InkWell(
                                                                        child:
                                                                            Container(
                                                                          height:
                                                                              MediaQuery.of(context).size.height * 0.05,
                                                                          width:
                                                                              MediaQuery.of(context).size.width * 0.3,
                                                                          decoration:
                                                                              BoxDecoration(
                                                                            shape:
                                                                                BoxShape.rectangle,
                                                                            borderRadius:
                                                                                BorderRadius.circular(5),
                                                                            color:
                                                                                const Color(0xffFFC6C6),
                                                                          ),
                                                                          alignment:
                                                                              Alignment.center,
                                                                          child:
                                                                              Wrap(
                                                                            children: [
                                                                              const Icon(Icons.close, color: Color(0xffFF0000)),
                                                                              const components().text("Cancel", FontWeight.normal, Colors.red, 18)
                                                                            ],
                                                                          ),
                                                                        ),
                                                                        onTap:
                                                                            () async {
                                                                          print(
                                                                              "CANCEL");
                                                                          var result = await api().manageAppointments(snapshot.data![index].id!, widget.id, "Declined");
                                                                          if(result == 200){
                                                                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                                                              content: components().text("Appointment Declined", FontWeight.w500, Colors.white, 20),
                                                                            ));
                                                                            setState(() {

                                                                            });
                                                                          }
                                                                          else{
                                                                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                                                              content: components().text("Error", FontWeight.w500, Colors.white, 20),
                                                                            ));
                                                                          }
                                                                        },
                                                                      ),
                                                                    ],
                                                                    actionsAlignment:
                                                                        MainAxisAlignment
                                                                            .center,
                                                                  );
                                                                },
                                                              );
                                                            },
                                                          ),
                                                          const SizedBox(
                                                            width: 10,
                                                          ),
                                                          InkWell(
                                                            child: Container(
                                                              height: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  0.085,
                                                              width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  0.1,
                                                              decoration:
                                                                  BoxDecoration(
                                                                shape: BoxShape
                                                                    .rectangle,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            5),
                                                                color: const Color(
                                                                    0xffB8FFB2),
                                                              ),
                                                              child: const Icon(
                                                                  Icons.check,
                                                                  color: Color(
                                                                      0xff32AE27)),
                                                            ),
                                                            onTap: () async {
                                                              print("ACCEPT");


                                                              var result = await api().manageAppointments(snapshot.data![index].id!, widget.id, "Approved");
                                                              if(result == 200){
                                                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                                                  content: components().text("Appointment Approved", FontWeight.w500, Colors.white, 20),
                                                                ));
                                                                setState(() {

                                                                });
                                                              }
                                                              else{
                                                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                                                  content: components().text("Appointment Not approved", FontWeight.w500, Colors.white, 20),
                                                                ));
                                                              }
                                                            },
                                                          ),
                                                          const SizedBox(
                                                            width: 10,
                                                          ),
                                                          InkWell(
                                                            child: Container(
                                                              height: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  0.085,
                                                              width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  0.1,
                                                              decoration:
                                                                  BoxDecoration(
                                                                shape: BoxShape
                                                                    .rectangle,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            5),
                                                                color: const Color(
                                                                    0xffFFC6C6),
                                                              ),
                                                              child: const Icon(
                                                                  Icons.close,
                                                                  color: Color(
                                                                      0xffFF0000)),
                                                            ),
                                                            onTap: () async {
                                                              print("CANCEL");
                                                              var result = await api().manageAppointments(snapshot.data![index].id!, widget.id, "Declined");
                                                              if(result == 200){
                                                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                                                  content: components().text("Appointment Declined", FontWeight.w500, Colors.white, 20),
                                                                ));
                                                                setState(() {

                                                                });
                                                              }
                                                              else{
                                                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                                                  content: components().text("Error", FontWeight.w500, Colors.white, 20),
                                                                ));
                                                              }
                                                            },
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ],
                                          )),
                                      onTap: () {},
                                    );
                                  },
                                );
                              }
                              return Scaffold(
                                body: Container(
                                  alignment: Alignment.center,
                                  child: const CircularProgressIndicator(),
                                ),
                              );
                            },
                          ),
                          FutureBuilder(
                            future: api().getApprovedAppointments(widget.id),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return ListView.builder(
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  itemCount: snapshot.data!.length,
                                  itemBuilder: (context, index) {
                                    return InkWell(
                                      child: Container(
                                          width: double.infinity,
                                          padding: const EdgeInsets.only(
                                              top: 10,
                                              bottom: 10,
                                              left: 20,
                                              right: 15),
                                          margin: const EdgeInsets.only(
                                              top: 5,
                                              bottom: 5,
                                              left: 10,
                                              right: 10),
                                          decoration: BoxDecoration(
                                              color: const Color(0xfff6f6f4),
                                              borderRadius:
                                              BorderRadius.circular(10)),
                                          child: Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: [
                                              Wrap(
                                                crossAxisAlignment:
                                                WrapCrossAlignment.center,
                                                children: [
                                                  const Icon(
                                                      Icons
                                                          .access_time_filled,
                                                      color:
                                                      Color(0xff474747),
                                                      size: 15),
                                                  const SizedBox(
                                                    width: 5,
                                                  ),
                                                  const components().text(
                                                      snapshot
                                                          .data![index].date!,
                                                      FontWeight.normal,
                                                      Color(0xff474747),
                                                      14),
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                  const components().text(
                                                      snapshot
                                                          .data![index].time!,
                                                      FontWeight.normal,
                                                      Color(0xff474747),
                                                      14)
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  Container(
                                                    alignment: Alignment
                                                        .bottomCenter,
                                                    height:
                                                    MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                        0.2,
                                                    width:
                                                    MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                        0.2,
                                                    decoration:
                                                    const BoxDecoration(
                                                        shape: BoxShape
                                                            .circle,
                                                        color: Colors
                                                            .white70),
                                                    child: Container(
                                                      alignment: Alignment
                                                          .bottomRight,
                                                      child: CircleAvatar(
                                                          radius: MediaQuery.of(
                                                              context)
                                                              .size
                                                              .width *
                                                              0.17,
                                                          child: Image(
                                                            image: NetworkImage(api()
                                                                .uri +
                                                                snapshot
                                                                    .data![
                                                                index]
                                                                    .image!),
                                                            fit: BoxFit.fill,
                                                          )),
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                  Column(
                                                    crossAxisAlignment:
                                                    CrossAxisAlignment
                                                        .start,
                                                    children: [
                                                      const components().text(
                                                          snapshot
                                                              .data![index]
                                                              .name!,
                                                          FontWeight.w500,
                                                          Colors.black,
                                                          16),
                                                      const components().text(
                                                          "Mode: " +
                                                              snapshot
                                                                  .data![
                                                              index]
                                                                  .mode!,
                                                          FontWeight.w400,
                                                          Color(0xff474747),
                                                          14),
                                                      Row(
                                                        mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                        crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                        children: [
                                                          SizedBox(
                                                            width: MediaQuery.of(
                                                                context)
                                                                .size
                                                                .width *
                                                                0.23,
                                                          ),
                                                          InkWell(
                                                            child: Container(
                                                                decoration: BoxDecoration(
                                                                    shape: BoxShape
                                                                        .rectangle,
                                                                    borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                        5),
                                                                    color: colors()
                                                                        .logo_darkBlue),
                                                                padding:
                                                                const EdgeInsets
                                                                    .only(
                                                                    left:
                                                                    10,
                                                                    right:
                                                                    10,
                                                                    top: 5,
                                                                    bottom:
                                                                    5),
                                                                child: const components().text(
                                                                    "Join",
                                                                    FontWeight
                                                                        .normal,
                                                                    Colors
                                                                        .white,
                                                                    16)),
                                                            onTap: () async {
                                                              await api().joinAppointment(int.parse(snapshot.data![index].id!));
                                                              if( snapshot.data![index].mode == "video"){
                                                                Navigator.of(context).push(MaterialPageRoute(builder: (context) => callScreen(roomId: snapshot.data![index].link!, role: "host", appointmentData: snapshot.data![index], doctorProfile: widget.doctorProfile),));
                                                              }
                                                              if(snapshot.data![index].mode == "audio"){
                                                                Navigator.of(context).push(MaterialPageRoute(builder: (context) => audiCallScreen(roomId: snapshot.data![index].link!, role: "host", appointmentData: snapshot.data![index], doctorProfile: widget.doctorProfile),));
                                                              }
                                                            },
                                                          )
                                                          ,
                                                          const SizedBox(
                                                            width: 10,
                                                          ),
                                                          Container(
                                                            decoration:
                                                            BoxDecoration(
                                                              shape: BoxShape
                                                                  .rectangle,
                                                              borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                  5),
                                                              color: const Color(
                                                                  0xffBDEAF8),
                                                            ),
                                                            padding:
                                                            const EdgeInsets
                                                                .only(
                                                                left: 10,
                                                                right: 10,
                                                                top: 5,
                                                                bottom:
                                                                5),
                                                            child: Wrap(
                                                              crossAxisAlignment:
                                                              WrapCrossAlignment
                                                                  .center,
                                                              children: [
                                                                Icon(
                                                                    Icons
                                                                        .remove_red_eye_outlined,
                                                                    color: colors()
                                                                        .logo_darkBlue,
                                                                    size: 17),
                                                                const components().text(
                                                                    "View",
                                                                    FontWeight
                                                                        .normal,
                                                                    colors()
                                                                        .logo_darkBlue,
                                                                    14)
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ],
                                          )),
                                      onTap: () {},
                                    );
                                  },
                                );
                              }
                              return Scaffold(
                                body: Container(
                                  alignment: Alignment.center,
                                  child: const CircularProgressIndicator(),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
