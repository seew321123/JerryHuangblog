
视频组件开发
===========

## 开发方式

新建通用组件，平台选择 `web_pc`，整体上和之前组合模块原子组件中的 Vue 组件类似。

## 不同之处

为了解耦和提高性能，事件监听需要自己处理

## API

```
// 获取容器宽度和高度
const { width, height } = app.dvideo.getOffset()

// 监听容器宽度变化
app.event.on('dvideo:resize', this.onResize)

// 监听选项改变
app.event.on('css_ctx:changed', this.onChanged)

// 刷新整个组件
app.event.emit('system:refresh')
```

## 参考示例

http://www.demlution.com/store/admin/page.html#/build/papp/9536

## 依赖

- TweenMax: 参考 http://www.demlution.com/store/admin/page.html#/build/papp/9050

## 计划安排

通用组件里面开发的组件可以支持添加到PC/手机/微场景网页，这样就能实现一次开发，兼容多个平台

# 静态组件

通用组件开始支持旧版模块开发中的单条目/多条目组件

## 语法保持一致

```
<div>
  [[ c.text1 ]]
  [[ c.image1 ]]
  <div [[ for.items ]]>
    [[ i.text1 ]]
    [[ i.image1 ]]
  </div>
</div>
```


## 配置

![ ](https://s2.d2scdn.com/2018/01/27/Fib6zFoVOaQl6LO7lxQZLA49nuhD.png)


## 参考组件

http://www.demlution.com/store/admin/page.html#/build/papp/9848



## 分类

和组合模块原子组件一样的分类和标签

## 开发

开发模型和小程序类似

参考应用 http://www.demlution.com/store/admin/page.html#/build/papp/9810

```
<ul class="list-group">
  <li class="list-group-item" v-for="item in items">{{ item.display.name }}</li>
</ul>
```

```
export default {
  data () {
    return {
      items: []
    }
  },
  async created () {
    this.load()
    app.event.on('liveconfig:changed', this.load)
  },
  methods: {
    async load () {
      this.items = await app.loadLiveItems()
    }
  },
  destroyed () {
    app.event.removeListener('liveconfig:changed', this.load)
  }
}
```


## 安排

可以从之前的小程序动态模块或者组合模块原子组件动态模块中挑选一些合适的导入到通用组件，
在通用组件开发的组件可以适配所有平台
