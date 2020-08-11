<font face="JetBrains Mono NL">

# **在Surface Pro 6上安装Manjaro 20.0.3 Plasma + Windows 10双系统的指南**

## **Windows的准备工作**

### **关闭Bitlocker**

开始菜单-->设置-->更新和安全-->设备加密-->关闭

### **进入UEFI模式**

关闭 Surface，然后等待大约 10 秒钟以确保其处于关闭状态。

长按 Surface 上的调高音量按钮，同时按下再松开电源按钮。
    
屏幕上会显示 Microsoft 或 Surface 徽标。继续按住调高音量按钮。显示 UEFI 屏幕后，松开此按钮。

Security-->Secure Boot-->Disabled(第三个选项)

### **制作启动盘**

在清华大学镜像中下载Manjaro镜像，网址如下：

https://mirrors.tuna.tsinghua.edu.cn/osdn/storage/g/m/ma/manjaro/

下载Rufus（当前版本是3.11），刻录启动盘。启动盘用移动硬盘会无法被识别，直接选中镜像点确定即可。（现在已经没有ISO/DD选项）

设置->恢复->立即重新启动->从USB启动


|     大小     | 文件系统  | 挂载点 | 标记  |
| :----------: | :-------: | :----: | :---: |
|  8192M (8G)  | linuxswap |        | swap  |
|     512M     |   ext4    | /boot  | boot  |
| 40960M (40G) |   ext4    |   /    | root  |
|   the rest   |   ext4    | /home  |       |

/root建议40G起步

## **初始配置**

换源：

    sudo pacman-mirrors -i -c China -m rank

建议用上海交大和阿里云的镜像

    sudo pacman -Syyu


## **美化**

**一定要先美化再装软件！**

屏幕是2736*1824，需要配置高分屏优化

字体大小14pt，固定DPI=144

分辨率-->全局缩放-->125%

**不要用全局主题！**

#### **解决pamac图标太小的问题**

    yay -S gtk3-nocsd
    kate ~/.xsession

这是一个空文件，添加下面两行：

    export GTK_CSD=0

    export LD_PRELOAD=<"full path" of your libgtk3-nocsd.so.0 file>

然后保存重启

#### **Konsole快捷键与密码显示星号**

右上角$\boxed{\cdot\cdot\cdot}$-->配置键盘快捷键-->复制改为Ctrl+C，粘贴改为Ctrl+V

让密码显示星号的方法，首先输入：

	sudo visudo

在最后一行加入

	Defaults env_reset, pwfeedback

输入 ```:wq``` 保存并退出

#### **Dolphin图标大小和快捷键**

右上角$\boxed{\cdot\cdot\cdot}$-->配置Dolphin-->视图模式-->图标大小都设为96-->标签宽度设为大

右上角$\boxed{\cdot\cdot\cdot}$-->配置键盘快捷键-->移至回收站改为Ctrl+D，删除改为Del

#### **Firefox缩放比例**

首选项-->默认缩放为150%

about:config-->layout.css.devPixelsPerPx-->改为1.5

### **语言包**

系统设置-->语言包-->右上角安装语言包

### **安装微软字体**

.ttf和.otf字体右键-->动作-->安装-->安装到系统字体
.ttc字体安装方法如下：

    sudo mkdir /usr/share/fonts/winfonts
    sudo cp (win-font-path)/* /usr/share/fonts/winfonts/
    cd /usr/share/fonts/winfonts/
    sudo mkfontscale
    sudo mkfontdir
    fc-cache -fv

这样就可以安装微软雅黑、宋体、黑体等字体了。

#### **更改程序和bash默认中文字体为微软雅黑**

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

### **安装sunpinyin+cloudpinyin**

安装

    sudo pacman -S fcitx-im fcitx-configtool fcitx-cloudpinyin fcitx-sunpinyin manjaro-asian-input-support-fcitx

配置文件
在 ```/etc/profile``` 或者 ```~/.xprofile``` 文件中添加：

    export GTK_IM_MODULE=fcitx
    export QT_IM_MODULE=fcitx
    export XMODIFIERS=@im=fcitx

Fcitx配置-->附加组件-->云拼音-->下方的“配置”-->云拼音来源改为“百度”

### **双系统时间不同步+24小时制**

双系统时间不同步

|                   Windows                    |                     Manjaro                      |
| :------------------------------------------: | :----------------------------------------------: |
| 时钟点右键-->调整日期/时间-->自动设置时间 | 时钟点右键-->调整日期和时间-->自动设置日期和时间 |

Manjaro设置24小时制：

时钟点右键-->配置数字时钟-->时间显示-->24小时制

### **Linux挂载Windows磁盘**

**首先要确保Bitlocker已经关闭**

这里以D盘为例，分区是 ```/dev/nvme0n1p4``` ，可以在KDE分区管理器里面找到。

    sudo mkdir /mnt/windows/d
    sudo blkid /dev/nvme0n1p4

在输出结果中可以发现一段 ```UUID="XXXXXXXXXXXXXXXX"``` 的内容，右键选中复制下来。

接着就来修改系统文件

    kate /etc/fstab

在最后加入这两句

    UUID=8494B8C594B8BACE                     /mnt/windows/C ntfs    defaults,noatime 0 2
    UUID=4E86792F867918A3                     /mnt/windows/D ntfs    defaults,noatime 0 2

接着我们需要检查一下，执行：

    sudo mount -a

如果什么都没有输出，那就成功了

#### **如果文件系统突然变成只读**

一般来讲是在Windows进行了优化磁盘等操作导致的。

检查占用进程：

    sudo fuser -m -u /dev/sdb2

可以看到数字，就是占用目录的进程PID，杀掉：

    sudo kill (PID number)

取消挂载：

    sudo umount /dev/nvme0n1p4

重新挂载：

    sudo mount /dev/nvme0n1p4 /mnt/windows/d

中途如果出现了前面的报错The disk contains an unclean file system，就跟前面一样执行一次：

    sudo ntfsfix /dev/nvme0n1p4

重启即可

### **连接北京大学VPN**

sudo openconnect --user (10位学号) https://vpn.pku.edu.cn --juniper

### **AUR软件源**

添加/删除软件-->右上角“ $\boxed{\cdot\cdot\cdot}$ ”-->首选项-->AUR-->启用AUR支持

	sudo pacman -S yay
	sudo pacman -S archlinuxcn-keyring

执行以下命令修改 aururl 以启用清华源:

yay --aururl "https://aur.tuna.tsinghua.edu.cn" --save

修改的配置文件位于 ~/.config/yay/config.json ，还可通过以下命令查看修改过的配置：

yay -P -g

## **下载软件**

以下 ```yay -S``` 也可以用 ```sudo pacman -S``` 代替，或者在“添加/删除软件”中搜索安装

	yay -S wps-office-cn wps-office-mui-zh-cn ttf-wps-fonts
	yay -S electron-netease-cloud-music
	yay -S nautilus
	yay -S texlive-most texlive-lang
	yay -S texstudio
	yay -S stellarium
	yay -S geogebra
	yay -S visual-studio-code-bin
	yay -S evolution

**以后用 ```sudo nautilus``` 就可以访问没有权限的文件**

Evolution用于替代Thunderbird

### **Anaconda配置**
	yay -S anaconda
	source ~/.zshrc

### **Visual Studio Code图标更改**

Visual Studio Code图标变成圆形，想恢复原图标

程序启动器-->编辑应用程序-->Visual Studio Code-->点击图标更改-->其他图标

### **清理缓存**

清理全部软件安装包

    sudo pacman -Scc

清理无用的孤立软件包

    sudo pacman -Rsn $(pacman -Qdtq)

## **参考资料**

BitLocker 恢复密钥
https://account.microsoft.com/devices/recoverykey?refd=account.microsoft.com

Win10如何关闭设备加密？关闭BitLocker加密图文教程
http://www.w10zj.com/Win10xy/Win10yh_8892.html

创建和使用 Surface 的 USB 恢复驱动器
https://support.microsoft.com/zh-cn/help/4023512/surface-creating-and-using-a-usb-recovery-drive

如何使用 Surface UEFI
https://support.microsoft.com/zh-cn/help/4023531/surface-how-to-use-surface-uefi

Win10环境下安装Manjaro KDE（双系统） 
https://www.cnblogs.com/Jaywhen-xiang/p/11561661.html

Manjaro 20 KDE配置心得：
https://blog.csdn.net/weixin_40293491/article/details/107526553

Manjaro安装后你需要这样做
https://www.cnblogs.com/haohao77/p/9034499.html#11-%E9%85%8D%E7%BD%AE%E5%AE%98%E6%96%B9%E6%BA%90

比较几种中文输入法后，我最终选择了sunpinyin + cloudpinyin组合
https://forum.manjaro.org/t/sunpinyin-cloudpinyin/114282

AUR 镜像使用帮助
https://mirrors.tuna.tsinghua.edu.cn/help/AUR/

SJTUG 软件源镜像服务
https://mirrors.sjtug.sjtu.edu.cn/#/

Manjaro为包管理器pacman和yaourt\yay 添加多线程下载
https://blog.csdn.net/dc90000/article/details/101752743?utm_medium=distribute.wap_relevant.none-task-blog-OPENSEARCH-6.nonecase&depth_1-utm_source=distribute.wap_relevant.none-task-blog-OPENSEARCH-6.nonecase

ArchWiki -- Microsoft fonts (简体中文)
https://wiki.archlinux.org/index.php/Microsoft_fonts_(%E7%AE%80%E4%BD%93%E4%B8%AD%E6%96%87)

Archlinux使用Windows字体及相关配置
https://blog.csdn.net/sinat_33528967/article/details/93380729

Kde桌面的Mac化
https://www.cnblogs.com/luoshuitianyi/p/10587788.html

gtk3-nocsd, 禁用 GTK 客户端侧面装饰的hack
https://www.kutu66.com/GitHub/article_117125

Oh-My-Zsh及主题、插件的安装与配置
https://www.cnblogs.com/misfit/p/10694397.html

ArchWiki -- pacman (简体中文)
https://wiki.archlinux.org/index.php/Pacman_(%E7%AE%80%E4%BD%93%E4%B8%AD%E6%96%87)

双系统下 Ubuntu 读写/挂载 Windows 中的硬盘文件 + 解决文件系统突然变成只读
https://jakting.com/archives/ubuntu-rw-windows-files.html

Linux grub引导界面（启动界面）美化
https://zhuanlan.zhihu.com/p/94331255

Linux grub删除多余启动条目
https://blog.csdn.net/JackLiu16/article/details/80383969
</font>
