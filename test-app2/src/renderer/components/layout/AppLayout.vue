<script setup lang="ts">
import NavRail from './NavRail.vue'
import { useAppStore } from '@/stores/app'
import { useI18n } from 'vue-i18n'
import { watch, onMounted } from 'vue'

const appStore = useAppStore()
const { locale } = useI18n()

watch(() => appStore.locale, (v) => { locale.value = v }, { immediate: true })

onMounted(() => {
  appStore.detectPlatform()
})
</script>

<template>
  <div class="relative flex h-screen overflow-hidden">
    <!--
      底层渐变背景 — 给玻璃态提供可透出的内容
      用微妙的色彩 mesh 渐变，不抢眼但让模糊有层次
    -->
    <div class="absolute inset-0 bg-background">
      <div class="absolute inset-0 bg-[radial-gradient(ellipse_at_top_left,oklch(0.85_0.06_260/20%)_0%,transparent_50%)]" />
      <div class="absolute inset-0 bg-[radial-gradient(ellipse_at_bottom_right,oklch(0.85_0.06_300/15%)_0%,transparent_50%)]" />
      <div class="absolute inset-0 bg-[radial-gradient(ellipse_at_top_right,oklch(0.9_0.04_200/10%)_0%,transparent_40%)]" />
    </div>
    <div class="dark:block hidden absolute inset-0 bg-background">
      <div class="absolute inset-0 bg-[radial-gradient(ellipse_at_top_left,oklch(0.3_0.08_260/20%)_0%,transparent_50%)]" />
      <div class="absolute inset-0 bg-[radial-gradient(ellipse_at_bottom_right,oklch(0.3_0.06_300/15%)_0%,transparent_50%)]" />
      <div class="absolute inset-0 bg-[radial-gradient(ellipse_at_center,oklch(0.25_0.04_260/10%)_0%,transparent_60%)]" />
    </div>

    <!-- NavRail — glass sidebar -->
    <NavRail class="relative z-10" />

    <!-- Main content area -->
    <div class="relative z-10 flex min-w-0 flex-1 flex-col overflow-hidden">
      <!-- Draggable titlebar -->
      <div class="titlebar-drag h-11 w-full shrink-0" />

      <!-- Page content -->
      <main class="relative flex-1 overflow-auto px-8 pb-8">
        <router-view v-slot="{ Component }">
          <transition name="page" mode="out-in">
            <component :is="Component" />
          </transition>
        </router-view>
      </main>
    </div>
  </div>
</template>
