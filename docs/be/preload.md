
http://www.demlution.com/store/admin/page.html#/dissue/9619

使用预加载云函数优化首屏渲染性能
=============================

## 问题

在网页编辑器插入的 Vue 组件，开始高度为 0 ，异步加载数据渲染之后展开高度，这个过程会导致页面闪烁，用户体验差。

示例页面：http://www.llg.d2shost.net/app-course/list.html?v=2018-03-05-22:53:51

## 产生原因

原因是数据是通过异步请求获取再拼接成HTML插入浏览器中。

## 传统解决方案

- 传统的服务端渲染(例如 Django)，服务端输出完整的 HTML
- Vue SSR

上述方案都不太完美

## 网页编辑器预加载方案

首屏请求移动到一个云函数 -> 渲染组件之前**同步**运行云函数 -> API 同步获取云函数返回的数据

上诉流程可以保证我们能够在初次渲染组件**同步**获取到数据

## 使用方法

第一步：组件开启预加载功能，并指定使用哪个云函数预加载数据

![](https://s2.d2scdn.com/2018/3/5/05e6b68c-9392-48bc-bba1-988014e0e075/Jietu20180305-225918.png)

第二步：编写云函数

![](https://s2.d2scdn.com/2018/3/5/ce276157-8821-4b5c-871e-aa3e3b6fb18d/Jietu20180305-230742.png)

第三步：在组件前端代码读取预加载数据，并处理无法获取预加载数据情况(如开发界面无法读取)

![](https://s2.d2scdn.com/2018/3/5/bb7bdcc2-010b-4e2b-acd6-9dff35d8c04d/Jietu20180305-231751.png)

## Event API

传递给云函数的 `event` 字典携带了很多有价值的信息：

- event.is_bazaar4：判断是否是预加载调用，因为云函数也能在前端直接调用，这个参数可以区分
- event.component：组件本身数据，等同于前端的 `slide`，可以读取 `slide.css_ctx` 等数据
- event.page_meta：读取当前所在网页元数据
- event.page_params：request.GET 查询参数
- event.papp_page_args: 应用页面参数如 `/app-toutiap/detail-10086.html` -> `['detail', '10086']`

## DEMO

网页 http://www.llg.d2shost.net/app-toutiao/list.html

代码 http://www.demlution.com/store/admin/page.html#/build/papp/10091

## 深入

如果仔细分析渲染流程：

Django：后端同步构造 context -> 渲染 template -> 输出 HTML

Vue：前端同步/异步构造 data -> 渲染 template -> 生成 HTML

预加载：后端同步构造 context -> 前端同步/异步构造 data -> 渲染 template -> 生成 HTML

预加载其实是综合了前两者的优点，而且完全由开发者控制内容是同步还是异步输出。

建议：

- 预加载函数也是普通云函数，也可以在前端直接调用
- 预加载耗时不宜过长，因为同步加载会阻塞渲染
- 列表页中主列表可以改成预加载，其它内容异步加载，这样可以综合预加载与异步加载的优缺点
- 详情页特别典型：主详情可以预加载，辅助功能异步加载
