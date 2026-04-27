import 'dart:convert';
import 'package:spds/data/model/all_data.dart';

class MqttParser {
  static const Set<String> _validPhases = {'R', 'S', 'T', 'U'};

  static String? _parsePhase(dynamic value) {
    final phase = value?.toString().trim().toUpperCase();
    if (phase == null || !_validPhases.contains(phase)) {
      return null;
    }
    return phase;
  }

  /// Decode JSON utama
  static Map<String, dynamic>? decode(String message) {
    try {
      final data = jsonDecode(message);
      if (data is Map<String, dynamic>) return data;
      return null;
    } catch (e) {
      print("JSON decode error: $e");
      return null;
    }
  }

  /// MODE
  static ModeData? parseMode(Map<String, dynamic> data) {
    final mode = data["MODE"];
    return mode is int ? ModeData(mode) : null;
  }

  /// STATUS
  static ConnectionStatus? parseStatus(Map<String, dynamic> data) {
    final status = data["status"];
    return status is int ? ConnectionStatus(status) : null;
  }

  static BalanceableData? parseBalanceable(Map<String, dynamic> data) {
    final value = data["isBalanceable"];
    return value is bool ? BalanceableData(value) : null;
  }

  /// SINGLE LOAD
  static LoadUpdate? parseSingleLoad(Map<String, dynamic> data) {
    if (!data.containsKey("load")) return null;

    final rawLoad = data["load"];
    if (rawLoad is! num) return null;

    final int loadIndex = rawLoad.toInt();

    final arus = data["arus"] is num ? (data["arus"] as num).toDouble() : null;

    final hasPhaseField = data.containsKey("phase");
    final phase = hasPhaseField ? _parsePhase(data["phase"]) : null;

    return LoadUpdate(
      load: loadIndex,
      arus: arus,
      phase: phase,
      // Clear phase only when payload explicitly sends phase but it is invalid/N.
      clearPhase: hasPhaseField && phase == null,
    );
  }

  static List<LoadUpdate> parseBulkLoads(Map<String, dynamic> data) {
    final List<LoadUpdate> result = [];

    if (data["loads"] is! List) return result;

    for (final item in data["loads"]) {
      if (item is! Map<String, dynamic>) continue;

      final parsed = parseSingleLoad(item);
      if (parsed != null) result.add(parsed);
    }

    return result;
  }

  static List<PhaseData> parsePhaseCurrents(Map<String, dynamic> data) {
    final raw = data["phase"];
    if (raw is! List) return const [];

    final List<PhaseData> result = [];

    for (final item in raw) {
      if (item is! Map<String, dynamic>) continue;

      final phase = _parsePhase(item["phase"]);
      if (phase == null) continue;

      final arusRaw = item["arus"];
      if (arusRaw is! num) continue;

      result.add(PhaseData(phase, arusRaw.toDouble()));
    }

    return result;
  }
}
