import 'dart:convert';


Map<String, dynamic> jsonTryDecode(String source) {
  try {
    final result = jsonDecode(source);
    return result;
  } catch (e) {
    print('Не удалось декодировать строку');
    return <String, dynamic>{};
  }
}
