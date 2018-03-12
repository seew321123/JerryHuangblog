
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

完整的 API 方法参考下表

| 对象属性              | 类型       | 对应的 Vue 组件属性  | 说明                   |
| ----------------- | -------- | ------------- | -------------------- |
| data              | object   | data          | 数据绑定                 |
| methods           | object   | methods       | 方法绑定                 |
| onLoad            | function | beforeCreate  | 生命周期函数--监听页面加载       |
| onShow            | function | created       | 生命周期函数--监听页面显示       |
| onReady           | function | mounted       | 生命周期函数--监听页面初次渲染完成   |
| onHide            | function | beforeDestroy | 生命周期函数--监听页面隐藏       |
| onUnload          | function | destroyed     | 生命周期函数--监听页面卸载       |
| onPullDownRefresh | function |               | 页面相关事件处理函数--监听用户下拉动作 |
| onReachBottom     | function |               | 页面上拉触底事件的处理函数        |
| onShareAppMessage | function |               | 不建议直接使用，参考下面章节       |
| onPageScroll      | function |               | 页面滚动触发事件的处理函数        |

详细参考 https://mp.weixin.qq.com/debug/wxadoc/dev/framework/app-service/page.html

光速入门 onLoad -> onShow -> onReady -> onHide -> onUnload

注意事项：

- onLoad/onUnload/onReady 在小程序端只会执行一次，但是在 web 端会跟随 Vue 组件生命周期
- onPullDownRefresh/ onReachBottom/onPageScroll 在 web 端不会主动执行
- onShareAppMessage 参考下文

### API: dw.*

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

### API: dw 存储API


| 对象属性                        | 说明        |
| --------------------------- | --------- |
| getPageLocals(key)          | 获取页面级变量   |
| setPageLocals(key, value)   | 设置页面级变量   |
| getGlobalLocals(key)        | 获取小程序全局变量 |
| setGlobalLocals(key, value) | 设置小程序全局变量 |
| getStorageSync(key)         | 获取小程序永久变量 |
| setStorageSync(key, value)  | 设置小程序永久变量 |

如果把 dw.setData 视为第一级数据存储，那么一共有四级数据存储API：

组件级 dw.setData -> 页面级 dw.setPageLocals -> 小程序级 dw.setGlobalLocals -> 永久 dw.setStorageSync

使用这些接口可以实现很多功能，下面分场景介绍

#### 场景一：一个页面内多个组件如何共享同一个请求的数据？

这个问题的纠结之处在于，你无法保证所有模块都存在，也不能保证他们的添加顺序

参考 http://www.demlution.com/store/admin/page.html#/build/papp/8556

```javascript
async onShow () {
  const p1 = dw.getPageLocals('company_account:get_siteuser_data') || dw.request('get/company_account/get_siteuser_data')
  dw.setPageLocals('company_account:get_siteuser_data', p1)
  console.log(await p1)
}
```

上面这段代码可以保证：如论多少个组件添加了这段代码，每个人获取到的 p1 都是同一个，
也就是只有一个请求，但是所有组件都可以获取到同一份数据

#### 场景二：跳转到新的页面如何携带数据？

可以暂时保存到 dw.setGlobalLocals

### API: dw 事件 API


| 对象属性           | 说明        |
| -------------- | --------- |
| dw.event       | 组件级事件管理器  |
| dw.pageEvent   | 页面级事件管理器  |
| dw.globalEvent | 小程序级事件管理器 |

和存储类似，事件管理器分为三级，具体使用方法参考应用的[事件管理器](/docs/docs/fe/event.html)

注意事项

- 注意作用域：dw.event 只在当前组件有效
- 注意事件名称冲突，为了防止冲突，可以在起事件名的时候带上当前组件的 ID
- 一定要在合理的时机销毁事件监听器
- 在 web 端，dw.pageEvent 和 dw.globalEvent 都是全局的，需要注意事件名称冲突和合理销毁事件

#### 场景一：某个应用的 admin_pc.js 修改了数据想要 dwapp_mobile.wjs 重新渲染？

这个场景可以在 dwapp_mobile.wjs 中监听事件，在 admin_pc.js 触发事件即可

```javascript
// dwapp_mobile.wjs
dw.event.on('update', item => {
  console.log('update', item)
})

// admin_pc.js
dw.event.emit('update', item)
```

#### 场景二：我想和当前页面的其他组件通信怎么办

使用 dw.pageEvent，为了防止冲突，可以在起事件名的时候带上当前组件的 ID

#### 场景三：某个应用的 A 页面想通知 B 页面

因为跨页面，所以需要使用全局事件 dw.globalEvent

### API: dw.app 应用 API

dw.app 是一个对象，用来处理应用相关的 API，具体接口如下，其中 wx 开头的接口只能在微信使用

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


示例：http://www.demlution.com/store/admin/page.html#/build/dwapp/9464

代码：

```
export default {
  data: {
    a: 1,
    b: {
      c: 2
    },
    d: [3],
    e: [
      {f: 4}
    ],
    g: [
      {h: [5]}
    ]
  },
  onShow () {
    dw.setData('a', 'success')
    dw.setData('b.c', 'success')
    dw.setData('d[0]', 'success')
    dw.setData('e[0].f', 'success')
    dw.setData('g[0].h[0]', 'success')
  }
}
```

渲染结果：

```
{
  "a": "success",
  "b": {
    "c": "success"
  },
  "d": [
    "success"
  ],
  "e": [
    {
      "f": "success"
    }
  ],
  "g": [
    {
      "h": [
        "success"
      ]
    }
  ]
}
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
