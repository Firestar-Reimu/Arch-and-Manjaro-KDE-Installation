# Manjaro 系统安装

**说明：Manjaro 专有部分自 2022.9.5 起不再更新，以下为最终版 ThinkPad X13 Intel 信息**

```text
OS: Manjaro 21.2.6 Qonos
Kernel: x86_64 Linux 5.19.4-1-MANJARO
Resolution: 2560x1600
DE: KDE 5.97.0 / Plasma 5.25.4
WM: KWin
CPU: 11th Gen Intel Core i7-1165G7 @ 8x 4.7GHz
GPU: Mesa Intel(R) Xe Graphics (TGL GT2)
```

### **下载 Manjaro 系统 ISO 镜像**

#### **Manjaro 官网下载**

此处所有 ISO 镜像均为 stable 分支：

https://manjaro.org/get-manjaro/ （所有官方版本）

https://manjaro.org/downloads/official/kde/ （KDE Plasma 版本）

#### **GitHub 下载**

可以在 GitHub 上下载测试版的 ISO 镜像：

https://github.com/manjaro/release-review/releases （所有官方版本，testing 分支）

https://github.com/manjaro-plasma/download/releases （KDE Plasma 版本，unstable 分支）

#### **本地制作 ISO 镜像**

还可以用下面的方法在一台 Manjaro Linux 设备上制作自定义的 ISO 镜像：

[Manjaro Wiki -- Build Manjaro ISOs with buildiso](https://wiki.manjaro.org/index.php/Build_Manjaro_ISOs_with_buildiso)

制作之前需要下载软件 `manjaro-tools-iso`，并在 `/etc/manjaro-tools/manjaro-tools.conf` 中修改镜像：

```bash
build_mirror=https://mirrors.tuna.tsinghua.edu.cn/manjaro/
```

命令为：`buildiso -p kde -b testing -k linux(version_number)`，整个过程大约需要 10 分钟

#### **通过 GitHub Actions 制作 ISO 镜像**

还可以用下面的方法通过 GitHub Actions 制作自定义的 ISO 镜像，参考以下网址：

[YouTube -- Building your custom Manjaro ISO via Github Actions CI](https://www.youtube.com/watch?v=S2t5Iat37CI)

### **安装 Manjaro**

语言选择“简体中文”

时区选择“Asia >> Shanghai”

键盘设置选择“Chinese >> Default”

安装时选择“替代一个分区”，并点击之前空出来的空分区

或者手动挂载空分区，挂载点设为 `/`，标记为 `root`，手动挂载 UEFI 分区（即第一个分区 `/dev/nvme0n1p1`，格式为 FAT32），不要格式化，挂载点设为 `/boot/efi`，标记为 `boot`

用户名建议全部用小写字母并与登录时的用户名一致

设置密码，并勾选“为管理员使用相同的密码”

### **Manjaro：选择镜像并切换更新分支**

Manjaro 预装了一个镜像和更新分支的选择器 `pacman-mirrors`，其使用教程参考以下网址：

[Manjaro Wiki -- Pacman-mirrors](https://wiki.manjaro.org/index.php/Pacman-mirrors)

[Manjaro Wiki -- Switching Branches](https://wiki.manjaro.org/index.php/Switching_Branches)

选择中国国内镜像，开启图形界面交互的命令为：

```bash
sudo pacman-mirrors -ic China
```

切换更新分支的命令为：（不要漏掉 `-a`）

```bash
sudo pacman-mirrors -aS (branch)
sudo pacman -Syyu
```

更新分支 `(branch)` 可以选择 `stable / testing / unstable`

获取更新分支的命令为：

```bash
sudo pacman-mirrors -G
```

选择镜像并切换更新分支的命令则为：

```bash
sudo pacman-mirrors -aS (branch) -ic China
```

切换更新分支后更新软件包缓存：

```text
sudo pacman -Syyu
```

**由于 Manjaro 的更新滞后于 Arch，使用 Arch Linux CN 仓库可能会出现“部分更新”的情况，导致某些软件包损坏，建议切换到 testing 或 unstable 分支以尽量跟进 Arch 的更新**

### **Manjaro：硬件管理**

硬件管理的包管理器是 `mhwd` 和 `mhwd-kernel`，其使用教程参考以下网址：

[Manjaro Wiki -- Manjaro Hardware Detection Overview](https://wiki.manjaro.org/index.php/Manjaro_Hardware_Detection_Overview)

[Manjaro Wiki -- Configure Graphics Cards](https://wiki.manjaro.org/index.php/Configure_Graphics_Cards)

[Manjaro Wiki -- Manjaro Kernels](https://wiki.manjaro.org/index.php/Manjaro_Kernels)

这两个也可以在 Manjaro Settings Manager（GUI 版本）中使用

### **Manjaro：语言包**

系统设置 >> 语言包 >> 右上角点击“已安装的软件包”安装语言包

### **Manjaro：中文输入法**

Manjaro 提供了 `manjaro-asian-input-support-fcitx` 和 `manjaro-asian-input-support-fcitx5`，下载 Fcitx/Fcitx5 不需要手动写环境变量

下载 Fcitx5：

```bash
sudo pacman -S fcitx5 fcitx5-chinese-addons manjaro-asian-input-support-fcitx5
```

下载 Fcitx4：

```bash
sudo pacman -S fcitx fcitx-configtool fcitx-cloudpinyin manjaro-asian-input-support-fcitx
```

### **Manjaro：从 PulseAudio 转移到 Pipewire**

有时候从 PulseAudio 转移到 Pipewire 可以提高蓝牙耳机等的音质，方法如下：

```bash
sudo pacman -R manjaro-pulse
sudo pacman -R pulseaudio-alsa pulseaudio-bluetooth pulseaudio-ctl pulseaudio-zeroconf
sudo pacman -R plasma-pa
sudo pacman -R pulseaudio
sudo pacman -S manjaro-pipewire
sudo pacman -S plasma-pa
```

运行后重启，此时可以用命令 `aplay -L` 检查，会输出这样的信息：

```text
default
    Default ALSA Output (currently PipeWire Media Server)
```

### **Manjaro：安装软件时 PGP 密钥崩溃**

有时安装软件需要导入 PGP 密钥，如果发生错误 `invalid or corrupted package (PGP signature)`，则创建一脚本文件 `pacman_key.sh`，添加如下内容：

```bash
pacman -Sy manjaro-keyring;
for i in $(cat /usr/share/pacman/keyrings/manjaro-trusted | cut -d: -f1); do
    pacman-key -d $i;
    pacman-key -r $i;
done;
pacman -S manjaro-keyring;
```

再以 `sudo` 身份运行：

```text
sudo bash pacman_key.sh
```

### **pkgfile 报错处理**

pkgfile 依赖于 manjaro-zsh-config，如果遇到开关机的时候报错：`[FAILED] failed to start pkgfile database update`，需要在 `/usr/lib/systemd/system/pkgfile-update.timer` 的 `Timer` 一段中加入：

```text
RandomizedDelaySec=60
```

其中 60 可以改为任何足够长的秒数

### **更新 GRUB**

Manjaro 上定义了 `update-grub` 命令，用于替换 `grub-mkconfig -o /boot/grub/grub.cfg`

更新 GRUB 可以使用：

```bash
sudo update-grub
```

### **显卡驱动切换到 video-modesetting（可选）**

如果打字时桌面卡死，只有鼠标能移动，但是无法点击，可能是默认的 video-linux 显卡驱动的问题

解决办法：

卸载 video-linux：

```bash
sudo mhwd -r pci video-linux
```

下载 video-modesetting：

```bash
sudo mhwd -i pci video-modesetting
```