# **在 ThinkPad X13 2021 Intel 上安装 Arch Linux KDE Plasma + Windows 11 双系统的指南**

```text
Operating System: Arch Linux
KDE Plasma Version: 6.3.4
KDE Frameworks Version: 6.13.0
Qt Version: 6.9.0
Kernel Version: 6.14.4-arch1-1 (64-bit)
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

右键点击开始菜单，选择“磁盘管理”，分出一块空分区，建议不小于 64GiB

**Windows 安装程序会创建一个 100MiB 的 EFI 系统分区，一般并不足以放下双系统所需要的所有文件（即 Linux 的 GRUB 文件），可以在将 Windows 安装到盘上之前就用 Arch 安装媒体创建一个较大的 EFI 系统分区（建议多于 512MiB），之后 Windows 安装程序将会使用你自己创建的 EFI 分区，而不是再创建一个**

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

也可以输入 `iwctl` 进入交互模式，此时命令前面会显示 `[iwd]#` 标志

上面的命令不加 `iwctl` 输入，最后用 `exit` 推出

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

**对 Linux 分区建议使用 EXT4/XFS/BTRFS 文件系统**

可以使用 `lsblk -f` 或 `fdisk -l` 查看硬盘 `/dev/(disk_name)`，如 `/dev/sda`、`/dev/nvme0n1` 等，前者多用于 HDD，后者多用于 SSD

修改分区可以用 `parted /dev/(disk_name)`、`cfdisk /dev/(disk_name)`、`fdisk /dev/(disk_name)` 等，下面以 `parted` 为例：

运行：

```bash
parted /dev/(disk_name)
```

此时进入交互模式，命令行前面会显示 `(parted)`

如果一个硬盘没有做过分区，或者是需要修改分区表的类型，则要为对应的设备创建/重建分区表，使用以下命令创建 GUID 分区表（GPT）：

```bash
(parted) mklabel gpt
```

对于 UEFI/GPT 分区方案，需要创建新的 EFI 系统分区（建议从 1MiB 开始对齐）：

```bash
(parted) mkpart "EFI system partition" fat32 1MiB 256MiB
(parted) set 1 esp on
```

再创建一个 Linux 根分区：

```bash
(parted) mkpart "Arch Linux" ext4 256MiB 100%
(parted) type 2 4F68BCE3-E8CD-4DB1-96E7-FBCAF984B709
```

`parted` 常用命令：

- `help`：帮助
- `print`：显示分区状态
- `unit`：更改单位，推荐使用 `s`（扇区）
- `set`：设置 `flag`，例如在分区 1 上创建 EFI 分区需要设置 `flag` 为 `esp`：`set 1 esp on`
- `mkpart`：创建分区，分区标签可以自定义，文件系统类型选择 `fat32`（对 EFI 分区），`ext4/xfs/btrfs`（对 Linux 分区），`ntfs`（对 Windows 分区）
- `resizepart`：改变分区大小
- `rm`：删除分区
- `name`：更改分区名字，比如将分区 2 改名为 `Arch`，需要设置：`name 2 'Arch'`
- `quit`：退出

更多操作参考以下网址：

[GNU Parted User Manual](https://www.gnu.org/software/parted/manual/parted.html)

### **创建文件系统**

**只有在分区步骤中创建 EFI 系统分区时才需要格式化，如果这个磁盘上已经存在一个 EFI 系统分区，将它重新格式化会破坏其他已安装操作系统的引导加载程序**

如果新创建了 EFI 系统分区 `/dev/(EFI_system_partition)` ，需要使用 `mkfs.fat` 将其格式化为 FAT32：

```bash
mkfs.fat -F 32 /dev/(EFI_system_partition)
```

例如要在根分区 `/dev/(root_partition)` 上创建一个 EXT4 文件系统，请运行：

```bash
mkfs.ext4 /dev/(root_partition)
```

XFS 和 BTRFS 对应的命令就是 `mkfs.xfs` 和 `mkfs.btrfs`

如果需要覆盖原有分区，加入 `-f` 参数强制执行即可

### **挂载分区**

首先将根磁盘卷挂载到 `/mnt`

```bash
mount /dev/(root_partition) /mnt
```

对于 UEFI 系统，挂载 EFI 系统分区（一般是 `lsblk` 输出的第一个分区，文件系统一般是 FAT32）：

```bash
mount --mkdir /dev/(EFI_system_partition) /mnt/boot
```

**挂载 EFI 系统分区一定要加 `--mkdir` 参数，并在挂载根磁盘卷后再挂载**

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
pacstrap /mnt base linux linux-firmware vim
```

对于本电脑，还需要安装 `sof-firmware` 声卡驱动

如果选择根分区文件系统为 XFS，需要下载 `xfsprogs`

如果选择根分区文件系统为 BTRFS，需要下载 `btrfs-progs`

### **生成 fstab 文件**

用以下命令生成 fstab 文件（用 `-U` 或 `-L` 选项设置 UUID 或卷标，）：

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

接着生成 locale 信息，运行：

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

编辑本地主机名解析 `/etc/hosts`，写入：（编辑 `/etc/hosts` 时空白建议用 `Tab` 键）

```text
127.0.0.1        localhost
::1              localhost
127.0.1.1        (my_hostname)
```

安装网络管理软件 `NetworkManager`：

```bash
pacman -S networkmanager
```

启用 `NetworkManager`（`systemctl` 命令对大小写敏感，下同）：

```bash
systemctl enable NetworkManager
```

**一定要安装网络管理软件，否则重启后将无法联网**

### **创建 initramfs**

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

接着执行以下命令：（`--bootloader-id` 可以自定义）

```bash
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=Archlinux
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
pacman -S bluez
systemctl enable bluetooth
```

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

`qt6-multimedia-backend` 选择 `qt6-multimedia-ffmpeg`

`jack` 选择 `pipewire-jack`

`emoji-font` 选择 `noto-fonts-emoji`

这一步默认下载的是 Pipewire 多媒体框架，以替代原有的 PulseAudio

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

`pacman` 使用 `-Q` 参数查询本地软件包数据库，`-S` 查询远程数据库（包含全部软件包），以及 `-F` 查询文件数据库

要了解每个参数的子选项，分别参见 `pacman -Q --help`，`pacman -S --help` 和 `pacman -F --help`

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

之后下载支持 AUR 的软件包管理器，例如 paru、yay 等 CLI 包管理器，或 octopi、pamac 等 GUI 包管理器

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

octopi 是一个使用图形界面的软件包管理器，执行以下命令安装 `octopi`：

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
UUID=(UUID_C)                     /home/(user_name)/C    ntfs3 defaults,uid=1000,gid=1000,nohidden,windows_names,discard 0 0
UUID=(UUID_D)                     /home/(user_name)/D    ntfs3 defaults,uid=1000,gid=1000,nohidden,windows_names,discard 0 0
```

此处的挂载选项可以在此基础上自行选择增减，参见：

[NTFS3 — The Linux Kernel documentation](https://docs.kernel.org/filesystems/ntfs3.html)

重启电脑后，即可自动挂载

**如果需要格式化 C 盘或 D 盘，先从 `/etc/fstab` 中删去对应的行，再操作，之后磁盘的 `UUID` 会被更改，再编辑 `/etc/fstab` ，重启挂载即可**

如果安装生成 fstab 文件时使用 `-L` 选项，即 `genfstab -L /mnt >> /mnt/etc/fstab`，则 `/etc/fstab` 中应加入：

```text
/dev/(name_C)                     /home/(user_name)/C    ntfs3 defaults,uid=1000,gid=1000,nohidden,windows_names,discard 0 0
/dev/(name_D)                     /home/(user_name)/D    ntfs3 defaults,uid=1000,gid=1000,nohidden,windows_names,discard 0 0
```

参考以下网址：

[fstab -- Archwiki](https://wiki.archlinux.org/title/fstab)

[mount(8) -- Arch manual pages](https://man.archlinux.org/man/mount.8)

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

推荐使用 Fcitx5 输入法：

```bash
sudo pacman -S fcitx5-im fcitx5-chinese-addons
```

编辑 `/etc/environment` 并添加：

```text
XMODIFIERS=@im=fcitx
```

在“系统设置 >> 键盘 >> 虚拟键盘”中选择“Fcitx”

在“系统设置 >> 输入法 >> 添加输入法”中添加“拼音”，默认的切换键是 `Ctrl+Space`

#### **配置与词库**

Fcitx5 的配置在：

系统设置 >> 输入法

注意有“全局选项”、“附加组件”、“拼音”三个配置区域

可以添加词库：（部分包需要使用 AUR 源）

```bash
paru -S fcitx5-pinyin-zhwiki fcitx5-pinyin-custom-pinyin-dictionary fcitx5-pinyin-moegirl
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

### **NTFS 磁盘无法挂载**

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

### **从 USB 启动盘启动**

如果计算机无法启动，可以尝试从 USB 启动盘启动以修复电脑

首先根据“刻录 USB 启动盘”一节中的内容创建一个 USB 启动盘

之后在 UEFI 中设置从 USB 启动

启动后需要挂载电脑上 Arch Linux 的分区：

```bash
mount /dev/(root_partition) /mnt
mount --mkdir /dev/(efi_system_partition) /mnt/boot
```

更改根目录到已安装的系统：

```bash
arch-chroot /mnt
```

这样就可以在已安装的系统中更改文件设置等以正常启动

退出时，输入 `exit` 退出 `chroot` 环境，输入 `umount -R /mnt` 手动卸载被挂载的分区，最后执行 `reboot` 重启系统

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

### **电源管理方案**

#### **使用图形界面**

这需要使用 `powerdevil` 软件包：

```bash
sudo pacman -S powerdevil
```

之后即可在“系统设置 >> 系统 >> 电源管理”中设置电源方案

#### **使用命令行工具**

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

### **NVIDIA 显卡**

如果电脑使用了 NVIDIA 独立显卡，需要根据显卡型号下载对应的驱动程序，参考以下网址：

[NVIDIA -- ArchWiki](https://wiki.archlinux.org/title/NVIDIA)

对于较新的 RTX 系列显卡，推荐使用 `nvidia-open` 软件包：

```bash
sudo pacman -S nvidia-open nvidia-utils
```

为了避免更新 NVIDIA 驱动之后忘了更新 initramfs，在 `/etc/pacman.d/` 中建立 `hooks` 文件夹：

```bash
sudo mkdir -p /etc/pacman.d/hooks/
```

之后在此创建一个 `nvidia.hook` 文件，写入：

```text
[Trigger]
Operation=Install
Operation=Upgrade
Operation=Remove
Type=Package
# Uncomment the installed NVIDIA package
Target=nvidia-open
#Target=nvidia
#Target=nvidia-lts
# If running a different kernel, modify below to match
Target=linux

[Action]
Description=Updating NVIDIA module in initcpio
Depends=mkinitcpio
When=PostTransaction
NeedsTargets
Exec=/bin/sh -c 'while read -r trg; do case $trg in linux*) exit 0; esac; done; /usr/bin/mkinitcpio -P'
```

即可重启电脑

### **切换软件包仓库**

参考以下网址：

[Official repositories -- ArchWiki](https://wiki.archlinux.org/title/Official_repositories)

#### **启用 multilib 仓库（可选）**

multilib 包含着 32 位的软件和链接库，可以用于在 64 位系统上运行和构建 32 位软件，例如 `wine` 软件包等

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

**测试仓库并不是“最新”软件包的仓库，测试仓库的目的是提供一个即将被放入主软件仓库的软件包的集散地**

若要启用测试仓库，请同时启用 core-testing 和 extra-testing 仓库，即在 `/etc/pacman.conf` 文件中取消 `[core-testing]` 和 `[extra-testing]` 段落的注释：

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

### **添加打印机（可选）**

需要下载 `system-config-printer` 和 `cups`：

```bash
sudo pacman -S system-config-printer cups
```

并启用 `cups` 服务：

```bash
sudo systemctl enable --now cups
```

此时在“系统设置 >> 已连接的设备 >> 打印机”中添加打印机

如果无法自动发现，需要选择“手动配置”，输入打印机的 IPP 地址如：（注意不要遗漏中间的 `://`）

```text
ipp://xxx.xxx.xxx.xxx
```

再选择打印机的制造商和型号，即可添加打印机，添加后可以打印测试页或自检页确认是否添加成功

### **Intel 硬件视频加速（可选）**

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

编辑 `/etc/pacman.conf` 文件，取消注释 `XferCommand` 一行，并改为：（这里的 16 可以换成其它数字）

```bash
XferCommand = /usr/bin/axel -n 16 -o %o %u
```

编辑 `/etc/makepkg.conf` 文件，修改 `DLAGENTS` 一段为：

```bash
DLAGENTS=('file::/usr/bin/axel -n 16 -o %o %u'
'ftp::/usr/bin/axel -n 16 -o %o %u'
'http::/usr/bin/axel -n 16 -o %o %u'
'https::/usr/bin/axel -n 16 -o %o %u'
'rsync::/usr/bin/rsync --no-motd -z %u %o'
'scp::/usr/bin/scp -C %u %o')
```

**注意某些软件包如 `rider` 和 `qqmusic-bin` 等下载源不支持 axel，启用多线程下载后可能会导致构建失败**

### **建立交换文件（可选）**

相比于使用一个磁盘分区作为交换空间，使用交换文件可以更方便地随时调整大小或者移除，当磁盘空间有限时，使用交换文件更加理想

可以使用 `mkswap` 命令建立交换文件，交换文件的大小推荐为与内存大小相等，此处以 16GiB 为例：

```bash
sudo mkswap -U clear -s 16G -F /swapfile
```
激活交换文件：

```bash
sudo swapon /swapfile
```

最后在 `/etc/fstab` 中加入交换文件的条目：

```text
/swapfile none swap defaults 0 0
```

现在输入 `free -h` 即可在 `Swap` 一行查看交换文件的使用情况

如果要删除交换文件，必须先关闭交换文件的使用：

```bash
sudo swapoff /swapfile
```

再删除文件：

```bash
sudo rm -f /swapfile
```

**对于 BTRFS 文件系统，建立交换文件的命令有一些不同，参见 [BTRFS Swap File -- ArchWiki](https://wiki.archlinux.org/title/Btrfs#Swap_file)**

## **一些有用的命令总结**

### **获取设备信息**

#### **简要信息**

可以使用能显示系统图标的 `fastfetch`，在终端中输入：（需要下载 `fastfetch` 软件包）

```bash
fastfetch
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

#### **内核版本**

在终端中输入：

```bash
uname -a
```

#### **操作系统版本**

在终端中输入：（需要 `lsb-release` 软件包）

```bash
lsb_release -a
```

### **当前目录**

在终端中输入：

```bash
pwd
```

可以获得当前目录的绝对路径

### **命令的说明文档**

在终端中输入：（需要 `man-db` 软件包）

```bash
man (command)
```

### **设置命令别名**

在 `~/.bashrc` 中添加一句 `alias (new_command)=(old-command)`，这样直接输入 `new_command` 即等效于输入 `old_command`

### **文件权限与属性**

#### **查看文件权限与属性**

查看当前目录下所有文件（包括目录文件，即文件夹）的权限与属性：

```bash
ls -l
```

输出部分开头由 10 位字母或 `-` 符号组成，如 `drwxr-xr-x`

第一个字母代表文件类型，`d` 表示目录文件，`-` 表示普通文件

后面 9 个字母代表文件的权限：第 1-3 个字母代表所有者对文件的权限，第 4-6 个字母代表用户组对该文件的权限，第 7-9 个字母代表所有其他用户对该文件的权限

其中 `r` 代表读取权限，`w` 代表修改权限，`x` 代表执行权限（非可执行文件，如文本文件，本身就没有执行权限），`-` 代表没有该类型的权限

#### **修改文件权限**

在终端里使用 `chmod` 命令可以修改文件（包括目录文件，即文件夹）权限：

```bash
chmod (who)=(permissions) (file_name)
```

其中的 `(who)` 是一个或者多个字母，可以是 `u`（所有者）、`g`（用户组）、`o`（所有其他用户）、`a`（以上所有，等价于 `ugo`）

权限 `(permissions)` 用 `r`、`w`、`x` 表示

中间的 `=` 符号是覆盖性的，`chmod` 命令允许使用 `+` 或 `-` 从现有集合中添加和减去权限，例如：

```bash
chmod u+x (file_name)
```

可以给文件添加所有者的可执行权限

`chmod` 也可以用数字来设置权限，此时 `r=4`、`w=2`、`x=1`，如 `rwxr-xr-x` 等于 `755`，这样可以同时编辑所有者、用户组和其他用户的权限：

```bash
chmod 755 (file_name)
```

大多数目录被设置为 `755`，以允许所有者读取、写入和执行，但拒绝被其他所有人写入

非可执行的文件通常是 `644`，以允许所有者读取和写入，但允许其他所有人读取，可执行文件则为 `744`

如果要递归修改，可以加入 `-R` 参数

更多设置和用法参考以下网址：

[File permissions and attributes -- ArchWiki](https://wiki.archlinux.org/title/File_permissions_and_attributes)

#### **修改文件用户组**

在终端里使用 `chgrp` 命令可以修改文件所属的用户组：

```bash
chgrp (group_name) (file_name)
```

如果要递归修改，可以加入 `-R` 参数

#### **修改文件所有者**

在终端里使用 `chown` 命令可以修改文件所有者：

```bash
chown (user_name) (file_name)
```

如果要递归修改，可以加入 `-R` 参数

也可以同时修改所有者和用户组：

```bash
chown (user_name):(group_name) (file_name)
```

### **命令行进程查看器**

在终端中输入：

```bash
top
```

或者使用功能更强大，有颜色高亮的 `htop`：

```bash
htop
```

### **内存使用情况**

`free` 显示系统中已用和未用的物理内存和交换内存、共享内存和内核使用的缓冲区的总和

在终端中输入：（默认单位是 KiB，即 1024 字节）

```bash
free
```

**Linux 的内存策略和使用指南可以参考这个网站：[Linux ate my RAM](https://www.linuxatemyram.com/)**

### **上一次关机的系统日志**

```bash
journalctl -rb -1
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

### **获取命令执行的时间**

使用 `time` 命令在任何命令前面可以获取命令执行的时间：

```bash
time (command)
```

输出有三行：`real` 一行是命令执行的总时间，`user` 一行是指令执行时在用户态（user mode）所花费的时间，`sys` 一行是指令执行时在内核态（kernel mode）所花费的时间

### **命令行比较两个文件**

可以用 Linux 自带的 `diff` 命令，它可以逐行比较两个文件（如果是二进制文件则直接输出是否存在差异）：

```bash
diff (file_name_1) (file_name_2)
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

### **将 Tab 替换为空格**

推荐使用 `expand` 命令，它可以自动将不同长度的 Tab 替换成对应数量的空格，保证最终文字依然是对齐的

```bash
expand -t 4 (file_name)
```

这样可以将文件中所有的 Tab 替换为 4 个空格（这里的 4 也可以改为其它数字），此时会把替换后的文件内容输出到命令行终端，需要复制到源文件内容中

替换 Tab 也可以使用 Vim 中的 `retab` 功能，用 Vim 打开文件后默认进入命令模式，输入：

```text
:set tabstop=4
:set expandtab
:%retab!
```

第一步设定一个 Tab 的长度等于 4 个空格，第二步设定从 Tab 替换为空格（反之则为 `:set noexpandtab`），第三步将文件中所有的 Tab 替换为对应数量的空格

### **归档、压缩与解压缩**

参考以下网址：

[Archiving and compression -- ArchWiki](https://wiki.archlinux.org/title/Archiving_and_compression)

#### **zip 格式**

压缩需要用 `zip` 命令（需要单独安装 `zip` 软件包）：

```bash
zip (archive_name).zip (file_name)
```

这里的 `(file_name)` 可以是单个或多个文件，下同

解压默认使用 `unzip` 命令（需要单独安装 `unzip` 软件包）：

```bash
unzip (archive_name).zip
```

如果压缩文件编码不是 UTF-8，可能会导致文件名乱码，此时可以指定为其它编码例如 GBK 编码：

```bash
unzip -O gbk (archive_name).zip
```

这里建议使用 `unar`（由 `unarchiver` 软件包提供）解压，因为它可以自动检测文件编码：

```bash
unar (archive_name).zip
```

#### **rar 格式**

压缩需要用 `rar` 命令（需要从 AUR 安装 `rar` 软件包）：

```bash
rar a (archive_name).rar (file_name)
```

解压时则将参数 `a` 换成 `x`：

```bash
rar x (archive_name).rar
```

也可以用 `unarchiver` 软件包提供的 `unar` 命令解压：

```bash
unar (archive_name).rar
```

#### **tar 格式**

归档文件（不压缩）时使用 `tar` 命令：

```bash
tar -cvf (archive_name).tar (file_name)
```

解开归档文件时使用：

```bash
tar -xvf (archive_name).tar
```

此处的 `-c` 参数表示创建归档文件（create）；`-v` 参数表示显示详细信息（verbose），即被归档或解压的每一个文件的名字；`-f` 参数表示归档文件的文件名（不是被归档文件的文件名），解开时则为压缩包的文件名；`-x` 参数表示解开归档文件（extract）

#### **tar.gz 格式**

压缩命令：（其中 `-z` 表示通过 gzip 压缩或解压）

```bash
tar -czvf (archive_name).tar.gz (file_name)
```

解压命令：

```bash
tar -xzvf (archive_name).tar.gz
```

实际上 `tar` 可以自动识别压缩格式，所以可以使用如下命令（下同）：

```bash
tar -xvf (archive_name).tar.gz
```

#### **tar.xz 格式**

压缩命令：（其中 `-J` 表示通过 xz 压缩或解压）

```bash
tar -cJvf (archive_name).tar.xz (file_name)
```

解压命令：

```bash
tar -xJvf (archive_name).tar.xz
```

#### **tar.bz2 格式**

压缩命令：（其中 `-j` 表示通过 bzip2 压缩或解压）

```bash
tar -cjvf (archive_name).tar.bz2 (file_name)
```

解压命令：

```bash
tar -xjvf (archive_name).tar.bz2
```

#### **gz 格式**

压缩命令：

```bash
gzip (file_name)
```

解压命令：（`gzip -d` 也可以替换为 `gunzip`）

```bash
gzip -d (file_name).gz
```

例如 gzip 压缩的 FITS 文件，其后缀是 `.fits.gz`，此时可以用 `gzip -d` 解压，得到 `.fits` 格式的文件

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

这需要 `imagemagick` 软件包，它提供了 `magick` 命令

例如批量将图片从 PNG 格式转换为 JPG 格式：

```bash
ls -1 *.png | xargs -n 1 bash -c 'magick "$0" "${0%.png}.jpg"'
```

### **批量裁剪图片**

同样需要使用 `imagemagick` 软件包，以下命令将原始图片裁剪为宽度为 W 像素、长度为 L 像素的图片：

```bash
magick mogrify -crop Wxl+20+20 (image_name)
```

### **PDF 与图片之间的转换**

#### **将 PDF 转换为多个图片**

第一种方法是用 `poppler` 软件包提供的 `pdftoppm` 命令：（推荐）

```bash
pdftoppm -png -r (resolution) (pdf_name) (image_name)
```

分辨率 `(resolution)` 默认为 150 DPI，可以调整为更高的 300、600 等

转化为 JPG 图片的命令为：

```bash
pdftoppm -jpeg -r (resolution) (pdf_name) (image_name)
```

第二种方法是用 `imagemagick` 软件包提供的 `magick` 命令：（图片质量不如第一种方法）

```bash
magick -density (resolution) -quality 100 (pdf_name) (image_name)
```

分辨率 `(resolution)` 至少为 300（单位为 DPI），压缩质量推荐选择 100，`(image_name)` 加入扩展名即可自动按照扩展名输出相应格式的图片

#### **将多个图片转换为 PDF**

使用 `img2pdf` 软件包提供的 `img2pdf` 命令：（强烈推荐，速度快）

```bash
img2pdf -o (pdf_name) (image_name)
```

这个命令还可以指定 PDF 页面大小：

```bash
img2pdf -o (pdf_name) --pagesize (page_size) (image_name)
```

其中 `(page_size)` 可以输入 `A4`、`B5`、`Letter` 等，也可以输入自定义的数字如 `10cmx15cm`

### **查看软件是否运行在 XWayland 下**

安装 `xorg-xlsclients`：

```bash
sudo pacman -S xorg-xlsclients
```

运行 `xlsclients`，列出当前运行中的 XWayland 软件，如：

```
Archlinux  code
```

说明 Visual Studio Code 运行在 XWayland 下

## **美化**

### **自定义壁纸**

桌面壁纸可以在 [pling.com](https://www.pling.com/) 下载

KDE Plasma 每个版本的壁纸可以在这里找到：

[Plasma Workspace Wallpapers -- KDE](https://github.com/KDE/plasma-workspace-wallpapers)

默认的壁纸保存位置为 `/usr/share/wallpapers/`

还可以使用包管理器下载壁纸

右键点击桌面得到桌面菜单，点击“配置桌面和壁纸”即可选择想要的壁纸，位置建议选择“缩放并裁剪”

### **SDDM 设置**

#### **SDDM 修改为中文**

创建一个新文件：`/etc/sddm.locale`，写入：

```text
LANG="zh_CN.UTF-8"
```

再编辑 `/lib/systemd/system/sddm.service`，在 `[Service]` 一节内加入：

```text
EnvironmentFile=-/etc/sddm.locale
```

前面的 `-` 号表示即使 `/etc/sddm.locale` 不存在，也不会报错

### **Plymouth 启动屏幕动画**

编辑 `/etc/default/grub`，找到一行：

```text
GRUB_CMDLINE_LINUX_DEFAULT
```

加入参数 `splash`

最后执行：

```bash
sudo grub-mkconfig -o /boot/grub/grub.cfg
```

再重启即可

默认的启动屏幕动画可以在“系统设置 >> 外观 >> 启动屏幕”更改

Plymouth 动画的缩放设置需要更改 `/etc/plymouth/plymouthd.conf`

在 `[Daemon]` 一节中加入一行 `DeviceScale=2`

执行 `sudo mkinitcpio -P` 再重启即可

### **主题 Mac 风格美化（可选）**

参考以下网址：

[KDE 桌面的 Mac 化](https://www.cnblogs.com/luoshuitianyi/p/10587788.html)

[KDE 桌面美化指南](https://acherstyx.github.io/2020/06/30/KDE%E6%A1%8C%E9%9D%A2%E7%BE%8E%E5%8C%96%E6%8C%87%E5%8D%97/)

其中 Plasma 主题、GTK 主题和图标主题推荐选择：

```text
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

```text
[Icon Theme]
Inherits=(cursor_theme_name)
```

默认的备选是 `Adwaita`，这可能导致光标主题的不统一，可以改为 `breeze_cursors`

### **终端字体效果配置**

打开终端 Konsole：

设置 >> 编辑当前方案 >> 外观 >> 复杂文本布局 >> 双向文字渲染

默认关闭连字，勾选“单词模式”和“ASCII 字符”（不勾选“对整个单词使用相同的属性”）可以开启连字

### **bash 配置提示符变量**

bash 的配置文件在 `~/.bashrc`，默认提示符变量 PS1 可以设置为如下内容：

```bash
PS1="[\e[0;36m\u\e[0m @ \e[0;32m\h\e[0m \W] (\e[0;35m\t\e[0m)\n\e[1;31m\$\e[0m "
```

显示了用户名、主机名、时间、是否为超级用户，并带有颜色高亮

说明文档参见以下网站：

[Controlling the Prompt -- Bash Manual](https://www.gnu.org/savannah-checkouts/gnu/bash/manual/bash.html#Controlling-the-Prompt)

更多的 PS1 内容和颜色设置可以在这个网站进行自定义：

[bashrc PS1 generator](https://bashrcgenerator.com/)

### **bash 配置 blesh**

[ble.sh](https://github.com/akinomyoga/ble.sh) 是一个使用纯 bash 编写的软件，可以提供代码高亮、自动补全等功能，可以在 AUR 中下载稳定版本：

```bash
paru -S blesh
```

或者开发者版本：

```bash
paru -S blesh-git
```

下载后，需要在 `.bashrc` 文件开头添加：

```bash
[[ $- == *i* ]] && source /usr/share/blesh/ble.sh --noattach
```

并在末尾添加：

```bash
[[ ${BLE_VERSION-} ]] && ble-attach
```

之后在用户目录 `/home/(user_name)` 下创建文件 `.blerc`，写入：

```text
bleopt canvas_winch_action=redraw-prev
bleopt exec_elapsed_enabled=1
```

更多设置和用法参考以下网址：

[ble.sh -- GitHub](https://github.com/akinomyoga/ble.sh)

### **zsh 与 Oh-My-Zsh 配置**

安装 zsh：

```bash
sudo pacman -S zsh
```

修改 Konsole 默认的 shell 需要如下设置：

Konsole >> 设置 >> 编辑当前方案 >> 常规 >> 命令 >> `usr/bin/zsh`

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

```text
ZSH_THEME="geoffgarside"
```

选择 Oh-My-Zsh 插件：

```text
plugins=(git zsh-autosuggestions zsh-syntax-highlighting)
```

更新 Oh-My-Zsh，执行：

```text
omz update
```

卸载 Oh-My-Zsh，执行：

```text
uninstall_oh_my_zsh
```

### **GRUB 美化**

#### **安装 GRUB 主题**

选择主题 grub2-themes，下载地址如下：

[grub2-themes -- GitHub](https://github.com/vinceliuice/grub2-themes)

可选的主题有：Tela/Vimix/Stylish/Slaze/Whitesur

以 Tela grub theme（2K，黑白图标）为例，解压后在文件夹内执行：

```bash
sudo ./install.sh -b -t tela -i white -s 2k
```

#### **修改启动条目**

删除多余启动条目，需要修改 `/boot/grub/grub.cfg`

删除整一段 `submenu 'Advanced options for Arch Linux'`，删除整一段 `UEFI Firmware Settings`，并将 `Windows Boot Manager (on /dev/nvme0n1p1)` 改为 `Windows`

**注意之后不要再执行 `grub-mkconfig`，否则会覆盖更改**

#### **恢复默认的 GRUB 设置**

恢复默认的 `/boot/grub/grub.cfg` 需要输入：

```bash
echo GRUB_DISABLE_OS_PROBER=false | sudo tee -a /etc/default/grub
sudo grub-mkconfig -o /boot/grub/grub.cfg
```

### **Vim 美化**

Vim 的颜色主题推荐使用 [PaperColor](https://github.com/NLKNguyen/papercolor-theme)，需要将其中的 `PaperColor.vim` 文件复制到 `/usr/share/vim/vim90/colors/`，并在 `/etc/vimrc` 中添加：

```text
colorscheme PaperColor
```

默认使用暗色主题，如果要使用亮色主题需要在 `/etc/vimrc` 中添加：

```text
set background=light
```

### **pacman 添加吃豆人彩蛋**

编辑 `/etc/pacman.conf`

```bash
sudo vim /etc/pacman.conf
```

去掉 `Color` 前面的注释，并在下一行加入：

```text
ILoveCandy
```

即可添加吃豆人彩蛋

### **配置桌面小部件（可选）**

右键点击桌面 >> 添加部件 >> 获取新部件 >> 下载新 Plasma 部件

在这里可以下载桌面小部件，并在“添加部件”处添加

### **在桌面显示 Intel CPU 频率（可选）**

安装 KDE 小部件：[Intel P-state and CPU-Freq Manager](https://github.com/frankenfruity/plasma-pstate)

右键点击顶栏，选择“添加部件”，找到 Intel P-state and CPU-Freq Manager 并添加在顶栏即可

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

### **生成 SSH 密钥**

首先安装 OpenSSH：

```bash
sudo pacman -S openssh
```

生成一个 SSH 密钥默认使用兼容性最好的 RSA 算法，现在推荐使用更安全的 ED25519 算法：

```bash
ssh-keygen -t ed25519 -C "(user_email)"
```

第一步生成私钥，会询问 `Enter file in which to save the key`，默认是 `~/.ssh/id_ed25519`，可以改为别的位置和名字，如 `(ssh_folder)/(key_name)`

第二步会提示输入安全密码，可以按 `Enter` 跳过，不影响后续操作和使用

这样创建的私钥位置为 `(ssh_folder)/(key_name)`，公钥位置为 `(ssh_folder)/(key_name).pub`

如果 SSH 密钥不在默认的 `~/.ssh`，则需要创建设置文件 `~/.ssh/config`（这个文件必须在 `~/.ssh/` 文件夹内）并写入：

```text
IdentityFile (ssh_folder)/(key_name)
```

注意如果 `(ssh_folder)` 中含有空格，需要用 `\ ` 即反斜杠进行转义

### **向 AUR 提交软件包**

#### **连接 AUR 仓库**

需要使用 SSH 连接 AUR 仓库

复制 `~/(ssh_folder)/.ssh/aur.pub` 的内容（至少包括前缀 `ssh_ed25519` 和公钥的随机字符串），粘贴到 AUR 的“My Account >> SSH 密钥”一节，输入密码以更新账号设置

在 `~/.ssh/config` 中为 AUR 指定 SSH 私钥的位置，即写入：

```text
Host aur.archlinux.org
User (user_name)
IdentityFile (ssh_folder)/(key_name)
```

#### **创建软件包仓库**

如果要创建新的软件包，通过克隆所需的 [pkgbase](https://wiki.archlinux.org/title/PKGBUILD#pkgbase) 的方式建立一个远程 AUR 仓库和本地 Git 仓库：（必须用 SSH 地址，需要登录 AUR 后才能看到）

```bash
git clone ssh://aur@aur.archlinux.org/(package_name).git
```

如果软件包还不存在，则会出现警告：

```text
warning: You appear to have cloned an empty repository.
```

这不影响后续操作

#### **提交和更新软件包**

**要上传或者更新一个软件包，至少要添加 `PKGBUILD` 和 `.SRCINFO`，以及其他所有新增的或者修改过的辅助文件（例如 `.install` 文件或补丁等本地源码文件）**

生成 `.SRCINFO` 的方法如下

```bash
makepkg --printsrcinfo > .SRCINFO
```

添加文件并提交，最后推送这些变动到 AUR 上：

```bash
git add PKGBUILD .SRCINFO
git commit -m (commit_message)
git push
```

### **Dolphin 显示文件预览图**

首先在 Dolphin 的“设置 >> 配置 Dolphin >> 界面 >> 预览图”中勾选显示预览图的项目类型

之后勾选菜单栏上的“视图 >> 显示预览图”即可显示预览图

预览 PDF 文件、RAW 文件需要下载 `kdegraphics-thumbnailers`，预览视频文件需要下载 `ffmpegthumbs`

### **Kate 语言包下载**

如果在打开 Kate 的时候出现：

```text
kf.sonnet.core: No language dictionaries for the language: "en_US"
```

下载 Kate 语言包：

```bash
sudo pacman -S aspell aspell-en
```

### **Gwenview 扩展**

下载 `qt6-imageformats` 和 `kimageformats` 软件包：

```
sudo pacman -S qt6-imageformats kimageformats
```

`qt6-imageformats` 提供了 Gwenview 对 WebP、TIFF 等图片格式的支持

`kimageformats` 提供了 Gwenview 对 EPS、PSD 等图片格式的支持，但 Gwenview 依然是以栅格化形式打开 EPS 矢量图，质量较差，建议用 Okular 查看 EPS 图片

### **运行 AppImage 文件**

AppImage 的扩展名为 `.AppImage`，可以直接双击或在终端输入文件名运行：

```bash
(file_name).AppImage
```

运行 AppImage 需要 FUSE2：

```bash
sudo pacman -S fuse2
```

并检查是否有运行权限，若没有则需要添加运行权限：

```bash
chmod u+x (file_name).AppImage
```

然后双击或在终端输入文件名运行即可

### **用 debtap 安装 DEB 包**

首先要下载并更新 [debtap](https://github.com/helixarch/debtap) 包：

```bash
paru -S debtap
sudo debtap -u
```

进入含有 `.deb` 安装包的文件夹，输入：

```bash
debtap (package_name).deb
```

系统会询问三个问题：文件名、协议、编辑文件，都可以直接按 `Enter` 跳过

此处会生成一个 `tar.zst` 包，可以用 `pacman` 安装：

```bash
sudo pacman -U (package_name).tar/zst
```

运行：

```bash
debtap -P (package_name).deb
```

会生成一个 `PKGBUILD` 文件，之后用 `makepkg -si` 也可安装

### **v2rayA 安装与配置**

v2rayA 客户端可以直接使用包管理器安装（AUR 软件库提供 `v2raya`、`v2raya-bin` 和 `v2raya-git`）：

```bash
paru -S v2raya-bin
```

默认使用核心为 v2ray，可以在官方软件源下载：

```bash
sudo pacman -S v2ray
```

启动 v2rayA 需要使用 `systemctl`：

```bash
sudo systemctl enable --now v2raya
```

之后 v2rayA 可以开机自启动

在 [http://localhost:2017/](http://localhost:2017/) 打开 v2rayA 界面，导入订阅链接或服务器链接（ID 填用户的 UUID，AlterID 填 0，Security 选择 Auto，其余选项均为默认）

右上角“设置”中，设置如下：

透明代理/系统代理 >> 启用：大陆白名单模式
透明代理/系统代理实现方式 >> tproxy
防止 DNS 污染 >> 转发 DNS 请求
特殊模式 >> 关闭

保存并应用设置

选择一个节点，点击左上角柚红色的“就绪”按钮即可启动，按钮变为蓝色的“正在运行”

选择左侧的勾选框可以测试节点的网络连接延时

此时系统测试网络连接的功能被屏蔽，可以通过在 `/etc/NetworkManager/conf.d/20-connectivity.conf` 中写入以下内容关闭此功能：

```text
[connectivity]
enabled=false
```

#### **v2rayA 更改核心**

如果需要更改为 xray 核心，可以在 AUR 下载（AUR 软件库提供 `xray`、`xray-bin`）：

```bash
paru -S xray-bin
```

创建文件夹 `/etc/systemd/system/v2raya.service.d`，并添加一个 `xray.conf` 文件：

```bash
sudo mkdir /etc/systemd/system/v2raya.service.d
cd /etc/systemd/system/v2raya.service.d
sudo vim xray.conf
```

写入如下内容：

```text
[Service]
Environment="V2RAYA_V2RAY_BIN=/usr/bin/xray"
```

再重启 v2rayA：

```bash
sudo systemctl daemon-reload && sudo systemctl restart v2raya
```

#### **v2rayA 设置任务栏图标**

任务栏图标可以在 [v2rayATray](https://github.com/YidaozhanYa/v2rayATray) 下载，即下载 [PKGBUILD](https://github.com/YidaozhanYa/v2rayATray/blob/main/PKGBUILD)，在其所在的文件夹下执行 `makepkg -si` 即可安装

v2rayATray 的命令是 `v2raya_tray`，设置它为开机自启动可以在 KDE Plasma 的“系统设置 >> 自动启动”中设置

**浏览器和 KDE Plasma 的网络连接设置都不需要更改**

### **DNS 设置**

DNS 会储存在 `/etc/resolv.conf` 文件中，一般由 `NetworkManager` 根据连接的网络自动生成，例如北京大学校园网的 DNS 服务器为：

```text
162.105.109.122
162.105.109.88
```

而 `/etc/resolv.conf` 文件会被其它软件所改写，如 v2rayA 的“防止 DNS 污染”功能若设置为“仅防止 DNS 劫持（快速）”，则会覆盖 `/etc/resolv.conf` 文件

如果要防止程序覆盖 `/etc/resolv.conf` 文件，可以通过设置不可变文件属性来为其建立写入保护：

```bash
sudo chattr +i /etc/resolv.conf
```

### **TeX Live 安装**

#### **使用 ISO 镜像文件安装**

**一定要以 `sudo` 执行，否则无法安装到默认文件夹和设置 PATH 环境变量（无法写入）**

首先在[清华大学镜像](https://mirrors.tuna.tsinghua.edu.cn/CTAN/systems/texlive/Images/)或者[上海交大镜像](https://mirrors.sjtug.sjtu.edu.cn/ctan/systems/texlive/Images/)下载最新的 TeX Live ISO，一般在 `/CTAN/systems/texlive/Images/` 下，文件名为 `texlive.iso`

在 Dolphin 中右键点击 ISO 镜像文件挂载（需要 `dolphin-plugins` 软件包），或在终端中运行：

```bash
sudo mount -t iso9660 -o ro,loop,noauto (texlive_path)/texlive.iso /mnt
```

进入镜像文件夹，运行：

```bash
sudo perl install-tl --gui text
```

用大写字母命令控制安装：

```text
S >> 选择安装方案 >> R
C >> 输入字母选择要安装/不安装的软件包集合（参考：abcefglmDFGJP） >> R
D >> 输入数字，选择要安装 TeX Live 的各种位置 >> R
O >> L >> 选择默认位置 >> R
I
```

`<D> set directories` 中可以选择默认文件夹，若更改 `TEXDIR`，`TEXMFLOCAL` 等会随 `TEXDIR` 自动更改

`<O> options` 中一定要选择 `<L> create symlinks in standard directories`，这会自动设置 PATH 环境变量

如果使用图形界面安装，首先要检查是否安装 `tcl` 和 `tk` 软件包：

```bash
sudo pacman -S tcl tk
```

进入镜像文件夹，运行：

```bash
sudo perl install-tl --gui
```

即可在图形界面下载 TeX Live，高级设置需要点击左下角的 Advanced 按钮

#### **手动设置 PATH 环境变量**

**如果在安装时选择了 `<L> create symlinks in standard directories`，则不需要如下操作**

编辑 `/etc/profile`，添加如下内容：

```bash
PATH=/usr/local/texlive/2024/bin/x86_64-linux:$PATH; export PATH
MANPATH=/usr/local/texlive/2024/texmf-dist/doc/man:$MANPATH; export MANPATH
INFOPATH=/usr/local/texlive/2024/texmf-dist/doc/info:$INFOPATH; export INFOPATH
```

之后重启电脑

这样可以保证 Bash、Visual Studio Code 等都能够找到 TeX Live 的环境变量

可以运行 `tex --version` 检查是否安装成功，若成功应显示 TeX 的版本号、TeX Live 的版本号和版权信息

还可以运行 `tlmgr --version` 和 `texdoc (package_name)` （选择常见的宏包名称如 `texdoc tex`）检查是否安装成功

输入命令 `tlmgr conf` 可以查看 TeX Live 的文件夹设置，如 `TEXMFMAIN=(TEXDIR)/texmf-dist`

#### **使用 pacman 安装**

可以使用 `pacman` 从 Arch Linux 的官方源下载所需要的 TeX Live 软件包：

```bash
sudo pacman texlive-basic
```

其余 TeX Live 软件包按需下载，可以在 [Arch Linux Packages](https://archlinux.org/packages/) 查看

TeX Live 软件包的文档可以在以下网站在线查看：

[CTAN: Comprehensive TeX Archive Network](https://www.ctan.org/)

[TeXdoc online documentation](https://texdoc.org/)

也可以下载 `texlive-doc` 软件包（大小为 2.3 GiB）：

```bash
sudo pacman -S texlive-doc
```

之后也可以通过 Arch Linux 官方源更新

**注意官方软件源的更新周期与 TeX Live 相同，即一年一次，且只能以软件包集合为最小单位下载**

#### **更改 CTAN 镜像源**

CTAN 镜像源可以使用 TeX Live 包管理器 `tlmgr` 更改

更改到清华大学镜像需要在命令行中执行：

```bash
sudo tlmgr option repository https://mirrors.tuna.tsinghua.edu.cn/CTAN/systems/texlive/tlnet
```

更改到上海交大镜像需要在命令行中执行：

```bash
sudo tlmgr option repository https://mirrors.sjtug.sjtu.edu.cn/ctan/systems/texlive/tlnet/
```

#### **从安装程序安装**

可以从[官网](https://www.tug.org/texlive/acquire-netinstall.html)下载 [install-tl-unx.tar.gz](https://mirror.ctan.org/systems/texlive/tlnet/install-tl-unx.tar.gz)，解压后可以找到一个 `install-tl` 文件，执行：

```bash
sudo perl install-tl --select-repository --gui text
```

第一步输入数字选择镜像站，建议选择清华大学镜像或上海交大镜像

之后步骤与前面一致，大约需要 1h（从 ISO 安装只需要 10min，因为是直接从本地 ISO 镜像中安装，不需要网络）

#### **tlmgr 的常用命令**

显示说明文档：

```bash
tlmgr --help
```

下载软件包：

```bash
sudo tlmgr install (package_name)
```

这会同时下载软件包及其依赖

更新软件包：

```bash
sudo tlmgr update (package_name)
```

更新自身：

```bash
sudo tlmgr update --self
```

更新全部软件包：

```bash
sudo tlmgr update --all
```

查找本地软件包：

```bash
tlmgr search (package_name)
```

从软件源（即完整的 TeX Live）查找软件包，开启全词匹配：

```bash
tlmgr search --global --word (package_name)
```

从本地查找软件包文件（如 `.sty` 文件、`.def` 文件等），返回文件位置：

```bash
tlmgr search --file (file_name)
```

#### **命令行编译 LaTeX 源文件**

建议使用 `latexmk`，可以自动编译 `.tex`、`.bib` 文件等，直到最后输出正确的 PDF 文件

以 LuaLaTeX 为例，命令为：

```bash
latexmk -lualatex -bibtex -synctex=1 -interaction=nonstopmode -file-line-error --shell-escape (file_name)
```

如果使用 XeLaTeX，将 `-lualatex` 改为 `-xelatex` 即可

清理编译时产生的多余文件的命令为：

```bash
latexmk -clean (file_name)
```

#### **biber 报错**

biber 是 biblatex 的默认后端，用来替换过时的 biblatex，如果在运行 biber 的过程中出现以下报错：（可以用 `biber --help` 尝试）

```text
error while loading shared libraries: libcrypt.so.1: cannot open shared object file: No such file or directory
```

需要安装 `libxcrypt-compat`：

```bash
sudo pacman -S libxcrypt-compat
```

#### **安装 MathTime Professional 2 字体**

[MathTime Professional 2](https://www.pctex.com/mtpro2.html) 字体是 Type 1 字体，下载后为 `mtp2fonts.zip.tpm` 文件

可以使用以下脚本安装在 Linux 上：

[Mathtime Installer -- GitHub](https://github.com/jamespfennell/mathtime-installer)

下载 `mtpro2-texlive.sh`，并安装 `unzip` 软件包，之后执行：

```bash
bash mtpro2-texlive.sh -i mtp2fonts.zip.tpm
```

之后可以用 `\usepackage{mtpro2}` 使用 MathTime Professional 2 字体，用 `texdoc mtpro2` 查看文档

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

### **Thunderbird 安装与配置**

#### **Thunderbird 安装**

在官方仓库中安装 Thunderbird 邮件新闻客户端：

```bash
sudo pacman -S thunderbird
```

可以安装中文语言包：

```bash
sudo pacman -S thunderbird-i18n-zh-cn
```

打开 Thunderbird 后需要添加账户，输入自定义的姓名，现有的邮箱和密码即可，Thunderbird 会自动配置

再添加账户可以在右上角菜单栏选择“添加账户”中的“现有邮箱”，并可以拖动账户更改排序

#### **Thunderbird 设置**

进入设置界面调整显示：

设置 >> 常规 >> Thunderbird 起始页 >> 清空并取消勾选

设置 >> 常规 >> 默认搜索引擎 >> 改为 Bing 或 Google

设置 >> 隐私 >> 邮件内容 >> 勾选“允许消息中的远程内容”

右键点击上方邮件工具栏，选择“自定义”，自行配置即可

#### **Thunderbird 账户设置**

点击邮箱帐号，配置“账户设置”如下：

服务器 >> 服务器设置 >> 每隔 1 分钟检查一次新消息

如果要删除账户，在“账户设置”左下角的“账户操作”中选择“删除账户”

### **GitHub Desktop 安装**

推荐选择二进制包 `github-desktop-bin`：

```bash
paru -S github-desktop-bin gnome-keyring
```

登录时要创建一个密钥环，密钥设为 GitHub 密码即可

### **使用 SSH 连接到 GitHub**

推荐使用 SSH 连接到 GitHub，其安全性更高，访问速度较快且更加稳定

配置参考以下网址：

[GitHub Docs -- 使用 SSH 连接到 GitHub](https://docs.github.com/cn/github/authenticating-to-github/connecting-to-github-with-ssh)

步骤如下：（Linux 上直接用系统终端，Windows 上需要用 Git Bash 而不能用 Windows Terminal，因为缺少 `eval` 等命令）

#### **生成新 SSH 密钥并添加到 ssh-agent**

生成一个 SSH 密钥默认使用兼容性最好的 RSA 算法，现在推荐使用更安全的 ED25519 算法：

```bash
ssh-keygen -t ed25519 -C "(user_email)"
```

第一步生成私钥，会询问 `Enter file in which to save the key`，默认是 `~/.ssh/id_ed25519`，可以改为别的位置和名字，如 `(ssh_folder)/(key_name)`

第二步会提示输入安全密码，可以按 `Enter` 跳过，不影响后续操作和使用

这样创建的私钥位置为 `(ssh_folder)/(key_name)`，公钥位置为 `(ssh_folder)/(key_name).pub`

如果 SSH 密钥不在默认的 `~/.ssh`，则需要创建设置文件 `~/.ssh/config`（这个文件必须在 `~/.ssh/` 文件夹内）并写入：

```text
IdentityFile (ssh_folder)/(key_name)
```

之后执行：

```bash
eval "$(ssh-agent -s)"
ssh-add (ssh_folder)/(key_name)
```

#### **新增 SSH 密钥到 GitHub 帐户**

通过 `cat ~/.ssh/id_ed25519.pub` 查看公钥并复制到 GitHub 账户下的“Settings >> SSH and GPG keys”中

#### **测试 SSH 连接**

在终端中输入：

```bash
ssh -T git@github.com
```

这一步要输入 `yes` 确定

此时会显示：

```
Hi (user_name)! You've successfully authenticated, but GitHub does not provide shell access.
```

说明 SSH 连接测试成功

**注意 Linux 上和 Windows 上用的是不同的密钥，Windows 上操作步骤相同，但需要在 Git Bash（而不是 Windows Powershell）上执行**

### **Python 安装与配置**

Arch Linux 预装了 Python，但没有安装包管理器，可以使用 `pip` 或 `conda`

#### **pip 安装**

在终端中输入：

```bash
curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py && python get-pip.py
```

即可安装 pip，此时不建议安装 conda，pip 下载包的命令是：

```bash
pip install (package_name)
```

列出 pip 下载的所有包，包括下载的位置：

```bash
pip list -v
```

下载 Python 软件包：

```bash
pip install numpy matplotlib astropy black isort ipython jupyterlab
```

使用 Matplotlib 绘图需要下载 tk 库：

```bash
sudo pacman -S tk
```

#### **Miniconda 安装**

Miniconda 是 Anaconda 的精简版，推荐使用 Miniconda

下载地址如下：

[Miniconda -- Conda documentation](https://docs.conda.io/en/latest/miniconda.html)

安装过程参考以下网址：（Miniconda 和 Anaconda 的安装步骤相同）

[Anaconda Documentation -- Installing on Linux](https://docs.anaconda.com/anaconda/install/linux/)

用 `bash` 执行安装文件：

```bash
bash Miniconda3-latest-Linux-x86_64.sh
```

按 `Enter` 查看许可协议，然后按住 `Enter` 滚动

输入 `yes` 同意许可协议

输入安装 Miniconda 的目录并按 `Enter` 确定

最后一步输入 `yes` 执行 `conda init` 初始化 Miniconda

注意最后一步要选择 `yes`

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

输入以下命令：（在 Windows 中用户无法直接创建名为 `.condarc` 的文件，可先执行 `conda config --set show_channel_urls yes` 生成该文件之后再修改）

```bash
vim ~/.condarc
```

修改 `~/.condarc` 以使用清华大学镜像：

```text
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

```text
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

```text
channels:
  - defaults
ssl_verify: true
```

#### **Miniconda 下载软件包**

下载 Python 软件包：

```bash
conda install numpy matplotlib astropy black isort ipython jupyterlab
```

各个操作系统平台上可下载的包可以在以下网站查询：

[Anaconda Documentation -- Anaconda Package Lists](https://docs.anaconda.com/anaconda/packages/pkg-docs/)

下载 JupyterLab 插件：

```
pip install lckr_jupyterlab_variableinspector jupyterlab-lsp python-lsp-server[all] jupyterlab_execute_time jupyterlab-code-formatter jupyterlab-spellchecker ipympl jupyterlab_h5web
```

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

更新包：（`pip` 的相应命令为 `pip install --upgrade (package_name)`）

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

激活/切换环境：

```bash
conda activate (environment_name)
```

取消激活当前环境：

```bash
conda deactivate
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

这样就可以下载 `wcstools` 等软件

#### **下载 JupyterLab**

可以通过 `pip` 下载：

```bash
pip install jupyterlab
```

或者在 conda-forge 中下载：

```bash
conda install -c conda-forge jupyterlab
```

下载后用 `jupyter-lab` 或 `jupyter lab` 命令在浏览器中打开

#### **下载 photutils**

需要在 conda-forge 中下载：

```bash
conda install -c conda-forge photutils
```

#### **Spyder 下载与配置**

推荐使用 `conda` 下载，在 conda-forge 中有最新的版本：

```bash
conda install -c conda-forge spyder
```

Spyder 配置如下：

通用 >> 显示器分辨率 >> 自定义高分辨率缩放 >> 1.0

编辑选定的方案：

文本：（`B` 表示加粗）

- 普通文本 `#000000`
- 注释：`#aeaeae`，`B`
- 字符串：`#ff7777`
- 数值：`#a530e0`
- 关键字：`#2aa4db`，`B`
- 内置：`#f43232`，`B`
- 定义：`#ee55b7`
- 实例：`#00d29e`

高亮：

- 当前 Cell：`#e49dfd`
- 当前行：`#b2ffdd`
- 事件：`#fff442`
- 匹配圆括号：`#ff7f27`
- 不匹配圆括号：`#ff3535`
- 链接：`#74f466`

编辑器 >> 勾选“显示标签栏”、“显示缩进指导”、“显示行号”、“高亮显示当前行”、“高亮显示当前 Cell”，并把“高亮延迟时间”设定为 100 毫秒

用 Spyder 打开某个文件需要在终端中输入：

```bash
spyder (file_path)/(file_name)
```

Spyder 会在 `~/.config/spyder-py3` 中创建初始文件 `temp.py`

如果使用 Anaconda/Miniconda 安装 Spyder，需要用 conda 安装 `fcitx-qt5` 才能支持 Fcitx/Fcitx5 输入中文字符：

```text
conda install -c conda-forge fcitx-qt5
```

### **Visual Studio Code 安装与配置**

#### **Visual Studio Code 安装**

发行版维护者从开源代码构建的版本，可以用 `code` 命令打开（缺点是图标被重新设计过，且更新略微落后于微软官方版）：

```bash
sudo pacman -S code
```

微软官方的二进制包（包含部分私有的组件），同样可以用 `code` 命令打开（如果不介意私有组件而且不习惯 Code - OSS 的图标，个人推荐首选此项）：

```bash
paru -S visual-studio-code-bin
```

内测版本：

```bash
paru -S visual-studio-code-insiders-bin
```

[VSCodium](https://vscodium.com/) 发布的从开源代码构建的二进制包：

```bash
paru -S vscodium-bin
```

[VSCodium](https://vscodium.com/) 从最新的开源代码构建：

```bash
paru -S vscodium-git
```

为使用 KDE/Plasma 全局菜单，还需要安装 `libdbusmenu-glib` 包：

```bash
sudo pacman -S libdbusmenu-glib
```

下载扩展：Python（需要单独下载代码风格检查工具 Pylint 和格式化工具 autopep8 或 Black Formatter）、Jupyter、LaTeX Workshop、Markdown all in One 等

扩展保存在 `~/.vscode/extensions/` 文件夹内

#### **Visual Studio Code 设置**

若要更改全局设置，设置文件在 `~/.config/Code/User/settings.json`，可以在 Visual Studio Code 中按 `Ctrl+,` 开启设置

若要更改全局快捷键，设置文件在 `~/.config/Code/User/keybindings.json`，可以在 Visual Studio Code 中按 `Ctrl+K Ctrl+S` 开启设置

#### **Visual Studio Code 连字设置**

在 `setting.json` 中关闭连字：

```json
"editor.fontLigatures": false,
```

以 Fira Code 为例，连字可以设置为：

```json
"editor.fontFamily": "Fira Code",
"editor.fontLigatures": "'calt' off, 'cv16', 'ss01', 'ss03', 'ss05', 'zero'",
```

#### **Visual Studio Code 不在“打开方式”/“打开文件夹方式”菜单内**

在 1.90.0 版本之后，Visual Studio Code 在 `code.desktop` 中删除了 `inode/directory`，使得“打开方式”/“打开文件夹方式”菜单中没有 Visual Studio Code

解决该问题的方法是下载 AUR 软件包 `vscode-xdg-patch-hook`：

```bash
paru -S vscode-xdg-patch-hook
```

它可以自动修改所有所需的文件，并顺带解决其它一些问题

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

#### **Python 插件设置**

如果使用的是 Miniconda 提供的 Python，需要查询 Python 的安装位置：

```bash
which python
```

并将返回的结果 `(python_path)` 添加到 `settings.json` 中：

```json
"python.defaultInterpreterPath": "(python_path)"
```

#### **LaTeX Workshop 插件设置**

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
"[\n\t${1}\n\\]"
```

重启 Visual Studio Code 即可生效，缺点是插件每次更新时会覆盖设置

#### **Markdown All in One 插件设置**

Visual Studio Code 自带 Markdown 预览功能，但是不支持快捷键（如粗体、斜体）、数学命令的补全（只支持预览），也不支持复选框：

```text
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
paru -S jetbrains-fleet
```

### **Typora 安装和设置**

#### **Typora 安装**

Typora 可以从 AUR 安装：

```bash
paru -S typora
```

#### **源代码模式设置**

更改 `/usr/share/typora/resources/style/base-control.css`：（在 Windows 中则是 `C:\Program Files\Typora\resources\style\base-control.css`）

找到 `.CodeMirror.cm-s-typora-default div.CodeMirror-cursor` 一行，将光标宽度改为 `1px`，颜色从 `#e4629a` 改为 `#000000`

更改 `/usr/share/typora/resources/style/base.css`：（在 Windows 中则是 `C:\Program Files\Typora\resources\style\base.css`）

找到 `:root` 一行，将 `--monospace` 改成自己想要的等宽字体

#### **主题渲染模式设置**

在 `/home/(user_name)/.config/Typora/themes/` 中自己写一个 CSS 文件（可以复制其中一个默认主题，重命名后更改）

找到 `body` 一行，将 `font-family` 改成自己想要的字体

找到 `tt` 一行，将 `font-family` 改成自己想要的等宽字体（`monospace`）

### **SAOImageDS9 安装和设置**

AUR 中有 `ds9`、`ds9-bin` 和 `ds9-git` 三个版本，以二进制包 `ds9-bin` 为例：

```bash
paru -S ds9-bin
```

如果出现这样的错误导致 SAOImageDS9 无法打开或闪退：

```text
application-specific initialization failed: unknown color name "BACKGROUND"
Unable to initialize window system.
```

在终端中输入：

```bash
xrdb -load /dev/null
xrdb -query
```

即可解决

设置 SAOImageDS9 使用鼠标左键拖动图片如下：

Edit >> Preferences >> Pan Zoom >> 选择“Drag to Center”

保存设置后，在“Edit >> Pan”模式下即可使用鼠标左键拖动图片

### **IRAF/PyRAF 安装**

#### **从 AUR 安装 IRAF**

可以从 AUR 安装 IRAF：

```bash
paru -S iraf-bin
```

#### **从源代码安装 IRAF**

首先下载编译依赖：

```bash
sudo pacman -S gcc make bison flex zlib curl expat readline
```

从 GitHub 上下载软件源代码：

```bash
git clone https://github.com/iraf-community/iraf.git
```

进入 `iraf` 文件夹，并执行：

```bash
make 2>&1 | tee build.log
```

可以使用 `make test` 测试安装，输出的 `xfailed` 是预计就会失败的，不必担心

之后执行：

```bash
sudo make install
```

将其安装到系统

默认安装到 `/usr/local`，也可以更改为其它位置：

```bash
sudo make install prefix=(directory)
```

部分功能可能需要 xgterm：

```bash
paru -S xgterm-bin
```

#### **安装 PyRAF**

可以用 pip 安装 PyRAF：

```bash
pip install pyraf
```

#### **IRAF/PyRAF 常用命令**

启动 IRAF 的命令为：

```bash
irafcl
```

列出所有可以使用的 IRAF 命令：

```bash
?
```

查看命令的说明文档：

```bash
help (command)
```

启动 PyRAF：

```bash
pyraf
```

退出 IRAF：

```bash
logout
```

退出 PyRAF：（也可以用 `Ctrl+D`）

```bash
exit()
```

启动参数编辑器（the EPAR Parameter Editor）的命令为：

```bash
epar (task_name)
```

退出参数编辑器的命令和 Vim 一样，也是 `:q`

### **Topcat 安装**

天文数据表格操作工具 [Topcat](https://www.star.bris.ac.uk/~mbt/topcat/) 可以从 AUR 安装：

```bash
paru -S topcat
```

如果 Topcat 在高分辨率屏幕上显示过小，则编辑 `~/.starjava.properties` 并加入：

```text
sun.java2d.uiScale=2
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

### **Docker 安装**

可以在官方仓库安装 Docker：

```bash
sudo pacman -S docker
```

之后执行：

```bash
sudo systemctl enable --now docker
```

再执行：

```bash
sudo docker info
```

以检查 Docker 运行状态，如果正常显示 Docker 信息说明安装成功

### **开启 OpenSSH 服务端**

sshd 是 OpenSSH 服务器守护程序，开启 sshd 之后，其它电脑可以用 `ssh` 命令连接本电脑：

```bash
sudo systemctl enable --now sshd
```

本机的 IP 地址可以使用 `ip addr` 命令查询

### **相机安装（可选）**

KDE 官方的相机应用是 Kamoso：

```bash
sudo pacman -S kamoso
```

需要区别于另一个 KDE 应用 Kamera，Kamera 提供了一个配置工具和一个 KIO 工作程序，用于在采用了此协议的数码相机上进行读写操作

### **QQ 安装（可选）**

可以下载基于 Electron 的官方 QQ Linux 版：

```bash
paru -S linuxqq
```

### **微信安装（可选）**

推荐安装以下版本：

```bash
paru -S wechat-universal-bwrap
```

### **会议软件安装（可选）**

#### **腾讯会议**

推荐安装官方原生的腾讯会议 Linux 版：

```bash
paru -S wemeet-bin
```

在 Wayland 上会产生无法共享屏幕的问题，还需要安装 `wemeet-wayland-screenshare-git` 包：

```bash
paru -S wemeet-wayland-screenshare-git
```

#### **钉钉**

```bash
paru -S dingtalk-bin
```

高分辨率屏幕下可以点击头像 >> 设置 >> 全局缩放，选择 150%

#### **Zoom**

```bash
paru -S zoom
```

高分辨率屏幕下调整全局缩放需要编辑 `~/.config/zoomus.conf`，加入一行 `scaleFactor=2`

#### **Microsoft Teams**

```bash
paru -S teams
```

#### **Slack**

```bash
paru -S slack-desktop
```

### **音乐软件安装（可选）**

#### **网易云音乐**

```bash
paru -S netease-cloud-music
```

#### **QQ 音乐**

```bash
paru -S qqmusic-bin
```

默认是暗色主题，右上角皮肤键（衣服图案）可以更改为亮色主题

### **办公软件安装（可选）**

WPS 安装：

```bash
paru -S wps-office-cn wps-office-mui-zh-cn ttf-wps-fonts
```

LibreOffice 安装：

```bash
paru -S libreoffice-fresh
```

### **百度网盘安装（可选）**

```bash
paru -S baidunetdisk-bin
```

### **BitTorrent 客户端安装（可选）**

推荐使用 KDE 官方客户端 KTorrent：

```bash
paru -S ktorrent
```

或者同样功能强大且跨平台的 qBittorrent：

```bash
paru -S qbittorrent
```

### **Filelight 安装（可选）**

Filelight 是一款以图形化方式显示电脑磁盘使用情况的应用程序，可以从官方仓库安装：

```bash
paru -S filelight
```

### **使用 CachyOS 内核（可选）**

首先检查 CPU 是否支持 `x86-64-v3` 和 `x86-64-v4` 微架构：

```bash
/lib/ld-linux-x86-64.so.2 --help | grep supported
```

输出结果如：

```
x86-64-v4 (supported, searched)
x86-64-v3 (supported, searched)
x86-64-v2 (supported, searched)
```

说明支持 `x86-64-v3` 和 `x86-64-v4` 微架构

导入密钥：

```bash
sudo pacman-key --recv-keys F3B607488DB35A47
sudo pacman-key --lsign-key F3B607488DB35A47
```

编辑 `/etc/pacman.conf` 文件：

```bash
sudo vim /etc/pacman.conf
```

如果 CPU 支持 `x86-64-v3`，则添加：

```text
[cachyos-v3]
Include = /etc/pacman.d/cachyos-v3-mirrorlist
[cachyos]
Include = /etc/pacman.d/cachyos-mirrorlist
```

如果 CPU 支持 `x86-64-v4`，则添加：

```text
[cachyos-v4]
Include = /etc/pacman.d/cachyos-v4-mirrorlist
[cachyos]
Include = /etc/pacman.d/cachyos-mirrorlist
```

之后下载想要的内核，例如：

```
sudo pacman -S linux-cachyos
```

之后重新生成 GRUB 文件：

```bash
sudo grub-mkconfig -o /boot/grub/grub.cfg
```

重启电脑即可

参考以下网址：

https://github.com/CachyOS/linux-cachyos