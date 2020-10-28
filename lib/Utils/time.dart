class TimeUtil {
  /// the current time, in “seconds since the epoch”
  static int currentTimeInSeconds() {
    var ms = (new DateTime.now()).millisecondsSinceEpoch;
    return (ms / 1000).round();
  }
}
