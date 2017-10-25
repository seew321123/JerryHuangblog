
文件管理
=======

文件管理是应用编辑器的核心功能

示例应用 http://www.demlution.com/store/admin/page.html#/build/papp/6979

## 平台入口文件

默认每个应用会加上一些默认文件，默认文件一般为不同平台的入口文件，详细参考下表

|参数|SDK是否支持|是否必须|默认值|说明|备注|
|---|---|---|---|---|---|
|web_pc.html            |yes   |true      |      |商家网站模板   |   |
|web_pc.js              |yes   |false     |      |商家网站 JavaScript 代码   |   |
|web_pc.css             |yes   |false     |      |商家网站样式   |   |
|admin_pc.html          |yes   |false     |      |内部管理界面模板   |   |
|admin_pc.js            |yes   |false     |      |内部管理界面 JavaScript 代码   |   |
|admin_pc.css           |yes   |false     |      |内部管理界面样式   |  -|

平台入口文件如 `web_pc.js` 或者 `admin_pc.js` 必须是合法的 Vue 组件，保存应用时会有严格的语法检查


## 自由文件

开发者可以自由添加任意多个文件，这些文件可以被其他文件引用，下面通过几个场景说明引用功能。

- 自由文件通过侧边栏文件管理按钮进行管理
- 自由文件支持 `html/js/css`
- 自由文件名称必须符合正则表达式 `/^my_[a-z_]+[.](html|css|js)$/`

### 场景一：引用其他文件的模块

这个场景适合用来分割代码到多个文件，以及实现多个平台共享代码，里面的 `export/import/from` 符合 `ES2015` 规范

参考 https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Statements/import

```
# my_module_a.js

export default {
  a: 1
}

export const b = 2
```

```
# my_module_b.js 或者 web_pc.js 等等入口文件

import a from './my_module_a.js'
import { b } from './my_module_a.js'

console.log(a.a)    // 1
console.log(b)      // 2
```

### 场景二：引用其他文件中的组件作为子组件

随着项目的不断扩展，必然会遇到一个项目需要定义多个组件的需求，可以通过自由文件引用多个组件。

```
# my_component_a.js

export default {
  template: '<div>my cool component a</div>',
  data () {
    return {}
  }
}

```

```
# my_component_b.js 或者 web_pc.js 等等入口文件

import ComponentA from './my_component_a.js'

export default {
  components: { ComponentA },
  data () {
    return {}
  }
}
```

通过文件之间的互相引用可以实现很复杂的组件系统。

### 场景三：引用 html 文件作为 Vue 组件的模板

上诉例子中的 `my_component_a.js` 使用的 `template` 是直接写的字符串，当组件模板复杂之后，这么写显然不合适(没有缩进没有语法高亮)，
我们可以通过导入 `.html` 文件中的模板解决这个问题。

```
# my_component_a.html

<div>my cool component a</div>
```

```
# my_component_a.js

import template from './my_component_a.html'

export default {
  template,
  data () {
    return {}
  }
}

```

如上所示，通过 `import` 语句实现了模板与代码的分离。


### 场景四: 引用 css 文件

当一个项目里面的样式越来越多，可以通过拆分成多个文件分散样式代码，为了简化逻辑，不支持嵌套引用。

```
# my_css_a.css

.b-item {
  color: red;
}
```


```
# my_css_b.css

@import './my_css_a.css';

.b-items {
  display: block;
}
```
