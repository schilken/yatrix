import 'dart:async';
import 'dart:math';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:peerdart/peerdart.dart';

class PeerService {
  final _random = Random();
  int _peerId = 0;
  Peer? _peer;
  late DataConnection conn;
  StreamController<String>? _streamController;
  bool connected = false;

  PeerService() {
    _setRandomPeerId();
  }

  int get localPeerId => _peerId;

  Stream<String> startServer() {
    initStreamController();
    // _peer = Peer(
    //   id: id,
    // ); // options: PeerOptions(debug: LogLevel.All));
    // if (_peer == null) {
    //   throw Exception('creation failed');
    // }

    _peer!.on<DataConnection>('connection').listen((event) {
      conn = event;
//      print('server got an connection: $event');
      _streamController?.add('connection opened');

      conn.on<dynamic>('data').listen((dynamic data) {
//        print('server received data: $data');
        _streamController?.add(data.toString());
        BotToast.showText(
          text: data.toString(),
          duration: const Duration(seconds: 3),
          align: const Alignment(0, 0.3),
        );
      });

      conn.on<dynamic>('close').listen((dynamic _) {
//        print('server received close');
        _streamController?.add('connection closed');
        connected = false;
      });
      connected = true;
    });
    return _streamController!.stream;
  }

  // void stopServer() {
  //   _peer?.dispose();
  //   _streamController?.close();
  //   _streamController = null;
  // }

  void disposePeer() {
    print('disposePeer');
    _peer?.dispose();
    _streamController?.close();
    _streamController = null;
    BotToast.showText(
      text: 'Two-Player Mode finished',
      duration: const Duration(seconds: 3),
      align: const Alignment(0, 0.3),
    );
  }

  void initStreamController() {
    print('initStreamController');
    _streamController?.close();
    _streamController ??= StreamController<String>();
  }

  void _setRandomPeerId() {
    _peerId = _random.nextInt(99999);
  }

  Future<void> initPeer() async {
//    final completer = Completer<void>();
    final startTime = DateTime.now();
    _peer =
        Peer(id: _peerId.toString(), options: PeerOptions(debug: LogLevel.All));
    if (_peer == null) {
      throw Exception('creation failed');
    }
//    await Future<void>.delayed(Duration(milliseconds: 1000));
    // _peer!.on<dynamic>('open').listen((dynamic id) {
    //   final delta = DateTime.now().difference(startTime);
    //   _streamController?.add('received open after ${delta.inMilliseconds}');
    //   print('on-open: $id after ${delta.inMilliseconds} ms');
    //   completer.complete;
    // });
    // return completer.future;
  }

  Stream<String> connectToServer(String id) {
    initStreamController();
    final connection =
        _peer!.connect(id, options: PeerConnectOption(reliable: true));
    conn = connection;

    conn.on<dynamic>('open').listen((dynamic event) {
      connected = true;
      _streamController?.add('connection opened');
//      print('conn.open: $event');

      conn.on<dynamic>('data').listen((dynamic data) {
//        print('client received data: $data');
        _streamController?.add(data.toString());
    });

      connection.on<dynamic>('close').listen((dynamic _) {
//        print('client received close');
        _streamController?.add('connection closed');
        connected = false;
      });
    });

    return _streamController!.stream;
  }

  // void disconnect() {
  //   _peer?.dispose();
  //   _streamController?.close();
  //   _streamController = null;
  // }

  void sendMessage(String message) {
    conn.send(message);
  }

}

final peerServiceProvider = Provider<PeerService>(
  (ref) => PeerService(),
  name: 'PeerServiceProvider',
);
