
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

| 对象属性                    | 类型       | 返回值     | 说明                        |
| ----------------------- | -------- | ------- | ------------------------- |
| platform                | string   |         | 区别浏览器环境(web)与小程序环境(dwapp) |
| config.company.id       | number   |         | 对应商家ID                    |
| config.company.nickname | string   |         | 对应商家用户名                   |
| data                    | object   |         | 访问数据绑定                    |
| setData(path, value)    | function |         | 修改数据绑定必须使用此方法             |
| request(path, data)     | function | Promise | 发起 API 请求                 |
| app                     | object   |         | AppProxy 对象，详细参考下表        |

`dw.app` 是一个对象，用来处理应用相关的 API，具体接口如下，其中 wx 开头的接口只能在微信使用

| 对象属性        | 类型       | 参数              | 返回值     | 说明          |
| ----------- | -------- | --------------- | ------- | ----------- |
| getRows     | function | object          | Promise | 同应用 API     |
| query       | function | object          | Promise | 同应用 API     |
| createRow   | function | tableName, data | Promise | 同应用 API     |
| updateRow   | function | rowId, data     | Promise | 同应用 API     |
| removeRow   | function | rowId           | Promise | 同应用 API     |
| run         | function | action, kwargs  | Promise | 同应用 API     |
| isUserLogin | function |                 | Promise | 判断用户是否登录    |
| wxGotoLogin | function |                 |         | [微信]跳转到登录页面 |

