import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:telemedicine_doctor/videoCall/videoCallScreen.dart';

typedef void StreamStateCallback(MediaStream stream);

class Signaling {
  Map<String, dynamic> configuration = {
    'iceServers': [
      {
        'urls': [
          'stun:stun1.l.google.com:19302',
          'stun:stun2.l.google.com:19302'
        ]
      }
    ]
  };

  RTCPeerConnection? peerConnection;
  RTCDataChannelInit? dataChannelInit;
  RTCDataChannel? channel;
  MediaStream? localStream;
  MediaStream? remoteStream;
  String? roomId;
  String? currentRoomText;
  StreamStateCallback? onAddRemoteStream;

  Future<String> createRoom(String hostName, String hostEmail, String callType) async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    DocumentReference roomRef = db.collection('rooms').doc();

    print('Create PeerConnection with configuration: $configuration');

    peerConnection = await createPeerConnection(configuration);
    // //
    registerPeerConnectionListeners();

    localStream?.getTracks().forEach((track) {
      peerConnection?.addTrack(track, localStream!);
    });

    // Code for collecting ICE candidates below
    // var callerCandidatesCollection = roomRef.collection('callerCandidates');
    //
    // peerConnection?.onIceCandidate = (RTCIceCandidate candidate) {
    //   print('Got candidate: ${candidate.toMap()}');
    //   callerCandidatesCollection.add(candidate.toMap());
    // };
    // Finish Code for collecting ICE candidate

    // Add code for creating a room
    RTCSessionDescription offer = await peerConnection!.createOffer();
    await peerConnection!.setLocalDescription(offer);
    print('Created offer: $offer');
    // //
    Map<String, dynamic> roomWithOffer = {'offer': offer.toMap()};
    // //
    await roomRef.set(roomWithOffer);
    Map<String, dynamic> roomHost = {
      'Host': {'Name': hostName, 'email': hostEmail, 'status': "Not Joined"},
      'Mode': callType
    };

    await roomRef.update(roomHost);
    var roomId = roomRef.id;
    // print('New room created with SDK offer. Room ID: $roomId');
    // currentRoomText = 'Current room is $roomId - You are the caller!';
    // Created a Room

    // peerConnection?.onTrack = (RTCTrackEvent event) {
    //   print('Got remote track: ${event.streams[0]}');
    //
    //   event.streams[0].getTracks().forEach((track) {
    //     print('Add a track to the remoteStream $track');
    //     remoteStream?.addTrack(track);
    //   });
    // };

    // Listening for remote session description below
    // roomRef.snapshots().listen((snapshot) async {
    //   print('Got updated room: ${snapshot.data()}');
    //
    //   Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    //   if (peerConnection?.getRemoteDescription() != null &&
    //       data['answer'] != null) {
    //     var answer = RTCSessionDescription(
    //       data['answer']['sdp'],
    //       data['answer']['type'],
    //     );
    //
    //     print("Someone tried to connect");
    //     await peerConnection?.setRemoteDescription(answer);
    //   }
    // });
    // Listening for remote session description above

    // Listen for remote Ice candidates below
    // roomRef.collection('calleeCandidates').snapshots().listen((snapshot) {
    //   snapshot.docChanges.forEach((change) {
    //     if (change.type == DocumentChangeType.added) {
    //       Map<String, dynamic> data = change.doc.data() as Map<String, dynamic>;
    //       print('Got new remote ICE candidate: ${jsonEncode(data)}');
    //       peerConnection!.addCandidate(
    //         RTCIceCandidate(
    //           data['candidate'],
    //           data['sdpMid'],
    //           data['sdpMLineIndex'],
    //         ),
    //       );
    //     }
    //   });
    // });
    // Listen for remote ICE candidates above

    return roomId;
  }

  Future<String> getCallMode(String roomId) async{
    FirebaseFirestore db = FirebaseFirestore.instance;
    DocumentReference roomRef = db.collection('rooms').doc('$roomId');
    var roomSnapshot = await roomRef.get();
    Map<String, dynamic> host = roomSnapshot.data() as Map<String, dynamic>;
    print(host["Mode"]);

    return host["Mode"];
  }

  Future<String> getHostDetails(String roomId) async{
    FirebaseFirestore db = FirebaseFirestore.instance;
    DocumentReference roomRef = db.collection('rooms').doc('$roomId');
    var roomSnapshot = await roomRef.get();
    Map<String, dynamic> host = roomSnapshot.data() as Map<String, dynamic>;
    print(host["Host"]["email"]);

    return host["Host"]["email"];
  }
  Future<String> getHostStatus(String roomId) async{
    FirebaseFirestore db = FirebaseFirestore.instance;
    DocumentReference roomRef = db.collection('rooms').doc('$roomId');
    var roomSnapshot = await roomRef.get();
    Map<String, dynamic> host = roomSnapshot.data() as Map<String, dynamic>;
    print(host["Host"]["status"]);

    return host["Host"]["status"];
  }

  Future<String> joinCaller(String roomId, RTCVideoRenderer remoteVideo, String callType) async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    DocumentReference roomRef = db.collection('rooms').doc('$roomId');
    var roomSnapshot = await roomRef.get();
    Map<String, dynamic> host = roomSnapshot.data() as Map<String, dynamic>;
    print(host["Host"]["Name"]);
    print('Got room ${roomSnapshot.exists}');

    if (roomSnapshot.exists) {
      print('Create PeerConnection with configuration: $configuration');
      peerConnection = await createPeerConnection(configuration);

      registerPeerConnectionListeners();
     var c = peerConnection?.createDataChannel("label", RTCDataChannelInit());


      localStream?.getTracks().forEach((track) {
        peerConnection?.addTrack(track, localStream!);
      });

      // Code for collecting ICE candidates below
      var callerCandidatesCollection = roomRef.collection('callerCandidates');

      peerConnection?.onIceCandidate = (RTCIceCandidate candidate) {
        print('Got candidate: ${candidate.toMap()}');
        callerCandidatesCollection.add(candidate.toMap());
      };

      RTCSessionDescription offer = await peerConnection!.createOffer();
      await peerConnection!.setLocalDescription(offer);
      print('Created offer: $offer');
      // //
      Map<String, dynamic> roomWithOffer = {'offer': offer.toMap()};
      // //
      await roomRef.set(roomWithOffer);
      Map<String, dynamic> roomHost = {
        'Host': {'Name': host["Host"]["Name"], 'email': host["Host"]["email"], 'status': "Joined"},
        'Mode': callType
      };

      await roomRef.update(roomHost);

      // Code for collecting ICE candidate above

      peerConnection?.onTrack = (RTCTrackEvent event) {
        print('Got remote track: ${event.streams[0]}');

        event.streams[0].getTracks().forEach((track) {
          print('Add a track to the remoteStream $track');
          remoteStream?.addTrack(track);
        });
      };

      roomRef.snapshots().listen((snapshot) async {
        print('Got updated room: ${snapshot.data()}');

        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
        if (peerConnection?.getRemoteDescription() != null &&
            data['answer'] != null) {
          var answer = RTCSessionDescription(
            data['answer']['sdp'],
            data['answer']['type'],
          );

          print("Someone tried to connect");
          await peerConnection?.setRemoteDescription(answer);
        }
      });

      // Code for creating SDP answer below
      roomRef.collection('calleeCandidates').snapshots().listen((snapshot) {
        snapshot.docChanges.forEach((change) {
          if (change.type == DocumentChangeType.added) {
            Map<String, dynamic> data = change.doc.data() as Map<String, dynamic>;
            print('Got new remote ICE candidate: ${jsonEncode(data)}');
            peerConnection!.addCandidate(
              RTCIceCandidate(
                data['candidate'],
                data['sdpMid'],
                data['sdpMLineIndex'],
              ),
            );
          }
        });
      });
      // Finished creating SDP answer

      // Listening for remote ICE candidates below
    }

    return "Success";
  }

  Future<void> fetchRooms() async{

    var collection = FirebaseFirestore.instance.collection('rooms');
    var querySnapshot = await collection.get();
    List<QueryDocumentSnapshot> data = querySnapshot.docs;
    List<Map> items = data.map((e) =>
    {
      'id': e.id,
    }).toList();

    print(items);
  }

  Future<String> joinRoom(String roomId, RTCVideoRenderer remoteVideo) async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    DocumentReference roomRef = db.collection('rooms').doc('$roomId');
    var roomSnapshot = await roomRef.get();
    print('Got room ${roomSnapshot.exists}');

    if (roomSnapshot.exists) {
      print('Create PeerConnection with configuration: $configuration');
      peerConnection = await createPeerConnection(configuration);

      registerPeerConnectionListeners();

      localStream?.getTracks().forEach((track) {
        peerConnection?.addTrack(track, localStream!);
      });

      // Code for collecting ICE candidates below
      var calleeCandidatesCollection = roomRef.collection('calleeCandidates');
      peerConnection!.onIceCandidate = (RTCIceCandidate candidate) {
        if (candidate == null) {
          print('onIceCandidate: complete!');
          return;
        }
        print('onIceCandidate: ${candidate.toMap()}');
        calleeCandidatesCollection.add(candidate.toMap());
      };
      // Code for collecting ICE candidate above

      peerConnection?.onTrack = (RTCTrackEvent event) {
        print('Got remote track: ${event.streams[0]}');
        event.streams[0].getTracks().forEach((track) {
          print('Add a track to the remoteStream: $track');
          remoteStream?.addTrack(track);
        });
      };

      // Code for creating SDP answer below
      var data = roomSnapshot.data() as Map<String, dynamic>;
      print('Got offer $data');
      var offer = data['offer'];
      await peerConnection?.setRemoteDescription(
        RTCSessionDescription(offer['sdp'], offer['type']),
      );
      var answer = await peerConnection!.createAnswer();
      print('Created Answer $answer');

      await peerConnection!.setLocalDescription(answer);

      Map<String, dynamic> roomWithAnswer = {
        'answer': {'type': answer.type, 'sdp': answer.sdp}
      };

      await roomRef.update(roomWithAnswer);
      // Finished creating SDP answer

      // Listening for remote ICE candidates below
      roomRef.collection('callerCandidates').snapshots().listen((snapshot) {
        snapshot.docChanges.forEach((document) {
          var data = document.doc.data() as Map<String, dynamic>;
          print(data);
          print('Got new remote ICE candidate: $data');
          peerConnection!.addCandidate(
            RTCIceCandidate(
              data['candidate'],
              data['sdpMid'],
              data['sdpMLineIndex'],
            ),
          );
        });
      });
    }
    return "Success";
  }

  Future<void> stopVideoOnly() async {
    localStream?.getTracks().forEach((track) {
    if (track.kind == 'video') {
    track.enabled = false;
    }
    });
  }

  Future<void> startVideoOnly() async {
    localStream?.getTracks().forEach((track) {
      if (track.kind == 'video') {
        track.enabled = true;
      }
    });
  }

  Future<void> stopAudioOnly() async {
    localStream?.getTracks().forEach((track) {
      if (track.kind == 'audio') {
        track.enabled = false;
      }
    });
  }

  Future<void> startAudioOnly() async {
    localStream?.getTracks().forEach((track) {
      if (track.kind == 'audio') {
        track.enabled = true;
      }
    });
  }

  Future<void> speakerPhone() async {
    localStream?.getTracks().forEach((track) {
      if (track.kind == 'audio') {
        track.enableSpeakerphone(true);
      }
    });
  }

  Future<void> stopSpeakerPhone() async {
    localStream?.getTracks().forEach((track) {
      if (track.kind == 'audio') {
        track.enableSpeakerphone(false);
      }
    });
  }

  Future<void> openUserMedia(
    RTCVideoRenderer localVideo,
    RTCVideoRenderer remoteVideo,
      bool video,
      bool audio
  ) async {
    var stream = await navigator.mediaDevices
      .getUserMedia({'video': video, 'audio': audio});
    if(video == false && audio == true){
      stream.getAudioTracks().forEach((track) {
        track.enableSpeakerphone(false);
      });
    }
    localVideo.srcObject = stream;
    localStream = stream;

    remoteVideo.srcObject = await createLocalMediaStream('key');
    // return Future.value("Success");
  }

  Future<void> hangUp(RTCVideoRenderer localVideo) async {
    List<MediaStreamTrack> tracks = localVideo.srcObject!.getTracks();
    tracks.forEach((track) {
      track.stop();
    });

    if (remoteStream != null) {
      remoteStream!.getTracks().forEach((track) => track.stop());
    }
    if (peerConnection != null) peerConnection!.close();

    if (roomId != null) {
      var db = FirebaseFirestore.instance;
      var roomRef = db.collection('rooms').doc(roomId);
      var calleeCandidates = await roomRef.collection('calleeCandidates').get();
      calleeCandidates.docs.forEach((document) => document.reference.delete());

      var callerCandidates = await roomRef.collection('callerCandidates').get();
      callerCandidates.docs.forEach((document) => document.reference.delete());

      await roomRef.delete();
    }

    localStream!.dispose();
    remoteStream?.dispose();
  }

  void registerPeerConnectionListeners() {
    peerConnection?.onIceGatheringState = (RTCIceGatheringState state) {
      print('ICE gathering state changed: $state');
    };

    peerConnection?.onConnectionState = (RTCPeerConnectionState state) {
      print('Connection state change: $state');
    };

    peerConnection?.onSignalingState = (RTCSignalingState state) {
      print('Signaling state change: $state');
    };

    peerConnection?.onIceGatheringState = (RTCIceGatheringState state) {
      print('ICE connection state change: $state');
    };

    peerConnection?.onAddStream = (MediaStream stream) {
      print("Add remote stream");
      onAddRemoteStream?.call(stream);
      remoteStream = stream;
    };
  }
}
