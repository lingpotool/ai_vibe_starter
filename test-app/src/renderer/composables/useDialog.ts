import type { OpenDialogOptions, SaveDialogOptions, MessageBoxOptions } from '@shared/types/ipc.types'

export function useDialog() {
  return {
    openFile: (options?: OpenDialogOptions) =>
      window.api.system.showOpenDialog((options ?? {}) as Record<string, unknown>),
    saveFile: (options?: SaveDialogOptions) =>
      window.api.system.showSaveDialog((options ?? {}) as Record<string, unknown>),
    messageBox: (options: MessageBoxOptions) =>
      window.api.system.showMessageBox(options as unknown as Record<string, unknown>),
  }
}
