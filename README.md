# **在 ThinkPad X13 2021 Intel 上安装 Arch Linux KDE Plasma + Windows 11 双系统的指南**

```
OS: Arch Linux x86_64
Kernel: x86_64 Linux 6.0.6-arch1-1
Resolution: 2560x1600
DE: KDE 5.99.0 / Plasma 5.26.2
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

要连接到网络：
- 有线以太网 —— 连接网线
- WiFi —— 使用 `iwctl` 验证无线网络

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

显示连接到网络后，可以用 `ping` 测试：

```
ping -c (count_number) (website_destination)
```

### **更新系统时间**

使用 `timedatectl` 开启 NTP 同步时间，确保系统时间是准确的：

```bash
timedatectl set-ntp true
```

### **建立硬盘分区**

**对 Linux 分区建议使用 BTRFS/XFS/EXT4 文件系统**

可以使用 `lsblk` 查看，使用 `parted` 修改分区，可以使用交互模式

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

编辑 `/etc/pacman.d/mirrorlist`，在文件的最顶端添加：

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

使用 `pacstrap` 脚本，安装 base 软件包和 Linux 内核以及常规硬件的固件：

```bash
pacstrap /mnt base linux linux-firmware sof-firmware vim base-devel
```

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

### **Root 密码**

设置 Root 密码：

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

**现在登录到新装好的系统时使用的是 Root 帐户，用户名为 `root`，需要手动输入**

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

### **启用蓝牙**

```bash
pacman -S bluez
systemctl enable bluetooth
```

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

**不启用 SDDM 则无法进入图形界面**

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

执行硬盘 NTFS 分区修复（需要 `ntfs-3g` 软件包）：

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

此处需要一直打开终端，故推荐使用 Yakuake

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

执行以下命令安装 `yay`：（需要保证能够连接 GitHub，一般需要修改 hosts）

```bash
git clone https://aur.archlinux.org/yay-bin.git
cd yay-bin
makepkg -si
```

`yay` 的命令与 `pacman` 相似，如 `yay -S` 表示下载软件包、`yay -Syyu` 表示更新所有软件包（包括官方仓库和 AUR 仓库）、`yay -R` 表示删除软件包，其使用教程参考以下网址：

[yay -- GitHub](https://github.com/Jguer/yay)

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

然后就可以用 pamac 的图形界面获取 AUR 软件包，或者用命令 `pamac build` 获取 AUR 的软件包

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

在 `yay` 上执行：

```bash
yay (package_name)
```

或者在 `pamac` 上执行：

```bash
pamac search (package_name)
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

若不小心终止了 `pacman` 进程，则需要先删除 `/var/lib/pacman/db.lck` 才能再次启动 `pacman`

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

### **GNU nano 配置**

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

这一步需要在 Powershell（管理员）中执行

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

编辑 `/etc/default/grub`，找到两行：

```
echo    'Loading Linux linux'
echo    'Loading initial ramdisk ...'
```

将其删除，重启即可

更本质是修改 `/etc/grub.d/10_linux`

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

https://github.com/systemd/systemd/pull/23574

https://forum.manjaro.org/t/the-system-is-going-down-for-poweroff-reboot-now/114353/4

暂时方法：`shutdown --no-wall`

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

#### **SONY WH-1000XM3 耳机的蓝牙连接**

长按耳机电源键约 7 秒即可进入配对模式，可以在蓝牙中配对

#### **Logitech 鼠标的蓝牙连接**

同一台电脑的 Windows 系统和 Linux 系统在鼠标上会被识别为两个设备

如果 Windows 系统被识别为设备 1，需要多设备切换的按钮（一般是一个在滚轮后或鼠标底部的圆形按钮）切换至设备 2

长按圆形按钮直到灯 2 快速闪烁进入配对模式，可以在蓝牙中配对

#### **如果鼠标配对后屏幕光标无法移动**

一般可以直接删除设备重新配对，如果失败则按照下面步骤操作：

首先要安装 `bluez-utils`：

```bash
sudo pacman -S bluez-utils
```

在终端中输入：

```bash
bluetoothctl
```

然后参考 [ArchWiki](https://wiki.archlinux.org/title/Bluetooth_mouse) 上“Problems with the Logitech BLE mouse (M557, M590, anywhere mouse 2, etc)”一段的指引进行操作

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

在命令行界面解决问题后，按快捷键 `Ctrl+Alt+Fn+F1` 可以转换回图形化界面

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

## **一些有用的命令总结**

### **获取设备信息**

#### **简要信息**

可以使用能显示系统图标的 `neofetch`，在终端中输入：（需要下载 `neofetch` 软件包）

```bash
neofetch
```

或者使用功能更强大的 `inxi`：（需要在 AUR 中下载 `inxi` 软件包）

```bash
sudo inxi -b
```

#### **详细信息**

在终端中输入：

```bash
sudo inxi -Fa
```

#### **操作系统版本**

在终端中输入：

```bash
lsb_release -sirc
```

#### **网络设备**

在终端中输入：

```bash
ip a
```

输出网络设备名称的前两个字母表示设备种类：

`lo` 为回环（loopback），`ww` 为无线广域网（WWAN，负责移动宽带连接），`wl` 为无线局域网（WLAN，负责 Wi-Fi 连接），`en` 为以太网（Ethernet，负责网线连接）

#### **命令行进程查看器**

在终端中输入：

```bash
htop
```

#### **命令行音量调节器**

在终端中输入：

```bash
alsamixer
```

#### **内存大小**

在终端中输入：（默认单位是 KiB，即 1024 字节）

```bash
free
```

**Linux 的内存策略可以参考这个网站：[Linux ate my RAM](https://www.linuxatemyram.com/)**

#### **上一次关机的系统日志**

```bash
journalctl -rb -1
```

### **查看并转换编码**

查看编码的命令为：

```bash
file -i (file_name)
```

其中 `charset` 一栏的输出即为文件编码

转换编码可以使用系统预装的 `iconv`，方法为：

```bash
iconv -f (from_encoding) -t (to_encoding) (from_file_name) -o (to_file_name)
```

该方法适合对文本文件转换编码，对 ZIP 压缩包和 PDF 文件等二进制文件则无法使用

`iconv` 支持的编码格式可以用 `iconv -l` 查看

### **转换图片格式**

这需要 `imagemagick` 软件包，它提供了 `convert` 等命令

例如批量将图片从 PNG 格式转换为 JPG 格式：

```bash
ls -1 *.png | xargs -n 1 bash -c 'convert "$0" "${0%.png}.jpg"'
```

### **查找命令**

`grep` 命令的用法为在文件或命令输出中查找字符串，例如：

```bash
grep (pattern) (file_pattern)
```

即为在当前目录文件名符合 `file_pattern` 的文件中查找字符串 `pattern`

又例如：

```bash
pamac list | grep (pattern)
```

可以查询已安装的软件包中名字含有 `pattern` 的软件包

### **命令行比较两个文件**

可以用 Linux 自带的 `diff` 命令，它可以逐行比较两个文件（如果是二进制文件则直接输出是否存在差异）：

```bash
diff (file_name_2) (file_name_2)
```

这里的文件也可以换成路径，详细用法可以用 `diff --help` 查询

### **批量更改文件名**

可以用 Linux 自带的 `rename` 命令：

```bash
rename -- "(old_name)" "(new_name)" (files)
```

这里的参数 `--` 是为了防止在 `"old_name"` 中出现连字符导致识别错误（将其识别为参数）而添加的

例如将本文件夹下所有文件的文件名中空格改为下划线，即执行：

```bash
rename -- " " "_" ./*
```

详细用法可以用 `rename --help` 查询

### **批量更改文件**

推荐使用 `sed` 命令处理：

```bash
sed -ie 's/(old_string)/(new_string)/g' (files)
```

例如将本地文件下所有 Tab 替换成4个空格：

```bash
sed -ie "s/\t/    /g" ./*
```

替换 Tab 也可以使用更加智能的 Vim 中的 `retab` 功能，它可以自动将不同长度的 Tab 替换成不同长度的空格，保证最终文字依然是对齐的

首先用下列命令在一个 Vim 窗口中打开多个文件

```
vim `find . -type f -name "(files)"`
```

然后执行：

```
:argdo %:retab! | update
```

单个文件则直接执行 `%:retab!` 即可

### **命令行解压 ZIP 压缩包**

建议使用系统预装的 `unar`（由 `unarchiver` 软件包提供），因为它可以自动检测文件编码（系统右键菜单默认的 Ark 不具备这个功能，可能导致乱码）：

```bash
unar (file_name).zip
```

### **设置命令别名**

在 `~/.bashrc` 中添加一句 `alias (new_command)=(old-command)`，这样直接输入 `new_command` 即等效于输入 `old_command`

## **美化**

### **自定义壁纸**

桌面壁纸可以在 [pling.com](https://www.pling.com/) 下载

KDE Plasma 每个版本的壁纸可以在这里找到：

[Plasma Workspace Wallpapers -- KDE](https://github.com/KDE/plasma-workspace-wallpapers)

默认的壁纸保存位置为 `/usr/share/wallpapers/`

还可以使用包管理器（pacman/yay/pamac）下载壁纸，用“添加/删除软件”或 `pamac search wallpaper` 查找

右键点击桌面得到桌面菜单，点击“配置桌面和壁纸”即可选择想要的壁纸，位置建议选择“缩放并裁剪”

### **添加用户图标**

系统设置 >> 用户账户 >> 图像

### **开机美化**

开机与关机 >> 登录屏幕（SDDM） >> 获取新 SDDM 主题 >> 应用 Plasma 设置

外观 >> 欢迎屏幕 >> 获取新欢迎屏幕

#### **SDDM 时间显示调整为 24 小时制**

更改 `/usr/share/sddm/themes/(theme_name)/components/Clock.qml` 或 `/usr/share/sddm/themes/(theme_name)/Clock.qml` 中的 `Qt.formatTime` 一行：

```
text: Qt.formatTime(timeSource.data["Local"]["DateTime"])
```

将其改为：

```
text: Qt.formatTime(timeSource.data["Local"]["DateTime"], "H:mm:ss")
```

保存重启即可

### **主题 Mac 风格美化（可选）**

参考以下网址：

[KDE 桌面的 Mac 化](https://www.cnblogs.com/luoshuitianyi/p/10587788.html)

[KDE 桌面美化指南](https://acherstyx.github.io/2020/06/30/KDE%E6%A1%8C%E9%9D%A2%E7%BE%8E%E5%8C%96%E6%8C%87%E5%8D%97/)

其中 Plasma 主题、GTK 主题和图标主题推荐选择：

```
Plasma Theme: Mojave-CT
GTK Theme: Mojave-light-alt [GTK2/3]
Icon Theme: La Capitaine
```

Latte-Dock 的推荐设置：

行为：位置 >> 底部，可见性 >> 自动隐藏，延迟 >> 显示 >> none

外观：绝对大小 >> 96，背景大小 >> 10%

**不想使用 Mac 风格主题但又想使用浅色主题时，可以使用 KDE 官方主题 Breeze Light，并将终端（Konsole 和 Yakuake）主题改为“白底黑字”，背景透明度选择 20%**

### **光标主题设置**

已安装的光标主题可以通过以下命令查看：

```bash
find /usr/share/icons ~/.local/share/icons ~/.icons -type d -name "cursors"
```

备用的光标主题可以在 `/usr/share/icons/default/index.theme` 设置：

```
[Icon Theme]
Inherits=(cursor_theme_name)
```

默认的备选是 `Adwaita`，这可能导致光标主题的不统一，可以改为 `breeze_cursors`

### **配置桌面小部件（可选）**

右键点击桌面 >> 添加部件 >> 获取新部件 >> 下载新 Plasma 部件

在这里可以下载桌面小部件，并在“添加部件”处添加

### **shell 配置**

修改 Konsole 默认的 shell 需要如下设置：

Konsole >> 设置 >> 编辑当前方案 >> 常规 >> 命令 >> `usr/bin/bash`

### **bash 配置提示符变量**

bash 的配置文件在 `~/.bashrc`，默认提示符变量 PS1 可以设置为如下内容，可以显示用户名、主机名、时间、Git 仓库分支、是否为超级用户，并显示颜色高亮：

```bash
PS1="\[\033[38;5;39m\]\$(git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/')\[$(tput sgr0)\][\[$(tput sgr0)\]\[\033[38;5;196m\]\u\[$(tput sgr0)\] @ \[$(tput sgr0)\]\[\033[38;5;40m\]\h\[$(tput sgr0)\] \[$(tput sgr0)\]\[\033[38;5;208m\]\W\[$(tput sgr0)\]] (\t)\n\[$(tput sgr0)\]\[$(tput bold)\]\[\033[38;5;196m\]\\$\[$(tput sgr0)\] \[$(tput sgr0)\]"
```

说明文档参见以下网站：

[Controlling the Prompt -- Bash Manual](https://www.gnu.org/savannah-checkouts/gnu/bash/manual/bash.html#Controlling-the-Prompt)

更多的 PS1 内容和颜色设置可以在这个网站进行自定义：

[bashrc PS1 generator](https://bashrcgenerator.com/)

### **bash 配置 ble.sh**

[ble.sh](https://github.com/akinomyoga/ble.sh) 是一个使用纯 bash 编写的软件，可以提供代码高亮、自动补全等功能，可以在 AUR 中下载稳定版本：

```bash
yay -S blesh
```

或者开发者版本：

```bash
yay -S blesh-git
```

下载后，需要在 `.bashrc` 文件开头添加：

```bash
[[ $- == *i* ]] && source /usr/share/blesh/ble.sh --noattach
```

并在末尾添加：

```bash
[[ ${BLE_VERSION-} ]] && ble-attach
```

更多设置和用法参考以下网址：

https://github.com/akinomyoga/ble.sh

### **zsh 配置 Oh-My-Zsh**

安装 zsh：

```bash
sudo pacman -S zsh
```

手动安装 Oh-My-Zsh，执行：（不推荐用包管理器安装）

```bash
zsh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

安装插件，执行：

```bash
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-autosuggestions $ZSH_CUSTOM/plugins/zsh-autosuggestions
```

编辑设置文件：

```bash
vim ~/.zshrc
```

选择 Oh-My-Zsh 主题，推荐使用 geoffgarside：

```
ZSH_THEME="geoffgarside"
```

选择 Oh-My-Zsh 插件：

```
plugins=(git zsh-autosuggestions zsh-syntax-highlighting)
```

更新 Oh-My-Zsh，执行：

```
omz update
```

卸载 Oh-My-Zsh，执行:

```
uninstall_oh_my_zsh
```

### **GRUB 美化**

选择主题 grub2-themes，下载地址如下：

https://github.com/vinceliuice/grub2-themes

可选的主题有：Tela/Vimix/Stylish/Slaze/Whitesur

以 Tela grub theme（2K，黑白图标）为例，解压后在文件夹内执行：

```bash
sudo ./install.sh -b -t tela -i white -s 2k
```

删除多余启动条目，需要修改 `/boot/grub/grub.cfg`

删除整一段 `submenu 'Advanced options for Arch Linux'`，删除整一段 `UEFI Firmware Settings`，并将 `Windows Boot Manager (on /dev/nvme0n1p1)` 改为 `Windows`

恢复默认的 `/boot/grub/grub.cfg` 需要输入：

```bash
echo GRUB_DISABLE_OS_PROBER=false | sudo tee -a /etc/default/grub
sudo grub-mkconfig -o /boot/grub/grub.cfg
```

### **Vim 美化**

Vim 的颜色主题推荐使用 [PaperColor](https://github.com/NLKNguyen/papercolor-theme)，需要将其中的 `PaperColor.vim` 文件复制到 `/usr/share/vim/vim82/colors/`，并在 `/etc/vimrc` 中添加：

```
colorscheme PaperColor
```

默认使用暗色主题，如果要使用亮色主题需要在 `/etc/vimrc` 中添加：

```
set background=light
```

### **pacman 添加吃豆人彩蛋**

编辑 `/etc/pacman.conf`

```bash
sudo vim /etc/pacman.conf
```

去掉 `Color` 前面的注释，并在下一行加入：

```
ILoveCandy
```

即可添加吃豆人彩蛋

## **软件的下载与配置**

### **PGP 密钥无法导入**

如果导入 PGP 密钥发生 `gpg: keyserver receive failed: General error` 的问题，将 PGP 密钥复制下来并运行：

```bash
gpg --keyserver keyserver.ubuntu.com --recv-keys (pgp_key)
```

再重新安装软件即可

### **安装软件后在开始菜单中找不到图标**

执行命令：

```bash
sudo update-desktop-database
```

### **Kate 语言包下载**

如果在打开 Kate 的时候出现：

```
kf.sonnet.core: No language dictionaries for the language: "en_US"
```

下载 Kate 语言包：

```bash
sudo pacman -S aspell aspell-en
```

### **运行 AppImage 文件或二进制文件**

AppImage 的扩展名为 `.AppImage`，二进制文件没有扩展名，这两者一般可以直接双击或在终端输入文件名运行：

```bash
(file_name)
```

如果无法启动，则需要添加运行权限：

```bash
chmod +x (file_name)
```

然后双击或在终端输入文件名运行即可

### **使用 SSH 连接到 GitHub**

推荐使用 SSH 连接到 GitHub，其安全性更高，访问速度较快且更加稳定

配置参考以下网址：

[GitHub Docs -- 使用 SSH 连接到 GitHub](https://docs.github.com/cn/github/authenticating-to-github/connecting-to-github-with-ssh)

步骤如下：（Linux 上直接用系统终端，Windows 上需要用 Git Bash 而不能用 Windows Terminal，因为缺少 `eval` 等命令）

#### **生成新 SSH 密钥并添加到 ssh-agent**

```bash
ssh-keygen -t ed25519 -C "(user_email)"
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519
```

第一步会提示输入安全密码，可以按 `Enter` 跳过，不影响后续操作和使用

#### **新增 SSH 密钥到 GitHub 帐户**

通过 `cat ~/.ssh/id_ed25519.pub` 查看公钥并复制到 Github 账户下的“设置 >> SSH and GPG keys”中

#### **测试 SSH 连接**

在终端中输入：

```
ssh -T git@github.com
```

这一步要输入 `yes` 确定

**注意 Linux 上和 Windows 上用的是不同的密钥，Windows 上操作步骤相同，但需要在 Git Bash（而不是 Windows Powershell）上执行**

### **V2Ray 安装与配置**

可以直接使用包管理器安装（`v2raya-git` 在 AUR 软件库）

```bash
yay -S v2ray v2raya-git
```

启动 v2rayA 需要使用 `systemctl`：

```bash
sudo systemctl enable --now v2raya
```

之后 v2rayA 可以开机自启动

注意 `v2ray` 升级到 5.x 版本，需要下载 `v2raya-git`（而不是 `v2raya`）才能支持，旧的 Qv2ray 已经无法使用，以后可能会迁移到 [sing-box](https://sing-box.sagernet.org/)

之后在 [http://localhost:2017/](http://localhost:2017/) 打开 v2rayA 界面，导入订阅链接或服务器链接（ID 填用户的 UUID，AlterID 填 0，Security 选择 Auto，其余选项均为默认）

右上角“设置”中，将“透明代理/系统代理”改为“启用：大陆白名单模式”，保存并应用

选择一个节点，点击左上角柚红色的“就绪”按钮即可启动，按钮变为蓝色的“正在运行”

选择左侧的勾选框可以测试节点的网络连接延时

此时系统测试网络连接的功能被屏蔽，可以通过在 `/etc/NetworkManager/conf.d/20-connectivity.conf` 中写入以下内容关闭此功能：

```
[connectivity] 
enabled=false
```

任务栏图标可以在 [v2rayATray](https://github.com/YidaozhanYa/v2rayATray) 下载

之后下载 [PKGBUILD](https://github.com/YidaozhanYa/v2rayATray/blob/main/PKGBUILD)，在其所在的文件夹下执行 `makepkg -si` 即可安装

v2rayATray 的命令是 `v2raya_tray`，设置它为开机自启动可以在 KDE Plasma 的“系统设置 >> 开机与关机 >> 自动启动”中设置

**浏览器和 KDE Plasma 的网络连接设置都不需要更改**

### **LaTeX 安装**

推荐从 ISO 安装 TeX Live 发行版

首先在[清华大学镜像](https://mirrors.tuna.tsinghua.edu.cn/CTAN/systems/texlive/Images/)或者[上海交大镜像](https://mirrors.sjtug.sjtu.edu.cn/ctan/systems/texlive/Images/)下载 TeX Live ISO，文件名为 `texlive.iso`（和 `texlive(year).iso`、`texlive(year)-(date).iso` 是一致的）

在 Dolphin 中右键点击 ISO 镜像文件挂载（需要 `dolphin-plugins` 软件包），或在终端中运行：

```bash
sudo mount -t iso9660 -o ro,loop,noauto (texlive_path)/texlive.iso /mnt
```

#### **使用命令行界面安装（推荐）**

**使用命令行界面/图形界面安装时一定要加 `sudo`，否则只能将其安装到 `/home/(user_name)/` 下的文件夹且没有 `Create symlinks in standard directories` 一项的设置**

进入镜像文件夹，运行：

```bash
sudo perl install-tl -gui text
```

用大写字母命令控制安装：

```
D >> 1 >> 输入要安装 TeX Live 的位置（`TEXDIR`） >> R
O >> L >> 都选择默认位置（按 Enter） >> R
I
```

`TEXDIR` 建议选择 `/home/(user_name)/` 下的文件夹以方便查看和修改（注意这里的 `~/` 等于 `/root/`，建议使用绝对路径）

`TEXMFLOCAL` 会随 `TEXDIR` 自动更改

CTAN 镜像源可以使用 TeX Live 包管理器 `tlmgr` 更改

更改到清华大学镜像需要在命令行中执行：

```bash
sudo tlmgr option repository https://mirrors.tuna.tsinghua.edu.cn/CTAN/systems/texlive/tlnet
```

更改到上海交大镜像需要在命令行中执行：

```bash
sudo tlmgr option repository https://mirrors.sjtug.sjtu.edu.cn/ctan/systems/texlive/tlnet/
```

#### **使用图形界面安装**

首先要检查是否安装 tcl 和 tk：

```bash
sudo pacman -S tcl tk
```

进入镜像文件夹，运行：

```bash
sudo perl install-tl -gui
```

即可在图形界面下载 TeX Live，高级设置需要点击左下角的 Advanced 按钮

**记住勾选 Create symlinks in standard directories 一项（自动添加到 PATH），Specify directories 选择默认文件夹即可，之后不需要自己添加 PATH**

可以运行 `tex --version` 检查是否安装成功，若成功应显示 TeX 的版本号、TeX Live 的版本号和版权信息

还可以运行 `tlmgr --version` 和 `texdoc (package_name)` （选择常见的宏包名称如 `texdoc amsmath`）检查是否安装成功

### **biber 报错**

biber 是 biblatex 的默认后端，用来替换过时的 biblatex，如果在运行 biber 的过程中出现以下报错：

```
error while loading shared libraries: libcrypt.so.1: cannot open shared object file: No such file or directory
```

需要安装 `libxcrypt-compat`：

```bash
sudo pacman -S libxcrypt-compat
```

### **TeXstudio 安装与配置（可选）**

安装 TeXstudio：

```bash
sudo pacman -S texstudio
```

帮助 >> 检查 LaTeX 安装信息

如果能检测到 LaTeX，说明 TeX Live 安装成功，开始设置

选项 >> 设置 TeXstudio

首先在左下角勾选“显示高级选项”

常规 >> 会话 >> 取消勾选“启动时恢复上一次会话”（可选）

菜单 >> 数学 >> `\frac{}{}` >> `\frac{%|}{}`

菜单 >> 数学 >> `\dfrac{}{}` >> `\dfrac{%|}{}`

快捷键 >> 数学 >> 数学字体格式 >> 罗马字体 >> 当前快捷键 >> `Alt+Shift+R`

编辑器 >> 缩进模式 >> 自动增加或减少缩进

编辑器 >> 缩进模式 >> 勾选“将缩进替换为空格”和“将文本中的制表符（Tab）替换为空格”

编辑器 >> 显示行号 >> 所有行号

编辑器 >> 取消勾选“行内检查”

高级编辑器 >> 自动保存所有文件 >> 1 分钟

高级编辑器 >> 破解/变通 >> 取消勾选“自动选择最佳显示选项”，并勾选“禁用字符宽度缓存”和“关闭固定位置模式”

补全 >> 取消勾选“输入参数”

### **Thunderbird 配置**

#### **Thunderbird 首选项配置**

进入首选项界面调整显示：

首选项 >> 常规 >> Thunderbird 起始页 >> 清空并取消勾选

首选项 >> 常规 >> 默认搜索引擎 >> 改为 Bing

首选项 >> 隐私与安全 >> 邮件内容 >> 勾选“允许消息中的远程内容”

右键点击上方邮件工具栏，选择“自定义”，自行配置即可

#### **Thunderbird 帐号配置**

点击邮箱帐号，配置“账户设置”如下：

服务器 >> 服务器设置 >> 每隔 1 分钟检查一次新消息

服务器 >> 服务器设置 >> 在删除消息时 >> 立即删除

### **Python 安装与配置**

Arch Linux 预装了 Python，但没有安装包管理器，可以使用 `pip` 或 `conda`（即安装 Miniconda）

#### **pip 安装**

在终端中输入：

```bash
curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py && python get-pip.py
```

即可安装 pip，此时不建议安装 conda，pip 下载包的命令是：

```bash
pip install (package_name)
```

这里不建议安装 spyder 和 jupyter notebook，安装最基本的包即可：

```bash
pip install numpy matplotlib astropy black ipython
```

使用 Matplotlib 绘图需要下载 tk 库：

```bash
sudo pacman -S tk
```

#### **Miniconda 安装**

Miniconda 是 Anaconda 的精简版，推荐使用 Miniconda

下载地址如下：

[Miniconda -- Conda documentation](https://docs.conda.io/en/latest/miniconda.html)

或者在[清华大学镜像站](https://mirrors.tuna.tsinghua.edu.cn/#)点击右侧的“获取下载链接”按钮，在“应用软件” >> Conda 里面选择

安装过程参考以下网址：（Miniconda 和 Anaconda 的安装步骤相同）

[Anaconda Documentation -- Installing on Linux](https://docs.anaconda.com/anaconda/install/linux/)

如果使用 `zsh`，需要用 `zsh` 执行安装文件：

```bash
zsh ./Miniconda3-latest-Linux-x86_64.sh
```

并手动在 `~/.zshrc` 中添加 PATH（`miniconda_path` 为 Miniconda 的安装位置）：

```bash
export PATH=(miniconda_path)/bin:$PATH
```

最后用 `source ~/.zshrc` 刷新设置

#### **Miniconda 配置软件源**

输入以下命令：（Windows 用户无法直接创建名为 `.condarc` 的文件，可先执行 `conda config --set show_channel_urls yes` 生成该文件之后再修改）

```bash
vim ~/.condarc
```

修改 `~/.condarc` 以使用清华大学镜像：

```
channels:
  - defaults
show_channel_urls: true
default_channels:
  - https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/main
  - https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/r
  - https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/msys2
custom_channels:
  conda-forge: https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud
  pytorch: https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud
```

或上海交大镜像：

```
channels:
  - defaults
default_channels:
  - https://mirror.sjtu.edu.cn/anaconda/pkgs/main
  - https://mirror.sjtu.edu.cn/anaconda/pkgs/r
  - https://mirror.sjtu.edu.cn/anaconda/pkgs/msys2
custom_channels:
  conda-forge: https://mirror.sjtu.edu.cn/anaconda/cloud/
  pytorch: https://mirror.sjtu.edu.cn/anaconda/cloud/
```

若不用特定的镜像，改为默认值：

```
channels:
  - defaults
ssl_verify: true
```

下载所需要的包：

```bash
conda install numpy matplotlib astropy black ipython
```

各个操作系统平台上可下载的包可以在以下网站查询：

[Anaconda Documentation -- Anaconda Package Lists](https://docs.anaconda.com/anaconda/packages/pkg-docs/)

#### **Conda 常用命令**

列出所有下载的包：

```bash
conda list
```

添加软件源：

```bash
conda config --add channels (channel_URL)
```

下载包：

```bash
conda install (package_name)
```

下载特定版本的包：

```bash
conda install (package_name)=(version_number)
```

下载 [conda-forge](https://conda-forge.org/) 中的软件：

```bash
conda install -c conda-forge (package_name)
```

更新包：（`pip` 没有 `update` 选项，相应命令为 `pip install --upgrade (package_name)`）

```bash
conda update (package_name)
```

更新所有包：（`pip` 不支持更新所有包，但可以用 `pip list --outdated` 列出所有过期包再一个个更新）

```bash
conda update --all
```

删除所有旧版本的包：

```bash
conda clean -p
```

列出并恢复之前的版本：

```bash
conda list --revisions
conda install --revision (revision_number)
```

如果回滚到早期版本（`revision_number` 较小）之后又想回到某个高版本（`revision_number` 较大），必须要把两个版本中的版本都装一遍

列出所有的环境：

```bash
conda env list
```

创建新环境：

```bash
conda create -n (environment_name)
```

Conda 默认会在 Miniconda/Anaconda 的安装位置创建一个 `base` 环境

激活环境：

```bash
source activate (environment_name)
```

取消激活环境：

```bash
source deactivate (environment_name)
```

删除环境：

```bash
conda env remove -n (environment_name)
```

#### **加入 AstroConda 软件源**

在终端中输入：

```bash
conda config --add channels http://ssb.stsci.edu/astroconda
```

这相当于在 `~/.condarc` 中 `channels` 一栏改为：

```
channels:
  - defaults
  - http://ssb.stsci.edu/astroconda
```

这样就可以下载 `wcstools` 等软件

#### **下载 photutils**

需要在 conda-forge 中下载：

```bash
conda install -c conda-forge photutils
```

#### **Spyder 配置**

通用 >> 显示器分辨率 >> 自定义高分辨率缩放 >> 1.0

编辑选定的方案：

文本：

```
普通文本 #000000
注释：#999999, B
字符串：#00aa00
数值：#aa0000
关键字：#ff5500, B
内置：#990099
定义：#0000ff
实例：#ff55ff, B
```

高亮：

```
当前 Cell：#ffaaff
当前行：#aaffff
事件：#ffff00
匹配圆括号：#99ff99
不匹配圆括号：#ff9999
链接：#55ff00
```

编辑器 >> 勾选“显示标签栏”、“显示缩进指导”、“显示行号”、“高亮显示当前行”、“高亮显示当前 Cell”，并把“高亮延迟时间”设定为 100 毫秒

用 Spyder 打开某个文件需要在终端中输入：

```bash
spyder (file_path)/(file_name)
```

Linux 上 Spyder 需要在 conda 中安装 `fcitx-qt5` 才能支持 Fcitx/Fcitx5 输入中文字符：

```
conda install -c conda-forge fcitx-qt5
```

### **Visual Studio Code 安装与配置**

#### **Visual Studio Code 安装**

发行版维护者从开源代码构建的版本，可以用 `code` 命令打开（缺点是图标被重新设计过，且更新落后于微软官方版）：

```bash
sudo pacman -S code
```

微软官方的二进制包（包含部分私有的组件），同样可以用 `code` 命令打开（如果不介意私有组件而且不习惯 Code - OSS 的图标，个人推荐首选此项）：

```bash
yay -S visual-studio-code-bin
```

内测版本：

```bash
yay -S visual-studio-code-insiders-bin
```

第三方发布的从开源代码构建的二进制包：

```bash
yay -S vscodium-bin
```

从最新的开源代码构建：

```bash
yay -S vscodium-git
```

下载扩展：Python（会自动下载 Pylance、Jupyter 等扩展），LaTeX Workshop，C/C++，Markdown all in One，Prettier - Code formatter

扩展保存在 `~/.vscode/extensions/` 文件夹内

#### **Visual Studio Code 设置**

若要更改全局设置，设置文件在 `~/.config/Code/User/settings.json`，可以在 Visual Studio Code 中按 `Ctrl+,` 开启设置

若要更改全局快捷键，设置文件在 `~/.config/Code/User/keybindings.json`，可以在 Visual Studio Code 中按 `Ctrl+K Ctrl+S` 开启设置

#### **Visual Studio Code 连字设置**

在 `setting.json` 中关闭连字：

```json
"editor.fontLigatures": false,
```

Fira Code 的连字可以设置为：

```json
"editor.fontFamily": "Fira Code",
"editor.fontLigatures": "'calt' off, 'cv16', 'ss01', 'ss03', 'ss05', 'zero'",
```

#### **Visual Studio Code 无法识别 Git 存储库**

如果 Visual Studio Code 无法识别文件夹内的 Git 存储库（显示“当前打开的文件夹中没有 Git 存储库”），是因为 Git 认为该文件夹不安全，需要对该文件夹执行：

```bash
git config --global --add safe.directory (directory_path)
```

`(directory_path)` 不能用 `./` 或 `../`，最好用绝对路径

文件夹安全性状态可以通过 `git status` 查看

如果要完全跳过检查，执行：

```bash
git config --global --add safe.directory "*"
```

#### **Visual Studio Code 图标更改（可选）**

如果图标美化后 Visual Studio Code 图标变成圆形，想恢复原图标，更改路径如下：

程序启动器 >> 编辑应用程序 >> Visual Studio Code >> 点击图标更改 >> 其他图标

其图标位置在 `/usr/share/icons/visual-studio-code.png`

#### **Visual Studio Code 缩放比例（可选）**

放大比例：`Ctrl+=`

缩小比例：`Ctrl+-`

### **Visual Studio Code 插件配置**

#### **Latex Workshop 插件设置**

若想在 [LaTeX Workshop](https://github.com/James-Yu/LaTeX-Workshop) 里面添加 `\frac{}{}` 命令的快捷键为 `Ctrl+M Ctrl+F`，则添加一段：

```json
{
    "key": "ctrl+m ctrl+f",
    "command": "editor.action.insertSnippet",
    "args": { "snippet": "\\frac{$1}{$2}$0" },
    "when": "editorTextFocus && !editorReadonly && editorLangId =~ /latex|rsweave|jlweave/",
}
```

若要更改行间公式 `\[\]` 的自动补全（公式独占一行），在 `~/.vscode/extensions/james-yu.latex-workshop-(version_number)/data/commands.json` 中找到 `"command": "["` 一段（即“display math”），将 `"snippet"` 的值改为：

```json
"[\n    ${1}\n\\]"
```

重启 Visual Studio Code 即可生效

#### **Markdown All in One 插件设置**

Visual Studio Code 自带 Markdown 预览功能，但是不支持快捷键（如粗体、斜体）、数学命令的补全（只支持预览），也不支持复选框：

```
- [x] item 1
- [ ] item 2
```

[Markdown All in One](https://github.com/yzhang-gh/vscode-markdown) 提供了粗体、斜体等的快捷键，对数学公式补全支持较好，也支持复选框，缺点是不支持自动补全配对括号（在设置中将所有语言的括号自动配对打开即可），即在 `setting.json` 中设置为：

```json
"editor.autoClosingBrackets": "always",
"markdown.extension.math.enabled": false,
```

而 Markdown 预览支持最好的插件是 [Markdown Preview Enhanced](https://github.com/shd101wyy/markdown-preview-enhanced)，使用时可以选择插件预览或默认预览

### **JetBrains Fleet 安装**

JetBrains Fleet 已经在 AUR 上打包：

```bash
yay -S jetbrains-fleet
```

### **Typora 美化**

#### **源代码模式**

更改 `/usr/share/typora/resources/style/base-control.css`：（在 Windows 中则是 `C:\Program Files\Typora\resources\style\base-control.css`）

找到 `.CodeMirror.cm-s-typora-default div.CodeMirror-cursor` 一行，将光标宽度改为 `1px`，颜色从 `#e4629a` 改为 `#000000`

更改 `/usr/share/typora/resources/style/base.css`：（在 Windows 中则是 `C:\Program Files\Typora\resources\style\base.css`）

找到 `:root` 一行，将 `--monospace` 改成自己想要的等宽字体

#### **主题渲染模式**

在 `/home/(user_name)/.config/Typora/themes/` 中自己写一个 CSS 文件（可以复制其中一个默认主题，重命名后更改）

找到 `body` 一行，将 `font-family` 改成自己想要的字体

找到 `tt` 一行，将 `font-family` 改成自己想要的等宽字体（`monospace`）

### **SAOImageDS9 安装**

推荐选择二进制包 `ds9-bin`：

```bash
yay -S ds9-bin
```

如果出现这样的错误导致 SAOImageDS9 无法打开或闪退：

```
application-specific initialization failed: unknown color name "BACKGROUND"
Unable to initialize window system.
```

在终端中输入：

```bash
xrdb -load /dev/null
xrdb -query
```

即可解决

### **IRAF/PyRAF 安装**

#### **从源代码安装（推荐）**

从源代码安装 IRAF/PyRAF 较为复杂，但软件版本较新，且支持 Python 3

首先从 GitHub 上下载软件源代码，网址如下：

[IRAF -- GitHub](https://github.com/iraf-community/iraf)

新建一个文件夹，例如 `~/.iraf-source` 用于存放解压后得到的源代码

进入 `~/.iraf-source`，首先运行安装脚本：

```bash
./install
```

这里的选项全部选择默认即可，此时会新建一个 `~/.iraf` 文件夹

下一步是将 IRAF 添加到 PATH：

```bash
export PATH=/home/(user-name)/.iraf/bin/:$PATH
```

此时便可以在 `~/.iraf-source` 中编译安装 IRAF（这一步需要的时间较长）：

```bash
make linux64
make sysgen 2>&1 | tee build.log
```

接下来安装 PyRAF：

```bash
pip install pyraf
```

**在使用 IRAF/PyRAF 之前，需要在该文件夹运行 `mkiraf` 命令，才能使用**

#### **从 AstroConda 安装**

从 AstroConda 安装 IRAF/PyRAF 较为简便，缺点是软件版本较旧（仍是 PyRAF 2.1.15），且依赖 Python 2.7

首先需要用 `conda config --add channels http://ssb.stsci.edu/astroconda` 加入 AstroConda 软件源，并推荐单独建立一个 IRAF 环境 `(iraf_environment)` 安装 IRAF/PyRAF：

```bash
conda create -n (iraf_environment) python=2.7 iraf-all pyraf-all stsci
source activate (iraf_environment)
```

#### **IRAF/PyRAF 常用命令**

启动 IRAF：

```bash
cl
```

启动 PyRAF：

```bash
pyraf
```

退出 IRAF：

```
logout
```

退出 PyRAF：

```
exit()
```

启动参数编辑器（the EPAR Parameter Editor）的命令为：

```
epar (task_name)
```

### **Geant4 安装**

#### **从源代码安装 Geant4**

从官网上下载源代码压缩包：

[Geant4 -- Download](https://geant4.web.cern.ch/support/download)

进入解压后的文件夹

若要将 Geant4 安装在 `(Geant4_directory)`，例如 `~/Geant4`，执行：

```bash
mkdir build
cd build
cmake -DCMAKE_INSTALL_PREFIX=(Geant4_directory) -DGEANT4_USE_OPENGL_X11=ON -DGEANT4_USE_QT=ON -DGEANT4_INSTALL_DATA=ON -DGEANT4_BUILD_MULTITHREADED=ON ..
make -j8
make install
```

在 `~/.bashrc` 中添加一行：

```bash
source (Geant4_directory)/bin/geant4.sh
```

#### **检验是否安装成功**

打开 `(Geant4_directory)/share/Geant4-(version_number)/examples/basic/B1`，执行：

```bash
mkdir build
cd build
cmake ..
make -j8
./exampleB1
```

如果出现图形交互界面，说明安装成功

### **微信安装（可选）**

微信官方原生桌面版（原生适配高分辨率屏幕，不需要 wine/deepin-wine 即可运行；但是功能较少，不支持截屏和“订阅号消息”，显示 emoji 需要下载 `noto-fonts-emoji`）：

```bash
yay -S com.tencent.weixin
```

功能较多，和最新的 Windows 电脑版同步更新，但依赖 deepin-wine，且暂不支持“截屏时隐藏当前窗口”的版本：

```bash
yay -S deepin-wine-wechat
```

#### **deepin-wine-wechat 高分辨率适配调整**

用命令 `/opt/apps/com.qq.weixin.deepin/files/run.sh winecfg` 调出 Wine Configuration，对于 200% 的放大率：

Graphics >> Screen Resolution >> 192 dpi

其余基于 Deepin Wine 的软件（如腾讯会议 `com.tencent.deepin.meeting`）也是类似的处理方法，将 `com.qq.weixin.deepin` 换成对应的文件夹名称即可（都在 `/opt/apps/` 目录下）

### **会议软件安装（可选）**

#### **腾讯会议**

推荐安装官方原生的腾讯会议 Linux 版：

```bash
yay -S wemeet-bin
```

也有基于 Deepin Wine 的版本可供选择：

```bash
yay -S com.tencent.deepin.meeting
```

#### **钉钉**

```bash
yay -S dingtalk-bin
```

高分辨率可以点击头像 >> 设置 >> 全局缩放，选择 150%

#### **Zoom**

```bash
yay -S zoom
```

#### **Microsoft Teams**

```bash
yay -S teams
```

#### **Slack**

```bash
yay -S slack-desktop
```

### **音乐软件安装（可选）**

#### **网易云音乐**

```bash
yay -S netease-cloud-music
```

#### **QQ 音乐**

```bash
yay -S qqmusic-bin
```

默认是暗色主题，右上角皮肤键（衣服图案）可以更改为亮色主题

### **GitHub Desktop 安装（可选）**

推荐选择二进制包 `github-desktop-bin`：

```bash
yay -S github-desktop-bin
```

登录时要创建一个密钥环，密钥设为 GitHub 密码即可

### **办公软件安装（可选）**

WPS 安装：

```bash
yay -S wps-office-cn wps-office-mui-zh-cn ttf-wps-fonts
```

LibreOffice 安装：

```bash
yay -S libreoffice-fresh
```

### **百度网盘安装（可选）**

```bash
yay -S baidunetdisk-bin
```

### **应用程序的快捷键配置（可选）**

应用程序的快捷键配置在：

系统设置 >> 快捷键

若没有想要的应用程序，可以点击下方的“添加应用程序”，例如设置 `Meta+Return`（即“Windows 徽标键 + Enter 键”）为启动 Konsole 的快捷键：

系统设置 >> 快捷键 >> 添加应用程序 >> Konsole >> Konsole 的快捷键设为 `Meta+Return`

### **用 debtap 安装 `.deb` 包（不推荐）**

首先要下载并更新 debtap 包：

```bash
yay -S debtap
sudo debtap -u
```

**运行 `sudo debtap -u` 时建议连接北京大学校园网**

进入含有 `.deb` 安装包的文件夹，输入：

```bash
sudo debtap (package_name).deb
```

系统会询问三个问题：文件名随便写，协议写软件包所用的协议，编辑文件可以直接按 `Enter` 跳过

此处会生成一个 `tar.zst` 包，双击打开（右键用“软件安装程序”打开）即可安装