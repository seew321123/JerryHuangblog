

## 依赖库配置

![ ](https://s2.d2scdn.com/2018/03/12/Fisc3qh3Y1Z_DcDr9NhRuoNmJgIk.png)

注意：

- 依赖库不能依赖其它依赖库
- 建议依赖库单独一个组件


## 组件配置

添加依赖

![ ](https://s2.d2scdn.com/2018/03/12/FrjCxXNp-Ft-CpsN1f5NuhI_dGAa.png)

## 代码中使用依赖

- 导入规则 `import <module> from 'slide/<slideId>/<fileName>'`
- 因为依赖库需要异步加载，每个组件只能导入两个依赖库
- 如果被导入的依赖文件中使用了 `import something from './my_other_file.js'` 的语法，
`'./my_other_file.js'` 自动映射到对应依赖库内部文件，也就是说支持递归导入
- 只能导入 `.js` 后缀结尾的文件，如果需要导入 `.html` 文件，可以在依赖库导入 `.html` 到一个 `.js` 文件

- 不支持小程序的 `wjs/wxss/wxml` 文件
- 依赖库支持 `/* build:include my_other_other_file.js */` 魔法注释

参考代码

```
import module from 'slide/10302/my_module.js'

export default {
  data () {
    return {}
  },
  created () {
    console.log('module', module)
  }
}
```

## CSS 导入的问题

因为 CSS 的特殊性，CSS 目前需要单独导入，并且有很多限制

- 不支持作用域，为了考虑依赖库的普适性，需要手动控制作用域，建议给每个组件特定的 class
- 不支持 SCSS 编译

使用方法

添加自定义CSS，然后填写下面的地址：

http://www.demlution.com/page/pagetemplate/10302/base/web_pc.css

地址规则 `/page/pagetemplate/<slideId>/base/<fileName>`
