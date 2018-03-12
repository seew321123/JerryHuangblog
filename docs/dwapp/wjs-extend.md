
## 更新概览

- [x] 小程序 dw.event 事件体系与 app.event 互通支持
- [x] 小程序 pageLocals 支持
- [x] 小程序 globalData 支持
- [x] 小程序 storage 封装支持
- [x] 小程序 onLoad/onReady/onUnload 支持
- [x] 小程序 pageEvent/globalEvent 事件管理器的支持

下面是新加的部分，详细参考在线文档 https://demlution.github.io/docs/docs/dwapp/wjs.html

## wjs 对象


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

和存储类似，事件管理器分为三级，具体使用方法参考应用的[事件管理器](https://demlution.github.io/docs/docs/fe/event.html)

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


# 优化



## 使用条件编译优化 fixture

使用 fixture 一定要使用条件编译优化，详情参考 http://www.demlution.com/store/admin/page.html#/dissue/6655

## 从积分礼品这个组件克隆的组件

之前从积分礼品这个组件克隆的组件会继承一些不必要的东西，可以优化掉

- 需要删除选项里面的导航和布局选项
- 依赖管理里面需要删除 dcenter
- 检查一下有没有多余的文件


![ ](https://s2.d2scdn.com/2017/12/14/Flr4D7N2Ihh-WEp1BaYHAmMvsKDH.png)





## 页面内共享数据支持

```
// 获取全局变量
dw.getPageLocals(key)


// 设置页面级变量
setPageLocals (key, value)
```

这个 API 用来设置页面级全局变量，key 保证唯一即可，value 可以是任何类型

## 使用场景

一个页面内多个组件如何共享同一个请求的数据？

这个问题的纠结之处在于，你无法保证所有模块都存在，也不能保证他们的添加顺序

参考 http://www.demlution.com/store/admin/page.html#/build/papp/8556

```
async onShow () {
  const p1 = dw.getPageLocals('company_account:get_siteuser_data') || dw.request('get/company_account/get_siteuser_data')
  dw.setPageLocals('company_account:get_siteuser_data', p1)
  console.log(await p1)
}
```

上面这段代码可以保证：如论多少个组件添加了这段代码，每个人获取到的 p1 都是同一个，
也就是只有一个请求，但是所有组件都可以获取到同一份数据
