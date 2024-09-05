import 'package:easy_localization/easy_localization.dart';

final decimalFormat = NumberFormat.decimalPattern("en");

extension IntExt on int {
  static int? safeParse(String? source) {
    if (source == null) return null;
    return int.tryParse(source);
  }

  String toComma() {
    return decimalFormat.format(this);
  }

  // 구독자 수를 한국어 형식으로 변환하는 메서드
  String toKoreanUnit() {
    if (this >= 10000) {
      // 소수점 이하 불필요한 0 제거
      return "${(this / 10000).toStringAsFixed(2).replaceAll(RegExp(r"(\.0+|0+)$"), "")}만명";
    } else if (this >= 1000) {
      return "${(this / 1000).toStringAsFixed(1).replaceAll(RegExp(r"(\.0+|0+)$"), "")}천명";
    } else if (this >= 100) {
      return "${(this / 100).toStringAsFixed(1).replaceAll(RegExp(r"(\.0+|0+)$"), "")}백명";
    } else {
      return "$this명";
    }
  }

  String get withPlusMinus {
    if (this > 0) {
      return "+$this";
    } else if (this < 0) {
      return "$this";
    } else {
      return "0";
    }
  }
}

extension DoubleExt on double {
  String toComma() {
    return decimalFormat.format(this);
  }
}
