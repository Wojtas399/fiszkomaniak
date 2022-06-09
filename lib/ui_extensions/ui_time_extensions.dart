import 'package:fiszkomaniak/models/time_model.dart';
import 'package:fiszkomaniak/utils/utils.dart';

extension UITimeExtensions on Time? {
  String toUIFormat() {
    final Time? time = this;
    if (time == null) {
      return '--';
    }
    final String hour = Utils.twoDigits(time.hour);
    final String minute = Utils.twoDigits(time.minute);
    return '$hour:$minute';
  }
}
