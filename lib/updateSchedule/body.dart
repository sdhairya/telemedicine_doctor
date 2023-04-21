import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
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
  final Time schedule;
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
  List<String> facility_id = [];
  List<String> mode = ["both", "both", "both"];
  String m = "";
  String daytime = "Morning";
  bool online = false;
  bool offline = true;
  bool onlineBtn = false;
  bool offlineBtn = false;
  bool showBtn = false;
  bool timeInvalid = false;
  bool isLoading = false;
  var hospitalName;

  day mor = day(slots: [], mode: "", facilities_id: null);
  day aft = day(slots: [], mode: "", facilities_id: null);
  day eve = day(slots: [], mode: "", facilities_id: null);

  Time sch = Time(morning: null, afternoon: null, evening: null);


  @override
  void initState() {
    morningSlots = widget.schedule.morning!.slots.isEmpty ? ["No Slots Available"] : widget.schedule.morning!.slots.toString().split(",");
    var morHostiptaId = widget.schedule.morning!.facilities_id == null ? 0 : widget.schedule.morning?.facilities_id;

    afternoonSlots = widget.schedule.afternoon!.slots.isEmpty ? ["No Slots Available"] : widget.schedule.afternoon!.slots.toString().split(",");
    var aftHostiptaId = widget.schedule.afternoon!.facilities_id == null ? 0 : widget.schedule.afternoon?.facilities_id;

    eveningSlots = widget.schedule.evening!.slots.isEmpty ? ["No Slots Available"] : widget.schedule.evening!.slots.toString().split(",");
    var eveHostiptaId = widget.schedule.evening!.facilities_id == null ? 0 : widget.schedule.evening?.facilities_id;

    mor = day(slots: morningSlots, mode: widget.schedule.morning!.mode, facilities_id: morHostiptaId.toString());
    aft = day(slots: afternoonSlots, mode: widget.schedule.afternoon!.mode, facilities_id: aftHostiptaId.toString());
    eve = day(slots: eveningSlots, mode: widget.schedule.evening!.mode, facilities_id: eveHostiptaId.toString());
    facility_id.add(morHostiptaId!.toString());
    facility_id.add(aftHostiptaId!.toString());
    facility_id.add(eveHostiptaId.toString());

    if(daytime == "Morning"){
      if(widget.schedule.morning!.mode == "both"){
        setState(() {
          online = true;
          offline = true;
        });
      }
      else if(widget.schedule.morning!.mode == "offline"){
        setState(() {
          online = false;
          offline = true;
        });
      }
      else if(widget.schedule.morning!.mode == "online"){
        setState(() {
          online = true;
          offline = false;
        });
      }
      morningSlots = widget.schedule.morning!.slots.isEmpty ? ["No Slots Available"] : widget.schedule.morning!.slots;
      hostiptaId = widget.schedule.morning!.facilities_id! == null ? 0 : int.parse(widget.schedule.morning!.facilities_id!);
      var h = widget.hospitals.indexWhere((element) => element.id.toString() == widget.schedule.morning!.facilities_id);
      hospitalName = widget.hospitals[h].name;

      mor = day(
          slots: morningSlots, 
          mode: widget.schedule.morning!.mode, 
          facilities_id: widget.schedule.morning!.facilities_id);
      aft = day(
          slots: afternoonSlots, 
          mode: widget.schedule.afternoon!.mode,
      facilities_id: widget.schedule.afternoon!.facilities_id);

           eve = day(
          slots: eveningSlots, 
          mode: widget.schedule.evening!.mode,
           facilities_id: widget.schedule.evening!.facilities_id);
    }
    if(daytime == "Afternoon"){
      if(widget.schedule.afternoon!.mode == "both"){
        setState(() {
          online = true;
          offline = true;
        });
      }
      else if(widget.schedule.afternoon!.mode == "offline"){
        setState(() {
          online = false;
          offline = true;
        });
      }
      else if(widget.schedule.afternoon!.mode == "online"){
        setState(() {
          online = true;
          offline = false;
        });
      }
      afternoonSlots = widget.schedule.afternoon!.slots.isEmpty ? ["No Slots Available"] : widget.schedule.afternoon!.slots.toString().split(",");
      hostiptaId = int.parse(widget.schedule.afternoon!.facilities_id!);

      aft = day(slots: afternoonSlots, mode: widget.schedule.afternoon!.mode, facilities_id: hostiptaId.toString());
    }
    if(daytime == "Evening"){
      if(widget.schedule.evening!.mode == "both"){
        setState(() {
          online = true;
          offline = true;
        });
      }
      else if(widget.schedule.evening!.mode == "offline"){
        setState(() {
          online = false;
          offline = true;
        });
      }
      else if(widget.schedule.evening!.mode == "online"){
        setState(() {
          online = true;
          offline = false;
        });
      }
      eveningSlots = widget.schedule.evening!.slots.isEmpty ? ["No Slots Available"] : widget.schedule.evening!.slots;
      hostiptaId = int.parse(widget.schedule.evening!.facilities_id!);

      eve = day(slots: eveningSlots, mode: widget.schedule.evening!.mode, facilities_id: hostiptaId.toString());

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
            margin: const EdgeInsets.only(top: 20, left: 10),
            child: ListTile(
              leading: ElevatedButton(
                child: Icon(Icons.arrow_back_ios_new, size: 30, color: Color(0xff383434)),
                style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xfff6f6f4),
                    shape: CircleBorder(),
                    padding: EdgeInsets.only(top: 10, bottom: 10,left: 5, right: 5)
                ),
                onPressed: () {

                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => updateSchedule(id: widget.id),));

                },
              ),
              title: const components().text(
                  "    Schedule Timings", FontWeight.bold, Colors.black, 25),
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 30, left: 20, bottom: 20),
                child: const components()
                    .text(widget.day, FontWeight.w600, Colors.black, 32),
              ),
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: const [
                      BoxShadow(
                          color: Colors.black12,
                          blurRadius: 3,
                          blurStyle: BlurStyle.outer)
                    ]),
                padding: const EdgeInsets.all(10),
                margin: const EdgeInsets.only(left: 10, right: 10),
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 10, left: 10, bottom: 10),
                      alignment: Alignment.centerLeft,
                      child: Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          const components().text(
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
                            child: const components().text("   Mode", FontWeight.w500, Colors.black, 18),
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
                                      if(daytime == "Morning"){
                                        setState(() {
                                          if(online && offline){
                                            mode[0] = "both";
                                          }
                                          else if(online){
                                            mode[0] = "online";
                                          }
                                          else if(offline){
                                            mode[0] = "offline";
                                          }
                                        });
                                        mor.mode = mode[0];
                                      }
                                      else if(daytime == "Afternoon"){
                                        setState(() {
                                          if(online && offline){
                                            mode[1] = "both";
                                          }
                                          else if(online){
                                            mode[1] = "online";
                                          }
                                          else if(offline){
                                            mode[1] = "offline";
                                          }
                                          aft.mode = mode[1];
                                        });
                                      }
                                      else if(daytime == "Evening"){
                                        setState(() {
                                          if(online && offline){
                                            mode[2] = "both";
                                          }
                                          else if(online){
                                            mode[2] = "online";
                                          }
                                          else if(offline){
                                            mode[2] = "offline";
                                          }
                                          eve.mode = mode[2];
                                        });
                                      }
                                    });
                                  },),
                                  const components().text("Online", FontWeight.w500,
                                      const Color(0xff292929), 16),
                                  Checkbox(value: offline, onChanged: (value) {
                                    setState(() {
                                      offline = !offline;
                                      value = offline;
                                      showBtn = true;
                                      if(daytime == "Morning"){
                                        setState(() {
                                          if(online && offline){
                                            mode[0] = "both";
                                          }
                                          else if(online){
                                            mode[0] = "online";
                                          }
                                          else if(offline){
                                            mode[0] = "offline";
                                          }
                                        });
                                        mor.mode = mode[0];
                                      }
                                      else if(daytime == "Afternoon"){
                                        setState(() {
                                          if(online && offline){
                                            mode[1] = "both";
                                          }
                                          else if(online){
                                            mode[1] = "online";
                                          }
                                          else if(offline){
                                            mode[1] = "offline";
                                          }
                                          aft.mode = mode[1];
                                        });
                                      }
                                      else if(daytime == "Evening"){
                                        setState(() {
                                          if(online && offline){
                                            mode[2] = "both";
                                          }
                                          else if(online){
                                            mode[2] = "online";
                                          }
                                          else if(offline){
                                            mode[2] = "offline";
                                          }
                                          eve.mode = mode[2];
                                        });
                                      }
                                    });
                                  },),
                                  const components().text(
                                      "Offline",
                                      FontWeight.w500,
                                      const Color(0xff292929),
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
                                    border: Border.all(color: const Color(0xffd7d7d7)),
                                    borderRadius: BorderRadius.circular(15)),
                                child: DropdownButtonFormField<String>(
                                    decoration:
                                    const InputDecoration(border: InputBorder.none),
                                    hint: Padding(
                                        padding: const EdgeInsets.only(left: 15),
                                        child: const components().text(hospitalName,
                                            FontWeight.normal, Colors.black, 18)),
                                    items: widget.hospitals
                                        .map<DropdownMenuItem<String>>((value) {
                                      return DropdownMenuItem(
                                        child: const components().text("  " + value.name,
                                            FontWeight.normal, Colors.black, 16),
                                        value: value.name,
                                        onTap: () {
                                          hostiptaId = value.id;
                                          if(daytime == "Morning"){
                                            setState(() {
                                              mor.facilities_id = hostiptaId.toString();
                                            });
                                          }
                                          else if(daytime == "Afternoon"){
                                            setState(() {
                                              aft.facilities_id = hostiptaId.toString();
                                            });
                                          }
                                          else if(daytime == "Evening"){
                                            setState(() {
                                              eve.facilities_id = hostiptaId.toString();
                                            });
                                          }
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
                            margin: const EdgeInsets.only(top: 10, bottom: 10),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: const [
                                  BoxShadow(
                                      color: Colors.black26,
                                      blurRadius: 2,
                                      blurStyle: BlurStyle.outer),
                                ]),
                            child: DefaultTabController(
                                length: 3,
                                child: TabBar(
                                  labelColor: const Color(0xff32ae27),
                                  labelStyle: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 19),
                                  unselectedLabelColor: Colors.black,
                                  unselectedLabelStyle: const TextStyle(
                                      fontWeight: FontWeight.normal,
                                      fontSize: 17),
                                  indicator: const BoxDecoration(),
                                  labelPadding:
                                  const EdgeInsets.only(top: 8, bottom: 8),
                                  onTap: (value) {

                                    print(times[value]);
                                    setState(() {
                                      daytime = times[value];
                                    });

                                    if(daytime == "Morning"){
                                      if(widget.schedule.morning!.mode == "both"){
                                        setState(() {
                                          online = true;
                                          offline = true;
                                        });
                                      }
                                      else if(widget.schedule.morning!.mode == "offline"){
                                        setState(() {
                                          online = false;
                                          offline = true;
                                        });
                                      }
                                      else if(widget.schedule.morning!.mode == "online"){
                                        setState(() {
                                          online = true;
                                          offline = false;
                                        });
                                      }
                                      setState(() {
                                        morningSlots = widget.schedule.morning!.slots;
                                        hostiptaId = int.parse(widget.schedule.morning!.facilities_id!);
                                        var h = widget.hospitals.indexWhere((element) => element.id == widget.schedule.morning!.facilities_id);
                                        hospitalName = widget.hospitals[h].name;
                                        mor = day(slots: morningSlots, mode: widget.schedule.morning!.mode, facilities_id: hostiptaId.toString());
                                      });
                                    }
                                    if(daytime == "Afternoon"){
                                      if(widget.schedule.afternoon!.mode == "both"){
                                        setState(() {
                                          online = true;
                                          offline = true;
                                        });
                                      }
                                      else if(widget.schedule.afternoon!.mode == "offline"){
                                        setState(() {
                                          online = false;
                                          offline = true;
                                        });
                                      }
                                      else if(widget.schedule.afternoon!.mode == "online"){
                                        setState(() {
                                          online = true;
                                          offline = false;
                                        });
                                      }
                                      setState(() {
                                        afternoonSlots = widget.schedule.afternoon!.slots;
                                        hostiptaId = int.parse(widget.schedule.afternoon!.facilities_id!);
                                        var h = widget.hospitals.indexWhere((element) => element.id == int.parse(widget.schedule.afternoon!.facilities_id.toString()));
                                        hospitalName = widget.hospitals[h].name;

                                        aft = day(slots: afternoonSlots, mode: widget.schedule.afternoon!.mode, facilities_id: hostiptaId.toString());
                                      });
                                    }
                                    if(daytime == "Evening"){
                                      if(widget.schedule.evening!.mode == "both"){
                                        setState(() {
                                          online = true;
                                          offline = true;
                                        });
                                      }
                                      else if(widget.schedule.evening!.mode == "offline"){
                                        setState(() {
                                          online = false;
                                          offline = true;
                                        });
                                      }
                                      else if(widget.schedule.evening!.mode == "online"){
                                        setState(() {
                                          online = true;
                                          offline = false;
                                        });
                                      }
                                      setState(() {
                                        eveningSlots = widget.schedule.evening!.slots.isEmpty ? ["No Slots Available"] : widget.schedule.evening!.slots;
                                        hostiptaId = int.parse(widget.schedule.evening!.facilities_id!.toString());
                                        var h = widget.hospitals.indexWhere((element) => element.id == int.parse(widget.schedule.evening!.facilities_id.toString()));
                                        hospitalName = widget.hospitals[h].name;

                                        eve = day(slots: eveningSlots, mode: widget.schedule.evening!.mode, facilities_id: hostiptaId.toString());
                                      });
                                    }

                                  },
                                  tabs: [
                                    Wrap(
                                      crossAxisAlignment:
                                      WrapCrossAlignment.center,
                                      children: const [
                                        Icon(Icons.sunny),
                                        Text(
                                          "Morning",
                                        ),
                                      ],
                                    ),
                                    Wrap(
                                      crossAxisAlignment:
                                      WrapCrossAlignment.center,
                                      children: const [
                                        Icon(Icons.wb_twighlight),
                                        Text(
                                          "Afternoon",
                                        ),
                                      ],
                                    ),
                                    Wrap(
                                      crossAxisAlignment:
                                      WrapCrossAlignment.center,
                                      children: const [
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
                                  const components().text("Start Time",
                                      FontWeight.w300, Colors.black, 18),
                                  InkWell(
                                    onTap: () => showCupertinoModalPopup(
                                      context: context,
                                      builder: (context) =>
                                          CupertinoActionSheet(
                                            actions: [timePicker("start")],
                                            cancelButton:
                                            CupertinoActionSheetAction(
                                              child: const Text('Done'),
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
                                      padding: const EdgeInsets.only(left: 15),
                                      decoration: BoxDecoration(
                                          color: const Color(0xfff6f4f4),
                                          border: Border.all(
                                              color: const Color(0xffd7d7d7)),
                                          borderRadius:
                                          BorderRadius.circular(10)),
                                      child: Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                        children: [
                                          const components().text(
                                              startTime == null
                                                  ? "Time"
                                                  : startTime,
                                              FontWeight.normal,
                                              Colors.black,
                                              20),
                                          const Icon(
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
                                  const components().text("End Time", FontWeight.w300,
                                      Colors.black, 18),
                                  InkWell(
                                    onTap: () => showCupertinoModalPopup(
                                      context: context,
                                      builder: (context) =>
                                          CupertinoActionSheet(
                                            actions: [timePicker("end")],
                                            cancelButton:
                                            CupertinoActionSheetAction(
                                              child: const Text('Done'),
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
                                      padding: const EdgeInsets.only(left: 15),
                                      decoration: BoxDecoration(
                                          color: const Color(0xfff6f4f4),
                                          border: Border.all(
                                              color: const Color(0xffd7d7d7)),
                                          borderRadius:
                                          BorderRadius.circular(10)),
                                      child: Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                        children: [
                                          const components().text(
                                              endTime == null
                                                  ? "Time"
                                                  : endTime,
                                              FontWeight.normal,
                                              Colors.black,
                                              20),
                                          const Icon(
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
                          const SizedBox(
                            height: 10,
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: const components().text("Timing Slot Duration",
                                FontWeight.normal, Colors.black, 18),
                          ),
                          Container(
                            height: MediaQuery.of(context).size.height * 0.07,
                            width: double.maxFinite,
                            alignment: Alignment.center,
                            margin: const EdgeInsets.only(top: 5, bottom: 10),
                            decoration: BoxDecoration(
                                border: Border.all(color: const Color(0xffd7d7d7)),
                                borderRadius: BorderRadius.circular(15)),
                            child: DropdownButtonFormField<String>(
                                decoration:
                                const InputDecoration(border: InputBorder.none),
                                hint: Padding(
                                    padding: const EdgeInsets.only(left: 15),
                                    child: const components().text("Select Duration",
                                        FontWeight.normal, Colors.black, 18)),
                                items: duration
                                    .map<DropdownMenuItem<String>>((value) {
                                  return DropdownMenuItem(
                                    child: const components().text(
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
                                          facility_id[0] = hostiptaId.toString();
                                        }
                                        else if(online){
                                          mode[0] = "online";
                                        }
                                        else if(offline){
                                          mode[0] = "offline";
                                          facility_id[0] = hostiptaId.toString();
                                        }
                                        mor.slots = morningSlots;
                                        mor.facilities_id = facility_id[0].toString();
                                        mor.mode = mode[0];
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
                                          facility_id[1] = hostiptaId.toString();
                                        }
                                        else if(online){
                                          mode[1] = "online";
                                        }
                                        else if(offline){
                                          mode[1] = "offline";
                                          facility_id[1] = hostiptaId.toString();
                                        }
                                        aft.slots = afternoonSlots;
                                        aft.facilities_id = facility_id[1].toString();
                                        aft.mode = mode[1];
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
                                          facility_id[2] = hostiptaId.toString();
                                        }
                                        else if(online){
                                          mode[2] = "online";
                                        }
                                        else if(offline){
                                          mode[2] = "offline";
                                          facility_id[2] = hostiptaId.toString();
                                        }

                                        eve.slots = eveningSlots;
                                        eve.facilities_id = facility_id[2].toString();
                                        eve.mode = mode[2];
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
                          timeInvalid ? const components().text("! Please select start time and end time", FontWeight.normal, Colors.red, 16) : Container(),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: const components().text("Slots", FontWeight.normal, Colors.black, 20),
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
            child: isLoading ? const CircularProgressIndicator(color: Colors.white,): const components().text("Update", FontWeight.bold, Colors.white, 22),
            onPressed:
            //showBtn ?
                () async {
              setState(() {
                isLoading = true;
              });
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

              //daytime == "Morning" ? await api().update_schedule(widget.schedule.morning.id, update_Schedule(daytime: daytime, slots: morningSlots.join(","), facilities_id: hostiptaId, mode: m, status: "Available")) : null;
              //daytime == "Afternoon" ? await api().update_schedule(widget.schedule.afternoon.id, update_Schedule(daytime: daytime, slots: afternoonSlots.join(","), facilities_id: hostiptaId, mode: m, status: "Available")) : null ;
              //daytime == "Evening" ? await api().update_schedule(widget.schedule.evening.id, update_Schedule(daytime: daytime, slots: eveningSlots.join(","), facilities_id: hostiptaId, mode: m, status: "Available")) : null;

              sch.morning = mor;
              sch.afternoon = aft;
              sch.evening = eve;

              print(sch);

              var j = jsonEncode(sch.toJson());
              print(j);
              await api().sch(widget.schedule.id.toString(), j);

              Lottie.asset("assets/animations/doneAnim.zip");
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => updateSchedule(id: widget.id,),));
            }
                //: null,
          ),
        ),
      ),
    );


  }

  Widget timeSlots(List<String> slot){

    return slot.length == 1 ? const Text("No Slots available") : Wrap(
      children: slot.map((e) {
        return Container(
            margin: const EdgeInsets.all(5),
          child: const components().text(
              e, FontWeight.normal, Colors.black, 18),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              boxShadow: const [
                BoxShadow(
                    color: Colors.black12,
                    blurStyle: BlurStyle.outer,
                    blurRadius: 5)
              ],
              borderRadius: BorderRadius.circular(10),),
          );
      }).toList(),
    );
  }

  // Widget timeSlots(List<String> slot){
  //   return Wrap(
  //     children: slot.map((e) {
  //       return Container(
  //         margin: EdgeInsets.all(5),
  //         child: components().text(
  //             e, FontWeight.normal, Colors.black, 18),
  //         padding: EdgeInsets.all(10),
  //         decoration: BoxDecoration(boxShadow: [
  //           BoxShadow(
  //               color: Colors.black12,
  //               blurStyle: BlurStyle.outer,
  //               blurRadius: 5)
  //         ], borderRadius: BorderRadius.circular(10)),
  //       );
  //     }).toList(),
  //   );
  // }

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
