# 项目规则

> 示例：一个 2D 平台跳跃游戏

## 项目概述

- **项目名称**: Shadow Runner
- **项目描述**: 2D 横版平台跳跃游戏，玩家操控影子角色穿越光暗交替的关卡
- **目标用户**: 休闲游戏玩家
- **目标平台**: PC (Steam) + 移动端

## 技术选型

- **项目类型**: 游戏
- **核心框架**: Unity 2023 LTS
- **编程语言**: C#
- **特殊依赖**: DOTween (动画)、Cinemachine (相机)、TextMeshPro (文字)

## UI 与设计

- **UI 方案**: Unity UI Toolkit + TextMeshPro
- **美术风格**: 暗色调 + 霓虹光效，赛博朋克像素风
- **分辨率**: 1920x1080 基准，支持 16:9 和 16:10
- **移动端适配**: 虚拟摇杆 + 按钮

## 项目结构

```
Assets/
├── Scripts/
│   ├── Player/
│   │   ├── PlayerController.cs
│   │   ├── PlayerAnimation.cs
│   │   └── PlayerHealth.cs
│   ├── Enemy/
│   ├── Level/
│   │   ├── LevelManager.cs
│   │   └── Checkpoint.cs
│   ├── UI/
│   │   ├── HUDController.cs
│   │   └── MenuController.cs
│   ├── Managers/
│   │   ├── GameManager.cs
│   │   ├── AudioManager.cs
│   │   └── SaveManager.cs
│   └── Utils/
├── Prefabs/
│   ├── Player/
│   ├── Enemies/
│   ├── Obstacles/
│   └── UI/
├── Scenes/
│   ├── MainMenu.unity
│   ├── Level_01.unity
│   └── Level_02.unity
├── Art/
│   ├── Sprites/
│   ├── Tilesets/
│   └── VFX/
├── Audio/
│   ├── Music/
│   └── SFX/
├── Animations/
└── Resources/
```

## 代码规范

- **命名风格**: PascalCase（类、方法、属性），camelCase（局部变量、参数）
- **Git 提交**: Conventional Commits
- **测试策略**: 关键系统的 Play Mode 测试
- **文档要求**: 游戏设计文档 (GDD)

## 部署

- **部署平台**: Steam (PC) + App Store / Google Play (移动端)
- **CI/CD**: Unity Cloud Build / GameCI (GitHub Actions)
- **发布流程**: 构建 → 测试 → 上传到 Steamworks / App Store Connect

## AI 开发规则

1. 使用 Unity 2023 LTS API，不要使用已弃用的 API
2. 遵循 Unity 项目结构，资源放在正确的文件夹
3. 使用 ScriptableObject 做数据配置，不要硬编码数值
4. 物理相关逻辑放在 FixedUpdate，输入检测放在 Update
5. 使用对象池管理频繁创建/销毁的对象（子弹、特效等）
6. 音频通过 AudioManager 统一管理
7. 存档使用 JSON 序列化，存储在 Application.persistentDataPath
8. 不要在 Update 中使用 GetComponent，缓存引用
9. 新增插件/资源前先说明
