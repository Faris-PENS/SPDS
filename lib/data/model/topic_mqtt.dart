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
      subPhase: "dev/ai/vixmo/mcu/SPDS/$espId/loadData",
      subMode: "dev/ai/vixmo/mcu/SPDS/$espId/mode",
      subStatus: "dev/ai/vixmo/mcu/SPDS/$espId/status",
      subCurrent: "dev/ai/vixmo/mcu/SPDS/$espId/currentData",
      subBalance: "dev/ai/vixmo/mcu/SPDS/$espId/isBalance",
      pubPhase: "dev/ai/vixmo/maa/SPDS/$espId/loadData",
      pubMode: "dev/ai/vixmo/maa/SPDS/$espId/mode",
      pubStatus: "dev/ai/vixmo/maa/SPDS/$espId/status",
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