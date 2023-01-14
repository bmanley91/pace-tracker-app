abstract class FormUpdateAction {
  bool shouldCalcPace;
  bool shouldCalcTime;

  FormUpdateAction({this.shouldCalcPace = false, this.shouldCalcTime = false});
}

class DistanceUpdateAction extends FormUpdateAction {
  String distance;

  DistanceUpdateAction(
      {required this.distance, super.shouldCalcPace, super.shouldCalcTime});
}

class PaceUpdateAction extends FormUpdateAction {
  String pace;

  PaceUpdateAction(
      {required this.pace, super.shouldCalcPace, super.shouldCalcTime});
}

class TimeUpdateAction extends FormUpdateAction {
  String time;

  TimeUpdateAction(
      {required this.time, super.shouldCalcPace, super.shouldCalcTime});
}
