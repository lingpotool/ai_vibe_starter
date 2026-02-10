// ignore_for_file: avoid_print
/// 分析图片像素分布，帮助确定裁剪参数
import 'dart:io';
import 'package:image/image.dart' as img;

void main(List<String> args) {
  if (args.isEmpty) {
    print('用法: dart run analyze_icon.dart <input.png>');
    exit(1);
  }

  final file = File(args[0]);
  final image = img.decodePng(file.readAsBytesSync())!;
  final w = image.width;
  final h = image.height;
  print('尺寸: $w x $h');

  // 打印四角颜色
  print('\n=== 四角颜色 ===');
  _printPixel(image, 10, 10, '左上(10,10)');
  _printPixel(image, w - 10, 10, '右上');
  _printPixel(image, 10, h - 10, '左下');
  _printPixel(image, w - 10, h - 10, '右下');

  // 打印中心线水平扫描（每隔100像素）
  print('\n=== 水平中心线 (y=${h ~/ 2}) ===');
  for (int x = 0; x < w; x += 80) {
    _printPixel(image, x, h ~/ 2, 'x=$x');
  }

  // 打印中心线垂直扫描
  print('\n=== 垂直中心线 (x=${w ~/ 2}) ===');
  for (int y = 0; y < h; y += 80) {
    _printPixel(image, w ~/ 2, y, 'y=$y');
  }

  // 检测每行的"非背景"像素比例（用左上角作为背景参考）
  final bgP = image.getPixel(50, 50);
  final bgR = bgP.r.toInt(), bgG = bgP.g.toInt(), bgB = bgP.b.toInt();
  print('\n背景参考色(50,50): RGB($bgR, $bgG, $bgB)');

  print('\n=== 每行非背景像素比例 (tolerance=12) ===');
  for (int y = 0; y < h; y += 40) {
    int nonBg = 0;
    for (int x = 0; x < w; x += 4) {
      final p = image.getPixel(x, y);
      final dr = (p.r.toInt() - bgR).abs();
      final dg = (p.g.toInt() - bgG).abs();
      final db = (p.b.toInt() - bgB).abs();
      if (dr >= 12 || dg >= 12 || db >= 12) nonBg++;
    }
    final ratio = nonBg / (w ~/ 4) * 100;
    final bar = '█' * (ratio ~/ 2);
    print('y=$y: ${ratio.toStringAsFixed(1)}% $bar');
  }

  print('\n=== 每列非背景像素比例 (tolerance=12) ===');
  for (int x = 0; x < w; x += 40) {
    int nonBg = 0;
    for (int y = 0; y < h; y += 4) {
      final p = image.getPixel(x, y);
      final dr = (p.r.toInt() - bgR).abs();
      final dg = (p.g.toInt() - bgG).abs();
      final db = (p.b.toInt() - bgB).abs();
      if (dr >= 12 || dg >= 12 || db >= 12) nonBg++;
    }
    final ratio = nonBg / (h ~/ 4) * 100;
    final bar = '█' * (ratio ~/ 2);
    print('x=$x: ${ratio.toStringAsFixed(1)}% $bar');
  }
}

void _printPixel(img.Image image, int x, int y, String label) {
  final p = image.getPixel(x, y);
  print('$label: RGB(${p.r.toInt()}, ${p.g.toInt()}, ${p.b.toInt()})');
}
