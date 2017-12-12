
小程序静态和动态组件开发文档
==========================

========== 重要的事情要说三遍 ==========

以下是对小程序静态和动态/列表/详情模块开发文档的整理，关于应用组件和通用组件参考其他文档

以下是对小程序静态和动态/列表/详情模块开发文档的整理，关于应用组件和通用组件参考其他文档

以下是对小程序静态和动态/列表/详情模块开发文档的整理，关于应用组件和通用组件参考其他文档

========== 重要的事情要说三遍 ==========

## 代码在线编辑功能概览

在线的小程序代码编辑器支持 ES6+ 语法。通过 `export default {}` 导出一个 `Actor` 对象，
`Actor` 是对 Vue Component 和 小程序里面 Wx Page 对象的抽象。

* Actor 包括 data/event(onShow/onHide...)/methods 三部分组成
* dw 是一个超级 API 代理，相当于 Vue 和 Wx Page 里面的 this
* 读取 data 必须通过 `dw.data`，设置数据必须通过 `dw.setDate()`，不能直接给 `dw.data` 赋值
* event 和 methods 里面可以通过 `dw.methods` 访问其它方法
* 模板里面可以直接绑定事件到 methods 上


下面是一个典型的动态模块代码

http://www.demlution.com/store/admin/page.html#/build/dwapp/6414

1. 监听 onShow 事件，调用 dw.methods.load()
2. 执行 dw.methods.load()，调用 await dw.loadLiveItems() 获取数据
3. 调用 dw.setData('items', items) 修改 data 绑定的数据
4. dw.on('liveconfig:changed') 这是在监听动态模块设置选项修改之后重新加载数据

![ ](https://s2.d2scdn.com/2017/08/31/FroVhhNFEtuhYS1yD2PWS_zebOw3.png)


## 语法概览

下表列出了目前支持的语法类型。只有标记为`开发者是否可用`才能直接使用，否则属于系统内部标签。

* 小程序代码编辑器严格按照上面的规范检查格式，出现错误不能保存
* `<wx-for>` 的使用参考下述多条目组件
* 原则上不允许单独的 `TextNode`，一定要写可以这样写 `<wx-text value="hello"></wx-text>`

### 单条目组件

模块中出现的文字图片尽可能用组件替代

参考 http://www.demlution.com/store/admin/page.html#/build/dwapp/6324


### 多条目组件

参考 http://www.demlution.com/store/admin/page.html#/build/dwapp/6340

注意里面 `for` 循环的写法


### 样式

* 目前只支持 `wx-view` 加 `class`，如果需要自定义样式，请用 `wx-view` 包裹
* `class` 严格限制只能是: `b-*`, `clearfix`
* `wx-for` 也支持绑定 `class`，会应用到每一个循环条目上

### CSS 选项

样式选项尽可能自定义

* 直接写样式的话，不能使用 `px` ，需要使用 `pm` 单位，`pm` 会在浏览器端转换为 `rem`，在小程序内转换为 `rpx`
* 自定义长度选项使用 [长度(rem)]
* 如果需要自定义边框的样式，可以一键添加[边框组(rem)]

样式选项里面提到的 `rem` 单位都是指在浏览器端的单位，在小程序会被转换成 `rpx`

### 调试

后端开发者在本地运行 `bazaar4` 项目之后，每次在小程序编辑器保存之后会自动编译小程序到 `dwapp/defaultapp` 目录，
使用微信开发者工具加载这个目录就能自动调试，支持自动刷新。

如果是在正式服务器，可以打包下载之后再用本地微信开发者工具打开。

线上线下模块可以通过导入／导出功能互相转换。


## 动态模块

1. 检查动态模块控制台有没有 `出于性能考虑，调用 loadLiveItems 和 loadDetailItem 必须指定 fields 参数！` 的警告
2. 检查动态组件设置里面 limit 和 fop 相关选项有没有启用并且正常工作


## 动态模块链接

三种点击链接场景

- 任意原子组件(文本/图片)点击可设置跳转到 普通页面／列表页／详情页
- 动态模块点击之后跳转到详情页
- 列表模块点击之后跳转到详情页

针对第二第三种情况，为了简化代码，采用以下代码

- `[[ import.item_loop ]]` 代替长长的 for 循环声明
- `[[ import.item_href ]]` 代替链接属性

```html
<wx-for class="b-item clearfix b-group-border1" [[ import.item_loop ]]>
  <wx-view [[ import.item_href ]]>
    ...
  </wx-view>
</wx-for>
```

## 后端开发调试

本地运行之后，每次在商家中心小程序编辑器保存小程序，会自动编译当前小程序到 `dwapp/debugapp` 目录下，
使用微信小程序开发工具加载这个目录即可实时调试，每次保存会自动刷新小程序。


## API 调试说明

API 请求路径为 `testapi.demlution.com`，本地需要修改 `/ect/hosts` 文件指向 127.0.0.1


## 图片响应式方案

小程序的开发者目测是从客户端开发转过去了，并不是原生 web 开发者

小程序里面的图片一定要有 `确定性的宽度和高度`，下面的代码在 web 会生效，在小程序里面没有意义

```
img {
  max-width: 100%;
}
```

必须使用下面方案才能保证在微信里面正确显示图片。

### 方案一: 直接给 `wx-image` 设定宽度和高度(用响应式的pm单位)

参考 http://t8003.demlution.com/store/admin/page.html#/build/dwapp/6414

不能漏掉 `mode="widthFix"`

```
<wx-image :src="item.display.image" class="b-image-raw" mode="widthFix"></wx-image>
```

```
.b-image-raw {
  width: 60pm;
  height: 60pm;
}
```

### 方案二: 设置图片本身宽度 100% 然后利用父级的宽度自动缩放

不能漏掉 `mode="widthFix"`

```
<wx-view class="b-image">
  <wx-image :src="item.display.image" style="width: 100%;" mode="widthFix"></wx-image>
</wx-view>
```

## 静态图片尺寸问题


因为手机的实际分辨率都高于逻辑分辨率，所以如果像下图这样设置 35px 在电脑上显示是合适的，
但是在手机上会模糊掉，一般设置成两倍以上大小

![ ](https://s2.d2scdn.com/2017/08/31/Fmv1pZeImvBdtQusc41IMVtiY6Um.png)
