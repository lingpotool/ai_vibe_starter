import 'package:flutter/services.dart';

class ClipboardUtil {
  ClipboardUtil._();
  static Future<String> read() async { final data = await Clipboard.getData(Clipboard.kTextPlain); return data?.text ?? ''; }
  static Future<void> write(String text) async { await Clipboard.setData(ClipboardData(text: text)); }
}
