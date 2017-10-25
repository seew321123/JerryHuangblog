
前端代码编辑
============

## 前端模板代码

参考 编辑器界面／文档／HTML 文档

## 前端 JavaScript 代码

参考 编辑器界面／文档／JavaScript 文档，前端代码使用 `ES 2015+` 语法，支持 `async/await`

每个 js 文件 都是一个 Vue 组件，通过 `export default` 导出一个对象，对象的属性参考 编辑器界面／文档／JavaScript 文档

同时 每个 js 文件内部可以通过变量 `app` 引用当前应用实例。

`app` 有以下属性和方法

|name|return|description|
|---|---|---|
|app.getTable(tableName)                            |object   |读取数据表结构   |
|async app.getRows([DQL])                           |Promise  |读取所有的数据行   |
|async app.query([DQL.query])                       |Promise  |读取所有的数据行   |
|async app.createRow (tableName, data)              |Promise  |创建数据行   |
|async app.updateRow (rowId, data)                  |Promise  |更新数据行   |
|async app.removeRow (rowId)                        |Promise  |删除数据行   |
|async app.run (action, event = {})                 |Promise  |执行云函数|
|async app.getAdminRows([DQL])                      |Promise  |[管理员权限]读取所有的数据行   |
|async app.queryAdmin([DQL.query])                  |Promise  |[管理员权限]读取所有的数据行   |
|async app.createAdminRow (tableName, data)         |Promise  |[管理员权限]创建数据行   |
|async app.updateAdminRow (rowId, data)             |Promise  |[管理员权限]更新数据行   |
|async app.removeAdminRow (rowId)                   |Promise  |[管理员权限]删除数据行   |
|async app.runAdmin (action, event = {})            |Promise  |[管理员权限]执行云函数|
