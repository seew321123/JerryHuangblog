
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
| request(path, data):Promise     | function | Promise | 发起 API 请求                                |
| setExtraQuery(obj)              | function |         | [转发]设置转发时携带额外的查询参数                       |
| setShareTitle(title)            | function |         | [转发]设置转发时标题，会覆盖默认标题                      |
| setShareImageUrl(imageUrl)      | function |         | [转发]设置转发时图片，会覆盖默认截图                      |
| addShareCallback(type, func)    | function |         | [转发]设置转发时回调函数(success, fail)             |
| setOveride(key, value)          | function |         | [转发]重载内置方法如  onShareAppMessage           |
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

