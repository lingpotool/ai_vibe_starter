<script setup lang="ts">
defineProps<{
  loading: boolean
  fullscreen?: boolean
}>()
</script>

<template>
  <Teleport v-if="fullscreen" to="body">
    <Transition name="fade">
      <div
        v-if="loading"
        class="fixed inset-0 z-[9999] flex items-center justify-center bg-black/20 backdrop-blur-sm"
      >
        <div class="flex flex-col items-center gap-3">
          <div class="w-8 h-8 border-2 border-current border-t-transparent rounded-full animate-spin"
            :style="{ color: 'var(--color-primary-500)' }"
          />
        </div>
      </div>
    </Transition>
  </Teleport>

  <div v-if="!fullscreen" class="relative">
    <slot />
    <Transition name="fade">
      <div
        v-if="loading"
        class="absolute inset-0 z-10 flex items-center justify-center rounded-xl"
        :style="{ background: 'var(--color-surface-elevated)' }"
      >
        <div class="w-6 h-6 border-2 border-current border-t-transparent rounded-full animate-spin"
          :style="{ color: 'var(--color-primary-500)' }"
        />
      </div>
    </Transition>
  </div>
</template>

<style scoped>
.fade-enter-active, .fade-leave-active {
  transition: opacity 200ms ease;
}
.fade-enter-from, .fade-leave-to {
  opacity: 0;
}
</style>
