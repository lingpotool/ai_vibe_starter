<script setup lang="ts">
import { useAppStore } from '@/stores/app'
import type { PlatformStyle } from '@/stores/app'
import { useI18n } from 'vue-i18n'
import { ref, onMounted } from 'vue'
import SettingsPanel from '@/components/ui/SettingsPanel.vue'
import SettingsItem from '@/components/ui/SettingsItem.vue'

const appStore = useAppStore()
const { t, locale } = useI18n()
const appVersion = ref('')

onMounted(async () => {
  try { appVersion.value = await window.api.system.getVersion() } catch { /* */ }
})

function handleLocaleChange(lang: string) {
  appStore.setLocale(lang as 'zh-CN' | 'en-US')
  locale.value = lang
}

function handlePlatformChange(val: string) {
  appStore.setPlatformStyle(val as PlatformStyle)
}
</script>

<template>
  <div class="max-w-2xl space-y-4 animate-fade-in">
    <!-- Appearance -->
    <SettingsPanel :title="t('settings.appearance')">
      <SettingsItem :label="t('settings.darkMode')" :description="t('settings.darkModeDesc')">
        <el-switch
          :model-value="appStore.isDark"
          @change="appStore.toggleTheme"
          :active-text="t('settings.dark')"
          :inactive-text="t('settings.light')"
          inline-prompt
        />
      </SettingsItem>

      <SettingsItem :label="t('settings.sidebar')" :description="t('settings.sidebarDesc')">
        <el-switch
          :model-value="appStore.sidebarCollapsed"
          @change="appStore.toggleSidebar"
          :active-text="t('settings.collapsed')"
          :inactive-text="t('settings.expanded')"
          inline-prompt
        />
      </SettingsItem>

      <SettingsItem :label="t('settings.language')" :description="t('settings.languageDesc')">
        <el-select
          :model-value="appStore.locale"
          @change="handleLocaleChange"
          size="small"
          style="width: 140px"
        >
          <el-option label="简体中文" value="zh-CN" />
          <el-option label="English" value="en-US" />
        </el-select>
      </SettingsItem>

      <SettingsItem :label="t('settings.platformStyle')" :description="t('settings.platformStyleDesc')">
        <el-select
          :model-value="appStore.platformStyle"
          @change="handlePlatformChange"
          size="small"
          style="width: 140px"
        >
          <el-option :label="t('settings.platformAuto')" value="auto" />
          <el-option label="Windows" value="windows" />
          <el-option label="macOS" value="macos" />
        </el-select>
      </SettingsItem>
    </SettingsPanel>

    <!-- About -->
    <SettingsPanel :title="t('settings.about')">
      <div class="px-5 py-4 space-y-3">
        <div class="flex justify-between items-center text-[13px]">
          <span :style="{ color: 'var(--color-content-secondary)' }">{{ t('settings.version') }}</span>
          <span class="font-mono text-[12px] px-2 py-0.5 rounded-[5px]"
            :style="{ color: 'var(--color-content)', background: 'var(--color-surface-secondary)' }">
            {{ appVersion || '0.1.0' }}
          </span>
        </div>
        <div class="flex justify-between items-center text-[13px]">
          <span :style="{ color: 'var(--color-content-secondary)' }">Electron</span>
          <span class="font-mono text-[12px] px-2 py-0.5 rounded-[5px]"
            :style="{ color: 'var(--color-content)', background: 'var(--color-surface-secondary)' }">
            33.x
          </span>
        </div>
        <div class="flex justify-between items-center text-[13px]">
          <span :style="{ color: 'var(--color-content-secondary)' }">Vue</span>
          <span class="font-mono text-[12px] px-2 py-0.5 rounded-[5px]"
            :style="{ color: 'var(--color-content)', background: 'var(--color-surface-secondary)' }">
            3.5.x
          </span>
        </div>
        <div class="flex justify-between items-center text-[13px]">
          <span :style="{ color: 'var(--color-content-secondary)' }">{{ t('settings.currentPlatform') }}</span>
          <span class="font-mono text-[12px] px-2 py-0.5 rounded-[5px]"
            :style="{ color: 'var(--color-primary-500)', background: 'var(--color-primary-50)' }">
            {{ appStore.effectivePlatform }}
          </span>
        </div>
      </div>
    </SettingsPanel>
  </div>
</template>
