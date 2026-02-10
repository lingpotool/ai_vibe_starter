import { IPC_CHANNELS } from '@shared/constants/ipc-channels'
import { registerHandler } from '../../core/ipc-registry'
import * as systemService from './system.service'

export function register(): void {
  const CH = IPC_CHANNELS.SYSTEM

  registerHandler(CH.GET_VERSION, () => systemService.getVersion())
  registerHandler(CH.GET_PLATFORM, () => systemService.getPlatform())

  registerHandler(CH.OPEN_EXTERNAL, (_e, url: unknown) => systemService.openExternal(url as string))
  registerHandler(CH.SHOW_ITEM_IN_FOLDER, (_e, path: unknown) => systemService.showItemInFolder(path as string))

  registerHandler(CH.READ_CLIPBOARD, () => systemService.readClipboard())
  registerHandler(CH.WRITE_CLIPBOARD, (_e, text: unknown) => systemService.writeClipboard(text as string))

  registerHandler(CH.SHOW_OPEN_DIALOG, (_e, options: unknown) => systemService.showOpenDialog(options as any))
  registerHandler(CH.SHOW_SAVE_DIALOG, (_e, options: unknown) => systemService.showSaveDialog(options as any))
  registerHandler(CH.SHOW_MESSAGE_BOX, (_e, options: unknown) => systemService.showMessageBox(options as any))
  registerHandler(CH.SHOW_NOTIFICATION, (_e, options: unknown) => systemService.showNotification(options as any))

  registerHandler(CH.REGISTER_SHORTCUT, (_e, accelerator: unknown, id: unknown) =>
    systemService.registerShortcut(accelerator as string, id as string)
  )
  registerHandler(CH.UNREGISTER_SHORTCUT, (_e, id: unknown) => systemService.unregisterShortcut(id as string))
}
