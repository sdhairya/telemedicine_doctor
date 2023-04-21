import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:telemedicine_doctor/api.dart';
import 'package:http/http.dart' as http;
import 'package:telemedicine_doctor/createProfile/createProfile.dart';

import '../components.dart';
import '../dashboardScreen/dashboardScreen.dart';
import '../scheduleslotsScreen/scheduleslots.dart';

class body extends StatefulWidget {
  const body({Key? key}) : super(key: key);

  @override
  State<body> createState() => _bodyState();
}

class _bodyState extends State<body> {
  bool _isobscure = true;
  bool _phone = false;
  bool _password = false;
  bool _ischecked = false;
  bool _isLoading = false;

  TextEditingController _phoneController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  void _toggle() {
    setState(() {
      _isobscure = !_isobscure;
    });
  }


  @override
  void initState() {
    _loadUserEmailPassword();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/images/background.png",),fit: BoxFit.fill,
                  alignment: Alignment.bottomCenter)),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: SingleChildScrollView(

              child: Column(
                children: [
                  Column(
                    children: [
                      Container(
                        width: double.maxFinite,
                        color: Colors.transparent,
                        child: Column(
                          children: [
                            Image(
                                image: AssetImage("assets/images/logo.png"),
                                width: MediaQuery.of(context).size.width * 0.6),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.85,
                              padding: EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  border: Border.all(color: Colors.black12),
                                  color: Colors.white),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Align(
                                    alignment: Alignment.center,
                                    child: components().text("Login",
                                        FontWeight.bold, Color(0xff114c81), 35),
                                  ),
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.01,
                                  ),
                                  components().text("   Phone", FontWeight.w700,
                                      Color(0xff292929), 16),
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.01,
                                  ),
                                  components().textField("Enter Your Phone",
                                      TextInputType.phone, _phoneController),
                                  _phone
                                      ? components().text(
                                      " Enter valid Phone Number",
                                      FontWeight.normal,
                                      Colors.red,
                                      15)
                                      : Container(),
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.03,
                                  ),
                                  components().text("   Password",
                                      FontWeight.w700, Color(0xff292929), 16),
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.01,
                                  ),
                                  TextFormField(
                                    obscureText: _isobscure,
                                    controller: _passwordController,
                                    decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                            borderRadius:
                                            BorderRadius.circular(15)),
                                        hintText: 'Enter Password',
                                        suffixIcon: IconButton(
                                          icon: Icon(_isobscure
                                              ? Icons.visibility
                                              : Icons.visibility_off, ),
                                          onPressed: _toggle,
                                        )),
                                    keyboardType: TextInputType.visiblePassword,
                                  ),
                                  _password
                                      ? components().text(" Password not valid",
                                      FontWeight.normal, Colors.red, 15)
                                      : Container(),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: TextButton(
                                      child: components().text(
                                          "Forgot Password?",
                                          FontWeight.w500,
                                          Color(0xff504d4d),
                                          16),
                                      onPressed: () async {
                                        print(_phoneController.text);
                                        print(_passwordController.text);

                                        var res = await api().profiledetails(_phoneController.text);
                                        print(res);
                                      },
                                    ),
                                  ),
                                  CheckboxListTile(
                                    controlAffinity: ListTileControlAffinity.leading,
                                    dense: true,
                                    enableFeedback: true,
                                    checkboxShape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(2)
                                    ),
                                    title: const Text("Remember Me",
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          color: Color(0xff646464),
                                          fontSize: 16,
                                        )),
                                    value: _ischecked,
                                    onChanged: (value) {
                                      _handleRememeberme(value!);
                                    },
                                  ),
                                  Align(
                                    alignment: Alignment.center,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: Color(0xff1f5c92),
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                              BorderRadius.circular(15)),
                                          padding: EdgeInsets.fromLTRB(
                                              55, 10, 55, 10)),
                                      child: _isLoading ? CircularProgressIndicator(color: Colors.white,) : components().text("Login",
                                          FontWeight.bold, Colors.white, 22),
                                      onPressed: () async {
                                        setState(() {
                                          _phone = false;
                                          _password = false;
                                          _isLoading = true;
                                        });
                                        await validateUser();
                                      },
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.05,
                  ),
                ],
              ),
            ),
          ))
    );
  }

  Future<void> _handleRememeberme(bool value) async {
    _ischecked = value;
    SharedPreferences.getInstance().then(
          (prefs) {
        prefs.setBool("remember_me", value);
        prefs.setString('phone', _phoneController.text);
        prefs.setString('password', _passwordController.text);
      },
    );
    setState(() {
      _ischecked = value;
    });
  }

  _loadUserEmailPassword() async {
    try {
      SharedPreferences _prefs = await SharedPreferences.getInstance();
      var _phone = _prefs.getString("phone") ?? "";
      var _password = _prefs.getString("password") ?? "";
      var _rememberMe = _prefs.getBool("remember_me") ?? false;


      if (_rememberMe) {
        setState(() {
          _ischecked = true;
        });

        // if(_phone.isNotEmpty && _password.isNotEmpty){
        //   authUser(_phone, _password);
        // }

        _phoneController.text = _phone;
        _passwordController.text = _password;
      }
    } catch (e) {
      print(e);
    }
  }

  Future<bool> validateUser() async {

    bool phoneInvalid = false;
    bool passwordInvalid = false;
    _phoneController.text.isEmpty ? phoneInvalid = true : _phoneController.text.length < 10 ? phoneInvalid = true : phoneInvalid = false;
    _passwordController.text.isEmpty ? passwordInvalid = true : _passwordController.text.length < 1 ? passwordInvalid = true : passwordInvalid = false;

    if(phoneInvalid){
      setState(() {
        _phone = true;
      });
    }
    if(passwordInvalid){
      setState(() {
        _password = true;
      });
    }
    if(_phone && _password){
      return false;
    }
    else{
     if(await authUser(_phoneController.text, _passwordController.text)){
       return true;
     }
     else{

       setState(() {
         _phone = true;
         _password = true;
       });

       return false;
     }
    }

  }

  Future<bool> authUser(String phone, String password) async {

    var res = await api().login(phone, password);
    print(res);
    var id;

    if(res[0] == "First time"){
      SharedPreferences.getInstance().then(
            (prefs) {
          id = prefs.getString('doctor_id');
        },
      );
      print(res[1]);
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => createProfile(id: res[1],),));
      return true;
    }
    if(res[0] == "Invalid"){


      return false;
    }
    else{
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => dashboardScreen(id: res[1]),));

      return true;
    }

  }

}
