# Surface 上安装 Manjaro KDE Plasma + Windows 11 双系统的指南

**说明：Surface 专有部分自 2021.9.5 起不再更新，以下为最终版 Surface Pro 6 信息**

```
OS: Manjaro 21.1.1 Pahvo
Kernel: x86_64 Linux 5.14.0-0-MANJARO/x86_64 Linux 5.13.13-arch1-3-surface
Resolution: 2736x1824
DE: KDE 5.85.0 / Plasma 5.22.5
WM: KWin
CPU: Intel Core i5-8250U @ 8x 3.4GHz
GPU: Mesa Intel(R) UHD Graphics 620 (KBL GT2)
```

### **UEFI 设置**

#### **进入 UEFI 设置**

长按 Surface 上的调高音量按钮，同时按下再松开电源按钮，此时屏幕上会显示 Microsoft 或 Surface 徽标，继续按住调高音量按钮，显示 UEFI 界面后，松开此按钮即可

#### **关闭 Secure Boot**

Security >> Secure Boot >> Disabled

### **在 UEFI 中设置启动顺序和启动设备**

Boot Configuration >> Configure boot device order 中可以调整和删除启动顺序

启动后进入 UEFI 界面后选择 Boot configuration，然后按住对应的设备（如 USB Storage）选项并左滑即可从该设备启动

### **Linux-Surface 内核安装（可选）**

**[Linux-Surface](https://github.com/linux-surface/linux-surface) 内核可以实现一些官方内核不支持的功能。官方内核从 Linux 5.13 开始已经支持 Surface 的电池组件（旧版内核不支持，无法显示电池电量状态），但不支持触屏，相关支持情况详见 [Linux-Surface -- Feature Matrix](https://github.com/linux-surface/linux-surface/wiki/Supported-Devices-and-Features#feature-matrix)**

在终端中输入：

```bash
curl -s https://raw.githubusercontent.com/linux-surface/linux-surface/master/pkg/keys/surface.asc \| sudo pacman-key --add -
```

如果出现错误或没有响应，一般是网络问题，可能要等待几分钟，建议先配置好 VPN 再装内核

接着输入：

```bash
sudo pacman-key --finger 56C464BAAC421453
sudo pacman-key --lsign-key 56C464BAAC421453
```

在 `/etc/pacman.conf` 里面添加：

```
[linux-surface]
Server = https://pkg.surfacelinux.com/arch/
```

然后更新软件库并下载：

```bash
sudo pacman -Syyu
sudo pacman -S linux-surface linux-surface-headers iptsd-git
```

启动触屏：

```bash
sudo systemctl enable iptsd
```

启动相机参考以下网址：（相机功能仍在开发中，可能出现配置失败的情况）

[Linux-Surface -- Camera Support](https://github.com/linux-surface/linux-surface/wiki/Camera-Support)

KDE 上原生的相机应用是 Kamoso，也可以使用 GNOME 上的相机应用 Cheese

**Firefox 启用触屏需要在 `/etc/environment` 中写入 `MOZ_USE_XINPUT2=1`，然后重新启动，并在 about:config 中设置 `apz.allow_zooming` 和 `apz.allow_zooming_out` 为 `true`；Visual Studio Code 启用触屏需要更改 `/usr/share/applications/visual-studio-code.desktop`，在 `Exec` 一行中加入命令 `--touch-events`，这一般对以 Electron 为基础的软件有效**

### **Surface：能用上触控笔的软件（可选）**

#### **绘画**

```bash
pamac install krita
```

#### **手写笔记**

可以选择 Xournal++ 或者 Write

```bash
pamac install xournalpp
pamac install write_stylus
```

### **Surface：屏幕键盘（可选）**

目前最受欢迎的屏幕键盘应该是 OnBoard

```bash
pamac install onboard
```

但 OnBoard 在 Wayland 上无法使用。如果需要在 Wayland 会话中使用屏幕键盘，推荐安装 CellWriter

```bash
pamac install cellwriter
```