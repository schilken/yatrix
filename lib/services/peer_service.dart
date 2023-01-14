import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:peerdart/peerdart.dart';

class PeerService {
  Peer? peer;
  late DataConnection conn;
  late StreamController<String> _streamController;
  bool connected = false;

  Stream<String> startServer(String id) {
    peer = Peer(
      id: id,
    ); // options: PeerOptions(debug: LogLevel.All));
    if (peer == null) {
      throw Exception('creation failed');
    }
    _streamController = StreamController<String>();
    peer!.on<DataConnection>("connection").listen((event) {
      conn = event;
//      print('server got an connection: $event');
      _streamController.add('connection opened');

      conn.on<dynamic>("data").listen((dynamic data) {
//        print('server received data: $data');
        _streamController.add(data.toString());
      });

      conn.on<dynamic>("close").listen((dynamic _) {
//        print('server received close');
        _streamController.add('connection closed');
        connected = false;
      });
      connected = true;
    });
    return _streamController.stream;
  }

  void connectToServer(String id) {
    peer = Peer();
    if (peer == null) {
      throw Exception('creation failed');
    }
    conn = peer!.connect(id);

    conn.on<String>("open").listen((name) {
      print('open: $name');
      conn.send("hi!");
    });

    conn.on<String>("data").listen((data) {
      print('client received data: $data');
    });
  }
}

final peerServiceProvider = Provider<PeerService>(
  (ref) => PeerService(),
  name: 'PeerServiceProvider',
);
