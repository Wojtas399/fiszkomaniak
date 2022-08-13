import '../models/time_model.dart';
import '../utils/utils.dart';

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
