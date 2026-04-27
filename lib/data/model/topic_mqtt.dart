class MqttTopics {
  final String subPhase;
  final String subMode;
  final String subStatus;
  final String subCurrent;
  final String subBalance;

  final String pubPhase;
  final String pubMode;
  final String pubStatus;

  MqttTopics({
    required this.subPhase,
    required this.subMode,
    required this.subStatus,
    required this.subCurrent,
    required this.subBalance,
    required this.pubPhase,
    required this.pubMode,
    required this.pubStatus,
  });

  factory MqttTopics.fromEspId(String espId) {
    return MqttTopics(
      subPhase: "$espId/Esp32/Phase",
      subMode: "$espId/Esp32/Mode",
      subStatus: "$espId/Esp32/Status",
      subCurrent: "$espId/Esp32/Arus",
      subBalance: "$espId/Esp32/Balanceable",
      pubPhase: "$espId/Flutter/Phase",
      pubMode: "$espId/Flutters/Mode",
      pubStatus: "$espId/Flutters/Status",
    );
  }

  List<String> get subscribeAll => [
        subPhase,
        subMode,
        subStatus,
        subCurrent,
        subBalance,
      ];

}