# 代码规范知识库

> AI 在推荐代码规范时参考此文件。大部分用户不会关心这些细节，准备好默认方案。

## 代码格式化

### TypeScript / JavaScript

默认推荐配置：
- **ESLint**: 代码质量检查
- **Prettier**: 代码格式化
- 或使用 **Biome**: ESLint + Prettier 的替代品，更快

推荐规则：
```
- 使用分号
- 使用单引号
- 缩进 2 空格
- 尾逗号 (trailing comma)
- 行宽 100 字符
```

### Python
- **Ruff**: 格式化 + lint，速度快，推荐
- 或 **Black** + **Flake8**: 传统方案
- **mypy / pyright**: 类型检查

### Go
- `gofmt`（标准工具，无需配置）
- `golangci-lint`（综合 lint 工具）

### Rust
- `rustfmt`（标准格式化）
- `clippy`（lint 工具）

### Java / Kotlin
- **Checkstyle** / **ktlint**: 代码风格检查
- **SpotBugs**: bug 检测
- **Google Java Format**: 格式化

### C# 
- **.editorconfig**: 统一编辑器配置
- **dotnet format**: 格式化
- **Roslyn Analyzers**: 代码分析

### Swift
- **SwiftLint**: lint 工具
- **swift-format**: 格式化

### Dart / Flutter
- `dart format`（标准工具）
- `dart analyze`（分析工具）
- **very_good_analysis**: 严格 lint 规则集

### Solidity
- **solhint**: lint 工具
- **prettier-plugin-solidity**: 格式化

### C / C++
- **clang-format**: 格式化
- **clang-tidy**: 静态分析
- **cppcheck**: bug 检测

### GDScript (Godot)
- **gdtoolkit**: 格式化 + lint

## 错误处理模式

### 前端 (Web / 移动端)
```
- API 请求统一封装，集中处理错误
- 使用 Error Boundary 捕获渲染错误（React）
- 表单验证使用 zod 或 yup
- 用户友好的错误提示，不暴露技术细节
- 网络错误自动重试（可选）
```

### 后端 API
```
- 统一错误响应格式：{ error: { code, message, details? } }
- 区分业务错误和系统错误
- 记录错误日志，包含上下文信息
- 不在响应中暴露堆栈信息
- HTTP 状态码正确使用
```

### CLI 工具
```
- 友好的错误信息，告诉用户怎么修复
- 退出码规范（0 成功，非 0 失败）
- --verbose 模式显示详细错误
```

### 游戏
```
- 异常不应导致游戏崩溃，优雅降级
- 错误日志写入文件，方便排查
- 关键操作（存档、网络）做好异常处理
```

### 嵌入式 / IoT
```
- 看门狗定时器防止死锁
- 错误状态通过 LED/串口输出
- 关键操作做好超时处理
- 内存分配失败的处理
```

### 智能合约
```
- 使用 require/revert 做输入验证
- 自定义错误类型节省 gas
- 关键操作使用事件（Event）记录
- 重入攻击防护
```

### AI / ML
```
- 数据加载失败的优雅处理
- 训练中断后可恢复（checkpoint）
- 模型推理超时处理
- 输入数据验证
```

## 测试策略

| 项目规模 | 推荐策略 |
|---------|---------|
| 原型/MVP | 不写测试，快速验证 |
| 小项目 | 关键路径的集成测试 |
| 中型项目 | 单元测试 + 集成测试 |
| 大型项目 | 单元 + 集成 + E2E |

### 测试工具推荐

| 类型 | 工具 |
|------|------|
| 单元测试 (JS/TS) | Vitest |
| 组件测试 (React) | Testing Library |
| E2E 测试 (Web) | Playwright |
| API 测试 (Node) | Vitest / Supertest |
| Python 测试 | pytest |
| Go 测试 | testing（标准库）+ testify |
| Rust 测试 | cargo test（内置）|
| Java 测试 | JUnit 5 + Mockito |
| C# 测试 | xUnit / NUnit + Moq |
| Swift 测试 | XCTest |
| Flutter 测试 | flutter_test（内置）|
| React Native 测试 | Jest + Testing Library |
| 智能合约测试 | Hardhat + Chai / Foundry |
| 游戏测试 | 引擎内置测试框架 |
| 嵌入式测试 | Unity Test / PlatformIO Test |
| 小程序测试 | miniprogram-simulate |
| 数据管道测试 | pytest + Great Expectations |

## Git 提交规范

推荐 Conventional Commits：

```
feat: 新功能
fix: 修复 bug
docs: 文档更新
style: 代码格式（不影响逻辑）
refactor: 重构
test: 测试相关
chore: 构建/工具相关
perf: 性能优化
ci: CI/CD 相关
```

## 文档规范

| 项目类型 | 推荐文档 |
|---------|---------|
| 所有项目 | README.md（项目说明、如何运行） |
| 库 / SDK | API 文档（TSDoc/JSDoc/Sphinx/GoDoc） |
| API 服务 | OpenAPI/Swagger 文档 |
| 智能合约 | NatSpec 注释 |
| 游戏 | 游戏设计文档 (GDD) |
| 数据工程 | 数据字典、管道说明 |
| 团队项目 | CONTRIBUTING.md、CHANGELOG.md |

## 默认推荐

对于大部分项目，直接使用：
- 对应语言的标准格式化工具
- Conventional Commits
- 原型阶段不写测试
- 统一错误处理封装
- README.md 必须有
