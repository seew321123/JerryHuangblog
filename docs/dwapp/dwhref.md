
## 跳转到其它组件

```
dw.goToHref(dwHref, { redirectTo: false })
```

- dwHref 是形如 `list-product` 这样的自定义链接格式
- dwHref 支持参数 `list-product?id=1`
- redirectTo 参数默认为 false，如果为 true 则使用 `wx.redirectTo` 跳转链接，下同


## 应用跳转到子页面

```
dw.goToPappPage(name, params, { redirectTo: false })
```

这个用来实现跳转到应用名称为 `name` 的子页面，可以通过 `params`传递参数。

之前名称为 `dw.goToPage()`比较误导，现在重命名为 `dw.goToPappPage()`，当然旧名称依然可用。


## 跳转到应用首页

```
dw.goToPappHome (params, { redirectTo: false })
```

使用这个 API 可以返回应用首页，可以自动兼容应用被添加到不同页面的问题
