import 'package:optimizer/src/core/models/parameter_model.dart';
import 'package:optimizer/src/core/utils/format_helper.dart';

class SimulationSettings {
  SimulationSettings({
    required this.cmConfig,
    required this.inputParams,
    required this.targetParams,
    required this.optConfig,
  });

  CMConfig cmConfig;
  List<InputParameter> inputParams;
  List<TargetParameter> targetParams;
  OPTConfig optConfig;

  static SimulationSettings fromJson(Map<String, dynamic> json) {
    for (var key in json.keys) {
      print("key: " + key);
      print(json[key]);
    }
    var list_1 = json['Input_params'] as List;
    var list_2 = json['Target_params'] as List;
    List<InputParameter> inputParamList =
        list_1.map((i) => InputParameter.fromJson(i)).toList();
    List<TargetParameter> targetParamList =
        list_2.map((i) => TargetParameter.fromJson(i)).toList();

    return SimulationSettings(
      cmConfig: CMConfig.fromJson(json['CM_config']),
      inputParams: inputParamList,
      targetParams: targetParamList,
      optConfig: OPTConfig.fromJson(json['opt_config']),
    );
  }

  Map<String, dynamic> toJson() {
    List<Map> inputParams = this.inputParams.map((i) => i.toJson()).toList();
    List<Map> targetParams = this.targetParams.map((i) => i.toJson()).toList();

    return {
      '"CM_config"': cmConfig.toJson(),
      '"Input_params"': inputParams,
      '"Target_params"': targetParams,
      '"opt_config"': optConfig.toJson(),
    };
  }
}

class CMConfig {
  final String cmPath;
  final String cmProj;
  final String cmTestrun;

  CMConfig({
    this.cmPath = "",
    this.cmProj = "",
    this.cmTestrun = "",
  });

  static CMConfig fromJson(Map<String, dynamic> json) => CMConfig(
        cmPath: json['CM_PATH'],
        cmProj: json['CM_PROJ'],
        cmTestrun: json['CM_TESTRUN'],
      );

  Map<String, dynamic> toJson() => {
        '"CM_PATH"': addQuatationMarkIfNeeded(cmPath),
        '"CM_PROJ"': addQuatationMarkIfNeeded(cmProj),
        '"CM_TESTRUN"': addQuatationMarkIfNeeded(cmTestrun),
      };
}

class OPTConfig {
  Algos algos;
  int iterations;
  int time;

  OPTConfig({
    this.algos = const Algos(),
    this.iterations = 0,
    this.time = 0,
  });

  static OPTConfig fromJson(Map<String, dynamic> json) => OPTConfig(
        algos: Algos.fromJson(json['algos']),
        iterations: json['Iterations'],
        time: json['Time'],
      );

  Map<String, dynamic> toJson() => {
        '"algos"': algos.toJson(),
        '"Iterations"': iterations,
        '"Time"': time,
      };
}

class Algos {
  final bool deOptimizer;
  final bool boRFLibVersion;
  final bool randomOPT;
  final bool boGpLibVersion;
  final bool customBo;
  final bool cmaEs;

  const Algos({
    this.deOptimizer = true,
    this.boRFLibVersion = false,
    this.randomOPT = false,
    this.boGpLibVersion = false,
    this.customBo = false,
    this.cmaEs = false,
  });

  static Algos fromJson(Map<String, dynamic> json) => Algos(
        deOptimizer: json['DEOptimizer'],
        boRFLibVersion: json['bo_rf_lib_version'],
        randomOPT: json['random_opt'],
        boGpLibVersion: json['bo_gp_lib_version'],
        customBo: json['custom_bo'],
        cmaEs: json['CMA-ES'],
      );

  Map<String, dynamic> toJson() => {
        '"DEOptimizer"': deOptimizer,
        '"bo_rf_lib_version"': boRFLibVersion,
        '"random_opt"': randomOPT,
        '"bo_gp_lib_version"': boGpLibVersion,
        '"custom_bo"': customBo,
        '"CMA-ES"': cmaEs,
      };
}
