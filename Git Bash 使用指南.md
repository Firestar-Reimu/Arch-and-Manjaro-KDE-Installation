# 配置用户名、邮箱及免密码设置
```bash
git config --global user.name "(user_name)"
git config --global user.email "(user_email)"       
kate .git-credentials
```
写入如下语句：

    https://(user_name):(user_password)@github.com

保存退出
```bash
git config --global credential.helper store
```

# 添加文件
```bash
cd (parent_folder_path)
git clone (repository_URL)  # repository 的网址，例如 https://github.com/1900011604/(my_repository).git
cd (repository_folder_path)
```
在文件管理器中添加文件
```bash
git add (file_path)/(file_name)  # 需要添加的文件
git commit -m 'add (file_name)'
git push -u origin (branch_name)  # branch_name 默认写 master
```

# 删除与恢复文件
```bash
cd (parent_folder_path)
git clone (repository_URL)  # repository 的网址，例如 https://github.com/1900011604/(my_repository).git
cd (repository_folder_path)
```
在文件管理器中删除你要添加的文件
```bash
git rm -f (file_name)  # 你要删除的文件
git commit -m 'delete (file_name)'
git push -u origin (branch_name)  # branch_name 默认写 master
```
恢复文件
```bash
git ls-files -d | xargs echo -e | xargs git checkout --
```
回退到上一个版本，只回退了commit的信息
```bash
git reset --soft^
```
回退到上一个版本，只保留源码，回退 commit 和 index 信息（默认方式）
```bash
git reset --mixed^
```
回退到 n 次提交之前
```bash
git reset --soft~n
```
彻底回退到某个版本，本地的源码也会变为上一个版本的内容，撤销的 commit 中所包含的更改被删除
```bash
git reset --hard^
```
