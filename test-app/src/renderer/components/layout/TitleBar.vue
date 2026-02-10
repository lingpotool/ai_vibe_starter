<script setup lang="ts">
/**
 * 标题栏 — 仅作为拖拽区域
 * Windows: 系统通过 titleBarOverlay 绘制原生窗口控制按钮
 * macOS: 系统通过 hiddenInset 绘制原生红绿灯按钮
 * 不需要自己画任何窗口控制按钮
 */
</script>

<template>
  <div
    class="titlebar-drag h-12 w-full shrink-0"
    :style="{ background: 'var(--titlebar-bg)' }"
  />
</template>
