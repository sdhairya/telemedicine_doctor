import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:telemedicine_doctor/api.dart';
import 'package:telemedicine_doctor/colors.dart';
import 'package:telemedicine_doctor/components.dart';
import 'package:telemedicine_doctor/scheduleslotsScreen/scheduleslots.dart';
import 'package:telemedicine_doctor/updateSchedule/updateSchedule.dart';

import '../dataClass/dataClass.dart';

class body extends StatefulWidget {
  final List<hospital> hospitals;
  final String day;
  final String id;
  final List<dayTime> schedule;
  const body({Key? key, required this.hospitals, required this.day, required this.id, required this.schedule})
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
  int dur = 0;
  bool statusAvailable = true;
  List<String> times = ["Morning", "Afternoon", "Evening"];
  List<String> morningSlots = [];
  List<String> afternoonSlots = [];
  List<String> eveningSlots = [];
  List<int> facility_id = [];
  List<String> mode = ["both", "both", "both"];
  String m = "";
  String daytime = "Morning";
  bool online = false;
  bool offline = true;
  bool onlineBtn = false;
  bool offlineBtn = false;
  bool showBtn = false;
  bool timeInvalid = false;
  var hospitalName;


  @override
  void initState() {
    if(daytime == "Morning"){
      if(widget.schedule[0].morning.mode == "both"){
        setState(() {
          online = true;
          offline = true;
        });
      }
      else if(widget.schedule[0].morning.mode == "offline"){
        setState(() {
          online = false;
          offline = true;
        });
      }
      else if(widget.schedule[0].morning.mode == "online"){
        setState(() {
          online = true;
          offline = false;
        });
      }
      morningSlots = widget.schedule[0].morning.slots.toString().split(",");
      hostiptaId = widget.schedule[0].morning.facility.id;
      hospitalName = widget.schedule[0].morning.facility.name;
    }
    if(daytime == "Afternoon"){
      if(widget.schedule[0].afternoon.mode == "both"){
        setState(() {
          online = true;
          offline = true;
        });
      }
      else if(widget.schedule[0].afternoon.mode == "offline"){
        setState(() {
          online = false;
          offline = true;
        });
      }
      else if(widget.schedule[0].afternoon.mode == "online"){
        setState(() {
          online = true;
          offline = false;
        });
      }
      afternoonSlots = widget.schedule[0].afternoon.slots.toString().split(",");
      hostiptaId = widget.schedule[0].afternoon.facility.id;
    }
    if(daytime == "Evening"){
      if(widget.schedule[0].evening.mode == "both"){
        setState(() {
          online = true;
          offline = true;
        });
      }
      else if(widget.schedule[0].evening.mode == "offline"){
        setState(() {
          online = false;
          offline = true;
        });
      }
      else if(widget.schedule[0].evening.mode == "online"){
        setState(() {
          online = true;
          offline = false;
        });
      }
      eveningSlots = widget.schedule[0].evening.slots.toString().split(",");
      hostiptaId = widget.schedule[0].evening.facility.id;
    }

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
                                      showBtn = true;
                                    });
                                  },),
                                  components().text("Online", FontWeight.w500,
                                      Color(0xff292929), 16),
                                  Checkbox(value: offline, onChanged: (value) {
                                    setState(() {
                                      offline = !offline;
                                      value = offline;
                                      showBtn = true;
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
                                        child: components().text(hospitalName,
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
                                        showBtn = true;
                                      });
                                    }),
                              ) : null
                          ),
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
                                      daytime = times[value];
                                    });

                                    if(daytime == "Morning"){
                                      if(widget.schedule[0].morning.mode == "both"){
                                        setState(() {
                                          online = true;
                                          offline = true;
                                        });
                                      }
                                      else if(widget.schedule[0].morning.mode == "offline"){
                                        setState(() {
                                          online = false;
                                          offline = true;
                                        });
                                      }
                                      else if(widget.schedule[0].morning.mode == "online"){
                                        setState(() {
                                          online = true;
                                          offline = false;
                                        });
                                      }
                                      setState(() {
                                        morningSlots = widget.schedule[0].morning.slots.toString().split(",");
                                        hostiptaId = widget.schedule[0].morning.facility.id;
                                        hospitalName = widget.schedule[0].morning.facility.name;
                                      });
                                    }
                                    if(daytime == "Afternoon"){
                                      if(widget.schedule[0].afternoon.mode == "both"){
                                        setState(() {
                                          online = true;
                                          offline = true;
                                        });
                                      }
                                      else if(widget.schedule[0].afternoon.mode == "offline"){
                                        setState(() {
                                          online = false;
                                          offline = true;
                                        });
                                      }
                                      else if(widget.schedule[0].afternoon.mode == "online"){
                                        setState(() {
                                          online = true;
                                          offline = false;
                                        });
                                      }
                                      setState(() {
                                        afternoonSlots = widget.schedule[0].afternoon.slots.toString().split(",");
                                        hostiptaId = widget.schedule[0].afternoon.facility.id;
                                        hospitalName = widget.schedule[0].afternoon.facility.name;
                                      });
                                    }
                                    if(daytime == "Evening"){
                                      if(widget.schedule[0].evening.mode == "both"){
                                        setState(() {
                                          online = true;
                                          offline = true;
                                        });
                                      }
                                      else if(widget.schedule[0].evening.mode == "offline"){
                                        setState(() {
                                          online = false;
                                          offline = true;
                                        });
                                      }
                                      else if(widget.schedule[0].evening.mode == "online"){
                                        setState(() {
                                          online = true;
                                          offline = false;
                                        });
                                      }
                                      setState(() {
                                        eveningSlots = widget.schedule[0].evening.slots.toString().split(",");
                                        hostiptaId = widget.schedule[0].evening.facility.id;
                                        hospitalName = widget.schedule[0].evening.facility.name;
                                      });
                                    }

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
                                    showBtn = true;
                                  });
                                  if(startTime == null && endTime == null){
                                    setState(() {
                                      timeInvalid = true;
                                    });
                                  }
                                  else{
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
                                    if(daytime == "Morning"){
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
                                    else if(daytime == "Afternoon"){
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
                                    else if(daytime == "Evening"){
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
                                  }

                                }),
                          ),
                          timeInvalid ? components().text("! Please select start time and end time", FontWeight.normal, Colors.red, 16) : Container(),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: components().text("Slots", FontWeight.normal, Colors.black, 20),
                          ),
                          daytime == "Morning" ? timeSlots(morningSlots) : Container(),
                          daytime == "Afternoon" ? timeSlots(afternoonSlots) : Container(),
                          daytime == "Evening" ? timeSlots(eveningSlots) : Container(),

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
            child: components().text("Update", FontWeight.bold, Colors.white, 22),
            onPressed: showBtn
                ? () async {

              if(online && offline ){
                setState(() {
                  m = "both";
                });
              }
              else if(online == true && offline == false){
                setState(() {
                  m = "online";
                });
              }
              else if(online == false && offline == true){
                setState(() {
                  m = "offline";
                });
              }

              setState(() {
                morningSlots = morningSlots;
                afternoonSlots = afternoonSlots;
                eveningSlots = eveningSlots;
              });

              daytime == "Morning" ? await api().update_schedule(widget.schedule[0].morning.id.toString(), update_Schedule(daytime: daytime, slots: morningSlots.join(","), facilities_id: hostiptaId, mode: m, status: "Available")) : null;
              daytime == "Afternoon" ? await api().update_schedule(widget.schedule[0].afternoon.id.toString(), update_Schedule(daytime: daytime, slots: afternoonSlots.join(","), facilities_id: hostiptaId, mode: m, status: "Available")) : null ;
              daytime == "Evening" ? await api().update_schedule(widget.schedule[0].evening.id.toString(), update_Schedule(daytime: daytime, slots: eveningSlots.join(","), facilities_id: hostiptaId, mode: m, status: "Available")) : null;

              print(morningSlots.join(","));
              print(afternoonSlots.join(","));
              print(eveningSlots.join(","));
              // Navigator.of(context).push(MaterialPageRoute(builder: (context) => updateSchedule(phone: widget.phone,),));
            }
                : null,
          ),
        ),
      ),
    );


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
