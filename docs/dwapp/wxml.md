# wxml(dxml) 文档

## 概述

微信封装了一套自己的语法叫 wxml，为了实现能够在浏览器运行和预览效果，我们实现了一套 dxml 语法，可以自动转换到 wxml

最重要的一点，dxml 是合法的 Vue 模板，遵守一切 Vue 模板语法规则

## 基本用法

和标准的 xml 文档一样，只要理解下面几个概念，就能掌握全部语法

- tag 标签: 通过不同的标签提供不同的功能
- attr 属性: 通过属性定义一个标签的自定义功能
- childNodes: 部分标签支持嵌套子节点
- textNode: 文本节点
- commentNode: 注释节点

```html
<wx-view class="weui-navbar__title">积分兑换订单</wx-view>
```

| 标签       | 属性                                       | 子节点  |
| -------- | ---------------------------------------- | ---- |
| wx-view  | `class` `:dw-class` `style` `@click.native` `dw-event` `v-if` `v-else-if` `v-else` `:dw-href` `dw-href` `slot` `data-bind-value` `data-string-value` `data-bind-value2` `data-string-value2` | 是    |
| wx-text  | `class` `:dw-class` `style` `value` `:value` `v-if` `v-else-if` `v-else` | 是    |
| wx-image | `class` `:dw-class` `style` `src` `:src` `mode` | 是    |

上面列出了几个常用的标签的基本属性，详细可以查看应用编辑器/侧边栏/wxml 文档

## class 和 style 绑定

- `style` 静态样式
- `class` 静态类
- `:dw-class` 动态绑定一个变量作为 class

## 事件绑定

先看一个最基本的例子

```html
<wx-view @click.native="handleClick" dw-event="bind:tap:handleClick">点击</wx-view>
```

```javascript
export default {
  methods: {
    handleClick () {
      //
    }
  }
}
```
### 如何处理参数

```html
<wx-view @click.native="handleClick(slide.dwdata.item)" dw-event="bind:tap:handleClick" data-bind-value="slide.dwdata.item">点击</wx-view>
```

```javascript
export default {
  methods: {
    handleClick (arg1) {
      const item = dw.platform === 'web' ? arg1 : arg1.currentTarget.dataset.bindValue
    }
  }
}
```

- data-bind-value 绑定变量
- data-string-value 绑定字符串
- data-bind-value2 绑定变量2
- data-string-value2 绑定字符串2

### 如何同时处理事件和参数

下面是一个复杂的例子 http://www.demlution.com/store/admin/page.html#/build/papp/8232

```html
<wx-pick mode="date" :value="slide.dwdata.startDate" @update:value="updateDate($event, 'startDate')" dw-event="bind:change:updateDate" data-string-value="startDate">
  <wx-view slot="date" class="weui-select weui-select_in-select-after">
    <wx-text v-if="slide.dwdata.startDate" :value="slide.dwdata.startDate"></wx-text>
    <wx-text v-else value="选择日期"></wx-text>
  </wx-view>
</wx-pick>
```

```javascript
export default {
  data: {
    startDate: null
  },
  updateDate (arg1, arg2) {
      const value = dw.platform === 'web' ? arg1 : arg1.detail.value
      const field = dw.platform === 'web' ? arg2 : arg1.currentTarget.dataset.stringValue
  }
}
```
## 条件语句

条件语句和 Vue 保持一致，无需额外的声明

- v-if
- v-else-if
- v-else

## 循环语句

```html
<wx-for v-for="gift in item.items" :key="gift.id" for-item="gift" for-items="item.items" for-key="id">
  <wx-view class="weui-media-box__title">{{ gift.name }}</wx-view>
</wx-for>
```

上面是一个典型的循环语句，糅合了 Vue 的语法和小程序语法

| 属性        | 值                  | 是否必须 | 说明           |
| --------- | ------------------ | ---- | ------------ |
| v-for     | gift in item.items | 是    | Vue 循环声明     |
| for-item  | gift               | 是    | 小程序循环声明      |
| for-items | item.items         | 是    | 小程序循环声明      |
| :key      | gift.id            | 否    | Vue key 绑定   |
| key       | id                 | 否    | 小程序 key 绑定   |
| for-index | index              | 否    | 小程序 index 绑定 |

`for-index` 使用举例

```html
<wx-for v-for="(item, index) in items" for-item="item" for-items="items" for-key="index">
  <wx-view>{{ index }}</wx-view>
</wx-for>
```

