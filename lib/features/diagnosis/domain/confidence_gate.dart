enum ConfidenceResult {
  show, // >= 70%
  flag, // 40% - 70%
  escalate, // < 40%
}

class ConfidenceGate {
  static const double thresholdShow = 0.70;
  static const double thresholdFlag = 0.40;

  /// Pure function to determine the next action based on model confidence.
  static ConfidenceResult evaluate(double confidence) {
    if (confidence >= thresholdShow) {
      return ConfidenceResult.show;
    } else if (confidence >= thresholdFlag) {
      return ConfidenceResult.flag;
    } else {
      return ConfidenceResult.escalate;
    }
  }
}
