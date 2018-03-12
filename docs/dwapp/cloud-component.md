
之前纠结过很多方案，都不太完美：

1. 方案一：映射到小程序自定义组件，缺点：不支持自定义样式、开发成本高、维护成本高
2. 方案二：映射到 dxml 组件，缺点：开发成本高、维护成本高

## 基于宏定义的组件方案

原理上是继续扩展中括号语法实现可复用

wxss

```
[[ com stepper.css a=1 ]]
```

wxml

```
[[ com stepper.wxml b=2 ]]
```


wjs

```
[[ com stepper.wjs namespace=3 ]]
```
