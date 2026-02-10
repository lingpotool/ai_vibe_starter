/**
 * IPC Channel 常量 — 所有跨进程通信的 channel 名称集中管理
 * 命名规则：MODULE:ACTION
 * 新增 IPC 通道只需在这里添加常量 + 在 ipc.types.ts 添加类型
 */
export const IPC_CHANNELS = {
  WINDOW: {
    MINIMIZE: 'window:minimize',
    MAXIMIZE: 'window:maximize',
    CLOSE: 'window:close',
    IS_MAXIMIZED: 'window:isMaximized',
    ON_MAXIMIZE_CHANGE: 'window:onMaximizeChange',
  },
  STORAGE: {
    GET: 'storage:get',
    SET: 'storage:set',
    DELETE: 'storage:delete',
    HAS: 'storage:has',
  },
  SYSTEM: {
    GET_VERSION: 'system:getVersion',
    GET_PLATFORM: 'system:getPlatform',
    OPEN_EXTERNAL: 'system:openExternal',
    SHOW_ITEM_IN_FOLDER: 'system:showItemInFolder',
    READ_CLIPBOARD: 'system:readClipboard',
    WRITE_CLIPBOARD: 'system:writeClipboard',
    SHOW_OPEN_DIALOG: 'system:showOpenDialog',
    SHOW_SAVE_DIALOG: 'system:showSaveDialog',
    SHOW_MESSAGE_BOX: 'system:showMessageBox',
    SHOW_NOTIFICATION: 'system:showNotification',
    REGISTER_SHORTCUT: 'system:registerShortcut',
    UNREGISTER_SHORTCUT: 'system:unregisterShortcut',
  },
} as const
