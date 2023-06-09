import 'dart:async';
import 'dart:convert';

import 'package:draggable_widget/draggable_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:telemedicine_doctor/signaling.dart';

import '../api.dart';
import '../colors.dart';
import '../components.dart';
import '../dataClass/dataClass.dart';

class videoCallScreen extends StatefulWidget {
  final String roomId;
  final String role;
  final appointment appointmentData;
  final profile doctorProfile;
  final List<prescription> pres;


  // final RTCVideoRenderer localRenderer;
  // final RTCVideoRenderer remoteRenderer;

  const videoCallScreen({Key? key, required this.roomId, required this.role, required this.appointmentData, required this.doctorProfile, required this.pres})
      : super(key: key);

  @override
  State<videoCallScreen> createState() => _videoCallScreenState();
}

class _videoCallScreenState extends State<videoCallScreen> with SingleTickerProviderStateMixin{
  Signaling signaling = Signaling();
  RTCVideoRenderer _localRenderer = RTCVideoRenderer();
  RTCVideoRenderer _remoteRenderer = RTCVideoRenderer();

  bool audio = true;
  bool video = true;

  int daytime = 0;
  List<medicine> medicines = [];
  TextEditingController pillName = TextEditingController();
  TextEditingController quantity = TextEditingController();
  TextEditingController duration = TextEditingController();
  TextEditingController symptoms = TextEditingController();
  TextEditingController diagnosis = TextEditingController();
  TextEditingController test = TextEditingController();
  String food = "";
  String dayTime = "";
  bool before = false;
  bool after = false;
  bool morning = false;
  bool afternoon = false;
  bool evening = false;
  bool foodInvalid = false;
  bool dayInvalid = false;
  String elapsedTime = "";
  bool timerStart = false;
  late TabController _tabController = TabController(length: 4, vsync: this);
  final _dialogFormKey = GlobalKey<FormState>();


  @override
  void initState() {
    setState(() {
      _localRenderer.initialize();
      _remoteRenderer.initialize();
    });


    signaling.onAddRemoteStream = ((stream) {
      _remoteRenderer.srcObject = stream;
      print("|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
      setState(() {
        timerStart = true;
        _start();
      });
    });

    // signaling.openUserMedia(_localRenderer, _remoteRenderer);

    // _stream = _reference.snapshots();
    
    medicines.addAll(widget.pres[0].medicines);
    symptoms.text = widget.pres[0].symptoms;
    diagnosis.text = widget.pres[0].diagnosis;
    test.text = widget.pres[0].test;
    
    super.initState();
    join();
  }

  @override
  void dispose() {
    _localRenderer.dispose();
    _remoteRenderer.dispose();
    super.dispose();
  }

  Future<String> join() async {
    await signaling.openUserMedia(_localRenderer, _remoteRenderer, true, true);
    print("opened");
    print(widget.role);

    if (widget.role == "host") {
      signaling.joinCaller(
          widget.roomId,
          _remoteRenderer,
          "Video"
      );
      await api().doctorAck(widget.appointmentData.id.toString());
      setState(() {});
    } else if (widget.role == "client") {
      signaling.joinRoom(
        widget.roomId,
        _remoteRenderer,
      );
      await api().patientAck(widget.appointmentData.id.toString());
    }

    return "Success";
  }

  final Stopwatch _stopwatch = Stopwatch();
  late Timer _timer;
  String _result = '00:00:00';
  void _start() {
    _timer = Timer.periodic(const Duration(milliseconds: 30), (Timer t) {
      setState(() {
        _result =
        '${_stopwatch.elapsed.inMinutes.toString().padLeft(2, '0')}:${(_stopwatch.elapsed.inSeconds % 60).toString().padLeft(2, '0')}';
      });
    });
    _stopwatch.start();
  }

  @override
  Widget build(BuildContext context) {
    // setState((){signaling.openUserMedia(_localRenderer, _remoteRenderer);});
    // signaling.joinRoom(
    //   widget.roomId,
    //   _remoteRenderer,
    // );
    final dragController = DragController();


    return SafeArea(
        child: Scaffold(
          body: Stack(
            children: [
              Container(
                  decoration: BoxDecoration(color: Colors.black26),
                  child: RTCVideoView(_remoteRenderer)),
              Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    width: double.infinity,
                    margin: EdgeInsets.all(10),
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.black38,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment:  CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            components().text(widget.appointmentData.name!, FontWeight.w600, Colors.white, 24),
                            components().text(timerStart ? _result : "Wating" , FontWeight.w600, Colors.white, 24),
                          ],
                        ),
                        Divider(color: Colors.white38),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    padding: EdgeInsets.all(10),
                                    backgroundColor: Colors.white,
                                    enableFeedback: true,
                                    shape: CircleBorder()),
                                onPressed: () {
                                  setState(() {
                                    audio = !audio;
                                    if(!audio){
                                      signaling.stopAudioOnly();
                                    }
                                    else{
                                      // signaling.startVideoOnly();
                                      signaling.startAudioOnly();
                                    }
                                  });
                                },
                                child: Icon(
                                  audio ? Icons.mic : Icons.mic_off_rounded,
                                  color: Colors.black,
                                  size: 30,
                                )),
                            ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    padding: EdgeInsets.all(10),
                                    backgroundColor: Colors.white,
                                    textStyle: TextStyle(fontSize: 18),
                                    enableFeedback: true,
                                    shape: CircleBorder()),
                                onPressed: () {
                                  setState(() {
                                    video = !video;

                                    if(!video){
                                      signaling.stopVideoOnly();
                                    }
                                    else{
                                      // signaling.startVideoOnly();
                                      signaling.startVideoOnly();
                                    }
                                  });


                                },
                                child: Icon(
                                  video ? Icons.videocam : Icons.videocam_off,
                                  color: Colors.black,
                                  size: 30,
                                )),
                            ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    padding: EdgeInsets.all(10),
                                    backgroundColor: Color(0xFFC90000),
                                    textStyle: TextStyle(fontSize: 18),
                                    enableFeedback: true,
                                    shape: CircleBorder()),
                                onPressed: () {
                                  showCupertinoModalBottomSheet(
                                      expand: false,
                                      context: context,
                                      backgroundColor: Colors.white,
                                      builder: (context) =>Padding(
                                        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                                        child:  Material(
                                          child: Column(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Container(height: MediaQuery.of(context).size.height * 0.3, color: Colors.white,
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      AspectRatio(aspectRatio: 5/8, child: Container(child: RTCVideoView(_localRenderer)),),
                                                      SizedBox(width: 10,),
                                                      AspectRatio(aspectRatio: 5/8, child: Container(child: RTCVideoView(_remoteRenderer)),),
                                                    ],
                                                  )),
                                              Expanded(
                                                child: Column(
                                                  children: [
                                                    Material(
                                                      child: Container(
                                                        width: double.infinity,
                                                        padding: const EdgeInsets.only(top: 10, bottom: 5, right: 10, left: 10),
                                                        decoration: BoxDecoration(
                                                            shape: BoxShape.rectangle,
                                                            borderRadius: BorderRadius.circular(10),
                                                            color: Colors.white),
                                                        child: TabBar(
                                                          controller: _tabController,
                                                          labelPadding: const EdgeInsets.only(top: 10, bottom: 5),
                                                          indicator: UnderlineTabIndicator(borderSide: BorderSide(color: colors().logo_darkBlue, width: 2)),
                                                          onTap: (value) {
                                                          },
                                                          tabs: [
                                                            const components().text("History", FontWeight.bold, colors().logo_darkBlue, 16),
                                                            const components().text("Diagnosis", FontWeight.bold, colors().logo_darkBlue, 16),
                                                            const components().text("Test", FontWeight.bold, colors().logo_darkBlue, 16),
                                                            const components().text("Medicines", FontWeight.bold, colors().logo_darkBlue, 16),

                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: Container(
                                                        width: double.infinity,
                                                        height: MediaQuery.of(context).size.height,
                                                        padding: const EdgeInsets.all(15),
                                                        color: Color(0xffE7F2FB),
                                                        child: TabBarView(
                                                          controller: _tabController,
                                                          children: [
                                                            FutureBuilder(
                                                              future: api().getHistory(widget.appointmentData.id.toString()),
                                                              builder: (context, snapshot) {
                                                                print(snapshot.data);
                                                                if(snapshot.hasData){
                                                                  return ListView.separated(
                                                                    itemCount: snapshot.data!.length,
                                                                    itemBuilder: (context, index) {
                                                                      return buildHistory(snapshot.data![index]);
                                                                    },
                                                                    separatorBuilder: (context, index) {
                                                                      return const Divider();
                                                                    },
                                                                  );
                                                                }
                                                                return CircularProgressIndicator();
                                                              },
                                                            ),
                                                            SingleChildScrollView(
                                                              child: Column(
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: [
                                                                  const components().text("Symptoms", FontWeight.w600, Colors.black, 17),
                                                                  const components().textField_prescription("Write Symptoms here", TextInputType.text, symptoms,"symptoms", widget.appointmentData.id!),
                                                                  SizedBox(height: 20,),
                                                                  const components().text("Diagnosis", FontWeight.w600, Colors.black, 17),
                                                                  const components().textField_prescription("Write Diagnosis", TextInputType.text, diagnosis,"diagnosis", widget.appointmentData.id!),


                                                                ],
                                                              ),
                                                            ),
                                                            SingleChildScrollView(
                                                              child: Column(
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: [
                                                                  const components().text("Test", FontWeight.w600, Colors.black, 17),
                                                                  const components().textField_prescription("Write any test required", TextInputType.text, test,"test", widget.appointmentData.id!),
                                                                ],
                                                              ),
                                                            ),
                                                            StatefulBuilder(
                                                              builder: (context, setState) {
                                                                return Scaffold(
                                                                  body:  Container(
                                                                    width: double.infinity,
                                                                    color: const Color(0xffE7F2FB),
                                                                    child: ListView.builder(
                                                                      itemCount: medicines.length,
                                                                      itemBuilder: (context, index) {
                                                                        return Container(
                                                                          padding: EdgeInsets.all(10),
                                                                          margin: EdgeInsets.only(bottom: 5),
                                                                          decoration: BoxDecoration(
                                                                            color: Colors.white,
                                                                            borderRadius: BorderRadius.circular(10),
                                                                          ),
                                                                          child: Column(
                                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                                            children: [
                                                                              Row(
                                                                                mainAxisSize: MainAxisSize.max,
                                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                children: [
                                                                                  Container(
                                                                                    child: components().text(medicines[index].name.toString(), FontWeight.w600, colors().logo_darkBlue, 18),
                                                                                  ),
                                                                                  Row(
                                                                                    children: [
                                                                                      InkWell(
                                                                                        child: Container(
                                                                                          child: Icon(Icons.edit, color: colors().logo_darkBlue),
                                                                                          decoration: BoxDecoration(
                                                                                              shape: BoxShape.circle,
                                                                                              color: Color(0xffE7F2FB)
                                                                                          ),
                                                                                          padding: EdgeInsets.all(5),
                                                                                        ),
                                                                                        onTap: () {
                                                                                          pillName.text = medicines[index].name!;
                                                                                          quantity.text = medicines[index].quantity!.toString();
                                                                                          duration.text = medicines[index].duration!.toString();
                                                                                          medicines[index].food.contains("Before Food") ? before = true : before = false;
                                                                                          medicines[index].food.contains("After Food") ? after = true : after = false;
                                                                                          medicines[index].daytime.contains("Morning") ? morning = true : morning = false;
                                                                                          medicines[index].daytime.contains("Afternoon") ? afternoon = true : afternoon = false;
                                                                                          medicines[index].daytime.contains("Evening") ? evening = true : evening = false;
                                                                                          // if("Before Food")
                                                                                          showDialog(context: context, barrierDismissible:  false,builder: (context) =>StatefulBuilder(
                                                                                            builder: (context, setState) => AlertDialog(
                                                                                              content: dialog(),
                                                                                              actions: [
                                                                                                ElevatedButton(
                                                                                                    onPressed: () {
                                                                                                      Navigator.of(context).pop();
                                                                                                    },
                                                                                                    child: Text("Cancel"),
                                                                                                    style: ElevatedButton.styleFrom(
                                                                                                      shape: StadiumBorder(),
                                                                                                      backgroundColor: colors().logo_darkBlue,
                                                                                                    )),
                                                                                                ElevatedButton(onPressed: ()  async {
                                                                                                  if(_dialogFormKey.currentState!.validate()){
                                                                                                    if((before || after) && (morning || afternoon || evening)){

                                                                                                      Navigator.of(context).pop(true);
                                                                                                    }
                                                                                                    else{
                                                                                                      setState(() {
                                                                                                        foodInvalid = true;
                                                                                                        dayInvalid = true;
                                                                                                      });
                                                                                                    }

                                                                                                  }

                                                                                                }  , child: Text("Update"),
                                                                                                    style: ElevatedButton.styleFrom(
                                                                                                      shape: StadiumBorder(),
                                                                                                      backgroundColor: colors().logo_darkBlue,
                                                                                                    ))
                                                                                              ],
                                                                                            ),
                                                                                          )).then((value) async{
                                                                                            setState(() {
                                                                                              List<String?> day = [];
                                                                                              List<String?> foodtime = [];
                                                                                              day = [morning ? "Morning" : "", afternoon ? "Afternoon" : "", evening ? "Evening" : ""];
                                                                                              foodtime = [before ? "Before Food" : "", after ? "After Food" : ""];
                                                                                              print(day);
                                                                                              print(foodtime);
                                                                                              medicines[index].name = pillName.text;
                                                                                              medicines[index].quantity = int.parse(quantity.text);
                                                                                              medicines[index].duration = int.parse(duration.text);
                                                                                              medicines[index].food = foodtime;
                                                                                              medicines[index].daytime = day;
                                                                                            });
                                                                                            var j = jsonEncode(medicines.map((e) => e.toJson()).toList());
                                                                                            await api().prescribe(widget.appointmentData.id!, "medicines", j);
                                                                                          },);
                                                                                        },
                                                                                      ),
                                                                                      SizedBox(width: 10,),
                                                                                      InkWell(
                                                                                        child: Container(
                                                                                          child: Icon(Icons.delete, color: Colors.red),
                                                                                          decoration: BoxDecoration(
                                                                                              shape: BoxShape.circle,
                                                                                              color: Color(0xffE7F2FB)
                                                                                          ),
                                                                                          padding: EdgeInsets.all(5),
                                                                                        ),
                                                                                        onTap: () async {

                                                                                          showDialog(context: context, builder: (context) =>StatefulBuilder(
                                                                                            builder: (context, setState) => AlertDialog(
                                                                                              title: components().text("Confirmation", FontWeight.normal, Colors.black, 16),
                                                                                              content: components().text("Are you sure you want to delete", FontWeight.normal, Colors.black, 16),
                                                                                              actions: [
                                                                                                ElevatedButton(
                                                                                                    onPressed: () {
                                                                                                      Navigator.of(context).pop();
                                                                                                    },
                                                                                                    child: Text("Cancel"),
                                                                                                    style: ElevatedButton.styleFrom(
                                                                                                      shape: StadiumBorder(),
                                                                                                      backgroundColor: colors().logo_darkBlue,
                                                                                                    )),
                                                                                                ElevatedButton(onPressed: ()  async {
                                                                                                  // setState(() {
                                                                                                  //   medicines.removeAt(index);
                                                                                                  //   print(medicines);
                                                                                                  // });

                                                                                                  Navigator.pop(context);
                                                                                                }  , child: Text("Yes"),
                                                                                                    style: ElevatedButton.styleFrom(
                                                                                                      shape: StadiumBorder(),
                                                                                                      backgroundColor: colors().logo_darkBlue,
                                                                                                    ))
                                                                                              ],
                                                                                            ),
                                                                                          )).then((value) async {
                                                                                            setState(() {
                                                                                              medicines.removeAt(index);
                                                                                              print(medicines);
                                                                                            });
                                                                                            var j = jsonEncode(medicines.map((e) => e.toJson()).toList());
                                                                                            await api().prescribe(widget.appointmentData.id!, "medicines", j);
                                                                                            print(medicines);
                                                                                          },);

                                                                                        },
                                                                                      ),
                                                                                    ],
                                                                                  )
                                                                                ],
                                                                              ),


                                                                              SizedBox(height: 5,),
                                                                              Row(
                                                                                children: [
                                                                                  components().text("Quantity: "+medicines[index].quantity.toString(), FontWeight.normal, colors().logo_darkBlue, 16),
                                                                                  SizedBox(width: 30,),
                                                                                  components().text("Days: "+medicines[index].duration.toString(), FontWeight.normal, colors().logo_darkBlue, 16),
                                                                                ],
                                                                              ),
                                                                              SizedBox(height: 5,),
                                                                              Wrap(
                                                                                children: [
                                                                                  components().text(medicines[index].food.join(" "), FontWeight.w500, colors().logo_darkBlue, 16),
                                                                                  SizedBox(width: 30,),
                                                                                  components().text(medicines[index].daytime.join(" "), FontWeight.w500, colors().logo_darkBlue, 16),
                                                                                ],
                                                                              )
                                                                            ],
                                                                          ),
                                                                        );
                                                                      },
                                                                    ),
                                                                  ),
                                                                  floatingActionButton: Container(
                                                                    width: MediaQuery.of(context).size.width * 0.5,
                                                                    child: ElevatedButton(
                                                                      style: ElevatedButton.styleFrom(
                                                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                                                          padding: EdgeInsets.only(top: 10, bottom: 10),
                                                                          backgroundColor: colors().logo_darkBlue
                                                                      ),
                                                                      onPressed: () {
                                                                        showDialog(context: context, builder: (context) =>StatefulBuilder(
                                                                          builder: (context, setState) => AlertDialog(
                                                                            content: dialog(),
                                                                            actions: [
                                                                              ElevatedButton(
                                                                                  onPressed: () {
                                                                                    Navigator.of(context).pop();
                                                                                  },
                                                                                  child: Text("Cancel"),
                                                                                  style: ElevatedButton.styleFrom(
                                                                                    shape: StadiumBorder(),
                                                                                    backgroundColor: colors().logo_darkBlue,
                                                                                  )),
                                                                              ElevatedButton(onPressed: ()  async {
                                                                                if(_dialogFormKey.currentState!.validate()){
                                                                                  // before ? null : setState((){foodInvalid = true;});
                                                                                  // after ? null : setState((){foodInvalid = true;});
                                                                                  // // if(before && after){
                                                                                  // //   setState(() {
                                                                                  // //     foodInvalid = true;
                                                                                  // //   });
                                                                                  // // }
                                                                                  // if(morning && afternoon && evening ){
                                                                                  //   setState(() {
                                                                                  //     dayInvalid = true;
                                                                                  //   });
                                                                                  // }
                                                                                  if((before || after) && (morning || afternoon || evening)){
                                                                                    List<String?> day = [];
                                                                                    List<String?> foodtime = [];
                                                                                    day = [morning ? "Morning" : "", afternoon ? "Afternoon" : "", evening ? "Evening" : ""];
                                                                                    foodtime = [before ? "Before Food" : "", after ? "After Food" : ""];
                                                                                    // morning ? day = day + "Morning " : null;
                                                                                    // afternoon ? day = day + " Afternoon " : null;
                                                                                    // evening ? day = day + " Evening" : null;
                                                                                    // before ? foodtime = foodtime + "Before Food " : null;
                                                                                    // after ? foodtime = foodtime + " After Food" : null;
                                                                                    setState(() {
                                                                                      medicines.add(medicine(name: pillName.text, quantity: int.parse(quantity.text), duration: int.parse(duration.text), food: foodtime, daytime: day));

                                                                                      pillName.clear();
                                                                                      quantity.clear();
                                                                                      duration.clear();
                                                                                      before = false;
                                                                                      after = false;
                                                                                      morning = false;
                                                                                      afternoon = false;
                                                                                      evening = false;
                                                                                      foodInvalid = false;
                                                                                      dayInvalid = false;

                                                                                    });
                                                                                    var j = jsonEncode(medicines.map((e) => e.toJson()).toList());
                                                                                    await api().prescribe(widget.appointmentData.id!, "medicines", j);
                                                                                    Navigator.pop(context);
                                                                                  }
                                                                                  else{
                                                                                    setState(() {
                                                                                      foodInvalid = true;
                                                                                      dayInvalid = true;
                                                                                    });
                                                                                  }


                                                                                }

                                                                              }  , child: Text("Add"),
                                                                                  style: ElevatedButton.styleFrom(
                                                                                    shape: StadiumBorder(),
                                                                                    backgroundColor: colors().logo_darkBlue,
                                                                                  ))
                                                                            ],
                                                                          ),
                                                                        ));
                                                                      },
                                                                      child: Row(
                                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                                        children: [
                                                                          Icon(Icons.add, color: Colors.white,),
                                                                          components().text("Add Medicine", FontWeight.w600, Colors.white, 18)
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
                                                                );
                                                              },
                                                            ),



                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),)
                                            ],
                                          ),
                                        ),
                                      )
                                  );
                                },
                                child: Icon(
                                  Icons.folder_copy,
                                  size: 30,
                                )),
                            ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    padding: EdgeInsets.all(10),
                                    backgroundColor: Color(0xFFC90000),
                                    textStyle: TextStyle(fontSize: 18),
                                    enableFeedback: true,
                                    shape: CircleBorder()),
                                onPressed: () {
                                  dispose();
                                  signaling.hangUp(_localRenderer);
                                  Navigator.pop(context);
                                },
                                child: Icon(
                                  Icons.call_end,
                                  size: 30,
                                )),
                          ],
                        )
                      ],
                    ),
                  )
              ),
              DraggableWidget(
                bottomMargin: MediaQuery.of(context).size.height * 0.15,
                topMargin: 20,
                horizontalSpace: 20,
                intialVisibility: true,
                shadowBorderRadius: 0,
                child: Container(
                  height: 213,
                  width: 120,
                  child: RTCVideoView(_localRenderer),
                ),
                initialPosition: AnchoringPosition.topRight,
                dragController: dragController,
              )
            ],
          ),
        ));

  }

  Widget dialog(){

    return StatefulBuilder(
        builder: (context, setState) => Form(
          key: _dialogFormKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const components().text("Pill Name", FontWeight.w600, Colors.black, 17),
                TextFormField(
                  keyboardType: TextInputType.text,
                  controller: pillName,
                  validator: (value) {
                    if(value == null || value.isEmpty ){
                      return "";
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15),borderSide: const BorderSide(color: Color(
                        0x52003879))),
                    enabled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    hintText: "Enter Pill Name",
                    hintStyle: const TextStyle(color: Color(0xff959595)),
                  ),
                ),
                const SizedBox(height: 15,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.3,
                      child:  Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const components().text("Quantity", FontWeight.w600, Colors.black, 17),
                          TextFormField(
                            keyboardType: TextInputType.number,
                            controller: quantity,
                            validator: (value) {
                              if(value == null || value.isEmpty ){
                                return "";
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15),borderSide: const BorderSide(color: Color(
                                    0x52003879))),
                                enabled: true,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                hintText: "Enter Quantity",
                                hintStyle: const TextStyle(color: Color(0xff959595))
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.3,
                      child:  Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const components().text("How Long", FontWeight.w600, Colors.black, 17),
                          TextFormField(
                            keyboardType: TextInputType.number,
                            controller: duration,
                            validator: (value) {
                              if(value == null || value.isEmpty ){
                                return "";
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15),borderSide: const BorderSide(color: Color(
                                    0x52003879))),
                                enabled: true,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                hintText: "Enter Days",
                                hintStyle: const TextStyle(color: Color(0xff959595))
                            ),
                          ),
                        ],
                      ),
                    )

                  ],
                ),
                const SizedBox(height: 15,),
                const components().text("When to take", FontWeight.w600, Colors.black, 17),
                Container(
                  padding: EdgeInsets.only(bottom: 5),
                  decoration: UnderlineTabIndicator(
                      borderSide: BorderSide(color: foodInvalid ? Colors.red : Colors.transparent )
                  ),
                  child: Wrap(
                    children: [
                      InkWell(
                        child:  AnimatedContainer(
                          width: MediaQuery.of(context).size.width * 0.33,
                          height: MediaQuery.of(context).size.height * 0.07,
                          decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              borderRadius: BorderRadius.circular(10),
                              color: before ? colors().logo_darkBlue : Colors.white
                          ),
                          duration: Duration(milliseconds: 400),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.fastfood_outlined, color: before ? Colors.white : colors().logo_darkBlue),
                              SizedBox(height: 5,),
                              Text("Before Food", style: TextStyle(color: before ? Colors.white : colors().logo_darkBlue)),
                            ],
                          ),
                        ),
                        onTap: () {
                          setState(() {
                            before = !before;
                          });
                          print(before);
                        },
                      ),
                      SizedBox(width: 10,),
                      InkWell(
                        child:  AnimatedContainer(
                          width: MediaQuery.of(context).size.width * 0.33,
                          height: MediaQuery.of(context).size.height * 0.07,
                          decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              borderRadius: BorderRadius.circular(10),
                              color: after ? colors().logo_darkBlue : Colors.white
                          ),
                          duration: Duration(milliseconds: 400),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.fastfood_outlined, color: after ? Colors.white : colors().logo_darkBlue),
                              SizedBox(height: 5,),
                              Text("After Food", style: TextStyle(color: after ? Colors.white : colors().logo_darkBlue)),
                            ],
                          ),
                        ),
                        onTap: () {
                          setState(() {
                            after = !after;
                          });
                          print(before);
                        },
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 20),
                  padding: EdgeInsets.only(bottom: 5),
                  decoration: UnderlineTabIndicator(
                      borderSide: BorderSide(color: dayInvalid ? Colors.red : Colors.transparent )
                  ),
                  child: Wrap(
                    children: [
                      InkWell(
                        child:  AnimatedContainer(
                          padding: EdgeInsets.symmetric(vertical: 5),
                          decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.grey),
                              color: morning ? colors().logo_darkBlue : Colors.white
                          ),
                          duration: Duration(milliseconds: 400),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.sunny, color: morning ? Colors.white : colors().logo_darkBlue),
                              SizedBox(height: 5,),
                              Text("Morning", style: TextStyle(color: morning ? Colors.white : colors().logo_darkBlue)),
                            ],
                          ),
                        ),
                        onTap: () {
                          setState(() {
                            morning = !morning;
                          });
                          print(before);
                        },
                      ),
                      SizedBox(width: 5,),
                      InkWell(
                        child:  AnimatedContainer(
                          padding: EdgeInsets.symmetric(vertical: 5),
                          margin: EdgeInsets.symmetric(vertical: 5),
                          decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.grey),
                              color: afternoon ? colors().logo_darkBlue : Colors.white
                          ),
                          duration: Duration(milliseconds: 400),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.wb_twighlight, color: afternoon ? Colors.white : colors().logo_darkBlue),
                              SizedBox(height: 5,),
                              Text("Afternoon", style: TextStyle(color: afternoon ? Colors.white : colors().logo_darkBlue)),
                            ],
                          ),
                        ),
                        onTap: () {
                          setState(() {
                            afternoon = !afternoon;
                          });
                          print(before);
                        },
                      ),
                      SizedBox(width: 5,),
                      InkWell(
                        child:  AnimatedContainer(
                          padding: EdgeInsets.symmetric(vertical: 5),
                          decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(10),
                              color: evening ? colors().logo_darkBlue : Colors.white
                          ),
                          duration: Duration(milliseconds: 400),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.nights_stay, color: evening ? Colors.white : colors().logo_darkBlue),
                              SizedBox(height: 5,),
                              Text("Evening", style: TextStyle(color: evening ? Colors.white : colors().logo_darkBlue)),
                            ],
                          ),
                        ),
                        onTap: () {
                          setState(() {
                            evening = !evening;
                          });
                          print(before);
                        },
                      ),
                    ],
                  ),
                ),

              ],
            ),
          ),
        )

    );
  }

  Widget buildHistory(history h){
    return Container(
      width: double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: UnderlineTabIndicator(borderSide: BorderSide(color: colors().logo_darkBlue), insets: const EdgeInsets.only(left: 0, right: -10)),
            child:  Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Icon(Icons.access_time_outlined, color: colors().logo_darkBlue, size: 15),
                const SizedBox(width: 5,),
                const components().text(h.date.toString(), FontWeight.w500, colors().logo_darkBlue, 17),
                const SizedBox(width: 10,),
                const components().text(h.time.toString(), FontWeight.w500, colors().logo_darkBlue, 17)
              ],
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10,),
                  const components().text("Symptoms", FontWeight.normal, Color(0xff7E7878), 16),
                  const components().text(h.symptoms.toString(), FontWeight.w600, Colors.black, 16),
                  const SizedBox(height: 10,),
                  const components().text("Diagnosis", FontWeight.normal, Color(0xff7E7878), 16),
                  const components().text(h.diagnosis.toString(), FontWeight.w600, Colors.black, 16),
                  const SizedBox(height: 10,),
                  const components().text("Medicines", FontWeight.normal, Color(0xff7E7878), 16),
                  ...h.medicines!.map((e) {
                    return Container(
                      padding: EdgeInsets.all(10),
                      margin: EdgeInsets.only(bottom: 5),
                      decoration: BoxDecoration(
                        // color: Colors.white,
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          components().text(e.name.toString(), FontWeight.w600, colors().logo_darkBlue, 18),

                          SizedBox(height: 5,),
                          Row(
                            children: [
                              components().text("Quantity: "+e.quantity.toString(), FontWeight.normal, colors().logo_darkBlue, 16),
                              SizedBox(width: 30,),
                              components().text("Days: "+e.duration.toString(), FontWeight.normal, colors().logo_darkBlue, 16),
                            ],
                          ),
                          SizedBox(height: 5,),
                          Wrap(
                            children: [
                              components().text(e.food.join(" "), FontWeight.w500, colors().logo_darkBlue, 16),
                              SizedBox(width: 30,),
                              components().text(e.daytime.join(" "), FontWeight.w500, colors().logo_darkBlue, 16),
                            ],
                          )
                        ],
                      ),
                    );
                  },)
                  // const components().text(h.medicines.toString(), FontWeight.w600, Colors.black, 16),
                  // const SizedBox(height: 10,),
                  // const components().text("When to take", FontWeight.normal, Color(0xff7E7878), 16),
                  // const components().text("After lunch", FontWeight.w600, Colors.black, 16)
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10,),
                  const components().text("Test", FontWeight.normal, Color(0xff7E7878), 16),
                  const components().text(h.test.toString(), FontWeight.w600, Colors.black, 16),

                ],
              )
            ],
          ),
        ],
      ),
    );
  }


}
