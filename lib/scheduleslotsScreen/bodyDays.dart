import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:telemedicine_doctor/colors.dart';
import 'package:telemedicine_doctor/components.dart';
import 'package:telemedicine_doctor/dashboardScreen/dashboardScreen.dart';
import 'package:telemedicine_doctor/scheduleslotsScreen/body.dart';

import '../api.dart';
import '../dataClass/dataClass.dart';

class bodyDays extends StatefulWidget {

  final List<hospital> hospitals;
  final String id;
  final int hospitalId;
  const bodyDays({Key? key, required this.hospitals, required this.id, required this.hospitalId}) : super(key: key);

  @override
  State<bodyDays> createState() => _bodyDaysState();
}

class _bodyDaysState extends State<bodyDays> {

  List<String> days = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"];

  @override
  Widget build(BuildContext context) {

    return FutureBuilder(
      future: api().getDaysAck(widget.id),
      builder: (context, snapshot) {
        print(snapshot.data);
        if(snapshot.hasData){
          return SafeArea(
            child: Scaffold(
                appBar: PreferredSize(
                  preferredSize: Size.fromHeight(MediaQuery.of(context).size.height * 0.1),
                  child: Container(
                    margin: EdgeInsets.only(top: 20, left: 10),
                    child: ListTile(
                      leading: components().backButton(context),
                      title: components().text("    Schedule Timings", FontWeight.bold, Colors.black, 25),
                    ),
                  ),
                ),
                body: ListView.builder(
                  itemCount: days.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      child: Container(
                        margin: EdgeInsets.only(left: 15, right: 15, top: 5, bottom: 5),
                        padding: EdgeInsets.all(15),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 3, blurStyle: BlurStyle.outer)]
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Wrap(
                                  children: [
                                    Icon(Icons.calendar_month_outlined, color: colors().logo_lightBlue, size: 23),
                                    SizedBox(width: 5,),
                                    components().text(days[index], FontWeight.w500, colors().logo_darkBlue, 20),
                                    SizedBox(width: 5,),
                                    snapshot.data!.contains(days[index]) ? Icon(Icons.check_circle, color: Colors.green,) : Container(),

                                  ],
                            ),
                            Icon(CupertinoIcons.forward)
                          ],
                        ),
                      ),
                      onTap: () async {
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => body(hospitals: widget.hospitals,day: days[index], id: widget.id, hospitalId: widget.hospitalId),));
                      },
                    );
                  },
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
                  child: components().text("Submit", FontWeight.bold, Colors.white, 22),
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => dashboardScreen(id:  widget.id),));
                  }
                ),
              ),
            ),
          );
        }
        return Scaffold(
          body: Container(
            height: double.infinity,
            width: double.infinity,
            alignment: Alignment.center,
            child: CircularProgressIndicator(backgroundColor: Colors.black,),
          ),
        );

      },
    );


  }

}
