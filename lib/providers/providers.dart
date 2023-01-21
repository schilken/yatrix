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
