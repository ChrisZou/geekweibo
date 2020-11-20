[中文版](https://github.com/ChrisZou/geekweibo/blob/master/README.cn.md)
## What's this?
This is a web app where you can quickly save and share short technical notes. You can think of this as "Twitter for programmers".

## Why？
I've always wanted a place where I can quickly and conveniently save some short technical notes. But I haven't found one that suits my need. Twitter is nearest to what I want, but it doesn't support rendering markdown, so the experience is not ideal for viewing notes. Also, I haven't found a CLI tool for tweeting that I'm satisfied with, and I don't want to visit twitter.com every time just for sending a quick tweet. More on this [here](https://chriszou.com/2020/10/17/introducing-geekweibo/), it's in Chinese though.

## Features
- Github login
- Managing tweets(sending, viewing, deleting)
- Liking tweet
- Commenting tweet
- Notifications for tweet being liked, commented, etc.
- Sharing tweet though generated tweet image, like the following 

![](https://github.com/ChrisZou/geekweibo/blob/master/docs/sharing-card-en.jpg)

## Language stack

* Ruby on Rails
  * Ruby2.7.1，Rails 6.0.3.2

* VueJS/AlphineJS

* TailwindCSS

* postgresql

* ElasticSearch

## How to run
  * git clone this_repo
  * bundle install
  * yarn install
  * rails db:create db:migrate
  * rails s
