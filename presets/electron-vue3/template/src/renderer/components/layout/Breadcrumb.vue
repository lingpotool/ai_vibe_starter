<script setup lang="ts">
import { computed } from 'vue'
import { useRouter } from 'vue-router'
import { useI18n } from 'vue-i18n'

const router = useRouter()
const { t } = useI18n()

const breadcrumbs = computed(() =>
  router.currentRoute.value.matched
    .filter((r) => r.meta?.title)
    .map((r) => ({
      path: r.path,
      title: r.meta?.titleKey ? t(r.meta.titleKey as string) : (r.meta?.title as string),
    }))
)
</script>

<template>
  <nav class="flex items-center gap-1.5 text-[12px]">
    <template v-for="(item, index) in breadcrumbs" :key="item.path">
      <svg v-if="index > 0" class="w-3 h-3" :style="{ color: 'var(--color-content-tertiary)' }" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"><path d="M9 18l6-6-6-6" /></svg>
      <span
        :style="{
          color: index === breadcrumbs.length - 1 ? 'var(--color-content)' : 'var(--color-content-tertiary)',
          fontWeight: index === breadcrumbs.length - 1 ? '500' : '400',
          cursor: index < breadcrumbs.length - 1 ? 'pointer' : 'default',
        }"
        @click="index < breadcrumbs.length - 1 && $router.push(item.path)"
      >{{ item.title }}</span>
    </template>
  </nav>
</template>
