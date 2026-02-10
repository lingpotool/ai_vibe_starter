<script setup lang="ts">
defineProps<{
  title?: string
  description?: string
}>()
</script>

<template>
  <div class="flex flex-col items-center justify-center py-16 px-4">
    <div
      class="w-16 h-16 rounded-2xl flex items-center justify-center mb-4"
      :style="{ background: 'var(--color-surface-secondary)' }"
    >
      <slot name="icon">
        <svg class="w-8 h-8" :style="{ color: 'var(--color-content-tertiary)' }" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5">
          <path d="M20 7l-8-4-8 4m16 0l-8 4m8-4v10l-8 4m0-10L4 7m8 4v10M4 7v10l8 4" />
        </svg>
      </slot>
    </div>
    <h3 v-if="title" class="text-sm font-medium mb-1" :style="{ color: 'var(--color-content)' }">
      {{ title }}
    </h3>
    <p v-if="description" class="text-xs text-center max-w-xs" :style="{ color: 'var(--color-content-tertiary)' }">
      {{ description }}
    </p>
    <div class="mt-4">
      <slot name="action" />
    </div>
  </div>
</template>
