
DQL(Data Query Language) 数据查询语法
====================================

DQL 是针对数据集前端提供的一套高级查询语法，支持以下功能

- [x] 分页
- [x] 权限控制
- [x] 过滤
- [x] 排序
- [x] 外键级联查询
- [x] 合并多组查询

## 参考实现

- http://graphql.org/
- https://www.elastic.co/guide/en/elasticsearch/reference/current/_introducing_the_query_language.html
- https://leancloud.cn/docs/rest_api.html

## 简单查询[不建议使用]

简单查询是为了兼容以前的功能而保留的查询方式，简单查询只支持简单的查询和过滤，如果需要更加复杂和完善的查询，请使用高级查询。

### 查询语句

```
{
  limit
  offset
}
```

### 返回值

```
{
  meta: {
    limit: <int>
    offset: <int>
    total_count: <int>
  }
  objects: [
    {
      id: <int>
      order: <int>
      uuid: <int>
      data: {
        [field]: [value]
      }
    }
  ]
}
```

### 前端 API 代码示例

```
app.getRows(<pk|table_name>, <query>)

# example
const response = await app.getRows('table1', {
  limit: 10,
  offset: 0,
})
```

### 简单查询支持的查询参数

|参数|SDK是否支持|是否必须|默认值|说明|备注|
|---|---|---|---|---|---|
|limit          |yes   |false    |10    |   |   |
|offset         |yes   |false    |0     |   |   |
|id             |yes   |false    |      |   |   |
|id__in         |yes   |false    |      |   |   |
|uuid           |yes   |false    |      |   |   |
|uuid__in       |yes   |false    |      |   |   |
|filter__[field]|yes   |false    |      |   |   |
|order_by       |yes   |false    |-id   |id,-id,created,-created>   |  -|

简单查询只支持简单的查询和过滤，如果需要更加复杂和完善的查询，请使用高级查询


## 高级查询语句

### 基本结构

```
{
  query: {
    datasettable: <pk|table_name>
    filters: {}
    excludes: {}
    fields: []
    order_by: []
    limit
    offset
  }
  querys: {}
}
```

|参数|SDK是否支持|是否必须|默认值|说明|备注|
|---|---|---|---|---|---|
|datasettable   |yes   |true      |      |数据表名称   |   |
|filters        |yes   |false     |      |详情查看 filters 子句   |   |
|excludes       |yes   |false     |      |详情查看 excludes 子句   |   |
|fields         |yes   |false     |      |详情查看 fields 子句   |   |
|order_by       |yes   |false     |      |详情查看 order_by 子句   |   |
|limit          |yes   |false     |      |   |   |
|offset         |yes   |false     |      |   |  |
|querys         |yes   |false     |      |详情查看 querys 子句   |  -|

### filters(excludes) 子句

excludes 子句支持和 filters 同样的语法，表示排除选中的语句，不再重复列出

```
filters: {
  id
  id__in
  uuid
  uuid__in

  created__lt
  created__lte
  created__gt
  created__gte

  data__contains
  data__[field]

  data__[field]__in
  data__[field]__isnull
  data__[field]__startswith
  data__[field]__istartswith
  data__[field]__endswith
  data__[field]__iendswith
  data__[field]__icontains
  data__[field]__lt
  data__[field]__lte
  data__[field]__gt
  data__[field]__gte
}
```

|参数|SDK是否支持|是否必须|默认值|说明|备注|
|---|---|---|---|---|---|
|`id`                           |yes   |false    |      |   |   |
|`id__in`                       |yes   |false    |      |参数为数组   |   |
|`uuid`                         |yes   |false    |      |   |   |
|`uuid__in`                     |yes   |false    |      |参数为数组   |   |
|`created__lt`                  |yes   |false    |      |参数为 ISO 8601 格式时间戳, 形如: 2017-10-11T15:34:21.273214   |   |
|`created__lte`                 |yes   |false    |      |参数为 ISO 8601 格式时间戳, 形如: 2017-10-11T15:34:21.273214   |   |
|`created__gt`                  |yes   |false    |      |参数为 ISO 8601 格式时间戳, 形如: 2017-10-11T15:34:21.273214   |   |
|`created__gte`                 |yes   |false    |      |参数为 ISO 8601 格式时间戳, 形如: 2017-10-11T15:34:21.273214   |   |
|`data__contains`               |yes   |false    |      |参数为字典，可以筛选多个字段的值   |   |
|`data__[field]`                |yes   |false    |      |精确筛选某个字段的值   |   |
|`data__[field]__in`            |yes   |false    |      |参数为数组   |   |
|`data__[field]__isnull`        |yes   |false    |      |判断某个字段是否存在   |   |
|`data__[field]__startswith`    |yes   |false    |      |字符串匹配   |   |
|`data__[field]__istartswith`   |yes   |false    |      |字符串匹配   |   |
|`data__[field]__endswith`      |yes   |false    |      |字符串匹配   |   |
|`data__[field]__iendswith`     |yes   |false    |      |字符串匹配   |   |
|`data__[field]__icontains`     |yes   |false    |      |字符串匹配   |   |
|`data__[field]__lt`            |yes   |false    |      |数字大小比较   |   |
|`data__[field]__lte`           |yes   |false    |      |数字大小比较   |   |
|`data__[field]__gt`            |yes   |false    |      |数字大小比较   |   |
|`data__[field]__gte`           |yes   |false    |      |数字大小比较   |   |


### fields 子句

fields 可以自定义读取部分字段数据，也可以通过 `__` 符号获取外键相关的数据

|参数|SDK是否支持|是否必须|默认值|说明|备注|
|---|---|---|---|---|---|
|`[field]`                        |yes   |false    |      |   |   |
|`[field]__toone`                 |yes   |false    |      |   |   |
|`tomany__[table_name]__[field]`  |yes   |false    |      |   |  -|


下面通过示例详细介绍外建查询的使用方法

```
# 假设有下面两个表，table2 的 parent 字段关联到了 table1

table1
=================
name1  | charfield


table2
===================
name2   | charfield
parent  | foreignkey -> table1

# 场景一：查询 table2 时希望可以获取 parent 的详细数据

DQL: -->
{
  query: {
    datasettable: 'table2',
    fields: ['name2', 'parent__toone'],
  }
}

RETURN <--
{
  meta: {},
  objects: [
    {
      name2: '...',
      parent__toone: {
        id: '...',
        data: {
          name1: '...'
        }
      }
    }
  ]
}

# 场景二：查询 table1 时希望获取到所有关联的 table2 列表

DQL: -->
{
  query: {
    datasettable: 'table1',
    fields: ['name1', 'tomany__table2__parent'],
  }
}

RETURN <--
{
  meta: {},
  objects: [
    {
      name1: '...',
      tomany__table2__parent: [
        {
          id: '...',
          data: {
            name2: '...'
            parent: '...'
          }
        }
      ]
    }
  ]
}
```


### order_by 子句

order_by 接受一个数组，支持对多个字段排序

```
order_by: [
  id
  -id
  created
  -created
  data__[field]
  -data__[field]
]
```

### querys 子句

如果你需要合并多次查询到一个请求内，可以使用 querys 子句。querys 是一个字典，键名称可以自定义，值为一个嵌套的 query 子句。

下面演示了一个简单的合并查询语句

```
POST  -->
{
  querys: {
    list1: {
      datasettable: 'table1',
      limit: 10,
      offset: 0
    },
    list2: {
      datasettable: 'table2',
      limit: 10,
      offset: 0
    }
  }
}


RETURN  <--
{
  list1: {
    meta: {}
    objects: {}
  }
  list2: {
    meta: {}
    objects: {}
  }
}
```

### 前端 API 代码示例

```
app.getRows(<query>)

# example
const response = await app.getRows({
  query: {
    filters: {
      data__name: 'test'
    },
    limit: 10,
    offset: 0
  }
})
```

## DQL 调试工具文档

为了方便调试，增加了一个 DQL 调试工具，基本功能如下

- 一个应用内可以添加多个查询，这些查询会永久保存
- 顶部导航栏管理查询
- 左侧可以编辑查询代码或者任何 JavaScript 代码
- 调试代码通过 `run` 函数返回一个对象
- 点击右侧 `运行` 按钮可以运行代码，如果左侧 `run` 函数有返回值则会自动显示

这个工具可以用来：

- 调试 `getRows` 的查询功能
- 保存一些有用的代码

![ ](https://s2.d2scdn.com/2017/10/10/FqiZ-1oERHTW9Ztqgnh_xtrS5V2h.png)
