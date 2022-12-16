// Convert Decimal Degrees to Degeree Minute Seconds
String decimalDegreesToDMS(double? decimalDegree) {
  if (decimalDegree == null) return "";
  // How to Convert Decimal Degrees to DMS
  // Follow these steps to convert decimal degrees to DMS:

  // For the degrees use the whole number part of the decimal
  // For the minutes multiply the remaining decimal by 60. Use the whole number part of the answer as minutes.
  // For the seconds multiply the new remaining decimal by 60

  int degree = decimalDegree.floor();

  double remaining = (decimalDegree - degree) * 60;

  int minute = remaining.floor();
  String second = ((remaining - minute) * 60).toStringAsFixed(2);

  return "$degree%C2%B0$minute'$second%22";
}