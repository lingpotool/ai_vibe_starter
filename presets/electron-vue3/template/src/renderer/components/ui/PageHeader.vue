<script setup lang="ts">
defineProps<{
  title: string
  description?: string
}>()
</script>

<template>
  <div class="flex items-center justify-between mb-5">
    <div>
      <h1 class="text-lg font-semibold" :style="{ color: 'var(--color-content)' }">
        {{ title }}
      </h1>
      <p v-if="description" class="text-sm mt-0.5" :style="{ color: 'var(--color-content-tertiary)' }">
        {{ description }}
      </p>
    </div>
    <div class="flex items-center gap-2">
      <slot name="actions" />
    </div>
  </div>
</template>
