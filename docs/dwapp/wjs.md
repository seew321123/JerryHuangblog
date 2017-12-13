
wjs 语法文档
===========

## 综述

wjs 是 Vue 组件和 小程序页面的超集，使用 wjs 编写代码可以同时支持 Vue 组件和小程序组件。


## wjs 的语法概览

wjs 文件需要通过 `export default` 导出一个对象，对象有三种属性

- data: 默认绑定的数据，以及该组件可以动态修改的数据
- events: 比如 `onShow` 和 `onHide` 等等
- methods: 自定义方法，可以在模板中触发也能被其它方法调用

```js
export default {
  data: {
    item: {},
    items: {}
  },
  onShow () {
    // 组件被重新渲染时触发
  },
  onHide () {
    // 组件隐藏时触发
  },
  methods: {
    handleClick () {
      //
    }
  }
}
```

API

全局变量 `dw` 是一个 API 代理，可以通过他调用很多 API，`dw` 具体接口如下

| 对象属性                            | 类型       | 返回值     | 说明                                       |
| ------------------------------- | -------- | ------- | ---------------------------------------- |
| platform                        | string   |         | 区别浏览器环境(web)与小程序环境(dwapp)                |
| config.company.id               | number   |         | 对应商家ID                                   |
| config.company.nickname         | string   |         | 对应商家用户名                                  |
| data                            | object   |         | 直接访问数据绑定                                 |
| setData(path, value)            | function |         | 修改数据绑定必须使用此方法                            |
| setDatas(obj)                   | function |         | 批量修改数据绑定                                 |
| setWxParse(path, description)   | function |         | 设定富文本数据                                  |
| alert(title, content, callback) | function |         | 显示一个简单的弹出框                               |
| goToHref(dwHref)                | function |         | 跳转到其他页面，例如：dw.goToHref('list-product')   |
| goToPage(name, params = {})     | function |         | 跳转到当前应用的某个子页面，例如：dw.goToPage('detail', {id: item.id}) |
| request(path, data)             | function | Promise | 发起 API 请求                                |
| setExtraQuery(obj)              | function |         | [转发]设置转发时携带额外的查询参数                       |
| setShareTitle(title)            | function |         | [转发]设置转发时标题，会覆盖默认标题                      |
| setShareImageUrl(imageUrl)      | function |         | [转发]设置转发时图片，会覆盖默认截图                      |
| addShareCallback(type, func)    | function |         | [转发]设置转发时回调函数(success, fail)             |
| setOveride(key, value)          | function |         | [转发]重载内置方法如  onShareAppMessage           |
| wx                              | object   |         | 微信内置的 wx 对象，只在小程序内部可用                    |
| app                             | object   |         | AppProxy 对象，详细参考下表                       |

`dw.app` 是一个对象，用来处理应用相关的 API，具体接口如下，其中 wx 开头的接口只能在微信使用

| 对象属性        | 类型       | 参数              | 返回值     | 说明                    |
| ----------- | -------- | --------------- | ------- | --------------------- |
| getRows     | function | object          | Promise | 同应用 API               |
| query       | function | object          | Promise | 同应用 API               |
| createRow   | function | tableName, data | Promise | 同应用 API               |
| updateRow   | function | rowId, data     | Promise | 同应用 API               |
| removeRow   | function | rowId           | Promise | 同应用 API               |
| run         | function | action, kwargs  | Promise | 同应用 API               |
| isUserLogin | function |                 | Promise | 判断用户是否登录              |
| wxGotoLogin | function | query           |         | [微信]跳转到登录页面，支持设置参数    |
| wxLogin     | function |                 | Boolean | [微信]判断用户是否登录，没有登录自动跳转 |

## 细节

### `dw.setData(key, value)` 支持修改嵌套对象

```javascript
export default {
  data: {
    key1: 1,
    obj: {
      key2: 3
    }
  },
  onShow () {
    dw.setData('key1', 2)
    dw.setData('obj.key2', 4)
  }
}

// 输出结果: { "key1": 2, "obj": { "key2": 4 } }
```

### `dw.setDatas(obj)` 支持批量更新数据

功能与 `dw.setData(key, value)` 一致，不过可以支持多组数据，如果要修改多条数据，强烈建议使用此 API，性能更好。

```javascript
export default {
  data: {
    key1: 1,
    obj: {
      key2: 3
    }
  },
  onShow () {
    dw.setDatas({
      key1: 2,
      'obj.key2': 4
    })
  }
}

// 输出结果: { "key1": 2, "obj": { "key2": 4 } }
```


###  弹出窗口

`dw.alert(title, content, callback)` 在 web 端渲染为 SweetAlert，在小程序内渲染为 `wx.showModal()`，可以用于简单的弹出一个弹出框

### 分享相关 API

| 对象属性                         | 类型       | 返回值  | 说明                             |
| ---------------------------- | -------- | ---- | ------------------------------ |
| setExtraQuery(obj)           | function |      | [转发]设置转发时携带额外的查询参数             |
| setShareTitle(title)         | function |      | [转发]设置转发时标题，会覆盖默认标题            |
| setShareImageUrl(imageUrl)   | function |      | [转发]设置转发时图片，会覆盖默认截图            |
| addShareCallback(type, func) | function |      | [转发]设置转发时回调函数(success, fail)   |
| setOveride(key, value)       | function |      | [转发]重载内置方法如  onShareAppMessage |


### 页面跳转如何处理

- 跳转到其他页面，使用 dw.goToHref('list-product')
- 跳转到应用的子页面，使用 dw.goToPage('detail', {id: item.id})

### 网络请求

- dw.request(path, data) 支持模拟登录
- dw.request(path, data) 支持多种语法，具体如下表




path 由三部分组成：method + resource_name + action_name

- **method**: get/post/put/delete/dynamic_get/dynamic_post
- **resource_name**: TastypieApi resource_name
- **action_name**: 可以是默认的 query/get/put/delete 也可以是自定义的 action_name



| 请求路径                                     | 对应的商家中心语法                     | 语义                     |
| ---------------------------------------- | ----------------------------- | ---------------------- |
| dw.request('get/company/query', query)   | Api.company.query(query)      | 获取资源数据列表               |
| dw.request('post/company/', data)        | Api.company.save(data)        | 创建单个资源数据               |
| dw.request('get/company/get', {id: 500}) | Api.company.get({id: 500})    | 读取单个资源数据               |
| dw.request('put/company/update', {id: 500}) | Api.company.update({id: 500}) | 更新单个资源数据               |
| dw.request('delete/company/delete', {id: 500}) | Api.company.delete({id: 500}) | 删除单个资源数据               |
| dw.request('get/company/action', query)  | Api.company.action(query)     | 自定义 static action 操作数据 |
| dw.request('post/company/action', query) | Api.company.action(query)     | 自定义 static action 操作数据 |
| dw.request('dynamic_get/company/action', query) | Api.company.action(query)     | 自定义 action 操作数据        |
| dw.request('dynamic_post/company/action', query) | Api.company.action(query)     | 自定义 action 操作数据        |

为什么看起来比商家中心版本复杂了很多？因为小程序版本的请求不再依赖于 API Schema

## 登录相关的问题处理

如果一个页面需要登录才能使用，特别是个人中心组件，在 onShow 方法内做如下处理

```javascript
async onShow () {
  if (dw.app.wxLogin()) {
    //
  }
}
```

上述代码会自动处理：已登录可见；未登录跳转到登录，用户登录后跳转回此页面

如何获取用户信息

```javascript
if (dw.app.wxLogin()) {
  const response = await dw.request('get/company_account/get_siteuser_data')
  dw.setData('load', true)
  dw.setData('siteuser', response.data.profile)
}
```
