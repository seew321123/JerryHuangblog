
```
if (!Dcompany.store.state.uniqueModuleName) {
  Dcompany.store.registerModule('uniqueModuleName', config)
}
```

注意

1. `uniqueModuleName` 必须全站唯一
2. 上述代码中的判断是为了避免重复注册
3. `config` 里面用到的 `type` 名称必须全站唯一

## 防止冲突规范

- 建议 `uniqueModuleName` 使用 `papp_<slug>_module`
- 建议 `type` 使用 `papp_<slug>_<typeName>`

其中 `slug` 是应用全局英文名称，只能用纯字母，可以在下面设置

 ![ ](https://s2.d2scdn.com/2018/02/28/FsuNlJUYG3bTiaKusj5gXEMa37gn.png)
