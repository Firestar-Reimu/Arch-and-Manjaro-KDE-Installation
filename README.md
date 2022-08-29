# **在 ThinkPad X13 2021 Intel/Surface Pro 6 上安装 Manjaro 21 KDE Plasma + Windows 11 双系统的指南**

ThinkPad 系统信息：

```
OS: Manjaro 21.2.6 Qonos
Kernel: x86_64 Linux 5.18.1-1-MANJARO
Resolution: 2560x1600
DE: KDE 5.96.0 / Plasma 5.24.6
WM: KWin
CPU: 11th Gen Intel Core i7-1165G7 @ 8x 4.7GHz
GPU: Mesa Intel(R) Xe Graphics (TGL GT2)
```

Surface 系统信息：

```
OS: Manjaro 21.1.1 Pahvo
Kernel: x86_64 Linux 5.14.0-0-MANJARO/x86_64 Linux 5.13.13-arch1-3-surface
Resolution: 2736x1824
DE: KDE 5.85.0 / Plasma 5.22.5
WM: KWin
CPU: Intel Core i5-8250U @ 8x 3.4GHz
GPU: Mesa Intel(R) UHD Graphics 620 (KBL GT2)
```

**说明：Surface 专有部分自 2021.9.5 起不再更新，内核版本终止于 x86_64 Linux 5.14.0-0-MANJARO/x86_64 Linux 5.13.13-arch1-3-surface**

## **Windows 的准备工作**

### **为 Manjaro 系统分区**

右键点击开始菜单，选择“磁盘管理”，分出一块空分区，建议不小于 64GB

### **关闭快速启动**

Windows 工具 >> 控制面板 >> 电源选项 >> 选择电源按钮的功能 >> 更改当前不可用的设置 >> 关闭快速启动 >> 保存修改

### **关闭 Secure Boot**

#### **进入 UEFI/BIOS 设置**

ThinkPad 的操作如下：启动 ThinkPad 时按 `Enter` 打断正常开机，然后按下 `Fn+Esc` 解锁 `Fn` 按钮，再按 `Fn+F1` 进入 UEFI/BIOS 设置

Surface 的操作如下：长按 Surface 上的调高音量按钮，同时按下再松开电源按钮，此时屏幕上会显示 Microsoft 或 Surface 徽标，继续按住调高音量按钮，显示 UEFI 界面后，松开此按钮即可

#### **关闭 Secure Boot**

在 UEFI/BIOS 设置界面：

ThinkPad：Security >> Secure Boot >> Off

Surface：Security >> Secure Boot >> Disabled（第三个选项）

### 删除多余的 Windows 启动项

如果在电脑上装有多个 Windows，则系统只会选择其中一个在 Windows Boot Manager 中启动，若要删除多余的启动项，在 Windows 的“系统配置”（搜索框中输入 `msconfig` 或在“Windows 工具”中选择）的“引导”页面即可删除

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

[Manjaro Wiki -- Build Manjaro ISOs with buildiso](https://wiki.manjaro.org/title/Build_Manjaro_ISOs_with_buildiso)

制作之前需要下载软件 `manjaro-tools-iso`，并在 `/etc/manjaro-tools/manjaro-tools.conf` 中修改镜像：

```bash
build_mirror=https://mirrors.tuna.tsinghua.edu.cn/manjaro/
```

命令为：`buildiso -p kde -b testing -k linux519`，整个过程大约需要 10 分钟

#### **通过 GitHub Actions 制作 ISO 镜像**

还可以用下面的方法通过 GitHub Actions 制作自定义的 ISO 镜像，参考以下网址：

[YouTube -- Building your custom Manjaro ISO via Github Actions CI](https://www.youtube.com/watch?v=S2t5Iat37CI)

### **刻录 USB 启动盘**

推荐使用 [Ventoy](https://www.ventoy.net/cn/index.html)，可以在 Windows/Linux 上使用，方法是下载安装包后解压、安装到 USB 上，之后直接将 ISO 镜像拷贝到 USB 中即可选择镜像文件进行登录系统，支持多个系统镜像登录

Linux 上也可以使用 [Etcher](https://www.balena.io/etcher/)，在 Linux（下载 AppImage 文件或从 AUR 上用包管理器下载 `balena-etcher`）和 Windows（下载 EXE 可执行文件）上均能使用（但不支持刻录 Windows 系统镜像）

Windows 上还可以用 [Rufus](https://rufus.ie/zh/)，速度与 Etcher 相当且支持 Windows 和 Linux 系统镜像，但无法在 Linux 上使用（只提供 Windows 版 EXE 可执行文件）

### **从 USB 启动**

#### **在 Windows 中设置从 USB 启动**

设置 >> 恢复 >> 立即重新启动 >> ThinkPad 上选择 USB HDD，Surface 上选择 USB Storage

#### **在 UEFI/BIOS 中设置从 USB 启动**

ThinkPad：启动时按 `Enter` 打断正常开机，然后按下 `Fn+Esc` 解锁 `Fn` 按钮，再按 `Fn+F12` 选择启动位置为 USB HDD

Surface：启动后进入 UEFI 界面后选择 Boot configuration，然后按住 USB Storage 选项并左滑即可从 USB 启动

### **安装 Manjaro**

语言选择“简体中文”

时区选择“Asia - Shanghai”

键盘设置选择“Chinese >> Default”

安装时选择“替代一个分区”，并点击之前空出来的空分区

或者手动挂载空分区，挂载点设为 `/`，标记为 `root`，手动挂载 UEFI 分区（即第一个分区 `dev/nvme0n1p1`，格式为 FAT32），不要格式化，挂载点设为 `/boot/efi`，标记为 `boot`

用户名建议全部用小写字母并与登录时的用户名一致

设置密码，并勾选“为管理员使用相同的密码”

## **初始配置**

### **启动顺序设置**

在 UEFI/BIOS 中调整启动顺序，保证 Manjaro 处于启动顺序的第一项，否则无法进入 Manjaro 系统

ThinkPad: Startup >> Boot >> Edit Boot Order 中可以调整和删除启动顺序

Surface: Boot Configuration >> Configure boot device order 中可以调整和删除启动顺序

### **电源与开机设置**

系统设置 >> 电源管理 >> 节能 >> 勾选“按键事件处理” >> 合上笔记本盖时 >> 选择“关闭屏幕” >> 勾选“即使已连接外部显示器”

系统设置 >> 开机与关机 >> 桌面会话 >> 登入时 >> 选择“以空会话启动”

#### **与电源管理相关的常见英文名词**

Sleep：睡眠，Suspend：挂起，Reboot：重启，Shutdown：关机，Logout：注销

### **高分辨率设置**

ThinkPad 的屏幕分辨率是 2560×1600，而 Surface 的屏幕分辨率是 2736×1824，需要配置高分屏优化：

系统设置 >> 显示和监控 >> 显示配置 >> 分辨率 >> 全局缩放 >> 200%

系统设置 >> 光标 >> 大小 >> 36

然后重启电脑

### **Konsole/Yakuake 快捷键配置**

打开 Konsole/Yakuake（可以用 `Fn+F12` 直接打开 Yakuake）：

设置 >> 配置键盘快捷键 >> 复制改为 `Ctrl+C` ，粘贴改为 `Ctrl+V`

### **选择镜像并更改更新分支**

选择镜像：

```bash
sudo pacman-mirrors -ic China
```

更新分支 `(branch)` 可以选择 `stable / stable-staging / testing / unstable`，更改更新分支的命令为：（不要漏掉 `-a`）

```bash
sudo pacman-mirrors -aS (branch)
sudo pacman -Syyu
```

获取更新分支的命令为：

```bash
sudo pacman-mirrors -G
```

选择镜像并更改更新分支的命令则为：

```bash
sudo pacman-mirrors -aS (branch) -ic China
```

**一般建议选择上海交大的镜像，其更新频率最高且支持全部三个更新分支，如果在北京大学访问上海交大镜像源较慢可以考虑用更快的清华大学镜像源**

### 包管理器

Manjaro 预装的包管理器有 pacman 和 pamac，其使用教程参考以下网址：

[Manjaro Wiki -- Pacman Overview](https://wiki.manjaro.org/title/Pacman_Overview)

[Manjaro Wiki -- Pacman-mirrors](https://wiki.manjaro.org/title/Pacman-mirrors)

[ArchWiki -- Pacman](https://wiki.archlinux.org/title/Pacman)

[Manjaro Wiki -- Pamac](https://wiki.manjaro.org/title/Pamac)

其中 pacman 和 pamac 是预装的，“添加/删除软件”就是 pamac 的 GUI 版本

硬件管理的包管理器是 mhwd 和 mhwd-kernel，其使用教程参考以下网址：

[Manjaro Wiki -- Manjaro Hardware Detection Overview](https://wiki.manjaro.org/title/Manjaro_Hardware_Detection_Overview)

[Manjaro Wiki -- Configure Graphics Cards](https://wiki.manjaro.org/title/Configure_Graphics_Cards)

[Manjaro Wiki -- Manjaro Kernels](https://wiki.manjaro.org/title/Manjaro_Kernels)

这两个也可以在 Manjaro Settings Manager（GUI 版本）中使用

### **AUR**

#### **安装 base-devel**

AUR 上的某些 PKGBUILD 会默认你已经安装 `base-devel` 组的所有软件包而不将它们写入构建依赖。为了避免在构建过程中出现一些奇怪的错误，建议先安装 `base-devel`：

```bash
sudo pacman -S base-devel
```

#### **AUR 软件包管理器**

**注意 pacman 不支持 AUR，所以需要下载 AUR 软件包管理器**

Manjaro 自带的 pamac 可以支持 AUR，需要按照如下方式启用 pamac 的 AUR 支持：

添加/删除软件 >> 设置（右上角的三横线图标） >> 首选项 >> AUR >> 启用 AUR 支持

然后就可以用 pamac 的图形界面获取 AUR 软件包，或者用命令 `pamac build` 及 `pamac install` 获取 AUR 的软件包

另外还可以下载 `yay`，命令与 `pacman` 相似，其使用教程参考以下网址：

[yay -- GitHub](https://github.com/Jguer/yay)

**以下所有 `sudo pacman` 都可以用 `yay` 替代，`pamac install` 都可以用 `yay -S` 替代**

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

之后执行下面的命令安装 archlinuxcn-keyring 包导入 GPG key

```bash
sudo pacman -Sy archlinuxcn-keyring
sudo pacman -Syyu
```

这样就开启了 pacman 和 pamac 对 Arch Linux CN 的支持

由于 Manjaro 的更新滞后于 Arch，使用 Arch Linux CN 仓库可能会出现“部分更新”的情况，导致某些软件包损坏

建议切换到 testing 或 unstable 分支以尽量跟进 Arch 的更新

**注意一定要写第一行的 `[archlinuxcn]`，安装 archlinuxcn-keyring 时要用 `-Sy` 安装（更新后安装）**

#### **搜索软件包**

在 `pamac` 上可以执行：

```bash
pamac search (package_name)
```

或者在 `yay` 上执行：

```bash
yay (package_name)
```

#### **检查依赖关系**

以树状图的形式展示某软件包的依赖关系：

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

### **Vim 安装与配置**

建议先安装 Vim，方便之后编辑各种文件：

```bash
sudo pacman -S vim
```

Vim 的配置文件主要有 `/usr/share/vim/vimfiles/archlinux.vim`，`/etc/vimrc` 和 `/home/(user_name)/.vimrc`，建议直接修改 `/etc/vimrc`，这样不会覆盖 `/usr/share/vim/vimfiles/archlinux.vim` 上定义的默认配置（语法高亮等）

Vim 的配置可以参考以下网址：

[Options -- Vim Reference Manual](https://vimhelp.org/options.txt.html)

启用剪贴板功能，并应用 `Ctrl+C`、`Ctrl+V`、`Ctrl+A`、`Ctrl+Z`等快捷键，需要在 `/etc/vimrc` 中写入：

```
set clipboard=unnamedplus
source $VIMRUNTIME/mswin.vim
```

`mswin.vim` 的源代码可以在这里找到：

[vim -- mswin.vim](https://github.com/vim/vim/blob/master/runtime/mswin.vim)

### **GNU nano 配置**

nano 的配置文件在 `/etc/nanorc`，可以通过取消注释设置选项配置文件，如：

取消注释 `set linenumbers` 可以显示行号

取消注释 `set tabsize 8` 可以更改 Tab 键的长度，例如 `set tabsize 4`

取消注释 `set tabstospaces` 可以将 Tab 转换为空格

取消注释 `set matchbrackets "(<[{)>]}"` 可以匹配括号

取消注释 `include "/usr/share/nano/*.nanorc"` 一行和所有的颜色设置可以启用代码高亮

取消注释所有的 `Key bindings` 选项可以启用更常用的快捷键设定

**用 nano 编辑后保存的步骤是 `Ctrl+W` （Write Out） >> `Enter` >> `Ctrl+Q` （Exit），如果用默认的快捷键设置，则为 `Ctrl+O` （Write Out） >> `Enter` >> `Ctrl+X` （Exit）**

### **更改 visudo 默认编辑器为 Vim**

Manjaro 中 visudo 的默认编辑器是 Vi，若要改为 Vim，则首先在终端中输入：

```bash
sudo visudo
```

在开头的一个空行键入：

```
Defaults editor=/usr/bin/vim
```

按 `Esc` 进入命令模式，再按 `:x` 保存，按 `Enter` 退出

如果想临时使用 Vim 作为编辑器，则输入：

```bash
sudo EDITOR=vim visudo
```

### **sudo 免密码**

在最后一行（空行）按 `i` 进入输入模式，加上这一行：

```
Defaults:(user_name) !authenticate
```

进入命令模式，保存退出即可

**注：如果想保留输入密码的步骤但是想在输入密码时显示星号，则加上一行 `Defaults env_reset,pwfeedback` 即可**

### **命令行界面输出语言为英语**

在 `~/.zshrc` 或 `~/.bashrc` 中添加一行：

```
export LANGUAGE=en_US.UTF-8
```

### **时间设置**

#### **双系统时间不同步**

系统设置 >> 时间和日期 >> 自动设置时间和日期

在 Manjaro 上设置硬件时间为 UTC：

```bash
sudo timedatectl set-local-rtc 0
```

并在 Windows 上设置硬件时间为 UTC，与 Manjaro 同步：

```powershell
reg add "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\TimeZoneInformation" /v RealTimeIsUniversal /d 1 /t REG_QWORD /f
```

这一步需要在 Powershell（管理员）中执行

#### **Manjaro 数字时钟设置 24 小时制**

右键点击“数字时钟” >> 配置数字时钟 >> 时间显示 >> 24 小时制

#### **添加 TUNA 网络授时服务**

参考以下网址：

[TUNA NTP（网络授时）服务使用说明](https://tuna.moe/help/ntp/)

### **Linux 挂载 Windows 磁盘**

**首先要确保设备加密和快速启动已经关闭**

参考以下网址：

[Archwiki -- fstab](https://wiki.archlinux.org/title/Fstab_(%E7%AE%80%E4%BD%93%E4%B8%AD%E6%96%87))

#### **使用 UUID**

官方推荐的方法是使用 UUID，以分别挂载 C 盘和 D 盘到 `/home/(user_name)/C` 和 `/home/(user_name)/D` 为例，在终端中输入：

```bash
lsblk -f
```

在输出结果中可以发现 Windows 的硬盘分区：

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
UUID=(UUID_C)                     /home/(user_name)/C    ntfs defaults 0 0
UUID=(UUID_D)                     /home/(user_name)/D    ntfs defaults 0 0
```

重启电脑后，即可自动挂载

**如果需要格式化 C 盘或 D 盘，先从 `/etc/fstab` 中删去这两行，再操作，之后磁盘的 `UUID` 会被更改，再编辑 `/etc/fstab` ，重启挂载即可**

#### **使用图形化界面**

在系统应用“KDE 分区管理器”中卸载 C 盘、D 盘，右键选择编辑挂载点，编辑为 `/home/(user_name)/C` 和 `/home/(user_name)/D`，选项全部不用勾选（使用默认配置），点击“执行”即可

这相当于直接编辑 `/etc/fstab`，加入：

```
/dev/(name_C)                     /home/(user_name)/C    ntfs defaults 0 0
/dev/(name_D)                     /home/(user_name)/D    ntfs defaults 0 0
```

好处是格式化磁盘后内核名称不变，依然可以挂载

#### **如果 Windows 磁盘突然变成只读**

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

执行硬盘 NTFS 分区修复：

```bash
sudo ntfsfix /dev/(partition_name)
```

再重新挂载即可：

```bash
sudo mount /dev/(partition_name) (mount_path)/(mount_folder)
```

如果在 Dolphin 中已经成功卸载分区，则直接执行：

```bash
sudo ntfsfix /dev/(partition_name) && sudo mount /dev/(partition_name)(mount_path)/(mount_folder)
```

### **字体安装**

Manjaro KDE 支持直接在 Dolphin 的右键菜单中安装 TTF/OTF 字体和 TTC/OTC 字体集

**注意不管是 Windows 还是 Manjaro Linux 都要将字体“为所有用户安装”，尤其是 Windows 11 右键直接安装是安装到个人用户目录 `C:\Users\(user_name)\AppData\Local\Microsoft\Windows\Fonts` 而非系统目录 `C:\Windows\Fonts`**

#### **命令行安装字体**

将字体文件复制到 `/usr/share/fonts` 安装，方法如下：

```bash
sudo cp (font-path)/* /usr/share/fonts
cd /usr/share/fonts
fc-cache -fv
```

这样就可以安装微软雅黑、宋体、黑体等字体了

**微软系统字体文件夹在 `C:\Windows\Fonts`，可以复制到 `/usr/share/fonts` 安装，注意需要排除掉 MS Gothic、Yu Gothic 和 Malgun Gothic 字体，因它们只有部分日/韩文汉字字形（与中文汉字字形一样的会被排除，最后导致部分中文汉字显示为日/韩文字形）**

### **安装 Google Noto 字体**

命令行安装：

```bash
sudo pacman -S noto-fonts noto-fonts-cjk
```

所有语言字体的下载地址如下：

[Noto Fonts -- Google Fonts](https://fonts.google.com/noto/fonts)

中文（CJK）字体的下载地址如下：

[Noto CJK -- GitHub](https://github.com/googlefonts/noto-cjk)

**注意 Microsoft Office 不支持嵌入 OTF 字体，只能嵌入 TTF 字体**

### **更改程序和终端默认中文字体**

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

**另一种处理方法是只安装简体中文字体，比如 Noto Sans SC（注意没有 CJK）**

### **安装中文输入法**

推荐使用 Fcitx5:

```bash
sudo pacman -S fcitx5 fcitx5-gtk fcitx5-qt fcitx5-configtool fcitx5-chinese-addons manjaro-asian-input-support-fcitx5
```

或者（fcitx-im 组包括了 fcitx5、fcitx5-gtk、fcitx5-qt、fcitx5-configtool）：

```bash
sudo pacman -S fcitx5-im fcitx5-chinese-addons manjaro-asian-input-support-fcitx5
```

如果无法启动输入法，在系统设置 >> 区域设置 >> 输入法 >> 添加输入法中手动添加“拼音”

对应的 git 版本为：（需要使用 Arch Linux CN 源）

```bash
sudo pacman -S fcitx5-git fcitx5-chinese-addons-git manjaro-asian-input-support-fcitx5 fcitx5-gtk-git fcitx5-qt5-git fcitx5-configtool-git
```

可以添加词库：

```bash
sudo pacman -S fcitx5-pinyin-moegirl fcitx5-pinyin-zhwiki
```

一个稳定的替代版本是 Fcitx 4.2.9.8-1：

```bash
sudo pacman -S fcitx-im fcitx-configtool fcitx-cloudpinyin manjaro-asian-input-support-fcitx
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

**安装输入法之后需要重启电脑才能生效**

### **关闭启动和关机时的系统信息**

参考以下网址：

[Silent Boot -- ArchWiki](https://wiki.archlinux.org/title/Silent_boot)

[Improving Performance -- ArchWiki](https://wiki.archlinux.org/title/Improving_performance)

主要是 [Kernel parameters](https://wiki.archlinux.org/title/Silent_boot#Kernel_parameters) 和 [fsck](https://wiki.archlinux.org/title/Silent_boot#fsck) 两段，以及关于 [watchdog](https://wiki.archlinux.org/title/Improving_performance#Watchdogs) 的说明

以下所有的 `sudo update-grub` 也可以替换为 `sudo grub-mkconfig -o /boot/grub/grub.cfg`

#### **关闭启动时 fsck 的消息**

第一种方法是将 fsck 的消息重定向到别的 TTY 窗口

编辑 Kernel parameters：

```bash
sudo vim /etc/default/grub
```

在 `GRUB_CMDLINE_LINUX_DEFAULT` 中加入 `console=tty3`

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
sudo update-grub
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
sudo update-grub
```

再重启即可

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

找到安装 Manjaro 的分区`((hd_number),(gpt_number))`，此时执行 `ls((hd_number),(gpt_number))`应该能看到 Manjaro 根目录下的所有文件和文件夹

手动修改启动分区所在的位置：

```bash
set prefix=((hd_number),(gpt_number))/boot/grub
```

执行：

```bash
insmod normal
normal
```

即可进入 GRUB 界面，从这里登录 Manjaro 系统，登录后执行：

```
sudo update-grub
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

### **Dolphin 在更新后删除文件/文件夹报错**

如果出现以下错误：

```
无法创建输入输出后端。klauncher 回应：装入“/usr/lib/qt/plugins/kf5/kio/trash.so”时出错
```

说明 Qt 还在内存中保留着旧版 Dolphin，此时可以重启/重新登录，或执行：

```bash
dbus-launch dolphin
```

### **SONY WH-1000XM3 耳机的蓝牙连接**

长按耳机电源键约 7 秒即可进入配对模式，可以在蓝牙中配对

### **Logitech 鼠标的蓝牙连接**

同一台电脑的 Windows 系统和 Manjaro 系统在鼠标上会被识别为两个设备

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

### **解决用 root 登录没有声音的问题**

在 `/root/.config/autostart/` 下创建一个 `pulseaudio.desktop` 文件：

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

保存退出即可

### **切换图形化界面和命令行界面**

登录时默认进入的是图形化界面，有时候开机后黑屏是图形化界面显示不出来所致，此时可以按快捷键 `Ctrl+Alt+Fn+(F2~F6)`进入`tty2 ~ tty6` 的任何一个命令行 TTY 界面

注意此时需要手动输入用户名和密码

在命令行界面解决问题后，按快捷键 `Ctrl+Alt+Fn+F1` 可以转换回图形化界面

### **网络设置**

#### **ping 命令**

IP 地址和连接情况可以通过对域名 `ping` 得到，例如：

```bash
ping -c (count_number) (website_destination)
```

表示对网站域名 `(website_destination)` 发送 `(count_number)` 次 `ping` 连通请求

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

### **从 PulseAudio 转移到 Pipewire**

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

```
default
    Default ALSA Output (currently PipeWire Media Server)
```

### **Surface：Linux-Surface 内核安装（可选）**

**[Linux-Surface](https://github.com/linux-surface/linux-surface) 内核可以实现一些 Manjaro 官方内核不支持的功能。Manjaro 官方内核从 Linux 5.13-MANJARO 开始已经支持 Surface 的电池组件（旧版内核不支持，无法显示电池电量状态），但不支持触屏，相关支持情况详见 [Linux-Surface -- Feature Matrix](https://github.com/linux-surface/linux-surface/wiki/Supported-Devices-and-Features#feature-matrix)**

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

#### **hosts 文件设置（可选）**

修改 hosts 文件可以有效访问 GitHub，需要修改的文件是 `/etc/hosts`，Windows 下对应的文件位置为： `C:\Windows\System32\drivers\etc\hosts` （注意这里是反斜杠），修改内容参见以下网站：

[HelloGitHub -- hosts](https://raw.hellogithub.com/hosts)

### **调整 CPU 频率（可选）**

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

**不需要高性能的时候可以关闭睿频，这样 CPU 的频率就会限制在 1.9 GHz 以下，大幅增加续航、减少发热**

保存、关闭，在终端中输入：

```bash
sudo tlp start
```

#### **显示 Intel CPU 频率（可选）**

安装 KDE 小部件：[Intel P-state and CPU-Freq Manager](https://github.com/jsalatas/plasma-pstate)

右键点击顶栏，选择“添加部件”，找到 Intel P-state and CPU-Freq Manager 并添加在顶栏即可

### **禁用 baloo（可选）**

`baloo` 是 KDE 的文件索引服务，能加快文件搜索的速度，但可能会时不时产生大量硬盘读写而导致图形界面卡顿。可以用下面的命令禁用之：

```bash
balooctl disable
```

### **为 pacman 启用多线程下载（可选）**

执行下面的命令下载 axel

```bash
 sudo pacman -S axel
```

编辑 `/etc/pacman.conf` 文件（在第 21 行）:

```
XferCommand = /usr/bin/axel -n 10 -o %o %u
```

编辑 `/etc/makepkg.conf` 文件（在第 12-17 行）:

```
DLAGENTS=('file::/usr/bin/curl -gqC - -o %o %u'
'ftp::/usr/bin/axel -n 10 -o %o %u'
'http::/usr/bin/axel -n 10 -o %o %u'
'https::/usr/bin/axel -n 10 -o %o %u'
'rsync::/usr/bin/rsync --no-motd -z %u %o'
'scp::/usr/bin/scp -C %u %o')
```

**注意某些软件包如 `rider` 和 `qqmusic-bin` 等下载源不支持 axel，启用多线程下载后可能会导致构建失败**

### **zram 文件设置（可选）**

对 zram 的介绍可以参考[官方文档](https://www.kernel.org/doc/html/latest/admin-guide/blockdev/zram.html)，设置步骤可以参考[ArchWiki](https://wiki.archlinux.org/title/Improving_performance#zram_or_zswap)

先下载 `zram-generator` 软件包：

```bash
sudo pacman -S zram-generator
```

编辑 `/etc/systemd/zram-generator.conf`，写入：

```
[zram0]
host-memory-limit = none
zram-size = min(ram / 2, 4096)
compression-algorithm = lzo-rle
fs-type = ext4
mount-point = /var/tmp
```

在终端输入

```bash
sudo systemctl daemon-reload
sudo systemctl start /dev/zram0
```

以启动 zram

在终端中输入 `zramctl`，若能够输出 `NAME ALGORITHM DISKSIZE DATA COMPR TOTAL STREAMS MOUNTPOINT` 等信息，说明启动成功

### **重新开启 Secure Boot（未测试）**

如果想在开启 Secure Boot 的情况下登录进 Manjaro Linux，可以使用经过微软签名的 PreLoader 或者 shim，然后在 UEFI 设置中将 Secure Boot 级别设置为 Microsoft & 3rd Party CA

具体教程参考以下网址：

[Secure Boot -- ArchWiki](https://wiki.archlinux.org/title/Unified_Extensible_Firmware_Interface/Secure_Boot#Microsoft_Windows)

## **一些有用的命令总结**

### **获取设备信息**

#### **简要信息**

在终端中输入：

```bash
neofetch
```

或者：

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

在终端中输入：

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

### **grep 查找命令**

grep 命令的用法为在文件或命令输出中查找字符串，例如：

```bash
grep (pattern) (file_pattern)
```

即为在当前目录文件名符合 `file_pattern` 的文件中查找字符串 `pattern`

又例如：

```bash
pamac list | grep (pattern)
```

可以查询已安装的软件包中名字含有 `pattern` 的软件包

### **批量更改文件名**

可以用 Linux 自带的 `rename` 命令：

```bash
rename  -- "(old_name)" "(new_name)" (files)
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
sed -i -e "s/\t/    /g" ./*
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

桌面壁纸可以在 [pling.com](https://www.pling.com/) 下载，专门为 Manjaro 定制的壁纸可以在这里找到：

[Wallpapers Manjaro -- pling.com](https://www.pling.com/browse/cat/309/order/latest/)

KDE Plasma 每个版本的壁纸可以在这里找到：

[Plasma Workspace Wallpapers -- KDE](https://github.com/KDE/plasma-workspace-wallpapers)

默认的壁纸保存位置为 `/usr/share/wallpapers/`

还可以使用包管理器（pacman/yay/pamac）下载壁纸，用“添加/删除软件”或 `pamac search wallpaper` 查找

右键点击桌面得到桌面菜单，点击“配置桌面和壁纸”即可选择想要的壁纸，位置建议选择“缩放并裁剪”

### **添加用户图标**

系统设置 >> 用户账户 >> 图像

### **登录屏幕（SDDM）美化**

开机与关机 >> 登录屏幕（SDDM） >> Breath（默认）、Breeze、Fluent

外观 >> 欢迎屏幕 >> Breath（默认）、Snowy Night Miku、Manjaro Linux Reflection Splashscreen、ManjaroLogo Black、Plasma 5 Manjaro Splashscreen White Blur

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

**不想使用 Mac 风格主题但又想使用浅色主题时，建议使用 Manjaro 新官方主题 Breath Light（也有深浅搭配和深色主题可选）或 KDE 官方主题 Breeze，并将终端（Konsole 和 Yakuake）主题改为“白底黑字”，背景透明度选择 20%**

### **配置桌面小部件（可选）**

右键点击桌面 >> 添加部件 >> 获取新部件 >> 下载新 Plasma 部件

在这里可以下载桌面小部件，并在“添加部件”处添加

### **bash 配置**

`ble.sh` 是一个使用纯 bash 编写的软件，可以提供代码高亮、自动补全等功能，可以在 AUR 中下载：

```bash
pamac install blesh
```

或者开发者版本：

```bash
pamac install blesh-git
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

### **zsh 配置**

Manjaro 已经做好了 zsh 的美化，一般直接使用即可

pkgfile 依赖于 manjaro-zsh-config，如果遇到开关机的时候报错：`[FAILED] failed to start pkgfile database update`，需要在 `/usr/lib/systemd/system/pkgfile-update.timer` 的 `Timer` 一段中加入：

```
RandomizedDelaySec=60
```

其中 60 可以改为任何足够长的秒数

#### **Oh-My-Zsh 手动配置（可选）**

如果想要自定义 zsh 样式，可以卸载 zsh 及其依赖：

```bash
sudo pacman -Rn zsh zsh-autosuggestions zsh-completions zsh-history-substring-search zsh-syntax-highlighting zsh-theme-powerlevel10k manjaro-zsh-config
```

再重新安装 zsh：

```bash
sudo pacman -S zsh
```

手动安装 Oh-My-Zsh，执行：（不推荐用包管理器安装）

```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
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

### **bash 配置（可选）**

Manjaro 的 Konsole 默认是 zsh，改成 bash 需要如下设置：

Konsole >> 设置 >> 编辑当前方案 >> 常规 >> 命令 >> `usr/bin/bash`

bash 的配置文件在 `~/.bashrc`，默认提示符变量 PS1 可以设置为如下内容，可以显示用户名、主机名、时间、Git 仓库分支、是否为超级用户，并显示颜色高亮：

```bash
export PS1="\[\033[38;5;39m\]\$(git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/')\[$(tput sgr0)\][\[$(tput sgr0)\]\[\033[38;5;196m\]\u\[$(tput sgr0)\] @ \[$(tput sgr0)\]\[\033[38;5;40m\]\h\[$(tput sgr0)\] \[$(tput sgr0)\]\[\033[38;5;208m\]\W\[$(tput sgr0)\]] (\t)\n\[$(tput sgr0)\]\[$(tput bold)\]\[\033[38;5;196m\]\\$\[$(tput sgr0)\] \[$(tput sgr0)\]"
```

说明文档参见以下网站：

[Controlling the Prompt -- Bash Manual]https://www.gnu.org/savannah-checkouts/gnu/bash/manual/bash.html#Controlling-the-Prompt

更多的 PS1 内容和颜色设置可以在这个网站进行自定义：

[.bashrc PS1 generator](https://bashrcgenerator.com/)

### **GRUB 美化**

选择主题 grub2-themes ，下载地址如下：

https://github.com/vinceliuice/grub2-themes

可选的主题有：Tela/Vimix/Stylish/Slaze/Whitesur

以 Tela grub theme （2K，黑白图标） 为例，解压后在文件夹内执行：

```bash
sudo ./install.sh -b -t tela -i white -s 2k
```

删除多余启动条目，需要修改`/boot/grub/grub.cfg`

删除整一段 `submenu 'Advanced options for Manjaro Linux'`，删除整一段 `UEFI Firmware Settings`，并将 `Windows Boot Manager (on /dev/nvme0n1p1)` 改为 `Windows`

恢复默认的`/boot/grub/grub.cfg`需要输入：

```bash
echo GRUB_DISABLE_OS_PROBER=false | sudo tee -a /etc/default/grub && sudo update-grub
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

### **安装 KDE 的 Wayland 支持（不推荐）**

与 Xorg 相比，Wayland 对触屏的支持更佳，但某些应用在 Wayland 上会有兼容性问题，目前 KDE 对 Wayland 的支持处于能用但还不太完善的状态

```bash
sudo pacman -S plasma-wayland-session
```

安装后即可在登录界面选择 Wayland 会话

## **软件的下载与配置**

**能用包管理器的尽量用包管理器安装！**

以下命令中的 `pamac install` 也可以在“添加/删除软件”（即 pamac）中搜索安装，如果不是 AUR 仓库中的软件，也可以用 `sudo pacman -S` 安装

### **PGP 密钥崩溃**

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

```
sudo bash pacman_key.sh
```

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

### **语言包**

系统设置 >> 语言包 >> 右上角点击“已安装的软件包”安装语言包

### **Kate 插件下载**

下载 Kate 插件：

```bash
sudo pacman -S aspell hspell libvoikko
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

### **安装常用软件**

以下软件推荐直接使用包管理器安装

```bash
pamac install stellarium typora v2ray qv2ray-dev-git vlc thunderbird
```

**这里的 qv2ray-dev-git 一定要选择 Arch Linux CN CN 软件源的版本**

### **安装 TeX Live**

推荐从 ISO 安装 TeX Live

首先在[清华大学镜像](https://mirrors.tuna.tsinghua.edu.cn/CTAN/systems/texlive/Images/)或者[上海交大镜像](https://mirrors.sjtug.sjtu.edu.cn/ctan/systems/texlive/Images/)下载 TeX Live ISO，文件名为 `texlive.iso`（和 `texlive(year).iso`、`texlive(year)-(date).iso` 是一致的）

在 Dolphin 中右键点击 ISO 镜像文件挂载，或在终端中运行：

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

`TEXDIR` 建议选择 `/home/(user_name)/` 下的文件夹以方便查看和修改（注意这里的 `~/` 等于 `/root/`），TEXMFLOCAL 会随 TEXDIR 自动更改

CTAN 镜像源可以使用 TeX Live 管理器 tlmgr 更改，更改到清华大学镜像需要在命令行中执行：

```bash
sudo tlmgr option repository https://mirrors.tuna.tsinghua.edu.cn/CTAN/systems/texlive/tlnet
sudo tlmgr --repository http://www.texlive.info/tlgpg/ install tlgpg
```

#### **使用图形界面安装**

首先要检查是否安装 tcl 和 tk：

```bash
pamac install tcl tk
```

进入镜像文件夹，运行：

```bash
sudo perl install-tl -gui
```

即可在图形界面下载 TeX Live，高级设置需要点击左下角的 Advanced 按钮

**记住勾选 Create symlinks in standard directories 一项（自动添加到 PATH），Specify directories 选择默认文件夹即可，之后不需要自己添加 PATH**

可以运行 `tex --version` 检查是否安装成功，若成功应显示 TeX 的版本号、TeX Live 的版本号和版权信息

还可以运行 `tlmgr --version` 和 `texdoc (package_name)` （选择常见的宏包名称如 `texdoc ctex`）检查是否安装成功

### **TeXstudio 安装与配置（可选）**

安装 TeXstudio：

```bash
pamac install texstudio
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

Manjaro 预装了 Python，但没有安装包管理器，可以使用 `pip` 或 `conda`（即安装 Miniconda）

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

外观 >> 语法高亮主题 >> IDLE

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
pamac install code
```

微软官方的二进制包（包含部分私有的组件），同样可以用 `code` 命令打开（如果不介意私有组件而且不习惯 Code - OSS 的图标，个人推荐首选此项）：

```bash
pamac install visual-studio-code-bin
```

内测版本：

```bash
pamac install visual-studio-code-insiders
```

第三方发布的从开源代码构建的二进制包：

```bash
pamac install vscodium-bin
```

从最新的开源代码构建：

```bash
pamac install code-git
```

下载扩展：Python（会自动下载 Pylance、Jupyter 等扩展），LaTeX Workshop，C/C++，Rainbow Brackets，Prettier - Code formatter，Markdown all in One

扩展保存在 `~/.vscode/extensions/` 文件夹内

#### **Visual Studio Code 设置**

若要更改全局设置，设置文件在 `~/.config/Code/User/settings.json`，可以在 Visual Studio Code 中按 `Ctrl+,` 开启设置

若要更改全局快捷键，设置文件在 `~/.config/Code/User/keybindings.json`，可以在 Visual Studio Code 中按 `Ctrl+K Ctrl+S` 开启设置

#### **Visual Studio Code 无法识别 Git 存储库**

如果 Visual Studio Code 无法识别文件夹内的 Git 存储库（显示“当前打开的文件夹中没有 Git 存储库”），是因为 Git 认为该文件夹不安全，需要对该文件夹执行：

```
git config --global --add safe.directory (directory_path)
```

`(directory_path)` 不能用 `./` 或 `../`，最好用绝对路径

文件夹安全性状态可以通过 `git status` 查看

如果要完全跳过检查，执行：

```
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

#### **Rainbow Brackets 插件设置**

更改 Rainbow Brackets 的括号配色可以修改文件 `~/.vscode/extensions/2gua.rainbow-brackets-0.0.6/out/src/extension.js`：

```js
var roundBracketsColor = ["#ff5500", "#cc0066", "#00aa66", "#ff9999"];
var squareBracketsColor = ["#33ccff", "#8080ff", "#0077aa"];
var squigglyBracketsColor = ["#aa00aa", "#009900", "#996600"];
```

重启 Visual Studio Code 即可生效

#### **Markdown 插件设置**

Visual Studio Code 自带 Markdown 预览功能，但是不支持数学命令的补全，也不支持复选框：

```markdown
- [x] item 1
- [ ] item 2
```

[Markdown all in one](https://github.com/yzhang-gh/vscode-markdown) 对数学公式补全支持较好，也支持复选框，缺点是不支持自动补全配对括号（在设置中将所有语言的括号自动配对打开即可），且部分数学公式环境无法渲染（可以在设置中将该插件的公式支持关闭），即在 `setting.json` 中设置为：

```json
"editor.autoClosingBrackets": "always",
"markdown.extension.math.enabled": false,
```

而 Markdown 预览支持最好的插件是 [Markdown Preview Enhanced](https://github.com/shd101wyy/markdown-preview-enhanced)，使用时可以选择插件预览或默认预览

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
pamac install ds9-bin
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
pip install pyraf==2.2.0
```

**在使用 IRAF/PyRAF 之前，需要在该文件夹运行 `mkiraf` 命令，才能使用**

#### **从 AstroConda 安装**

从 AstroConda 安装 IRAF/PyRAF 较为简便，缺点是软件版本较旧，且依赖 Python 2.7

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

### **微信安装**

微信官方原生桌面版（原生适配高分辨率屏幕，不需要 wine/deepin-wine 即可运行；但是功能较少，不支持截屏和“订阅号消息”，显示 emoji 需要下载 `noto-fonts-emoji`）：

```bash
pamac install com.tencent.weixin
```

功能较多，和最新的 Windows 电脑版同步更新，但依赖 deepin-wine，且暂不支持“截屏时隐藏当前窗口”的版本：

```bash
pamac install deepin-wine-wechat
```

#### **deepin-wine-wechat 高分辨率适配调整**

用命令 `/opt/apps/com.qq.weixin.deepin/files/run.sh winecfg` 调出 Wine Configuration，对于 200% 的放大率：

Graphics >> Screen Resolution >> 192 dpi

其余基于 Deepin Wine 的软件（如腾讯会议 `com.tencent.deepin.meeting`）也是类似的处理方法，将 `com.qq.weixin.deepin` 换成对应的文件夹名称即可（都在 `/opt/apps/` 目录下）

### **会议软件安装**

#### **腾讯会议**

推荐安装官方原生的腾讯会议 Linux 版：

```bash
pamac install wemeet-bin
```

也有基于 Deepin Wine 的版本可供选择：

```bash
pamac install com.tencent.deepin.meeting
```

#### **钉钉**

```bash
pamac install dingtalk-bin
```

高分辨率可以点击头像 >> 设置 >> 全局缩放，选择 150%

#### **Zoom**

```bash
pamac install zoom
```

#### **Microsoft Teams**

```bash
pamac install teams
```

#### **Slack**

```bash
pamac install slack-desktop
```

### **音乐软件安装**

#### **网易云音乐**

```bash
pamac install netease-cloud-music
```

#### **QQ 音乐**

```bash
pamac install qqmusic-bin
```

默认是暗色主题，右上角皮肤键（衣服图案）可以更改为亮色主题

### **Geant4 安装**

#### **从源代码安装 Geant4**

从官网上下载源代码压缩包：

[Geant4 -- Download](https://geant4.web.cern.ch/support/download)

进入解压后的文件夹，若要将 Geant4 安装在 `(Geant4_directory)`，例如 `~/Geant4`，执行：

```bash
mkdir build
cd ./build
cmake -DCMAKE_INSTALL_PREFIX=(Geant4_directory) -DGEANT4_USE_OPENGL_X11=ON -DGEANT4_USE_QT=ON -DGEANT4_INSTALL_DATA=ON -DGEANT4_BUILD_MULTITHREADED=ON ..
make -j8
make install -j8
```

之后在 `~/.bashrc` 中添加一行：

```bash
source (Geant4_directory)/bin/geant4.sh
```

#### **检验是否安装成功**

打开 `(Geant4_directory)/share/Geant4-(version_number)/examples/basic/B1`，执行：

```bash
mkdir build
cd ./build
cmake ..
make -j8
./exampleB1
```

如果出现图形交互界面，说明安装成功

### **应用程序的快捷键配置（可选）**

应用程序的快捷键配置在：

系统设置 >> 快捷键

若没有想要的应用程序，可以点击下方的“添加应用程序”，例如设置 `Meta+Return`（即“Windows 徽标键 + Enter 键”）为启动 Konsole 的快捷键：

系统设置 >> 快捷键 >> 添加应用程序 >> Konsole >> Konsole 的快捷键设为 `Meta+Return`

### **GitHub Desktop 安装（可选）**

推荐选择二进制包 `github-desktop-bin`：

```bash
pamac install github-desktop-bin
```

登录时要创建一个密钥环，密钥设为 GitHub 密码即可

### **办公软件安装（可选）**

WPS 安装：

```bash
pamac install wps-office-cn wps-office-mui-zh-cn ttf-wps-fonts
```

LibreOffice 安装：

```
pamac install libreoffice-fresh
```

### **百度网盘安装（可选）**

```bash
pamac install baidunetdisk-bin
```

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

### **用 debtap 安装 `.deb` 包（不推荐）**

首先要下载并更新 debtap 包：

```bash
pamac install debtap
sudo debtap -u
```

**运行 `sudo debtap -u` 时建议连接北京大学校园网**

进入含有 `.deb` 安装包的文件夹，输入：

```bash
sudo debtap (package_name).deb
```

系统会询问三个问题：文件名随便写，协议写软件包所用的协议，编辑文件可以直接按 `Enter` 跳过

此处会生成一个 `tar.zst` 包，双击打开（右键用“软件安装程序”打开）即可安装

## **参考资料**

[BitLocker 恢复密钥](https://account.microsoft.com/devices/recoverykey)

[Windows 10 如何关闭快速启动](https://jingyan.baidu.com/article/ca00d56c7a40e6e99febcf4f.html)

[创建和使用 Surface 的 USB 恢复驱动器](https://support.microsoft.com/zh-cn/help/4023512/surface-creating-and-using-a-usb-recovery-drive)

[下载 Surface 的恢复映像](https://support.microsoft.com/zh-cn/surfacerecoveryimage)

[下载 Windows 10 光盘映像](https://www.microsoft.com/zh-cn/software-download/windows10ISO)

[如何使用 Surface UEFI](https://support.microsoft.com/zh-cn/help/4023531/surface-how-to-use-surface-uefi)

[Win 10 环境下安装 Manjaro KDE（双系统）](https://www.cnblogs.com/Jaywhen-xiang/p/11561661.html)

[Manjaro 20 KDE 配置心得](https://blog.csdn.net/weixin_40293491/article/details/107526553)

[Manjaro 安装体验小结](https://zhuanlan.zhihu.com/p/76608451)

[Manjaro 安装后你需要这样做](https://www.cnblogs.com/haohao77/p/9034499.html)

[YouTube -- Building your custom Manjaro ISO via Github Actions CI](https://www.youtube.com/watch?v=S2t5Iat37CI)

[Manjaro Wiki -- Pacman Overview](https://wiki.manjaro.org/title/Pacman_Overview)

[ArchWiki -- Pacman](https://wiki.archlinux.org/title/Pacman)

[Manjaro Wiki -- Pamac](https://wiki.manjaro.org/title/Pamac)

[yay -- GitHub](https://github.com/Jguer/yay)

[Manjaro Wiki -- Manjaro Hardware Detection Overview](https://wiki.manjaro.org/title/Manjaro_Hardware_Detection_Overview)

[Manjaro Wiki -- Configure Graphics Cards](https://wiki.manjaro.org/title/Configure_Graphics_Cards)

[Manjaro Wiki -- Manjaro Kernels](https://wiki.manjaro.org/title/Manjaro_Kernels)

[ArchWiki -- Sudo](https://wiki.archlinux.org/title/Sudo)

[Manjaro Wiki -- Switching Branches](https://wiki.manjaro.org/title/Switching_Branches)

[在 Mac 上用 Openconnect 连接 Pulse Secure VPN](https://blog.yangl1996.com/post/use-openconnect-to-connect-to-pulse-secure-on-mac/)

[mount -- Arch manual pages](https://man.archlinux.org/man/mount.8)

[双系统下 Ubuntu 读写/挂载 Windows 中的硬盘文件 + 解决文件系统突然变成只读](https://jakting.com/archives/ubuntu-rw-windows-files.html)

[HelloGitHub -- hosts](https://raw.hellogithub.com/hosts)

[Manjaro Linux Forum -- Connect to internet from command-line as a beginner](https://forum.manjaro.org/t/howto-connect-to-internet-from-command-line-as-a-beginner/)

[Manjaro Linux Forum -- Failed to add/activate new connection: 确定 AP 安全信息失败](https://forum.manjaro.org/t/failed-to-add-activate-new-connection-ap/76048)

[Arch Wiki -- XDG user directories](https://wiki.archlinux.org/title/XDG_user_directories)

[Arch Wiki -- Intel Graphics](https://wiki.archlinux.org/title/Intel_graphics)

[Arch Wiki -- Baloo](https://wiki.archlinux.org/title/Baloo)

[Arch Wiki -- Bluetooth Mouse](https://wiki.archlinux.org/title/Bluetooth_mouse)

[Linux-Surface -- Installation and Setup](https://github.com/linux-surface/linux-surface/wiki/Installation-and-Setup)

[Arch Wiki -- System time](https://wiki.archlinux.org/title/System_time)

[Manjaro Linux Forum -- Cannot install manjaro-pipewire](https://forum.manjaro.org/t/cannot-install-manjaro-pipewire/102776)

[KDE 桌面的 Mac 化](https://www.cnblogs.com/luoshuitianyi/p/10587788.html)

[KDE 桌面美化指南](https://acherstyx.github.io/2020/06/30/KDE%E6%A1%8C%E9%9D%A2%E7%BE%8E%E5%8C%96%E6%8C%87%E5%8D%97/)

[Oh-My-Zsh 及主题、插件的安装与配置](https://www.cnblogs.com/misfit/p/10694397.html)

[Linux GRUB 删除多余启动条目](https://blog.csdn.net/JackLiu16/article/details/80383969)

[TUNA NTP（网络授时）服务使用说明](https://tuna.moe/help/ntp/)

[Manjaro 为包管理器 pacman 和 yaourt/yay 添加多线程下载](https://blog.csdn.net/dc90000/article/details/101752743)

[ArchWiki -- Fonts](https://wiki.archlinux.org/title/Fonts)

[Arch Linux 使用 Windows 字体及相关配置](https://blog.csdn.net/sinat_33528967/article/details/93380729)

[ArchWiki -- Fcitx5](https://wiki.archlinux.org/title/Fcitx5)

[Archived Manjaro Forum -- 比较几种中文输入法后，我最终选择了 sunpinyin + cloudpinyin 组合](https://archived.forum.manjaro.org/t/sunpinyin-cloudpinyin/114282)

[TeX Live -- Acquiring TeX Live as an ISO image](https://www.tug.org/texlive/acquire-iso.html)

[TeX Live -- Quick install](https://www.tug.org/texlive/quickinstall.html)

[TeX Live Documentation -- TeX Live Installation](https://www.tug.org/texlive/doc/texlive-en/texlive-en.html)

[Mozilla Support -- Font size of mailbox is too small](https://support.mozilla.org/zh-CN/questions/1297871)

[Anaconda Documentation -- Installing on Linux](https://docs.anaconda.com/anaconda/install/linux/)

[恢复 Anaconda 环境，卸载 Anaconda，重装 Anaconda](https://blog.csdn.net/wangweiwells/article/details/88374361)

[Geant4 -- Building and Installing from Source](https://geant4-userdoc.web.cern.ch/UsersGuides/InstallationGuide/html/installguide.html)

[Geant4 -- Postinstall Setup](https://geant4-userdoc.web.cern.ch/UsersGuides/InstallationGuide/html/postinstall.html)

[Geant4 基础 -- 准备与安装](https://zhuanlan.zhihu.com/p/135917392)

[Linux ate my RAM!](https://www.linuxatemyram.com/)
