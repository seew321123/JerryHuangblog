
# 动态组件切换

参考: [https://vuejs.org/v2/guide/components.html#Dynamic-Components](https://vuejs.org/v2/guide/components.html#Dynamic-Components)


```html
<component :is="currentView">
  <!-- component changes when vm.currentView changes! -->
</component>
```

```javascript
export default {
  data: {
    currentView: 'home'
  },
  components: {
    home: { /* ... */ },
    posts: { /* ... */ },
    archive: { /* ... */ }
  }
}
```

参考以上组件，只需要修改 `this.currentView` 的值就能够实现修改当前渲染的组件。
