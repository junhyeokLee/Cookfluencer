import '../common.dart';

String formatMonthDayDate(String isoDate) {
  try {
    // ISO 8601 형식 문자열을 DateTime으로 변환
    final dateTime = DateTime.parse(isoDate);

    // 원하는 형식으로 변환 (MM.dd)
    final formattedDate = DateFormat('MM.dd').format(dateTime);
    return formattedDate;
  } catch (e) {
    // 오류 발생 시 기본값 반환
    print("Date parsing error: $e");
    return '';
  }
}