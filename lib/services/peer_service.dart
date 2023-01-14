import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:peerdart/peerdart.dart';

class PeerService {
  Peer? _peer;
  late DataConnection conn;
  late StreamController<String> _streamController;
  bool connected = false;

  Stream<String> startServer(String id) {
    _peer = Peer(
      id: id,
    ); // options: PeerOptions(debug: LogLevel.All));
    if (_peer == null) {
      throw Exception('creation failed');
    }
    _streamController = StreamController<String>();
    _peer!.on<DataConnection>("connection").listen((event) {
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

  void stopServer() {
    _peer?.dispose();
    _streamController.close();
  }

  void connectToServer(String id) {
    _peer = Peer();
    if (_peer == null) {
      throw Exception('creation failed');
    }
    conn = _peer!.connect(id);

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
