<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { useI18n } from 'vue-i18n'
import { APP_CONFIG } from '@/config/app'
import StatCard from '@/components/ui/StatCard.vue'

const { t } = useI18n()
const appVersion = ref('')

onMounted(async () => {
  appVersion.value = await window.api.system.getVersion()
})

const stats = [
  { labelKey: 'home.stats.activeToday', value: '1,234', gradient: 'from-blue-400 to-blue-600' },
  { labelKey: 'home.stats.totalTasks', value: '56', gradient: 'from-emerald-400 to-emerald-600' },
  { labelKey: 'home.stats.completion', value: '89%', gradient: 'from-violet-400 to-violet-600' },
  { labelKey: 'home.stats.pending', value: '12', gradient: 'from-amber-400 to-amber-600' },
]

const steps = [
  { key: 'home.step1', code: 'src/renderer/views/' },
  { key: 'home.step2', code: 'src/renderer/router/modules/' },
  { key: 'home.step3', code: '' },
  { key: 'home.step4', code: 'src/main/modules/' },
]
</script>

<template>
  <div class="space-y-5 animate-fade-in">
    <!-- Welcome card -->
    <div
      class="rounded-xl p-6 text-white relative overflow-hidden"
      :style="{ background: 'linear-gradient(135deg, var(--color-primary-500), var(--color-primary-700))' }"
    >
      <div class="absolute -right-8 -top-8 w-40 h-40 rounded-full bg-white/10" />
      <div class="absolute -right-4 -bottom-12 w-32 h-32 rounded-full bg-white/5" />

      <div class="relative">
        <div class="flex items-center gap-2 mb-2">
          <h2 class="text-xl font-semibold">
            {{ t('home.welcome') }} {{ APP_CONFIG.name }}
          </h2>
          <span class="text-xs bg-white/20 px-2 py-0.5 rounded-full">
            v{{ appVersion || '0.1.0' }}
          </span>
        </div>
        <p class="text-sm text-white/80 max-w-lg">
          {{ t('home.description') }}
        </p>
      </div>
    </div>

    <!-- Stats -->
    <div class="grid grid-cols-4 gap-4">
      <StatCard
        v-for="stat in stats"
        :key="stat.labelKey"
        :label="t(stat.labelKey)"
        :value="stat.value"
        :gradient="stat.gradient"
      >
        <template #icon>
          <svg class="w-4.5 h-4.5" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
            <circle cx="12" cy="12" r="10" />
          </svg>
        </template>
      </StatCard>
    </div>

    <!-- Quick start -->
    <div
      class="rounded-xl p-5 border"
      :style="{
        background: 'var(--color-surface)',
        borderColor: 'var(--color-border-light)',
      }"
    >
      <h3 class="text-sm font-semibold mb-4" :style="{ color: 'var(--color-content)' }">
        {{ t('home.quickStart') }}
      </h3>
      <div class="space-y-3">
        <div
          v-for="(step, index) in steps"
          :key="step.key"
          class="flex items-start gap-3 animate-slide-up"
          :style="{ animationDelay: `${index * 60}ms` }"
        >
          <div
            class="w-5 h-5 rounded-full flex items-center justify-center flex-shrink-0 mt-0.5"
            :style="{ background: 'var(--color-primary-50)' }"
          >
            <span class="text-[10px] font-bold" :style="{ color: 'var(--color-primary-500)' }">{{ index + 1 }}</span>
          </div>
          <div class="text-sm leading-relaxed" :style="{ color: 'var(--color-content-secondary)' }">
            {{ t(step.key) }}
            <code
              v-if="step.code"
              class="ml-1 px-1.5 py-0.5 rounded text-[11px] font-mono"
              :style="{
                background: 'var(--color-surface-secondary)',
                color: 'var(--color-primary-500)',
              }"
            >{{ step.code }}</code>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>
