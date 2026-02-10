<script setup lang="ts">
defineProps<{
  label: string
  value: string | number
  gradient?: string
}>()
</script>

<template>
  <div
    class="rounded-[12px] p-4 transition-all duration-200"
    :style="{
      background: 'var(--color-surface)',
      border: '1px solid var(--color-border)',
      boxShadow: 'var(--shadow-card)',
    }"
  >
    <div class="flex items-center gap-3">
      <div
        class="w-10 h-10 rounded-[10px] flex items-center justify-center bg-gradient-to-br text-white flex-shrink-0"
        :class="gradient || 'from-blue-400 to-blue-600'"
      >
        <slot name="icon" />
      </div>
      <div class="min-w-0">
        <div class="text-[20px] font-semibold leading-tight" :style="{ color: 'var(--color-content)' }">{{ value }}</div>
        <div class="text-[11px] mt-0.5" :style="{ color: 'var(--color-content-tertiary)' }">{{ label }}</div>
      </div>
    </div>
  </div>
</template>
