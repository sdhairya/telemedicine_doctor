import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:telemedicine_doctor/addHospital/addHospital.dart';
import 'package:telemedicine_doctor/api.dart';
import 'package:telemedicine_doctor/createProfile/createProfile.dart';
import 'package:telemedicine_doctor/scheduleslotsScreen/scheduleslots.dart';

import '../colors.dart';
import '../components.dart';
import '../dataClass/dataClass.dart';

class body extends StatefulWidget {

  final List<hospital> hospitals;
  final String id;
  const body({Key? key, required this.hospitals, required this.id}) : super(key: key);

  @override
  State<body> createState() => _bodyState();
}

class _bodyState extends State<body> {

  File? _pickedimage;
  Uint8List webImage = Uint8List(8);
  DateTime dateTime = DateTime.now();

  List<docs> degree = [];
  List<docs> otherAchievement = [];
  int hostiptaId = 0;
  List<hospital> hospitals = [];

  var f;
  var imgPath;
  String? path;
  String? filePath;
  String? gender;
  String dropdownvalue = 'Choose Hospital';
  TextEditingController _emailController = TextEditingController();
  TextEditingController _degreeController = TextEditingController();
  TextEditingController _specialityController = TextEditingController();
  TextEditingController _otherController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _tagsController = TextEditingController();
  TextEditingController _experienceController = TextEditingController();
  TextEditingController _feesController = TextEditingController();

  bool emailInvalid = false;
  bool _genderInvalid = false;
  bool specialityInvalid = false;
  bool degreeInvalid = false;
  bool descriptionInvalid = false;
  bool tagsInvalid = false;
  bool experienceInvalid = false;
  bool feesInvalid = false;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: RefreshIndicator(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(left: 20, right: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.04,
                  ),
                  ListTile(
                    leading: components().backButton(context),
                    title: components().text("Create Profile", FontWeight.w500, Color(0xff101010), 26),
                  ),
                  Center(
                    child: Container(
                      alignment: Alignment.bottomCenter,
                      height: MediaQuery.of(context).size.width * 0.35,
                      width: MediaQuery.of(context).size.width * 0.35,
                      margin: EdgeInsets.only(top: 10),
                      decoration: BoxDecoration(
                          border:
                          Border.all(color: colors().logo_darkBlue),
                          shape: BoxShape.circle,
                          color: Colors.white70),
                      child: CircleAvatar(
                          backgroundColor: Color(0xfff6f6f4),
                          radius:
                          MediaQuery.of(context).size.width * 0.175,
                          child: _pickedimage == null
                              ? InkWell(
                            child: Column(
                              mainAxisAlignment:
                              MainAxisAlignment.center,
                              children: [
                                Icon(Icons.camera_alt,
                                    size: 50,
                                    color: Colors.grey),
                                Text(
                                  "Choose Image",
                                  style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 16),
                                )
                              ],
                            ),
                            onTap: () {
                              _getFromGallery();
                            },
                          )
                              : ClipOval(
                              child: Image.memory(
                                width: double.maxFinite,
                                height: double.maxFinite,
                                webImage,
                                fit: BoxFit.fill,
                              ))),
                    ),
                  ),
                  Visibility(
                      child: Container(
                        alignment: Alignment.center,
                        child: TextButton(
                            child: Row(
                              mainAxisAlignment:
                              MainAxisAlignment.center,
                              children: const [
                                Icon(Icons.edit),
                                Text("Edit"),
                              ],
                            ),
                            onPressed: () => _getFromGallery()),
                      ),
                      visible: true),
                  Divider(
                    height: 10,
                    color: Colors.black,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  components().text("   Email", FontWeight.w500, Colors.black, 18),
                  components().textField("Enter email", TextInputType.text, _emailController),
                  emailInvalid ? components().text(" Enter valid Email", FontWeight.normal, Colors.red, 15) : Container(),
                  SizedBox(
                    height: 15,
                  ),
                  components().text("   Gender", FontWeight.w500, Colors.black, 18),
                  Container(
                    height:
                    MediaQuery.of(context).size.height * 0.07,
                    width: double.maxFinite,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: Color(0xfff6f4f4),
                        border:
                        Border.all(color: Color(0xffd7d7d7)),
                        borderRadius: BorderRadius.circular(15)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Radio(
                          value: "male",
                          groupValue: gender,
                          onChanged: (value) {
                            setState(() {
                              gender = "male";
                              _genderInvalid = false;
                            });
                          },
                        ),
                        components().text("Male", FontWeight.w500,
                            Color(0xff292929), 16),
                        Radio(
                          value: "female",
                          groupValue: gender,
                          onChanged: (value) {
                            setState(() {
                              gender = "female";
                              _genderInvalid = false;
                            });
                          },
                        ),
                        components().text(
                            "Female",
                            FontWeight.w500,
                            Color(0xff292929),
                            16),
                        Radio(
                          value: "other",
                          groupValue: gender,
                          onChanged: (value) {
                            setState(() {
                              gender = "other";
                              _genderInvalid = false;
                            });
                          },
                        ),
                        components().text(
                            "Other",
                            FontWeight.w500,
                            Color(0xff292929),
                            16),
                      ],
                    ),
                  ),
                  _genderInvalid ? components().text(" Please Select Gender", FontWeight.normal, Colors.red, 15) : Container(),
                  SizedBox(
                    height: 15,
                  ),
                  components().text("   Date of Birth", FontWeight.w500, Colors.black, 18),
                  InkWell(
                    onTap: () => showCupertinoModalPopup(
                      context: context,
                      builder: (context) => CupertinoActionSheet(
                        actions: [
                          buildDatePicker(),
                        ],
                        cancelButton: CupertinoActionSheetAction(
                          child: Text('Done'),
                          onPressed: () {
                            final value = dateTime;
                            print(value);
                            setState(() {
                              dateTime = value;
                              Navigator.of(context).pop();
                            });


                          },
                        ),
                      ),
                    ),
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.06,
                      width: double.maxFinite,
                      padding: EdgeInsets.only(left: 15),
                      decoration: BoxDecoration(
                          color: Color(0xfff6f4f4),
                          border: Border.all(color: Color(0xffd7d7d7)),
                          borderRadius: BorderRadius.circular(10)
                      ),
                      child: Row(
                        children: [
                          components().text(dateTime.toString().substring(0,10), FontWeight.normal, Colors.black, 18),
                          Icon(Icons.keyboard_arrow_down_rounded, color: Colors.grey,)
                        ],
                      ),
                    ),
                  ),


                  SizedBox(
                    height: 15,
                  ),
                  components().text("   Degree", FontWeight.w500, Colors.black, 18),
                  degree.isEmpty ? Container() : ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: degree.length,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: EdgeInsets.all(2),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(5)
                        ),
                        child: Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            Icon(Icons.file_present_rounded, color: colors().logo_darkBlue, size: 30),
                            SizedBox(width: 10,),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                components().text(degree[index].name, FontWeight.w500, Colors.black, 16),
                                components().text(degree[index].docPath.split("/").last, FontWeight.w500, Colors.grey, 14),
                              ],
                            )
                          ],
                        ),
                      );
                    },
                  ),
                  degreeInvalid ? components().text(" Enter valid Degree", FontWeight.normal, Colors.red, 15) : Container(),
                  Container(
                    width: double.maxFinite,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        border:
                        Border.all(color: Color(0xffd7d7d7)),
                        borderRadius: BorderRadius.circular(15)),
                    child: InkWell(
                      child: ListTile(
                        leading: Icon(Icons.add,color: colors().logo_darkBlue),
                        title: components().text("Add Degree Qualification", FontWeight.w500, colors().logo_darkBlue, 16),
                      ),
                      onTap: () {
                        addDegreeDialog();
                      },
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  components().text("   Speciality", FontWeight.w500, Colors.black, 18),
                  components().textField("Ex. Heart Surgeon", TextInputType.text, _specialityController),
                  specialityInvalid ? components().text(" Speciality Cannot be empty", FontWeight.normal, Colors.red, 15) : Container(),
                  SizedBox(
                    height: 15,
                  ),
                  components().text("   Choose Hospital", FontWeight.w500, Colors.black, 18),
                  Container(
                      height:
                      MediaQuery.of(context).size.height * 0.07,
                      width: double.maxFinite,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          border:
                          Border.all(color: Color(0xffd7d7d7)),
                          borderRadius: BorderRadius.circular(15)),
                      child: DropdownButtonFormField<String>(
                          decoration: InputDecoration(
                              border: InputBorder.none
                          ),
                          onTap: ()  {
                            print("|||||||||||||||||||||||||");
                          },

                          items: widget.hospitals.map<DropdownMenuItem<String>>((value) {
                            return DropdownMenuItem(
                              child: components().text("  "+value.name, FontWeight.normal, Colors.black, 16),
                              value: value.name,
                              onTap: () {
                                hostiptaId = value.id;
                              },
                            );
                          }).toList(),
                          onChanged: (String? value) {
                            if(value == "+ Other Hospital"){
                              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => addHospital(id: widget.id),));
                            }
                            setState(() {
                              dropdownvalue = value!;
                            });
                          })

                  ),
                  SizedBox(
                    height: 15,
                  ),
                  components().text("   Other Achievements", FontWeight.w500,Colors.black, 18),
                  otherAchievement.isEmpty ? Container() : ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: otherAchievement.length,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: EdgeInsets.all(2),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(5)
                        ),
                        child: Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            Icon(Icons.file_present_rounded, color: colors().logo_darkBlue, size: 30),
                            SizedBox(width: 10,),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                components().text(otherAchievement[index].name, FontWeight.w500, Colors.black, 16),
                                components().text(otherAchievement[index].docPath.split("/").last, FontWeight.w500, Colors.grey, 14),
                              ],
                            )
                          ],
                        ),
                      );
                    },
                  ),
                  Container(
                    height:
                    MediaQuery.of(context).size.height * 0.07,
                    width: double.maxFinite,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        border:
                        Border.all(color: Color(0xffd7d7d7)),
                        borderRadius: BorderRadius.circular(15)),
                    child: InkWell(
                      child: ListTile(
                        leading: Icon(Icons.add,color: colors().logo_darkBlue),
                        title: components().text("Add Other achievements", FontWeight.w500, colors().logo_darkBlue, 16),
                      ),
                      onTap: () {
                        addOtherAchievementDialog();
                      },
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  components().text("   Tags", FontWeight.w500, Colors.black, 18),
                  components().textField("Ex. fever, headache, handache", TextInputType.text, _tagsController),
                  tagsInvalid ? components().text(" Speciality Cannot be empty", FontWeight.normal, Colors.red, 15) : Container(),
                  SizedBox(
                    height: 15,
                  ),
                  components().text("   Description", FontWeight.w500, Colors.black, 18),
                  components().textField("Write about yourself", TextInputType.text, _descriptionController),
                  descriptionInvalid ? components().text(" Description cannot be empty", FontWeight.normal, Colors.red, 15) : Container(),
                  SizedBox(
                    height: 15,
                  ),
                  components().text("   Experience", FontWeight.w500, Colors.black, 18),
                  components().textField("Enter experience", TextInputType.number, _experienceController),
                  experienceInvalid ? components().text(" Experience cannot be empty", FontWeight.normal, Colors.red, 15) : Container(),
                  SizedBox(
                    height: 15,
                  ),
                  components().text("   Fees", FontWeight.w500, Colors.black, 18),
                  components().textField("Enter Fees", TextInputType.number, _feesController),
                  feesInvalid ? components().text(" Fees cannot be empty", FontWeight.normal, Colors.red, 15) : Container(),
                  SizedBox(
                    height: 10,
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: colors().logo_darkBlue,
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                BorderRadius.circular(15)),
                            padding: EdgeInsets.fromLTRB(
                                55, 10, 55, 10)
                        ),
                        onPressed: () async {
                          _validate();
                          setState(() {
                            isLoading = true;
                          });
                          print(widget.id);
                          await api().createProfile(profile(id: widget.id ,name: "name", email: _emailController.text, gender: gender.toString(), password: "password", dob: dateTime.toString().substring(0,10), image: imgPath, phone: "",
                              docData: doctor(speciality: "speciality", hospital: 0, degree: [], otherAchievements: [], description: "description", tags: "tags", experience: 0, fees: 0),
                              app: null,
                              stat: null
                          ),
                            doctor(speciality: _specialityController.text, hospital: hostiptaId, degree: degree, otherAchievements: otherAchievement, description: _descriptionController.text, tags: _tagsController.text, experience: int.parse(_experienceController.text),fees: int.parse(_feesController.text)),
                          );
                          setState(() {
                            isLoading = false;
                          });
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => scheduleslots(id:  widget.id, hospitalId: hostiptaId),));
                        },
                        child: isLoading ? CircularProgressIndicator(color: Colors.white,) : components().text("Next",
                            FontWeight.bold, Colors.white, 20)),
                  ),
                ],
              ),
            ),
          ),
          onRefresh: () {
            return Future(() => Navigator.of(context).push(MaterialPageRoute(builder: (context) => createProfile(id: widget.id),))
            );
          },
        )

      ),
    );
  }

  _validate() {

    if(_emailController.text.isEmpty){
      setState(() {
        emailInvalid = true;
      });
    }
    if(gender != "female"){
      setState(() {
        _genderInvalid = true;
      });
    }
    if(gender != "male"){
      setState(() {
        _genderInvalid = true;
      });
    }
    if(gender != "other"){
      setState(() {
        _genderInvalid = true;
      });
    }
    if(degree.isEmpty){
      setState(() {
        degreeInvalid = true;
      });
    }
    if(_specialityController.text.isEmpty){
      setState(() {
        specialityInvalid = true;
      });
    }
    if(_descriptionController.text.isEmpty){
      setState(() {
        descriptionInvalid = true;
      });
    }


  }

  _getDocuments() async{

    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      File file = File(result.files.single.path!);
      setState(() {
        filePath = file.path;
      });
      print(file.path);
    } else {
      // User canceled the picker
    }

  }

  _getFromGallery() async {
    final ImagePicker _picker = ImagePicker();
    XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() async {
        f = await image.readAsBytes();
        webImage = f;
        _pickedimage = File("a");
        imgPath = image.path;
        // imgPath = File(image!.path);
      });
      print(webImage);
    }

    //imgPath = image!.path;
    print("print $imgPath");
  }

  Widget buildDatePicker() => SizedBox(
    height: 180,
    child: CupertinoDatePicker(
      minimumYear: 2015,
      maximumYear: DateTime.now().year,
      initialDateTime: dateTime,
      mode: CupertinoDatePickerMode.date,
      onDateTimeChanged: (dateTime) =>
          setState(() => this.dateTime = dateTime),
    ),
  );

  Future addDegreeDialog() => showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: components()
            .text("Add Degree", FontWeight.bold, Colors.black, 18),
        content: Container(
          // height: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              components().textField("Ex. MBBS",
                  TextInputType.text, _degreeController),
              SizedBox(
                height: 15,
              ),
              components().text("   Choose Degree Certificate", FontWeight.w500,
                  Colors.black, 18),
              Container(
                height:
                MediaQuery.of(context).size.height * 0.07,
                width: double.maxFinite,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    border:
                    Border.all(color: Color(0xffd7d7d7)),
                    borderRadius: BorderRadius.circular(15)),
                child: InkWell(
                  child: ListTile(
                    leading: Icon(Icons.file_upload_rounded,color: colors().logo_darkBlue),
                    title: components().text("Choose File", FontWeight.w500, colors().logo_darkBlue, 16),
                  ),
                  onTap: () {
                    _getDocuments();
                  },
                ),
              ),
            ],
          ),
        ),
        actions: [
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Color(0xFF1D2A3A),
                padding: EdgeInsets.all(3),
                textStyle: TextStyle(fontSize: 18),
                minimumSize: Size.fromHeight(40),
                shape: StadiumBorder(),
                enableFeedback: true,
              ),
              onPressed: () {
                setState(() {
                  degree.clear();
                  degree.add(docs(name: _degreeController.text, docPath: filePath.toString()));

                });
                // print(item);
                Navigator.pop(context);
              },
              child: Text("Submit"))
        ],
      ));

  Future addOtherAchievementDialog() => showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: components()
            .text("Add Degree", FontWeight.bold, Colors.black, 18),
        content: Container(
          // height: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              components().textField("Ex. Gold Medalist",
                  TextInputType.text, _otherController),
              SizedBox(
                height: 15,
              ),
              components().text("   Choose Other Achievement document", FontWeight.w500,
                  Colors.black, 18),
              Container(
                height:
                MediaQuery.of(context).size.height * 0.07,
                width: double.maxFinite,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    border:
                    Border.all(color: Color(0xffd7d7d7)),
                    borderRadius: BorderRadius.circular(15)),
                child: InkWell(
                  child: ListTile(
                    leading: Icon(Icons.file_upload_rounded,color: colors().logo_darkBlue),
                    title: components().text("Choose File", FontWeight.w500, colors().logo_darkBlue, 16),
                  ),
                  onTap: () {
                    _getDocuments();
                  },
                ),
              ),
            ],
          ),
        ),
        actions: [
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Color(0xFF1D2A3A),
                padding: EdgeInsets.all(3),
                textStyle: TextStyle(fontSize: 18),
                minimumSize: Size.fromHeight(40),
                shape: StadiumBorder(),
                enableFeedback: true,
              ),
              onPressed: () {
                setState(() {
                  otherAchievement.clear();
                  otherAchievement.add(docs(name: _otherController.text, docPath: filePath.toString()));

                });
                // print(item);
                Navigator.pop(context);
              },
              child: Text("Submit"))
        ],
      ));

}
