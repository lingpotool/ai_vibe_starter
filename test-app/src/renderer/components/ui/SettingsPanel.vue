<script setup lang="ts">
defineProps<{ title: string }>()
</script>

<template>
  <div
    class="rounded-[12px] overflow-hidden"
    :style="{
      background: 'var(--color-surface)',
      border: '1px solid var(--color-border)',
      boxShadow: 'var(--shadow-card)',
    }"
  >
    <div class="px-5 py-3" :style="{ borderBottom: '1px solid var(--color-border)' }">
      <span class="text-[13px] font-semibold" :style="{ color: 'var(--color-content)' }">{{ title }}</span>
    </div>
    <slot />
  </div>
</template>
