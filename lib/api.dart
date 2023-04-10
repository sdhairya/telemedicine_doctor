import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:telemedicine_doctor/dataClass/dataClass.dart';

import 'dataClass/dataClass.dart';

class api {
  String uri = 'http://192.168.1.9:5024/';

  Future<List<String>> login(String phone, String password) async {
    String url = uri + "api/users/login";
    var res = await http.post(Uri.parse(url),
        body: json.encode({"phone": phone, "password": password}),
        headers: {
          "Accept": "application/json",
          "content-type": "application/json"
        },
        encoding: Encoding.getByName('utf-8'));
    print(res.statusCode);

    var ack = json.decode(res.body);
    var a = ack.toString().split(",");
    print(a);
    if (int.parse(a[1].toString()) is int) {

      SharedPreferences.getInstance().then(
            (prefs) {
          prefs.setString('doctor_id', a[1].toString());
        },
      );

      return a;
    } else if (a[0] == "First time") {
      return a;
    } else {
      return a;
    }

    // if (ack == "Valid") {
    //   return "Valid";
    // } else if (ack == "First time") {
    //   return "First time";
    // } else {
    //   return "Invalid";
    // }
  }

  Future<List<profile>> profiledetails(String id) async {
    String url = uri + "api/doctors/byid?id=" + id;
    var res = await http.get(Uri.parse(url));
    var responseData = json.decode(res.body);

    print(responseData[0]);
    List<profile> profileData = [];

    for(var i in responseData){

      appointment? a;

      if(i["user"]["id"] == null){
        a = null;
      }
      else{
        a = appointment(id: i["user"]["getappointment"]["id"].toString(), image: i["user"]["getappointment"]["image"], name: i["user"]["getappointment"]["name"], date: i["user"]["getappointment"]["date"], gender: i["user"]["getappointment"]["gender"], time: i["user"]["getappointment"]["time"], mode: i["user"]["getappointment"]["mode"], address: i["user"]["getappointment"]["address"], fees: int.parse(i["user"]["getappointment"]["fees"].toString()), link: i["user"]["getappointment"]["link"]);

    }

      profileData.add(profile(

          id: id,
          name: i["user"]["name"].toString(),
          email: i["user"]["email"].toString(),
          gender: i["user"]["gender"].toString(),
          password: i["user"]["password"].toString(),
          dob: " ",
          image: i["user"]["image"].toString(),
          phone: " ",
          stat: stats(totalPatients: int.parse(i["stats"]["totalpatients"].toString()), pendingAppointments: int.parse(i["stats"]["pendingappointments"].toString()), todayPatients: int.parse(i["stats"]["todaypatients"].toString())),
          app: a,
    docData: doctor(speciality: i["speciality"].toString(), hospital: int.parse(i["facility_id"].toString()), degree: [docs(name: i["degree"].toString(), docPath: i["document"])], otherAchievements: [docs(name: i["otherachivement"], docPath: i["otherachivementdoc"])], description: i["description"], tags: i["tags"], experience: int.parse(i["experience"].toString()), fees: int.parse(i["fees"].toString()))
      ));
    }
    
    print(profileData);
    return profileData;
  }

  Future<List<String>> getTags() async {
    var url = "api/doctors/tags";
    var res = await http.get(Uri.parse(uri + url));
    var data = json.decode(res.body);
    List<String> d = [];
    for (var i = 0; i < data.length; i++) {
      data[i]["tags"].contains(",")
          ? d.addAll(data[i]["tags"].split(","))
          : d.add(data[i]["tags"]);
    }
    return d;
  }

  Future<List<hospital>> getHospital() async {
    var url = "api/facilities/name";
    var res = await http.get(Uri.parse(uri + url));
    var data = json.decode(res.body);
    print(data);
    List<hospital> hospitals = [];
    for (var i = 0; i < data.length; i++) {
      hospitals.add(hospital(
          id: int.parse(data[i]["id"].toString()),
          name: data[i]["name"],
          address: data[i]["address"],
          phone: data[i]["phone"]));
    }
    print(hospitals);
    return hospitals;
  }

  Future<List<String>> getDoctors(String tag) async {
    var url = "api/doctors/name?tag=" + tag;
    var res = await http.get(Uri.parse(uri + url));
    var data = json.decode(res.body);
    print(data);
    List<String> d = [];
    // for(var i = 0; i<data.length; i++){
    //   data[i]["tags"].contains(",") ? d.addAll(data[i]["tags"].split(",")) : d.add(data[i]["tags"]);
    // }
    return d;
  }

  Future<String> updateProfile(profile data, String id, ) async {
    print(data);
    var url = "api/doctors?id=" + id;
    var request = http.MultipartRequest('PUT', Uri.parse(uri + url));

    request.fields.addAll({
      "user.name": data.name,
      "user.email": data.email,
      "user.gender": data.gender,
      "user.password": data.password,
      "speciality" : data.docData.speciality,
      "facility_id" : data.docData.hospital.toString(),
      "description" : data.docData.description,
      "experience" :  data.docData.experience.toString(),
      "tags" :  data.docData.tags,
      "fees":  data.docData.fees.toString()
    });
    if (data.image != null) {
      print("=============================="+data.image.toString());
      request.files
          .add(await http.MultipartFile.fromPath('user.image', data.image!));
    }

    if(data.docData.degree.isNotEmpty){
      for (var i = 0; i < data.docData.degree.length; i++) {
        request.fields.addAll({
          "degree":  data.docData.degree[i].name,
        });
        request.files.add(await http.MultipartFile.fromPath(
            'document',  data.docData.degree[i].docPath));
      }
    }
    if(data.docData.otherAchievements.isNotEmpty){
      for (var i = 0; i <  data.docData.otherAchievements.length; i++) {
        request.fields.addAll({
          "otherachivement":  data.docData.otherAchievements[i].name,
        });
        request.files.add(await http.MultipartFile.fromPath(
            'otherachivementdoc',  data.docData.otherAchievements[i].docPath));
      }
    }



    // print(request.statusCode);
    // print(request.body);
    var req = await request.send();
    print(req.statusCode);
    return "Success";
  }

  Future<String> createProfile(profile data, doctor doctorData) async {
    print(data);
    print(doctorData);
    var url = "api/doctors/basic?id=" + data.id;
    var request = http.MultipartRequest('PUT', Uri.parse(uri + url));

    request.fields.addAll({
      "email": data.email,
      "gender": data.gender,
      "dob": data.dob,
    });
    if (data.image != null) {
      request.files
          .add(await http.MultipartFile.fromPath('image', data.image!));
    }

    var response = await request.send();

    print(response.statusCode);
    // print(response.body);

    var urlDoc = "api/doctors?phone=" + data.phone;
    var reqDoc = http.MultipartRequest("POST", Uri.parse(uri + urlDoc));

    reqDoc.fields.addAll({
      "speciality": doctorData.speciality,
      "facility_id": doctorData.hospital.toString(),
      "description": doctorData.description,
      "experience": doctorData.experience.toString(),
      "tags": doctorData.tags,
      "fees": doctorData.fees.toString()
    });

    for (var i = 0; i < doctorData.degree.length; i++) {
      reqDoc.fields.addAll({
        "degree": doctorData.degree[i].name,
      });
      reqDoc.files.add(await http.MultipartFile.fromPath(
          'document', doctorData.degree[i].docPath));
    }
    for (var i = 0; i < doctorData.otherAchievements.length; i++) {
      reqDoc.fields.addAll({
        "otherachivement": doctorData.otherAchievements[i].name,
      });
      reqDoc.files.add(await http.MultipartFile.fromPath(
          'otherachivementdoc', doctorData.otherAchievements[i].docPath));
    }

    var resDoc = await reqDoc.send();
    print(resDoc.statusCode);

    return "Success";
  }

  Future<String> update_schedule(String id, update_Schedule schedule) async {
    var url = "api/scheduler?id=" + id;
    var request = await http.put(Uri.parse(uri + url),
        body: json.encode({
          "facilities_id":schedule.facilities_id.toString(),
          "status":schedule.status,
          "mode":schedule.mode,
          "daytime": schedule.daytime,
          "slots":schedule.slots
        }),
        headers: {
          "Accept": "application/json",
          "content-type": "application/json"
        },
        encoding: Encoding.getByName('utf-8')
    );
    print(request.body);
    // print(response.body);
    return "Success";
  }

  Future<String> insertSchedule(schedule s, String id) async {
    var url = "api/scheduler?id=" + id;
    var request = await http.post(Uri.parse(uri + url),
        body: json.encode({
          "day": s.day.toString(),
          "facilities_id": int.parse(s.facilities_id),
          "status": s.status.toString(),
          "morning": s.morning.toString(),
          "afternoon": s.afternoon.toString(),
          "evening": s.evening.toString(),
          "mode": s.mode.toString()
        }),
        headers: {
          "Accept": "application/json",
          "content-type": "application/json"
        },
        encoding: Encoding.getByName('utf-8'));
    print(request.statusCode);
    print(request.body);

    return " ";
  }

  Future<List<String>> getDaysAck(String id) async {
    var url = "api/scheduler/days?id=" + id;
    var res = await http.get(Uri.parse(uri + url));
    var data = json.decode(res.body);
    print(data);
    List<String> d = [];
    for (var i = 0; i < data.length; i++) {
      d.add(data[i]["day"]);
    }
    print(d);
    return d;
  }

  Future<List<dayTime>> getDaysData(String id, String day) async {
    var url = "api/scheduler/drslots?id=" + id + "&day=" + day;
    var res = await http.get(Uri.parse(uri + url));
    var data = json.decode(res.body);
    print(data);
    List<dayTime> schedule = [];
    for (var i in data) {
      schedule.add(dayTime(
          morning: currentSchedule(
            id: int.parse(i["morning"]["id"].toString()),
              slots: i["morning"]["slots"].toString().split(","),
              facility: hospital(
                  id: int.parse(i["morning"]["facility"]["id"].toString()),
                  name: i["morning"]["facility"]["name"],
                  address: i["morning"]["facility"]["address"],
                  phone: i["morning"]["facility"]["phone"]),
              mode: i["morning"]["mode"]),
          afternoon: currentSchedule(
              id: int.parse(i["afternoon"]["id"].toString()),
              slots: i["afternoon"]["slots"].toString().split(","),
              facility: hospital(
                  id: int.parse(i["afternoon"]["facility"]["id"].toString()),
                  name: i["afternoon"]["facility"]["name"],
                  address: i["afternoon"]["facility"]["address"],
                  phone: i["afternoon"]["facility"]["phone"]),
              mode: i["afternoon"]["mode"]),
          evening: currentSchedule(
              id: int.parse(i["evening"]["id"].toString()),
              slots: i["evening"]["slots"].toString().split(","),
              facility: hospital(
                  id: int.parse(i["evening"]["facility"]["id"].toString()),
                  name: i["evening"]["facility"]["name"],
                  address: i["evening"]["facility"]["address"],
                  phone: i["evening"]["facility"]["phone"]),
              mode: i["evening"]["mode"])));
    }
    print(schedule);
    return schedule;
  }

  Future<List<appointment>> getAppointments(String id) async {
    var url = "api/doctors/getappointment?id=" + id;
    var res = await http.get(Uri.parse(uri + url));
    var data = json.decode(res.body);
    print(data);
    List<appointment> appointments = [];
    for (var i in data) {
      appointments.add(
        appointment(id: i["id"].toString(),image: i["image"], name: i["name"],gender: i["gender"], date: i["date"].toString(), time: i["time"].toString(), mode: i["mode"], address: i["address"], fees: int.parse(i["fees"].toString()), link: i["link"])
      );
    }
    print(appointments);
    return appointments;
  }

  Future<List<appointment>> getApprovedAppointments(String id) async {
    var url = "api/doctors/getapprove?id=" + id;
    var res = await http.get(Uri.parse(uri + url));
    var data = json.decode(res.body);
    print(data);
    List<appointment> appointments = [];
    for (var i in data) {
      appointments.add(
          appointment(id: i["id"].toString(),image: i["image"], name: i["name"], gender: i["gender"], date: i["date"].toString(), time: i["time"].toString(), mode: i["mode"], address: i["address"], fees: int.parse(i["fees"].toString()), link: i["link"])
      );
    }
    print(appointments);
    return appointments;
  }

  Future<int> manageAppointments(String AppId, String drId, String status) async {
    var url = "api/doctors/approve?apid=" + AppId+"&drid="+drId;
    var request = await http.put(Uri.parse(uri + url),
        body: json.encode({
          "status":status,
        }),
        headers: {
          "Accept": "application/json",
          "content-type": "application/json"
        },
        encoding: Encoding.getByName('utf-8')
    );

    return request.statusCode;

  }

  Future<int> joinAppointment(int id) async {
    var url = "api/prescription?id="+id.toString();
    var request = await http.post(Uri.parse(uri + url),
        body: json.encode({
          "appointment_id": id,
        }),
        headers: {
          "Accept": "application/json",
          "content-type": "application/json"
        },
        encoding: Encoding.getByName('utf-8'));
    print(request.statusCode);
    print(request.body);

    return request.statusCode;
  }

  Future<String> prescribe(String id, String columnName, String data) async {
    var url = "api/prescription?id=" + id;
    var request = await http.put(Uri.parse(uri + url),
        body: json.encode({
          "columnName" : columnName,
          "data":data,
        }),
        headers: {
          "Accept": "application/json",
          "content-type": "application/json"
        },
        encoding: Encoding.getByName('utf-8')
    );
    print(request.body);
    // print(response.body);
    return "Success";
  }

}
