# 简介
此库是博客的源码文件，上传到source分支

静态文件上传到master主分支


# 使用说明
### 新建一篇文章
hugo new post/first.md

### 启动hugo服务
# 本地启动服务：指定监听地址、端口，访问根路径和主题，包含草稿内容
#hugo server --bind 127.0.0.1 -p 1313 -b http://127.0.0.1:1313/ --buildDrafts -v
hugo server --buildDrafts

通过浏览器中访问主页 http://127.0.0.1:1313/

### 上传对外公布
sh deploy.sh

访问darrengeek.github.io 

