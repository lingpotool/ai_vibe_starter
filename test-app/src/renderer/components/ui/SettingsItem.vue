<script setup lang="ts">
defineProps<{ label: string; description?: string }>()
</script>

<template>
  <div class="flex items-center justify-between px-5 py-3.5" :style="{ borderBottom: '1px solid var(--color-border-light)' }">
    <div class="min-w-0 mr-4">
      <div class="text-[13px]" :style="{ color: 'var(--color-content)' }">{{ label }}</div>
      <div v-if="description" class="text-[11px] mt-0.5" :style="{ color: 'var(--color-content-tertiary)' }">{{ description }}</div>
    </div>
    <div class="flex-shrink-0"><slot /></div>
  </div>
</template>
