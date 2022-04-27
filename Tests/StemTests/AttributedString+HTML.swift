//
//  File.swift
//  
//
//  Created by linhey on 2021/11/23.
//

import Foundation
import XCTest
import Stem

class AttributeHtmlTests: XCTestCase {
    
    enum ParseHtmlResult {
        case dxmm(String)
        case text(String)
    }
    
    func testHtmlImageSrc() throws {
        let html = #"不错的帖子<img class="emotion emotion-default" src="https://assets.dxycdn.com/app/bbs/emotions/dxmm/04.png" />哈哈哈<img class="emotion emotion-default" src="https://assets.dxycdn.com/app/bbs/emotions/dxmm/13.png" />可以的可以<img class="emotion emotion-default" src="https://assets.dxycdn.com/app/bbs/emotions/dxmm/13.png" /><img class="emotion emotion-default" src="https://assets.dxycdn.com/app/bbs/emotions/dxmm/13.png" />的哈哈哈"#
        guard html.isEmpty == false,
              let imgRegex = try? NSRegularExpression(pattern: #"<(img|IMG)[^\<\>]*>"#),
              let dxmmRegex = try? NSRegularExpression.init(pattern: #"src="(.+)""#) else {
            return
        }
        let matches = imgRegex.matches(in: html, options: [], range: .init(location: 0, length: html.count))
        let ranges = matches.map(\.range)
        var result = [ParseHtmlResult]()
        
        func substring(_ range: NSRange, in string: String) -> String {
            string[.init(utf16Offset: range.location, in: string)..<(.init(utf16Offset: range.location+range.length, in: string))].description
        }
        
        func substring(_ range: ClosedRange<Int>, in string: String) -> String {
            string[.init(utf16Offset: range.lowerBound, in: string)...(.init(utf16Offset: range.upperBound, in: string))].description
        }
        
        var lastRange: NSRange = .init(location: 0, length: 0)
        for range in ranges {
            if range.location > lastRange.location+lastRange.length {
                result.append(.text(substring(lastRange.location+lastRange.length...range.location-1, in: html)))
            }
            let str = substring(range, in: html)
            if let range = dxmmRegex.firstMatch(in: str, range: .init(location: 0, length: str.count))?.range(at: 1) {
                result.append(.dxmm(substring(range, in: str)))
            } else {
                result.append(.text(str))
            }
            lastRange = range
        }
        if lastRange.location + lastRange.length < html.count {
            result.append(.text(substring(lastRange.location+lastRange.length...html.count-1, in: html)))
        }
        result
    }
    
    func testHtmlToString() throws {
      try Gcd.duration { duration in
            let data = #"""
    <!doctype html>
    <html lang="zh-CN">

    <head>
      <title>腾讯首页</title>
      <meta charset="gb2312">
      <meta http-equiv="X-UA-Compatible" content="IE=Edge" />
      <meta name="baidu-site-verification" content="OfJHAPXD7i" />
      <meta name="baidu_union_verify" content="4508fc7dced37cf569c36f88135276d2">
      <meta name="theme-color" content="#FFF" />
      <meta name="viewport" content="width=device-width, initial-scale=1" />
      <meta name="format-detection" content="telephone=no">
      <!-- <script src="//js.aq.qq.com/js/aq_common.js"></script> -->
      <script type="text/javascript">
    try {
      if (location.search.indexOf('?pc') !== 0 && /Android|Windows Phone|iPhone|iPod/i.test(navigator.userAgent)) {
        window.location.href = 'https://xw.qq.com?f=qqcom';
      }
    } catch (e) {}
    </script><!--[if !IE]>|xGv00|2d5210e6c1b95e3bf4b8983f9cb00ab3<![endif]-->
      <meta content="资讯,新闻,财经,房产,视频,NBA,科技,腾讯网,腾讯,QQ,Tencent" name="Keywords">
      <meta name="description" content="腾讯网从2003年创立至今，已经成为集新闻信息，区域垂直生活服务、社会化媒体资讯和产品为一体的互联网媒体平台。腾讯网下设新闻、科技、财经、娱乐、体育、汽车、时尚等多个频道，充分满足用户对不同类型资讯的需求。同时专注不同领域内容，打造精品栏目，并顺应技术发展趋势，推出网络直播等创新形式，改变了用户获取资讯的方式和习惯。" />
      <link rel="shortcut icon" href="//mat1.gtimg.com/www/icon/favicon2.ico" />
      <link rel="stylesheet" href="https://mat1.gtimg.com/qqcdn/qqindex2021/qqhome/css/qq_059aca1a.css" charset="utf-8">
      <style>
        body{
            background-color:#fff;
        }
        
        #skin-close{
          display: none;
        }
        /* .qq-body-skin{
          background-color: #d20001!important;
        } */
        .qq-body-skin .layout{
          margin-bottom:0;
          padding-bottom: 20px;
        }
        .qq-body-skin .qq-skin,
        .qq-body-skin .qq-top{
          padding-bottom: 0;
        }
        .garyBody{
          filter: grayscale(100%);
          -webkit-filter: grayscale(100%);
          -moz-filter: grayscale(100%);
          -ms-filter: grayscale(100%);
          -o-filter: grayscale(100%);
          -webkit-filter: grayscale(1);
        }
        .iebrowser{
            background-color: #ddd ;
            opacity: 0.5;
            filter: Alpha(opacity=50);
        }
        .iebrowser .qq-nav .nav-mod{
            background-color: #b0b0b1 !important;
        }

        .iebrowser .searchBtn{
          background-color: #b0b0b1 !important;
        }

        .iebrowser .mod .hd .tit.active a{
          display: inline-block !important;
          color: #161617 !important;
          border-bottom: 4px solid #212121 !important;
        }
        .iebrowser .mod .bd .cate {
          color: #212222 !important;
        }
        .iebrowser  a:hover {
          color: #030303 !important;
        }
        .p1t {
          overflow: hidden;
        }
        
        .p1t img {
          width: auto;
          margin-left: -9px;
        }
        @media (max-width: 1440px){
          .barrierLink {
                margin-left: 185px!important;
            }
        }
        @media (max-width: 1279px){
          .barrierLink {
                margin-left: 75px!important;
                margin-top: 23px!important;
            }
        }
      </style>
    </head>

    <body>

      <div class="global" data-beacon-expo="qn_elementid=pv&qn_event_type=show">

        <!-- 大皮肤 -->
        <div id="big-skin" class="layout qq-skin"></div>
        <!-- /大皮肤 -->

        <!-- 头部 -->
        <div class="layout qq-top cf" bossexpo="bg_top">

          <h1 class="top-logo fl">
            <a href="/" target="_blank" bosszone="top_logo" data-beacon-expo="qn_elementid=top_logo&qn_event_type=show" data-beacon-click="qn_elementid=top_logo&qn_event_type=click">
              <img width="100%" src="//inews.gtimg.com/newsapp_bt/0/0923142908664_4470/0" alt="腾讯网">
            </a>
          </h1>

          <!-- 小皮肤 -->
          <div id="small-skin" class="skin-min fl"></div>
          <!-- /小皮肤 -->

          <!-- 搜索 -->
    <div class="top-search fl" id="sosobar" role="search" bosszone="top_search"  data-beacon-expo="qn_elementid=top_search&qn_event_type=show" data-beacon-click="qn_elementid=top_search&qn_event_type=click">
        <form id="searchForm" method="get" name="soso_search_box"
            action="https://www.sogou.com/tx?hdq=sogou-wsse-3f7bcd0b3ea82268-0001&ie=utf-8&query=" target="_blank">
            <div id="searchTxt" class="searchTxt">
                <input type="hidden" value="w.q.in.sb.web" name="cid" />
                <div class="searchMenu fl">
                    <div class="searchSelected" id="searchSelected">网页</div>
                    <div class="searchTab" id="searchTab">
                        <ul></ul>
                    </div>
                </div>
                <input id="sougouTxt" type="text" value="" name="w" aria-label="请输入搜索文字" />
                <div class="searchSmart" id="searchSmart" style="display:none;">
                    <ul></ul>
                </div>
                <div class="fr">
                    <button id="searchBtn" class="searchBtn" type="submit">搜狗搜索</button>
                </div>
            </div>
        </form>
    </div>
    <script type="text/javascript">
        function sogouShow() {}

        function sosoShow() {}
    </script>
    <!-- /搜索 -->

    <div class="fl barrierLink" style="margin: 28px 0 0 270px;font-size: 14px;">
        <a href="//new.qq.com/barrierfree.html" target="_blank" style="color: #1479d7;">关怀版</a>
    </div>

    <!-- 登录 -->
    <div id="top-login" class="top-login fr">
        <div class="item item-qzone fl" data-beacon-expo="qn_elementid=top_qzone&qn_event_type=show" data-beacon-click="qn_elementid=top_qzone&qn_event_type=click">
            <a href="https://qzone.qq.com" class="q-icons l-qzone" target="_blank" bosszone="top_qzone">Qzone</a>
            <div class="pop">
                <i class="arr-icon"></i>
                <a class="txt" href="https://qzone.qq.com" target="_blank" bosszone="top_qzone">点击查看QQ空间</a>
            </div>
        </div>
        <div class="item item-qmail fl" data-beacon-expo="qn_elementid=top_mail&qn_event_type=show" data-beacon-click="qn_elementid=top_mail&qn_event_type=click">
            <a href="https://mail.qq.com" class="q-icons l-qmail" target="_blank" bosszone="top_mail">Qmail</a>
            <div class="pop">
                <i class="arr-icon"></i>
                <a class="txt" href="https://mail.qq.com/cgi-bin/loginpage" target="_blank" bosszone="top_mail">点击查看QQ邮箱</a>
            </div>
        </div>
        <div class="item item-login fl" data-beacon-expo="qn_elementid=top_login&qn_event_type=show" data-beacon-click="qn_elementid=top_login&qn_event_type=click">
            <a class="l-login" href="javascript:;" onclick="userLogin()" bosszone="top_login">登录</a>
            <div class="pop">
                <i class="arr-icon"></i>
                <div class="nick">你好，</div>
                <a class="loginout" href="javascript:;" onclick="login.loginOut()" bosszone="top_login">[退出登录]</a>
            </div>
        </div>
    </div>
    <!-- /登录 --><!--93ec87ac054bad1983e652d59b0e1be3-->

        </div>
        <!-- /头部 -->

        <!-- 导航 -->
        <div class="layout qq-nav">
          <div class="nav-mod cf">
            <style type="text/css">
    .qq-nav .nav-mod .nav-item{white-space: nowrap;}
    </style>

    <ul class="nav-main fl" bossexpo="bg_dh_1">
        <li class="nav-item">
        <a href="http://news.qq.com/" target="_blank" data-beacon-click="qn_elementid=dh_1&qn_event_type=click" data-beacon-expo="qn_elementid=dh_1&qn_event_type=show"   bosszone="dh_1">新闻</a>
      </li>
        <li class="nav-item">
        <a href="http://v.qq.com/" target="_blank" data-beacon-click="qn_elementid=dh_2&qn_event_type=click" data-beacon-expo="qn_elementid=dh_2&qn_event_type=show"   bosszone="dh_2">视频</a>
      </li>
        <li class="nav-item">
        <a href="http://new.qq.com/ch/photo/" target="_blank" data-beacon-click="qn_elementid=dh_3&qn_event_type=click" data-beacon-expo="qn_elementid=dh_3&qn_event_type=show"   bosszone="dh_3">图片</a>
      </li>
        <li class="nav-item">
        <a href="https://new.qq.com/ch/milite/" target="_blank" data-beacon-click="qn_elementid=dh_4&qn_event_type=click" data-beacon-expo="qn_elementid=dh_4&qn_event_type=show"   bosszone="dh_4">军事</a>
      </li>
        <li class="nav-item">
        <a href="https://sports.qq.com/" target="_blank" data-beacon-click="qn_elementid=dh_5&qn_event_type=click" data-beacon-expo="qn_elementid=dh_5&qn_event_type=show"   bosszone="dh_5">体育</a>
      </li>
        <li class="nav-item">
        <a href="https://sports.qq.com/nba/" target="_blank" data-beacon-click="qn_elementid=dh_6&qn_event_type=click" data-beacon-expo="qn_elementid=dh_6&qn_event_type=show"   bosszone="dh_6">NBA</a>
      </li>
        <li class="nav-item">
        <a href="https://new.qq.com/ch/ent/" target="_blank" data-beacon-click="qn_elementid=dh_7&qn_event_type=click" data-beacon-expo="qn_elementid=dh_7&qn_event_type=show"   bosszone="dh_7">娱乐</a>
      </li>
        <li class="nav-item">
        <a href="https://new.qq.com/ch/finance/" target="_blank" data-beacon-click="qn_elementid=dh_8&qn_event_type=click" data-beacon-expo="qn_elementid=dh_8&qn_event_type=show"   bosszone="dh_8">财经</a>
      </li>
        <li class="nav-item">
        <a href="https://new.qq.com/ch/tech/" target="_blank" data-beacon-click="qn_elementid=dh_9&qn_event_type=click" data-beacon-expo="qn_elementid=dh_9&qn_event_type=show"   bosszone="dh_9">科技</a>
      </li>
        <li class="nav-item">
        <a href="https://new.qq.com/ch/fashion/" target="_blank" data-beacon-click="qn_elementid=dh_10&qn_event_type=click" data-beacon-expo="qn_elementid=dh_10&qn_event_type=show"   bosszone="dh_10">时尚</a>
      </li>
        <li class="nav-item">
        <a href="https://new.qq.com/ch/auto/" target="_blank" data-beacon-click="qn_elementid=dh_11&qn_event_type=click" data-beacon-expo="qn_elementid=dh_11&qn_event_type=show"   bosszone="dh_11">汽车</a>
      </li>
        <li class="nav-item">
        <a href="http://house.qq.com/" target="_blank" data-beacon-click="qn_elementid=dh_12&qn_event_type=click" data-beacon-expo="qn_elementid=dh_12&qn_event_type=show"   bosszone="dh_12">房产</a>
      </li>
        <li class="nav-item">
        <a href="https://new.qq.com/ch/edu/" target="_blank" data-beacon-click="qn_elementid=dh_13&qn_event_type=click" data-beacon-expo="qn_elementid=dh_13&qn_event_type=show"   bosszone="dh_13">教育</a>
      </li>
        <li class="nav-item">
        <a href="https://new.qq.com/ch/cul/" target="_blank" data-beacon-click="qn_elementid=dh_14&qn_event_type=click" data-beacon-expo="qn_elementid=dh_14&qn_event_type=show"   bosszone="dh_14">文化</a>
      </li>
        <li class="nav-item">
        <a href="https://new.qq.com/ch/astro/" target="_blank" data-beacon-click="qn_elementid=dh_15&qn_event_type=click" data-beacon-expo="qn_elementid=dh_15&qn_event_type=show"   bosszone="dh_15">星座</a>
      </li>
        <li class="nav-item">
        <a href="https://new.qq.com/ch/games/" target="_blank" data-beacon-click="qn_elementid=dh_16&qn_event_type=click" data-beacon-expo="qn_elementid=dh_16&qn_event_type=show"   bosszone="dh_16">游戏</a>
      </li>
      </ul><!--229e2d042583d5bedee507a5fe4c358b-->
            <div class="nav-more fl">
      <div class="more-txt" bosszone="dh_more">更多</div>
      <div class="nav-sub" bossexpo="bg_dh_2">
        <ul class="sub-list cf">
                <li class="nav-item">
            <a href="https://new.qq.com/ch/society/" target="_blank" data-beacon-click="qn_elementid=dh_1_2&qn_event_type=click" data-beacon-expo="qn_elementid=dh_1_2&qn_event_type=show" bosszone="dh_1_2">法制</a>
          </li>
                <li class="nav-item">
            <a href="https://v.qq.com/tv/" target="_blank" data-beacon-click="qn_elementid=dh_2_2&qn_event_type=click" data-beacon-expo="qn_elementid=dh_2_2&qn_event_type=show" bosszone="dh_2_2">热剧</a>
          </li>
                <li class="nav-item">
            <a href="https://new.qq.com/ch/antip/" target="_blank" data-beacon-click="qn_elementid=dh_3_2&qn_event_type=click" data-beacon-expo="qn_elementid=dh_3_2&qn_event_type=show" bosszone="dh_3_2">抗肺炎</a>
          </li>
                <li class="nav-item">
            <a href="http://new.qq.com/ch/history/" target="_blank" data-beacon-click="qn_elementid=dh_4_2&qn_event_type=click" data-beacon-expo="qn_elementid=dh_4_2&qn_event_type=show" bosszone="dh_4_2">历史</a>
          </li>
                <li class="nav-item">
            <a href="http://sports.qq.com/premierleague/" target="_blank" data-beacon-click="qn_elementid=dh_5_2&qn_event_type=click" data-beacon-expo="qn_elementid=dh_5_2&qn_event_type=show" bosszone="dh_5_2">英超</a>
          </li>
                <li class="nav-item">
            <a href="http://sports.qq.com/cba/" target="_blank" data-beacon-click="qn_elementid=dh_6_2&qn_event_type=click" data-beacon-expo="qn_elementid=dh_6_2&qn_event_type=show" bosszone="dh_6_2">CBA</a>
          </li>
                <li class="nav-item">
            <a href="https://new.qq.com/ch2/star" target="_blank" data-beacon-click="qn_elementid=dh_7_2&qn_event_type=click" data-beacon-expo="qn_elementid=dh_7_2&qn_event_type=show" bosszone="dh_7_2">明星</a>
          </li>
                <li class="nav-item">
            <a href="https://new.qq.com/ch/finance_licai/" target="_blank" data-beacon-click="qn_elementid=dh_8_2&qn_event_type=click" data-beacon-expo="qn_elementid=dh_8_2&qn_event_type=show" bosszone="dh_8_2">理财</a>
          </li>
                <li class="nav-item">
            <a href="https://new.qq.com/ch/kepu/" target="_blank" data-beacon-click="qn_elementid=dh_9_2&qn_event_type=click" data-beacon-expo="qn_elementid=dh_9_2&qn_event_type=show" bosszone="dh_9_2">科普</a>
          </li>
                <li class="nav-item">
            <a href="https://new.qq.com/ch/health/" target="_blank" data-beacon-click="qn_elementid=dh_10_2&qn_event_type=click" data-beacon-expo="qn_elementid=dh_10_2&qn_event_type=show" bosszone="dh_10_2">健康</a>
          </li>
                <li class="nav-item">
            <a href="https://auto.qq.com/car_public/index.shtml" target="_blank" data-beacon-click="qn_elementid=dh_11_2&qn_event_type=click" data-beacon-expo="qn_elementid=dh_11_2&qn_event_type=show" bosszone="dh_11_2">车型</a>
          </li>
                <li class="nav-item">
            <a href="http://www.jia360.com" target="_blank" data-beacon-click="qn_elementid=dh_12_2&qn_event_type=click" data-beacon-expo="qn_elementid=dh_12_2&qn_event_type=show" bosszone="dh_12_2">家居</a>
          </li>
                <li class="nav-item">
            <a href="https://new.qq.com/ch/baby/" target="_blank" data-beacon-click="qn_elementid=dh_13_2&qn_event_type=click" data-beacon-expo="qn_elementid=dh_13_2&qn_event_type=show" bosszone="dh_13_2">育儿</a>
          </li>
                <li class="nav-item">
            <a href="https://new.qq.com/ch/emotion/" target="_blank" data-beacon-click="qn_elementid=dh_14_2&qn_event_type=click" data-beacon-expo="qn_elementid=dh_14_2&qn_event_type=show" bosszone="dh_14_2">情感</a>
          </li>
                <li class="nav-item">
            <a href="https://new.qq.com/ch/comic/" target="_blank" data-beacon-click="qn_elementid=dh_15_2&qn_event_type=click" data-beacon-expo="qn_elementid=dh_15_2&qn_event_type=show" bosszone="dh_15_2">动漫</a>
          </li>
                <li class="nav-item">
            <a href="http://gongyi.qq.com/" target="_blank" data-beacon-click="qn_elementid=dh_16_2&qn_event_type=click" data-beacon-expo="qn_elementid=dh_16_2&qn_event_type=show" bosszone="dh_16_2">公益</a>
          </li>
                <li class="nav-item">
            <a href="http://tianqi.qq.com/index.htm" target="_blank" data-beacon-click="qn_elementid=dh_17_2&qn_event_type=click" data-beacon-expo="qn_elementid=dh_17_2&qn_event_type=show" bosszone="dh_17_2">天气</a>
          </li>
                <li class="nav-item">
            <a href="https://new.qq.com/omn/author/5107513" target="_blank" data-beacon-click="qn_elementid=dh_18_2&qn_event_type=click" data-beacon-expo="qn_elementid=dh_18_2&qn_event_type=show" bosszone="dh_18_2">较真</a>
          </li>
                <li class="nav-item">
            <a href="https://v.qq.com/channel/variety" target="_blank" data-beacon-click="qn_elementid=dh_19_2&qn_event_type=click" data-beacon-expo="qn_elementid=dh_19_2&qn_event_type=show" bosszone="dh_19_2">综艺</a>
          </li>
                <li class="nav-item">
            <a href="http://news.qq.com/photon/photoex.htm" target="_blank" data-beacon-click="qn_elementid=dh_20_2&qn_event_type=click" data-beacon-expo="qn_elementid=dh_20_2&qn_event_type=show" bosszone="dh_20_2">影展</a>
          </li>
                <li class="nav-item">
            <a href="https://new.qq.com/ch/world/" target="_blank" data-beacon-click="qn_elementid=dh_21_2&qn_event_type=click" data-beacon-expo="qn_elementid=dh_21_2&qn_event_type=show" bosszone="dh_21_2">国际</a>
          </li>
                <li class="nav-item">
            <a href="http://sports.qq.com/csocce/csl/" target="_blank" data-beacon-click="qn_elementid=dh_22_2&qn_event_type=click" data-beacon-expo="qn_elementid=dh_22_2&qn_event_type=show" bosszone="dh_22_2">中超</a>
          </li>
                <li class="nav-item">
            <a href="http://fans.sports.qq.com/#/" target="_blank" data-beacon-click="qn_elementid=dh_23_2&qn_event_type=click" data-beacon-expo="qn_elementid=dh_23_2&qn_event_type=show" bosszone="dh_23_2">社区</a>
          </li>
                <li class="nav-item">
            <a href="http://v.qq.com/movie/" target="_blank" data-beacon-click="qn_elementid=dh_24_2&qn_event_type=click" data-beacon-expo="qn_elementid=dh_24_2&qn_event_type=show" bosszone="dh_24_2">电影</a>
          </li>
                <li class="nav-item">
            <a href="https://new.qq.com/ch/finance_stock/" target="_blank" data-beacon-click="qn_elementid=dh_25_2&qn_event_type=click" data-beacon-expo="qn_elementid=dh_25_2&qn_event_type=show" bosszone="dh_25_2">证券</a>
          </li>
                <li class="nav-item">
            <a href="https://new.qq.com/ch/digi/" target="_blank" data-beacon-click="qn_elementid=dh_26_2&qn_event_type=click" data-beacon-expo="qn_elementid=dh_26_2&qn_event_type=show" bosszone="dh_26_2">数码</a>
          </li>
                <li class="nav-item">
            <a href="https://new.qq.com/ch2/makeup" target="_blank" data-beacon-click="qn_elementid=dh_27_2&qn_event_type=click" data-beacon-expo="qn_elementid=dh_27_2&qn_event_type=show" bosszone="dh_27_2">美容</a>
          </li>
                <li class="nav-item">
            <a href="https://new.qq.com/ch/topic/" target="_blank" data-beacon-click="qn_elementid=dh_28_2&qn_event_type=click" data-beacon-expo="qn_elementid=dh_28_2&qn_event_type=show" bosszone="dh_28_2">话题</a>
          </li>
                <li class="nav-item">
            <a href="https://new.qq.com/ch/life/" target="_blank" data-beacon-click="qn_elementid=dh_29_2&qn_event_type=click" data-beacon-expo="qn_elementid=dh_29_2&qn_event_type=show" bosszone="dh_29_2">生活</a>
          </li>
                <li class="nav-item">
            <a href="http://kid.qq.com/" target="_blank" data-beacon-click="qn_elementid=dh_30_2&qn_event_type=click" data-beacon-expo="qn_elementid=dh_30_2&qn_event_type=show" bosszone="dh_30_2">儿童</a>
          </li>
                <li class="nav-item">
            <a href="http://book.qq.com/" target="_blank" data-beacon-click="qn_elementid=dh_31_2&qn_event_type=click" data-beacon-expo="qn_elementid=dh_31_2&qn_event_type=show" bosszone="dh_31_2">文学</a>
          </li>
                <li class="nav-item">
            <a href="https://new.qq.com/omv/" target="_blank" data-beacon-click="qn_elementid=dh_32_2&qn_event_type=click" data-beacon-expo="qn_elementid=dh_32_2&qn_event_type=show" bosszone="dh_32_2">享看</a>
          </li>
                <li class="nav-item">
            <a href="https://new.qq.com/ch/cul_ru/" target="_blank" data-beacon-click="qn_elementid=dh_33_2&qn_event_type=click" data-beacon-expo="qn_elementid=dh_33_2&qn_event_type=show" bosszone="dh_33_2">新国风</a>
          </li>
                <li class="nav-item">
            <a href="http://www.qq.com/map/" target="_blank" data-beacon-click="qn_elementid=dh_34_2&qn_event_type=click" data-beacon-expo="qn_elementid=dh_34_2&qn_event_type=show" bosszone="dh_34_2">全部</a>
          </li>
              </ul>
      </div>
    </div><!--e090f8e0a9ebbc20b1e13d9f9a1e5643-->
          </div>
        </div>
        <!-- /导航 -->

        <!-- 广告1 -->
        <div class="layout qq-gg gg-1 cf">
          <div class="col-1 fl">
            <!--NEW_QQCOM_N_Width1_div AD begin...."l=NEW_QQCOM_N_Width1&log=off"--><div id="NEW_QQCOM_N_Width1" style="width:920px;height:75px;" class="l_qq_com"></div><!--NEW_QQCOM_N_Width1 AD end --><!--[if !IE]>|xGv00|b3d18b0084cd79d75eec6cc3e21077fc<![endif]-->
          </div>
          <div class="col-2 fr">
            <div id="gg-focus1" class="gg-focus">
      <ul class="list">
            <li class="item">
                  <a href="http://www.shdf.gov.cn/shdf/channels/740.html" target="_blank">
              <img src="https://inews.gtimg.com/newsapp_bt/0/09241451069_3873/0" alt="中国扫黄打非网举报入口">
            </a>
              </li>
            <li class="item">
                  <a href="https://www.qq.com/jubaoxuzhi.htm" target="_blank">
              <img src="https://inews.gtimg.com/newsapp_bt/0/0924145221382_8644/0" alt="网络监控">
            </a>
              </li>
            <li class="item">
                  <a href="https://110.qq.com/article_detail.html?id=5F1B69AAE7DBFB2D2B90" target="_blank">
              <img src="https://inews.gtimg.com/newsapp_bt/0/0924145258587_5505/0" alt="未成年人不良内容举报入口">
            </a>
              </li>
            <li class="item">
                  <a href="https://www.12377.cn/" target="_blank">
              <img src="https://inews.gtimg.com/newsapp_bt/0/092414533156_7716/0" alt="网上有害信息举报">
            </a>
              </li>
            <li class="item">
                  <a href="https://110.qq.com/" target="_blank">
              <img src="https://inews.gtimg.com/newsapp_bt/0/0924145407765_4081/0" alt="腾讯卫士">
            </a>
              </li>
          </ul>
      <div class="dot"></div>
    </div><!--cc7cf4cea08e360fd5a316159788a696-->
          </div>
        </div>
        <!-- /广告1 -->

        <div class="layout qq-main cf">
          <div class="col col-1 fl">

            <div id="main-news" class="mod m-news">

              <div class="hd cf">
                <h2 class="tit active fl"><a href="//news.qq.com" target="_blank" bosszone="yw_logo">要闻</a></h2>
                <span class="tit-line fl"></span>
                <h2 class="tit fl"><a href="//new.qq.com/ch/antip/" target="_blank" data-beacon-expo="qn_elementid=antip_logo&qn_event_type=show" data-beacon-click="qn_elementid=antip_logo&qn_event_type=click" bosszone="antip_logo">抗肺炎</a></h2>
                <span class="tit-line fl" style="display:none"></span>
                <h2 class="tit fl"></h2>
                <div id="m-weather" class="m-weather f14 fr">
      <a id="weaher-info" href="https://tianqi.qq.com/" target="_blank">
        <div id="ipWeather" class="w-city fl"></div>
        <div id="weatherIcon" class="w-icon fl"></div>
        <div id="weatherTemperature" class="w-du fl"></div>
      </a>

      <div id="weatherMore" class="weather-more">

        <!-- 天气详情 -->
        <div class="face front">
          <div class="weatherMoreTitle cf">
            <div class="weather-info fl">
              <a id="weatherMoreLink" href="https://tianqi.qq.com/" target="_blank">
                <span id="weatherMoreCity"></span>
                <span id="weatherMoreTxt"></span>
                <span id="weatherMoreTem"></span>
              </a>
            </div>
            <div class="weatherMoreSet fr" id="weatherMoreSet">
              <a href="javascript:void(0);">更换城市</a>
            </div>
          </div>
          <div class="weatherMoreAir">
            <a id="weatherMoreAirLink" href="https://tianqi.qq.com/" target="_blank">
              空气质量：<span id="weatherMoreAirTxt" style="padding-right:20px;"></span>
              PM2.5：<span id="weatherMoreAirPmTxt"></span>
            </a>
          </div>
          <a id="weatherMoreFuture" class="weatherMoreFuture cf" href="https://tianqi.qq.com/" target="_blank">
            <div class="weatherMoreFutureCon">
              <div class="weatherMoreIcon w-icon" id="weatherMoreTodayIcon"></div>
              <p><strong>今天</strong></p>
              <p>
                <span id="weatherMoreTodayHighest" class="weatherMoreMath">-</span>℃ -
                <span id="weatherMoreTodayLowest" class="weatherMoreMathLow">-</span>
                <span class="weatherMoreSign">℃</span>
              </p>
            </div>
            <div class="weatherMoreFutureCon">
              <div class="weatherMoreIcon w-icon" id="weatherMoreTomorrowIcon"></div>
              <p><strong>明天</strong></p>
              <p>
                <span id="weatherMoreTomorrowHighest" class="weatherMoreMath">-</span>℃ -
                <span id="weatherMoreTomorrowLowest" class="weatherMoreMathLow">-</span>
                <span class="weatherMoreSign">℃</span></p>
            </div>
            <div class="weatherMoreFutureCon">
              <div class="weatherMoreIcon w-icon" id="weatherMoreAfterTomorrowIcon"></div>
              <p><strong>后天</strong></p>
              <p>
                <span id="weatherMoreAfterTomorrowHighest" class="weatherMoreMath">-</span>℃ -
                <span id="weatherMoreAfterTomorrowLowest" class="weatherMoreMathLow">-</span>
                <span class="weatherMoreSign">℃</span>
              </p>
            </div>
          </a>
        </div>
        <!-- /天气详情 -->

        <!-- 城市设置 -->
        <div class="face back">
          <div class="weatherMoreTitle cf">
            <div class="fl">
              <span>设置城市</span>
            </div>
            <a href="javascript:void(0);" id="weatherMoreReset" class="weatherMoreReset">恢复默认城市</a>
          </div>
          <div class="weatherMoreSelectLayout cf">
            <div class="weatherMoreProviceLayout fl">
              <div class="weatherMoreProviceDefault" id="ipSetProvince">北京市</div>
              <div class="weatherMoreProviceSelect" id="weatherMoreProviceSelect">
                <ul>
                  <li><a href="javascript:void(0);">北京市</a></li>
                  <li><a href="javascript:void(0);">上海市</a></li>
                  <li><a href="javascript:void(0);">天津市</a></li>
                  <li><a href="javascript:void(0);">重庆市</a></li>
                  <li><a href="javascript:void(0);">河北省</a></li>
                  <li><a href="javascript:void(0);">山西省</a></li>
                  <li><a href="javascript:void(0);">内蒙古</a></li>
                  <li><a href="javascript:void(0);">江苏省</a></li>
                  <li><a href="javascript:void(0);">安徽省</a></li>
                  <li><a href="javascript:void(0);">山东省</a></li>
                  <li><a href="javascript:void(0);">辽宁省</a></li>
                  <li><a href="javascript:void(0);">吉林省</a></li>
                  <li><a href="javascript:void(0);">黑龙江省</a></li>
                  <li><a href="javascript:void(0);">浙江省</a></li>
                  <li><a href="javascript:void(0);">江西省</a></li>
                  <li><a href="javascript:void(0);">福建省</a></li>
                  <li><a href="javascript:void(0);">湖北省</a></li>
                  <li><a href="javascript:void(0);">湖南省</a></li>
                  <li><a href="javascript:void(0);">河南省</a></li>
                  <li><a href="javascript:void(0);">广东省</a></li>
                  <li><a href="javascript:void(0);">广西</a></li>
                  <li><a href="javascript:void(0);">海南省</a></li>
                  <li><a href="javascript:void(0);">四川省</a></li>
                  <li><a href="javascript:void(0);">贵州省</a></li>
                  <li><a href="javascript:void(0);">云南省</a></li>
                  <li><a href="javascript:void(0);">西藏</a></li>
                  <li><a href="javascript:void(0);">陕西省</a></li>
                  <li><a href="javascript:void(0);">甘肃省</a></li>
                  <li><a href="javascript:void(0);">宁夏</a></li>
                  <li><a href="javascript:void(0);">青海省</a></li>
                  <li><a href="javascript:void(0);">新疆</a></li>
                  <li><a href="javascript:void(0);">香港</a></li>
                  <li><a href="javascript:void(0);">澳门</a></li>
                  <li><a href="javascript:void(0);">台湾省</a></li>
                </ul>
              </div>
            </div>
            <div class="weatherMoreCityLayout fl">
              <div class="weatherMoreCityDefault" id="ipSetCity">北京市</div>
              <div class="weatherMoreCitySelect" id="weatherMoreCitySelect">
                <ul id="weatherMoreCitySelectUl">
                  <li><a href="javascript:void(0);">北京市</a></li>
                </ul>
              </div>
            </div>
          </div>
          <div class="weatherMoreNews">
            <div id="weatherMoreNewsCheckbox" class="weatherMoreNewsCheckbox weatherMoreNewsYes" style="display:none">同时更新资讯所属地</div>
          </div>
          <div class="weatherMoreBtn">
            <input type="button" value="确定" id="weatherMoreSubmit" class="weatherMoreSubmit" />
            <input type="button" value="取消" id="weatherMoreCancel" class="weatherMoreCancel" />
          </div>
        </div>
        <!-- /城市设置 -->

      </div>
    </div><!--22387c29e2e6565bc4936f977fba8cfc--><!--[if !IE]>|xGv00|e8fbb0435570dc4bd2db993b13cd0260<![endif]-->
              </div>
              <div class="bd">

                <!-- 要闻 -->
                <div id="tab-news-01" class="tab-news" bossexpo="bg_yw">
                  <style>
      .bgcolor1 {
          background: #f56300;
          color: #FFF;
          padding: 0 3px;
          border-radius: 3px;
      }
      
      .bgcolor1:hover {
          color: #FFF;
      }
      li.news-top-first {
        height:36px;
        text-indent: -2000px;
      }
      </style>
                  <ul class="yw-list" bosszone="yw_1">
          
      <li class="news-top ">
          <a class=" bold" href="https://new.qq.com/omn/20211123/20211123A09RC100.html" target="_blank" data-beacon-expo="qn_elementid=yw1_1&qn_event_type=show" data-beacon-click="qn_elementid=yw1_1&qn_event_type=click" newsexpo="yw1_1" style="">习近平对全军后勤工作会议作出重要指示</a>
      
      </li>

          
      <li class=" ">
          
            <a data-a="false" style="" class=" bold" href="https://new.qq.com/omn/20211123/20211123A052B100.html" target="_blank" data-icon="no-icon" data-beacon-expo="qn_elementid=yw2_1&qn_event_type=show" data-beacon-click="qn_elementid=yw2_1&qn_event_type=click" newsexpo="yw2_1">构建中国-东盟命运共同体</a>        <a data-a="false" style="" class=" bold" href="https://new.qq.com/omn/TWF20211/TWF2021112300833100.html" target="_blank" data-icon="no-icon" data-beacon-expo="qn_elementid=yw2_2&qn_event_type=show" data-beacon-click="qn_elementid=yw2_2&qn_event_type=click" newsexpo="yw2_2">三名航天员获航天功勋奖章</a>
      </li>

          
      <li class=" ">
          
            <a data-a="false" style="" class=" bold" href="https://new.qq.com/omn/20211122/20211122A0AYPU00.html" target="_blank" data-icon="no-icon" data-beacon-expo="qn_elementid=yw3_1&qn_event_type=show" data-beacon-click="qn_elementid=yw3_1&qn_event_type=click" newsexpo="yw3_1">“五个一百”</a>        <a data-a="false" style="" class=" bold" href="https://new.qq.com/omn/20211123/20211123A026JV00.html" target="_blank" data-icon="no-icon" data-beacon-expo="qn_elementid=yw3_2&qn_event_type=show" data-beacon-click="qn_elementid=yw3_2&qn_event_type=click" newsexpo="yw3_2">释放向上向善的正能量</a>        <a data-a="false" style="" class=" bold" href="https://new.qq.com/omn/20211123/20211123A026JW00.html" target="_blank" data-icon="no-icon" data-beacon-expo="qn_elementid=yw3_3&qn_event_type=show" data-beacon-click="qn_elementid=yw3_3&qn_event_type=click" newsexpo="yw3_3">环球漫评</a>
      </li>

          
      <li class=" ">
          <a class="" href="https://new.qq.com/omn/20211123/20211123A01IBQ00.html" target="_blank" data-beacon-expo="qn_elementid=yw4_1&qn_event_type=show" data-beacon-click="qn_elementid=yw4_1&qn_event_type=click" newsexpo="yw4_1" style="">中央网信办发文规范娱乐明星网上信息</a>
      
      </li>

          
      <li class=" ">
          <a class="" href="https://new.qq.com/omn/TWF20211/TWF2021112300540500.html" target="_blank" data-beacon-expo="qn_elementid=yw5_1&qn_event_type=show" data-beacon-click="qn_elementid=yw5_1&qn_event_type=click" newsexpo="yw5_1" style="">百年经验告诉我们未来怎样继续成功</a>
      
      </li>

          
      <li class=" ">
          <a class="" href="https://new.qq.com/omn/20211122/20211122A07GOR00.html" target="_blank" data-beacon-expo="qn_elementid=yw6_1&qn_event_type=show" data-beacon-click="qn_elementid=yw6_1&qn_event_type=click" newsexpo="yw6_1" style="">通讯：中国煤炭大市鄂尔多斯“保供”记</a>
      
      </li>

          
      <li class=" ">
          <a class="" href="https://new.qq.com/omn/20211123/20211123A036MI00.html" target="_blank" data-beacon-expo="qn_elementid=yw7_1&qn_event_type=show" data-beacon-click="qn_elementid=yw7_1&qn_event_type=click" newsexpo="yw7_1" style="">弘扬“老西藏精神” 激发奋进力量</a>
      
      </li>

          
      <li class=" ">
          <a class="" href="https://new.qq.com/omn/20211123/20211123A04Q6100.html" target="_blank" data-beacon-expo="qn_elementid=yw8_1&qn_event_type=show" data-beacon-click="qn_elementid=yw8_1&qn_event_type=click" newsexpo="yw8_1" style="">《长津湖》在香港热映：一堂生动的爱国主义教育课</a>
      
      </li>

        </ul><!--a2ccc477ebfc35f5ac367528bbd10f43-->
                  <style type="text/css">
    .news_color_3{color:#0c82ff!important;}
    .news_color_4{color:#df5147!important;}
    </style>

    <ul class="yw-list" bosszone="yw_2">
              <li class="news-pic-txt cf">
          <div class="pic fl">
            <a href="https://new.qq.com/omn/20211123/20211123A017WG00.html" target="_blank" data-beacon-expo="qn_elementid=yw9_1&qn_event_type=show" data-beacon-click="qn_elementid=yw9_1&qn_event_type=click" newsexpo="yw9_1">
              <img src="//inews.gtimg.com/newsapp_ls/0/14213269632_640330/0" alt="台湾远东集团被大陆重罚，岛内猜测：大陆出手震慑“台独”金主">
            </a>
          </div>
          <div class="txt fl">
            <a href="https://new.qq.com/omn/20211123/20211123A017WG00.html" target="_blank" data-beacon-expo="qn_elementid=yw9_1&qn_event_type=show" data-beacon-click="qn_elementid=yw9_1&qn_event_type=click" newsexpo="yw9_1">台湾远东集团被大陆重罚，岛内猜测：大陆出手震慑“台独”金主</a>
            <div class="info">
              <a href="https://new.qq.com/omn/20211123/20211123A017WG00.html" target="_blank">
                
              </a>
            </div>
          </div>
        </li>
            <li>
                  <a class="" href="https://new.qq.com/omn/20211122/20211122A05DPS00.html" target="_blank" newsexpo="yw10_1" data-beacon-expo="qn_elementid=yw10_1&qn_event_type=show" data-beacon-click="qn_elementid=yw10_1&qn_event_type=click">东西问｜姜鹏：“中国天眼”为何能吸引世界瞩目？</a>
              </li>
            <li>
                  <a class="" href="https://new.qq.com/omn/20211122/20211122A08WXZ00.html" target="_blank" newsexpo="yw11_1" data-beacon-expo="qn_elementid=yw11_1&qn_event_type=show" data-beacon-click="qn_elementid=yw11_1&qn_event_type=click">新冠死亡人数超去年，美国抗疫“从失败走向失败”</a>
              </li>
            <li>
                  <a class=" news_color_2" href="https://new.qq.com/omn/20211123/20211123A01O3K00.html" target="_blank" newsexpo="yw12_1" data-beacon-expo="qn_elementid=yw12_1&qn_event_type=show" data-beacon-click="qn_elementid=yw12_1&qn_event_type=click">韩媒：韩国前总统全斗焕去世，终年90岁</a>
              </li>
            <li>
                  <a class="" href="https://new.qq.com/omn/20211123/20211123A0156F00.html" target="_blank" newsexpo="yw13_1" data-beacon-expo="qn_elementid=yw13_1&qn_event_type=show" data-beacon-click="qn_elementid=yw13_1&qn_event_type=click">绿媒紧盯：解放军6架次军机昨进入台西南空域，全是战机</a>
              </li>
            <li>
                  <a class="" href="https://new.qq.com/omn/20211123/20211123A00JRB00.html" target="_blank" newsexpo="yw14_1" data-beacon-expo="qn_elementid=yw14_1&qn_event_type=show" data-beacon-click="qn_elementid=yw14_1&qn_event_type=click">拜登放话参加2024年大选，多家外媒认为拜登在“虚张声势”</a>
              </li>
            <li>
                  <a class="" href="https://new.qq.com/omn/20211123/20211123A01BQE00.html" target="_blank" newsexpo="yw15_1" data-beacon-expo="qn_elementid=yw15_1&qn_event_type=show" data-beacon-click="qn_elementid=yw15_1&qn_event_type=click">网红雪梨、林珊珊偷税被罚敲警钟 年底直播业将迎补税潮</a>
              </li>
                        </ul><ul class="yw-list" bosszone="yw_3">
            <li class="news-pic-txt cf">
          <div class="pic fl">
            <a href="https://new.qq.com/omn/20211122/20211122V0BLP400.html" target="_blank" data-beacon-expo="qn_elementid=yw16_1&qn_event_type=show" data-beacon-click="qn_elementid=yw16_1&qn_event_type=click" newsexpo="yw16_1">
              <img src="//inews.gtimg.com/newsapp_ls/0/14211909764_640330/0" alt="武汉女子拿命控告遛狗不牵绳 父亲：代价太大 警方未立案">
            </a>
          </div>
          <div class="txt fl">
            <a href="https://new.qq.com/omn/20211122/20211122V0BLP400.html" target="_blank" data-beacon-expo="qn_elementid=yw16_1&qn_event_type=show" data-beacon-click="qn_elementid=yw16_1&qn_event_type=click" newsexpo="yw16_1">武汉女子拿命控告遛狗不牵绳 父亲：代价太大 警方未立案</a>
            <div class="info">
              <a href="https://new.qq.com/omn/20211122/20211122V0BLP400.html" target="_blank">
                
              </a>
            </div>
          </div>
        </li>
            <li>
                  <a class="" href="https://new.qq.com/omn/20211122/20211122A0DG7Z00.html" target="_blank" newsexpo="yw17_1" data-beacon-expo="qn_elementid=yw17_1&qn_event_type=show" data-beacon-click="qn_elementid=yw17_1&qn_event_type=click">4名经验丰富的地质人员何以迷失大山 专业人士分析多种可能</a>
              </li>
            <li>
                  <a class="" href="https://new.qq.com/omn/20211122/20211122A0DFBD00.html" target="_blank" newsexpo="yw18_1" data-beacon-expo="qn_elementid=yw18_1&qn_event_type=show" data-beacon-click="qn_elementid=yw18_1&qn_event_type=click">“花农民百万建毛坯房”设计师住房疑似违建 当地城管回应</a>
              </li>
            <li>
                  <a class="" href="https://new.qq.com/omn/20211123/20211123A017TB00.html" target="_blank" newsexpo="yw19_1" data-beacon-expo="qn_elementid=yw19_1&qn_event_type=show" data-beacon-click="qn_elementid=yw19_1&qn_event_type=click">深圳“中介改革”背后：已关店642家，不吃差价怎么活下去</a>
              </li>
            <li>
                  <a class="" href="https://new.qq.com/omn/20211122/20211122A07Z2C00.html" target="_blank" newsexpo="yw20_1" data-beacon-expo="qn_elementid=yw20_1&qn_event_type=show" data-beacon-click="qn_elementid=yw20_1&qn_event_type=click">“8块的面你害了多少人”郑州老板疑因面价太低遭同行掌掴</a>
              </li>
            <li>
                  <a class="" href="https://new.qq.com/omn/20211122/20211122A06XOV00.html" target="_blank" newsexpo="yw21_1" data-beacon-expo="qn_elementid=yw21_1&qn_event_type=show" data-beacon-click="qn_elementid=yw21_1&qn_event_type=click">南京一法院判决书出现“安徽省南京市” 回应称系失误已改</a>
              </li>
      </ul><!--fa36af4a712a084da2bed672b957f927-->
                </div>
                <!-- /要闻 -->

                <!-- 抗肺炎 -->
                <div id="tab-news-02" class="tab-news" data-beacon-expo="qn_elementid=antip_yw&qn_event_type=show" data-beacon-click="qn_elementid=antip_yw&qn_event_type=click" bossexpo="antip_yw" style="display:none;">
                  <div id="scaleContainer" style="display:none;" data-src="https://mat1.gtimg.com/rain/apub2019/ddea48edb444.qq_top1x1.svg">
                    <a id="antip_charts" style="text-decoration: none;" href="https://news.qq.com//zt2020/page/feiyan.htm" target="_blank" bosszone="antip_click" >
                      <div class="head"></div>
                      <div class="topdataWrap">
                        <div class="antip_timeNum">
                          <div class="bottom">
                            <p class="d"></p>
                          </div>
                        </div>
                        <div class="antip_recentNumber">
                          <div class="antip_icbar confirm">
                            <div class="add">较上日<span>+</span></div>
                            <div class="number">0</div>
                            <div class="text">全国确诊</div>
                          </div>
                          <div class="antip_icbar suspect">
                            <div class="add">较上日<span>+</span></div>
                            <div class="number">0</div>
                            <div class="text">疑似病例</div>
                          </div>
                          <div class="antip_icbar cure">
                            <div class="add">较上日<span>+</span></div>
                            <div class="number">0</div>
                            <div class="text">治愈人数</div>
                          </div>
                          <div class="antip_icbar dead">
                            <div class="add">较上日<span>+</span></div>
                            <div class="number">0</div>
                            <div class="text">死亡人数</div>
                          </div>
                        </div>
                      </div>
                    </a>
                  </div>
                  <ul class="yw-list" bosszone="antip_1">
            <li class="news-top"><a href="https://new.qq.com/omn/20211123/20211123A04MH300.html" target="_blank">四川：成都全域降为低风险区 隔离居民相拥而泣</a></li>
                <li><a href="https://new.qq.com/omn/20211123/20211123A08JL600.html" target="_blank">法国总理确诊新冠 比利时首相成“密接”</a></li>
                <li><a href="https://new.qq.com/omn/20211123/20211123A0AA8Q00.html" target="_blank">疫情期间发布不当言论，广西一男子被行拘5日</a></li>
                <li><a href="https://new.qq.com/omn/20211123/20211123A09EHY00.html" target="_blank">《黑客帝国4》确认引进，导演因疫情一度想放弃拍摄</a></li>
                <li><a href="https://new.qq.com/omn/20211123/20211123A07YK900.html" target="_blank">欧洲再成全球新冠疫情“震中”反防疫示威却持续不断</a></li>
                <li><a href="https://new.qq.com/omn/20211123/20211123A05E6A00.html" target="_blank">江西现有确诊病例2例 上饶信州区开展第十轮区域核酸筛查</a></li>
                <li><a href="https://new.qq.com/omn/20211123/20211123A07XMN00.html" target="_blank">国家卫健委：昨日新增确诊病例19例 其中本土5例</a></li>
                <li><a href="https://new.qq.com/omn/20211123/20211123A049VL00.html" target="_blank">成都市发改委：受疫情影响的企业和在征集年度的可缓缴社保费</a></li>
                        </ul><ul class="yw-list" bosszone="antip_2">
        <li class="news-pic-txt cf">
          <div class="pic fl">
            <a href="https://new.qq.com/omn/20211123/20211123A04S8V00.html" target="_blank">
                        <img src="//inews.gtimg.com/newsapp_ls/0/14214267892_640330/0" alt="最后1名患者今日出院，贵州本轮新冠肺炎确诊病例清零">
                      </a>
          </div>
          <div class="txt fl">
            <a href="https://new.qq.com/omn/20211123/20211123A04S8V00.html" target="_blank">最后1名患者今日出院，贵州本轮新冠肺炎确诊病例清零</a>
            <div class="info">
              <a href="https://new.qq.com/omn/20211123/20211123A04S8V00.html" target="_blank">
                          </a>
            </div>
          </div>
        </li>
                      <li><a href="https://new.qq.com/omn/20211123/20211123A04IL800.html" target="_blank">北京市平谷区疫情防控快严准 “防”出零病例</a></li>
                      <li><a href="https://new.qq.com/omn/20211123/20211123A04HNN00.html" target="_blank">日本日增新冠确诊病例50例 创今年新低</a></li>
                      <li><a href="https://new.qq.com/omn/20211123/20211123A04WFE00.html" target="_blank">疫情冲击 泰国失业率创14年来最高</a></li>
                      <li><a href="https://new.qq.com/omn/20211123/20211123A04OTJ00.html" target="_blank">希腊又一部长确诊 政府和专家对防疫封锁各持己见</a></li>
                      <li><a href="https://new.qq.com/omn/20211123/20211123A02OZK00.html" target="_blank">北京朝阳平房：最美夫妻志愿者 防疫战线急先锋</a></li>
                      <li><a href="https://new.qq.com/omn/20211123/20211123A01JLT00.html" target="_blank">辽宁省新增4例本土新冠肺炎确诊病例 为大连市报告</a></li>
                              </ul><ul class="yw-list" bosszone="antip_3">
        <li class="news-pic-txt cf">
          <div class="pic fl">
            <a href="https://new.qq.com/omn/20211123/20211123A01JBQ00.html" target="_blank">
                        <img src="//inews.gtimg.com/newsapp_ls/0/14213383092_640330/0" alt="云南：瑞丽新增1例本土确诊病例">
                      </a>
          </div>
          <div class="txt fl">
            <a href="https://new.qq.com/omn/20211123/20211123A01JBQ00.html" target="_blank">云南：瑞丽新增1例本土确诊病例</a>
            <div class="info">
              <a href="https://new.qq.com/omn/20211123/20211123A01JBQ00.html" target="_blank">
                          </a>
            </div>
          </div>
        </li>
                      <li><a href="https://new.qq.com/omn/20211123/20211123A02MIP00.html" target="_blank">罗马尼亚在第四波疫情中苦苦挣扎：太平间外尸体堆积如山</a></li>
                      <li><a href="https://new.qq.com/omn/20211123/20211123A021L100.html" target="_blank">欧洲再成全球新冠疫情“震中”</a></li>
                      <li><a href="https://new.qq.com/omn/20211123/20211123A00YZL00.html" target="_blank">世卫组织：全球新冠肺炎确诊病例超2.5696亿例</a></li>
                      <li><a href="https://new.qq.com/omn/20211123/20211123A013G500.html" target="_blank">美国累计确诊新冠肺炎病例超4784万例</a></li>
                      <li><a href="https://new.qq.com/omn/20211123/20211123A013MI00.html" target="_blank">法国总理卡斯泰新冠病毒检测结果呈阳性</a></li>
        </ul>
                </div>
                <!-- /抗肺炎 -->

                <!-- 地方新闻 -->
                <div id="tab-news-03" class="tab-news undis" bossexpo="bg_dfz">
                  <ul class="yw-list" bosszone="dfz_1">
            <li class="news-top"><a href="https://new.qq.com/omn/20200701/20200701A04H7500" target="_blank">北京昨日新增报告3例确诊病例 均在大兴区</a></li>
              <li><a href="https://new.qq.com/omn/20200701/20200701A03LEM00" target="_blank">今明两天北京雷雨频繁 外出需注意防雷避雨</a></li>
              <li><a href="https://new.qq.com/omn/20200701/20200630A0SSK000" target="_blank">新发地周边12个封闭管控小区6月30日起依规解封</a></li>
              <li><a href="https://new.qq.com/omn/20200701/20200630A0SEID00" target="_blank">张文宏：北京疫情只是小范围反弹，中国拒绝第二波疫情</a></li>
              <li><a href="https://new.qq.com/omn/20200701/BJC2020063000998300" target="_blank">北京发布病例详情 多名隔离人员发病不报告</a></li>
              <li><a href="https://new.qq.com/omn/20200701/BJC2020063000799200" target="_blank">北京多人隔离14天后确诊，专家称有两方面原因</a></li>
              <li><a href="https://new.qq.com/omn/20200701/20200630A0A2VC00" target="_blank">北京市银行停业一周？五大行辟谣：仅个别风险区网点暂停</a></li>
              <li><a href="https://new.qq.com/omn/20200701/20200630A0PE5200" target="_blank">北京6月30日有3地疫情风险等级降级</a></li>
                      </ul><ul class="yw-list" bosszone="dfz_2">
        <li class="news-pic-txt cf">
          <div class="pic fl">
            <a href="https://new.qq.com/omn/20200701/20200630A0PPY900" target="_blank">
              <img src="//inews.gtimg.com/newsapp_ls/0/12013918816_640330/0" alt="看“病毒侦探”如何工作：透视北京疫情流调三大焦点">
            </a>
          </div>
          <div class="txt fl">
            <a href="https://new.qq.com/omn/20200701/20200630A0PPY900" target="_blank">看“病毒侦探”如何工作：透视北京疫情流调三大焦点</a>
            <div class="info">
              <a href="https://new.qq.com/omn/20200701/20200630A0PPY900" target="_blank">
                北京日报客户端
              </a>
            </div>
          </div>
        </li>
                    <li><a href="https://new.qq.com/omn/20200701/20200630A0JTXV00" target="_blank">北京：已经出院的新冠肺炎患者 未发现人传人现象</a></li>
                    <li><a href="https://new.qq.com/omn/20200701/20200630A0JMSN00" target="_blank">北京：此次疫情重症和危重症患者比例明显偏低</a></li>
                    <li><a href="https://new.qq.com/omn/20200701/20200630A0JVY300" target="_blank">北京：二级以上医疗机构非急诊全面预约实行常态化机制</a></li>
                    <li><a href="https://new.qq.com/omn/20200701/20200630A0OLGM00" target="_blank">7月1日起，北京公积金账户余额可直接用来还贷款了！</a></li>
                    <li><a href="https://new.qq.com/omn/20200701/20200630A0URPY00" target="_blank">北京57家公立医疗机构核酸检测预约电话公布</a></li>
                    <li><a href="https://new.qq.com/omn/20200701/20200630A0M75V00" target="_blank">北京近4日有37例确诊病例来自集中隔离点</a></li>
                            </ul><ul class="yw-list" bosszone="dfz_3">
        <li class="news-pic-txt cf">
          <div class="pic fl">
            <a href="https://new.qq.com/omn/20200701/20200701A03PSY00" target="_blank">
              <img src="//inews.gtimg.com/newsapp_ls/0/12016212561_640330/0" alt="“圈定”确诊送餐员活动轨迹，他有这些妙招">
            </a>
          </div>
          <div class="txt fl">
            <a href="https://new.qq.com/omn/20200701/20200701A03PSY00" target="_blank">“圈定”确诊送餐员活动轨迹，他有这些妙招</a>
            <div class="info">
              <a href="https://new.qq.com/omn/20200701/20200701A03PSY00" target="_blank">
                北京日报客户端
              </a>
            </div>
          </div>
        </li>
                    <li><a href="https://new.qq.com/omn/20200701/20200630A0IXXO00" target="_blank">新发地市场一个体经营人员先被诊断为疑似后确诊</a></li>
                    <li><a href="https://new.qq.com/omn/20200701/20200630A0OF6200" target="_blank">朝阳一诊所因擅自接诊发热患者被停业整顿 当事人被行拘</a></li>
                    <li><a href="https://new.qq.com/omn/20200701/20200630A06N0K00" target="_blank">顺义累计采集30余万份样本，结果均为阴性</a></li>
                    <li><a href="https://new.qq.com/omn/20200701/20200630A06TMZ00" target="_blank">大兴黄村约谈职能部门，加强企业防疫监管力度</a></li>
                    <li><a href="https://new.qq.com/omn/20200701/20200630A0I3XN00" target="_blank">女子与男友吵架 深夜往楼下扔菜刀被控制</a></li>
      </ul><!--991636fbe8c375d613bd50eeee5dadad--><!--[if !IE]>|xGv00|e15d36cd2e0736bada6acb6250ab238f<![endif]-->
                </div>
                <!-- /地方新闻 -->

              </div>
            </div>
          </div>
          <div class="col col-2 fl">

            <!-- 今日话题 -->
            <div class="mod m-topic" data-beacon-expo="qn_elementid=bg_jrht&qn_event_type=show" data-beacon-click="qn_elementid=bg_jrht&qn_event_type=click" bossexpo="bg_jrht">
      <div class="hd cf">
        <h2 class="tit active"><a bosszone="jrht_logo">今日话题</a></h2>
      </div>
      <div class="bd">
        <ul class="news-list">
                      <li class="news-top" bosszone="jrht_1">
              <a href="https://new.qq.com/omn/20211123/20211123A026R600.html" target="_blank">我国进一步强化地下水节约保护、超采治理和污染防治</a>
            </li>
                            <li bosszone="jrht_2">
                                                        <a class="cate" href="https://new.qq.com/omn/author/1124" target="_blank">中国新闻网</a><span class="line">|</span>
                                                            <a href="https://new.qq.com/omn/20211123/20211123A0282Y00.html" target="_blank">什么是北大荒精神？</a>
                                                </li>
                            <li bosszone="jrht_3">
                                                        <a class="cate" href="https://new.qq.com/omn/author/5215397" target="_blank">光明网</a><span class="line">|</span>
                                                            <a href="https://new.qq.com/omn/20211123/20211123A0271300.html" target="_blank">北京冬奥就这样一点一点“绿”起来</a>
                                                </li>
                            <li bosszone="jrht_4">
                                                        <a class="cate" href="https://new.qq.com/omn/author/5161561" target="_blank">经济日报</a><span class="line">|</span>
                                                            <a href="https://new.qq.com/omn/20211123/20211123A00WJ500.html" target="_blank">丰富绿色低碳发展政策工具</a>
                                                </li>
                            <li bosszone="jrht_5">
                                                        <a class="cate" href="https://new.qq.com/omn/author/5376464" target="_blank">中新经纬</a><span class="line">|</span>
                                                            <a href="https://new.qq.com/omn/20211123/20211123A01GLD00.html" target="_blank">中央网信办要求严把娱乐明星网上信息内容导向</a>
                                                </li>
                            <li bosszone="jrht_6">
                                                        <a class="cate" href="https://new.qq.com/omn/author/26082" target="_blank">环球网</a><span class="line">|</span>
                                                            <a href="https://new.qq.com/omn/20211123/20211123A026JV00.html" target="_blank">“五个一百”，释放向上向善的正能量</a>
                                                </li>
                            <li bosszone="jrht_7">
                                                        <a class="cate" href="https://new.qq.com/omn/author/5013601" target="_blank">政知圈</a><span class="line">|</span>
                                                            <a href="https://new.qq.com/omn/20211122/20211122A0CJD300.html" target="_blank">全国唯一！省级政府一把手兼任市委书记</a>
                                                </li>
                  </ul>
      </div>
    </div><!--b407ace3951798e4c1ad779374f26738-->
            <!-- /今日话题 -->

            <!-- 原创 十三邀 -->
            <div class="mod m-yao13" bossexpo="bg_ycsp">
      <div class="hd-2 cf" style="height:50px;">
        <h2 class="tit active">
                            <a href="http://v.qq.com/detail/8/90168.html" target="_blank" data-beacon-expo="qn_elementid=ycsp_logo&qn_event_type=show" data-beacon-click="qn_elementid=ycsp_logo&qn_event_type=click" bosszone="ycsp_logo">
                <img src="https://inews.gtimg.com/newsapp_bt/0/1119110750197_6866/0" alt="未来新世界">
              </a>
                                                                                                          </h2>
      </div>
      <div class="bd" style="margin-top:-14px;">
        <ul class="news-list">
                                            <li class="news-pic-txt cf" data-beacon-expo="qn_elementid=ycsp_2&qn_event_type=show" data-beacon-click="qn_elementid=ycsp_2&qn_event_type=click" bosszone="ycsp_2">
                <div class="pic video-box click-drag-play fl" bossvv="vv_ycsp">
                  <img src="https://inews.gtimg.com/newsapp_bt/0/1119110830244_6568/0" alt="真假蒋昌建在线PK，你愿意让机器人代替你活下去吗">
                  <i class="q-icons icon-play2"></i>
                  <div class="txt undis">真假蒋昌建在线PK，你愿意让机器人代替你活下去吗</div>
                  <div class="desc undis">t33092deon3</div>
                  <div id="mod-player4" class="mod-player" data-vid="t33092deon3" data-url="https://new.qq.com/newsvideo.htm#/cover/mzc002007g3egar/t33092deon3" style="display: none;"></div>
                  <div class="click-layer"></div>
                </div>
                <div class="txt fl">
                  <a href="https://new.qq.com/newsvideo.htm#/cover/mzc002007g3egar/t33092deon3" target="_blank">真假蒋昌建在线PK，你愿意让机器人代替你活下去吗</a>
                  <div class="info">

                  </div>
                </div>
              </li>
                                              <li data-beacon-expo="qn_elementid=ycsp_3&qn_event_type=show" data-beacon-click="qn_elementid=ycsp_3&qn_event_type=click" bosszone="ycsp_3">
                                            <a href="https://new.qq.com/newsvideo.htm#/cover/mzc002007g3egar/u330845b8kr" target="_blank">【看点】母亲希望把儿子做成机器人：他工作忙没时间回来</a>
                          </li>
                                              <li data-beacon-expo="qn_elementid=ycsp_4&qn_event_type=show" data-beacon-click="qn_elementid=ycsp_4&qn_event_type=click" bosszone="ycsp_4">
                                            <a href="https://new.qq.com/newsvideo.htm#/cover/mzc002007g3egar/f3308jmosih" target="_blank">【看点】为了钱命都不要了？傅首尔自称不需要很长时间的睡</a>
                          </li>
                                              <li data-beacon-expo="qn_elementid=ycsp_5&qn_event_type=show" data-beacon-click="qn_elementid=ycsp_5&qn_event_type=click" bosszone="ycsp_5">
                                                                                <a class="cate q-icons icon-video" href="https://v.qq.com/detail/8/90177.html" target="_blank">亲爱的小店</a><span class="line">|</span>
                                                                    <a href="https://new.qq.com/newsvideo.htm#/cover/mzc00200nkxg8tr/d3309ufg4ip" target="_blank">千万人开餐馆，为什么只有他成功了？</a>
                                                        </li>
                                              <li data-beacon-expo="qn_elementid=ycsp_6&qn_event_type=show" data-beacon-click="qn_elementid=ycsp_6&qn_event_type=click" bosszone="ycsp_6">
                                                                                <a class="cate q-icons icon-video" href="https://v.qq.com/detail/8/90104.html" target="_blank">和陌生人说话</a><span class="line">|</span>
                                                                    <a href="https://new.qq.com/newsvideo.htm#/cover/mzc002007dfb4m0/r3310kmpjhm" target="_blank">陈晓楠对话乔任梁父母</a>
                                                        </li>
                                              <li data-beacon-expo="qn_elementid=ycsp_7&qn_event_type=show" data-beacon-click="qn_elementid=ycsp_7&qn_event_type=click" bosszone="ycsp_7">
                                                                                <a class="cate q-icons icon-video" href="https://v.qq.com/detail/8/89720.html" target="_blank">财约你</a><span class="line">|</span>
                                                                    <a href="https://new.qq.com/newsvideo.htm#/cover/mzc00200opqfvwk/c3309mgjqso" target="_blank">放纵的人活不长？自律的人更容易活下来</a>
                                                        </li>
                          </ul>
      </div>
    </div><!--963d3b6aee790c9d44b5952951717b93-->
            <!-- /原创 十三邀 -->

            <!-- 图话 -->
            <div class="mod m-picture" bossexpo="bg_th">
              <div class="hd-2 cf">
                <h2 class="tit active">
                  <a href="https://new.qq.com/ch/photo" target="_blank" data-beacon-expo="qn_elementid=jrht_logo&qn_event_type=show" data-beacon-click="qn_elementid=jrht_logo&qn_event_type=click" bosszone="th_logo">图话</a>
                </h2>
              </div>
              <div class="bd">
                <ul class="news-list">
                        <li class="v-item news-pic-txt cf" data-beacon-expo="qn_elementid=jrht_1&qn_event_type=show" data-beacon-click="qn_elementid=jrht_1&qn_event_type=click" bosszone="th_1">
          <div class="pic fl">
            <a href="https://new.qq.com/rain/a/20211116V0322F00" target="_blank">
              <img src="//inews.gtimg.com/newsapp_ls/0/14184989732_640330/0" alt="北漂三年毅然回乡，她跑遍了各大粮油市场，却决定当主播">
            </a>
          </div>
          <div class="txt fl">
            <a href="https://new.qq.com/rain/a/20211116V0322F00" target="_blank">北漂三年毅然回乡，她跑遍了各大粮油市场，却决定当主播</a>
            <div class="info">
              <a href="https://new.qq.com/rain/a/20211116V0322F00" target="_blank">
                中国人的一天第3975期
              </a>
            </div>
          </div>
        </li>
            <li class="v-item" data-beacon-expo="qn_elementid=jrht_2&qn_event_type=show" data-beacon-click="qn_elementid=jrht_2&qn_event_type=click" bosszone="th_2">
                                                    <a class="cate q-icons icon-pic" href="https://new.qq.com/omn/author/15329577" target="_blank">萤火计划</a><span class="line">|</span>
                                            <a href="https://new.qq.com/rain/a/20211120A03WBJ00" target="_blank">双胞胎出生即患病，父亲：坚持还是放弃？</a>
                                </li>
      <!--0134db4060335a8b56af21223054a7f4-->
                        <li class="v-item" data-beacon-expo="qn_elementid=jrht_3&qn_event_type=show" data-beacon-click="qn_elementid=jrht_3&qn_event_type=click" bosszone="th_1">
                                                  <a  class="cate q-icons icon-pic" href="https://new.qq.com/omn/author/5505476" target="_blank">谷雨</a><span class="line">|</span>
                                            <a href="https://new.qq.com/rain/a/20211120A06H9T00" target="_blank">当代佛系打工人：不泡夜店泡公园，蹲点找快乐</a>
                                </li>
      <!--7a54c0016879707f2e08d252b9063c5f-->
                        <li class="v-item" data-beacon-expo="qn_elementid=jrht_4&qn_event_type=show" data-beacon-click="qn_elementid=jrht_4&qn_event_type=click" bosszone="th_1">
                                                  <a  class="cate q-icons icon-pic" href="http://sports.qq.com/photo/" target="_blank">体坛</a><span class="line">|</span>
                                            <a href="http://view.inews.qq.com/a/20211123A016MZ00" target="_blank">300万还是800万？李铁年薪引发媒体人争论</a>
                                </li>
      <!--f96df7344520bb9749b7bfc416410639-->
                        <li class="v-item" data-beacon-expo="qn_elementid=jrht_5&qn_event_type=show" data-beacon-click="qn_elementid=jrht_5&qn_event_type=click" bosszone="th_1">
                                                  <a  class="cate q-icons icon-pic" href="https://new.qq.com/ch/ent/" target="_blank">娱乐</a><span class="line">|</span>
                                            <a href="https://new.qq.com/rain/a/20211111A07XE800" target="_blank">她们这是集体颜值回春了？</a>
                                </li>
      <!--6384406209b138a0c9bc0c8dab5b98ec-->
                        <li class="v-item" data-beacon-expo="qn_elementid=jrht_6&qn_event_type=show" data-beacon-click="qn_elementid=jrht_6&qn_event_type=click" bosszone="th_1">
                                                  <a  class="cate q-icons icon-pic" href="https://new.qq.com/ch/fashion/" target="_blank">时尚圈</a><span class="line">|</span>
                                            <a href="https://new.qq.com/omn/20211117/20211117A01E7200.html" target="_blank">其实，博物馆也是老美妆达人了</a>
                                </li>
      <!--a5308490a959cb0db58d143a796e1a28-->
                </ul>
              </div>
            </div>
            <!-- /图话 -->

          </div>
          <div class="col col-3 fr">

            <!-- 产品 -->
            <div id="m-product" class="m-product">
      <ul class="list f14">
                                                                                    <li class="q-icons prod-1">
                                                    <a href="http://news.qq.com/mobile/"  target="_blank" data-beacon-expo="qn_elementid=cp_1_1_1&qn_event_type=show" data-beacon-click="qn_elementid=cp_1_1_1&qn_event_type=click" bosszone="cp_1_1_1">新闻APP</a>
                                      <a href="http://sports.qq.com/kbsweb/"  target="_blank" data-beacon-expo="qn_elementid=cp_1_1_2&qn_event_type=show" data-beacon-click="qn_elementid=cp_1_1_2&qn_event_type=click" bosszone="cp_1_1_2">体育APP</a>
                                      <a href="http://meeting.tencent.com/activities/index.html?fromSource=sem70"  target="_blank" data-beacon-expo="qn_elementid=cp_1_1_3&qn_event_type=show" data-beacon-click="qn_elementid=cp_1_1_3&qn_event_type=click" bosszone="cp_1_1_3">会议</a>
                                      <a href="https://om.qq.com/userAuth/index"  target="_blank" data-beacon-expo="qn_elementid=cp_1_1_4&qn_event_type=show" data-beacon-click="qn_elementid=cp_1_1_4&qn_event_type=click" bosszone="cp_1_1_4">企鹅号</a>
                                      <a href="http://kuaibao.qq.com/"  target="_blank" data-beacon-expo="qn_elementid=cp_1_1_5&qn_event_type=show" data-beacon-click="qn_elementid=cp_1_1_5&qn_event_type=click" bosszone="cp_1_1_5">快报</a>
                                      <a href="http://v.qq.com/download.html#pc"  target="_blank" data-beacon-expo="qn_elementid=cp_1_1_6&qn_event_type=show" data-beacon-click="qn_elementid=cp_1_1_6&qn_event_type=click" bosszone="cp_1_1_6">视频</a>
                                      <a href="https://browser.qq.com/"  target="_blank" data-beacon-expo="qn_elementid=cp_1_1_7&qn_event_type=show" data-beacon-click="qn_elementid=cp_1_1_7&qn_event_type=click" bosszone="cp_1_1_7">浏览器</a>
                                      <a href="http://www.weishi.com/"  target="_blank" data-beacon-expo="qn_elementid=cp_1_1_8&qn_event_type=show" data-beacon-click="qn_elementid=cp_1_1_8&qn_event_type=click" bosszone="cp_1_1_8">微视</a>
                                            </li>
                                    <li class="q-icons prod-2">
                                                    <a href="http://weixin.qq.com/"  target="_blank" data-beacon-expo="qn_elementid=cp_1_2_1&qn_event_type=show" data-beacon-click="qn_elementid=cp_1_2_1&qn_event_type=click" bosszone="cp_1_2_1">微信</a>
                                      <a href="https://im.qq.com/index.shtml"  target="_blank" data-beacon-expo="qn_elementid=cp_1_2_2&qn_event_type=show" data-beacon-click="qn_elementid=cp_1_2_2&qn_event_type=click" bosszone="cp_1_2_2">QQ</a>
                                      <a href="https://qzone.qq.com/"  target="_blank" data-beacon-expo="qn_elementid=cp_1_2_3&qn_event_type=show" data-beacon-click="qn_elementid=cp_1_2_3&qn_event_type=click" bosszone="cp_1_2_3">空间</a>
                                      <a href="https://work.weixin.qq.com/wework_admin/register_wx?from=regopt_tlogo_wxcbar_tengxunwang"  target="_blank" data-beacon-expo="qn_elementid=cp_1_2_4&qn_event_type=show" data-beacon-click="qn_elementid=cp_1_2_4&qn_event_type=click" bosszone="cp_1_2_4">企业微信</a>
                                      <a href="https://mail.qq.com/cgi-bin/loginpage"  target="_blank" data-beacon-expo="qn_elementid=cp_1_2_5&qn_event_type=show" data-beacon-click="qn_elementid=cp_1_2_5&qn_event_type=click" bosszone="cp_1_2_5">邮箱</a>
                                      <a href="https://cloud.tencent.com/?fromSource=gwzcw.756432.756432.756432"  target="_blank" data-beacon-expo="qn_elementid=cp_1_2_6&qn_event_type=show" data-beacon-click="qn_elementid=cp_1_2_6&qn_event_type=click" bosszone="cp_1_2_6">腾讯云</a>
                                      <a href="https://guanjia.qq.com/?ADTAG=news.qqcom"  target="_blank" data-beacon-expo="qn_elementid=cp_1_2_7&qn_event_type=show" data-beacon-click="qn_elementid=cp_1_2_7&qn_event_type=click" bosszone="cp_1_2_7">电脑管家</a>
                                      <a href="https://vip.qq.com/"  target="_blank" data-beacon-expo="qn_elementid=cp_1_2_8&qn_event_type=show" data-beacon-click="qn_elementid=cp_1_2_8&qn_event_type=click" bosszone="cp_1_2_8">会员</a>
                                            </li>
                                    <li class="q-icons prod-3">
                                                    <a href="http://lol.qq.com/index.shtml?ADTAG=media.innerenter.qqcom.index_navigation"  target="_blank" data-beacon-expo="qn_elementid=cp_1_3_1&qn_event_type=show" data-beacon-click="qn_elementid=cp_1_3_1&qn_event_type=click" bosszone="cp_1_3_1">LOL</a>
                                      <a href="http://dnf.qq.com/?ADTAG=media.innerenter.qqcom.index_navigation"  target="_blank" data-beacon-expo="qn_elementid=cp_1_3_2&qn_event_type=show" data-beacon-click="qn_elementid=cp_1_3_2&qn_event_type=click" bosszone="cp_1_3_2">DNF</a>
                                      <a href="http://cf.qq.com/?ADTAG=media.innerenter.qqcom.index_navigation"  target="_blank" data-beacon-expo="qn_elementid=cp_1_3_3&qn_event_type=show" data-beacon-click="qn_elementid=cp_1_3_3&qn_event_type=click" bosszone="cp_1_3_3">CF</a>
                                      <a href="http://pvp.qq.com/?ADTAG=media.innerenter.qqcom.index_navigation"  target="_blank" data-beacon-expo="qn_elementid=cp_1_3_4&qn_event_type=show" data-beacon-click="qn_elementid=cp_1_3_4&qn_event_type=click" bosszone="cp_1_3_4">王者</a>
                                      <a href="https://gouhuo.qq.com/?ADTAG=QQHOME"  target="_blank" data-beacon-expo="qn_elementid=cp_1_3_5&qn_event_type=show" data-beacon-click="qn_elementid=cp_1_3_5&qn_event_type=click" bosszone="cp_1_3_5">单机游戏</a>
                                      <a href="http://huoying.qq.com/act/a20141009landingpage/index.htm?via=45&ADTAG=ied.neiguang&ADTAG=media.innerenter.qqcom.index_navigation"  target="_blank" data-beacon-expo="qn_elementid=cp_1_3_6&qn_event_type=show" data-beacon-click="qn_elementid=cp_1_3_6&qn_event_type=click" bosszone="cp_1_3_6">火影OL</a>
                                      <a href="http://wuxia.qq.com/?ADTAG=media.innerenter.qqcom.index_navigation"  target="_blank" data-beacon-expo="qn_elementid=cp_1_3_7&qn_event_type=show" data-beacon-click="qn_elementid=cp_1_3_7&qn_event_type=click" bosszone="cp_1_3_7">天刀</a>
                                      <a href="http://iwan.qq.com/index.htm?ADTAG=media.innerenter.qqcom.indexnavigation"  target="_blank" data-beacon-expo="qn_elementid=cp_1_3_8&qn_event_type=show" data-beacon-click="qn_elementid=cp_1_3_8&qn_event_type=click" bosszone="cp_1_3_8">爱玩</a>
                                      <a href="http://nz.qq.com/main.shtml?ADTAG=media.innerenter.qqcom.index_navigation"  target="_blank" data-beacon-expo="qn_elementid=cp_1_3_9&qn_event_type=show" data-beacon-click="qn_elementid=cp_1_3_9&qn_event_type=click" bosszone="cp_1_3_9">逆战</a>
                                            </li>
                                    <li class="q-icons prod-4">
                                                    <a href="https://pc.qq.com/"  target="_blank" data-beacon-expo="qn_elementid=cp_1_4_1&qn_event_type=show" data-beacon-click="qn_elementid=cp_1_4_1&qn_event_type=click" bosszone="cp_1_4_1">软件</a>
                                      <a href="https://pay.qq.com/"  target="_blank" data-beacon-expo="qn_elementid=cp_1_4_2&qn_event_type=show" data-beacon-click="qn_elementid=cp_1_4_2&qn_event_type=click" bosszone="cp_1_4_2">Q币</a>
                                      <a href="https://www.jd.com/?utm_source=qq.com&utm_medium=cpc&utm_campaign=dmp_77&utm_term=dmp_77_11727_d604816f27c2b5e98ae51fd59de8b1c43abfdac_1538472240"  target="_blank" data-beacon-expo="qn_elementid=cp_1_4_3&qn_event_type=show" data-beacon-click="qn_elementid=cp_1_4_3&qn_event_type=click" bosszone="cp_1_4_3">京东</a>
                                      <a href="https://map.qq.com/#city=%D6%D0%B9%FA&wd=%D6%D0%B9%FA"  target="_blank" data-beacon-expo="qn_elementid=cp_1_4_4&qn_event_type=show" data-beacon-click="qn_elementid=cp_1_4_4&qn_event_type=click" bosszone="cp_1_4_4">腾讯地图</a>
                                      <a href="https://docs.qq.com/"  target="_blank" data-beacon-expo="qn_elementid=cp_1_4_5&qn_event_type=show" data-beacon-click="qn_elementid=cp_1_4_5&qn_event_type=click" bosszone="cp_1_4_5">腾讯文档</a>
                                      <a href="https://qian.qq.com/?stat_data=oth87ppcsy00222&ADTAG=SCQD.BD.PC.TXDH1"  target="_blank" data-beacon-expo="qn_elementid=cp_1_4_6&qn_event_type=show" data-beacon-click="qn_elementid=cp_1_4_6&qn_event_type=click" bosszone="cp_1_4_6">理财通</a>
                                      <a href="http://www.qq.com/map/" class="more" target="_blank" data-beacon-expo="qn_elementid=cp_1_4_7&qn_event_type=show" data-beacon-click="qn_elementid=cp_1_4_7&qn_event_type=click" bosszone="cp_1_4_7">全部</a>
                                            </li>
                    </ul>
      <div id="prod-more" class="prod-more">
        <div class="prod-more-btn">
          <div class="q-icons btn-icon">展开</div>
        </div>
        <ul class="list f14">
                            <li class="prod-1">
                                                    <a href="https://new.qq.com/omv" target="_blank" data-beacon-expo="qn_elementid=cp_2_1_6&qn_event_type=show" data-beacon-click="qn_elementid=cp_2_1_6&qn_event_type=click" bosszone="cp_2_1_6">享看</a>
                                      <a href="http://qq.pinyin.cn/" target="_blank" data-beacon-expo="qn_elementid=cp_2_1_5&qn_event_type=show" data-beacon-click="qn_elementid=cp_2_1_5&qn_event_type=click" bosszone="cp_2_1_5">QQ拼音</a>
                                      <a href="http://player.qq.com/" target="_blank" data-beacon-expo="qn_elementid=cp_2_1_4&qn_event_type=show" data-beacon-click="qn_elementid=cp_2_1_4&qn_event_type=click" bosszone="cp_2_1_4">QQ影音</a>
                                      <a href="https://pc.qq.com/detail/15/detail_755.html" target="_blank" data-beacon-expo="qn_elementid=cp_2_1_3&qn_event_type=show" data-beacon-click="qn_elementid=cp_2_1_3&qn_event_type=click" bosszone="cp_2_1_3">QQ影像</a>
                                      <a href="http://www.weiyun.com/index.html" target="_blank" data-beacon-expo="qn_elementid=cp_2_1_2&qn_event_type=show" data-beacon-click="qn_elementid=cp_2_1_2&qn_event_type=click" bosszone="cp_2_1_2">微云</a>
                                      <a href="https://fm.qq.com/" target="_blank" data-beacon-expo="qn_elementid=cp_2_1_1&qn_event_type=show" data-beacon-click="qn_elementid=cp_2_1_1&qn_event_type=click" bosszone="cp_2_1_1">企鹅FM</a>
                                            </li>
                                    <li class="prod-2">
                                                    <a href="http://book.qq.com/?g_f=70085" target="_blank" data-beacon-expo="qn_elementid=cp_2_2_6&qn_event_type=show" data-beacon-click="qn_elementid=cp_2_2_6&qn_event_type=click" bosszone="cp_2_2_6">QQ阅读</a>
                                      <a href="https://y.qq.com/" target="_blank" data-beacon-expo="qn_elementid=cp_2_2_5&qn_event_type=show" data-beacon-click="qn_elementid=cp_2_2_5&qn_event_type=click" bosszone="cp_2_2_5">QQ音乐</a>
                                      <a href="http://kg.qq.com/" target="_blank" data-beacon-expo="qn_elementid=cp_2_2_4&qn_event_type=show" data-beacon-click="qn_elementid=cp_2_2_4&qn_event_type=click" bosszone="cp_2_2_4">全民K歌</a>
                                      <a href="http://z.qzone.com/" target="_blank" data-beacon-expo="qn_elementid=cp_2_2_3&qn_event_type=show" data-beacon-click="qn_elementid=cp_2_2_3&qn_event_type=click" bosszone="cp_2_2_3">手机空间</a>
                                      <a href="https://im.qq.com/mobileqq/" target="_blank" data-beacon-expo="qn_elementid=cp_2_2_2&qn_event_type=show" data-beacon-click="qn_elementid=cp_2_2_2&qn_event_type=click" bosszone="cp_2_2_2">手机QQ</a>
                                      <a href="https://jiasu.qq.com/?ADTAG=qqcom" target="_blank" data-beacon-expo="qn_elementid=cp_2_2_1&qn_event_type=show" data-beacon-click="qn_elementid=cp_2_2_1&qn_event_type=click" bosszone="cp_2_2_1">网游加速器</a>
                                            </li>
                                    <li class="prod-3">
                                                    <a href="http://speed.qq.com/main.shtml?ADTAG=media.innerenter.qqcom.index_navigation" target="_blank" data-beacon-expo="qn_elementid=cp_2_3_7&qn_event_type=show" data-beacon-click="qn_elementid=cp_2_3_7&qn_event_type=click" bosszone="cp_2_3_7">QQ飞车</a>
                                      <a href="http://yxwd.qq.com/?ADTAG=media.innerenter.qqcom.index_navigation" target="_blank" data-beacon-expo="qn_elementid=cp_2_3_6&qn_event_type=show" data-beacon-click="qn_elementid=cp_2_3_6&qn_event_type=click" bosszone="cp_2_3_6">英雄</a>
                                      <a href="http://dn.qq.com/cp/a20180904ysjj/index.htm" target="_blank" data-beacon-expo="qn_elementid=cp_2_3_5&qn_event_type=show" data-beacon-click="qn_elementid=cp_2_3_5&qn_event_type=click" bosszone="cp_2_3_5">龙之谷</a>
                                      <a href="http://eafifa.qq.com/?ADTAG=media.innerenter.qqcom.index_navigation" target="_blank" data-beacon-expo="qn_elementid=cp_2_3_4&qn_event_type=show" data-beacon-click="qn_elementid=cp_2_3_4&qn_event_type=click" bosszone="cp_2_3_4">FIFA</a>
                                      <a href="http://hdl.qq.com/index.shtml?ADTAG=media.innerenter.qqcom.index_navigation" target="_blank" data-beacon-expo="qn_elementid=cp_2_3_3&qn_event_type=show" data-beacon-click="qn_elementid=cp_2_3_3&qn_event_type=click" bosszone="cp_2_3_3">魂斗罗</a>
                                      <a href="http://cfm.qq.com/cp/a20180927vacation/index.html" target="_blank" data-beacon-expo="qn_elementid=cp_2_3_2&qn_event_type=show" data-beacon-click="qn_elementid=cp_2_3_2&qn_event_type=click" bosszone="cp_2_3_2">CF手游</a>
                                      <a href="http://tlbb.qq.com/main.shtml?ADTAG=media.innerenter.qqcom.index_navigation" target="_blank" data-beacon-expo="qn_elementid=cp_2_3_1&qn_event_type=show" data-beacon-click="qn_elementid=cp_2_3_1&qn_event_type=click" bosszone="cp_2_3_1">天龙手游</a>
                                            </li>
                                    <li class="prod-4">
                                                    <a href="http://xing.qq.com/" target="_blank" data-beacon-expo="qn_elementid=cp_2_4_7&qn_event_type=show" data-beacon-click="qn_elementid=cp_2_4_7&qn_event_type=click" bosszone="cp_2_4_7">星钻</a>
                                      <a href="https://888.qq.com/?bc_tag=10161.1.1" target="_blank" data-beacon-expo="qn_elementid=cp_2_4_6&qn_event_type=show" data-beacon-click="qn_elementid=cp_2_4_6&qn_event_type=click" bosszone="cp_2_4_6">QQ彩票</a>
                                      <a href="http://cb.qq.com/?attach=200_1000_10090&QQ_from=200_1000_10090" target="_blank" data-beacon-expo="qn_elementid=cp_2_4_5&qn_event_type=show" data-beacon-click="qn_elementid=cp_2_4_5&qn_event_type=click" bosszone="cp_2_4_5">彩贝</a>
                                      <a href="http://time.qq.com/?pgv_ref=qqcom" target="_blank" data-beacon-expo="qn_elementid=cp_2_4_4&qn_event_type=show" data-beacon-click="qn_elementid=cp_2_4_4&qn_event_type=click" bosszone="cp_2_4_4">时光画轴</a>
                                      <a href="https://tianqi.qq.com/" target="_blank" data-beacon-expo="qn_elementid=cp_2_4_3&qn_event_type=show" data-beacon-click="qn_elementid=cp_2_4_3&qn_event_type=click" bosszone="cp_2_4_3">天气</a>
                                      <a href="http://users.qq.com/" target="_blank" data-beacon-expo="qn_elementid=cp_2_4_2&qn_event_type=show" data-beacon-click="qn_elementid=cp_2_4_2&qn_event_type=click" bosszone="cp_2_4_2">用户社区</a>
                                      <a href="https://dreamreader.qq.com/" target="_blank" data-beacon-expo="qn_elementid=cp_2_4_1&qn_event_type=show" data-beacon-click="qn_elementid=cp_2_4_1&qn_event_type=click" bosszone="cp_2_4_1">海豚智音</a>
                                            </li>
                                                                              </ul>
      </div>
    </div><!--67cce3d3884c72fbc1f8f7598ea9d328-->
            <!-- /产品 -->

            <!-- 热门赛事 -->
            <div class="mod m-match" bossexpo="bg_rmss">
      <div class="hd cf">
        <h2 class="tit active fl">
          <a href="http://kbs.sports.qq.com/#hot" target="_blank" data-beacon-expo="qn_elementid=rmss_logo&qn_event_type=show" data-beacon-click="qn_elementid=rmss_logo&qn_event_type=click" bosszone="rmss_logo">热门赛事</a>
        </h2>
        <div class="fr">
          <a id="match-info" class="match-info" href="http://kbs.sports.qq.com/#hot" target="_blank" data-beacon-expo="qn_elementid=rmss_sc&qn_event_type=show" data-beacon-click="qn_elementid=rmss_sc&qn_event_type=click" bosszone="rmss_sc">
            <span class="match-time"></span>
            <span class="tit-line"></span>
            <span class="q-icons match-txt"></span>
          </a>
        </div>
      </div>
      <div class="bd">
        <ul class="news-list">
                                <li class="video-box click-pop-play" data-beacon-expo="qn_elementid=rmss_1&qn_event_type=show" data-beacon-click="qn_elementid=rmss_1&qn_event_type=click" bosszone="rmss_1" bossvv="vv_rmss">
              <img src="//inews.gtimg.com/newsapp_bt/0/202111163765747061582/0" alt="NBA长暂停：字母哥运筹帷幄主导惨案 大将军暗讽詹皇">
              <i class="q-icons icon-play"></i>
              <div class="desc undis">a0041hx9mqq</div>
              <a class="txt" href="https://v.qq.com/x/cover/mzc002007ttx89c/a0041hx9mqq.html" target="_blank">NBA长暂停：字母哥运筹帷幄主导惨案 大将军暗讽詹皇</a>
                        <div id="mod-player1" class="mod-player" data-vid="a0041hx9mqq"  data-url="https://v.qq.com/x/cover/mzc002007ttx89c/a0041hx9mqq.html"></div>
              <div class="click-layer"></div>
            </li>
                                          <li data-beacon-expo="qn_elementid=rmss_2&qn_event_type=show" data-beacon-click="qn_elementid=rmss_2&qn_event_type=click" bosszone="rmss_2">
                <a class="q-icons icon-video" href="https://view.inews.qq.com/a/20211123A0AKGC00" target="_blank">女篮世预赛抽签：中国与法国、尼日利亚和马里同组</a>
              </li>
                                          <li data-beacon-expo="qn_elementid=rmss_3&qn_event_type=show" data-beacon-click="qn_elementid=rmss_3&qn_event_type=click" bosszone="rmss_3">
                <a class="q-icons icon-video" href="https://v.qq.com/x/cover/mzc00200ld5vm8c/a0041gwbhhj.html" target="_blank">准绝杀！灰熊大将终场前5.7秒投进致命三分掀翻爵士</a>
              </li>
                                          <li data-beacon-expo="qn_elementid=rmss_4&qn_event_type=show" data-beacon-click="qn_elementid=rmss_4&qn_event_type=click" bosszone="rmss_4">
                <a class="q-icons icon-video" href="http://view.inews.qq.com/a/20211123A03FKY00" target="_blank">NBA一纸罚单却惹更大争议：詹姆斯禁赛1场轻了吗？</a>
              </li>
                                          <li data-beacon-expo="qn_elementid=rmss_5&qn_event_type=show" data-beacon-click="qn_elementid=rmss_5&qn_event_type=click" bosszone="rmss_5">
                <a class="q-icons icon-video" href="https://fans.sports.qq.com/post.htm?id=1717198140627484797&mid=145#1_allWithElite" target="_blank">欧冠第五轮直播表：管泽元詹俊领衔解说天团齐上阵</a>
              </li>
                                          <li data-beacon-expo="qn_elementid=rmss_6&qn_event_type=show" data-beacon-click="qn_elementid=rmss_6&qn_event_type=click" bosszone="rmss_6">
                <a class="q-icons icon-video" href="https://v.qq.com/x/page/w3310va33s5.html" target="_blank">刘国梁谈中美混双出战世乒赛：展示乒乓外交的力量</a>
              </li>
                      </ul>
      </div>
    </div><!--49edf3bff2e6f34afbc306f8c2b9cf5b-->
            <!-- /热门赛事 -->

            <!-- 今日热播 -->
            <div class="mod m-todayhot" bossexpo="bg_jrrb">
      <div class="hd-2 cf">
        <h2 class="tit active fl">
          <a href="https://v.qq.com/" target="_blank" data-beacon-expo="qn_elementid=jrrb_logo&qn_event_type=show" data-beacon-click="qn_elementid=jrrb_logo&qn_event_type=click" bosszone="jrrb_logo">今日热播</a>
        </h2>
      </div>
      <div class="bd">
        <ul id="jrrb_news_1" class="news-list cf">
                                      <li class="video-item fl">
                <div class="pic video-box click-drag-play" data-beacon-expo="qn_elementid=jrrb_1&qn_event_type=show" data-beacon-click="qn_elementid=jrrb_1&qn_event_type=click" bosszone="jrrb_1" bossvv="vv_jrrb">
                  <img src="//inews.gtimg.com/newsapp_bt/0/202111163762532824496/0" alt="王亚平太空跑步和追剧两不误">
                  <i class="q-icons icon-play2"></i>
                  <div class="txt">王亚平太空跑步和追剧两不误</div>
                  <div class="desc undis">n33102tjrq7</div>
                  <div id="mod-player2" class="mod-player" data-vid="n33102tjrq7" data-url="https://new.qq.com/omn/20211122/20211122V07TPF00.html"></div>
                  <div class="click-layer"></div>
                </div>
              </li>
                                              <li class="video-item fr">
                <div class="pic video-box click-drag-play" data-beacon-expo="qn_elementid=jrrb_2&qn_event_type=show" data-beacon-click="qn_elementid=jrrb_2&qn_event_type=click" bosszone="jrrb_2" bossvv="vv_jrrb">
                  <img src="//inews.gtimg.com/newsapp_bt/0/202111163762585281718/0" alt="黑龙江再迎暴风雪 积雪达34厘米">
                  <i class="q-icons icon-play2"></i>
                  <div class="txt">黑龙江再迎暴风雪 积雪达34厘米</div>
                  <div class="desc undis">j3310x5f6rr</div>
                  <div id="mod-player3" class="mod-player" data-vid="j3310x5f6rr" data-url="https://new.qq.com/omn/20211122/20211122V04TFK00.html"></div>
                  <div class="click-layer"></div>
                </div>
              </li>
                                                          </ul><ul id="jrrb_news_2" class="news-list">
                        <li class="item" data-beacon-expo="qn_elementid=jrrb_3&qn_event_type=show" data-beacon-click="qn_elementid=jrrb_3&qn_event_type=click" bosszone="jrrb_3">
                <a href="https://new.qq.com/omn/20211123/20211123V00CWB00.html" target="_blank">深圳千元饮品号称百年果树橄榄制作 市监局回应：已启动核查</a>
              </li>
                                                        <li class="item" data-beacon-expo="qn_elementid=jrrb_4&qn_event_type=show" data-beacon-click="qn_elementid=jrrb_4&qn_event_type=click" bosszone="jrrb_4">
                <a href="https://new.qq.com/omn/20211123/20211123V0188S00.html" target="_blank">江西宿舍坍塌致4死：遇难者来自3个家庭，含一对七旬老夫妻</a>
              </li>
                                                        <li class="item" data-beacon-expo="qn_elementid=jrrb_5&qn_event_type=show" data-beacon-click="qn_elementid=jrrb_5&qn_event_type=click" bosszone="jrrb_5">
                <a href="https://new.qq.com/omn/20211122/20211122V0C61A00.html" target="_blank">面对外机挑衅中国空军一点不退： 看谁先示弱 看谁不怕死</a>
              </li>
                                                        <li class="item" data-beacon-expo="qn_elementid=jrrb_6&qn_event_type=show" data-beacon-click="qn_elementid=jrrb_6&qn_event_type=click" bosszone="jrrb_6">
                <a href="https://new.qq.com/omn/20211122/20211122V0AR4T00.html" target="_blank">美国加州一店铺遭数十人集体行窃 劫匪涌入扫荡留下一地狼藉</a>
              </li>
                                                        <li class="item" data-beacon-expo="qn_elementid=jrrb_7&qn_event_type=show" data-beacon-click="qn_elementid=jrrb_7&qn_event_type=click" bosszone="jrrb_7">
                <a href="https://new.qq.com/omn/20211122/20211122V0A9ES00.html" target="_blank">雪后大学生用模具自制星星雪球挂满枝头 浪漫十足令网友称羡</a>
              </li>
                      </ul>
      </div>
    </div><!--6d2575a9d7a3ef80e09f68357fd37374-->
            <!-- /今日热播 -->
          </div>

        </div>
        <!-- /要闻 -->

        <!-- 视觉焦点 -->
        <div class="layout">
          <div class="index-dom-html structure-imgs" id="visual_focus_20200724"></div>
        </div>
        <!--include virtual="/ninja/visual_focus_20200724.htm"-->
        <!-- /视觉焦点 -->

        <!-- 广告2 -->
        <div class="layout qq-gg gg-2 cf">
          <div class="col-1 fl">
            <!--NEW_QQCOM_N_Width2_div AD begin...."l=NEW_QQCOM_N_Width2&log=off"--><div id="NEW_QQCOM_N_Width2" style="width:920px;height:90px;" class="l_qq_com"></div><!--NEW_QQCOM_N_Width2 AD end --><!--[if !IE]>|xGv00|6c79a7f4e8d6aec45d089679f71d59ee<![endif]-->
          </div>
          <div class="col-2 fr">
            <!--NEW_QQCOM_N_button1_div AD begin...."l=NEW_QQCOM_N_button1&log=off"--><div id="NEW_QQCOM_N_button1" style="width:440px;height:90px;" class="l_qq_com"></div><!--NEW_QQCOM_N_button1 AD end --><!--[if !IE]>|xGv00|1722760f894cd85a0ed41de85dc28e3b<![endif]-->
          </div>
        </div>
        <!-- /广告2 -->

        <!-- 娱乐/体育/NBA -->
        <div class="layout qq-channel2col channelent channel-num6 cf">

          <div class="col col-2 fl">

            <!-- 娱乐 -->
            <div class="mod-ch">
              <div class="title nst">
                <a class="txt active" href="https://new.qq.com/ch/ent/" target="_blank" data-beacon-expo="qn_elementid=yule_logo&qn_event_type=show" data-beacon-click="qn_elementid=yule_logo&qn_event_type=click" bosszone="yule_logo">娱乐</a>
                <span data-beacon-expo="qn_elementid=yule_dh&qn_event_type=show" data-beacon-click="qn_elementid=yule_dh&qn_event_type=click" bosszone="yule_dh">
                  <a class="txt" href="https://new.qq.com/ch2/tv" target="_blank">电视剧</a>
                  <a class="txt" href="https://new.qq.com/ch2/movie" target="_blank">电影</a>
                  <a class="txt" href="https://new.qq.com/ch2/music" target="_blank">音乐</a>
                </span>
                <ul class="label" data-beacon-expo="qn_elementid=yule_om&qn_event_type=show" data-beacon-click="qn_elementid=yule_om&qn_event_type=click" bosszone="yule_om">
                    <li><a href="https://new.qq.com/omn/author/32" target="_blank">贵圈</a></li>
      <li><a href="https://new.qq.com/omn/author/26135" target="_blank">懂小姐</a></li>
      <li><a href="https://new.qq.com/omn/author/6853487" target="_blank">认真映画</a></li>
    <!--16f576bb002ac16dcbe30d6e528dca11--><!--[if !IE]>|xGv00|f830b6435807e5e6bbb226ae0a5cc0bd<![endif]-->
                </ul>
              </div>
              <div class="bdwrap js_chyh">
                      <div class="index-dom-html structure-text-horizontally structure" id="index_ent_20200724"></div>
                <!--include virtual="/ninja/index_ent_20200724.htm" -->
                <div class="hyh js_hyh" data-beacon-expo="qn_elementid=yule_more&qn_event_type=show" data-beacon-click="qn_elementid=yule_more&qn_event_type=click" bosszone="yule_more">
                  <span class="htxt">换一换</span>
                  <ul class="hwrap" id="js_enthyh">
                    <li class="hpoint active" data-rel="#js_entbd1"></li>
                    <li class="hpoint" data-rel="#js_entbd2"></li>
                    <li class="hpoint" data-rel="#js_entbd3"></li>
                  </ul>
                </div>
              </div>
            </div>
            <!-- /娱乐 -->

            <!-- 体育 -->
            <div class="mod-ch">
              <div class="title nst">
                <a class="txt active" href="http://sports.qq.com/" target="_blank" data-beacon-expo="qn_elementid=tiyu_logo&qn_event_type=show" data-beacon-click="qn_elementid=tiyu_logo&qn_event_type=click" bosszone="tiyu_logo">体育</a>
                <span data-beacon-expo="qn_elementid=tiyu_dh&qn_event_type=show" data-beacon-click="qn_elementid=tiyu_dh&qn_event_type=click" bosszone="tiyu_dh">
                  <a class="txt" href="https://sports.qq.com/csocce/csl/" target="_blank">中超</a>
                  <a class="txt" href="http://sports.qq.com/cba/" target="_blank">CBA</a>
                  <a class="txt" href="http://sports.qq.com/premierleague/" target="_blank">英超</a>
                  <a class="txt" href="http://fans.sports.qq.com/#/" target="_blank">社区</a>
                </span>
                <ul class="label" data-beacon-expo="qn_elementid=tiyu_om&qn_event_type=show" data-beacon-click="qn_elementid=tiyu_om&qn_event_type=click" bosszone="tiyu_om">
                    <li><a href="https://v.qq.com/detail/8/87659.html" target="_blank">超新星运动会</a></li>
      <li><a href="https://v.qq.com/detail/8/87756.html" target="_blank">女主播大乐透</a></li>
      <li><a href="https://v.qq.com/detail/8/81602.html" target="_blank">有球必应</a></li>
      <li><a href="https://v.qq.com/detail/5/52906.html" target="_blank">中场不安定</a></li>
    <!--9bc44bb1ee8fb6a000a940264e51b733--><!--[if !IE]>|xGv00|a85c819f48a9d486de8774f44fbf208e<![endif]-->
                </ul>
              </div>
              <div class="bdwrap js_chyh">
                <div class="index-dom-html structure-text-horizontally structure" loadsport="1" id="index_sports_20200724"></div>
                <!--include virtual="/ninja/index_sports_20200724.htm" -->
                <div class="hyh js_hyh" data-beacon-expo="qn_elementid=tiyu_more&qn_event_type=show" data-beacon-click="qn_elementid=tiyu_more&qn_event_type=click" bosszone="tiyu_more">
                  <span class="htxt">换一换</span>
                  <ul class="hwrap" id="js_sportshyh">
                    <li class="hpoint active" data-rel="#js_sportsbd1"></li>
                    <li class="hpoint" data-rel="#js_sportsbd2"></li>
                    <li class="hpoint" data-rel="#js_sportsbd3"></li>
                  </ul>
                </div>
              </div>
            </div>
            <!-- /体育 -->


          </div>

          <div class="col col-1 fr">
            <div id="mod-recommend" class="mod mod-recommend">
              <i class="line"></i>
              <div class="hd cf">
                <h2 class="tit fl">为你推荐</h2>
                <a class="more-btn fr" href="javascript:;" data-src="https://news.qq.com/" bosszone="wntj_more">点击查看 9 条新内容</a>
                <i class="icon-dot"></i>
              </div>
              <div class="bd">
                <div class="list">
                  <div class="index-dom-html structure-text-vertically structure" id="recommend_20201021"></div>
                  <!--include virtual="/ninja/recommend_20201021.htm"-->
                </div>
              </div>
            </div>
          </div>

        </div>
        <!-- /娱乐/体育/NBA -->

        <!-- 财经/军事 -->
        <div class="layout channel2col qq-channel2col channel-num6 cf">
          <div class="col col-2 fl">
            <div class="title nst">
              <a class="txt active" href="http://finance.qq.com" target="_blank" data-beacon-expo="qn_elementid=caijing_logo&qn_event_type=show" data-beacon-click="qn_elementid=caijing_logo&qn_event_type=click" bosszone="caijing_logo">财经</a>
              <span data-beacon-expo="qn_elementid=caijing_dh&qn_event_type=show" data-beacon-click="qn_elementid=caijing_dh&qn_event_type=click" bosszone="caijing_dh">
                <a class="txt" href="http://stock.qq.com/" target="_blank">证券</a>
                <a class="txt" href="http://money.qq.com/" target="_blank">理财</a>
              </span>
              <ul class="label" data-beacon-expo="qn_elementid=caijing_om&qn_event_type=show" data-beacon-click="qn_elementid=caijing_om&qn_event_type=click" bosszone="caijing_om">
                  <li><a href="https://new.qq.com/omn/author/5178949" target="_blank">第一财经</a></li>
      <li><a href="https://new.qq.com/omn/author/5564731" target="_blank">界面新闻</a></li>
      <li><a href="https://new.qq.com/omn/author/5005722" target="_blank">每日经济新闻</a></li>
      <li><a href="https://new.qq.com/omn/author/5373662" target="_blank">财约你</a></li>
    <!--d4120556c8f48fa4cc68947280f5af23--><!--[if !IE]>|xGv00|2397e68d03fe1a1234773346456910f5<![endif]-->
              </ul>
            </div>
            <div class="bdwrap js_chyh">
              <div class="bd stockbd cf" id="js_stockbd1" data-beacon-expo="qn_elementid=caijing_1&qn_event_type=show" data-beacon-click="qn_elementid=caijing_1&qn_event_type=click" bosszone="caijing_1" bossexpo="bg_caijing_1">
                <div class="bdleft">
                  <div class="index-dom-html structure-text structure" id="index_finance1_20200724"></div>
                  <!--include virtual="/ninja/index_finance1_20200724.htm" -->
                </div>
                <div class="bdright">
                  <div class="index-dom-html" id="index_stock1_zhishu"></div>
                  <div class="index-dom-html structure-text structure" id="index_stock1_20200724"></div>
                  <!--include virtual="/ninja/index_stock1_20200724.htm" -->
                </div>
              </div>
              <div class="bd cf undis" id="js_stockbd2" data-beacon-expo="qn_elementid=caijing_2&qn_event_type=show" data-beacon-click="qn_elementid=caijing_2&qn_event_type=click" bosszone="caijing_2" bossexpo="bg_caijing_2">
                <div class="bdleft">
                  <div class="index-dom-html" id="index_finance2_20200724"></div>
                  <!--include virtual="/ninja/index_finance2_20200724.htm" -->
                </div>
                <div class="bdright">
                  <div class="index-dom-html" id="index_stock2_20200724"></div>
                <!--include virtual="/ninja/index_stock2_20200724.htm" -->
                </div>
              </div>
              <div class="bd cf undis" id="js_stockbd3" data-beacon-expo="qn_elementid=caijing_3&qn_event_type=show" data-beacon-click="qn_elementid=caijing_3&qn_event_type=click" bosszone="caijing_3" bossexpo="bg_caijing_3">
                <div class="bdleft">
                  <div class="index-dom-html" id="index_finance3_20200724"></div>
                  <!--include virtual="/ninja/index_finance3_20200724.htm" -->
                </div>
                <div class="bdright">
                  <div class="index-dom-html" id="index_stock3_20200724"></div>
                  <!--include virtual="/ninja/index_stock3_20200724.htm" -->
                </div>
              </div>
              <div class="hyh js_hyh" data-beacon-expo="qn_elementid=caijing_more&qn_event_type=show" data-beacon-click="qn_elementid=caijing_more&qn_event_type=click" bosszone="caijing_more">
                <span class="htxt">换一换</span>
                <ul class="hwrap" id="js_stockhyh">
                  <li class="hpoint active" data-rel="#js_stockbd1"></li>
                  <li class="hpoint" data-rel="#js_stockbd2"></li>
                  <li class="hpoint" data-rel="#js_stockbd3"></li>
                </ul>
              </div>
            </div>
          </div>
          <div class="col col-1 fr" bossexpo="bg_junshi">
            <div class="title">
              <a class="txt active" href="https://new.qq.com/ch/milite/" target="_blank" data-rel="#js_bdmil" data-beacon-expo="qn_elementid=junshi_logo&qn_event_type=show" data-beacon-click="qn_elementid=junshi_logo&qn_event_type=click" bosszone="junshi_logo">军事</a>
            </div>
            <div data-beacon-expo="qn_elementid=junshi&qn_event_type=show" data-beacon-click="qn_elementid=junshi&qn_event_type=click" bosszone="junshi">
              <div class="index-dom-html structure-text structure" id="index_milite_20200724"></div>
              <!--include virtual="/ninja/index_milite_20200724.htm" -->
            </div>
          </div>
        </div>
        <!-- 财经/军事 -->

        <!-- NBA/大家 -->
        <div class="layout channel2col qq-channel2col channel-num6 cf">
            <div class="col col-2 fl">
                <div class="title nst">
                  <a class="txt active" href="http://sports.qq.com/nba/" target="_blank" data-beacon-expo="qn_elementid=nba_logo&qn_event_type=show" data-beacon-click="qn_elementid=nba_logo&qn_event_type=click" bosszone="nba_logo">NBA</a>
                  <ul class="label" data-beacon-expo="qn_elementid=nba_om&qn_event_type=show" data-beacon-click="qn_elementid=nba_om&qn_event_type=click" bosszone="nba_om">
                        <li><a href="http://sports.qq.com/nbavideo/" target="_blank">NBA视频</a></li>
        <li><a href="http://sports.qq.com/nbavideo/topsk/" target="_blank">TOP时刻</a></li>
        <li><a href="http://nba.stats.qq.com/stats/" target="_blank">数据中心</a></li>
    <!--6d53cccf9c0ee8e250df3d63048c39e4--><!--[if !IE]>|xGv00|47402e3084fcadff3d28e78c0805a35b<![endif]-->
                  </ul>
                </div>
                <div class="bdwrap js_chyh">
                  <div class="index-dom-html structure-text-horizontally structure" loadsport="1" id="index_sportsnba_20200724"></div>
                  <!--include virtual="/ninja/index_sportsnba_20200724.htm" -->
                   <div class="hyh js_hyh" data-beacon-expo="qn_elementid=nba_more&qn_event_type=show" data-beacon-click="qn_elementid=nba_more&qn_event_type=click" bosszone="nba_more">
                    <span class="htxt">换一换</span>
                    <ul class="hwrap" id="js_nbahyh">
                      <li class="hpoint active" data-rel="#js_nbabd1"></li>
                      <li class="hpoint" data-rel="#js_nbabd2"></li>
                      <li class="hpoint" data-rel="#js_nbabd3"></li>
                    </ul>
                  </div>
                </div>
            </div>
            <div class="col col-1 fr" bossexpo="bg_dajia">
              <div class="title">
                <!-- <a class="txt active" href="http://dajia.qq.com/" target="_blank" bosszone="dajia_logo">大家</a> -->
                <a class="txt active" href="//new.qq.com/omn/author/5107513" target="_blank" data-beacon-expo="qn_elementid=dajia_logo&qn_event_type=show" data-beacon-click="qn_elementid=dajia_logo&qn_event_type=click" bosszone="dajia_logo">较真</a>
              </div>
              <div data-beacon-expo="qn_elementid=dajia&qn_event_type=show" data-beacon-click="qn_elementid=dajia&qn_event_type=click" bosszone="dajia">
                <div class="index-dom-html structure-text structure" id="index_jiaozhen_2020"></div>
                <!--include virtual="/ninja/index_dajia_2018.htm" -->
                <!--include virtual="/ninja/index_jiaozhen_2020.htm" -->
              </div>
            </div>
          </div>
          <!-- 财经/大家 -->

        <!-- 科技/时尚 -->
        <div class="layout channel2col qq-channel2col channel-num6 cf">
          <div class="col col-2 fl">
            <div class="title nst">
              <a class="txt active" href="https://new.qq.com/ch/tech/" target="_blank" data-beacon-expo="qn_elementid=keji_logo&qn_event_type=show" data-beacon-click="qn_elementid=keji_logo&qn_event_type=click" bosszone="keji_logo">科技</a>
              <span data-beacon-expo="qn_elementid=keji_dh&qn_event_type=show" data-beacon-click="qn_elementid=keji_dh&qn_event_type=click" bosszone="keji_dh">
                <a class="txt" href="//news.qq.com/newspedia/kepu.htm" target="_blank">科普</a>
              </span>
              <ul class="label" data-beacon-expo="qn_elementid=keji_om&qn_event_type=show" data-beacon-click="qn_elementid=keji_om&qn_event_type=click" bosszone="keji_om">
                  <li><a href="https://new.qq.com/rain/a/TEC202106110086002U" target="_blank">了不起的新产品</a></li>
      <li><a href="https://new.qq.com/rain/a/TEC202011110093883X" target="_blank">新能源汽车</a></li>
    <!--91f965401d41065d2d82f8ccbde7303d-->
              </ul>
            </div>
            <div class="bdwrap js_chyh">
              <div class="index-dom-html structure-text-horizontally structure" id="index_tech_20200724"></div>
              <!--include virtual="/ninja/index_tech_20200724.htm" -->
              <div class="hyh js_hyh" data-beacon-expo="qn_elementid=keji_more&qn_event_type=show" data-beacon-click="qn_elementid=keji_more&qn_event_type=click" bosszone="keji_more">
                <span class="htxt">换一换</span>
                <ul class="hwrap" id="js_techhyh">
                  <li class="hpoint active" data-rel="#js_techbd1"></li>
                  <li class="hpoint" data-rel="#js_techbd2"></li>
                  <li class="hpoint" data-rel="#js_techbd3"></li>
                </ul>
              </div>
             </div>
          </div>
          <div class="col col-1 fr" bossexpo="bg_shishang">
            <div class="title">
              <a class="txt active" href="https://new.qq.com/ch/fashion/" target="_blank" data-beacon-expo="qn_elementid=shishang_logo&qn_event_type=show" data-beacon-click="qn_elementid=shishang_logo&qn_event_type=click" bosszone="shishang_logo">时尚</a>
            </div>
            <div data-beacon-expo="qn_elementid=shishang&qn_event_type=show" data-beacon-click="qn_elementid=shishang&qn_event_type=click" bosszone="shishang">
              <div class="index-dom-html structure-text structure" id="index_fashion_20200724"></div>
              <!--include virtual="/ninja/index_fashion_20200724.htm" -->
            </div>
          </div>
        </div>
        <!-- 科技/时尚 -->

       <!-- 汽车/房产 -->
        <div class="layout channel2col qq-channel2col channel-num6 cf">
          <div class="col col-2 fl">
            <div class="title nst">
              <a class="txt active" href="http://auto.qq.com/" target="_blank" data-beacon-expo="qn_elementid=qiche_logo&qn_event_type=show" data-beacon-click="qn_elementid=qiche_logo&qn_event_type=click" bosszone="qiche_logo">汽车</a>
              <ul class="label" data-beacon-expo="qn_elementid=qiche_om&qn_event_type=show" data-beacon-click="qn_elementid=qiche_om&qn_event_type=click" bosszone="qiche_om">
                  <li><a href="https://new.qq.com/ch2/hyrd" target="_blank">行业热点</a></li>
      <li><a href="https://auto.qq.com/car_public/index.shtml" target="_blank">车型大全</a></li>
      <li><a href="http://v.qq.com/auto/" target="_blank">精彩视频</a></li>
      <li><a href="http://automall.qq.com/web" target="_blank">汽车商城</a></li>
    <!--78bdb5def66102b2e5de894017d41e5d-->
              </ul>
            </div>
            <div class="bdwrap js_chyh">
              <div class="index-dom-html structure-text-horizontally structure" id="index_carauto_20200724"></div>
              <!--include virtual="/ninja/index_carauto_20200724.htm" -->
              <div class="hyh js_hyh" data-beacon-expo="qn_elementid=qiche_more&qn_event_type=show" data-beacon-click="qn_elementid=qiche_more&qn_event_type=click" bosszone="qiche_more">
                <span class="htxt">换一换</span>
                <ul class="hwrap" id="js_autohyh">
                  <li class="hpoint active" data-rel="#js_autobd1"></li>
                  <li class="hpoint" data-rel="#js_autobd2"></li>
                  <li class="hpoint" data-rel="#js_autobd3"></li>
                </ul>
              </div>
            </div>
          </div>
          <div class="col col-1 fr" bossexpo="bg_fangchan">
            <div class="title">
              <a class="txt active" href="http://house.qq.com/" target="_blank" data-beacon-expo="qn_elementid=fangchan_logo&qn_event_type=show" data-beacon-click="qn_elementid=fangchan_logo&qn_event_type=click" bosszone="fangchan_logo">房产</a>
            </div>
            <div data-beacon-expo="qn_elementid=fangchan&qn_event_type=show" data-beacon-click="qn_elementid=fangchan&qn_event_type=click" bosszone="fangchan">
              <div class="index-dom-html structure-text structure" id="index_house_20200724"></div>
              <!--include virtual="/ninja/index_house_20200724.htm" -->
            </div>
          </div>
        </div>
        <!-- /汽车/房产 -->

        <!-- 综艺影视剧 -->
        <div class="layout qq-videos m40" style="display:none;">
          <div class="title" id="js_vtitle">
            <a class="txt active" href="https://v.qq.com/x/variety/" target="_blank" data-rel="#js_bdzy" bosszone="zongyi_logo">综艺</a>
            <span class="split"></span>
            <a class="txt" href="http://v.qq.com/tv/" target="_blank" data-rel="#js_bdysj" bosszone="zongyi_logo">电视剧</a>
            <span class="split"></span>
            <a class="txt" href="http://v.qq.com/movie/" target="_blank" data-rel="#js_bdmv" bosszone="dianying_logo">电影</a>
            <span class="split"></span>
            <a class="txt" href="https://v.qq.com/child" target="_blank" data-rel="#js_bdchild" bosszone="shaoer_logo">少儿</a>
            <ul class="label" bosszone="zongyi_om">
              <!--include virtual="/ninja/index_omzy_2018.htm" -->
            </ul>
          </div>
          <div class="mainbody" id="js_videosbd">
            <div id="js_bdzy" bossexpo="bg_zongyi">
              <div class="bdwrap">
                <div class="bd-inner cf" id="js_zyCon">

                  <!--include virtual="/ninja/index_zongyi_2018.htm"-->
                </div>
              </div>
              <div id="js_zydir" bosszone="zongyi_more">
                <a href="javascript:;" class="prev icon disabled" data-rel="#js_zyCon_0"></a>
                <a href="javascript:;" class="next icon" data-rel="#js_zyCon_1"></a>
              </div>
            </div>
            <div id="js_bdysj" class="undis" bossexpo="bg_dsj">
              <div class="bdwrap">
                <div class="bd-inner cf" id="js_ysjCon">
                  <!--include virtual="/ninja/index_ysj_2018.htm"-->
                </div>
              </div>
              <div id="js_ysjdir" bosszone="dsj_more">
                <a href="javascript:;" class="prev icon disabled" data-rel="#js_ysjCon_0"></a>
                <a href="javascript:;" class="next icon" data-rel="#js_ysjCon_1"></a>
              </div>
            </div>
            <div id="js_bdmv" class="undis" bossexpo="bg_dianying">
              <div class="bdwrap">
                <div class="bd-inner cf" id="js_mvCon">
                  <!--include virtual="/ninja/index_movie_2018.htm"-->
                </div>
              </div>
              <div id="js_mvdir" bosszone="dianying_more">
                <a href="javascript:;" class="prev icon disabled" data-rel="#js_mvCon_0"></a>
                <a href="javascript:;" class="next icon" data-rel="#js_mvCon_1"></a>
              </div>
            </div>
             <div id="js_bdchild" class="undis" bossexpo="bg_shaoer">
              <div class="bdwrap">
                <div class="bd-inner cf" id="js_childCon">
                  <!--include virtual="/ninja/index_child_2018.htm"-->
                </div>
              </div>
              <div id="js_childdir" bosszone="shaoer_more">
                <a href="javascript:;" class="prev icon disabled" data-rel="#js_childCon_0"></a>
                <a href="javascript:;" class="next icon" data-rel="#js_childCon_1"></a>
              </div>
            </div>
            <div class="vplayer">
              <div class="layer"></div>
              <div id="js_videoplayer">

              </div>
            </div>
          </div>
        </div>
        <!-- /综艺影视剧 -->

        <!-- 广告3 -->
        <div class="layout qq-gg gg-3 cf">
          <div class="col-1 fl">
            <!--NEW_QQCOM_N_Width3_div AD begin...."l=NEW_QQCOM_N_Width3&log=off"--><div id="NEW_QQCOM_N_Width3" style="width:920px;height:90px;" class="l_qq_com"></div><!--NEW_QQCOM_N_Width3 AD end --><!--[if !IE]>|xGv00|a54d84501d504c4567ba39a7064f670b<![endif]-->
          </div>
          <div class="col-2 fr">
            <!--NEW_QQCOM_N_button2_div AD begin...."l=NEW_QQCOM_N_button2&log=off"--><div id="NEW_QQCOM_N_button2" style="width:440px;height:90px;" class="l_qq_com"></div><!--NEW_QQCOM_N_button2 AD end --><!--[if !IE]>|xGv00|6743da0daaed589d3944270e6489eda6<![endif]-->
          </div>
        </div>
        <!-- /广告3 -->

        <!-- 军事/历史/文化佛学 -->
        <div class="layout qq-channel3col cf">
          <div class="col col-1">
            <div class="title">
              <a class="txt active" href="https://new.qq.com/ch/edu/" target="_blank" data-beacon-expo="qn_elementid=jiaoyu_logo&qn_event_type=show" data-beacon-click="qn_elementid=jiaoyu_logo&qn_event_type=click" bosszone="jiaoyu_logo">教育</a>
            </div>
            <div data-beacon-expo="qn_elementid=jiaoyu&qn_event_type=show" data-beacon-click="qn_elementid=jiaoyu&qn_event_type=click" bosszone="jiaoyu" bossexpo="bg_jiaoyu">
              <div class="index-dom-html structure-text structure" id="index_education_20200724"></div>
              <!--include virtual="/ninja/index_education_20200724.htm" -->
            </div>
          </div>
          <div class="col col-1">
            <div class="title" id="js_histitle">
              <a class="txt active" href="https://new.qq.com/omn/author/41" target="_blank" data-rel="#js_bdhis" data-beacon-expo="qn_elementid=lishi_logo&qn_event_type=show" data-beacon-click="qn_elementid=lishi_logo&qn_event_type=click" bosszone="lishi_logo">历史</a>
            </div>
            <div class="bdwrap">
              <div class="bd" id="js_bdhis" data-beacon-expo="qn_elementid=lishi&qn_event_type=show" data-beacon-click="qn_elementid=lishi&qn_event_type=click" bosszone="lishi" bossexpo="bg_lishi">
                <div class="index-dom-html structure-text structure" id="index_history_20200724"></div>
                <!--include virtual="/ninja/index_history_20200724.htm" -->
              </div>
            </div>
          </div>
          <div class="col col-1 col-last">
            <div class="title" id="js_title1">
              <a class="txt active" href="https://new.qq.com/ch/cul/" target="_blank" data-rel="#js_bdcul" data-beacon-expo="qn_elementid=wenhua_logo&qn_event_type=show" data-beacon-click="qn_elementid=wenhua_logo&qn_event_type=click" bosszone="wenhua_logo">文化</a>
              <span class="split"></span>
              <a class="txt" href="https://new.qq.com/ch/cul_ru/" target="_blank" data-rel="#js_bdbud" data-beacon-expo="qn_elementid=foxue_logo&qn_event_type=show" data-beacon-click="qn_elementid=foxue_logo&qn_event_type=click" bosszone="foxue_logo">新国风</a>
            </div>
            <div class="bdwrap">
              <div class="bd" id="js_bdcul" data-beacon-expo="qn_elementid=wenhua&qn_event_type=show" data-beacon-click="qn_elementid=wenhua&qn_event_type=click" bosszone="wenhua" bossexpo="bg_wenhua">
                <div class="index-dom-html structure-text structure" id="index_culture_20200724"></div>
                <!--include virtual="/ninja/index_culture_20200724.htm" -->
              </div>
              <div class="bd undis" id="js_bdbud" data-beacon-expo="qn_elementid=foxue&qn_event_type=show" data-beacon-click="qn_elementid=foxue&qn_event_type=click" bosszone="foxue" bossexpo="bg_foxue">
                <div class="index-dom-html" id="index_rushidao_20200724"></div>
                <!--include virtual="/ninja/index_rushidao_20200724.htm" -->
              </div>
            </div>
          </div>
        </div>
        <!-- /军事/历史/文化佛学 -->

        <!-- 星座每日运势/游戏动漫/财报 -->
        <div class="layout qq-channel3col cf">
          <div class="col col-1">
            <div class="title" id="js_title2">
              <a class="txt active" href="http://astro.fashion.qq.com/" target="_blank" data-rel="#js_bdastro" data-beacon-expo="qn_elementid=xingzuo_logo&qn_event_type=show" data-beacon-click="qn_elementid=xingzuo_logo&qn_event_type=click" bosszone="xingzuo_logo">星座</a>
              <span class="split"></span>
              <a class="txt" href="http://astro.fashion.qq.com/" target="_blank" data-rel="#js_bdfortune" data-beacon-expo="qn_elementid=yunshi_logo&qn_event_type=show" data-beacon-click="qn_elementid=yunshi_logo&qn_event_type=click" bosszone="yunshi_logo">今日运势</a>
            </div>
            <div class="bdwrap bdwrapast">
              <div class="bd" id="js_bdastro" data-beacon-expo="qn_elementid=xingzuo&qn_event_type=show" data-beacon-click="qn_elementid=xingzuo&qn_event_type=click" bosszone="xingzuo" bossexpo="bg_xingzuo">
                <div class="index-dom-html structure-text structure" id="index_astro_20200724"></div>
                <!--include virtual="/ninja/index_astro_20200724.htm" -->
              </div>
              <div class="undis col-astrobd" id="js_bdfortune" data-beacon-expo="qn_elementid=yunshi&qn_event_type=show" data-beacon-click="qn_elementid=yunshi&qn_event_type=click" bosszone="yunshi" bossexpo="bg_yunshi">
                <div class="astop cf">
                  <a class="asleft" href="javascript:;" id="js_aimg" target="_blank">
                    <span class="icon Aries" title="白羊座"></span>
                    <p class="name">白羊座</p>
                  </a>
                  <div class="asright">
                    <div class="asdesc" id="js_adetail">
                      <div class="desc fortune">
                        <span class="label">今日运势：</span>
                        <div class="fortune-star">
                          <span class="bottom iconastro"></span>
                          <span class="top iconastro"></span>
                        </div>
                      </div>
                      <div class="desc luck">
                        <span class="label">幸运颜色：紫色</span>
                      </div>
                      <div class="desc lucknum">
                        <span class="label">幸运数字：7</span>
                      </div>
                    </div>
                    <div class="select">
                      <div class="selected iconastro" id="js_aselect">白羊座 03.21-04.19 </div>
                      <ul class="list" id="js_aselectlist">
                        <li class="astroItem" data-value="0">白羊座 03.21-04.19</li>
                        <li class="astroItem" data-value="1">金牛座 04.20-05.20</li>
                        <li class="astroItem active" data-value="2">双子座 05.21-06.21</li>
                        <li class="astroItem" data-value="3">巨蟹座 06.22-07.22</li>
                        <li class="astroItem" data-value="4">狮子座 07.23-08.22</li>
                        <li class="astroItem" data-value="5">处女座 08.23-09.22</li>
                        <li class="astroItem" data-value="6">天秤座 09.23-10.23</li>
                        <li class="astroItem" data-value="7">天蝎座 10.24-11.22</li>
                        <li class="astroItem" data-value="8">射手座 11.23-12.21</li>
                        <li class="astroItem" data-value="9">摩羯座 12.22-01.19</li>
                        <li class="astroItem" data-value="10">水瓶座 01.20-02.18</li>
                        <li class="astroItem" data-value="11">双鱼座 02.19-03.20</li>
                      </ul>
                    </div>
                  </div>
                </div>
                <p class="astxt" id="js_atxt">今天对于一切的工作都是那么专心致志，隔一段时间就要起来走动一下，才能保证有更高的效率，期待已久的事件总算有了一个交代，虽然不是满分，但也算是好结果。
                </p>
                <ul class="txtArea">
                      <li><a class="" href="https://new.qq.com/omn/20211123/20211123A0AF9C00.html" target="_blank">极度自私的三个星座！</a></li>
                                <li><a class="" href="https://new.qq.com/omn/20211123/20211123A0BLRN00.html" target="_blank">星座女神1124｜双子多留意细节，天蝎忌意气用事</a></li>
                                  </ul>
              </div>
            </div>
          </div>
          <div class="col col-1">
            <div class="title" id="js_title3">
              <a class="txt active" href="https://new.qq.com/ch/games/" target="_blank" data-rel="#js_bdgame" data-beacon-expo="qn_elementid=youxi_logo&qn_event_type=show" data-beacon-click="qn_elementid=youxi_logo&qn_event_type=click" bosszone="youxi_logo">游戏</a>
              <span class="split"></span>
              <a class="txt" href="https://new.qq.com/ch/comic/" target="_blank" data-rel="#js_bdcomic" bosszone="dongman_logo">动漫</a>
            </div>
            <div class="bdwrap">
              <div class="bd" id="js_bdgame" data-beacon-expo="qn_elementid=youxi&qn_event_type=show" data-beacon-click="qn_elementid=youxi&qn_event_type=click" bosszone="youxi" bossexpo="bg_youxi">
                <div class="index-dom-html structure-text structure" id="index_games_20200724"></div>
                <!--include virtual="/ninja/index_games_20200724.htm" -->
              </div>
              <div class="bd undis" id="js_bdcomic" bosszone="dongman" bossexpo="bg_dongman">
                <div class="index-dom-html" id="index_comic_2018test"></div>
                <!--include virtual="/ninja/index_comic_2018test.htm" -->
              </div>
            </div>
          </div>
          <div class="col col-1 col-last col-tencent" bosszone="caibao" bossexpo="bg_caibao">
            <div class="title">
              <a class="txt active" href="https://www.tencent.com/zh-cn/company.html" target="_blank" data-beacon-expo="qn_elementid=caibao_logo&qn_event_type=show" data-beacon-click="qn_elementid=caibao_logo&qn_event_type=click" bosszone="caibao_logo">财报</a>
            </div>
            <div data-beacon-expo="qn_elementid=caibao&qn_event_type=show" data-beacon-click="qn_elementid=caibao&qn_event_type=click" bosszone="caibao">
              <div class="index-dom-html structure-text structure" id="index_caibao_2018_test"></div>
              <!--include virtual="/ninja/index_caibao_2018_test.htm" -->
            </div>
          </div>
        </div>
        <!-- 星座每日运势/游戏动漫/财报 -->

        <!-- 高清组图 -->
        <div class="layout">
          <div class="index-dom-html structure-imgs" id="hd_picture_20200724"></div>
        </div>
        <!--include virtual="/ninja/hd_picture_20200724.htm"-->
        <!-- /高清组图 -->

        <!-- 广告4 -->
        <div class="layout qq-gg gg-4">
          <!--NEW_QQCOM_N_Width4_div AD begin...."l=NEW_QQCOM_N_Width4&log=off"--><div id="NEW_QQCOM_N_Width4" style="width:1400px;height:90px;" class="l_qq_com"></div><!--NEW_QQCOM_N_Width4 AD end --><!--[if !IE]>|xGv00|988d4677a77862e5edbcb3f52aba9377<![endif]-->
        </div>
        <!-- /广告4 -->

        <!--NEW_WWW_RM_RightMove1_div AD begin...."l=NEW_WWW_RM_RightMove1&log=off"--><div id="NEW_WWW_RM_RightMove1" style="width:400px;height:300px;display:none;margin:0 auto;" class="l_qq_com"></div><!--NEW_WWW_RM_RightMove1 AD end --><!--[if !IE]>|xGv00|c020c69143131b5b928166fd08447a05<![endif]-->
        <!--NEW_QQ_Couplet_div AD begin...."l=NEW_QQ_Couplet&log=off"--><div id="NEW_QQ_Couplet" style="width:100px;height:300px;display:none;" class="l_qq_com"></div><!--NEW_QQ_Couplet AD end --><!--[if !IE]>|xGv00|5b0b305532624ef799bf7dc76b9e5338<![endif]-->

        <!-- 版权信息 -->
        <div class="layout qq-footer" bosszone="dibu" bossexpo="bg_dibu">
      <a href="http://www.tencent.com/" target="_blank" rel="nofollow">关于腾讯</a> | <a href="http://www.tencent.com/index_e.shtml"
        target="_blank" rel="nofollow">About Tencent</a> | <a href="http://www.qq.com/contract.shtml" target="_blank"
        rel="nofollow">服务协议</a>
      | <a href="https://privacy.qq.com/" target="_blank" rel="nofollow">隐私政策</a> | <a href="http://open.qq.com/"
        target="_blank" rel="nofollow">开放平台</a><!--  | <a href="http://www.tencentmind.com/" target="_blank" rel="nofollow">广告服务</a> -->
      | <a href="https://www.tencent.com/zh-cn/partnership.html" target="_blank" rel="nofollow">商务洽谈</a> | <a href="http://hr.tencent.com/"
        target="_blank" rel="nofollow">腾讯招聘</a> | <a href="http://gongyi.qq.com/" target="_blank" rel="nofollow">腾讯公益</a>
      | <a href="http://kf.qq.com/" target="_blank" rel="nofollow">客服中心</a> | <a href="http://www.qq.com/map/" target="_blank"
        rel="nofollow">网站导航</a> | <a href="http://dldir1.qq.com/dlomg/qqcom/mini/QQNewsMini5.exe" rel="nofollow">客户端下载</a><!--
      | <a href="http://www.tencent.com/law/mo_law.shtml?/law/copyright.htm" target="_blank" rel="nofollow">版权所有</a>--><br>
      <a href="http://szwljb.sz.gov.cn/" target="_blank" rel="nofollow">深圳举报中心</a> | <a href="http://ga.sz.gov.cn"
        target="_blank" rel="nofollow">深圳公安局</a> | <a href="http://www.qq.com/dzwfggcns.htm" target="_blank" rel="nofollow">抵制违法广告承诺书</a><!--  | <a class="lchot" href="http://www.gdis.cn/admin/newstext_netsun.asp" target="_blank" rel="nofollow">阳光·绿色网络工程</a> -->
      | <a href="http://www.qq.com/copyright.shtml" target="_blank" rel="nofollow">侵权投诉指引</a> | <a href="https://www.qq.com/bjhlwfyflfwgzz.shtml"
        target="_blank" rel="nofollow">北京互联网法院法律服务工作站</a> | <a href="https://gdca.miit.gov.cn/"
        target="_blank" rel="nofollow">广东省通管局</a><br>
      <span><a href="http://www.qq.com/culture.shtml" target="_blank" rel="nofollow">粤网文[2020]3396-195号</a> <a href="http://www.qq.com/internet_licence.htm"
          target="_blank" rel="nofollow">新出网证（粤）字010号</a> <a href="http://www.qq.com/cbst.shtml" target="_blank" rel="nofollow">网络视听许可证1904073号</a>
        增值电信业务经营许可证：<a href="http://beian.miit.gov.cn/" target="_blank" rel="nofollow">粤B2-20090059</a> <a href="http://www.qq.com/icp1.shtml"
          target="_blank" rel="nofollow">B2-20090028</a>
      </span><br>
      <a href="http://www.qq.com/scio.htm" target="_blank" rel="nofollow">新闻信息服务许可证</a> <a href="http://www.qq.com/xwdz.shtml"
        target="_blank" rel="nofollow">粤府新函[2001]87号</a> 违法和不良信息举报电话：0755-83765566-4 <a style="" target="_blank" href="http://www.beian.gov.cn/portal/registerSystemInfo?recordcode=44030002000001"><span>粤公网安备
          44030002000001号</span></a><br>
      <a href="http://www.qq.com/spyp.htm" target="_blank">互联网药品信息服务资格证书 （粤）—非营业性—2017-0153</a><br>
      <span>Copyright  1998 - </span><span id="currentFullYear">2018</span> <span>Tencent. All Rights Reserved</span>
      <div class="footernew">
        <div class="footernewdiv" style="width:685px">
          <p style="width:128px;height:52px;">
          <span style="padding:0;" class="fl"><a href="//www.piyao.org.cn/" target="_blank" rel="nofollow"><img border="0" alt="中国互联网联合辟谣平台" src="//inews.gtimg.com/newsapp_bt/0/0923160330827_8387/0" style="
        width: 128px;
        height: 52px;
    "></a></span>
        </p>
        <p>
          <span style="width:44px;" class="fl"><a href="http://www.12377.cn/" target="_blank" rel="nofollow"><img width="44" height="44" border="0" alt="中国互联网举报中心" src="//inews.gtimg.com/newsapp_bt/0/0923160410686_7902/0"></a></span>
          <span style="width:64px;" class="fr"><a class="lcblack" href="http://www.12377.cn/" target="_blank" rel="nofollow">中国互联网<br>
          举报中心</a></span>
        </p>
        <p>
          <span style="width:44px;" class="fl"><a href="http://www.wenming.cn" target="_blank" rel="nofollow"><img width="44" height="42" border="0" alt="中国文明网传播文明" src="//inews.gtimg.com/newsapp_bt/0/0923160427468_4512/0"></a></span>
          <span style="width:64px;" class="fr"><a class="lcblack" href="http://www.wenming.cn" target="_blank" rel="nofollow">中国文明网<br>传播文明</a></span>
        </p>
        <p style="width:128px;height:52px;border:0;">
          <span style="padding:0;" class="fl"><a href="https://ss.knet.cn/verifyseal.dll?sn=2010051300100001081&ct=df&a=1&pa=337337" target="_blank" rel="nofollow"><img border="0" alt="诚信网站" src="//inews.gtimg.com/newsapp_bt/0/0923160441309_8267/0"></a></span>
        </p>
        <p>
          <span style="width:44px;" class="fl"><a href="http://szcert.ebs.org.cn/6917b6fe-b844-4e12-97c5-85b8d1df30ed" target="_blank" rel="nofollow"><img src="//inews.gtimg.com/newsapp_bt/0/0923160507619_4319/0" title="深圳市市场监督管理局企业主体身份公示" alt="深圳市市场监督管理局企业主体身份公示"></a></span>
          <span style="width:64px;" class="fr"><a class="lcblack" href="http://szcert.ebs.org.cn/6917b6fe-b844-4e12-97c5-85b8d1df30ed" target="_blank" rel="nofollow">工商网监<br>电子标识</a></span>
        </p>
        </div>
      </div>
    </div>
    <script type="text/javascript">
      var currentFullYear = (new Date()).getFullYear();
      document.getElementById('currentFullYear').innerHTML = currentFullYear;
    </script>
    <!--b4ce8cf858f404a6d8f2081d0b7ee0ca-->
        <!-- /版权信息 -->

        <!-- 电梯 -->
        <div class="elevator" id="elevator">
          <a href="javascript:" class="refresh fix" id="js_refresh" title="刷新" bosszone="shuaxin"><span class="icon"></span><br />刷新</a>
          <a href="https://support.qq.com/products/4312" target="_blank" class="feedback fix" title="用户反馈" data-beacon-expo="qn_elementid=fankui&qn_event_type=show" data-beacon-click="qn_elementid=fankui&qn_event_type=click" bosszone="fankui">用户<br />反馈</a>
          <a href="javascript:void(0)" target="_self" class="backtop" id="js_gotop" title="返回顶部" data-beacon-expo="qn_elementid=dingbu&qn_event_type=show" data-beacon-click="qn_elementid=dingbu&qn_event_type=click" bosszone="dingbu"><span class="icon"></span></a>
        </div>
        <!-- /电梯 -->

      </div>

      <!-- 视频弹层 -->
      <div id="pop-player" class="pop-player">
      <div class="inner">
        <div class="player-hd">
          <div id="video-pop" class="player-container"></div>
          <div class="tit"></div>
          <a class="close-btn" href="javascript:;">关闭</a>
        </div>
        <div class="player-ft cf">
          <div class="scroll-mod">
            <ul class="player-list cf"></ul>
            <a href="javascript:;" class="q-icons btn btn-left"></a>
            <a href="javascript:;" class="q-icons btn btn-right"></a>
          </div>
        </div>
      </div>
    </div>

    <div id="pop-player2" class="pop-player pop-player2">
      <div class="inner">
        <div class="player-hd">
          <div id="video-pop2" class="player-container"></div>
          <div class="tit"></div>
          <a class="close-btn" href="javascript:;">关闭</a>
          <div class="hd-info"></div>
        </div>
        <div class="player-ft cf">
          <div class="scroll-mod">
            <ul class="player-list cf"></ul>
          </div>
          <a href="javascript:;" class="q-icons btn btn-left"></a>
          <a href="javascript:;" class="q-icons btn btn-right"></a>
        </div>
      </div>
    </div>

    <div id="min-player" class="min-player">
      <div class="min-hd cf">
        <h2 class="tit fl"></h2>
        <a class="close-btn fr" href="javascript:;">关闭</a>
      </div>
      <div class="min-bd">
        <div id="video-min" class="player-container"></div>
      </div>
    </div><!--ec4544fe058862e423cdc3225e110e49--><!--[if !IE]>|xGv00|6254f87b049c4c938babd0b80a015de3<![endif]-->
      <!-- /视频浮层 -->

      
      <script type="text/javascript">
      //<![CDATA[
      var serverTime = new Date(2021, 11-1, 23, 21, 03, 24);
      //]]>
      </script>
      <script src="//mat1.gtimg.com/www/asset/lib/jquery/jquery/jquery-1.11.1.min.js"></script>
      <script type="text/javascript" src="//joke.qq.com/lucky/jquery.qqscroll.js"></script>
      <script src="//vm.gtimg.cn/tencentvideo/txp/js/txplayer.js" charset="utf-8"></script>
      <script src="//mat1.gtimg.com/qqcdn/qqindex2021/dist/qqcom/beacon.min.js" charset="utf-8"></script>
      <script src="//mat1.gtimg.com/pingjs/ext2020/configF2017/5d09e4c5.js" charset="utf-8"></script>
      <script src="//mat1.gtimg.com/pingjs/ext2020/configF2017/5e857945.js" charset="utf-8"></script>
      <script src="//mat1.gtimg.com/pingjs/ext2020/dc2017/publicjs/m/ping.js"></script>
        <script>if(typeof(pgvMain) == 'function')pgvMain();</script>
      <script src="//mat1.gtimg.com/qqcdn/qqindex2021/qqhome/js/qq_91c04101.js" charset="utf-8"></script>

      <script type="text/javascript" src="//imgcache.qq.com/qzone/biz/comm/js/qbs.js"></script>
    <script type="text/javascript">
    var TIME_BEFORE_LOAD_CRYSTAL = (new Date).getTime();
    </script>
    <script src="//ra.gtimg.com/web/crystal/v4.7Beta04Build040/crystal-min.js" id="l_qq_com" arguments="{'extension_js_src':'//ra.gtimg.com/web/crystal/v4.7Beta04Build040/crystal_ext-min.js', 'jsProfileOpen':'false', 'mo_page_ratio':'0.01', 'mo_ping_ratio':'0.01', 'mo_ping_script':'//ra.gtimg.com/sc/mo_ping-min.js'}"></script>
    <script type="text/javascript">
    if(typeof crystal === 'undefined' && Math.random() <= 1) {
      (function() {
        var TIME_AFTER_LOAD_CRYSTAL = (new Date).getTime();
        var img = new Image(1,1);
        img.src = "//dp3.qq.com/qqcom/?adb=1&dm=www&err=1002&blockjs="+(TIME_AFTER_LOAD_CRYSTAL-TIME_BEFORE_LOAD_CRYSTAL);
      })();
    }
    </script>
    <style>.absolute{position:absolute;}</style>
    <!--[if !IE]>|xGv00|34ba8056fb38cac38d53027a9f08814a<![endif]-->

      <script>
      // 腾讯分析代码
      var _mtac = {};
      (function() {
          var mta = document.createElement("script");
          mta.src = "//pingjs.qq.com/h5/stats.js?v2.0.2";
          mta.setAttribute("name", "MTAH5");
          mta.setAttribute("sid", "500460529");
          var s = document.getElementsByTagName("script")[0];
          s.parentNode.insertBefore(mta, s);
      })();
      </script>

    </body>

    </html>
    """#.data(using: .utf8)!
          
          var html = try NSMutableAttributedString(data: data,
                                                   options: [.documentType: NSAttributedString.DocumentType.html,
                                                             .characterEncoding: String.Encoding.utf8.rawValue],
                                                   documentAttributes: nil)
              .string
          
          html = html.reduce("") { result, item in
              
              if item != "\n" {
                  if item.st.isObjectReplacement {
                      return result
                  }
                  
                  if item.isWhitespace {
                      return result
                  }
              } else if result.last == "\n" {
                  return result
              }
              
              return result + item.description
          }.trimmingCharacters(in: .whitespacesAndNewlines)
                    
          print(try duration())
          print(html)
      }

    }
    
    
}
