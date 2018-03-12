
应用多页面支持
=============

## 核心概念

- 主组件：应用的入口，同时存放应用的数据集、云函数、应用配置
- 从组件：独立的通用组件，通过设置关联主组件可以实现调取组组件的内容
  - 独立组件: 把从组件分类设定为独立组件可以实现一些可以加到任意页面的独立组件
  - 页面组件: 把从组件分类设定为页面组件可以实现一些只能在特定页面使用的组件
- 组件页面：可以在主组件元数据配置界面配置一个应用下的多个页面，页面 slug 只能是纯字母组合(`^[a-z]+$`)

注意事项

- 主组件必须设定唯一的 slug，slug 只能是纯字母组合(`^[a-z]+$`)
- 一个主组件可以有多个从组件
- 从组件通过关联主组件成为从组件
- 主组件必须设置数据集、云函数、应用配置
- 从组件不能设定自己的数据集、云函数、应用配置
- 在列表页按应用筛选可以筛选出该应用下的所有主从组件
- 页面组件必须在元数据配置界面指定自己属于哪个页面

## 组件开发设置流程

主组件主要需要配置应用唯一标识符和多页面，参考 [10090/元数据设置](http://www.demlution.com/store/admin/page.html#/build/papp/10090)

![](https://s2.d2scdn.com/2018/03/02/FsiRVDkzuF1x_9i1az_1_1p6jP1P.png)


从组件需要关联父组件，页面组件还需要设置自己处于哪个页面，参考 [10091/元数据设置](http://www.demlution.com/store/admin/page.html#/build/papp/10091)

![](https://s2.d2scdn.com/2018/03/02/FgHx1G-cn700PK5E8IS9e2EZliTW.png)


## 页面添加流程

用户添加应用之后会自动在页面选择器添加应用所有的页面，点击对应页面进入对应页面的独立编辑界面

![](https://s2.d2scdn.com/2018/03/02/Fmqf1b-fwOYTsYm0DdVDidCAXG45.png)

独立编辑页面可以查看到当前页面下特定的组件

![](https://s2.d2scdn.com/2018/03/02/FpZpPgJ5IWgFpcX7KQ4b8vsH2Mnf.png)

## 页面链接结构

应用独立页面完全固定链接，完整命名规则：`/app-${slug}/${pageSlug}-${arg1}-${arg2}.html?${params}`

以上述应用为例，应用 slug 为 `toutiao`，那么 `list` 页面链接固定为 `/app-toutiao/list.html`

如果需要加到链接 path 部分的参数，可以通过连字符分隔：`/app-toutiao/detail-arg1-arg2.html`，这种方式可以很灵活的实现很多复杂的需求

具体看下部分关于链接的使用方式

## 新增相关 API

```
// 获取主应用的 slug
app.getPappSlug()


// 获取页面路径参数
app.getPappPageArgs()

示例：
  page url: /app-toutiao/list.html
  app.getPappPageArgs() === ['list']
  page url: /app-toutiao/list-arg1-arg2.html
  app.getPappPageArgs() === ['list', 'arg1', 'arg2']

注意：
开发者界面一律返回 []


// 获取页面查询参数
app.getPageParams()

示例：
  page url: /app-toutiao/list.html?a=1&b=2
  app.getPageParams() === {a: '1', b: '2'}


// 构造固定链接
app.buildPappUrl(pageSlug, ...args, params = {})

示例：
  app.buildPappUrl('list') === `/app-toutiao/list.html`
  app.buildPappUrl('list', 'arg1') === `/app-toutiao/list-arg1.html`
  app.buildPappUrl('list', 'arg1', 'arg2', {a: 1, b: 2}) === `/app-toutiao/list-arg1-arg2.html?a=1&b=2`
```

永远不要自己手动去拼接链接，而是通过系统函数调用实现，下面是一个常见的模式：在组件内定义一个 `url` 函数，模板和组件内都能够快速构造固定链接

html
```
<a :href="url('detail', item.id)">
  {{ item.data.name }}
</a>
```

js
```
methods: {
    url (...args) {
      return app.buildPappUrl(...args)
    }
  }
}
```

## 示例应用

开发界面：http://www.demlution.com/store/admin/page.html#/build/10090

最终打开效果：http://www.llg.d2shost.net/app-toutiao/list.html


## 已知问题正在处理

- [ ] 从组件还不能调用主组件的应用数据设置界面
- [ ] 小程序多页面预览和开发支持
- [ ] 从网站跳转到个人中心的 API 支持
