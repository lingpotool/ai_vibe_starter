<script setup lang="ts">
import { useAppStore } from '@/stores/app'
import { useI18n } from 'vue-i18n'
import { ref, onMounted } from 'vue'

const appStore = useAppStore()
const { t, locale } = useI18n()
const appVersion = ref('')

onMounted(async () => {
  try { appVersion.value = await window.api.system.getVersion() } catch { /* */ }
})

function handleLocaleChange(e: Event) {
  const lang = (e.target as HTMLSelectElement).value
  appStore.setLocale(lang as 'zh-CN' | 'en-US')
  locale.value = lang
}

const techStack = [
  { label: 'Electron', value: '40.x' },
  { label: 'Vue', value: '3.5.x' },
  { label: 'Tailwind CSS', value: '4.x' },
  { label: 'TypeScript', value: '5.x' },
]
</script>

<template>
  <div class="mx-auto max-w-2xl space-y-5 animate-fade-in">
    <!-- Page header -->
    <div class="space-y-1">
      <h1 class="text-2xl font-semibold tracking-tight text-foreground">{{ t('settings.title') }}</h1>
      <p class="text-sm text-muted-foreground">{{ t('settings.appearance') }}</p>
    </div>

    <!-- Appearance — glass card -->
    <div class="glass-card rounded-xl bg-card overflow-hidden">
      <!-- Dark mode -->
      <div class="flex items-center justify-between border-b border-border/50 px-5 py-4">
        <div class="space-y-0.5">
          <div class="text-sm font-medium text-card-foreground">{{ t('settings.darkMode') }}</div>
          <div class="text-xs text-muted-foreground">{{ t('settings.darkModeDesc') }}</div>
        </div>
        <button
          class="relative inline-flex h-[22px] w-[42px] shrink-0 cursor-pointer rounded-full
                 transition-colors duration-200 focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2"
          :class="appStore.isDark ? 'bg-primary' : 'bg-input'"
          role="switch"
          :aria-checked="appStore.isDark"
          @click="appStore.toggleTheme"
        >
          <span
            class="pointer-events-none block h-[18px] w-[18px] rounded-full bg-white shadow-[0_1px_3px_oklch(0_0_0/20%)]
                   ring-0 transition-transform duration-200"
            :style="{ transform: appStore.isDark ? 'translateX(22px)' : 'translateX(2px)' }"
          />
        </button>
      </div>

      <!-- Language -->
      <div class="flex items-center justify-between px-5 py-4">
        <div class="space-y-0.5">
          <div class="text-sm font-medium text-card-foreground">{{ t('settings.language') }}</div>
          <div class="text-xs text-muted-foreground">{{ t('settings.languageDesc') }}</div>
        </div>
        <select
          :value="appStore.locale"
          class="h-8 appearance-none rounded-lg border border-input bg-card/50 pl-3 pr-8 text-sm text-foreground
                 shadow-[0_1px_2px_oklch(0_0_0/5%)]
                 transition-all duration-150
                 focus:outline-none focus:ring-2 focus:ring-ring/30 focus:border-ring
                 hover:border-ring/50
                 bg-[url('data:image/svg+xml;charset=utf-8,%3Csvg%20xmlns%3D%22http%3A%2F%2Fwww.w3.org%2F2000%2Fsvg%22%20width%3D%2212%22%20height%3D%2212%22%20viewBox%3D%220%200%2024%2024%22%20fill%3D%22none%22%20stroke%3D%22%23999%22%20stroke-width%3D%222%22%3E%3Cpath%20d%3D%22m6%209%206%206%206-6%22%2F%3E%3C%2Fsvg%3E')]
                 bg-[length:12px] bg-[right_8px_center] bg-no-repeat"
          @change="handleLocaleChange"
        >
          <option value="zh-CN">简体中文</option>
          <option value="en-US">English</option>
        </select>
      </div>
    </div>

    <!-- About — glass card -->
    <div class="glass-card rounded-xl bg-card overflow-hidden">
      <div class="border-b border-border/50 px-5 py-3.5">
        <span class="text-sm font-semibold text-card-foreground">{{ t('settings.about') }}</span>
      </div>
      <div class="divide-y divide-border/30">
        <div class="flex items-center justify-between px-5 py-3">
          <span class="text-sm text-muted-foreground">{{ t('settings.version') }}</span>
          <span class="font-mono text-xs px-2 py-1 rounded-md bg-muted/50 text-foreground">
            {{ appVersion || '0.1.0' }}
          </span>
        </div>
        <div
          v-for="tech in techStack"
          :key="tech.label"
          class="flex items-center justify-between px-5 py-3"
        >
          <span class="text-sm text-muted-foreground">{{ tech.label }}</span>
          <span class="font-mono text-xs px-2 py-1 rounded-md bg-muted/50 text-foreground">{{ tech.value }}</span>
        </div>
        <div class="flex items-center justify-between px-5 py-3">
          <span class="text-sm text-muted-foreground">{{ t('settings.currentPlatform') }}</span>
          <span class="font-mono text-xs px-2 py-1 rounded-md bg-primary/10 text-primary font-medium">
            {{ appStore.platform }}
          </span>
        </div>
      </div>
    </div>
  </div>
</template>
