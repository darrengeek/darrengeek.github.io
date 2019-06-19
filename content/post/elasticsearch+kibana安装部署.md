---
title: "Elasticsearch+kibana安装部署"
date: 2019-06-19T14:48:21+08:00
categories:
- ELK
tags:
- ELK
keywords:
- tech
#thumbnailImage: //example.com/image.jpg
---

<!--more-->
[TOC]

# 准备安装环境
es建议安装在独立的系统账户下，这里我们创建es账户。
JAVA版本为1.8。
下载elasticsearch和kibana，注意两者版本号要严格保持一致。这里我们用6.7.1。
```
$ cd /home/es
$ wget https://artifacts.elastic.co/downloads/kibana/kibana-6.7.1-linux-x86_64.tar.gz
$ wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-6.7.1.tar.gz
$ tar -zxvf kibana-6.7.1-linux-x86_64.tar.gz
$ tar -zxvf elasticsearch-6.7.1.tar.gz
```

# 配置启动
## 启动elasticsearch
修改es配置文件/home/es/elasticsearch-6.7.1/config/elasticsearch.yml
```
# 官方自带推荐的默认配置，这里我们将几个关键配置显式定义
path.data: /home/es/data # 数据文件存放目录
path.logs: /home/es/logs # 日志存放目录
network.host: 192.168.1.212
http.port: 9200
```
启动elasticsearch
```
$ cd /home/es/elasticsearch-6.7.1/
$ sh bin/elasticsearch
```
检测elasticsearch是否启动成功：
```
浏览器访问：http://192.168.1.212:9200/
或者：
$ curl http://192.168.1.212:9200/

输出以下内容表示ES已启动：
{
  "name" : "uMMV8Hc",
  "cluster_name" : "elasticsearch",
  "cluster_uuid" : "JHaM0vXORy-In37Duldahg",
  "version" : {
    "number" : "6.7.1",
    "build_flavor" : "default",
    "build_type" : "tar",
    "build_hash" : "2f32220",
    "build_date" : "2019-04-02T15:59:27.961366Z",
    "build_snapshot" : false,
    "lucene_version" : "7.7.0",
    "minimum_wire_compatibility_version" : "5.6.0",
    "minimum_index_compatibility_version" : "5.0.0"
  },
  "tagline" : "You Know, for Search"
}
```
关闭es，官方没有提供关闭方案，我们直接kill进程
```
$ ps -efj|grep elasticsearch
# 把es相关的进程挨个Kill掉
```

## 启动kibana
修改配置文件：/home/es/kibana-6.7.1-linux-x86_64/config/kibana.yml
```
server.port: 5601 # 访问kibana时的ip/port
server.host: "192.168.1.212"
elasticsearch.hosts: ["http://192.168.1.212:9200"] # 显式指定ES
logging.dest: /home/es/logs/kibana.log # 日志文件
```
启动kibana
```
$ cd /home/es/kibana-6.7.1-linux-x86_64/
$ ./bin/kibana &
```
访问kibana，浏览器打开192.168.1.212:5601即可

关闭kibana
```
# 找到后台的kibana进程得费点事
$ ps -efj |grep src/cli
es       11759  9289 11759  9289  0 10:35 pts/6    00:00:45 ./bin/../node/bin/node --no-warnings --max-http-header-size=65536 ./bin/../src/cli
es       12068 11517 12067 11517  0 12:23 pts/7    00:00:00 grep --color=auto src/cli
# 这个11759的就是kibana进程，我们Kill掉即可
$ kill 11759
```

# 使用示例
操作ES有3种方式：

 - kibana控制台（Dev Tools）
 - Http + json
 - api接口

ES支持以下命令：

 - GET：获取请求对象的当前状态。 
 - POST：改变对象的当前状态。 
 - PUT：创建一个对象。 
 - DELETE：销毁对象。 
 - HEAD：请求获取对象的基础信息。

接下来我们提供几组在kibana dev tools上操作的示例：
```
# 获取指定文档
GET /dataproduct/productinfo/1/

# 搜索"masterName"字段包含"蛋糕"关键字的文档
GET dataproduct/_search
{
  "query": {
    "match": {
      "basicInfo.basicInfo.masterName": "蛋糕"
    }
  }
}

# 删除文档
DELETE /dataproduct/productinfo/1

# 添加一个文档
PUT /dataproduct/productinfo/1
{
  "basicInfo": {
    "basicInfo": {
      "productId": 1,
      "masterName": "四季芝士蛋糕(四拼)",
      "slaveName": "草莓 蓝莓 芝士 巧克力 如四季流转各具风味",
    },
    "categoryId": 105,
    "attrTypeIdList": [
      1,
      2,
      3
    ]
  }
}

# 修改文档字段basicInfo.categoryId加100
POST /dataproduct/productinfo/1/_update
{
  "script": {
    "inline":"ctx._source.basicInfo.categoryId += 100"
  }
}
```

如果是HTTP方式，在上述控制台指令上增加curl及ip:port即可，比如：
```
curl GET 192.168.1.212:9200/dataproduct/productinfo/1/
```


