# 项目规则

> 示例：一个基于 ESP32 的智能家居温湿度监控系统

## 项目概述

- **项目名称**: HomeClimate
- **项目描述**: ESP32 采集温湿度数据，通过 MQTT 上报，Web 面板实时展示和告警
- **目标用户**: 智能家居爱好者
- **目标平台**: ESP32 (固件) + Web (控制面板)

## 技术选型

- **项目类型**: 嵌入式 IoT + Web 应用
- **核心框架**: PlatformIO + Arduino (固件) / Next.js (Web)
- **编程语言**: C++ (固件) + TypeScript (Web)
- **包管理器**: PlatformIO (固件) + pnpm (Web)
- **数据库**: InfluxDB (时序数据) + SQLite (设备配置)
- **特殊依赖**: MQTT (Mosquitto)、DHT22 传感器库

## UI 与设计

- **组件库**: shadcn/ui (Web 面板)
- **样式方案**: Tailwind CSS
- **设计风格**: 简洁仪表盘风格
- **主色调**: 青色 (#06b6d4)
- **暗色模式**: 是
- **响应式**: 是（手机也能看）

## 项目结构

```
firmware/                    # ESP32 固件
├── src/
│   └── main.cpp
├── lib/
│   ├── SensorManager/      # 传感器管理
│   ├── MQTTClient/         # MQTT 通信
│   ├── WiFiManager/        # WiFi 配网
│   └── ConfigStore/        # 配置存储 (NVS)
├── include/
├── test/
└── platformio.ini

web/                         # Web 控制面板
├── src/
│   ├── app/
│   │   ├── dashboard/
│   │   ├── devices/
│   │   └── alerts/
│   ├── components/
│   │   ├── ui/
│   │   ├── charts/         # 数据图表
│   │   └── device/
│   ├── lib/
│   │   ├── mqtt.ts         # MQTT 客户端
│   │   └── influx.ts       # InfluxDB 查询
│   └── types/

docker-compose.yml           # Mosquitto + InfluxDB
```

## 代码规范

- **格式化工具**: clang-format (C++) + Biome (TypeScript)
- **命名风格**: C++ snake_case 函数 + PascalCase 类，TS 标准
- **Git 提交**: Conventional Commits
- **测试策略**: 固件单元测试 + Web 关键路径测试
- **测试框架**: PlatformIO Test (固件) + Vitest (Web)

## 部署

- **部署平台**: USB 烧录 (固件) + Docker 自托管 (Web + MQTT + InfluxDB)
- **环境**: development + production
- **CI/CD**: GitHub Actions（固件编译检查 + Web 构建）

## AI 开发规则

1. 固件代码使用 Arduino 框架 + PlatformIO
2. 固件中避免使用 String 类，用 char[] 减少内存碎片
3. MQTT 消息格式统一用 JSON
4. 传感器读取间隔可配置，默认 30 秒
5. WiFi 断线自动重连，MQTT 断线自动重连
6. 固件 OTA 更新预留接口
7. Web 端图表使用 recharts 或 Chart.js
8. 时序数据查询要做好时间范围限制，避免查询过大
9. 新增依赖前先说明
