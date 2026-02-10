<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { useI18n } from 'vue-i18n'
import { APP_CONFIG } from '@/config/app'

const { t } = useI18n()
const appVersion = ref('')

onMounted(async () => {
  try { appVersion.value = await window.api.system.getVersion() } catch { /* */ }
})

const stats = [
  { labelKey: 'home.stats.activeToday', value: '1,234', icon: 'activity', color: 'text-blue-500 dark:text-blue-400' },
  { labelKey: 'home.stats.totalTasks', value: '56', icon: 'tasks', color: 'text-emerald-500 dark:text-emerald-400' },
  { labelKey: 'home.stats.completion', value: '89%', icon: 'check', color: 'text-violet-500 dark:text-violet-400' },
  { labelKey: 'home.stats.pending', value: '12', icon: 'clock', color: 'text-amber-500 dark:text-amber-400' },
]

const steps = [
  { key: 'home.step1', code: 'src/renderer/views/' },
  { key: 'home.step2', code: 'src/renderer/router/modules/' },
  { key: 'home.step3', code: '' },
  { key: 'home.step4', code: 'src/main/modules/' },
]
</script>

<template>
  <div class="max-w-3xl space-y-6 animate-fade-in">
    <!-- Header -->
    <div class="space-y-1">
      <h1 class="text-2xl font-semibold tracking-tight text-foreground">
        {{ t('home.welcome') }} {{ APP_CONFIG.name }}
      </h1>
      <p class="text-sm text-muted-foreground">
        {{ t('home.description') }}
        <span class="ml-1.5 inline-flex items-center rounded-md bg-card glass-subtle px-1.5 py-0.5 font-mono text-xs text-muted-foreground border border-border">
          v{{ appVersion || '0.1.0' }}
        </span>
      </p>
    </div>

    <!-- Stats — glass cards -->
    <div class="grid grid-cols-4 gap-3">
      <div
        v-for="(stat, i) in stats"
        :key="stat.labelKey"
        class="group glass-card rounded-xl bg-card p-4 transition-all duration-200
               hover:translate-y-[-1px] hover:shadow-[0_4px_20px_oklch(0_0_0/6%),0_1px_3px_oklch(0_0_0/4%)]
               animate-slide-up"
        :style="{ animationDelay: `${i * 50}ms` }"
      >
        <div class="flex items-center justify-between mb-3">
          <span class="text-xs font-medium text-muted-foreground">{{ t(stat.labelKey) }}</span>
          <div :class="['flex h-7 w-7 items-center justify-center rounded-lg bg-muted/50 transition-colors group-hover:bg-muted', stat.color]">
            <svg class="h-3.5 w-3.5" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round">
              <template v-if="stat.icon === 'activity'">
                <polyline points="22 12 18 12 15 21 9 3 6 12 2 12" />
              </template>
              <template v-else-if="stat.icon === 'tasks'">
                <rect x="3" y="3" width="18" height="18" rx="2" />
                <path d="M9 12l2 2 4-4" />
              </template>
              <template v-else-if="stat.icon === 'check'">
                <path d="M22 11.08V12a10 10 0 11-5.93-9.14" />
                <polyline points="22 4 12 14.01 9 11.01" />
              </template>
              <template v-else>
                <circle cx="12" cy="12" r="10" />
                <polyline points="12 6 12 12 16 14" />
              </template>
            </svg>
          </div>
        </div>
        <div class="text-2xl font-semibold tracking-tight text-card-foreground">{{ stat.value }}</div>
      </div>
    </div>

    <!-- Quick start — glass card -->
    <div class="glass-card rounded-xl bg-card">
      <div class="border-b border-border px-5 py-3.5">
        <h3 class="text-sm font-semibold text-card-foreground">{{ t('home.quickStart') }}</h3>
      </div>
      <div class="p-5 space-y-3.5">
        <div
          v-for="(step, index) in steps"
          :key="step.key"
          class="flex items-start gap-3 animate-slide-up"
          :style="{ animationDelay: `${(index + 4) * 50}ms` }"
        >
          <div class="flex h-6 w-6 shrink-0 items-center justify-center rounded-full bg-primary/10 mt-px">
            <span class="text-[11px] font-semibold text-primary">{{ index + 1 }}</span>
          </div>
          <div class="text-sm leading-relaxed text-muted-foreground pt-0.5">
            {{ t(step.key) }}
            <code
              v-if="step.code"
              class="ml-1 rounded-md bg-muted/60 px-1.5 py-0.5 font-mono text-xs text-foreground"
            >{{ step.code }}</code>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>
