# 基础组件

### wx-view 块级容器

```html
<wx-view
  class="b-view"
  :dw-class="slide.dwdata.dynamicClass"
  ></wx-view>
```

### wx-scroll-view 可滚动视图区域

```html
<wx-scroll-view class="b-items" scroll-y="true"></wx-scroll-view>
```

### wx-swiper 滑块视图容器

```html
<wx-swiper class="b-items" :settings="slide.dwdata.settings">
  <wx-swiper-item class="b-item">1</wx-swiper-item>
  <wx-swiper-item class="b-item">2</wx-swiper-item>
  <wx-swiper-item class="b-item">3</wx-swiper-item>
  <wx-swiper-item class="b-item">4</wx-swiper-item>
</wx-swiper>
```

```javascript
export default {
  data: {
    lock: false,
    settings: {
      duration: 500,
      interval: 5000,
      autoplay: true,
      'indicator-dots': true
    }
  }
}
```

```css
.b-items {
  height: 200pm;
}
```

注意事项

- `wx-swiper` 必须固定高度
- 下面必须接 `wx-swiper-item` 组件
- 可以和 `wx-for` 结合使用，参考下面，但是不能在 `wx-for` 和 `wx-swiper-item` 添加 `class`，因为 `wx-for` 是虚拟的

```html
<wx-swiper class="b-swiper" :settings="slide.dwdata.settings">
  <wx-for [[ import.item_loop ]]>
    <wx-swiper-item>
      <wx-view class="b-item" [[ import.item_href ]]>
        <wx-view class="b-image">
          <wx-image :src="item.display.image" class="b-image-raw" mode="widthFix"></wx-image>
        </wx-view>
        <wx-view class="b-description">
          <wx-view class="b-name b-group-text1 b-ellipsis-2">
            <wx-text :value="item.name"></wx-text>
          </wx-view>
          <wx-view class="b-date b-group-text2">
            [[ import.item_price ]]
          </wx-view>
        </wx-view>
      </wx-view>
    </wx-swiper-item>
  </wx-for>
</wx-swiper>
```


### wx-image 图片组件

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

参考 http://www.demlution.com/store/admin/page.html#/build/papp/8232 ，这个例子展示了 `wx-pick` 的典型用法

```html
<wx-view class="weui-cells__title">筛选</wx-view>

  <wx-view class="weui-cells weui-cells_after-title">

    <wx-view class="weui-cell weui-cell_select">
      <wx-view class="weui-cell__hd weui-cell__hd_in-select-after">
        <wx-view class="weui-label">积分类型</wx-view>
      </wx-view>
      <wx-view class="weui-cell__bd">
        <wx-pick mode="selector" :value="slide.dwdata.ruleType.value"
          @update:value="updateSelect" dw-event="bind:change:updateSelect"
          :range="slide.dwdata.ruleType.range" :range-key="slide.dwdata.ruleType.rangeKey">
          <wx-view slot="selector">
            <wx-view class="weui-select weui-select_in-select-after">
              {{ slide.dwdata.ruleType.range[slide.dwdata.ruleType.value]["name"] }}</wx-view>
          </wx-view>
        </wx-pick>
      </wx-view>
    </wx-view>

    <wx-view class="weui-cell weui-cell_select">
      <wx-view class="weui-cell__hd weui-cell__hd_in-select-after">
        <wx-view class="weui-label">开始日期</wx-view>
      </wx-view>
      <wx-view class="weui-cell__bd">
        <wx-pick mode="date" :value="slide.dwdata.startDate" @update:value="updateDate($event, 'startDate')"
          dw-event="bind:change:updateDate" data-string-value="startDate">
          <wx-view slot="date" class="weui-select weui-select_in-select-after">
            <wx-text v-if="slide.dwdata.startDate" :value="slide.dwdata.startDate"></wx-text>
            <wx-text v-else value="选择日期"></wx-text>
          </wx-view>
        </wx-pick>
      </wx-view>
    </wx-view>

    <wx-view class="weui-cell weui-cell_select">
      <wx-view class="weui-cell__hd weui-cell__hd_in-select-after">
        <wx-view class="weui-label">结束日期</wx-view>
      </wx-view>
      <wx-view class="weui-cell__bd">
        <wx-pick mode="date" :value="slide.dwdata.endDate" @update:value="updateDate($event, 'endDate')"
          dw-event="bind:change:updateDate" data-string-value="endDate">
          <wx-view slot="date" class="weui-select weui-select_in-select-after">
            <wx-text v-if="slide.dwdata.endDate" :value="slide.dwdata.endDate"></wx-text>
            <wx-text v-else value="选择日期"></wx-text>
          </wx-view>
        </wx-pick>
      </wx-view>
    </wx-view>

  </wx-view>

</wx-view>
```
