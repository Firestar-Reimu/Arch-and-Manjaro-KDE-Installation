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
在文件管理器中添加你要添加的文件
```bash
git add (file_path)/(file_name)  # 你要添加的文件
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
