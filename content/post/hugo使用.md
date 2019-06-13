---
title: "Hugo使用"
date: 2019-06-13T15:42:32+08:00
categories:
- blog
tags:
- hugo
- blog
keywords:
- tech
#thumbnailImage: //example.com/image.jpg
---

<!--more-->

博客文件，通常放在 content/post 目录中

```yaml
#创建
hugo new post/my-first-blog.md
```

## 编译静态网站
Hugo 在构建之前不会移除生成的文件。一个简单的解决方法是对开发环境和生产环境使用不同的目录。
可以指定单独的目录（例如 dev/）来启动构建草稿内容的服务器（有助于编辑）:
hugo server -wDs ~/Code/hugo/docs -d dev

内容完成后，可以使用默认的 public/ 目录。此时会忽略所有标记为 draft: false 的文件：
hugo -s ~/Code/hugo/docs

最终我们需要的是静态的 HTML 文件。--theme 选项指定主题，--baseUrl 指定了项目的网站。最终静态文件生成在 public 目录中：
hugo --theme=hugo-bootstrap --baseUrl="https://blog.kikakika.com"



