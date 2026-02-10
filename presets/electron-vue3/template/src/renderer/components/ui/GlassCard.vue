<script setup lang="ts">
withDefaults(defineProps<{
  blur?: number
  opacity?: number
}>(), {
  blur: 40,
  opacity: 0.72,
})
</script>

<template>
  <div
    class="rounded-[12px] transition-shadow duration-200"
    :style="{
      backdropFilter: `blur(${blur}px) saturate(180%)`,
      WebkitBackdropFilter: `blur(${blur}px) saturate(180%)`,
      background: `rgba(var(--glass-rgb), ${opacity})`,
      border: '1px solid var(--color-border)',
      boxShadow: 'var(--shadow-card)',
    }"
  >
    <slot />
  </div>
</template>
