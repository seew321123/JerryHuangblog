
## 分包加载

从今天晚上更新开始，小程序开始支持自动分包加载

- 小程序整体大小从 2M 提升到 4M
- 小程序页面数量限制放开到 100 页
- 分包加载无需设置，当小程序包体积大于 1.6M 时自动拆分成两个包


## 部分组件不兼容分包功能

因为以前部分组件直接使用了 `wx.navigateTo`，在分包环境中不支持。
所有链接跳转必须通过 `dw.goToHref` 或者 `dw.goToPage`，只有这样才能兼容分包加载，不能使用 `wx.navigateTo`

比如支付接口，可以按照下面代码修改

```
wx.navigateTo({ url: '/pages/charge/index?id=' + res.data.id });
```

```
dw.goToHref(`plugin-charge?id=${id}`)
```

## 插件机制与支付插件

分包加载之后，支付功能只能通过插件引入，需要在依赖里面声明小程序插件依赖

参考：http://www.demlution.com/store/admin/page.html#/build/papp/9463


## 需要修改 14 个模块

在代码搜索页面搜索 `navigateTo` 可以查看所有需要修改的组件，一共 14 个

http://www.demlution.com/store/admin/page.html#/search/list?screen=papp

- [x] 8908 guxiaoliang
- [x] 8593 liyuanpei
- [ ] 8382 shengyang
- [x] 8072 songziqiang
- [ ] 7926 linliguang
- [x] 7868 songziqiang
- [x] 7240 songziqiang
- [x] 7189 guxiaoliang
- [ ] 7019 risent
- [x] 6959 songziqiang
- [x] 6953 guxiaoliang
- [x] 6900 songziqiang
- [x] 6899 songziqiang
- [x] 6726 guxiaoliang


## 小程序链接规则

这次更新之后，小程序链接规则固定为 `${group}-${slug}`。
如果需要增加本地组件，一律以 `plugin-` 开头。

```
local:
  "account-login",
  "plugin-*",
online:
  "default-*",
  "list-*",
  "detail-*",
  "feature-*",
  "mall-*",
  "section-*",
  "forum-*",
  "papp_*",
```
