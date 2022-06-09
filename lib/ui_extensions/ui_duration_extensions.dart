extension UIDurationExtensions on Duration? {
  String toUIFormat() {
    final Duration? duration = this;
    if (duration == null) {
      return '--';
    }
    final int hours = duration.inHours;
    final int minutes = duration.inMinutes.remainder(60);
    final String convertedMinutes = '${minutes}min';
    final String convertedHours = '${hours}godz';
    if (hours > 0 && minutes == 0) {
      return convertedHours;
    } else if (minutes > 0 && hours == 0) {
      return convertedMinutes;
    }
    return '$convertedHours $convertedMinutes';
  }
}
