//import 'package:flutter/material.dart' as material;
import 'package:file_picker/file_picker.dart';
import 'package:optimizer/src/core/models/parameter_model.dart';
import 'package:optimizer/src/core/models/simulation_settings_model.dart';
import 'package:optimizer/src/core/services/download_service.dart';
import 'package:optimizer/src/views/ui/simulation_settings/widgets/input_param_table.dart';
import 'package:optimizer/src/views/ui/result_page.dart';
import 'package:optimizer/src/views/ui/simulation_settings/widgets/simulation_param_commandbar.dart';
import 'package:optimizer/src/views/ui/simulation_settings/widgets/start_configuration_container.dart';
import 'package:optimizer/src/views/ui/simulation_settings/widgets/target_param_table.dart';
import 'package:fluent_ui/fluent_ui.dart';

const Widget spacer = const SizedBox(height: 5.0);

const double iconSize = 40;

class SimulationsSettingsPage extends StatefulWidget {
  final CMConfig cmConfig;
  const SimulationsSettingsPage({Key? key, required this.cmConfig})
      : super(key: key);

  @override
  _SimulationsSettingsPageState createState() =>
      _SimulationsSettingsPageState();
}

class _SimulationsSettingsPageState extends State<SimulationsSettingsPage> {
  List<InputParameter> _inputParameters = [];
  List<TargetParameter> _targetParameters = [];

  set inputParameters(List<InputParameter> value) =>
      setState(() => _inputParameters = value);
  set targetParameters(List<TargetParameter> value) =>
      setState(() => _targetParameters = value);

  final FlyoutController flyoutController = FlyoutController();
  final ScrollController scrollController = ScrollController();

  String errorCMConfig = "";
  String errorInputParameters = "";
  String errorTargetParameters = "";

  bool _isDuration = true;
  String _time = '3';
  String _iterations = '100';

  @override
  void dispose() {
    // flyoutController.dispose();
    //scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    CMConfig _cmConfig = this.widget.cmConfig;

    return ScaffoldPage(
      header: PageHeader(
        title: Text(
          'Parameter Settings',
          style: FluentTheme.of(context).typography.titleLarge,
        ),
        commandBar: Row(
          children: [
            SimulationParamCommandBar(
              callback: (val, bool) {
                setState(() {
                  _isDuration = bool;
                  if (_isDuration) {
                    _time = val;
                  } else {
                    _iterations = val;
                  }
                });
              },
            ),
            SplitButtonBar(
              style: SplitButtonThemeData(
                primaryButtonStyle: ButtonStyle(),
                interval: 2,
                borderRadius: BorderRadius.circular(4),
              ),
              buttons: [
                FilledButton(
                  child: Text("Run"),
                  onPressed: () {
                    setState(() {
                      errorInputParameters =
                          validateInputParameter(_inputParameters);
                      errorTargetParameters =
                          validateTargetParameter(_targetParameters);
                    });

                    if (validateForm(
                      errorCMConfig,
                      errorInputParameters,
                      errorTargetParameters,
                    )) {
                      if (_isDuration) {
                        _iterations = '0';
                      } else {
                        _time = '0';
                      }
                      SimulationSettings sim = new SimulationSettings(
                          cmConfig: this.widget.cmConfig,
                          inputParams: _inputParameters,
                          targetParams: _targetParameters,
                          optConfig: OPTConfig(
                              algos: Algos(
                                boGpLibVersion: true,
                                boRFLibVersion: false,
                                cmaEs: false,
                                customBo: false,
                                deOptimizer: false,
                                randomOPT: false,
                              ),
                              iterations: int.parse(_iterations),
                              time: int.parse(_time)));
                      print(sim.toJson().toString());
                      Navigator.pushNamed(context, 'generation');
                    }
                  },
                ),
                Button(
                  child: Text("Save Settings"),
                  onPressed: () {
                    setState(() {
                      // errorCMConfig = validateCMConfig(_cmConfigIsSelected);
                      errorInputParameters =
                          validateInputParameter(_inputParameters);
                      errorTargetParameters =
                          validateTargetParameter(_targetParameters);
                    });

                    if (validateForm(errorCMConfig, errorInputParameters,
                        errorTargetParameters)) {
                      if (_isDuration) {
                        _iterations = '0';
                      } else {
                        _time = '0';
                      }
                      SimulationSettings sim = new SimulationSettings(
                          cmConfig: this.widget.cmConfig,
                          inputParams: _inputParameters,
                          targetParams: _targetParameters,
                          optConfig: OPTConfig(
                              algos: Algos(
                                boGpLibVersion: true,
                                boRFLibVersion: false,
                                cmaEs: false,
                                customBo: false,
                                deOptimizer: false,
                                randomOPT: false,
                              ),
                              iterations: int.parse(_iterations),
                              time: int.parse(_time)));

                      DownloadService.saveStringAsJson(sim.toJson().toString());
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
      content: Scrollbar(
        controller: scrollController,
        child: ListView(
            padding: EdgeInsets.symmetric(
              horizontal: PageHeader.horizontalPadding(context),
            ),
            children: <Widget>[
              Wrap(
                spacing: 50,
                runSpacing: 50,
                children: [
                  MediaQuery.of(context).size.width < 1350
                      ? ConstrainedBox(
                          constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width * 0.6,
                          ),
                          child: StartConfigurationContainer(
                            cmConfig: _cmConfig,
                            callback: (val) => _cmConfig = val,
                          ),
                        )
                      : ConstrainedBox(
                          constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width * 0.35,
                          ),
                          child: StartConfigurationContainer(
                            cmConfig: _cmConfig,
                            callback: (val) => _cmConfig = val,
                          ),
                        ),
                ],
              ),
              SizedBox(height: 40),
              Wrap(
                spacing: 50,
                runSpacing: 50,
                children: [
                  MediaQuery.of(context).size.width < 1350
                      ? ConstrainedBox(
                          constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width * 0.6,
                          ),
                          child: InputParamTable(
                              parameters: _inputParameters,
                              callback: (val) =>
                                  setState(() => _inputParameters = val)),
                        )
                      : ConstrainedBox(
                          constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width * 0.35,
                          ),
                          child: InputParamTable(
                              parameters: _inputParameters,
                              callback: (val) =>
                                  setState(() => _inputParameters = val)),
                        ),
                  MediaQuery.of(context).size.width < 1350
                      ? ConstrainedBox(
                          constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width * 0.6,
                          ),
                          child: TargetParamTable(
                              parameters: _targetParameters,
                              callback: (val) =>
                                  setState(() => _targetParameters = val)),
                        )
                      : ConstrainedBox(
                          constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width * 0.35,
                          ),
                          child: TargetParamTable(
                              parameters: _targetParameters,
                              callback: (val) =>
                                  setState(() => _targetParameters = val)),
                        ),
                ],
              ),
              Divider(),
            ]),
      ),
    );
  }

  String validateCMConfig(bool isSelected) {
    if (!isSelected) {
      return "Please provide the CarMaker Configuration";
    } else
      return "";
  }

  String validateInputParameter(List<InputParameter> params) {
    if (params.length == 0) {
      return "Please provide at least 1 Input Parameter";
    } else
      return "";
  }

  String validateTargetParameter(List<TargetParameter> params) {
    if (params.length == 0) {
      return "Please provide at least 1 Target Parameter";
    } else
      return "";
  }

  String validateSimulationParameters(String value) {
    if (value == "") {
      return "Please provide a value";
    } else if (double.tryParse(value) == null) {
      return "Please use a numeric value";
    } else
      return "";
  }

  bool validateForm(
    String value1,
    String value2,
    String value3,
  ) {
    if (value1 == "" && value2 == "" && value3 == "") {
      return true;
    } else {
      return false;
    }
  }
}
