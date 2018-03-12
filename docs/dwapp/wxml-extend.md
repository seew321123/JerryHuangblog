
# 小程序动态 class 绑定: dw-class/dw-class-list


## 语法

- :dw-class 支持绑定单个变量
- :dw-class-list 支持绑定多个变量，并且支持简单的计算：字符串加法/三元运算

## 示例

```wjs
/* global dw:true */

export default {
  data: {
    class1: 'test-class1',
    class2: 'test-class2',
    class3: 'test-class3',
  }
}

```

```wxml
<wx-view>

  <wx-view class="b-block" :dw-class="slide.dwdata.class1">
    {{ slide.dwdata.class1 }}
  </wx-view>

  <wx-view class="b-block" :dw-class-list="[slide.dwdata.class2, slide.dwdata.class3]">
    {{ slide.dwdata.class2 }} {{ slide.dwdata.class3 }}
  </wx-view>  

  <wx-view class="b-block" :dw-class-list="[slide.dwdata.class2 + '-' + slide.dwdata.class3]">
    {{ slide.dwdata.class2 + '-' + slide.dwdata.class3 }}
  </wx-view>  

  <wx-view class="b-block" :dw-class-list="[slide.dwdata.class2 ? 'haha' : 'hehe']">
    {{ slide.dwdata.class2 ? 'haha' : 'hehe' }}
  </wx-view>

</wx-view>
```

```wxss

.b-block {
  color: #fff;
  font-size: 16px;
  padding: 10px;
}

.test-class1 {
  background: green;
}

.test-class2.test-class3 {
  background: blue;
}

.test-class2-test-class3 {
  background: green;
}

.haha {
  background: blue;
}
```

渲染效果

![ ](https://s2.d2scdn.com/2017/12/28/FhC34Bg1g7wrWHqRINVpuqGvahAN.png)


## 示例

http://www.demlution.com/store/admin/page.html#/build/papp/8754


# wxss 支持导入其它文件

```
@import "./my_style.wxss";
```

注意：

- 仅支持单层，不能嵌套
- 可以导入 `.css` 文件，甚至可以和 web 端共享代码

## wjs 支持 include 其他文件

```
/* build:include my_script.wjs */

```

上述注释会被 `my_script.wjs` 的内容替换掉

注意 include 和 ES6+ 的 export/import 不同，include 支持替换文本，**仅此而已**

注意：

- 仅支持单层，不能嵌套
- 可以和 `/* build:dwapp:remove */` 一起使用
- 支持在入口文件多次使用导入不同的代码
- 支持添加到文件的不同位置
- 可以导入 `.js` 文件，甚至可以和 web 端共享代码

参考示例组件 http://www.demlution.com/store/admin/page.html#/build/papp/8692



## wxml 中直接调用自定义选项

```
<wx-view class="b-content" v-if="slide.css_ctx.select1.value === 'block'">
  Hello, world!  
</wx-view>
```

## wjs 中直接调用选项

```
console.log(dw.slide.css_ctx.select1.value)
```

## wxss 中直接调用选项

```
.b-content {
  color: '[[ s.color1 ]]';
  font-size: '[[ s.range_rem1 ]]';
}
```

## 如何区分 web 端和 dwapp 端写不同的样式？

在 wjs 中把平台赋值给 data

```
data: {
  platform: dw.platform
}
```

在 wxml 中绑定动态 class

```
<wx-view class="b-platform" :dw-class="slide.dwdata.platform">

</wx-view>
```

这样就能在 wxss 中愉快的分不同的平台写不同的样式了

```
.b-fixed {
  height: 50px;
  background: green;
}

.b-platform.web {
  // 这里是网页特有的样式
}

.b-platform.dwapp {
  // 小程序特有的样式，利用这种方法可以区分网页和小程序的样式
  .b-fixed {
    position: fixed;
    bottom: 0;
    z-index: 100;
    left: 0;
    right: 0;
  }  
}
```

使用场景：web 端不固定在底部，小程序内固定在底部，参考效果

![ ](https://s2.d2scdn.com/2017/12/26/FjhYuzgm6TbNgwCimstFgen9FVZB.png)

![ ](https://s2.d2scdn.com/2017/12/26/FtPwRFfyQkRW1xXh1XBt4ff92fON.png)

以上所有功能示例

http://www.demlution.com/store/admin/page.html#/build/papp/8664


# 动态样式绑定



参考 http://www.demlution.com/store/admin/page.html#/build/papp/8657

wxml

```
<wx-view :style="slide.dwdata.style" dw-style="color: (slide.dwdata.style.color); font-size: (slide.dwdata.style['font-size'])">
  Hello, world!
</wx-view>
```

wjs

```
/* global dw:true */

export default {
  data: {
    lock: false,
    style: {
      color: "green",
      'font-size': '30px'
    }
  },
  onShow () {
    console.log(dw.data)
    setTimeout(() => {
      dw.setData('style.color', 'red')
    }, 3000)
    setTimeout(() => {
      dw.setData('style.color', 'green')
    }, 6000)
  },
  methods: {
    load () {
      //
    }
  }
}

```

## 注意事项

- dw-style 中，必须写属性名，属性值中的动态变量用小括号包裹
- 只针对 wx-view 生效
