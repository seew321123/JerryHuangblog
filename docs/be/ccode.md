
云函数编辑
==========

## 云函数

云函数功能参考 AWS Lambda 实现，目前支持 `Python 3.6.2`

http://docs.aws.amazon.com/lambda/latest/dg/python-programming-model-handler-types.html

可以在后端代码／index.py 里面编写多个函数，每个函数类似与下方代码：

```
def handler_name(event, context):
    ...
    return {
      "message": "Hello world!",
    }
```

前端调用方法: `app.run('handler_name')`，或者带上参数 `app.run('handler_name', kwargs)`，
会自动请求服务器执行上述 Python 代码，并返回结果到前端。

每个 `handler` 有且只有两个参数，`event` 代表前端传入的参数 `kwargs`，
`context` 是一个对象，此对象提供了一些上下文信息和一些必要的方法：

|name|return|description|
|---|---|---|
|context.log()                                  |                     |打印日志，日志最终会输出到前端   |
|context.get_dataset()                          |Django Model Object  |当前应用的数据库   |
|context.get_table(table_name)                  |Django Model Object  |某个数据表   |
|context.get_rows(table_name)                   |Django QuerySet      |查询某个数据表下的所有数据   |
|context.get_company_id()                       |int                  |获取当前公司 ID   |
|context.get_siteuser_id()                      |int                  |获取登录用户 ID   |
|context.getRows([DQL])                         |                     |同前端 API|     
|context.query([DQL.query])                     |                     |同前端 API|
|context.createRow(tableName, data)             |                     |同前端 API|
|context.updateRow(rowId, data)                 |                     |同前端 API|
|context.removeRow(rowId)                       |                     |同前端 API|
|context.getAdminRows([DQL])                    |                     |同前端 API|
|context.queryAdmin([DQL.query])                |                     |同前端 API|
|context.createAdminRow(tableName, data)        |                     |同前端 API|
|context.updateAdminRow(rowId, data)            |                     |同前端 API|
|context.removeAdminRow(rowId)                  |                     |同前端 API|


### 注意:

- 云函数运行的环境是 `Django 1.11` 和 `Python 3.6.2`
- 每个 `handler` 返回值必须是可以被 json 序列号的对象，包括: dict/list/string/int/bool
- 目前没有区分测试数据库和正式数据库，在线上的一切操作都是实时的操作正式数据库
- 通过 `context.log()` 记录的信息会自动打印到浏览器终端
- Python 代码如果有报错也会自动打印到终端


### 如何本地调试云函数

云函数运行在独立的 Docker 容器，本地调试需要运行一个独立的服务器

```
cd bazaar4/dcode/
mkvirtualenv -p python3.6 dcode
workon dcode
pip install -r requirements.txt
python manage.py runserver 5010
```
