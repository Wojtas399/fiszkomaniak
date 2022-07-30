extension UIIntExtensions on int {
  String toDaysStreakUIFormat() {
    if (this >= 1000) {
      return '999+';
    }
    return '$this';
  }
}
