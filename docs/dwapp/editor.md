
小程序在线编辑器
===============

小程序编辑器和应用编辑器在一起，但是有一些特殊的地方

## 支持编辑多个页面

默认入口文件为 `dwapp_mobile.wxml`，对应的其他文件为 `dwapp_mobile.wjs` `dwapp_mobile.wxss`，
如果需要支持多个页面，可以在文件管理器一键创建页面或者手动创建类似以下结构的三个文件，
其中 `<pageName>` 可以替换成自己的页面名称(名称必须符合正则表达式`/^[a-z]+$/`)

```yaml
dwapp_page_<pageName>
  - my_dwapp_page_<pageName>.wxml
  - my_dwapp_page_<pageName>.wjs
  - my_dwapp_page_<pageName>.wxss
```

## 支持预览多个页面

通过编辑器顶部的 `自定义` 按钮，可以选择渲染指定的小程序页面

## 支持一键编译到小程序

如果使用客户端，可以点击一键编译到小程序

## 不支持的功能

- wjs 之间不能互相引用
- css 不能使用 import 语句
