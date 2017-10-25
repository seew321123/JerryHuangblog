担路网应用中心支付交易接口
===========================

## 概述

应用中心支付为应用中心的的程序提供统一支付的接口，每个应用将自己的订单编号传入 生成一个可以支付的 Charge 对象。

在 Charge 对象的基础上通过不同的支付方式(目前只支持支付宝) 传递来生成不同的支付链接，然后在前端监听相应的支付成功事件，进行后续的 业务逻辑处理。

同时在云函数中可以定义一个名字叫 payment 的云函数在后端接收支付 成功的事件调用。

每个应用中修改订单状态的操作应该放在 云函数 中去处理，防止用户通过 API 接口直接篡改数据。

所以在支付成功的通知处理过程中，云函数中处理订单动态的变更，前端 js 代码中只用查询
确认订单状态并且调转到订单详情页面即可。


## 应用中心调用

### 前端 js 中的调用

必须在应用依赖中增加 dcompany webpack entry 依赖，并且增加 `PaymentMixin`

```javascript
const dcompany = app.getDcompany()

export default {
  data() {
    return {
      payUrl:'',
    }
  },
  mixins: [dcompany.mixins.PaymentMixin],
  methods: {
    async payNow() {
      this.watchChargeStatus( data => {
        console.log(data)
        alert(data.status)
        /* 这里添加支付成功业务处理代码 */
      })

      const orderData = {subject: 'Test Order', amount: 100, status: 'pending'}
      const orderRes = await app.createRow('table1', {data: orderData})
      const order = orderRes.data.object

      let chargeData = {
        amount: 100,        // 支付金额,单位为 分
        subject: '产品名称',  // 支付产品名称
        body: '产品描述',     // 支付产品描述
        source: 'pc',       // 来源: pc/mobile/weixin
        channel: 'ALIPAY',  // 支付方式: 此处不指定，后面 `fetchPayUrl` 时必须指定，如果此处指定了，后面 `fetchPayUrl` 不指定会默认调用此处指定的
        trade_no: order.id, // 应用中的订单编号:
        livemode: false     // 支付正式环境: true 表示正式环境， false 表示测试开发环境(访问支付 URL 不用真实支付，会自动出发支付成功回调)
      }

      const charge = await this.createCharge(chargeData)

      const res = await this.fetchPayUrl(charge, { channel: 'ALIPAY' }) // 目前支持支付宝，后续会增加更多支付方式的切换
      this.payUrl = res.pay_url
    }
  }
}

```

### 云函数端的通知处理

支付成功后，系统会发送通知到 `payment` 这个云函数，所以每个需要支付的应用应该定义一个 `payment` 的云函数

```python
def payment(event, context):
    charge = event['charge']  # charge 中是回调传递过来的支付相关信息
    # {'charge': '{"body": null, "status": "succeeded", "created": "2017-10-14T10:51:34.233", "trade_no": "43", "paid": true, "paid_time": "2017-10-14T10:51:35.816", "data": {}, "id": 74, "subject": "TEST FOR CHARGE"}'}
    order = context.get_rows('table1').filter(pk=charge['trade_no']).first()
    if order:
        order.data['status'] = 'success'
        order.data['paid_time'] = charge['paid_time']
        order.save()
        return 'SUCCESS'  # 处理成功后必须返回 `SUCCESS`
    return 'FAIELD'
```





## HTTP 调用流程<应用中心不用使用>

### 创建交易请求

```
POST /capi/api/v1/charge

{
"subject": "商品主题",
"body"": "商品描述",
"amount": 100,
"channel": "ALIPAY",
"papp": 101,
"client_ip": "127.0.0.1",
"return_url": "https://www.sh-qiuzhen.com/return_url",
"notify_url": "https://www.sh-qiuzhen.com/notify_url"
}
```


### 获取支付跳转 URL

```
POST /capi/api/v1/charge/101/fetch_pay_url

# 参数
{
"channel": "ALIPAY"
}

# 返回值
{
"pay_url": "https://mapi.alipay.com/gateway.do?body=None&seller_email=alipay%40demlution.com&total_fee=0&service=create_direct_pay_by_user&paymethod=directPay&_input_charset=utf-8&sign=23194186804995997dac271353ee57ec&out_trade_no=150658495585026&payment_type=1&notify_url=https%3A%2F%2Fapi.demlution.com%2Fcharge%2Falipay_notify&sign_type=MD5&partner=2088801661897804&return_url=https%3A%2F%2Fapi.demlution.com%2Fcharge%2Falipay_return&subject=Test+For+Charge"
}
```

### 接收支付成功事件

```
POST /notify_url

{
"id": 101,
"subject": "商品主题",
"paid": true,
"paid_time": "2017-10-11 12:10",
"status": "succeeded",
"data": {
"trade_no": "20100010101001",
"buyer_email": "",
"seller_id": ""
}
}
```

在应用中接收该请求后必须返回 `SUCCESS`
