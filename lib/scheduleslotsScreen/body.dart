import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:telemedicine_doctor/api.dart';
import 'package:telemedicine_doctor/colors.dart';
import 'package:telemedicine_doctor/components.dart';
import 'package:telemedicine_doctor/scheduleslotsScreen/scheduleslots.dart';

import '../dataClass/dataClass.dart';

class body extends StatefulWidget {
  final List<hospital> hospitals;
  final String day;
  final String id;
  final int hospitalId;
  const body({Key? key, required this.hospitals, required this.day, required this.id, required this.hospitalId})
      : super(key: key);

  @override
  State<body> createState() => _bodyState();
}

class _bodyState extends State<body> {
  Duration initialTimer = const Duration();
  var startTime;
  var endTime;
  List<String> slots = [];
  int hostiptaId = 0;
  List<int> duration = [15, 30, 45, 60];
  int dur = 15;
  bool statusAvailable = true;
  List<String> times = ["Morning", "Afternoon", "Evening"];
  List<String> morningSlots = [];
  List<String> afternoonSlots = [];
  List<String> eveningSlots = [];
  List<int> facility_id = [];
  List<String> mode = ["both", "both", "both"];
  String dayTime = "Morning";
  bool online = true;
  bool offline = true;


  @override
  void initState() {
    setState(() {
      facility_id = [widget.hospitalId, widget.hospitalId, widget.hospitalId];
    });
  }

  @override
  Widget build(BuildContext context) {
    String dropdownvalue = "Select Days";

    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize:
              Size.fromHeight(MediaQuery.of(context).size.height * 0.1),
          child: Container(
            margin: EdgeInsets.only(top: 20, left: 10),
            child: ListTile(
              leading: components().backButton(context),
              title: components().text(
                  "    Schedule Timings", FontWeight.bold, Colors.black, 25),
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 30, left: 20, bottom: 20),
                child: components()
                    .text(widget.day, FontWeight.w600, Colors.black, 32),
              ),
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black12,
                          blurRadius: 3,
                          blurStyle: BlurStyle.outer)
                    ]),
                padding: EdgeInsets.all(10),
                margin: EdgeInsets.only(left: 10, right: 10),
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 10, left: 10, bottom: 10),
                      alignment: Alignment.centerLeft,
                      child: Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          components().text(
                              "Status", FontWeight.w500, Colors.black, 22),
                          Transform.scale(
                            scale: 0.8,
                            child: CupertinoSwitch(
                              value: statusAvailable,
                              onChanged: (value) {
                                setState(() {
                                  statusAvailable = !statusAvailable;
                                });
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                    AbsorbPointer(
                      absorbing: !statusAvailable,
                      child: Column(
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: components().text("   Mode", FontWeight.w500, Colors.black, 18),
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Container(
                              height:
                              MediaQuery.of(context).size.height * 0.07,
                              alignment: Alignment.centerLeft,
                              child: Row(
                                children: [
                                  Checkbox(value: online, onChanged: (value) {
                                    setState(() {
                                      online = !online;
                                      value = online;
                                    });
                                  },),
                                  components().text("Online", FontWeight.w500,
                                      Color(0xff292929), 16),
                                  Checkbox(value: offline, onChanged: (value) {
                                    setState(() {
                                      offline = !offline;
                                      value = offline;
                                    });
                                  },),
                                  components().text(
                                      "Offline",
                                      FontWeight.w500,
                                      Color(0xff292929),
                                      16),
                                ],
                              ),
                            ),
                          ),

                          Container(
                            child: offline ? Container(
                              height: MediaQuery.of(context).size.height * 0.07,
                              width: double.maxFinite,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  border: Border.all(color: Color(0xffd7d7d7)),
                                  borderRadius: BorderRadius.circular(15)),
                              child: DropdownButtonFormField<String>(
                                  decoration:
                                  InputDecoration(border: InputBorder.none),
                                  hint: Padding(
                                      padding: EdgeInsets.only(left: 15),
                                      child: components().text("Select Hospital",
                                          FontWeight.normal, Colors.black, 18)),
                                  items: widget.hospitals
                                      .map<DropdownMenuItem<String>>((value) {
                                    return DropdownMenuItem(
                                      child: components().text("  " + value.name,
                                          FontWeight.normal, Colors.black, 16),
                                      value: value.name,
                                      onTap: () {
                                        hostiptaId = value.id;
                                      },
                                    );
                                  }).toList(),
                                  onChanged: (String? value) {
                                    setState(() {
                                      dropdownvalue = value!;
                                    });
                                  }),
                            ) : null
                          )
                          ,
                          Container(
                            // padding: EdgeInsets.all(10),
                            margin: EdgeInsets.only(top: 10, bottom: 10),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.black26,
                                      blurRadius: 2,
                                      blurStyle: BlurStyle.outer),
                                ]),
                            child: DefaultTabController(
                                length: 3,
                                child: TabBar(
                                  labelColor: Color(0xff32ae27),
                                  labelStyle: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 19),
                                  unselectedLabelColor: Colors.black,
                                  unselectedLabelStyle: TextStyle(
                                      fontWeight: FontWeight.normal,
                                      fontSize: 17),
                                  indicator: BoxDecoration(),
                                  labelPadding:
                                      EdgeInsets.only(top: 8, bottom: 8),
                                  onTap: (value) {

                                    print(times[value]);
                                    setState(() {
                                      dayTime = times[value];
                                    });
                                  },
                                  tabs: [
                                    Wrap(
                                      crossAxisAlignment:
                                          WrapCrossAlignment.center,
                                      children: [
                                        Icon(Icons.sunny),
                                        Text(
                                          "Morning",
                                        ),
                                        morningSlots.isEmpty ? Container(): Icon(Icons.check_circle, color: Colors.green,size: 15,)
                                      ],
                                    ),
                                    Wrap(
                                      crossAxisAlignment:
                                          WrapCrossAlignment.center,
                                      children: [
                                        Icon(Icons.wb_twighlight),
                                        Text(
                                          "Afternoon",
                                        ),
                                        afternoonSlots.isEmpty ? Container(): Icon(Icons.check_circle, color: Colors.green, size: 15,)
                                      ],
                                    ),
                                    Wrap(
                                      crossAxisAlignment:
                                          WrapCrossAlignment.center,
                                      children: [
                                        Icon(Icons.nights_stay),
                                        Text(
                                          "Evening",
                                        ),
                                        eveningSlots.isEmpty ? Container(): Icon(Icons.check_circle, color: Colors.green, size: 15,)
                                      ],
                                    ),
                                  ],
                                )),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  components().text("Start Time",
                                      FontWeight.w300, Colors.black, 18),
                                  InkWell(
                                    onTap: () => showCupertinoModalPopup(
                                      context: context,
                                      builder: (context) =>
                                          CupertinoActionSheet(
                                        actions: [timePicker("start")],
                                        cancelButton:
                                            CupertinoActionSheetAction(
                                          child: Text('Done'),
                                          onPressed: () {
                                            // final value = dateTime;
                                            // print(value);
                                            setState(() {
                                              // dateTime = value;
                                              Navigator.of(context).pop();
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                    child: Container(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.06,
                                      width: MediaQuery.of(context).size.width *
                                          0.4,
                                      padding: EdgeInsets.only(left: 15),
                                      decoration: BoxDecoration(
                                          color: Color(0xfff6f4f4),
                                          border: Border.all(
                                              color: Color(0xffd7d7d7)),
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          components().text(
                                              startTime == null
                                                  ? "Time"
                                                  : startTime,
                                              FontWeight.normal,
                                              Colors.black,
                                              20),
                                          Icon(
                                            Icons.access_time_filled,
                                            color: Colors.grey,
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  components().text("End Time", FontWeight.w300,
                                      Colors.black, 18),
                                  InkWell(
                                    onTap: () => showCupertinoModalPopup(
                                      context: context,
                                      builder: (context) =>
                                          CupertinoActionSheet(
                                        actions: [timePicker("end")],
                                        cancelButton:
                                            CupertinoActionSheetAction(
                                          child: Text('Done'),
                                          onPressed: () {
                                            // final value = dateTime;
                                            // print(value);
                                            setState(() {
                                              // dateTime = value;
                                              Navigator.of(context).pop();
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                    child: Container(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.06,
                                      width: MediaQuery.of(context).size.width *
                                          0.4,
                                      padding: EdgeInsets.only(left: 15),
                                      decoration: BoxDecoration(
                                          color: Color(0xfff6f4f4),
                                          border: Border.all(
                                              color: Color(0xffd7d7d7)),
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          components().text(
                                              endTime == null
                                                  ? "Time"
                                                  : endTime,
                                              FontWeight.normal,
                                              Colors.black,
                                              20),
                                          Icon(
                                            Icons.access_time_filled,
                                            color: Colors.grey,
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: components().text("Timing Slot Duration",
                                FontWeight.normal, Colors.black, 18),
                          ),
                          Container(
                            height: MediaQuery.of(context).size.height * 0.07,
                            width: double.maxFinite,
                            alignment: Alignment.center,
                            margin: EdgeInsets.only(top: 5, bottom: 10),
                            decoration: BoxDecoration(
                                border: Border.all(color: Color(0xffd7d7d7)),
                                borderRadius: BorderRadius.circular(15)),
                            child: DropdownButtonFormField<String>(
                                decoration:
                                    InputDecoration(border: InputBorder.none),
                                hint: Padding(
                                    padding: EdgeInsets.only(left: 15),
                                    child: components().text("Select Duration",
                                        FontWeight.normal, Colors.black, 18)),
                                items: duration
                                    .map<DropdownMenuItem<String>>((value) {
                                  return DropdownMenuItem(
                                    child: components().text(
                                        "  " + value.toString(),
                                        FontWeight.normal,
                                        Colors.black,
                                        16),
                                    value: value.toString(),
                                    onTap: () {
                                      dur = value;
                                    },
                                  );
                                }).toList(),
                                onChanged: (String? value) {
                                  setState(() {
                                    dropdownvalue = value!;
                                  });
                                  var start =
                                      DateFormat("HH:mm").parse(startTime);
                                  var end = DateFormat("HH:mm").parse(endTime);
                                  List<String> s = [];
                                  slots.clear();
                                  while (start.isBefore(end)) //Run loop
                                  {
                                    var s = start.toString().substring(10,16);

                                    setState(() {
                                      start = start.add(Duration(minutes: dur));
                                      slots.add("$s - ${start.toString().substring(10, 16)}");
                                    });
                                  }
                                  if(dayTime == "Morning"){
                                    setState(() {
                                      morningSlots = List.from(slots);

                                      if(online && offline){
                                        mode[0] = "both";
                                        facility_id[0] = hostiptaId;
                                      }
                                      else if(online){
                                        mode[0] = "online";
                                      }
                                      else if(offline){
                                        mode[0] = "offline";
                                        facility_id[0] = hostiptaId;
                                      }
                                    });
                                    print(morningSlots);
                                    print(afternoonSlots);
                                    print(eveningSlots);
                                  }
                                  else if(dayTime == "Afternoon"){
                                    setState(() {
                                      afternoonSlots = List.from(slots);
                                      if(online && offline){
                                        mode[1] = "both";
                                        facility_id[1] = hostiptaId;
                                      }
                                      else if(online){
                                        mode[1] = "online";
                                      }
                                      else if(offline){
                                        mode[1] = "offline";
                                        facility_id[1] = hostiptaId;
                                      }
                                    });
                                    print(morningSlots);
                                    print(afternoonSlots);
                                    print(eveningSlots);
                                  }
                                  else if(dayTime == "Evening"){
                                    setState(() {
                                      eveningSlots = List.from(slots);
                                      if(online && offline){
                                        mode[2] = "both";
                                        facility_id[2] = hostiptaId;
                                      }
                                      else if(online){
                                        mode[2] = "online";
                                      }
                                      else if(offline){
                                        mode[2] = "offline";
                                        facility_id[2] = hostiptaId;
                                      }
                                    });
                                    print(morningSlots);
                                    print(afternoonSlots);
                                    print(eveningSlots);
                                  }
                                  print(facility_id);
                                  print(mode);
                                }),
                          ),
                          dayTime == "Morning" ? timeSlots(morningSlots) : Container(),
                          dayTime == "Afternoon" ? timeSlots(afternoonSlots) : Container(),
                          dayTime == "Evening" ? timeSlots(eveningSlots) : Container(),

                        ],
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
        bottomNavigationBar: Container(
          height: MediaQuery.of(context).size.height * 0.1,
          alignment: Alignment.center,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: colors().logo_darkBlue,
                padding: EdgeInsets.only(
                    top: 10,
                    bottom: 10,
                    left: MediaQuery.of(context).size.width * 0.15,
                    right: MediaQuery.of(context).size.width * 0.15),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10))),
            child: components().text("Save", FontWeight.bold, Colors.white, 22),
            onPressed: statusAvailable
                ? () async {
              if(facility_id[0] == facility_id [1] && facility_id[1] == facility_id [2]){
              if (mode[0] == mode[1] && mode[1] == mode[2]){
                await api().insertSchedule(schedule(day: widget.day, facilities_id: facility_id[2].toString(), status: statusAvailable ? "Available" : "Unavailable", morning: morningSlots.join(","), afternoon: afternoonSlots.join(","), evening: eveningSlots.join(","), mode:  mode[1]), widget.id);
              }
              else if(mode[0] == mode[1]){
                  await api().insertSchedule(schedule(day: widget.day, facilities_id: facility_id[2].toString(), status: statusAvailable ? "Available" : "Unavailable", morning: morningSlots.join(","), afternoon: afternoonSlots.join(","), evening: "", mode:  mode[0]), widget.id);
                  await api().insertSchedule(schedule(day: widget.day, facilities_id: facility_id[2].toString(), status: statusAvailable ? "Available" : "Unavailable", morning: "", afternoon: "", evening: eveningSlots.join(","), mode:  mode[2]), widget.id);
                  }
                else if (mode[0] == mode[2]){
                  await api().insertSchedule(schedule(day: widget.day, facilities_id: facility_id[2].toString(), status: statusAvailable ? "Available" : "Unavailable", morning: morningSlots.join(","), afternoon: "", evening: eveningSlots.join(","), mode:  mode[0]), widget.id);
                  await api().insertSchedule(schedule(day: widget.day, facilities_id: facility_id[2].toString(), status: statusAvailable ? "Available" : "Unavailable", morning: "", afternoon: afternoonSlots.join(","), evening: "", mode:  mode[1]), widget.id);
                  }
                else if(mode[1] == mode[2]){
                  await api().insertSchedule(schedule(day: widget.day, facilities_id: facility_id[2].toString(), status: statusAvailable ? "Available" : "Unavailable", morning: "", afternoon: afternoonSlots.join(","), evening: eveningSlots.join(","), mode:  mode[1]), widget.id);
                  await api().insertSchedule(schedule(day: widget.day, facilities_id: facility_id[2].toString(), status: statusAvailable ? "Available" : "Unavailable", morning: morningSlots.join(","), afternoon: "", evening: "", mode:  mode[0]), widget.id);
                  }

                  else{
                  await api().insertSchedule(schedule(day: widget.day, facilities_id: facility_id[2].toString(), status: statusAvailable ? "Available" : "Unavailable", morning: morningSlots.join(","), afternoon: "", evening: "", mode:  mode[0]), widget.id);
                  await api().insertSchedule(schedule(day: widget.day, facilities_id: facility_id[2].toString(), status: statusAvailable ? "Available" : "Unavailable", morning: "", afternoon: afternoonSlots.join(","), evening: "", mode:  mode[1]), widget.id);
                  await api().insertSchedule(schedule(day: widget.day, facilities_id: facility_id[2].toString(), status: statusAvailable ? "Available" : "Unavailable", morning: "", afternoon: "", evening: eveningSlots.join(","), mode:  mode[2]), widget.id);
                  }
              }
              else if(facility_id[0] == facility_id [1]){
                await insertData(0, 1, morningSlots.join(","), afternoonSlots.join(","), "");
                await api().insertSchedule(schedule(day: widget.day, facilities_id: facility_id[2].toString(), status: statusAvailable ? "Available" : "Unavailable", morning: "", afternoon: "", evening: eveningSlots.join(","), mode: mode[2]), widget.id);
              }
              else if(facility_id[0] == facility_id [2]){
                await insertData(0, 2, morningSlots.join(","), "", eveningSlots.join(","));
                await api().insertSchedule(schedule(day: widget.day, facilities_id: facility_id[1].toString(), status: statusAvailable ? "Available" : "Unavailable", morning: "", afternoon: afternoonSlots.join(","), evening: "", mode: mode[1]), widget.id);
              }
              else if(facility_id[1] == facility_id [2]){
                await insertData(1, 2, "", afternoonSlots.join(","), eveningSlots.join(","));
                await api().insertSchedule(schedule(day: widget.day, facilities_id: facility_id[0].toString(), status: statusAvailable ? "Available" : "Unavailable", morning: morningSlots.join(","), afternoon: "", evening: "", mode: mode[0]), widget.id);
              }

              else{
                await api().insertSchedule(schedule(day: widget.day, facilities_id: facility_id[0].toString(), status: statusAvailable ? "Available" : "Unavailable", morning: morningSlots.join(","), afternoon: "", evening: "", mode: mode[0]), widget.id);
                await api().insertSchedule(schedule(day: widget.day, facilities_id: facility_id[1].toString(), status: statusAvailable ? "Available" : "Unavailable", morning: "", afternoon: afternoonSlots.join(","), evening: "", mode: mode[1]), widget.id);
                await api().insertSchedule(schedule(day: widget.day, facilities_id: facility_id[2].toString(), status: statusAvailable ? "Available" : "Unavailable", morning: "", afternoon: "", evening: eveningSlots.join(","), mode: mode[2]), widget.id);

              }


                    print(morningSlots.join(","));
                    print(afternoonSlots.join(","));
                    print(eveningSlots.join(","));
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => scheduleslots(id: widget.id, hospitalId: widget.hospitalId),));
                  }
                : null,
          ),
        ),
      ),
    );
  }

  Future insertData(int facility_1, int facility_2, String morning, String afternoon, String evening) async {
    if(mode[facility_1] == mode[facility_2]){
      await api().insertSchedule(schedule(day: widget.day, facilities_id: facility_id[facility_1].toString(), status: statusAvailable ? "Available" : "Unavailable", morning: morning, afternoon: afternoon, evening: evening, mode: mode[0]), widget.id);
    }
    else{
      await api().insertSchedule(schedule(day: widget.day, facilities_id: facility_id[facility_1].toString(), status: statusAvailable ? "Available" : "Unavailable", morning: morning, afternoon: afternoon, evening: evening, mode: mode[facility_1]), widget.id);
      await api().insertSchedule(schedule(day: widget.day, facilities_id: facility_id[facility_1].toString(), status: statusAvailable ? "Available" : "Unavailable", morning: morning, afternoon: afternoon, evening: evening, mode: mode[facility_2]), widget.id);
    }
  }

  Widget timeSlots(List<String> slot){
    return Wrap(
      children: slot.map((e) {
        return Container(
          margin: EdgeInsets.all(5),
          child: components().text(
              e, FontWeight.normal, Colors.black, 18),
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(boxShadow: [
            BoxShadow(
                color: Colors.black12,
                blurStyle: BlurStyle.outer,
                blurRadius: 5)
          ], borderRadius: BorderRadius.circular(10)),
        );
      }).toList(),
    );
  }

  Widget timePicker(String selected) {
    return SizedBox(
      height: 180,
      child: CupertinoTimerPicker(
        mode: CupertinoTimerPickerMode.hm,
        minuteInterval: 1,
        secondInterval: 1,
        initialTimerDuration: initialTimer,
        onTimerDurationChanged: (Duration changeTimer) {
          setState(() {
            initialTimer = changeTimer;
            print(changeTimer);
            selected == "start"
                ? startTime =
                    '${changeTimer.inHours}:${changeTimer.inMinutes % 60}'
                : endTime =
                    '${changeTimer.inHours}:${changeTimer.inMinutes % 60}';
          });
        },
      ),
    );
  }
}
