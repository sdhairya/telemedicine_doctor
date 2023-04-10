import 'dart:core';

import 'dataClass.dart';

class profile{

  String id = "";
  String name = "";
  String email = "";
  String gender = "";
  String password = "";
  String dob = "";
  String? image = "";
  String phone = "";
  stats? stat = stats(totalPatients: 0, pendingAppointments: 0, todayPatients: 0);
  appointment? app = appointment(id: "", image: "image", name: "name", date: "date", time: "time", mode: "mode", address: "address", fees: 0, link: "link", gender: '');
  doctor docData = doctor(speciality: "speciality", hospital: 0, degree: [], otherAchievements: [], description: "description", tags: "tags", experience: 0, fees: 0);

  profile(
      {required this.id, required this.name, required this.email, required this.gender, required this.password,required this.dob, required this.image, required this.phone, required this.docData, required this.app, required this.stat});

  @override
  String toString() {
    return "$name\n$email\n$gender\n$password\n$image\n$dob\n$phone\n$id\n$docData\n$stat\n$app";
  }

}

class stats{

  int totalPatients = 0;
  int pendingAppointments = 0;
  int todayPatients = 0;

  stats({
    required this.totalPatients, required this.pendingAppointments, required this.todayPatients
  });

  @override
  String toString() {
    return "$totalPatients\n$pendingAppointments\n$todayPatients";
  }
}

class docs{

  String name = "";
  String docPath = "";

  docs({
    required this.name, required this.docPath
});

  @override
  String toString() {
    return "$name\n$docPath";
  }
}



class doctor{

  String speciality = "";
  int hospital = 0;
  List<docs> degree = [];
  List<docs> otherAchievements = [];
  String description = "";
  String tags = "";
  int experience = 0;
  int fees = 0;

  doctor({
    required this.speciality, required this.hospital, required this.degree, required this.otherAchievements, required this.description, required this.tags, required this.experience, required this.fees
  });

  @override
  String toString() {
    return "$speciality\n$hospital\n$degree\n$otherAchievements\n$description\n$tags\n$experience\n$fees";
  }
}

class hospital{

  int id = 0;
  String name = "";
  String address = "";
  String phone = "";

  hospital({
    required this.id, required this.name, required this.address, required this.phone
});

  @override
  String toString() {
    return "$id\n$name\n$address\n$phone";
  }
}

class schedule{

  String facilities_id = "";
  String day = "";
  String status = "";
  String morning = "";
  String afternoon = "";
  String  evening = "";
  String mode = "";

  schedule({
    required this.day, required this.facilities_id, required this.status, required this.morning, required this.afternoon, required this.evening, required this.mode
  });

  @override
  String toString() {
    return "$day\n$facilities_id\n$status\n$morning\n$afternoon\n$evening\n$mode";
  }
}

class time {

  String dayTime = "";
  List<timings> times = [];

  time({
    required this.dayTime, required this.times
});

  @override
  String toString() {
    return "$dayTime\n$times";
  }
}

class timings {

  String start_time= "";
  String end_time = "";
  String duration = "";

  timings({
    required this.start_time, required this.end_time, required this.duration
});

  @override
  String toString() {
    return "$start_time\n$end_time\n$duration";
  }


}

class dayTime {
  currentSchedule morning = currentSchedule(id: 0,slots: [], facility: hospital(id: 0, name: "name", address: "address", phone: "phone"), mode: "mode");
  currentSchedule afternoon = currentSchedule(id: 0,slots: [], facility: hospital(id: 0, name: "name", address: "address", phone: "phone"), mode: "mode");
  currentSchedule evening = currentSchedule(id: 0,slots: [], facility: hospital(id: 0, name: "name", address: "address", phone: "phone"), mode: "mode");

  dayTime({
   required this.morning, required this.afternoon, required this.evening
});

  @override
  String toString() {
    return "$morning\n$afternoon\n$evening";
  }
}

class currentSchedule{

  int id = 0;
  List<String> slots = [];
  hospital facility = hospital(id: 0, name: "name", address: "address", phone: "phone");
  String mode = "";

  currentSchedule({
    required this.id, required this.slots, required this.facility, required this.mode
  });

  @override
  String toString() {
    return "$id\n$slots\n$facility\n$mode";
  }
}

class update_Schedule{

  String daytime = "";
  String slots = "";
  int facilities_id = 0;
  String mode = "";
  String status = "";

  update_Schedule({
   required this.daytime, required this.slots, required this.facilities_id, required this.mode, required this.status
});

  @override
  String toString() {
    return "$daytime\n$mode\n$slots\n$facilities_id\n$status";
  }
}

class appointment{

  String? id = "";
  String? image = "";
  String? name = "";
  String? date = "";
  String? gender = "";
  String? time = "";
  String? mode = "";
  String? address = "";
  int? fees = 0;
  String? link = "";

  appointment({
    required this.id, required this.image, required this.name, required this.date,required this.gender, required this.time, required this.mode, required this.address, required this.fees, required this.link
  });

  @override
  String toString() {
    return "$id\n$name\n$date\n$time\n$mode";
  }
}

class medicine{

  String? name = "";
  int? quantity = 0;
  int? duration = 0;
  List<String?> food = [];
  List<String?> daytime = [];

  medicine(
      {required this.name, required this.quantity, required this.duration, required this.food, required this.daytime});

  @override
  String toString() {
    return "$name\n$quantity\n$duration\n$food\n$daytime";
  }

  Map toJson() {
    return {'name': name, 'quantity': quantity, 'duration': duration, 'food': food, 'daytime': daytime};
  }

}

class prescription{

  String symptoms = "";
  String diagnosis = "";
  String test = "";
  List<medicine> medicines = [];

  prescription({
    required this.symptoms, required this.diagnosis, required this.test, required this.medicines
  });

  @override
  String toString() {
    return "$symptoms\n$diagnosis\n$test\n$medicines";
  }

}
