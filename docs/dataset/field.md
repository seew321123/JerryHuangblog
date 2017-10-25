
数据库管理
==========

## 支持的字段类型

除了前 5 种基本类型，其他为派生类型

|类型|名称|Python 校验||   |
|---|---|---|---|---|
|text         |文本       |validator.CHAR_255             |   |   |
|number       |数字       |Or(int, float)                 |   |   |
|bool         |布尔值     |bool                           |   |   |
|richtext     |富文本     |validator.TEXT                 |   |   |
|foreignkey   |外键       |Or(None, int, validator.UUID4) |   |   |
|select       |选择性文本 |validator.CHAR_255             |   |   |
|color        |颜色       |validator.CHAR_255             |   |   |
|image        |图片       |validator.CHAR_255             |   |   |
|position     |经纬度     |validator.CHAR_255             |   |  -|


## 权限设置

针对前端直接访问的 API 实现了一套 ACL 机制，保证基本的数据安全。
下面针对具体 API 详细分析权限设置对 API 的影响。

权限分为表级和字段级，在下面叙述中会明确说明。

### app.createRow()

- 如果`对应表:所有用户是否可以创建`，创建的数据行不关联用户
- 如果`对应表:登录用户是否可以创建`，创建的数据行自动关联用户，我们把这条记录叫做 `用户数据行`，下面会继续用到
- 以上两个选项都不匹配则禁止创建，这种设置适合只需要管理员查看的内部数据表

### app.updateRow()

- 如果是 `用户数据行` 则检查 `对应表:登录用户是否可以修改`，否则检查 `对应表:所有用户是否可以修改`
- 上述表级检查通过之后对所有字段依次检查权限
  - 如果是 `用户数据行` 则检查 `对应字段:对应用户是否可以修改`
  - 如果不是 `用户数据行` 则检查 `对应字段:所有用户是否可以修改`

### app.removeRow()

- 如果是 `用户数据行` 则检查 `对应表:登录用户是否可以删除`，否则检查 `对应表:所有用户是否可以删除`


### app.getRows()

- 如果`对应表:所有用户是否可以读取`，返回所有结果
- 如果`对应表:登录用户是否可以读取`，返回登录用户对应的 `用户数据行`
- 以上都不满足返回空结果

### 字段读取权限

上述所有 API 都只会返回有访问权限的字段，检查方法

- 读取数据之后对所有字段依次检查权限
  - 如果是 `用户数据行` 则检查 `对应字段:对应用户是否可以读取`
  - 如果不是 `用户数据行` 则检查 `对应字段:所有用户是否可以读取`


### 其他问题

- 默认所有权限全部关闭，即调用上述所有 API 都不会返回内容