
工单：http://www.demlution.com/store/admin/page.html#/dissue/9627

## new Date() 在不同平台表现不一致

![ ](https://s2.d2scdn.com/2018/03/06/FvFps-y5JIhB83ON6lITcJORpvhD.png)

```
new Date('2018-03-06 10:00')
```

左上是 Chrome，左下是 Firefox，一切正常

但是在右侧 Safari ，这种写法会直接导致报错

安全处理方法：

```
// ISO 8601
new Date("2018-03-06T02:00:00.000Z")

// 分散写，注意月份要减去一
new Date(2018, 3 - 1, 6, 10, 0)

// 时间戳
new Date(1520302090559)
```

## 如何获取 Date 对象 的 ISO 8601 无时区格式

担路网后端数据保存/返回的基本上都是形如 `2018-03-06T10:21:01.008` 格式的ISO 8601 无时区格式字符串，
下面的代码演示了怎么从 Date 对象安全的转换到我们需要的格式

```
const date = new Date()
date.setHours(date.getHours() - date.getTimezoneOffset() / 60)
const dateISO = date.toISOString().replace('Z', '')

// dateISO === "2018-03-06T10:21:01.008"
```

## 需要处理的模块

@songziqiang http://www.demlution.com/store/admin/page.html#/build/papp/10123
