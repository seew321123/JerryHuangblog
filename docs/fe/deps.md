
# 应用依赖管理

网页编辑器目前支持上千个组件和模块的排列组合，必然会遇到外部依赖的问题。

应用依赖管理需要解决的问题

- 隔离
- 按需加载
- 同一个依赖加载之后能够缓存起来
- 多个应用共享相同的依赖只加载一次

## 依赖类型

在网页编辑器组件开发界面支持 6 种依赖类型。

- 系统 JavaScript
- 系统 CSS
- 用户 JavaScript
- 用户 CSS
- Webpack Entry
- Webpack CSS

`系统 JavaScript/CSS` 就是一些系统内置的依赖库，可以依赖管理界面右侧点击添加即可。
其它的依赖类型在依赖管理界面左侧添加，其中 `用户 JavaScript/CSS` 填写链接地址即可。Webpack 相关依赖在下面介绍。

![](https://s2.d2scdn.com/2017/10/26/fc550fca-e8a3-4fc3-a9db-2667b8e277c5/Jietu20171026-114619.png)


## Webpack 依赖

Webpack 依赖分为 `Webpack Entry` 和 `Webpack CSS`

目前支持以下三种 `Webpack Entry` 依赖:

- dcompany: 一些担路网内置的组件和服务
- package_mintui: https://mint-ui.github.io/
- package_elementui: http://element.eleme.io/2.0/#/zh-CN/component/changelog

上诉部分 `Webpack Entry` 还需要添加对应的 `Webpack CSS`:

- package_mintui
- package_elementui

添加 `Webpack Entry` 依赖之后，可以在前端代码获取对应的依赖对象
```javascript
// 通用 API
app.getEntry(name)

// 示例1: package_elementui
const eui = app.getEntry('package_elementui')
app.Vue.use(eui)
```

### 示例一：添加 package_elementui

![](https://s2.d2scdn.com/2017/10/26/d539bbc9-df87-4a6f-a80f-6f03699a80bb/Jietu20171026-115249.png)

```javascript
const ElementUI = app.getEntry('package_elementui')
app.Vue.use(ElementUI)

export default {
  data () {
    return {}
  }
}
```
