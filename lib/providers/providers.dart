import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

export '../services/peer_service.dart';
export 'high_score_notifier.dart';
export 'peer_client_notifier.dart';
export 'peer_notifier.dart';
export 'peer_server_notifier.dart';
export 'preferences_repository.dart';
export 'settings_notifier.dart';

final sharedPreferencesProvider = Provider<SharedPreferences>(
  (ref) => throw UnimplementedError(),
  name: 'SharedPreferencesProvider',
);

class DialogData {
  String? title;
  String? text1;
  String? text2;
  String? buttonText;
  String? returnedData;
  VoidCallback? onCommit;
  VoidCallback? onCancel;

  DialogData({
    this.title,
    this.text1,
    this.text2,
    this.buttonText,
    this.returnedData,
    this.onCommit,
    this.onCancel,
  });
}

final dialogDataProvider = StateProvider<DialogData>((_) => DialogData());
