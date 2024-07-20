# **在 ThinkPad X13 2021 Intel 上安装 Arch Linux KDE Plasma + Windows 11 双系统的指南**

```text
Operating System: Arch Linux
KDE Plasma Version: 6.1.2
KDE Frameworks Version: 6.4.0
Qt Version: 6.7.2
Kernel Version: 6.9.10-arch1-1 (64-bit)
Graphics Platform: Wayland
Processors: 8 × 11th Gen Intel® Core™ i7-1165G7 @ 2.80GHz
Memory: 15.3 GiB of RAM
Graphics Processor: Mesa Intel® Xe Graphics
Manufacturer: LENOVO
Product Name: 20WKA000CD
System Version: ThinkPad X13 Gen 2i
```

## **准备工作**

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

[Archiso -- ArchWiki](https://wiki.archlinux.org/title/Archiso)

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

**Windows 安装程序会创建一个 100MiB 的 EFI 系统分区，一般并不足以放下双系统所需要的所有文件（即 Linux 的 GRUB 文件），可以在将 Windows 安装到盘上之前就用 Arch 安装媒体创建一个较大的 EFI 系统分区（建议多于 256MiB），之后 Windows 安装程序将会使用你自己创建的 EFI 分区，而不是再创建一个**

### **关闭快速启动**

Windows 工具 >> 控制面板 >> 电源选项 >> 选择电源按钮的功能 >> 更改当前不可用的设置 >> 关闭快速启动 >> 保存修改

### **关闭 Secure Boot**

#### **进入 UEFI/BIOS 设置**

ThinkPad 的操作如下：启动 ThinkPad 时按 `Enter` 打断正常开机，然后按下 `Fn+Esc` 解锁 `Fn` 按钮，再按 `Fn+F1` 进入 UEFI/BIOS 设置

#### **关闭 Secure Boot**

在 UEFI/BIOS 设置界面：

ThinkPad 的操作如下：Security >> Secure Boot >> Off

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

之后直接将 ISO 镜像拷贝到 USB 中（这一步需要数分钟）：

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

对于无线局域网（WLAN）和无线广域网（WWAN），请确保网卡未被 `rfkill` 禁用：

```bash
rfkill
```

此时应该全部显示 `unblocked`，否则使用命令 `rfkill unblock (type_name)` 启用，例如 `rfkill unblock wlan`

如果使用有线以太网，连接网线即可

如果使用 WiFi，使用 `iwctl` 连接无线网络：

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

```text
ping -c (count_number) archlinux.org
```

### **更新系统时间**

使用 `timedatectl` 开启 NTP 同步时间，确保系统时间是准确的：

```bash
timedatectl set-ntp true
```

### **建立硬盘分区**

**对 Linux 分区建议使用 BTRFS/XFS/EXT4 文件系统**

可以使用 `lsblk -f` 或 `fdisk -l` 查看硬盘 `/dev/(disk_name)`，如 `/dev/sda`、`/dev/nvme0n1` 等，前者多用于 HDD，后者多用于 SSD

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

[GNU Parted User Manual](https://www.gnu.org/software/parted/manual/parted.html)

### **创建文件系统**

例如，要在根分区 `/dev/(root_partition)` 上创建一个 BTRFS 文件系统，请运行：

```bash
mkfs.btrfs /dev/(root_partition)
```

XFS 和 EXT4 对应的命令就是 `mkfs.xfs` 和 `mkfs.ext4`

如果需要覆盖原有分区，加入 `-f` 参数强制执行即可

### **挂载分区**

首先将根磁盘卷挂载到 `/mnt`

```bash
mount /dev/(root_partition) /mnt
```

对于 UEFI 系统，挂载 EFI 系统分区（一般是 `lsblk` 输出的第一个分区，文件系统一般是 FAT32）：

```bash
mount --mkdir /dev/(efi_system_partition) /mnt/boot
```

**挂载 EFI 系统分区一定要加 `--mkdir` 参数**

### **选择镜像源**

**一般建议选择清华大学镜像和上海交大镜像，这两个镜像站覆盖较全、稳定且积极维护**

编辑 `/etc/pacman.d/mirrorlist`（ISO 镜像中自带有 `vim` 等常用编辑器）：

```bash
vim /etc/pacman.d/mirrorlist
```

按 `:` 进入命令模式，输入 `:%d`并按 `Enter` 删除全部内容，添加：

```text
Server = https://mirrors.tuna.tsinghua.edu.cn/archlinux/$repo/os/$arch
```

改为清华大学镜像

或添加：

```text
Server = https://mirror.sjtu.edu.cn/archlinux/$repo/os/$arch
```

改为上海交大镜像

**这个文件接下来还会被 `pacstrap` 复制到新系统里，所以请确保设置正确**

### **安装必需的软件包**

使用 `pacstrap` 脚本，安装 base 软件包、Linux 内核、常规硬件的固件、文本编辑器等：

```bash
pacstrap /mnt base linux linux-firmware sof-firmware vim
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
pacman -Syu
```

### **时区**

设置时区：

```bash
ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
hwclock --systohc
```

### **本地化**

编辑 `/etc/locale.gen`：

```bash
vim /etc/locale.gen
```

取消掉 `en_US.UTF-8 UTF-8` 和 `zh_CN.UTF-8 UTF-8` 两行的注释

接着生成 locale 信息：

```bash
locale-gen
```

然后创建 `/etc/locale.conf` 文件，并编辑设定 `LANG` 变量：

```text
LANG=en_US.UTF-8
```

**不推荐在 `locale.conf` 中设置任何中文 locale，会导致 TTY 乱码**

### **网络配置**

创建 `/etc/hostname` 文件，写入自定义的主机名：

```text
(my_hostname)
```

编辑本地主机名解析 `/etc/hosts`，写入：（编辑 `/etc/hosts` 时空白建议用 `Tab` 键，下同）

```text
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

执行 `ls /boot` 检查 `/boot` 中是否有遗留的旧内核 initramfs，若有则删除之

之后执行以下命令：

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

首先下载 `grub` 和 `efibootmgr`

```bash
pacman -S grub efibootmgr
```

输入 `efibootmgr` 可以查看所有的启动项，每一个启动项都有一个四位数字的编号 `(boot_number)`，可以使用 `efibootmgr -b (boot_number) -B` 命令删除原来的启动项

接着执行以下命令：

```bash
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=Arch
```

最后更新 GRUB 设置：

```bash
grub-mkconfig -o /boot/grub/grub.cfg
```

### **重启**

输入 `exit` 退出 chroot 环境

输入 `umount -R /mnt` 手动卸载被挂载的分区

最后，执行 `reboot` 重启系统，`systemd` 将自动卸载仍然挂载的任何分区

**不要忘记移除安装介质**

## **初始配置**

**现在登录到新装好的系统时使用的是 Root 用户，用户名为 `root`，需要手动输入**

### **连接网络**

命令行输入 `nmtui` 并按照终端上的图形界面一步一步操作

### **设置新用户**

设置用户名为 `(user_name)`，建议只使用小写字母和数字：

```bash
useradd -m -G wheel (user_name)
```

为用户创建密码

```bash
passwd (user_name)
```

**一定要设置在 wheel 用户组里面**

### **sudo 配置**

首先需要下载 `sudo` 软件包：

```bash
pacman -S sudo
```
sudo 的配置文件是 `/etc/sudoers`，更改配置需要使用命令 `visudo`，其默认编辑器是 Vi，若要改为 Vim，则首先在终端中输入以下命令用 Vim 打开 `visudo`：

```bash
EDITOR=vim visudo
```

#### **更改默认编辑器为 Vim**

在开头的一个空行键入：

```text
Defaults editor=/usr/bin/vim
```

按 `Esc` 进入命令模式，再按 `:x` 保存，按 `Enter` 退出

#### **用户组授权**

取消注释 `%wheel ALL=(ALL) ALL`

如果不想每次执行 Root 用户命令都输入密码，可以取消注释 `%wheel ALL=(ALL) NOPASSWD: ALL`

**必须保留最前面的 `%`，这不是注释的一部分**

#### **单个用户免密码**

在最后一行（空行）按 `i` 进入输入模式，加上这一行：

```text
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

#### **安装 Wayland 和 SDDM**

安装 Wayland：

```bash
pacman -S wayland
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

可以排除掉一些软件包，如 `discover`、`drkonqi`、`flatpak-kcm`、`plasma-firewall`、`plasma-welcome`

`jack` 选择 `jack2`

`qt6-multimedia-backend` 选择 `qt6-multimedia-ffmpeg`

`emoji-font` 选择 `noto-fonts-emoji`

#### **安装必要的软件**

```bash
pacman -S firefox konsole dolphin dolphin-plugins ark kate gwenview spectacle yakuake okular poppler-data git adobe-source-han-sans-cn-fonts adobe-source-han-serif-cn-fonts
```

`firefox` 也可以替换为其余浏览器，但可能需要使用 AUR 软件包管理器（使用方法见下文），例如 `microsoft-edge-stable-bin` 和 `google-chrome`

`dolphin-plugins` 提供了右键菜单挂载 ISO 镜像等选项

`poppler-data` 是 PDF 渲染所需的编码数据，不下载 `poppler-data` 会导致部分 PDF 文件的中文字体无法在 Okular 中显示

**KDE Frameworks/KDE Gear/Plasma 的更新时间表可以在 [KDE Community Wiki](https://community.kde.org/Schedules) 查看**

## **在图形界面下设置**

**现在重启电脑后即可进入图形界面，用户从 Root 变为新建的普通用户**

### **系统设置**

**此时系统语言为英语，可以执行 `export LANGUAGE=zh_CN.UTF-8` 将终端输出修改为中文，再执行 `systemsettings` 打开系统设置**

#### **语言和区域设置**

**将系统语言改为中文需要保证 `localectl list-locales` 输出包含 `zh_CN.UTF-8` 并且安装了中文字体（否则会缺字无法显示）**

系统设置 >> 区域和语言 >> 语言 >> 改为“简体中文”

其余“数字”、“时间”、“货币”等选项可以分别修改，可以搜索“China”找到“简体中文”

#### **电源、开机、锁屏设置**

系统设置 >> 省电功能 >> 节能 >> “交流供电”以及“电池供电” >> 合上笔记本盖时 >> 选择“息屏”

系统设置 >> 会话 >> 桌面会话 >> 登入时 >> 选择“启动为空会话”

系统设置 >> 锁屏 >> 自动锁定屏幕 >> 调整空闲时间

#### **高分辨率设置**

Wayland 会自动启用缩放率 175% 和光标大小 24，如果不合适可以如下调整：

系统设置 >> 显示和监视器 >> 分辨率 >> 缩放率 >> 200%

系统设置 >> 显示和监视器 >> 旧式应用程序（X11） >> 由应用程序进行缩放

系统设置 >> 光标 >> 大小 >> 18

#### **SDDM 设置**

系统设置 >> 颜色和主题 >> 登录屏幕（SDDM） >> 选择“Breeze 微风” >> 应用 Plasma 设置

创建文件 `/etc/sddm.conf.d/hidpi.conf`，并加入以下内容：

```text
[General]
GreeterEnvironment=QT_SCREEN_SCALE_FACTORS=2,QT_FONT_DPI=192

[Wayland]
EnableHiDPI=true
```

然后重启电脑

#### **锁屏设置**

自动锁定屏幕的时间和锁屏界面的外观等在此处设置：

系统设置 >> 工作区行为 >> 锁屏

#### **自动启动设置**

系统设置 >> 自动启动

可以添加 Yakuake 下拉终端为自动启动

#### **自动挂载设置**

系统设置 >> 磁盘和相机 >> 设备自动挂载 >> 所有设备

勾选“登录时”和“插入时”，以及“自动挂载新的可移动设备”

### **终端快捷键配置**

打开终端 Konsole/Yakuake（Yakuake 设置自动启动后可以用 `Fn+F12` 直接打开）：

设置 >> 配置键盘快捷键 >> 复制改为 `Ctrl+C` ，粘贴改为 `Ctrl+V`，查找改为 `Ctrl+F`

### **pacman 包管理器的使用技巧**

这里介绍了 `pacman` 包管理器的常用操作

更多操作参考以下网址：

[Pacman -- ArchWiki](https://wiki.archlinux.org/title/Pacman)

也可以使用 `man pacman` 和 `man pacman.conf` 查询

#### **下载软件包**

下载软件包：

```bash
sudo pacman -S (package_name)
```

#### **删除软件包**

删除软件包：

```bash
sudo pacman -R (package_name)
```

删除软件包，及其所有未被其他已安装软件包依赖的软件包：

```bash
sudo pacman -Rs (package_name)
```

删除软件包，及其 `pacman` 备份文件：

```bash
sudo pacman -Rn (package_name)
```

#### **更新软件包**

更新所有软件包：

```bash
sudo pacman -Syu
```

#### **搜索软件包**

`pacman` 使用 `-Q` 参数查询本地软件包数据库，`-S` 查询远程数据库（包含全部软件包），以及 `-F` 查询文件数据库。要了解每个参数的子选项，分别参见 `pacman -Q --help`，`pacman -S --help` 和 `pacman -F --help`

在远程数据库中查询软件包：

```bash
pacman -Ss (package_name)
```

搜索已安装的软件包：（`-s` 会使用正则表达式匹配所有相似的结果，如果没有 `-s` 会只显示全词匹配）

```bash
pacman -Qs (package_name)
```

列出所有已安装的软件包：

```bash
pacman -Q
```

列出所有已安装的仓库外（一般就是 AUR）软件包：

```bash
pacman -Qm
```

列出所有孤立软件包（不再作为依赖的软件包），可以加 `-q` 选项不显示版本号：

```bash
pacman -Qdt
```

获取已安装软件包所包含文件路径（比如用来查看软件包提供了什么可执行文件）：

```bash
pacman -Ql (package_name)
```

查询文件属于远程数据库中的哪个软件包：

```bash
pacman -F (file_name)
```

查询远程库中软件包包含的文件：

```bash
pacman -Fl (package_name)
```

#### **检查依赖关系**

以树状图的形式展示某软件包的依赖关系：（需要下载 `pacman-contrib` 软件包）

```bash
pactree (package_name)
```

#### **降级软件包**

在 `/var/cache/pacman/pkg/` 中找到旧软件包，双击打开安装实现手动降级，参考以下网址：

[Downgrading Packages -- ArchWiki](https://wiki.archlinux.org/title/Downgrading_packages)

#### **清理缓存**

`pacman-contrib` 软件包提供的 `paccache` 脚本默认会删除所有缓存的版本和已卸载的软件包，除了最近的3个会被保留：

```bash
sudo paccache -r
```

更激进的方式是使用 `pacman` 清理全部软件安装包缓存：（即删除 `/var/cache/pacman/pkg/`、`/var/lib/pacman/` 下的全部内容）

```bash
sudo pacman -Scc
```

清理无用的孤立软件包：

```bash
sudo pacman -R $(pacman -Qdtq)
```

若显示 `error: no targets specified (use -h for help)` 则说明没有孤立软件包需要清理

**若不小心终止了 `pacman` 进程，则需要先删除 `/var/lib/pacman/db.lck` 才能再次启动 `pacman`**

#### **从本地安装包安装软件**

pacman 有从本地安装包安装软件的功能，只需输入：

```bash
sudo pacman -U (package_name).tar.zst
```

#### **从 PKGBUILD 安装软件**

在 PKGBUILD 所在的文件夹内执行：

```bash
makepkg -si
```

即可安装

### **AUR 软件仓库**

首先安装 `base-devel` 软件包：

```bash
sudo pacman -S base-devel
```

之后下载支持 AUR 的软件包管理器

**注意 Arch 预装的包管理器 pacman 不支持 AUR，也不打包 AUR 软件包管理器，需要单独下载 AUR 软件包管理器**

#### **paru**

paru 是一个支持官方仓库和 AUR 仓库的命令行软件包管理器

执行以下命令安装 paru：（需要保证能够连接 GitHub，一般需要修改 hosts）

```bash
git clone https://aur.archlinux.org/paru-bin.git
cd paru-bin
makepkg -si
```

paru 是一个 pacman 封装，其命令与 pacman 基本相同，即将上一节的 `pacman/sudo pacman` 替换为 `paru`

详细使用教程参考以下网址：

[paru -- GitHub](https://github.com/Morganamilo/paru)

也可以使用 `man paru` 和 `man paru.conf` 查询

如果不想让 `paru` 下载软件包时显示 `PKGBUILD` 文件内容，需要在 `/etc/paru.conf` 的 `[options]` 一栏中加入一行 `SkipReview`

#### **octopi**

octopi 是一个使用图形界面的软件包管理器，执行以下命令安装 `pamac`：

```bash
git clone https://aur.archlinux.org/octopi.git
cd octopi
makepkg -si
```

其使用教程参考以下网址：

[Octopi -- Tinta escura](https://tintaescura.com/projects/octopi)

octopi 的 AUR 支持需要点击中间的绿色外星人图标，依赖 paru 等软件包管理器

### **Arch Linux CN 软件仓库（可选）**

在 `/etc/pacman.conf` 文件末尾添加以下两行以启用清华大学镜像：

```text
[archlinuxcn]
Server = https://mirrors.tuna.tsinghua.edu.cn/archlinuxcn/$arch
```

或上海交大镜像：

```text
[archlinuxcn]
Server = https://mirrors.sjtug.sjtu.edu.cn/archlinux-cn/$arch
```

之后执行下面的命令安装 `archlinuxcn-keyring` 包导入 GPG 密钥

```bash
sudo pacman -Sy archlinuxcn-keyring
sudo pacman -Syu
```

这样就开启了 pacman 对 Arch Linux CN 的支持

**注意一定要写第一行的 `[archlinuxcn]`，安装 archlinuxcn-keyring 时要用 `-Sy` 安装（更新后安装）**

### **Arch4edu 软件仓库（可选）**

Arch4edu 是面向高校用户推出的非官方软件仓库，支持 Arch Linux 和 Arch Linux ARM，主要包含高校用户常用的科研、教学及开发软件

首先导入 GPG 密钥：

```bash
pacman-key --recv-keys 7931B6D628C8D3BA
pacman-key --finger 7931B6D628C8D3BA
pacman-key --lsign-key 7931B6D628C8D3BA
```

在 `/etc/pacman.conf` 文件末尾添加以下两行以启用清华大学镜像：

```text
[arch4edu]
Server = https://mirrors.tuna.tsinghua.edu.cn/arch4edu/$arch
```

最后更新系统：

```bash
sudo pacman -Syu
```

这样就开启了 pacman 对 Arch4edu 的支持

### **双系统启动设置**

下载 `os-prober`：

```bash
sudo pacman -S os-prober
```

想要让 `grub-mkconfig` 探测其他已经安装的系统并自动把他们添加到启动菜单中，编辑 `/etc/default/grub` 并取消下面这一行的注释：

```text
GRUB_DISABLE_OS_PROBER=false
```

想要让 GRUB 记住上一次启动的启动项，首先将 `GRUB_DEFAULT` 的值改为 `saved`，再取消下面这一行的注释：

```text
GRUB_SAVEDEFAULT=true
```

使用 `grub-mkconfig` 工具重新生成 `/boot/grub/grub.cfg`：

```bash
sudo grub-mkconfig -o /boot/grub/grub.cfg
```

此时会显示找到 Windows Boot Manager，说明设置双系统成功

如果下载了 AUR 软件包 `update-grub`，则可以直接执行 `sudo update-grub` 更新 GRUB 设置

### **Linux 挂载 Windows 磁盘**

#### **使用 fstab 文件**

**首先要确保设备加密和快速启动已经关闭，以下内容针对 Linux 5.15 及之后的内核中引入的 NTFS3 驱动**

官方推荐的方法是使用 UUID，以分别挂载 C 盘和 D 盘到 `/home/(user_name)/C` 和 `/home/(user_name)/D` 为例，在终端中输入：

```bash
lsblk -f
```

在输出结果中可以发现 Windows 的硬盘分区，其中第一列（`NAME`）是卷标，第四列（`UUID`）是 UUID：

```text
NAME       FSTYPE       LABEL   UUID
├─(name_C) ntfs         C       (UUID_C)
├─(name_D) ntfs         D       (UUID_D)
```

接着就来修改系统文件：

```bash
sudo vim /etc/fstab
```

在最后加入这两行：（编辑 `/etc/fstab` 时空白建议用 `Tab` 键）

```text
UUID=(UUID_C)                     /home/(user_name)/C    ntfs3 defaults,windows_names,hide_dot_files,umask=000 0 0
UUID=(UUID_D)                     /home/(user_name)/D    ntfs3 defaults,windows_names,hide_dot_files,umask=000 0 0
```

重启电脑后，即可自动挂载

**如果需要格式化 C 盘或 D 盘，先从 `/etc/fstab` 中删去对应的行，再操作，之后磁盘的 `UUID` 会被更改，再编辑 `/etc/fstab` ，重启挂载即可**

如果安装生成 fstab 文件时使用 `-L` 选项，即 `genfstab -L /mnt >> /mnt/etc/fstab`，则 `/etc/fstab` 中应加入：

```text
/dev/(name_C)                     /home/(user_name)/C    ntfs3 defaults,windows_names,hide_dot_files,umask=000 0 0
/dev/(name_D)                     /home/(user_name)/D    ntfs3 defaults,windows_names,hide_dot_files,umask=000 0 0
```

参考以下网址：

[fstab -- Archwiki](https://wiki.archlinux.org/title/fstab)

[mount(8) -- Arch manual pages](https://man.archlinux.org/man/mount.8)

[NTFS3 — The Linux Kernel documentation](https://docs.kernel.org/filesystems/ntfs3.html)

#### **命令行挂载 NTFS 移动硬盘**

首先使用 `lsblk` 查看硬盘分区 `/dev/(partition_name)`，如 `/dev/sda1`

之后设置挂载点，默认是在 `/run/media/(user_name)/` 下创建一个和硬盘分区名称一致的文件夹：

```bash
cd /run/media/(user_name)/
sudo mkdir ./(partition_name)
```

也可以选择 `/mnt` 作为临时挂载点

再将移动硬盘挂载到新创建的文件夹，如：

```bash
sudo mount -t ntfs3 -o force /dev/(partition_name) /run/media/(user_name)/(partition_name)
```

### **网络设置**

#### **网络设备**

在终端中输入：

```bash
ip a
```

输出网络设备名称的前两个字母表示设备种类：

`lo` 为回环（loopback），`ww` 为无线广域网（WWAN，负责移动宽带连接），`wl` 为无线局域网（WLAN，负责 Wi-Fi 连接），`en` 为以太网（Ethernet，负责网线连接）

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
nmcli connection edit "PKU Secure"
```

在 `nmcli` 界面内输入：

```text
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
sudo systemctl enable --now ModemManager
```

此时 Plasma 系统托盘的网络设置会多出一个移动宽带的图标选项

在“系统设置 >> WiFi 和网络”中，点击右下角的加号创建新的链接，选择“移动宽带”并创建，按照以下步骤设置：

设置移动宽带连接 >> 任何 GSM 设备

国家 >> 中国

提供商 >> China Unicom

选择您的资费方案 >> 没有列出我的资费方案

APN >> `bjlenovo12.njm2apn`

保存即可激活

**提供商和 APN 可以在 Windows 系统的“设置 >> 网络和 Internet >> 手机网络 >> 运营商设置”上查找到，在“活动网络”处能找到提供商，在“Internet APN >> 默认接入点 >> 视图”中可以找到 APN 地址**

#### **修改 hosts 文件访问 GitHub**

修改 hosts 文件可以有效访问 GitHub，需要修改的文件是 `/etc/hosts`，Windows 下对应的文件位置为： `C:\Windows\System32\drivers\etc\hosts` （注意这里是反斜杠），修改内容参考以下网址：

[HelloGitHub -- hosts](https://raw.hellogithub.com/hosts)

可以用下面命令修改：

```bash
sudo sh -c 'sed -i "/# GitHub520 Host Start/Q" /etc/hosts && curl https://raw.hellogithub.com/hosts >> /etc/hosts'
```

#### **不显示回环连接**

如果在 Plasma 系统托盘的网络设置中发现一个名为 `lo` 的连接，这是系统的回环连接

不显示回环连接可以编辑 `/etc/NetworkManager/NetworkManager.conf`，添加如下内容：

```text
[keyfile]
unmanaged-devices=interface-name:lo
```

之后重启网络服务：

```bash
sudo systemctl restart NetworkManager
```

### **Vim 配置**

Vim 的配置文件主要有 `/usr/share/vim/vimfiles/archlinux.vim`，`/etc/vimrc` 和 `/home/(user_name)/.vimrc`，建议直接修改 `/etc/vimrc`，这样不会覆盖 `/usr/share/vim/vimfiles/archlinux.vim` 上定义的默认配置（语法高亮等）

Vim 的配置可以参考以下网址：

[Options -- Vim Documentation](http://vimdoc.sourceforge.net/htmldoc/options.html)

应用 `Ctrl+C`、`Ctrl+V`、`Ctrl+A`、`Ctrl+Z` 等快捷键，需要在 `/etc/vimrc` 中写入：

```text
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

在 `~/.bashrc` 中添加：

```text
export LC_ALL=en_US.UTF-8
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

**注意 Microsoft Office 不支持嵌入 OTF 字体，只能嵌入 TTF 字体**

#### **安装中文字体**

推荐安装[思源黑体](https://github.com/adobe-fonts/source-han-sans)、[思源宋体](https://github.com/adobe-fonts/source-han-serif)

命令行安装：

```bash
sudo pacman -S adobe-source-han-sans-cn-fonts adobe-source-han-serif-cn-fonts
```

并创建字体设置文件：

```bash
sudo vim /etc/fonts/conf.d/64-language-selector-prefer.conf
```

加入以下内容：

```xml
<?xml version="1.0"?>
<!DOCTYPE fontconfig SYSTEM "fonts.dtd">
<fontconfig>
    <alias>
        <family>sans-serif</family>
        <prefer>
            <family>Source Han Sans CN</family>
        </prefer>
    </alias>
    <alias>
        <family>serif</family>
        <prefer>
            <family>Source Han Serif CN</family>
        </prefer>
    </alias>
    <alias>
        <family>monospace</family>
        <prefer>
            <family>Source Han Sans CN</family>
        </prefer>
    </alias>
</fontconfig>
```

保存退出，重启电脑即可

### **安装中文输入法**

#### **安装 Fcitx5 输入法**

推荐使用 Fcitx5:

```bash
sudo pacman -S fcitx5-im fcitx5-chinese-addons
```

编辑 `/etc/environment` 并添加以下几行：

```text
GTK_IM_MODULE=fcitx
QT_IM_MODULE=fcitx
XMODIFIERS=@im=fcitx
```

然后重新登录，此时输入法会自动启动，默认的切换键是 `Ctrl+Space`

**安装输入法之后需要重启电脑才能生效，如果无法启动输入法，在“系统设置 >> 输入法 >> 添加输入法”中手动添加“拼音”**

#### **配置与词库**

Fcitx5 的配置在：

系统设置 >> 输入法

注意有“全局选项”、“附加组件”、“拼音”三个配置区域

可以添加词库：（部分包需要使用 AUR 源）

```bash
paru -S fcitx5-pinyin-zhwiki fcitx5-pinyin-custom-pinyin-dictionary fcitx5-pinyin-moegirl fcitx5-pinyin-sougou
```

虚拟键盘的配置在：

系统设置 >> 键盘 >> 虚拟键盘 >> 选择 Fcitx5

#### **其它版本**

Fcitx5 对应的 git 版本为：（需要使用 AUR 源）

```bash
paru -S fcitx5-git fcitx5-chinese-addons-git fcitx5-gtk-git fcitx5-qt5-git fcitx5-configtool-git
```

一个稳定的替代版本是 Fcitx 4：

```bash
paru -S fcitx-im fcitx-configtool fcitx-cloudpinyin
```

可以配合 googlepinyin 或 sunpinyin 使用，即执行：

```bash
paru -S fcitx-googlepinyin
```

或者：

```bash
sudo pacman -S fcitx-sunpinyin
```

也可以用 `sudo pacman -S sunpinyin` 安装 Sunpinyin

### **安装 Firefox 的中文语言包**

Firefox 浏览器的中文语言包可以在官方仓库中下载：

```bash
sudo pacman -S firefox-i18n-zh-cn
```

### **关闭启动和关机时的系统信息**

修改 `/etc/grub.d/10_linux`，删除 `message="$(gettext_printf "Loading Linux %s ..." ${version})"` 和 `message="$(gettext_printf "Loading initial ramdisk ...")"` 两行

然后执行：

```bash
sudo grub-mkconfig -o /boot/grub/grub.cfg
```

### **在登录时自动解锁 KWallet**

在登录时自动解锁 KWallet 需要安装 `kwallet-pam` 包来提供对 [PAM](https://wiki.archlinux.org/title/PAM) 的兼容模块：

```bash
sudo pacman -S kwallet-pam
```

自动解锁的条件：

- KWallet 必须使用 blowfish 加密方式
- 所选择的 KWallet 密码必须与当前用户的密码相同
- 要自动解锁的密码库必须要命名为默认的 kdewallet，任何其他名字的密码库都不会自动解锁

### **Git 配置**

配置用户名、邮箱：

```bash
git config --global user.name (user_name)
git config --global user.email (user_email)
```

Git 使用教程参考以下网址：

[Git Documentation](https://git-scm.com/docs)

#### **NTFS 磁盘无法挂载**

一般来讲是该磁盘未正确卸载（如热插拔）、Windows 开启了快速启动，或者进行了优化磁盘等操作导致的，此时 NTFS 分区会被标记为 `dirty`

可以尝试强制挂载，需要加上 `force` 选项，如：

```bash
sudo mount -t ntfs3 -o force /dev/(partition_name) /run/media/(user_name)/(partition_name)
```

临时解决这个问题需要下载 AUR 软件包 `ntfsprogs-ntfs3` 以执行硬盘 NTFS 分区修复：

```bash
paru -S ntfsprogs-ntfs3
sudo ntfsfix -d /dev/(partition_name)
```

再重新挂载即可：

```bash
sudo mount -t ntfs3 /dev/(partition_name) /run/media/(user_name)/(partition_name)
```

根本的解决方案是在 Windows 中使用 `chkdsk` 修复，注意这里要使用盘符，以 `E:` 盘为例：

```powershell
chkdsk /F E:
```

### **系统分区改变导致时进入 GRUB Rescue 模式**

此时会在开机时显示如下内容而无法进入选择系统的界面：

```text
error: no such partition.
Entering rescue mode...
grub rescue>
```

此时执行 `ls`，显示如下：

```text
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

```bash
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

- 使用命令 `scan on` 去搜索发现所有可配对的设备，找到要配对的设备的 MAC 地址 `(MAC_address)`，一般是 `XX:XX:XX:XX:XX:XX` 的形式
- 使用命令 `pair (MAC_address)` 配对设备，可能需要输入 PIN 密码
- 使用命令 `trust (MAC_address)` 将设备添加到信任列表
- 使用命令 `connect (MAC_address)` 建立连接
- 使用命令 `exit` 退出

#### **SONY WH-1000XM3 耳机的蓝牙连接**

长按耳机电源键约 7 秒即可进入配对模式，可以在蓝牙中配对

#### **Logitech 多设备鼠标的蓝牙连接**

同一台电脑的 Windows 系统和 Linux 系统在鼠标上会被识别为两个设备

如果 Windows 系统被识别为设备 1，需要多设备切换的按钮（一般是一个在滚轮后或鼠标底部的圆形按钮）切换至设备 2

长按圆形按钮直到灯 2 快速闪烁进入配对模式，可以在蓝牙中配对

如果 Logitech 鼠标配对后屏幕光标无法移动，一般可以直接删除设备重新配对，如果仍然失败则按照“命令行连接蓝牙”一节操作

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

### **解决 Gwenview 无法打开大型图片的问题**

在应用程序启动器中找到 Gwenview，右键点击，选择“编辑应用程序”

找到“应用程序”，编辑环境变量，加入 `QT_IMAGEIO_MAXALLOC=(size)`

默认值是 256，无法打开大型图片时要将其改成更大的值，如 65536

### **切换图形化界面和命令行界面**

登录时默认进入的是图形化界面，有时候开机后黑屏是图形化界面显示不出来所致，此时可以按快捷键 `Ctrl+Alt+Fn+(F2~F6)` 进入 `tty2 ~ tty6` 的任何一个命令行 TTY 界面

注意此时需要手动输入用户名和密码

在命令行界面解决问题后，按快捷键 `Ctrl+Alt+Fn+F1` 可以转换回 TTY1 图形化界面

### **切换软件包仓库**

参考以下网址：

[Official repositories -- ArchWiki](https://wiki.archlinux.org/title/Official_repositories)

#### **启用 multilib 仓库**

multilib 包含着32位的软件和链接库，可以用于在64位系统上运行和构建32位软件，例如 `wine` 软件包等

如果想启用 multilib 仓库，请在 `/etc/pacman.conf` 文件中取消 `[multilib]` 段落的注释：

```text
[multilib]
Include = /etc/pacman.d/mirrorlist
```

然后更新系统：

```bash
sudo pacman -Syu
```

#### **启用测试仓库（可选）**

测试仓库并不是“最新”软件包的仓库。测试仓库的目的是提供一个即将被放入主软件仓库的软件包的集散地。软件包维护者（和普通用户）可以访问并测试这些软件包以确保软件包没有问题。当位于测试仓库的软件包被测试无问题后，即可被移入主仓库。

请同时启用 core-testing 和 extra-testing 仓库，即在 `/etc/pacman.conf` 文件中取消 `[core-testing]` 和 `[extra-testing]` 段落的注释：

```text
[core-testing]
Include = /etc/pacman.d/mirrorlist

[extra-testing]
Include = /etc/pacman.d/mirrorlist
```

由于并不是所有的主仓库软件包都在测试仓库中有相应的版本，core 和 extra 主仓库应该保留，并保证相应的测试仓库在主仓库的前面，即：

```text
[core-testing]
Include = /etc/pacman.d/mirrorlist

[core]
Include = /etc/pacman.d/mirrorlist

[extra-testing]
Include = /etc/pacman.d/mirrorlist

[extra]
Include = /etc/pacman.d/mirrorlist
```

#### **启用 kde-unstable 仓库（可选）**

kde-unstable 仓库包含包含 KDE Plasma 和应用程序的测试版本

如果想启用 kde-unstable 仓库，请在 `/etc/pacman.conf` 文件中添加：

```text
[kde-unstable]
Include = /etc/pacman.d/mirrorlist
```

此时应该启用 core-testing 和 extra-testing 仓库，并保证 `[kde-unstable]` 在其它所有仓库的前面，即：

```text
[kde-unstable]
Include = /etc/pacman.d/mirrorlist

[core-testing]
Include = /etc/pacman.d/mirrorlist

[core]
Include = /etc/pacman.d/mirrorlist

[extra-testing]
Include = /etc/pacman.d/mirrorlist

[extra]
Include = /etc/pacman.d/mirrorlist
```

然后更新系统：

```bash
sudo pacman -Syu
```

### **切换到其它内核（可选）**

Arch Linux 和 AUR 上可选的内核可以参考以下网址：

[Kernel -- ArchWiki](https://wiki.archlinux.org/title/Kernel)

以 `linux-lts` 为例，首先下载 `linux-lts` 内核：

```bash
sudo pacman -S linux-lts
```

可以选择保留或删除原有内核，若保留内核，重启后可以选择从任何一个内核启动

之后重新生成 GRUB 文件：

```bash
sudo grub-mkconfig -o /boot/grub/grub.cfg
```

**如果不重新生成 GRUB 文件会因为找不到内核而无法启动**

### **应用程序的快捷键配置（可选）**

应用程序的快捷键配置在：

系统设置 >> 键盘 >> 快捷键

若没有想要的应用程序，可以点击“新增”

### **调整 CPU 频率（可选）**

这需要 `tlp` 软件包：

```bash
sudo pacman -S tlp
sudo systemctl enable tlp
```

tlp 的设置文件在 `/etc/tlp.conf`

若需要更改 CPU 性能设置，修改以下位置：

```text
CPU_MIN_PERF_ON_AC=0
CPU_MAX_PERF_ON_AC=100
CPU_MIN_PERF_ON_BAT=0
CPU_MAX_PERF_ON_BAT=30
```

若需要更改 CPU 睿频设置，修改以下位置：

```text
CPU_BOOST_ON_AC=1
CPU_BOOST_ON_BAT=0
```

保存、关闭，在终端中输入：

```bash
sudo tlp start
```

**不需要高性能的时候可以关闭睿频，这样可以大幅增加续航、减少发热**

### **显示 Intel CPU 频率（可选）**

安装 KDE 小部件：[Intel P-state and CPU-Freq Manager](https://github.com/frankenfruity/plasma-pstate)

右键点击顶栏，选择“添加部件”，找到 Intel P-state and CPU-Freq Manager 并添加在顶栏即可

### **硬件视频加速（可选）**

如果想要获得硬件视频加速，可以下载 `intel-media-driver`

```bash
sudo pacman -S intel-media-driver
```

具体教程参考以下网址：

[Hardware video acceleration -- ArchWiki](https://wiki.archlinux.org/title/Hardware_video_acceleration)

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

### **重新开启 Secure Boot（未测试）**

如果想在开启 Secure Boot 的情况下登录进 Arch Linux，可以使用经过微软签名的 PreLoader 或者 shim，然后在 UEFI 设置中将 Secure Boot 级别设置为 Microsoft & 3rd Party CA

具体教程参考以下网址：

[Secure Boot -- ArchWiki](https://wiki.archlinux.org/title/Unified_Extensible_Firmware_Interface/Secure_Boot#Microsoft_Windows)