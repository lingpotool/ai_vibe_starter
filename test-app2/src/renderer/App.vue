<script setup lang="ts">
import AppLayout from '@/components/layout/AppLayout.vue'
import { useAppStore } from '@/stores/app'

// Initialize store (triggers persisted state restore + theme apply)
const appStore = useAppStore()
</script>

<template>
  <AppLayout />
</template>
