import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pace_tracker_app/redux/app_state.dart';
import 'package:pace_tracker_app/util/mappers.dart';
import 'package:pace_tracker_app/widgets/calculator_field.dart';
import 'package:pace_tracker_app/widgets/clear_button.dart';

import '../util/calculators.dart';
import '../util/validators.dart';
import 'distance_field.dart';

class PaceCalculator extends StatefulWidget {
  const PaceCalculator({super.key});

  @override
  State<StatefulWidget> createState() => _PaceCalculatorState();
}

class _PaceCalculatorState extends State<PaceCalculator> {
  String _distance = '';
  String _time = '';
  String _pace = '';

  final _distanceController = TextEditingController();
  final _timeController = TextEditingController();

  bool _shouldCalcPace() {
    final distValid = isDistanceValid(_distance);
    final timeValid = isTimeValid(_time);
    return distValid && timeValid;
  }

  void _handleDistanceChanged(String newDistance) {
    setState(() {
      debugPrint('Distance changed');
      _distance = newDistance;
      if (_shouldCalcPace()) {
        debugPrint('Calculating Pace');
        _pace = calculatePace(_time, _distance).toString();
      }
    });
  }

  void _handleTimeChanged(String newTime) {
    setState(() {
      debugPrint('Time changed');
      _time = newTime;
      if (_shouldCalcPace()) {
        debugPrint('Calculating Pace');
        _pace = calculatePace(_time, _distance).toString();
      }
    });
  }

  void _clearAll() {
    _distanceController.clear();
    _timeController.clear();
    setState(() {
      _distance = '';
      _pace = '';
      _time = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _PaceCalculatorViewModel>(
        builder: (BuildContext context, _PaceCalculatorViewModel viewModel) {
          return Form(
              child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Text(
                    _pace.isNotEmpty
                        ? 'Pace: $_pace per ${viewModel.unitShortString}'
                        : 'Enter distance in ${viewModel.unitString} and total time to calculate pace',
                    style: const TextStyle(
                      fontSize: 24,
                    ),
                    textAlign: TextAlign.center,
                  )),
              DistanceField(
                onChanged: _handleDistanceChanged,
                controller: _distanceController,
              ),
              CalculatorField(
                  label: 'Time',
                  value: _time,
                  hint: 'Format hh:mm:ss',
                  onChanged: _handleTimeChanged,
                  controller: _timeController),
              ClearButton(
                clearFunction: () => _clearAll(),
              )
            ],
          ));
        },
        converter: (store) => _PaceCalculatorViewModel(
            state: store.state,
            unitShortString: mapMetricStoreStateToShortString(
                store.state.metricUnitsEnabled),
            unitString:
                mapMetricStoreStateToString(store.state.metricUnitsEnabled)));
  }
}

class _PaceCalculatorViewModel {
  final AppState state;
  final String unitString;
  final String unitShortString;

  _PaceCalculatorViewModel(
      {required this.state,
      required this.unitString,
      required this.unitShortString});
}
