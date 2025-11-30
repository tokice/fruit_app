extension DoubleExtension on double {
  String toStringAsFixedNoZero(int fractionDigits) {
    final string = toStringAsFixed(fractionDigits);
    if (string.contains('.')) {
      var trimmed = string.replaceAll(RegExp(r'0*$'), '');
      if (trimmed.endsWith('.')) {
        trimmed = trimmed.substring(0, trimmed.length - 1);
      }
      return trimmed;
    }
    return string;
  }
}