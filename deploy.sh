#!/bin/bash

echo -e "\033[0;32mDeploying updates to GitHub...\033[0m"

echo "切到source分支，测试源文件"

git branch -m master source

echo "将本地博客的源码推送到GitHub仓库的source分支"
git add --all
git commit -m "Initial commit"
git push -u origin source

# Build the project.
echo "生成静态网站内容"
hugo

# Go To Public folder
cd public
# Add changes to git.
git add .

# Commit changes.
msg="rebuilding site `date`"
if [ $# -eq 1 ]
  then msg="$1"
fi
git commit -m "$msg"

# Push source and build repos.
git push origin master

# Come Back up to the Project Root
cd ..
echo "发布完毕"