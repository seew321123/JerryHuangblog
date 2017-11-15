
云函数计划任务支持
=================

## 场景

什么情况下需要使用计划任务？

比如需要主动关闭未支付的订单，可以添加一个计划任务，在每天凌晨一点执行一个计划任务。

## 实现方法

非常简单，在云函数里面加上装饰器即可。

```python
import datetime
import app

@app.register_task(times=[datetime.time(1, 0)])
def hello(context):
    print('Hello, world!!!!')
    print(list(context.get_all_datasets()))
    print(list(context.get_all_tables()))
    print(list(context.get_all_rows()))
    return {}
```

上述代码声明了一个计划任务，该任务会在每天的凌晨 1 点开始执行。

times 接受一个数组，里面是 `datetime.time` 对象，支持设置时间，即允许在一天内的多组时间内执行。
比如下面的代码声明这个计划任务会在 下午 17:00 - 17:59 每分钟执行一次，一共执行 60 次：

```python
@app.register_task(times=[datetime.time(17, i) for i in range(60)])
def hello(context):
    pass
```


## 执行环境

计划任务云函数和普通云函数很大的不同在于，普通云函数操作的是当前商家，而在计划任务里面，操作的是使用这个应用的**所有商家**，
云函数只接受一个 `context` 参数，API 如下：

|name|return|description|
|---|---|---|
|context.get_all_datasets()                   |Django QuerySet      |所有使用此应用的商家的数据库   |
|context.get_all_tables()                     |Django QuerySet      |所有使用此应用的商家的数据表   |
|context.get_all_rows()                       |Django QuerySet      |所有使用此应用的商家的数据记录   |

## 其他问题

- times 的精度为 一分钟
- **请不要**将时间设置为 `datetime.time(0, 0)`，因为在 0 点的计划任务太多了
- **建议**将时间设置为 `datetime.time(1, 0)` - `datetime.time(4, 0)`
