# 基础组件

### 图片组件

```html
<wx-image
  class="b-image"
  :src="gift.img_url"
  mode="widthFix"></wx-image>
```

### wx-input 文本框

```html
<wx-input
  class="b-input"
  type="text"
  :value="slide.dwdata.name"
  @update:value="updateInput"
  dw-event="bind:input:updateInput"></wx-input>
```

### wx-pick 选择器

支持的选择类型

- selector
- date
- time

参考 http://www.demlution.com/store/admin/page.html#/build/papp/8232
