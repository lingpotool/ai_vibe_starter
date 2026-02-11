import 'package:flutter/material.dart';

/// 动效系统 — 统一时长和曲线
///
/// 所有动画必须使用此处定义的常量。
/// 参考 Material 3 Motion 规范。
///
/// 时长层级：
///   instant  — 100ms  微交互（颜色变化、opacity）
///   fast     — 200ms  小元素（toggle、按钮状态）
///   normal   — 300ms  标准过渡（页面切换、展开收起）
///   slow     — 500ms  大面积动画（模态弹出、全屏过渡）
///
/// 曲线：
///   easeOut      — 进入动画（元素出现）
///   easeIn       — 退出动画（元素消失）
///   easeInOut    — 状态切换（toggle、tab 切换）
///   spring       — 弹性动画（拖拽、下拉刷新）
class AppMotion {
  AppMotion._();

  // ── 时长 ──
  static const instant = Duration(milliseconds: 100);
  static const fast    = Duration(milliseconds: 200);
  static const normal  = Duration(milliseconds: 300);
  static const slow    = Duration(milliseconds: 500);

  // ── 曲线 ──
  static const curveEaseOut   = Curves.easeOut;
  static const curveEaseIn    = Curves.easeIn;
  static const curveEaseInOut = Curves.easeInOut;
  static const curveSpring    = Curves.elasticOut;

  // ── 标准组合（最常用） ──
  /// 小元素状态切换（hover 效果）
  static const fastEaseOut = (duration: fast, curve: curveEaseOut);

  /// 标准页面过渡
  static const normalEaseInOut = (duration: normal, curve: curveEaseInOut);
}
