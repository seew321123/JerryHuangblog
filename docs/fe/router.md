
## 多组件路由推荐实践

只在顶层定义路由，不同的路由映射到不同的文件，这样的好处

- 顶层逻辑十分清晰
- 路由逻辑与组件分离
- 每个组件有自己的生命周期
- 顶层组件可以向下层组件传递共享数据，实现部分数据的共享

```
# web_pc.html

<dui-router-view :prefix="slide.randomid" @change="handleChange($event)">
  <detail-view v-if="state.path === 'detail'" :slide="slide" :state="state"></detail-view>
  <list-view v-else :slide="slide" :state="state"></list-view>
</dui-router-view>
```

```
# web_pc.js

import ListView from './my_list.js'
import DetailView from './my_detail.js'
```

参考 http://www.demlution.com/store/admin/page.html#/build/papp/6769
