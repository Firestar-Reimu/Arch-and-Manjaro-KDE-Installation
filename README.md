<font face="JetBrains Mono">

# **在Surface Pro 6上安装Manjaro 20.0.3 KDE Plasma + Windows 10双系统的指南**

```
OS: Manjaro 20.0.3 Lysia

Kernel: x86_64 Linux 5.7.9-1-MANJARO

Shell: zsh 5.8

Resolution: 2736x1824

DE: KDE 5.72.0 / Plasma 5.19.3

WM: KWin

GTK Theme: Mojave-light-alt [GTK2/3]

Icon Theme: Mojave-CT-Light

CPU: Intel Core i5-8250U @ 8x 3.4GHz

GPU: Mesa Intel(R) UHD Graphics 620 (KBL GT2)
```

## **Windows的准备工作**

### **关闭快速启动**

控制面板 --> 电源选项 --> 选择电源按钮的功能 --> 更改当前不可用的设置 --> 保存修改

### **关闭Bitlocker**

开始菜单 --> 设置 --> 更新和安全 --> 设备加密 --> 关闭

### **进入UEFI模式**

关闭 Surface，然后等待大约 10 秒钟以确保其处于关闭状态 

长按 Surface 上的调高音量按钮，同时按下再松开电源按钮 
    
屏幕上会显示 Microsoft 或 Surface 徽标 继续按住调高音量按钮 显示 UEFI 屏幕后，松开此按钮 

Security --> Secure Boot --> Disabled(第三个选项)

### **制作启动盘**

在清华大学镜像中下载Manjaro镜像，网址如下：

https://mirrors.tuna.tsinghua.edu.cn/osdn/storage/g/m/ma/manjaro/

下载Rufus（当前版本是3.11），刻录启动盘（注意启动盘如果用移动硬盘会无法被识别），直接选中镜像点确定即可（现在已经没有ISO/DD选项）

### **安装Manjaro**

设置 --> 恢复 --> 立即重新启动 --> USB Storage

#### **分区设置**

|     大小     | 文件系统  | 挂载点 | 标记  |
| :----------: | :-------: | :----: | :---: |
|  8192M (8G)  | linuxswap |        | swap  |
|     512M     |   ext4    | /boot  | boot  |
| 40960M (40G) |   ext4    |   /    | root  |
|   the rest   |   ext4    | /home  |       |

**如果空间足够，/root建议至少60G，因为几乎所有软件都要装在这里**

**系统安装时Office选择No Office Suite，在安装软件时再下载 WPS Office**

## **初始配置**

### **电源设置**

系统设置 --> 电源管理 --> 节能 --> 勾选“按键事件处理” --> 合上笔记本盖时 --> 选择“关闭屏幕” --> 勾选“即使已连接外部显示器”

#### **与电源管理相关的常见英文名词**

Suspend：挂起，Reboot：重启，Shutdown：关机，Logout：注销

### **sudo免密码**

首先在终端中输入：

	sudo visudo

在最后一行（空行）按 ```a``` 进入输入模式，加上这一行：

	Defaults:(user_name) !authenticate

按 ```Esc``` 进入命令模式，再按 ```:wq``` 保存，按 ```Enter``` 退出

### **官方软件源更改镜像**

    sudo pacman-mirrors -i -c China -m rank

建议用上海交大或阿里云的镜像，确认后输入：

    sudo pacman -Syyu

### **AUR软件源**

添加/删除软件 --> 右上角 ··· --> 首选项 --> AUR --> 启用AUR支持

	sudo pacman -S yay

执行以下命令以启用清华镜像:

	yay --aururl "https://aur.tuna.tsinghua.edu.cn" --save

修改的配置文件位于 ```~/.config/yay/config.json``` ，还可通过以下命令查看修改过的配置：

	yay -P -g

### **Arch Linux CN 软件源**

在 ```/etc/pacman.conf``` 文件末尾添加以下两行以启用上海交大镜像：

	[archlinuxcn]

	Server = https://mirrors.sjtug.sjtu.edu.cn/archlinux-cn/$arch

之后执行下面的命令安装archlinuxcn-keyring包导入GPG key

	sudo pacman -S archlinuxcn-keyring

### **双系统时间不同步+24小时制**

#### **双系统时间不同步**

|                    Windows                    |                       Manjaro                        |
| :-------------------------------------------: | :--------------------------------------------------: |
| 时钟点右键 --> 调整日期/时间 --> 自动设置时间 | 时钟点右键 --> 调整日期和时间 --> 自动设置日期和时间 |

#### **Manjaro设置24小时制**

时钟点右键 --> 配置数字时钟 --> 时间显示 --> 24小时制

### **自动连接Wifi**

确保KDE钱包开启即可，调整路径如下：

应用 --> 系统 --> KWalletManager

### **连接北京大学VPN**

按 ```Fn+F12``` 打开Yakuake，输入：

	sudo openconnect --user (student_ID) https://vpn.pku.edu.cn --juniper

之后点击窗口外任意位置或按 ```Fn+F12``` 让它收起，不要关闭窗口（关闭窗口则VPN断开）

### **Linux挂载Windows磁盘**

**首先要确保Bitlocker已经关闭**

**如果要挂载C盘请确保快速启动已经关闭**

这里以D盘为例，分区是 ```/dev/nvme0n1p4``` ，可以在KDE分区管理器里面找到 

    sudo mkdir /mnt/windows/D
    sudo blkid /dev/nvme0n1p4

在输出结果中可以发现一段 ```UUID="XXXXXXXXXXXXXXXX"``` 的内容，右键选中复制下来 

接着就来修改系统文件

    kate /etc/fstab

在最后加入这两句

    UUID=8494B8C594B8BACE                     /mnt/windows/C ntfs    defaults,noatime 0 2
    UUID=4E86792F867918A3                     /mnt/windows/D ntfs    defaults,noatime 0 2

接着我们需要检查一下，执行：

    sudo mount -a

如果什么都没有输出，那就成功了

#### **如果文件系统突然变成只读**

一般来讲是Windows进行了优化磁盘等操作导致的 

检查占用进程：

    sudo fuser -m -u /dev/sdb2

可以看到数字，就是占用目录的进程PID，终止进程：

    sudo kill (PID_number)

取消挂载：

    sudo umount /dev/nvme0n1p4

执行硬盘NTFS分区修复：

    sudo ntfsfix /dev/nvme0n1p4

再重新挂载即可：

	sudo mount /dev/nvme0n1p4 /mnt/windows/D

## **美化**

**一定要先美化再装软件！**

### **桌面美化**

屏幕分辨率是2736*1824，需要在“系统设置”中配置高分屏优化：

字体大小14pt，固定DPI=144

分辨率 --> 全局缩放 --> 125%

光标 --> 大小 --> 36

#### **解决“添加/删除软件”（即pamac）图标太小的问题**

    yay -S gtk3-nocsd
    kate ~/.xsession

这是一个空文件，添加下面两行：

    export GTK_CSD=0

    export LD_PRELOAD=<"full path" of your libgtk3-nocsd.so.0 file>

然后保存重启

#### **Firefox缩放比例**

首选项 --> 默认缩放为150%

```about:config```  -->  ```layout.css.devPixelsPerPx```  --> 改为1.5

#### **主题美化**

**不要用全局主题！**

参考以下网址：

Kde桌面的Mac化
https://www.cnblogs.com/luoshuitianyi/p/10587788.html

其中GTK主题和图标主题选择：

	GTK Theme: Mojave-light-alt [GTK2/3]
    Icon Theme: Mojave-CT-Light

Latte-Dock的推荐设置：

行为：位置 --> 底部，可见性 --> 自动隐藏，延迟 --> 显示 --> none

外观：绝对大小 --> 96，背景大小 --> 10%

#### **终端美化**

参考以下网址：

Oh-My-Zsh及主题、插件的安装与配置
https://www.cnblogs.com/misfit/p/10694397.html

#### **grub美化**

参考以下网址：

Linux grub引导界面（启动界面）美化
https://zhuanlan.zhihu.com/p/94331255

Linux grub删除多余启动条目
https://blog.csdn.net/JackLiu16/article/details/80383969

### **快捷键配置**

#### **Konsole快捷键**

右上角 ··· --> 配置键盘快捷键 --> 复制改为 ```Ctrl+C``` ，粘贴改为 ```Ctrl+V``` 

#### **Dolphin图标大小和快捷键**

右上角 ··· --> 配置Dolphin --> 视图模式 --> 图标大小都设为96 --> 标签宽度设为大

右上角 ··· --> 配置键盘快捷键 --> 移至回收站改为 ```Ctrl+D``` ，删除改为 ```Del```

## **下载软件**

### **语言包**

系统设置 --> 语言包 --> 右上角点击“已安装的软件包”安装语言包

### **安装微软字体**

.ttf和.otf字体：右键点击字体文件 --> 动作 --> 安装 --> 安装到系统字体

.ttc字体安装方法如下：

    sudo mkdir /usr/share/fonts/winfonts
    sudo cp (win-font-path)/* /usr/share/fonts/winfonts/
    cd /usr/share/fonts/winfonts/
    sudo mkfontscale
    sudo mkfontdir
    fc-cache -fv

这样就可以安装微软雅黑、宋体、黑体等字体了 

### **更改程序和终端默认中文字体为微软雅黑**

输入命令：

    kate /etc/fonts/conf.d/64-language-selector-prefer.conf

并加入以下内容：

```
<?xml version="1.0"?>
<!DOCTYPE fontconfig SYSTEM "fonts.dtd">
<fontconfig>
	<alias>
		<family>sans-serif</family>
		<prefer>
			<family>Microsoft YaHei UI</family>
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
			<family>SimSun</family>
			<family>Noto Sans CJK SC</family>
			<family>Noto Sans CJK TC</family>
			<family>Noto Sans CJK HK</family>
			<family>Noto Sans CJK JP</family>
			<family>Noto Sans CJK KR</family>
		</prefer>
	</alias>
	<alias>
		<family>monospace</family>
		<prefer>
			<family>JetBrains Mono NL</family>
			<family>JetBrains Mono</family>
			<family>Consolas</family>
			<family>Microsoft YaHei UI</family>
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

### **安装中文输入法**

安装输入法软件：

    sudo pacman -S fcitx-im fcitx-configtool fcitx-cloudpinyin fcitx-sunpinyin manjaro-asian-input-support-fcitx

配置文件：

在 ```/etc/profile``` 或者 ```~/.xprofile``` 文件中添加：

	export XIM=fcitx
	export XIM_PROGRAM=fcitx
	export GTK_IM_MODULE=fcitx
	export QT_IM_MODULE=fcitx
	export XMODIFIERS="@im=fcitx"

保存重启即可

Fcitx配置 --> 附加组件 --> 云拼音 --> 下方的“配置” --> 云拼音来源改为“百度”

### **安装其它软件**

以下命令中的 ```yay -S``` 也可以在“添加/删除软件”（即pamac）中搜索安装，部分也可用 ```sudo pacman -S``` 代替 

**推荐用 ```yay -S``` ，因为 ```sudo pacman -S``` 不一定能搜索到**

	yay -S wps-office-cn wps-office-mui-zh-cn ttf-wps-fonts
	yay -S electron-netease-cloud-music
	yay -S nautilus
	yay -S texlive-most texlive-lang
	yay -S texstudio
	yay -S stellarium
	yay -S geogebra

**以后用 ```sudo nautilus``` 就可以访问没有权限的文件**

### **Thunderbird安装与配置**

#### **Thunderbird安装与登录**

官方软件仓库的Thunderbird是版本68.11.0，要安装最新的版本78.1.1需要输入：

	yay -S thunderbird-bin

安装后设置邮箱登录，参数如下：

|   收件服务器    |   发件服务器    |
| :-------------: | :-------------: |
| imap.pku.edu.cn | smtp.pku.edu.cn |
|   端口号：143   |   端口号：25    |
| SSL端口号：993  | SSL端口号：465  |

#### **Thunderbird美化**

进入首选项界面调整显示：

Startpage清空并取消勾选

Default Search Engine改为Bing

System Intergration全部设为默认并取消勾选

Preferences --> General --> Fonts and Colors --> Advanced... --> Fonts for: --> Simplified Chinese/Latin/Other Writing Systems --> 字体大小（Proportional/Monospace/Minimum Font Size）全部改为16

Preferences --> General --> Fonts and Colors --> Advanced... --> 取消勾选Allow messages to use other fonts

Preferences --> General --> Config Editor（在最下方） --> layout.css.devPixelsPerPx --> 改为2.25

右键点击上方工具栏Mail Toolbar，选择Customize，自行配置即可

#### **Thunderbird帐号配置**

点击邮箱帐号，配置Account Settings如下：

Server Settings --> Server Settings --> Check for new messages every ```1``` minutes

Server Settings --> Server Settings --> When I delete a message --> Remove it immediately

Copies & Folders --> When sending messages, automatically --> 取消勾选Place a copy in

### **Git配置**

	git config --global user.name "1900011604"
	git config --global user.email "1900011604@pku.edu.cn"

### **Anaconda安装**

**运行 ```conda``` 时建议连接北京大学VPN**

默认安装：

	yay -S anaconda

自定义安装参考以下网址：

Anaconda Documentation -- Installing on Linux
https://docs.anaconda.com/anaconda/install/linux/

恢复之前的版本：

	conda list --revisions
	conda install --revision (revision_number)

注意：如果回滚到早期版本（revision_number较小）之后又想回到某个高版本（revision_number较大），必须要把两个版本中的版本都装一遍

打开Anaconda Navigator需要在终端中输入：

	anaconda-navigator

用Spyder打开某个文件需要在终端中输入：

	spyder (file_path)/(file_name)

### **Visual Studio Code安装与配置**

#### **Visual Studio Code安装**

下载最新版本的Visual Studio Code（以版本1.48.0为例）：

在官网选择 ```.deb``` 安装包，下载到文件夹，网址如下：

https://code.visualstudio.com/Download

首先要下载并更新debtap包：

	yay -S debtap
	sudo debtap -u

**运行 ```sudo debtap -u``` 时建议连接北京大学VPN**

进入含有 ```.deb``` 安装包的文件夹，输入：

	sudo debtap code_1.48.0-1597304990_amd64.deb

系统会询问三个问题：文件名随便写，协议写 ```GPL``` 即可，编辑文件直接按 ```Enter``` 跳过 

此处会生成一个 ```tar.zst``` 包，双击打开（右键用“软件安装程序”打开）即可安装 

#### **Visual Studio Code图标更改**

如果图标美化后Visual Studio Code图标变成圆形，想恢复原图标，更改路径如下：

程序启动器 --> 编辑应用程序 --> Visual Studio Code --> 点击图标更改 --> 其他图标

#### **Visual Studio Code缩放比例**

放大比例：```Ctrl+=```

缩小比例：```Ctrl+-```

### **清理缓存**

清理全部软件安装包

    yay -Scc

清理无用的孤立软件包

    yay -Rsn $(pacman -Qdtq)

## **参考资料**

BitLocker 恢复密钥
https://account.microsoft.com/devices/recoverykey?refd=account.microsoft.com

Windows 10如何关闭快速启动
https://jingyan.baidu.com/article/ca00d56c7a40e6e99febcf4f.html

Win 10如何关闭设备加密？关闭BitLocker加密图文教程
http://www.w10zj.com/Win10xy/Win10yh_8892.html

创建和使用 Surface 的 USB 恢复驱动器
https://support.microsoft.com/zh-cn/help/4023512/surface-creating-and-using-a-usb-recovery-drive

如何使用 Surface UEFI
https://support.microsoft.com/zh-cn/help/4023531/surface-how-to-use-surface-uefi

Win 10环境下安装Manjaro KDE（双系统） 
https://www.cnblogs.com/Jaywhen-xiang/p/11561661.html

Manjaro 20 KDE配置心得
https://blog.csdn.net/weixin_40293491/article/details/107526553

Manjaro 安装体验小结
https://zhuanlan.zhihu.com/p/76608451

Manjaro安装后你需要这样做
https://www.cnblogs.com/haohao77/p/9034499.html#11-%E9%85%8D%E7%BD%AE%E5%AE%98%E6%96%B9%E6%BA%90

ArchWiki -- Sudo (简体中文)
https://wiki.archlinux.org/index.php/Sudo_(%E7%AE%80%E4%BD%93%E4%B8%AD%E6%96%87)

在 Mac 上用 Openconnect 连接 Pulse Secure VPN
https://blog.yangl1996.com/post/use-openconnect-to-connect-to-pulse-secure-on-mac/

双系统下 Ubuntu 读写/挂载 Windows 中的硬盘文件 + 解决文件系统突然变成只读
https://jakting.com/archives/ubuntu-rw-windows-files.html

Kde桌面的Mac化
https://www.cnblogs.com/luoshuitianyi/p/10587788.html

Oh-My-Zsh及主题、插件的安装与配置
https://www.cnblogs.com/misfit/p/10694397.html

Linux grub引导界面（启动界面）美化
https://zhuanlan.zhihu.com/p/94331255

Linux grub删除多余启动条目
https://blog.csdn.net/JackLiu16/article/details/80383969

AUR 镜像使用帮助
https://mirrors.tuna.tsinghua.edu.cn/help/AUR/

SJTUG 软件源镜像服务
https://mirrors.sjtug.sjtu.edu.cn/#/

Manjaro为包管理器pacman和yaourt\yay添加多线程下载
https://blog.csdn.net/dc90000/article/details/101752743?utm_medium=distribute.wap_relevant.none-task-blog-OPENSEARCH-6.nonecase&depth_1-utm_source=distribute.wap_relevant.none-task-blog-OPENSEARCH-6.nonecase

ArchWiki -- Microsoft fonts (简体中文)
https://wiki.archlinux.org/index.php/Microsoft_fonts_(%E7%AE%80%E4%BD%93%E4%B8%AD%E6%96%87)

Archlinux使用Windows字体及相关配置
https://blog.csdn.net/sinat_33528967/article/details/93380729

比较几种中文输入法后，我最终选择了sunpinyin + cloudpinyin组合
https://forum.manjaro.org/t/sunpinyin-cloudpinyin/114282

ArchWiki -- pacman (简体中文)
https://wiki.archlinux.org/index.php/Pacman_(%E7%AE%80%E4%BD%93%E4%B8%AD%E6%96%87)

Font size of mailbox is too small
https://support.mozilla.org/zh-CN/questions/1297871

Anaconda Documentation -- Installing on Linux
https://docs.anaconda.com/anaconda/install/linux/

恢复anaconda环境, 卸载anaconda, 重装anaconda
https://blog.csdn.net/wangweiwells/article/details/88374361

Manjaro 安装 .deb 包
https://zhuanlan.zhihu.com/p/83335242

</font>
