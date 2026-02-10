<script setup lang="ts">
import { ref } from 'vue'

const isHovering = ref(false)

function minimize() { window.api.window.minimize() }
function maximize() { window.api.window.maximize() }
function close() { window.api.window.close() }
</script>

<template>
  <div
    class="titlebar-no-drag flex items-center gap-2"
    @mouseenter="isHovering = true"
    @mouseleave="isHovering = false"
  >
    <!-- Close -->
    <button
      class="w-3 h-3 rounded-full bg-[#ff5f57] flex items-center justify-center transition-all hover:brightness-90 active:brightness-75"
      @click="close"
    >
      <svg v-if="isHovering" width="6" height="6" viewBox="0 0 6 6" fill="none" stroke="#4d0000" stroke-width="1.2">
        <line x1="0.5" y1="0.5" x2="5.5" y2="5.5" /><line x1="5.5" y1="0.5" x2="0.5" y2="5.5" />
      </svg>
    </button>
    <!-- Minimize -->
    <button
      class="w-3 h-3 rounded-full bg-[#febc2e] flex items-center justify-center transition-all hover:brightness-90 active:brightness-75"
      @click="minimize"
    >
      <svg v-if="isHovering" width="6" height="1" viewBox="0 0 6 1" fill="#995700"><rect width="6" height="1" /></svg>
    </button>
    <!-- Maximize -->
    <button
      class="w-3 h-3 rounded-full bg-[#28c840] flex items-center justify-center transition-all hover:brightness-90 active:brightness-75"
      @click="maximize"
    >
      <svg v-if="isHovering" width="6" height="6" viewBox="0 0 6 6" fill="none" stroke="#006500" stroke-width="0.8">
        <path d="M0.5 3.5L0.5 0.5L3.5 0.5M5.5 2.5L5.5 5.5L2.5 5.5" />
      </svg>
    </button>
  </div>
</template>
