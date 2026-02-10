import type { RouteRecordRaw } from 'vue-router'

// 示例：如何添加新的路由模块
// 1. 在此目录下创建新的 .ts 文件
// 2. 导出路由数组，会自动注册到路由中
// 3. meta.title 用于侧边栏菜单显示
// 4. meta.icon 用于菜单图标（Element Plus 图标名）

const routes: RouteRecordRaw[] = [
  // 取消下面的注释可以添加示例页面
  // {
  //   path: '/example',
  //   name: 'Example',
  //   component: () => import('@/views/example/index.vue'),
  //   meta: {
  //     title: '示例页面',
  //     icon: 'Document'
  //   }
  // }
]

export default routes
