## 这是什么
这是一个编程技术人员用来记录和分享 零碎的技术知识的地方，你可以理解为“技术人员的微博”。

## Why？
简单来说，希望有一个地方能够方便快捷的记录和分享一些零碎的知识片段。目前没有找到一个合适的现有产品。可能因为我是处女座，特别鸡毛，所以干脆自己写了一个。更详细的心路历程可参考：[这篇文章](https://chriszou.com/2020/10/17/introducing-geekweibo/)

## 现有功能
- Github 登陆
- 管理微博 (查看，发表，删除)
- 点赞微博
- 评论微博
- 通知（微博得到点赞、评论等）
- 生成分享图片，分享微博，如下图

![](https://github.com/ChrisZou/geekweibo/blob/master/docs/sharing-card-en.jpg)

## 技术栈：

* Ruby on Rails
  * Ruby2.7.1，Rails 6.0.3.2

* VueJS/AlphineJS

* TailwindCSS

* postgresql

* ElasticSearch（有点后悔，可能会迁移到PostgreSQL FTS）

## 运行起来：
  * git clone this_repo
  * bundle install
  * yarn install
  * rails db:create db:migrate
  * rails s
