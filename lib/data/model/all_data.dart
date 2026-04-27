class PhaseData {
  final String phase;
  final double arus;

  PhaseData(this.phase, this.arus);
}

class LoadParam {
  final int load;
  final double arus;
  final String? phase;

  LoadParam({
    required this.load,
    this.arus = 0,
    this.phase,
  });

  LoadParam copyWith({
    double? arus,
    String? phase,
  }) {
    return LoadParam(
      load: load,
      arus: arus ?? this.arus,
      phase: phase ?? this.phase,
    );
  }
}

class LoadDatabase {
  final int load;
  final String name;
  final String assetNum;
  final int type;
  final String location;
  final int maxAmps;

  LoadDatabase({
    required this.load,
    required this.name,
    required this.assetNum,
    required this.type,
    required this.location,
    required this.maxAmps,
  });
}

class LoadViewData {
  final int load;

  final String name;
  final String assetNum;
  final int type;
  final String location;
  final int maxAmps;
  final double arus;
  final String phase;

  LoadViewData({
    required this.load,
    required this.name,
    required this.assetNum,
    required this.type,
    required this.location,
    required this.maxAmps,
    required this.arus,
    required this.phase,
  });

  LoadViewData copyWith({
    double? arus,
    String? phase,
  }) {
    return LoadViewData(
      load: load,
      name: name,
      assetNum: assetNum,
      type: type,
      location: location,
      maxAmps: maxAmps,
      arus: arus ?? this.arus,
      phase: phase ?? this.phase,
    );
  }
}

class LoadUpdate {
  final int load;
  final double? arus;
  final String? phase;
  final bool clearPhase;

  LoadUpdate({
    required this.load,
    this.arus,
    this.phase,
    this.clearPhase = false,
  });
}

class ConnectionStatus {
  final int status;

  ConnectionStatus(this.status);
}

class ModeData {
  final int mode;

  ModeData(this.mode);
}



class BalanceableData {
  final bool isBalanceable;

  BalanceableData(this.isBalanceable);
}



