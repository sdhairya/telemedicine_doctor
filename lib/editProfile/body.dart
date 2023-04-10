import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:telemedicine_doctor/api.dart';
import 'package:telemedicine_doctor/colors.dart';
// import 'package:telemedicine_doctor/doctorsScreen/doctorsScreen.dart';
import 'package:telemedicine_doctor/editProfile/editProfile.dart';

import '../components.dart';
import '../dataClass/dataClass.dart';

class body extends StatefulWidget {
  final List<profile> data;
  final String id;
  final List<hospital> hospitals;

  const body({Key? key, required this.data, required this.id, required this.hospitals})
      : super(key: key);

  @override
  State<body> createState() => _bodyState();
}

class _bodyState extends State<body> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _degreeController = TextEditingController();
  TextEditingController _specialityController = TextEditingController();
  TextEditingController _otherController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _tagsController = TextEditingController();
  TextEditingController _experienceController = TextEditingController();
  TextEditingController _feesController = TextEditingController();

  List<profile> updatedData = [];
  File? _pickedimage;
  Uint8List webImage = Uint8List(8);
  var f;
  var imgPath;
  String? path;
  // String? path;
  String? filePath;
  String assetURL = "http://192.168.1.170:5024/";

  List<docs> degree = [];
  List<docs> otherAchievement = [];
  List<docs> updatedDegree = [];
  List<docs> updatedOtherAchievement = [];
  int hostiptaId = 0;
  String dropdownvalue = 'Choose Hospital';

  bool _genderInvalid = false;
  bool emailInvalid = false;
  bool specialityInvalid = false;
  bool degreeInvalid = false;
  bool descriptionInvalid = false;
  bool tagsInvalid = false;
  bool experienceInvalid = false;
  bool feesInvalid = false;
  bool isLoading = false;
  bool _isobscure = false;
  String? gender;

  void _toggle() {
    setState(() {
      _isobscure = !_isobscure;
    });
  }

  @override
  void initState() {
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: Colors.white,
          body: FutureBuilder(
            future: api().profiledetails(""),
            builder: (context, snapshot) {
              return SingleChildScrollView(
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
                          ])),
                    ),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.only(top: 25),
                      child: Column(
                        children: [
                          ListTile(
                            horizontalTitleGap: 80,
                            leading: components().backButton(context),
                            title: components().text(
                                "Account", FontWeight.w500, Colors.white, 26),
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
                                child: _pickedimage == null
                                    ? path!.isEmpty
                                        ? InkWell(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Icon(Icons.camera_alt,
                                                    size: 50,
                                                    color: Colors.white),
                                                Text(
                                                  "Choose Image",
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 16),
                                                )
                                              ],
                                            ),
                                            onTap: () {
                                              _getFromGallery();
                                            },
                                          )
                                        : ClipOval(
                                            child: Image.network(
                                              api().uri + path!,
                                            fit: BoxFit.fill,
                                            height: double.maxFinite,
                                            width: double.maxFinite,
                                          ))
                                    : ClipOval(
                                        child: Image.memory(
                                        width: double.maxFinite,
                                        height: double.maxFinite,
                                        webImage,
                                        fit: BoxFit.fill,
                                      ))),
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
                          Container(
                            width: MediaQuery.of(context).size.width,
                            margin: EdgeInsets.only(
                                left: MediaQuery.of(context).size.width * 0.06,
                                right:
                                    MediaQuery.of(context).size.width * 0.06),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                components().text("\t\tName", FontWeight.w500,
                                    Colors.black, 18),
                                components().textField("Enter Name",
                                    TextInputType.text, _nameController),
                                SizedBox(
                                  height: 15,
                                ),
                                components().text("\t\tEmail", FontWeight.w500,
                                    Colors.black, 18),
                                components().textField("Enter email",
                                    TextInputType.text, _emailController),
                                SizedBox(
                                  height: 15,
                                ),
                                components().text("\t\tGender", FontWeight.w500,
                                    Colors.black, 18),
                                Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.06,
                                  width: double.maxFinite,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      color: Color(0xfff6f4f4),
                                      border:
                                          Border.all(color: Color(0xffd7d7d7)),
                                      borderRadius: BorderRadius.circular(10)),
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
                                SizedBox(
                                  height: 15,
                                ),
                                components().text("\t\tPassword",
                                    FontWeight.w500, Colors.black, 18),
                                TextFormField(
                                  obscureText: _isobscure,
                                  controller: _passwordController,
                                  decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(15)),
                                      hintText: 'Enter Password',
                                      suffixIcon: IconButton(
                                        icon: Icon(
                                          _isobscure
                                              ? Icons.visibility
                                              : Icons.visibility_off,
                                        ),
                                        onPressed: _toggle,
                                      )),
                                  keyboardType: TextInputType.visiblePassword,
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
                                      hint: Text(dropdownvalue),
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
                                        setState(() {
                                          dropdownvalue = value!;
                                        });
                                      }),
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
                                  height: MediaQuery.of(context).size.height * 0.01,
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
                                      onPressed: () {
                                      print(imgPath);
                                        api().updateProfile(
                                            profile(name: _nameController.text, email: _emailController.text, gender: gender.toString(), password: _passwordController.text, image: imgPath, id: widget.id, phone: "", dob:  "",
                                                stat: null,
                                                app: null,
                                                docData: doctor(speciality: _specialityController.text, hospital: widget.hospitals.elementAt(widget.hospitals.indexWhere((element) => element.name == dropdownvalue)).id, degree: updatedDegree, otherAchievements: updatedOtherAchievement, description: _descriptionController.text, tags: _tagsController.text, experience: int.parse(_experienceController.text), fees: int.parse(_feesController.text))), widget.id );
                                      },
                                      child: components().text("Update",
                                          FontWeight.bold, Colors.white, 20)),
                                )

                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              );
            },
          )),
    );
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

  _loadData() {
    _nameController.text = widget.data[0].name;
    _emailController.text = widget.data[0].email;
    setState(() {
      gender = widget.data[0].gender;
    });
    _passwordController.text = widget.data[0].password;
    path = widget.data[0].image;
    _specialityController.text = widget.data[0].docData.speciality;
    dropdownvalue = widget.hospitals.elementAt(widget.hospitals.indexWhere((element) => element.id == widget.data[0].docData.hospital)).name;
    _tagsController.text = widget.data[0].docData.tags;
    degree = widget.data[0].docData.degree;
    otherAchievement = widget.data[0].docData.otherAchievements;
    _descriptionController.text = widget.data[0].docData.description;
    _experienceController.text = widget.data[0].docData.experience.toString();
    _feesController.text = widget.data[0].docData.fees.toString();

    // print(assetURL + path!);
  }

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

                  degree.add(docs(name: _degreeController.text, docPath: filePath.toString()));
                  updatedDegree.add(docs(name: _degreeController.text, docPath: filePath.toString()));

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

                  otherAchievement.add(docs(name: _otherController.text, docPath: filePath.toString()));
                  updatedOtherAchievement.add(docs(name: _otherController.text, docPath: filePath.toString()));

                });
                // print(item);
                Navigator.pop(context);
              },
              child: Text("Submit"))
        ],
      ));

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

}
