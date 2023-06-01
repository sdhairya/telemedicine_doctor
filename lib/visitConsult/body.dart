import 'dart:convert';

import 'package:flutter/material.dart';

import '../api.dart';
import '../colors.dart';
import '../components.dart';
import '../dataClass/dataClass.dart';

class body extends StatefulWidget {

  final appointment appointmentData;
  final profile doctorProfile;

  const body({Key? key,required this.appointmentData, required this.doctorProfile}) : super(key: key);

  @override
  State<body> createState() => _bodyState();
}

class _bodyState extends State<body> with TickerProviderStateMixin {

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
  late TabController _tabController = TabController(length: 4, vsync: this);
  final _dialogFormKey = GlobalKey<FormState>();


  @override
  void initState() {
    super.initState();
    join();
  }

  Future<String> join() async {

      await api().doctorAck(widget.appointmentData.id.toString());
      setState(() {});

    return "Success";
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(MediaQuery.of(context).size.height * 0.1),
          child: Container(
            margin: EdgeInsets.only(top: 20, left: 10, bottom: 10),
            child: ListTile(
              leading: ElevatedButton(
                child: Icon(Icons.arrow_back_ios_new, size: 30, color: Color(0xff383434)),
                style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xfff6f6f4),
                    shape: CircleBorder(),
                    padding: EdgeInsets.only(top: 10, bottom: 10,left: 5, right: 5)
                ),
                onPressed: () {

                  Navigator.of(context).pop();

                },
              ),
              title: components().text(widget.appointmentData.name!, FontWeight.bold, Colors.black, 25),
            ),
          ),
        ),
        body: Column(
          children: [
            Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
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
                )
            )
          ],
        ),
          bottomNavigationBar: Container(
            margin: EdgeInsets.symmetric(horizontal: 10),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: colors().logo_darkBlue,
                padding: EdgeInsets.all(10),
                shape: StadiumBorder()
              ),
              child: components().text("Submit", FontWeight.w500, Colors.white, 25),
              onPressed: () {

              },
            ),
          )
      ),
    );
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
                  child: Row(
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
                  child: Row(
                    children: [
                      InkWell(
                        child:  AnimatedContainer(
                          width: MediaQuery.of(context).size.width * 0.22,
                          height: MediaQuery.of(context).size.height * 0.05,
                          decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              borderRadius: BorderRadius.circular(10),
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
                          width: MediaQuery.of(context).size.width * 0.22,
                          height: MediaQuery.of(context).size.height * 0.05,
                          decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              borderRadius: BorderRadius.circular(10),
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
                          width: MediaQuery.of(context).size.width * 0.22,
                          height: MediaQuery.of(context).size.height * 0.05,
                          decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
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
