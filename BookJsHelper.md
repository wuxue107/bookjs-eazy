# BookJsHelper 辅助函数说明


## BookJsHelper.getQueryParam(queryParamName, defaultValue, url) 获取页面Query参数
```javascript
    // 当前页:  /eazy-1.html?aa=11&bb=22
    ret = BookJsHelper.getQueryParam()
    //ret  => {aa:'11',bb:'22'}
    ret = BookJsHelper.getQueryParam('cc','33')
    //ret  => '33'
    ret = BookJsHelper.getQueryParam('dd','444','/some?dd=44')
    //ret  => 44
```

## BookJsHelper.showMsg(msg)  显示一个弹出层消息,返回msgId
```javascript
    ret = BookJsHelper.showMsg(msg)
    // ret => 'id-xxxxxx' 消息ID
```
### BookJsHelper.closeMsg(msgId) 根据msgId关闭弹出层消息


### BookJsHelper.closeAllMsg() 关闭所有弹出层消息

### BookJsHelper.isMobile() 返回当前是否为在手机端浏览
### BookJsHelper.isWkHtmlToPdf() 返回当前浏览器是否为wkhtmltopdf内核
### BookJsHelper.isHeadless() 返回当前是否无头浏览器模式下浏览

### BookJsHelper.tag(tagName,attrs,content) 构建html片段
- tagName: 标签名
- attrs ： String/Object 属性
- content : String/Array 内容
```javascript
ret = BookJsHelper.tag(
         'select',
         {class:'form-control',name:'type',data:{aa:1,bb:2}},
         [
               ['option',{value:"2"},"选项2"],
               ['option',{value:"1"},"选项1"],
         ]
     );


// ret => <select class="form-control" name="type" data-aa='1' data-bb='2'><option value="2">选项2</option><option value="1">选项1</option></select>

```

### BookHelper.dataPath(path,sourceData,defaultValue) 从多层级数据中取值，不存在的返回默认值
```javascript
data = {a1:{a2:111},b1:[{b2:222}]};



// BookHelper.dataPath('a1.a2',data) => 111
// BookHelper.dataPath('a1.a2.a3',data) => null
// BookHelper.dataPath('a1.a2.a3',data,123) => 123
// BookHelper.dataPath('b1[0].b2',data) => 222

```
