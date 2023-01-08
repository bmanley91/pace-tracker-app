import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pace_tracker_app/redux/metric_state_action.dart';

class UnitSwitcher extends StatefulWidget {
  const UnitSwitcher({super.key});

  @override
  State<UnitSwitcher> createState() => _UnitSwitcherState();
}

class _UnitSwitcherState extends State<UnitSwitcher> {
  bool switchState = false;

  @override
  Widget build(BuildContext context) {
    return StoreConnector<bool, _UnitSwitcherViewModel>(
        builder: (BuildContext context, _UnitSwitcherViewModel viewModel) {
      return SwitchListTile(
          title: const Text('Use Metric Units?'),
          value: viewModel.state,
          secondary: const Icon(Icons.language),
          onChanged: viewModel.onChange);
    }, converter: (store) {
      return _UnitSwitcherViewModel(
          onChange: ((newState) => store.dispatch(MetricStateActions.flip)),
          state: store.state);
    });
  }
}

class _UnitSwitcherViewModel {
  final bool state;
  final void Function(bool newState) onChange;

  _UnitSwitcherViewModel({required this.state, required this.onChange});
}
