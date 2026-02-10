# 项目规则

> 示例：一个 NFT 市场 DApp

## 项目概述

- **项目名称**: PixelMarket
- **项目描述**: NFT 铸造和交易市场，支持图片和像素艺术 NFT
- **目标用户**: NFT 收藏者和创作者
- **目标平台**: Web (DApp)

## 技术选型

- **项目类型**: 区块链 / Web3
- **核心框架**: Next.js (前端) + Hardhat (合约)
- **编程语言**: TypeScript (前端) + Solidity (合约)
- **包管理器**: pnpm
- **数据库**: The Graph (链上数据索引) + Supabase (链下元数据)
- **认证方案**: 钱包登录 (SIWE - Sign In With Ethereum)
- **特殊依赖**: wagmi + viem (合约交互)、RainbowKit (钱包连接)、IPFS/Pinata (存储)

## UI 与设计

- **组件库**: shadcn/ui + RainbowKit
- **样式方案**: Tailwind CSS
- **设计风格**: 现代、暗色调
- **主色调**: 紫色 (#8b5cf6)
- **图标库**: Lucide
- **暗色模式**: 是（默认暗色）
- **响应式**: 是

## 项目结构

```
contracts/                   # 智能合约
├── src/
│   ├── NFTMarket.sol
│   ├── NFTToken.sol
│   └── interfaces/
├── test/
├── scripts/
│   ├── deploy.ts
│   └── verify.ts
└── hardhat.config.ts

frontend/                    # DApp 前端
├── src/
│   ├── app/
│   │   ├── explore/        # 浏览 NFT
│   │   ├── create/         # 铸造 NFT
│   │   ├── profile/        # 个人主页
│   │   └── nft/[id]/       # NFT 详情
│   ├── components/
│   │   ├── ui/
│   │   ├── nft/
│   │   └── wallet/
│   ├── hooks/
│   │   ├── useContract.ts
│   │   └── useNFT.ts
│   ├── lib/
│   │   ├── contracts.ts    # 合约 ABI 和地址
│   │   ├── ipfs.ts         # IPFS 上传
│   │   └── wagmi.ts        # wagmi 配置
│   └── types/

subgraph/                    # The Graph 子图
├── schema.graphql
├── src/
│   └── mapping.ts
└── subgraph.yaml
```

## 代码规范

- **格式化工具**: Biome (TypeScript) + solhint + prettier-plugin-solidity (Solidity)
- **命名风格**: TS 标准 + Solidity 标准
- **Git 提交**: Conventional Commits
- **测试策略**: 合约全面测试 + 前端关键路径测试
- **测试框架**: Hardhat + Chai (合约) + Vitest (前端)

## 部署

- **部署平台**: Vercel (前端) + Ethereum Sepolia 测试网 → 主网 (合约)
- **环境**: development (本地 Hardhat 节点) + testnet + mainnet
- **CI/CD**: GitHub Actions（合约测试 + 前端构建）
- **发布流程**: 合约部署 → 验证 → 子图部署 → 前端部署

## AI 开发规则

1. 智能合约安全第一，使用 OpenZeppelin 标准合约
2. 合约必须有完整的测试覆盖，包括边界情况
3. 前端使用 wagmi hooks 与合约交互，不要直接用 ethers.js
4. 所有链上操作要有加载状态和错误处理
5. 合约地址和 ABI 通过配置管理，支持多网络切换
6. NFT 元数据和图片存储在 IPFS，不要用中心化存储
7. Gas 费用估算要展示给用户
8. 钱包未连接时优雅降级，引导用户连接
9. 新增依赖前先说明
