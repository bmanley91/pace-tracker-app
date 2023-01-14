import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pace_tracker_app/redux/app_state.dart';
import 'package:pace_tracker_app/redux/form_update_actions.dart';
import 'package:pace_tracker_app/util/mappers.dart';
import 'package:pace_tracker_app/widgets/calculator_field.dart';
import 'package:pace_tracker_app/widgets/clear_button.dart';

import '../util/validators.dart';
import 'distance_field.dart';

class PaceCalculator extends StatefulWidget {
  const PaceCalculator({super.key});

  @override
  State<StatefulWidget> createState() => _PaceCalculatorState();
}

class _PaceCalculatorState extends State<PaceCalculator> {
  final _distanceController = TextEditingController();
  final _timeController = TextEditingController();

  // bool _shouldCalcPace(String distance, String time) {
  //   final distValid = isDistanceValid(distance);
  //   final timeValid = isTimeValid(time);
  //   debugPrint('distValid? $distValid, timeValid? $timeValid');
  //   return distValid && timeValid;
  // }

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
                    viewModel.pace.isNotEmpty
                        ? 'Pace: ${viewModel.pace} per ${viewModel.unitShortString}'
                        : 'Enter distance in ${viewModel.unitString} and total time to calculate pace',
                    style: const TextStyle(
                      fontSize: 24,
                    ),
                    textAlign: TextAlign.center,
                  )),
              DistanceField(
                controller: _distanceController,
                shouldUpdatePace: true,
              ),
              CalculatorField(
                  label: 'Time',
                  hint: 'Format hh:mm:ss',
                  onChanged: viewModel.onTimeChange,
                  controller: _timeController),
              ClearButton(
                controllersToClear: [_distanceController, _timeController],
              )
            ],
          ));
        },
        converter: (store) => _PaceCalculatorViewModel(
              pace: store.state.pace,
              distance: store.state.distance,
              time: store.state.time,
              unitShortString: mapMetricStoreStateToShortString(
                  store.state.metricUnitsEnabled),
              unitString:
                  mapMetricStoreStateToString(store.state.metricUnitsEnabled),
              onTimeChange: (newTime) => store.dispatch(
                  TimeUpdateAction(time: newTime, shouldCalcPace: true)),
            ));
  }
}

class _PaceCalculatorViewModel {
  final String pace;
  final String distance;
  final String time;
  final String unitString;
  final String unitShortString;
  final void Function(String newTime) onTimeChange;

  _PaceCalculatorViewModel(
      {required this.pace,
      required this.distance,
      required this.time,
      required this.unitString,
      required this.unitShortString,
      required this.onTimeChange});
}
