
### 组件最重要的属性是隔离性

我们要支持的是能够在一个页面内同时运行多个不同的组件，保证他们互不影响。互不影响至少要满足以下要求

1. 当前组件能在同一个页面内添加两次或者无数次，同类组件互相之间不受影响
2. 当前组件不能去影响其他组件的样式或者行为
3. 当前组件不受其他组件影响

试想一下下面的代码

```
$('.b-item).css('background', 'red')
```

这行代码会把 **整个页面** 内所有的 `.b-item` 背景颜色修改为红色，意味着可能会修改别人的组件，
这就破坏了隔离性，这种写法是不合理的，违背了上诉第 1、2 点

下面具体分析几种场景

### 场景一：如果要在 Vue 组件里面操作 DOM 怎么办？

虽然 95% 以上的场景都不需要在 Vue 组件里面操作 DOM，如果一定要的话，
可以使用 `this.$el`，这个属性始终指向当前组件根结点的 DOM 元素，
还可以通过 `$(this.$el).find('.b-item')` 查找当前组件下的 DOM 元素

为什么 `this.$el` 可以保证隔离性？因为同一个组件在每次渲染时会生成不同的 `this.$el`。

### 场景二：为什么写 `<div id="sth"></div>` 提示不能保存？

同一个 id 只能合法的存在于一个 DOM，违背了上诉第 1 点

### 场景三：`modal-base` 样式不生效怎么办？

在根结点写 `:rootClass="[slide.randomid]"` 即可，所有子级元素都可以生效，不要用 `:id`

```
<modal-base class="clearfix" :rootClass="[slide.randomid]" :showModal="false">
  <template slot="body">
    <div class="b-item">
      hello
    </div>
  </template>
</modal-base>
```

### 场景四：为什么提示 `typeof data must be function` ?

```
# 原来写法

export default {
  data: {
    a: 1
  }
}

# 修改为

export default {
  data () {
    return {
      a: 1
    }
  }
}
```

为什么？为了这个组件可以重复使用。

https://vuejs.org/v2/guide/components.html#data-Must-Be-a-Function
