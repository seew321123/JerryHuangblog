
更新日志
=======

## 应用编辑器支持一键创建小程序页面

![](https://s2.d2scdn.com/2017/12/6/6efd6da3-7175-4a85-a2d5-2d7f3d67386d/Jietu20171206-182346.png)

## dw.request 兼容模拟用户登录

## wx-input 支持 `data-string-value` 和 `data-bind-value`

## `dw.setData(key, value)` 支持修改嵌套对象

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

## 增加 `dw.setDatas(obj)` 批量更新数据

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


## 增加 `dw.alert(title, content)` API

`dw.alert(title, content)` 在 web 端渲染为 SweetAlert，在小程序内渲染为 `wx.showModal()`


## 增加 `dw.setExtraQuery(obj)` 修改页面参数
