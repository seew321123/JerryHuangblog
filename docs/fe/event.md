
事件管理器
=========

## 跨多个文件/组件/平台监听事件

```javascript
// 监听事件
app.event.on(eventName, listener)
//其中 `listener` 是一个函数，参数是下面的 `data`

// 触发事件
app.event.emit(eventName, data)
//触发事件可以携带数据

// 移除事件监听
app.event.removeListener(eventName, listener)
//移除事件监听之后，后面的 emit 将会被忽略
```

** 警告: 监听事件必须在合理的时机移除 ！！！**

监听事件必须在合理的时机移除，否则在重新渲染应用时会重复执行，下面的代码演示了如何在 Vue 组件里面逻辑完备的处理事件。

```javascript
export default {
  data () {
    return {}
  },
  created () {
    this.listener = (data) => {
      console.log('biu', data)
    }
    app.event.on('biu', this.listener)
  },
  mounted () {
    app.event.emit('biu', 'hello')
  },
  destroyed () {
    app.event.removeListener('biu', this.listener)
  }
}

```

## 事件管理器的特点和使用场景

- 支持一些内置事件
- 跨文件跨平台传递数据

典型场景

- 多个同级别的子组件之间的通信
- 管理界面(admin_pc)修改或者增加了条目，需要通知网页(web_pc)刷新列表


## 内置的事件监听

平台内置了一些事件，开发者可以选择监听事件进行相关的操作

### 自定义选项修改之后触发事件

事件名 `css_ctx:changed`

## 详细 API

https://nodejs.org/api/events.html



