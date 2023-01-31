# **在 ThinkPad X13 2021 Intel 上安装 Arch Linux KDE Plasma + Windows 11 双系统的指南**

```
OS: Arch Linux x86_64
Kernel: x86_64 Linux 6.1.3-arch1-1
Resolution: 2560x1600
DE: KDE 5.101.0 / Plasma 5.26.5
WM: KWin
CPU: 11th Gen Intel Core i7-1165G7 @ 8x 4.7GHz
GPU: Mesa Intel(R) Xe Graphics (TGL GT2)
```

## **Windows 的准备工作**

### **下载 Arch Linux 系统 ISO 镜像**

#### **Arch Linux 官网下载**

官网的下载地址为：

[Arch Linux -- Releases](https://archlinux.org/releng/releases/)

但是只提供 Torrent 和 Magnet 链接

#### **镜像网站下载**

可以在清华大学镜像：

https://mirrors.tuna.tsinghua.edu.cn/archlinux/iso/latest/

或者上海交大镜像：

https://mirror.sjtu.edu.cn/archlinux/iso/latest/

下载到最新版的系统 ISO 镜像

#### **本地制作 ISO 镜像**

还可以用下面的方法在一台 Arch Linux 设备上制作自定义的 ISO 镜像：

[ArchWiki -- Archiso](https://wiki.archlinux.org/title/Archiso)

制作之前需要下载软件 `archiso`，然后复制配置文件：

```bash
cp -r /usr/share/archiso/configs/baseline/ (profile_directory)
```

并执行：

```bash
sudo mkarchiso (profile_directory)/baseline
```

在 `(profile_directory)` 目录的 `out` 文件夹下可以找到 ISO 镜像

### **为 Linux 系统分区**

右键点击开始菜单，选择“磁盘管理”，分出一块空分区，建议不小于 64GB

### **关闭快速启动**

Windows 工具 >> 控制面板 >> 电源选项 >> 选择电源按钮的功能 >> 更改当前不可用的设置 >> 关闭快速启动 >> 保存修改

### **关闭 Secure Boot**

#### **进入 UEFI/BIOS 设置**

ThinkPad 的操作如下：启动 ThinkPad 时按 `Enter` 打断正常开机，然后按下 `Fn+Esc` 解锁 `Fn` 按钮，再按 `Fn+F1` 进入 UEFI/BIOS 设置

#### **关闭 Secure Boot**

在 UEFI/BIOS 设置界面：

ThinkPad：Security >> Secure Boot >> Off

### **删除多余的 Windows 启动项**

如果在电脑上装有多个 Windows，则系统只会选择其中一个在 Windows Boot Manager 中启动，若要删除多余的启动项，在 Windows 的“系统配置”（搜索框中输入 `msconfig` 或在“Windows 工具”中选择）的“引导”页面即可删除

### **刻录 USB 启动盘**

#### **Windows 系统方案**

Windows 上可以用 [Rufus](https://rufus.ie/zh/)，支持 Windows 和 Linux 系统镜像，但无法在 Linux 上使用（只提供 Windows 版 EXE 可执行文件）

#### **Linux 系统方案**

Linux 上可以用命令行刻录 USB 启动盘

首先使用 `lsblk` 检查 USB 设备的名称（`NAME` 一列）和挂载点（`MOUNTPOINTS` 一列），例如 `/dev/sda`，需要设备处于插入但未挂载的状态

如果被挂载，可以用 `sudo umount (partition_name)` 或 `sudo umount (mount_point)` 卸载设备，卸载磁盘的所有被挂载的分区

例如 `sudo umount /dev/sda1` 或 `sudo umount /run/media/(user_name)/(device_label)`

之后格式化磁盘：

```bash
sudo wipefs --all /dev/sda
```

之后直接将 ISO 镜像拷贝到 USB 中（这一步需要约2分钟）：

```bash
sudo cp (iso_path)/(iso_name) /dev/sda
```

#### **跨平台方案**

推荐使用 [Ventoy](https://www.ventoy.net/cn/index.html)，在 Windows 和 Linux 上都可以使用，方法是下载安装包后解压、安装到 USB 上，之后直接将 ISO 镜像拷贝到 USB 中即可选择镜像文件进行登录系统，支持多个系统镜像登录

### **从 USB 启动**

#### **在 Windows 中设置从 USB 启动**

设置 >> 恢复 >> 立即重新启动 >> USB HDD

#### **在 UEFI 中设置从 USB 启动**

启动时按 `Enter` 打断正常开机，然后按下 `Fn+Esc` 解锁 `Fn` 按钮，再按 `Fn+F12` 选择第一个启动项为 USB HDD

## **安装系统**

### **连接到互联网**

检查确保系统已经启用了网络接口：

```bash
ip link
```

对于无线局域网（Wi-Fi）和无线广域网（WWAN），请确保网卡未被 `rfkill` 禁用

如果使用有线以太网，连接网线即可

如果使用WiFi，使用 `iwctl` 连接无线网络：

首先找到网络设备：

```bash
iwctl device list
```

获得 `device_name`，一般是 `wlan0`

```bash
iwctl station (device_name) scan
iwctl station (device_name) get-networks
iwctl station (device_name) connect (SSID)
```

也可以输入 `iwctl` 进入交互模式，此时会显示 `[iwd]#` 标志上面的命令不加 `iwctl` 输入，最后用 `exit` 推出

连接到有线或无线网络后，可以用 `ping` 测试：

```
ping -c (count_number) archlinux.org
```

### **更新系统时间**

使用 `timedatectl` 开启 NTP 同步时间，确保系统时间是准确的：

```bash
timedatectl set-ntp true
```

### **建立硬盘分区**

**对 Linux 分区建议使用 BTRFS/XFS/EXT4 文件系统**

可以使用 `lsblk` 查看硬盘 `/dev/(disk_name)`，如 `/dev/sda`、`/dev/nvme0n1` 等，前者多用于 HDD，后者多用于 SSD

修改分区可以用 `parted /dev/(disk_name)`、`cfdisk /dev/(disk_name)`、`fdisk /dev/(disk_name)` 等，下面以 `parted` 为例，注意要

使用 `parted /dev/(disk_name)` 修改分区，可以使用交互模式

`parted` 常用命令：

- `help`：帮助
- `print`：显示分区状态
- `unit`：更改单位，推荐使用 `s`（扇区）
- `set`：设置 `flag`，例如在分区 1 上创建 EFI 分区需要设置 `flag` 为 `esp`：`set 1 esp on`
- `mkpart`：创建分区，分区类型选择 `primary`，文件系统类型选择 `fat32`（对 EFI 分区），`btrfs/xfs/ext4`（对 Linux 分区），`ntfs`（对 Windows 分区）
- `resizepart`：改变分区大小
- `rm`：删除分区
- `name`：更改分区名字，比如将分区 2 改名为 `Arch`，需要设置：`name 2 'Arch'`
- `quit`：退出

更多操作参考以下网址：

[Parted User's Manual](https://www.gnu.org/software/parted/manual/parted.html)

**Windows 安装程序会创建一个 100MiB 的 EFI 系统分区，一般并不足以放下双系统所需要的所有文件（即 Linux 的 GRUB 文件），可以在将 Windows 安装到盘上之前就用 Arch 安装媒体创建一个较大的 EFI 系统分区，建议多于 256MiB，之后 Windows 安装程序将会使用你自己创建的 EFI 分区，而不是再创建一个**

### **创建文件系统**

例如，要在根分区 `/dev/(root_partition)` 上创建一个 BTRFS 文件系统，请运行：

```bash
mkfs.btrfs /dev/(root_partition)
```

XFS 和 EXT4 对应的命令就是 `mkfs.xfs` 和 `mkfs.ext4`

如果需要覆盖原有分区，加入 `-f` 参数强制执行即可

### **挂载分区**

将根磁盘卷挂载到 `/mnt`

```bash
mount /dev/(root_partition) /mnt
```

对于 UEFI 系统，挂载 EFI 系统分区：

```bash
mount --mkdir /dev/(efi_system_partition) /mnt/boot
```

**挂载 EFI 系统分区一定要加 `--mkdir` 参数**

### **选择镜像源**

**一般建议选择清华大学镜像和上海交大镜像，这两个镜像稳定且积极维护，清华大学镜像速度更快，上海交大镜像更新频率更高**

编辑 `/etc/pacman.d/mirrorlist`（ISO 镜像中自带有 `vim` 等常用编辑器），在文件的最顶端添加：

```
Server = https://mirrors.tuna.tsinghua.edu.cn/archlinux/$repo/os/$arch
```

改为清华大学镜像

或添加：

```
Server = https://mirror.sjtu.edu.cn/archlinux/$repo/os/$arch
```

改为上海交大镜像

**这个文件接下来还会被 `pacstrap` 复制到新系统里，所以请确保设置正确**

### **安装必需的软件包**

使用 `pacstrap` 脚本，安装 base 软件包、Linux 内核、常规硬件的固件、文本编辑器等：

```bash
pacstrap /mnt base linux linux-firmware sof-firmware vim base-devel
```

如果想要获得[硬件视频加速](https://wiki.archlinux.org/title/Hardware_video_acceleration)可以下载 `intel-media-driver`

### **生成 fstab 文件**

用以下命令生成 fstab 文件 (用 `-U` 或 `-L` 选项设置 UUID 或卷标)：

```bash
genfstab -U /mnt >> /mnt/etc/fstab
```

### **进入新的 Archlinux 系统**

更改根目录到新安装的系统：

```bash
arch-chroot /mnt
```

更新软件包缓存：

```bash
pacman -Syyu
```

### **时区**

设置时区：

```bash
ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
hwclock --systohc
```

### **本地化**

编辑 `/etc/locale.gen`，然后取消掉 `en_US.UTF-8 UTF-8` 和 `zh_CN.UTF-8 UTF-8` 前的注释

接着生成 locale 信息：

```bash
locale-gen
```

然后创建 `/etc/locale.conf` 文件，并编辑设定 LANG 变量：

```
LANG=en_US.UTF-8
```

**不推荐在 `locale.conf` 中设置任何中文 locale，会导致 TTY 乱码**

### **网络配置**

创建 `/etc/hostname` 文件，写入自定义的主机名：

```
(my_hostname)
```

编辑本地主机名解析 `/etc/hosts`，写入：

```
127.0.0.1        localhost
::1              localhost
127.0.1.1        (my_hostname)
```

安装网络管理软件 `NetworkManager`：

```bash
pacman -S networkmanager
```

启用 `NetworkManager`（`systemctl` 命令对大小写敏感）：

```bash
systemctl enable NetworkManager
```

**一定要安装网络管理软件，否则重启后将无法联网**

### **创建 initramfs**

执行以下命令：

```bash
mkinitcpio -P
```

### **Root 用户密码**

设置 Root 用户密码：

```bash
passwd
```

### **安装引导程序**

**这是安装的最后一步也是至关重要的一步，请按指引正确安装好引导加载程序后再重新启动，否则重启后将无法正常进入系统**

```bash
pacman -S grub efibootmgr
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=(ID)
grub-mkconfig -o /boot/grub/grub.cfg
```

其中 `(ID)` 是 Arch Linux 系统启动项在 BIOS 启动菜单中的名字

### **重启**

输入 `exit` 退出 chroot 环境

输入 `umount -R /mnt` 手动卸载被挂载的分区

最后，执行 `reboot` 重启系统，`systemd` 将自动卸载仍然挂载的任何分区

不要忘记移除安装介质

## **初始配置**

**现在登录到新装好的系统时使用的是 Root 用户，用户名为 `root`，需要手动输入**

### **连接网络**

命令行输入 `nmtui` 并按照终端上的图形界面一步一步操作

### **设置新用户**

```bash
useradd -m -G wheel (user_name)
```

为用户创建密码

```bash
passwd (user_name)
```

**一定要设置在 wheel 用户组里面**

### **visudo 配置**

#### **更改 visudo 默认编辑器为 Vim**

visudo 的默认编辑器是 Vi，若要改为 Vim，则首先在终端中输入以下命令用 Vim 打开 visudo：

```bash
EDITOR=vim visudo
```

在开头的一个空行键入：

```
Defaults editor=/usr/bin/vim
```

按 `Esc` 进入命令模式，再按 `:x` 保存，按 `Enter` 退出

#### **用户组授权**

在 `visudo` 中取消注释 `%wheel ALL=(ALL) ALL`

如果不想每次执行 Root 用户命令都输入密码，可以取消注释 `%wheel ALL=(ALL) NOPASSWD: ALL`

**必须保留最前面的 `%`，这不是注释的一部分**

#### **单个用户免密码**

在最后一行（空行）按 `i` 进入输入模式，加上这一行：

```
Defaults:(user_name) !authenticate
```

进入命令模式，保存退出即可

**注：如果想保留输入密码的步骤但是想在输入密码时显示星号，则加上一行 `Defaults env_reset,pwfeedback` 即可**

### **安装并启用蓝牙**

```bash
pacman -S bluez pulseaudio-bluetooth
systemctl enable bluetooth
```

这里的 `pulseaudio-bluetooth` 是用于连接蓝牙耳机的

### **KDE Plasma 桌面安装**

#### **安装 Xorg 和 SDDM**

安装 Xorg：

```bash
pacman -S xorg
```

安装 SDDM：

```bash
pacman -S sddm
```

SDDM 字体选择 `noto-fonts`

#### **启用 SDDM**

**不启用 SDDM 等显示管理器则无法进入图形界面**

启用 SDDM：

```bash
systemctl enable sddm
```

#### **安装 Plasma 桌面**

安装 Plasma 桌面：

```bash
pacman -S plasma
```

可以排除掉一些软件包：

```
^4 ^5 ^20 ^21 ^33
```

即 `discover`、`drkonqi`、`kwayland`、`kwallet`、`plasma-firewall`

`jack` 选择 `jack2`

`pipewire-session-manager` 选择 `wireplumber`

`phonon-qt5-backend` 选择 `phonon-qt5-vlc`，这会自动下载 VLC 播放器

#### **安装必要的软件**

```bash
pacman -S firefox firefox-i18n-zh-cn konsole dolphin dolphin-plugins ark kate gwenview kimageformats spectacle yakuake okular poppler-data git noto-fonts-cjk
```

`firefox-i18n-zh-cn` 是 Firefox 浏览器的中文语言包

`dolphin-plugins` 提供了右键菜单挂载 ISO 镜像等选项

`kimageformats` 提供了 Gwenview 对 EPS、PSD 等图片格式的支持，但 Gwenview 依然是以栅格化形式打开 EPS 矢量图，质量较差，建议用 Okular 查看 EPS 图片

`poppler-data` 是 PDF 渲染所需的编码数据，不下载 `poppler-data` 会导致部分 PDF 文件的中文字体无法在 Okular 中显示

**KDE Frameworks/KDE Gear/Plasma 的更新时间表可以在 [KDE Community Wiki](https://community.kde.org/Schedules) 查看**

## **在图形界面下设置**

**现在重启电脑后即可进入图形界面，用户从 Root 变为新建的普通用户**

### **系统设置**

**此时系统语言为英语，可以执行 `export LANG=zh_CN.UTF-8` 将终端输出修改为中文，再执行 `systemsettings` 打开系统设置**

#### **语言和区域设置**

**将系统语言改为中文需要保证 `localectl list-locales` 输出包含 `zh_CN.UTF-8` 并且安装了中文字体**

系统设置 >> 语言和区域设置 >> 语言 >> 改为“简体中文”

其余“数字”、“时间”、“货币”等选项可以分别修改，可以搜索“China”找到“简体中文”

#### **电源与开机设置**

系统设置 >> 电源管理 >> 节能 >> 勾选“按键事件处理” >> 合上笔记本盖时 >> 选择“关闭屏幕” >> 勾选“即使已连接外部显示器”

系统设置 >> 开机与关机 >> 桌面会话 >> 登入时 >> 选择“以空会话启动”

#### **高分辨率设置**

系统设置 >> 显示和监控 >> 显示配置 >> 分辨率 >> 全局缩放 >> 200%

系统设置 >> 光标 >> 大小 >> 36

然后重启电脑

#### **触摸板设置**

系统设置 >> 输入设备 >> 触摸板 >> 手指轻触 >> 选择“轻触点击”

#### **工作区行为设置**

Dolphin 中单击文件、文件夹时的行为默认是单击打开，如果需要双击打开可以在此处设置：

系统设置 >> 工作区行为 >> 常规行为 >> 单击文件、文件夹时 >> 选择“选中”

#### **锁屏设置**

自动锁定屏幕的时间和锁屏界面的外观等在此处设置：

系统设置 >> 工作区行为 >> 锁屏

#### **自动启动设置**

系统设置 >> 开机与关机 >> 自动启动

可以添加 Yakuake 下拉终端为自动启动

### **终端快捷键配置**

打开终端 Konsole/Yakuake（Yakuake 设置自动启动后可以用 `Fn+F12` 直接打开）：

设置 >> 配置键盘快捷键 >> 复制改为 `Ctrl+C` ，粘贴改为 `Ctrl+V`

### **SDDM 修改为中文**

创建一个新文件：`/etc/sddm.locale`，写入：

```
LANG="zh_CN.UTF-8"
```

再编辑 `/lib/systemd/system/sddm.service`，在 `[Service]` 一节内加入：

```
EnvironmentFile=-/etc/sddm.locale
```

前面的 `-` 号表示即使 `/etc/sddm.locale` 不存在，也不会报错

### **双系统启动设置**

下载 `os-prober`：

```bash
sudo pacman -S os-prober
```

想要让 `grub-mkconfig` 探测其他已经安装的系统并自动把他们添加到启动菜单中，编辑 `/etc/default/grub` 并取消下面这一行的注释：

```
GRUB_DISABLE_OS_PROBER=false
```

想要让 GRUB 记住上一次启动的启动项，首先将 `GRUB_DEFAULT` 的值改为 `saved`，再取消下面这一行的注释：

```
GRUB_SAVEDEFAULT=true
```

使用 `grub-mkconfig` 工具重新生成 `/boot/grub/grub.cfg`：

```bash
sudo grub-mkconfig -o /boot/grub/grub.cfg
```

此时会显示找到 Windows Boot Manager，说明设置双系统成功

### **Linux 挂载 Windows 磁盘**

**首先要确保设备加密和快速启动已经关闭，以下内容针对 Linux 5.15 及之后的内核中引入的 NTFS3 驱动**

参考以下网址：

[fstab -- Archwiki](https://wiki.archlinux.org/title/Fstab_(%E7%AE%80%E4%BD%93%E4%B8%AD%E6%96%87))

#### **使用 UUID/卷标**

官方推荐的方法是使用 UUID，以分别挂载 C 盘和 D 盘到 `/home/(user_name)/C` 和 `/home/(user_name)/D` 为例，在终端中输入：

```bash
lsblk -f
```

在输出结果中可以发现 Windows 的硬盘分区，其中第一列（`NAME`）是卷标，第四列（`UUID`）是 UUID：

```
NAME       FSTYPE       LABEL   UUID
├─(name_C) ntfs         C       (UUID_C)
├─(name_D) ntfs         D       (UUID_D)
```

接着就来修改系统文件：

```bash
sudo vim /etc/fstab
```

在最后加入这两行：

```
UUID=(UUID_C)                     /home/(user_name)/C    ntfs3 defaults,umask=0 0 0
UUID=(UUID_D)                     /home/(user_name)/D    ntfs3 defaults,umask=0 0 0
```

重启电脑后，即可自动挂载

如果安装生成 fstab 文件时使用 `-L` 选项，即 `genfstab -L /mnt >> /mnt/etc/fstab`，则 `/etc/fstab` 中应加入：

```
(name_C)                     /home/(user_name)/C    ntfs3 defaults,umask=0 0 0
(name_D)                     /home/(user_name)/D    ntfs3 defaults,umask=0 0 0
```

**如果需要格式化 C 盘或 D 盘，先从 `/etc/fstab` 中删去这两行，再操作，之后磁盘的 `UUID` 会被更改，再编辑 `/etc/fstab` ，重启挂载即可**

#### **使用图形化界面**

**只支持旧版 `NTFS-3G`驱动，需要 `ntfs-3g` 软件包**

在系统应用“KDE 分区管理器（`partitionmanager`）”中卸载 C 盘、D 盘，右键选择编辑挂载点，编辑为 `/home/(user_name)/C` 和 `/home/(user_name)/D`，选项全部不用勾选（使用默认配置），点击“执行”即可

这相当于直接编辑 `/etc/fstab`，加入：

```
/dev/(name_C)                     /home/(user_name)/C    ntfs  0 0
/dev/(name_D)                     /home/(user_name)/D    ntfs  0 0
```

好处是格式化磁盘后内核名称不变，依然可以挂载

#### **如果 Windows 磁盘挂载错误**

**首先检查 Windows 中是否关闭了快速启动**

一般来讲是 Windows 开启了快速启动，或者进行了优化磁盘等操作导致的，若关闭快速启动不能解决问题，使用下面的方法：

检查占用进程：

```bash
sudo fuser -m -u /dev/(partition_name)
```

可以看到数字，就是占用目录的进程 PID，终止进程：

```bash
sudo kill (PID_number)
```

卸载磁盘分区：

```bash
sudo umount /dev/(partition_name)
```

执行硬盘 NTFS 分区修复（需要 `ntfs-3g` 软件包，也可以在 Windows 上进行）：

```bash
sudo ntfsfix -b -d /dev/(partition_name)
```

再重新挂载即可：

```bash
sudo mount -t ntfs3 /dev/(partition_name) (mount_path)/(mount_folder)
```

#### **挂载 NTFS 移动硬盘**

Dolphin 中可以用 NTFS3 驱动挂载 NTFS 移动硬盘，但是会因为不支持 `windows_names` 参数报错，解决方法是创建文件 `/etc/udisks2/mount_options.conf` 并写入：

```
[defaults]
ntfs_defaults=uid=$UID,gid=$GID
```

重启电脑即可

如果要设置自动挂载，可以在“系统设置 >> 可移动存储设备 >> 所有设备”中勾选“登录时”和“插入时”，以及“自动挂载新的可移动设备”

### **网络设置**

#### **ping 命令**

IP 地址和连接情况可以通过对域名 `ping` 得到，例如：

```bash
ping -c (count_number) (website_destination)
```

表示对网站域名 `(website_destination)` 发送 `(count_number)` 次 `ping` 连通请求

**Linux 上的 `ping` 命令默认是不停止发送请求的，必须指定发送次数或用 `Ctrl+C` 等方式强制终止**

#### **命令行连接 PKU Wi-Fi**

方法一：命令行输入 `nmtui` 并按照终端上的图形界面一步一步操作

方法二：使用 `nmcli`，输入：

```bash
nmcli device wifi connect PKU
```

通用的操作是：

```bash
nmcli device wifi connect (SSID) password (student_passowrd)
```

注意这里的 SSID 是 Wi-Fi 的名称（如 PKU 或 TP-LINK_XXX），不是 IP 地址或 MAC 地址

#### **命令行连接 PKU VPN**

**此处需要一直打开终端，故推荐使用 Yakuake**

首先下载 `openconnect`：

```bash
sudo pacman -S openconnect
```

按 `Fn+F12` 打开 Yakuake，输入：

```bash
sudo openconnect --protocol=nc --user (student_ID) https://vpn.pku.edu.cn
```

输入密码即可连接

之后可以按 `Fn+F12` 让它收起，不要关闭窗口（关闭窗口则 VPN 断开）

#### **图形化界面连接 PKU Secure**

首先从系统托盘中点击网络图标，再点击 PKU Secure 连接，此时会弹出一个“编辑连接”的窗口，按照以下步骤设置：

Wi-Fi 安全 >> 安全 >> 企业 WPA/WPA2

Wi-Fi 安全 >> 认证 >> 受保护的 EAP（PEAP）

PEAP 版本 >> 自动

内部认证 >> MSCHAPv2

输入用户名、密码即可连接

#### **命令行连接 PKU Secure**

首先进入 `nmcli` 配置：

```bash
nmcli connection edit PKU\ Secure
```

在 `nmcli` 界面内输入：

```
set wifi-sec.key-mgmt wpa-eap
set ipv4.method auto
set 802-1x.eap peap
set 802-1x.phase2-auth mschapv2
set 802-1x.identity (student_ID)
set 802-1x.password (student_password)
save
activate
```

#### **ThinkPad：图形化界面设置移动宽带网络**

下载 `modemmanager` 软件包：

```bash
sudo pacman -S modemmanager
```

启用 ModemManager：

```bash
sudo systemctl enable ModemManager
```

此时 Plasma 系统托盘的网络设置会多出一个移动宽带的图标选项

在“系统设置 >> 连接”中，点击右下角的加号创建新的链接，选择“移动宽带”并创建，按照以下步骤设置：

设置移动宽带连接 >> 任何 GSM 设备

国家 >> 中国

提供商 >> China Unicom

选择您的方案 >> 未列出我的方案

APN >> bjlenovo12.njm2apn

**提供商和 APN 可以在 Windows 系统的“设置 >> 网络和 Internet >> 手机网络 >> 运营商设置”上查找到，在“活动网络”处能找到提供商，在“Internet APN >> 默认接入点 >> 视图”中可以找到 APN 地址**

#### **修改 hosts 文件访问 GitHub**

修改 hosts 文件可以有效访问 GitHub，需要修改的文件是 `/etc/hosts`，Windows 下对应的文件位置为： `C:\Windows\System32\drivers\etc\hosts` （注意这里是反斜杠），修改内容参考以下网址：

[HelloGitHub -- hosts](https://raw.hellogithub.com/hosts)

### **AUR 软件包管理器**

**注意 Arch 预装的包管理器 pacman 不支持 AUR，也不打包 AUR 软件包管理器，需要单独下载 AUR 软件包管理器**

#### **yay**

yay 是一个支持官方仓库和 AUR 仓库的命令行软件包管理器

执行以下命令安装 yay：（需要保证能够连接 GitHub，一般需要修改 hosts）

```bash
git clone https://aur.archlinux.org/yay-bin.git
cd yay-bin
makepkg -si
```

yay 的命令与 `pacman` 相似，如 `yay -S (package_name)` 表示下载软件包、`yay -Syyu` 表示更新所有软件包（包括官方仓库和 AUR 仓库）、`yay -R (package_name)` 表示删除软件包，其使用教程参考以下网址：

[yay -- GitHub](https://github.com/Jguer/yay)

yay 支持在下载时修改 PKGBUILD 文件，方法是 `yay -S --editmenu (package_name)`

#### **pamac**

pamac 支持命令行和图形界面，“添加/删除软件”就是 pamac 的 GUI 版本，执行以下命令安装 `pamac`：

```bash
git clone https://aur.archlinux.org/libpamac-aur.git
cd libpamac-aur
makepkg -si
git clone https://aur.archlinux.org/pamac-aur.git
cd pamac-aur
makepkg -si
```

其使用教程参考以下网址：

[Manjaro Wiki -- Pamac](https://wiki.manjaro.org/index.php/Pamac)

需要按照如下方式启用 pamac 的 AUR 支持：

添加/删除软件 >> 设置（右上角的三横线图标） >> 首选项 >> AUR >> 启用 AUR 支持

然后就可以用 pamac 的图形界面获取 AUR 软件包，或者用命令 `pamac build (package_name)` 获取 AUR 的软件包

**以下所有的 `yay -S` 都可以用 `pamac build` 替代，或者在“添加/删除软件”搜索安装**

### **Arch Linux CN 软件源**

在 `/etc/pacman.conf` 文件末尾添加以下两行以启用清华大学镜像：

```
[archlinuxcn]
Server = https://mirrors.tuna.tsinghua.edu.cn/archlinuxcn/$arch
```

或上海交大镜像：

```
[archlinuxcn]
Server = https://mirrors.sjtug.sjtu.edu.cn/archlinux-cn/$arch
```

之后执行下面的命令安装 `archlinuxcn-keyring` 包导入 GPG 密钥

```bash
sudo pacman -Sy archlinuxcn-keyring
sudo pacman -Syyu
```

这样就开启了 pacman 对 Arch Linux CN 的支持

**注意一定要写第一行的 `[archlinuxcn]`，安装 archlinuxcn-keyring 时要用 `-Sy` 安装（更新后安装）**

#### **搜索软件包**

在 `yay` 上执行：（`-s` 会使用正则表达式匹配所有相似的结果，如果只有 `-S` 会启动下载程序）

```bash
yay -Ss (package_name)
```

或者在 `pamac` 上执行：

```bash
pamac search (package_name)
```

搜索已安装的软件包:

```bash
yay -Qs (package_name)
```

#### **检查依赖关系**

以树状图的形式展示某软件包的依赖关系：（需要下载 `pacman-contrib` 软件包）

```bash
pactree (package_name)
```

#### **降级软件包**

在 `/var/cache/pacman/pkg/` 中找到旧软件包（包括旧 AUR 软件包），双击打开安装实现手动降级，参考以下网址：

[Downgrading Packages -- ArchWiki](https://wiki.archlinux.org/title/Downgrading_packages_(%E7%AE%80%E4%BD%93%E4%B8%AD%E6%96%87))

#### **清理缓存**

清理全部软件安装包：

```bash
pamac clean
```

删除软件包时清理设置文件：

```bash
sudo pacman -Rn (package_name)
```

清理无用的孤立软件包：

```bash
sudo pacman -Rsn $(pacman -Qdtq)
```

若显示 `error: no targets specified (use -h for help)` 则说明没有孤立软件包需要清理

或者：

```bash
pamac remove -o
```

**若不小心终止了 `pacman` 进程，则需要先删除 `/var/lib/pacman/db.lck` 才能再次启动 `pacman`**

#### **从本地安装包安装软件**

pacman 有从本地安装包安装软件的功能，只需输入：

```bash
sudo pacman -U (package_path)/(package_name)
```

**重启后会发现许多窗口和图标变小，建议先调整全局缩放为 100%，重新启动，再调至 200%，再重启**

### **Vim 配置**

Vim 的配置文件主要有 `/usr/share/vim/vimfiles/archlinux.vim`，`/etc/vimrc` 和 `/home/(user_name)/.vimrc`，建议直接修改 `/etc/vimrc`，这样不会覆盖 `/usr/share/vim/vimfiles/archlinux.vim` 上定义的默认配置（语法高亮等）

Vim 的配置可以参考以下网址：

[Options -- Vim Documentation](http://vimdoc.sourceforge.net/htmldoc/options.html)

应用 `Ctrl+C`、`Ctrl+V`、`Ctrl+A`、`Ctrl+Z` 等快捷键，需要在 `/etc/vimrc` 中写入：

```
source $VIMRUNTIME/mswin.vim
```

`mswin.vim` 的源代码可以在这里找到：

[vim -- mswin.vim](https://github.com/vim/vim/blob/master/runtime/mswin.vim)

启用剪贴板功能，需要安装 `gvim` 软件包

### **GNU nano 下载与配置**

下载 nano 文本编辑器：

```bash
sudo pacman -S nano
```

nano 的配置文件在 `/etc/nanorc`，可以通过取消注释设置选项配置文件，如：

取消注释 `set linenumbers` 可以显示行号

取消注释 `set tabsize 8` 可以更改 Tab 键的长度，例如 `set tabsize 4`

取消注释 `set tabstospaces` 可以将 Tab 转换为空格

取消注释 `set matchbrackets "(<[{)>]}"` 可以匹配括号

取消注释 `include "/usr/share/nano/*.nanorc"` 一行和所有的颜色设置可以启用代码高亮

取消注释所有的 `Key bindings` 选项可以启用更常用的快捷键设定

**用 nano 编辑后保存的步骤是 `Ctrl+W` （Write Out） >> `Enter` >> `Ctrl+Q` （Exit），如果用默认的快捷键设置，则为 `Ctrl+O` （Write Out） >> `Enter` >> `Ctrl+X` （Exit）**

### **命令行界面输出语言为英语**

在 `~/.zshrc` 或 `~/.bashrc` 中添加一行：

```
export LANGUAGE=en_US.UTF-8
```

### **时间设置**

#### **双系统时间不同步**

系统设置 >> 时间和日期 >> 自动设置日期和时间

在 Arch Linux 上设置硬件时间为 UTC：

```bash
sudo timedatectl set-local-rtc 0
```

并在 Windows 上设置硬件时间为 UTC，与 Arch Linux 同步：

```powershell
reg add "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\TimeZoneInformation" /v RealTimeIsUniversal /d 1 /t REG_QWORD /f
```

**这一步需要在 Powershell（管理员）中执行**

#### **数字时钟设置 24 小时制**

右键点击“数字时钟” >> 配置数字时钟 >> 时间显示 >> 24 小时制

#### **添加 TUNA 网络授时服务（可选）**

参考以下网址：

[TUNA NTP（网络授时）服务使用说明](https://tuna.moe/help/ntp/)

### **字体安装**

KDE Plasma 支持直接在 Dolphin 的右键菜单中安装 TTF/OTF 字体和 TTC/OTC 字体集

**注意不管是 Windows 还是 Linux 都要将字体“为所有用户安装”，尤其是 Windows 11 右键直接安装是安装到个人用户目录 `C:\Users\(user_name)\AppData\Local\Microsoft\Windows\Fonts` 而非系统目录 `C:\Windows\Fonts`**

#### **命令行安装字体**

将字体文件复制到 `/usr/share/fonts` 安装，方法如下：

```bash
sudo cp (font-path)/* /usr/share/fonts
cd /usr/share/fonts
fc-cache -fv
```

这样就可以安装字体了

**微软系统字体文件夹在 `C:\Windows\Fonts`，可以复制到 `/usr/share/fonts` 安装，注意需要排除掉 MS Gothic、Yu Gothic 和 Malgun Gothic 字体，因它们只有部分日/韩文汉字字形（与中文汉字字形一样的会被排除，最后导致部分中文汉字显示为日/韩文字形）**

#### **安装 Google Noto 字体**

命令行安装：

```bash
sudo pacman -S noto-fonts noto-fonts-cjk
```

所有语言字体的下载地址如下：

[Noto Fonts -- Google Fonts](https://fonts.google.com/noto/fonts)

中文（CJK）字体的下载地址如下：

[Noto CJK -- GitHub](https://github.com/googlefonts/noto-cjk)

安装的 Noto CJK 字体可能在某些情况下（框架未定义地区）汉字字形与标准形态不符，例如门、关、复等字的字形与规范中国大陆简体中文不符

这是因为每个程序中可以设置不同的默认字体，而这些字体的属性由 fontconfig 控制，其使用顺序是据地区代码以 A-Z 字母表顺序成默认排序，由于 `ja` 在 `zh` 之前，故优先显示日文字形

解决方法是手动修改字体设置文件：

```bash
sudo vim /etc/fonts/conf.d/64-language-selector-prefer.conf
```

并加入以下内容：

```xml
<?xml version="1.0"?>
<!DOCTYPE fontconfig SYSTEM "fonts.dtd">
<fontconfig>
    <alias>
        <family>sans-serif</family>
        <prefer>
            <family>Noto Sans CJK SC</family>
            <family>Noto Sans CJK TC</family>
            <family>Noto Sans CJK HK</family>
            <family>Noto Sans CJK JP</family>
            <family>Noto Sans CJK KR</family>
        </prefer>
    </alias>
    <alias>
        <family>serif</family>
        <prefer>
            <family>Noto Serif CJK SC</family>
            <family>Noto Serif CJK TC</family>
            <family>Noto Serif CJK HK</family>
            <family>Noto Serif CJK JP</family>
            <family>Noto Serif CJK KR</family>
        </prefer>
    </alias>
    <alias>
        <family>monospace</family>
        <prefer>
            <family>Noto Sans Mono CJK SC</family>
            <family>Noto Sans Mono CJK TC</family>
            <family>Noto Sans Mono CJK HK</family>
            <family>Noto Sans Mono CJK JP</family>
            <family>Noto Sans Mono CJK KR</family>
        </prefer>
    </alias>
</fontconfig>
```

保存退出即可

**注意 Microsoft Office 不支持嵌入 OTF 字体，只能嵌入 TTF 字体**

### **安装中文输入法**

#### **安装 Fcitx5 输入法**

推荐使用 Fcitx5:

```bash
sudo pacman -S fcitx5-im fcitx5-chinese-addons
```

编辑 `/etc/environment` 并添加以下几行：

```
GTK_IM_MODULE=fcitx
QT_IM_MODULE=fcitx
XMODIFIERS=@im=fcitx
```

然后重新登录，此时输入法会自动启动，默认的切换键是 `Ctrl+Space`

**安装输入法之后需要重启电脑才能生效，如果无法启动输入法，在“系统设置 >> 区域设置 >> 输入法 >> 添加输入法”中手动添加“拼音”**

#### **配置与词库**

Fcitx5 的配置在：

系统设置 >> 语言和区域设置 >> 输入法

注意有“全局选项”、“附加组件”、“拼音”三个配置区域

可以添加词库：（需要使用 Arch Linux CN 源）

```bash
sudo pacman -S fcitx5-pinyin-moegirl fcitx5-pinyin-zhwiki
```

#### **其它版本**

Fcitx5 对应的 git 版本为：（需要使用 Arch Linux CN 源）

```bash
sudo pacman -S fcitx5-git fcitx5-chinese-addons-git fcitx5-gtk-git fcitx5-qt5-git fcitx5-configtool-git
```

一个稳定的替代版本是 Fcitx 4.2.9.8-1：

```bash
sudo pacman -S fcitx-im fcitx-configtool fcitx-cloudpinyin
```

可以配合 googlepinyin 或 sunpinyin 使用，即执行：

```bash
sudo pacman -S fcitx-googlepinyin
```

或者：

```bash
sudo pacman -S fcitx-sunpinyin
```

也可以用 `sudo pacman -S sunpinyin` 安装 Sunpinyin

### **关闭启动和关机时的系统信息**

参考以下网址：

[Silent Boot -- ArchWiki](https://wiki.archlinux.org/title/Silent_boot)

[Improving Performance -- ArchWiki](https://wiki.archlinux.org/title/Improving_performance)

主要是 [Kernel parameters](https://wiki.archlinux.org/title/Silent_boot#Kernel_parameters) 和 [fsck](https://wiki.archlinux.org/title/Silent_boot#fsck) 两段，以及关于 [watchdog](https://wiki.archlinux.org/title/Improving_performance#Watchdogs) 的说明

#### **关闭启动时 grub 的消息**

编辑 `/boot/grub/grub.cfg`，找到两行：

```
echo    'Loading Linux linux'
echo    'Loading initial ramdisk ...'
```

将其删除，重启即可

更本质是修改 `/etc/grub.d/10_linux`，删除 `message="$(gettext_printf "Loading Linux %s ..." ${version})"` 和 `message="$(gettext_printf "Loading initial ramdisk ...")"`

#### **关闭启动时 fsck 的消息**

第一种方法是将 fsck 的消息重定向到别的 TTY 窗口，缺点是开机卡住时需要先切换到别的 TTY 窗口才能进入 emergency mode

编辑 Kernel parameters：

```bash
sudo vim /etc/default/grub
```

在 `GRUB_CMDLINE_LINUX_DEFAULT` 中加入 `console=tty(x)`，其中 `x` 可以为 2 ~ 6 中的任何一个数

第二种方法是让 systemd 来检查文件系统：

编辑 `/etc/mkinitcpio.conf`，在 `HOOKS` 一行中将 `udev` 改为 `systemd`

再编辑 `systemd-fsck-root.service` 和 `systemd-fsck@.service`：

```bash
sudo systemctl edit --full systemd-fsck-root.service
sudo systemctl edit --full systemd-fsck@.service
```

分别在 `Service` 一段中编辑 `StandardOutput` 和 `StandardError` 如下：

```
[Service]
Type=oneshot
RemainAfterExit=yes
ExecStart=/usr/lib/systemd/systemd-fsck
TimeoutSec=0
StandardOutput=null
StandardError=journal+console
```

最后执行：

```bash
sudo mkinitcpio -P
sudo grub-mkconfig -o /boot/grub/grub.cfg
```

再重启即可

#### **关闭重启时 watchdog 的消息**

编辑 Kernel parameters：

```bash
sudo vim /etc/default/grub
```

在 `GRUB_CMDLINE_LINUX_DEFAULT` 中加入 `nowatchdog`

再创建文件 `/etc/modprobe.d/watchdog.conf`，并写入：

```bash
blacklist iTCO_wdt
blacklist iTCO_vendor_support
```

这样可以屏蔽掉不需要的驱动，最后执行：

```bash
sudo mkinitcpio -P
sudo grub-mkconfig -o /boot/grub/grub.cfg
```

再重启即可

#### **关闭重启时 systemd 的消息**

参考以下网址：

https://github.com/systemd/systemd/pull/23574

方法如下：

系统设置 >> 开机与关机 >> 登录屏幕（SDDM） >> 行为设置 >> “关机命令”和“重启命令”中加入 `--no-wall` 参数

### **Git 配置**

配置用户名、邮箱：

```bash
git config --global user.name "(user_name)"
git config --global user.email "(user_email)"
```

Git 使用教程参考以下网址：

[Git Documentation](https://git-scm.com/docs)

### **系统分区改变导致时进入 GRUB Rescue 模式**

此时会在开机时显示如下内容而无法进入选择系统的界面：

```
error: no such partition.
Entering rescue mode...
grub rescue>
```

此时执行 `ls`，显示如下：

```
((hd_number)) ((hd_number),(gpt_number))
```

其中硬盘编号 `(hd_number)` 从小到大排列（最小值为 0），分区编号 `(gpt_number)` 从大到小排列（最小值为 1）

找到安装 Arch Linux 的分区 `((hd_number),(gpt_number))`，此时执行 `ls((hd_number),(gpt_number))` 应该能看到 Arch Linux 根目录下的所有文件和文件夹

手动修改启动分区所在的位置：

```bash
set prefix=((hd_number),(gpt_number))/boot/grub
```

执行：

```bash
insmod normal
normal
```

即可进入 GRUB 界面，从这里登录 Arch Linux 系统，登录后执行：

```
sudo grub-mkconfig -o /boot/grub/grub.cfg
```

以修复启动项

### **调整文件夹名称为英文**

修改 `~/.config/user-dirs.dirs`，改为：

```bash
XDG_DESKTOP_DIR="$HOME/Desktop"
XDG_DOCUMENTS_DIR="$HOME/Documents"
XDG_DOWNLOAD_DIR="$HOME/Downloads"
XDG_MUSIC_DIR="$HOME/Music"
XDG_PICTURES_DIR="$HOME/Pictures"
XDG_PUBLICSHARE_DIR="$HOME/Public"
XDG_TEMPLATES_DIR="$HOME/Templates"
XDG_VIDEOS_DIR="$HOME/Videos"
```

并在 Dolphin 中按照上面的说明更改文件名

### **蓝牙连接设置**

#### **命令行连接蓝牙**

一般蓝牙设备可以在 Plasma 桌面的图形界面下连接，如果连接失败，可以选择用命令行界面连接和排查错误

首先要安装 `bluez-utils`：

```bash
sudo pacman -S bluez-utils
```

在终端中输入：

```bash
bluetoothctl
```

进入交互模式，此时命令前缀变为 `[bluetooth]#`（`bluetooth` 可能替换为已连接设备的名字），连接步骤如下：

- 使用命令 `scan on` 去搜索发现所有可配对的设备
- 使用命令 `devices` 获得要配对的设备的 MAC 地址，一般是 `XX:XX:XX:XX:XX:XX` 的形式
- 使用命令 `pair (MAC_address)` 配对设备，可能需要输入 PIN 密码
- 使用命令 `trust (MAC_address)` 将设备添加到信任列表
- 使用命令 `connect (MAC_address)` 建立连接
- 使用命令 `quit` 退出

#### **SONY WH-1000XM3 耳机的蓝牙连接**

长按耳机电源键约 7 秒即可进入配对模式，可以在蓝牙中配对

#### **Logitech 多设备鼠标的蓝牙连接**

同一台电脑的 Windows 系统和 Linux 系统在鼠标上会被识别为两个设备

如果 Windows 系统被识别为设备 1，需要多设备切换的按钮（一般是一个在滚轮后或鼠标底部的圆形按钮）切换至设备 2

长按圆形按钮直到灯 2 快速闪烁进入配对模式，可以在蓝牙中配对

如果 Logitech 鼠标配对后屏幕光标无法移动，一般可以直接删除设备重新配对，如果仍然失败则按照下面步骤操作：

安装 `bluez-utils`，输入 `bluetoothctl` 进入命令行界面

然后参考 [ArchWiki](https://wiki.archlinux.org/title/Bluetooth_mouse) 上“Problems with the Logitech BLE mouse”一段的指引进行操作

### **解决登录 Root 用户没有声音的问题**

首先创建一个新文件夹：

```bash
sudo mkdir /root/.config/autostart/
```

在该文件夹下创建一个 `pulseaudio.desktop` 文件：

```bash
sudo vim /root/.config/autostart/pulseaudio.desktop
```

写入：

```bash
[Desktop Entry]
Encoding=UTF-8
Type=Application
Name=pulseaudio
Exec=pulseaudio --start --log-target=syslog
StartupNotify=false
Terminal=true
Hidden=false
```

保存，重启即可

### **切换图形化界面和命令行界面**

登录时默认进入的是图形化界面，有时候开机后黑屏是图形化界面显示不出来所致，此时可以按快捷键 `Ctrl+Alt+Fn+(F2~F6)` 进入 `tty2 ~ tty6` 的任何一个命令行 TTY 界面

注意此时需要手动输入用户名和密码

在命令行界面解决问题后，按快捷键 `Ctrl+Alt+Fn+F1` 可以转换回 TTY1 图形化界面

### **调整 CPU 频率（可选）**

这需要 `tlp` 软件包：

```bash
sudo vim /etc/tlp.conf
```

若更改 CPU 频率，修改以下位置：

```
CPU_MIN_PERF_ON_AC=0
CPU_MAX_PERF_ON_AC=100
CPU_MIN_PERF_ON_BAT=0
CPU_MAX_PERF_ON_BAT=30
```

若更改 CPU 睿频设置，修改以下位置：

```
CPU_BOOST_ON_AC=1
CPU_BOOST_ON_BAT=0
```

保存、关闭，在终端中输入：

```bash
sudo tlp start
```

**不需要高性能的时候可以关闭睿频，这样可以大幅增加续航、减少发热**

#### **显示 Intel CPU 频率（可选）**

安装 KDE 小部件：[Intel P-state and CPU-Freq Manager](https://github.com/frankenfruity/plasma-pstate)

右键点击顶栏，选择“添加部件”，找到 Intel P-state and CPU-Freq Manager 并添加在顶栏即可

### **为 pacman 启用多线程下载（可选）**

执行下面的命令下载 [axel](https://github.com/axel-download-accelerator/axel)

```bash
 sudo pacman -S axel
```

编辑 `/etc/pacman.conf` 文件（在第 21 行）:

```bash
XferCommand = /usr/bin/axel -n 10 -o %o %u
```

编辑 `/etc/makepkg.conf` 文件（在第 12-17 行）:

```bash
DLAGENTS=('file::/usr/bin/curl -gqC - -o %o %u'
'ftp::/usr/bin/axel -n 10 -o %o %u'
'http::/usr/bin/axel -n 10 -o %o %u'
'https::/usr/bin/axel -n 10 -o %o %u'
'rsync::/usr/bin/rsync --no-motd -z %u %o'
'scp::/usr/bin/scp -C %u %o')
```

**注意某些软件包如 `rider` 和 `qqmusic-bin` 等下载源不支持 axel，启用多线程下载后可能会导致构建失败**

### **安装 KDE 的 Wayland 支持（不推荐）**

与 Xorg 相比，Wayland 对触屏的支持更佳，但某些应用在 Wayland 上会有兼容性问题，目前 KDE 对 Wayland 的支持处于能用但还不太完善的状态

```bash
sudo pacman -S plasma-wayland-session
```

安装后即可在登录界面选择 Wayland 会话

### **重新开启 Secure Boot（未测试）**

如果想在开启 Secure Boot 的情况下登录进 Arch Linux，可以使用经过微软签名的 PreLoader 或者 shim，然后在 UEFI 设置中将 Secure Boot 级别设置为 Microsoft & 3rd Party CA

具体教程参考以下网址：

[Secure Boot -- ArchWiki](https://wiki.archlinux.org/title/Unified_Extensible_Firmware_Interface/Secure_Boot#Microsoft_Windows)