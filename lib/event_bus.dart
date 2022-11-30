// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:event_bus/event_bus.dart';

/// The global [EventBus] object.
EventBus eventBus = EventBus();

class Points {
  final int biggestCommon;
  final int balls;
  final int totalPoints;

  const Points(
    this.biggestCommon,
    this.balls,
    this.totalPoints,
  );
}
