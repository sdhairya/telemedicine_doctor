import 'package:flutter/material.dart';

import '../api.dart';
import 'body.dart';

class dashboardScreen extends StatefulWidget {
  final String id;
  const dashboardScreen({Key? key, required this.id}) : super(key: key);

  @override
  State<dashboardScreen> createState() => _dashboardScreenState();
}

class _dashboardScreenState extends State<dashboardScreen> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: api().profiledetails(widget.id),
      builder: (context, snapshot) {
        print(snapshot.data);
        if(snapshot.hasData){
          return body(data: snapshot.data!,id: widget.id);
        }
        else{
          return Scaffold(
            body: Container(
              height: double.infinity,
              width: double.infinity,
              alignment: Alignment.center,
              child: CircularProgressIndicator(backgroundColor: Colors.black,),
            ),
          );
        }
      },
    );
    // return body(id: widget.id,);
  }
}
