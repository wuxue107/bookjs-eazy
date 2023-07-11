# WEB打印，HTML转PDF工具。bookjs-eazy

- Readme: [中文](./README.md) | [English](./README-en.md)
- 仓库地址： [GITEE](https://gitee.com/wuxue107/bookjs-eazy) | [GITHUB](https://github.com/wuxue107/bookjs-eazy)
- 主要解决，HTML生成PDF，分页可控的问题，从此生成高品质PDF不在是困难的事
- 依赖js库：polyfill、jquery、lodash、bookjs-eazy
- 优势：

1. 只需专注用H5构件你的PDF内容,而无需关心分页及内容截断问题，按规则自动分页。
2. 支持预览，所见即所得。支持WEB打印、支持自定义页码/目录/页眉/页脚。
3. 前后端皆可生成PDF,前端打印另存为PDF,后端可配套使用chrome headless和wkhtmltopdf命令行PDF生成工具。
4. docker镜像。可快速构件你的在线PDF的打印生成服务
5. 兼容主流浏览器及移动端


- 缺陷提示：

1. 不支持现代js框架 VUE、React等单页面多路由场景，需要在html中用script标签直接引入，不能在import引入再经过编译
2. 不支持动态刷新，重新渲染需要刷新整个页面
3. PDF页面需要单独的html文件入口
4. 如果想嵌入应用网页内部，可使用iframe方式


# 预览案例(./dist)

- <a href="https://bookjs.zhouwuxue.com/eazy-1.html" target="_blank" rel="noopener noreferrer">eazy-1.html</a>

![alt ](https://bookjs.zhouwuxue.com/static/js/bookjs/eazy-1-qrcode.png)

- 另一个小说案例 
- JS : <a href="https://bookjs.zhouwuxue.com/eazy-2.html" target="_blank" rel="noopener noreferrer">eazy-2.html</a> 
- Lodash模板:<a href="https://bookjs.zhouwuxue.com/eazy-4.html" target="_blank" rel="noopener noreferrer">eazy-4.html</a> 
- Vue模板:   <a href="https://bookjs.zhouwuxue.com/eazy-3.html" target="_blank" rel="noopener noreferrer">eazy-3.html</a>


![alt ](https://bookjs.zhouwuxue.com/static/js/bookjs/eazy-2-qrcode.png)

- 发票案例
- <a href="https://bookjs.zhouwuxue.com/eazy-5.html" target="_blank" rel="noopener noreferrer">eazy-5.html</a>
- **注意**：对于自定义纸张的页面，只有在web打印中只有在chrome“打印另存为PDF”或有安装并选择对应打印机和纸张时在能正确显示。否则有可能错乱。使用chrome headless和wkhtmltopdf不影响

![alt ](https://bookjs.zhouwuxue.com/static/js/bookjs/eazy-5-qrcode.png)

- 表格: 合并单元格
- 参考实例：<a href="https://bookjs.zhouwuxue.com/eazy-6.html" target="_blank" rel="noopener noreferrer">eazy-6.html</a>


# 使用docker快速体验(可以不使用docker，请参考，[PDF生成服务安装](#自建打印服务本机安装pdf生成服务)章节)

- 下载或clone项目，命令行进入项目目录
- 运行 ./docker-start.sh 或 docker-start.bat
- 即可通过浏览器 http://127.0.0.1:3000/eazy-1.html 访问demo，打印并制作PDF
- 在dist目录下可以尝试写自己的pdf页面。

# 使用方式：

    渲染机制：
    1. 将PDF页面内容元素放置body>#content-box节点下（参考：PDF内容设计）
    2. 程序会检查全局变量window.bookConfig.start 的值（参考：配置页面参数）
    直到此值为true时，才开始渲染将 #content-box 节点的内容渲染为PDF样式。
    **重要**：如果你的页面是动态的，就先将默认值设为false,当内容准备好后，在将其设为true。
    3. 高度页面溢出检测原理：
    页面内容节点.nop-page-content，是一个弹性高度的容器节点。
    在向页面加入内容时会引起容器节点的高度变化。
    计算页面的是否溢出，就时通过计算它高度得到的。
    **注意**： 
    a. display: float, position: absolute; overflow样式的元素的插入不会页面容器高度变化。可能造成页面溢出而检测不到。
    b. 因为 margin样式的元素 无法撑开.nop-page-content 大小,造成.nop-page-content位置偏移，很容易造成页面出现溢出的现象，所以控制相对位置尽量使用padding
        
## 配置页面参数：

- 定义一个全局配置变量 bookConfig

```html
<script>
bookConfig = {
        
    // ！！重要！！重要！！ 
    // 当这个值为true时，页面才开始渲染。如果你的页面是动态的，
    // 就先将默认值设为false,当下节所述中的#content-box节点内容**准备好**后，在将其设为true
    // **准备好**是指：所有html渲染完毕。例如：有多个异步请求，有图表等。参考：eazy-1.html
    // bookConfig.start = true; // 开始bookjs渲染，差分页面。
    // 除了这个配置项外其他参数都是可选的！！！
    start : true,

    /**  全部纸张类型，未全量测试，常用ISO_A4
    ISO_A0、ISO_A1、ISO_A2、ISO_A3、ISO_A4、ISO_A5
    ISO_B0、ISO_B1、ISO_B2、ISO_B3、ISO_B4、ISO_B5、ISO_B6、ISO_B7、ISO_B8、ISO_B9、ISO_B10
    ISO_C0、ISO_C1、ISO_C2、ISO_C3、ISO_C4、ISO_C5、ISO_C6、ISO_C7、ISO_DL、ISO_C7_6
    JIS_B0、JIS_B1、JIS_B2、JIS_B3、JIS_B4、JIS_B5、JIS_B6、JIS_B7、JIS_B8、JIS_B9
    NA_LEGAL、NA_LETTER、NA_LEDGER、NA_EXECUTIVE、NA_INVOICE、
    BIG_K32
    **/
    // 定义纸张大小,两种方式,可选，默认：ISO_A4
    pageSize : 'ISO_A4', 
    orientation :  'landscape', // portrait/landscape 定义纸张是竖屏/横屏放置
    /** pageSizeConfig 和 pageSize/orientation组合 ，只选其一即可 **/
    pageSizeOption : {
        width : '15cm', // 自定义宽高
        height : '20cm',
    }

    // 可选，边距，所列选项为默认值
    padding : "31.8mm 25.4mm 31.8mm 25.4mm", 

    //
    // --  !!!!  看到这里可以先去《PDF内容设计》章节，有需要时再来详细了解下面的参数  !!!! --//
 
    // 可选,高度修复选项。
    // 不同的浏览器在打印时PDF有可能出现每页都多出空白页
    // 常用于自定义未适配的纸张。 
    // 通过此值调节修正
    pageFixedHeightOffset : -1.0, // 单位mm,一般为负值

    // 可选，强制打印背景页，所列选项为默认值
    forcePrintBackground : true,
    // 可选，文本内容在跨页差分时，不会出现在段首的字符，所列选项为默认值
    textNoBreakChars : ['，','。','：','”','！','？','、','；','》','】','…','.',',','!',']','}','｝'],
    // 可选，毫秒，生成PDF延时时间，（此配置项不影响预览）。有些页面包含一些异步不可控因素。调整此值保证页面打印正常。可以适当调节此值以优化服务端生成PDF的速度
    printDelay : 1000, 

    // 简易页码插件，可选（默认未开启），所列选项为开启时的默认值
    simplePageNum : {
        // 从第几页开始编号，默认0为第一页开始，，没有页码,也可以为一个css选择器如：".first_page"，从包含选择器接点的页面开始编号
        pageBegin : 0, 
        // 从第几页结束编号，默认-1为最后一页结束，，没有页码,也可以为一个css选择器如：".end_page"，到包含选择器接点的页面结束编号
        pageEnd : -1,
        // 页面部件， 可选
        pendant : '<div class="page-num-simple"><span style="">${PAGE} / ${TOTAL_PAGE}</span></div>',
    }, 

    // 目录/书签插件，可选（默认未开启），所列选项为开启时的默认值
    simpleCatalog : {
        // 当前版本，如果需要生成PDF书签，toolBar.serverPrint.wkHtmlToPdf 必须为true
        // titlesSelector不要修改，使用h1-h6标记书签
        titlesSelector : 'h1,h2,h3,h4,h5,h6', // 可选，作为目录标题的选择器，按目录级别依次

        
        /** 目录相关选项 **/
        showCatalog : true, // 可选，是否在页面中插入目录，默认，插入目录到页面
        header : '<div class="catalog-title">目 录</div>', // 可选，目录页Header部分，放入你想加入的一切
        itemFillChar : '…', // 可选，目录项填充字符, ""空字符串，不填充，使用自定义makeItem时，忽略该选项配置
        positionSelector : '.nop-page-item-pagenum-1', //可选，目录位置会插入在匹配页的之前，默认为第一个编号页前
        // 可选，自定义目录项。
        makeItem : function(itemEl,itemInfo) {
           /** 
            * @var itemEl jQuery Element 
            * @var object itemInfo PS: {title, pageNum, level,linkId}
            **/
            return '<div>自定义的目录项html内容，根据itemInfo自己构造</div>';
        },

        /** 侧边栏（PDF书签）相关选项 **/
        showSlide : true, // 可选，是否显示侧边栏，目录导航，工具栏按钮顺序index: 200, 在bookConfig.toolBar选项为false时无效
        slideOn : false, // 可选，目录导航，默认是否打开状态
        slideHeader : '<div class="title">目&nbsp;&nbsp;录</div>', // 可选，侧边栏标题
        slideClassName : '', // 可选，侧边栏自定义class
        slidePosition : 'left', // 可选，位置 left、right
        slideMakeContent : null, // 自定义侧边栏内容处理函数，为null时,默认行为：使用目录内容填充， function(){ return '侧边栏内容';}
    },

    // 工具栏插件，可选（默认开启），object|false, false会不显示工具栏， 所列选项为开启时的默认值
    toolBar : {
        // Web打印按钮功能可选，默认true, 按钮顺序index: 100
        webPrint : true, 

        /**
         * HTML保存按钮，可选，bool|object，默认false:禁用保存HTML功能，true:启用并使用默认选项
         * 按钮顺序index: 300
         * saveHtml : {
         *     // 可选，保存的文件名，默认值: document.title + '.html'
         *     fileName : 'output.html',
         *     // 可选，自定义下载保存。可用于混合APP内下载时用
         *     save : function(getStaticHtmlPromiseFunc,fileName){
         *         getStaticHtmlPromiseFunc().then(function(htmlBlob){
         *             ...
         *         })
         *     }
         * }
         */
        saveHtml : false,

        /**
         * 服务端打印下载按钮，按钮顺序index: 400
         * 可选，bool|object，默认false:不启用,true:启用并使用默认选项,object:使用自定义的服务端打印
         * true等效的object的配置：serverPrint : { serverUrl : '/' }, 
         * 要使用serverPrint,必须server能访问到你的网页。网页不要使用登录状态授权，建议通过URL参数传递临时授权
         * 如果使用官方的server进行打印，则需公网上可正确访问你用bookjs-eazy构造的网页
         * 
         * serverPrint : {
         *     // 可选，打印服务器地址,按钮顺序index: 400
         *     serverUrl : '/',
         *
         *     // 可选，true时使用wkHtmlPdf制作，false：默认使用chrome headless
         *     // **注意**：wkhtmltopdf不支持es6,缺失一些web新特性，好处在于可以生成PDF目录书签。
         *     // 为了更好的调试发现问题：请下载QtWeb浏览器,其内核于wkhtmltopdf是一样的。
         *     // 菜单->工具->启用网页检查器，右键页面内容，选择检查 进入debug工具栏
         *     // 以便发现各种兼容问题
         *     // 在QtWeb浏览器中默认为打印模式的样式。不显示页间隔，及工具栏
         *     // 下载链接：http://www.qtweb.net/download.html
         *     wkHtmlToPdf : false, 
         *
         *     // 可选，保存的文件名，默认值 document.title + '.pdf'
         *     fileName : 'output.pdf',
         *     // 可选，打印附属参数
         *     params : {
         *         // 打印超时时间
         *         timeout : 30000,
         *         // 页面渲染完成后，打印前延时
         *         delay : 1000,
         *     }, 
         *     // 可选，自定义下载。可用于混合APP内下载时用
         *     save : function(pdfUrl, serverPrintOption){
         *         
         *     }
         * }
         */
        serverPrint : false,
        
        buttons : [
            // 这里可以自定义工具栏按钮
            // {
            //    id : 'cloudPrint',
            //    index : 1, // 按钮位置顺序，小的显示在前面，系统内置按钮index值，见各配置项说明。
            //    icon : 'https://xxxx.../aa.png'
            //    onClick : function(){ console.log("...do some thing"); }
            // }
        ],

        className: '', // 额外自定义的class属性
        position : 'right',// 位置：right、left
    }
}
</script>
```

## PDF内容设计（约定页面内容分页方式）

- 定义一个id为content-box节点内放入要插入到文档里的内容；
- content-box下的每个一级子节点都需定义属性 data-op-type表示其在文档中的插入方式
- 示例： 

```html
<body>
    <div id="content-box">
        <p data-op-type="text">Hello World!</p>
    </div>
</body>
```

- 除block和text可以嵌套在盒子类型（mix-box、table、block-box、text-box）的容器节点内内,其他类型并不支持相互嵌套。
- 具体注意查看每种类型“使用在符合下列选择器规则的位置”说明

### block：块，不可分割（默认）

- 如果当前页空间充足则整体插入，空间不足，则会自动创建新页，整体插入到下一页
- **注意**：这里的块,仅是内容不跨页。与css中的display无关，也就可以display: inline样式。
      前面有用户问到这个问题。从而限制了他对PDF内容设计的思维。
- 例如：[块示例](https://bookjs.zhouwuxue.com/static/book-tpl/editor.html?code=4ELVR92Y)
```html
<div data-op-type="block">...</div>
```
- 使用在符合下列选择器规则的位置之一：
```
#content-box> 下的一级节点
[data-op-type=mix-box] .nop-fill-box>  混合盒子容器节点下的一级节点
[data-op-type=table] tbody td> 表格的单元格的
```

### text: 文本，可分割到不同页

- 跨页内容自动分割,节点内直接放入文本内容。(内部只能为文本，如果包含子节点，子节点标签将被删除)
- 例如：[文本示例](https://bookjs.zhouwuxue.com/static/book-tpl/editor.html?code=D8PBJHC5)
```html
<p data-op-type="text"> long text...</p>
<p data-op-type="text"> long text2...</p>
```

- 使用在符合下列选择器规则的位置之一：
```
#content-box> 下的一级节点
[data-op-type=mix-box] .nop-fill-box>  混合盒子容器节点下的一级节点
[data-op-type=table] tbody td> 表格的单元格的一级节点
```

        
### new-page: 新页，手动控制添加新页
- 在标记的节点后的内容，将从新的一页开始写入
- 例如：[新页示例](https://bookjs.zhouwuxue.com/static/book-tpl/editor.html?code=R992XN88)
```html
<div data-op-type="new-page">仅仅是一个标记节点，这里的内容是不会渲染的</div>
```
- 使用在符合下列选择器规则的位置之一： 
```
#content-box> 下的一级节点
[data-op-type=mix-box] .nop-fill-box>  混合盒子容器节点下的一级节点
[data-op-type=table] tbody>tr  表格的tbody下的tr节点,(与被标记到其他位置不同，被标记的tr节点会保留不会从页面删除)

```



### pendants: 页面部件，相对于页面位置固定的元素（页眉、页脚、页标签...）

- pendants内部的子节点，会自动标记class:nop-page-pendants，在其定义后的每个页面都会显示，直到下一个pendants出现。
- 部件nop-page-pendants包含css: {position: absolute}属性，相对页面纸张位置固定。
- 在页面设计时需要为部件节点设置css: left/right/top/bottom/width/height等属性来控制部件位置和大小。
- 使用在符合下列选择器规则的位置之一： 
```
#content-box> 下的一级节点
```
- 例如： [部件示例](https://bookjs.zhouwuxue.com/static/book-tpl/editor.html?code=V86PPDPA)
```html
<div data-op-type="pendants">
    <div style="top: 50px;left: 100px;width: 100px;height: 100px"><img src="...." alt="logo"></div>
    <div style="bottom: 50px;left: 400px;width: 100%;height: 30px"><span>页尾：章节：xxx</span></div>
</div>
```


### 盒子， 可差分，并携带布局样式
- 包含mix-box、table、block-box、text-box 多种类型详见具体
- **注意**：不要限定盒子及容器节点高度(如height、max-height样式)，影响溢出检测，出现未知结果

#### mix-box: 混合盒子（常用）
- 盒子内部class:nop-fill-box标记的容器节点的可以包含多个[data-op-type="text"],[data-op-type="block"]元素
- 盒子内的元素被超出一页时，会根据text/block的规则，自动分割到下一页，并会复制携带包裹元素的外部节点。
- 例如： 见示例：[混合盒子示例](https://bookjs.zhouwuxue.com/static/book-tpl/editor.html?code=EM8ANL97)
```html
    <div data-op-type="mix-box"><!-- 跨页时：这个节点会被复制到下一页，除nop-fill-box内所有的内容都会被复用,一个data-op-type里只可以有一个容器节点（class:nop-fill-box）,容器节点可以在data-op-type="mix-box"里的任意位置 -->
        <div class="title">布局1</div>
        <div class="nop-fill-box">
            <!-- 跨页时，class: nop-fill-box 里的内容会接着上一页页继续填充 -->
            <span data-op-type="text">AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA</span>
            <span data-op-type="new-page"></span><!-- 插入新页 -->
            <span data-op-type="text" sytle="color:red">BBBBBBBBBBBBBBBBBBBBBBB</span>
            <a data-op-type="text" target="_blank" href="https://baijiahao.baidu.com/s?id=1726750581584920901&wfr=spider&for=pc">文章链接...</a><!-- 这里的链接文字：如果跨页最两页里都会有超链接 -->
        </div>
        <div class="title">布局2</div>
        <div class="title">布局3</div>
    </div>
```
- 使用在符合下列选择器规则的位置之一：
```
 #content-box> 下的一级节点
```

#### table: 表格，也是一种特殊的盒子
- 对表格遇到分页时，出现的一些显示问题，做了些优化处理（**注意**：列一定要固定宽度），（参考：ezay-6 示例）
- 对于合并单元格：td上标记属性 data-split-repeat="true" ，在分页td里的文本会在在新页中也会显示。
- td : td>直接子节点可以是[data-op-type="text"],[data-op-type="block"]元素
- 使用在符合下列选择器规则的位置之一：
```
 #content-box> 下的一级节点
```

- 例如： 见示例：[表格示例](https://bookjs.zhouwuxue.com/static/book-tpl/editor.html?code=J2QR8NGC)
```html
<table data-op-type="table" class="nop-simple-table-2">
    <thead>
        <tr>
            <td width="100">生物种类</td>
            <td width="100">子类别</td>
            <td width="500">详解介绍</td>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td data-split-repeat="true" rowspan="2">动物</td>
            <td data-split-repeat="true">爬行动物</td>
            <td>
                <p data-op-type="text">long text1 ...<p>
                <img data-op-type="block" src="..." /> 
                <p data-op-type="text">long text2 ...</p>
                <div data-op-type="block">... </div> 
            </td>
        </tr>
        <tr>
            <td data-split-repeat="true">哺乳动物</td>
            <td>
                <p data-op-type="text">long text1 ...</p>
                <img data-op-type="block" src="..." /> 
                <p data-op-type="text">long text2 ...</p>
                <div data-op-type="block">... </div> 
            </td>
        </tr>
        <tr>
            <td>植物</td>
            <td>蕨类</td>
            <td>
                <p>long text...</p>
            </td>
        </tr>
   </tbody>
</table>
```

#### block-box: 块盒子，（@deprecated 其功能已完全被mix-box替代）
- 块盒子内部nop-fill-box标记的节点内部的一级子节点都被视作"块"，盒子内的多个块被分割到多个页面时，都会复制包裹块的外部节点。
-  以下一个示例中的简易表格为例：
-  table节点定义为块盒子
-  tbody节点定义为容纳块的容器节点（使用class: nop-fill-box标记）
-  这样在填充行tr时，当前页空间不足时，换页并复制外部table（除去nop-fill-box标记的部分）继续填充。这样表头就得到复用
- 使用在符合下列选择器规则的位置之一：
```
 #content-box> 下的一级节点
```

- 例如：见示例：[块示例](https://bookjs.zhouwuxue.com/static/book-tpl/editor.html?code=6AYD2RET)
```html
<table data-op-type="block-box" style="font-size: 16px">
<thead>
    <tr><th>ID</th><th>name</th></tr>
</thead>
<tbody class="nop-fill-box">
    <tr><td>1</td><td>name1</td></tr>
    <tr><td>2</td><td>name2</td></tr>
    <tr><td>...</td><td>...</td></tr>
</tbody>
</table>
```

#### text-box : 文本盒子（@deprecated 其功能已完全被mix-box替代）
- 与块盒子类似，大文本内容跨多个页面时，会复制外部包裹文本的盒子的部分。
- 文本盒子内部nop-fill-box标记的节点内部的一级子节点都被视作"文本"

### 示例

- 使用样例

```html
<div id="content-box" style="display: none">
    <div data-op-type="pendants"><!-- 定义页面部件（页眉/页脚/页标签/水印背景等） -->
        <div class='pendant-title'>第一章：块盒子</div>
    </div>
    <h1 data-op-type='block'>第1章 块盒子</h1><!-- 块 -->
    <table data-op-type="block-box" class="nop-simple-table-2" border="1"><!-- 块盒子 -->
        <thead>
            <tr><th>ID</th><th>姓名</th><th>年龄</th></tr>
        </thead>
        <tbody class="nop-fill-box"><!-- 子块列表，程序会自动差分 -->
            <tr><td>1</td><td>张三</td><td>12</td></tr>
            ...
        </tbody>
        <tfoot>
            <tr><td colspan="3">表格尾部</td></tr>
        </tfoot>
    </table>
    <div data-op-type="new-page"></div><!-- 新页面标记，强制从新页开始 -->
    <div data-op-type="pendants"><!-- 定义页面部件（页眉/页脚/书签/水印背景等） -->
        <div class='pendant-title'>第二章：文本盒子</div>
    </div>
    <h1  data-op-type='block'>第2章 文本盒子</h1><!-- 块 -->
    <p data-op-type="text-box"><!-- 文本盒子 -->
        <span class="nop-fill-box">1234566....(很长的文字)</span><!-- 大文本，程序会自动差分 -->
    </p>
    <div data-op-type="new-page"></div><!-- 新页面标记，强制从新页开始 -->
    <div data-op-type="pendants"><!-- 定义页面部件（页眉/页脚/书签/水印背景等） -->
        <div class='pendant-title'>第三章：混合盒子</div>
    </div>
    <h1  data-op-type='block'>第3章 混合盒子</h1><!-- 块 -->
    <div data-op-type="mix-box"><!-- 混合盒子 -->
        <div class="nop-fill-box" style='font-size: 14px;line-height: 1.5;color: white'><!-- 文本或块列表，程序会自动差分 -->
            <div data-op-type='block' style='background-color: red;height: 300px;'>red</div>
            <div data-op-type='block' style='background-color: green;height: 300px;'>green</div>
            <div data-op-type='block' style='background-color: blue;height: 300px;'>blue</div>
            <span data-op-type='text' style='color: red'>ABCDEFGHIJKLMNOPQRSTUVWXYZ...</span>
        </div>
    </div>
</div>
```

# 在线体验 
    
- <a href="https://bookjs.zhouwuxue.com/static/book-tpl/editor.html">在线模板编辑</a>

# 使用示例

## 页面背景图片

- <a href="https://bookjs.zhouwuxue.com/static/book-tpl/editor.html?code=5R4E4EJU">页面背景图片示例</a>

## 页面水印

- <a href="https://bookjs.zhouwuxue.com/static/book-tpl/editor.html?code=ESWDZ5G2">页面水印示例</a>

## 不分页PDF

- 不分页PDF，仅支持后端生成
- <a href="https://bookjs.zhouwuxue.com/static/book-tpl/editor.html?code=W83KPQXV">不分页PDF</a>


# 设计中的相关细节

## 字体相关

- 如果是服务端生成PDF,为了保证生成的PDF和浏览器端预览的体验一致性，建议在生成PDF的服务器预先安装使用到的字体。
- 如果是docker启动，可以将字体文件放入./dist/fonts下,字体文件会在docker启动时自动加载。
- 为了加快截图或生成PDF速度,通常字体文件较大，下载耗时。防止渲染截图或PDF出现字体不一致情况，建议css设置字体时，优先使用字体原字体名，再使用网络字体别名，例如：

```html
<style>
    @font-face {
        font-family: YH;
        src: url(./fonts/msyh.ttf);
        font-weight: 400;
        font-style: normal
    }

    body {
        font-family: "Microsoft YaHei", YH, sans-serif;
        font-weight: normal;
    }
</style>
```

## 页面渲染完成前，事件回调
```javascript
    /**
    * BOOK渲染完成前		book.before-complete
    **/
    $(document).on('book.before-complete',function (e,info) {
        /**
         * info: 
         * {
         *    "PAGE_BEGIN_INDEX": 0,  // 开始页码标记的页面序号
         *    "PAGE_END_INDEX": 2,    // 结束页码标记的页面序号
         *    "TOTAL_PAGE": 3         // 总页数
         * }
         **/
    });
```

## 打印时不显示和强制打印背景

  class: nop-no-print   被标记的节点在打印时不显示
  class: nop-force-background 被标记的节点强制打印背景，在forcePrintBackground选项为false时可用

## 奇偶页实现

- 在设置简易页码插件后，页面节点上会添加对应的class: nop-page-item-odd （奇数页）、 nop-page-item-even（偶数页） nop-page-item-pagenum-1（页编号）

## 文本、盒子被分割到不同页后，被差分部分特殊样式处理

- 同一段落文本，被分到下一页的文本部分节点，会被class:  nop-link-last 进行标记。可以根据此class,进行缩进特殊处理

- text-box 、block-box、mix-box 内容被分割部分也同样会被class: nop-link-last 标记

## 浏览器类型标记

- Book节点。上会标记浏览器类型。class: chrome、firefox、safari、ie、qq、wechat、wkhtmltopdf

## 打印和预览时样式差异处理

- Book节点。在不同模式下，会使用class: nop-book-preview（预览）、nop-book-print（打印） 进行标记

## PDF的属性信息生成

- 可以在页面中加入meta标签，bookjs-eazy会将其生成到pdf的属性信息中
- 从1.12.0 版本开始，服务端生成有效。

```html
<meta name="author" content="nop">
<meta name="description" content="bookjs-eazy so eazy!!">
<meta name="keywords" content="PDF、bookjs">
```

## 辅助函数,见 [BookJsHelper.md](BookJsHelper.md)

# 生成PDF及配套PDF生成命令行工具的使用

## 通过浏览器点击打印按钮，打印另存为PDF

- 点击WEB打印按钮 打印选择“另存为PDF” 

## 服务端打印
- 参考 ： bookConfig.toolBar.serverPrint 服务端打印选项
- 可以配置值为 ：true （和 {serverUrl : '/'}等效） 或 {serverUrl : '//your_screenshot_api_server_host[:WEB_PORT]/'}

### 自建打印服务、使用官网docker镜像,点击直接下载PDF(服务端打印、推荐) 

- 可使用 ./docker-start.sh 进行快速部署
```bash
    # 自己docker打印服务的命令
    # ./docker-start.sh [WEB端口,默认3000]
    
    ./docker-start.sh
    # 运行打印服务
    # 会以dist为根目录，创建一个web站点。可通过http://127.0.0.1:3000/eazy-1.html访问示例，并可使用服务端打印
    # 
    # 你可以在dist根目录下用bookjs-eazy创建book.html（参考示例：eazy-1.html）。
    # 即可访问 http://127.0.0.1:3000/book.html 进行预览/打印下载
    # 生成的pdf会存在dist/pdf/ 目录下。
```

详细内容见，<a href="https://gitee.com/wuxue107/screenshot-api-server" target="_blank">wuxue107/screenshot-api-server</a>项目

### 自建打印服务、本机安装PDF生成服务

```shell script
    # 需预先先安装nodejs 环境，并安装yarn
    git clone https://gitee.com/wuxue107/screenshot-api-server.git
    cd screenshot-api-server
    # 安装依赖
    yarn
    # 启动服务，默认服务端口号3000
    # 指定端口号启动
    # 启动时可指定的环境变量
    # MAX_BROWSER=1     最大的puppeteer实例数，忽略选项则默认值： [可用内存]/200M
    # PDF_KEEP_DAY=0    自动删除num天之前产生的文件目录,默认0: 不删除文件
    # PORT=3001         监听端口，默认：3000
    yarn start
```

指定配置bookConfig.toolBar.serverPrint.serverUrl值为： '//your-screenshot-api-server[:PORT]/'



## 命令行打印，使用chrome headless方式渲染

- 此插件适配了wkhtmltopdf和chrome headless。可使用本项目中配套封装的命令行工具，从后端生成精美PDF

```bash
    # 首次使用时,安装bin/html2pdf的依赖包
    yarn install
```

```bash
    # 安装过后，执行命令
    # 示例：
    bin/html2pdf print --output eazy-2-1.pdf "https://bookjs.zhouwuxue.com/eazy-2.html"
    
    #
    # 命令行说明：
    #   Usage: html2pdf print [options] <url>
    #   
    #   Options:
    #     -o --output [outputfile]     保存PDF文件的路径 (default: "output.pdf")
    #     -t --timeout [type]          超时时间 (default: 60000)
    #     -a --agent [agent]           指定转换引擎chrome-headless|puppeteer，默认：puppeteer (default: "puppeteer")
    #     -d --printDelay [delay]      打印前等待延迟（毫秒） (default: 1000)
    #     -c --checkJs [jsExpression]  检查是否渲染完成的js表达式 (default: "window.status === 'PDFComplete'")
    #                                  "window.document.readyState === 'complete'" 这个表达式可以用作非bookjs-eazy构建的网页
    #     -h, --help                   display help for command
    #
    #
```

## 命令行打印，使用wkhtmltopdf渲染(会更据h1-h6生成PDF书签),需自己去下载命令行，放入PATH的环境变量所在目录下
    
```bash

    bin/pdf-a4-landscape "https://bookjs.zhouwuxue.com/eazy-2.html" eazy-2-2.pdf
    #
    # 在bin目录下，有数个同类脚本文件。
    # 
    # bin/pdf-[纸张]-[纸张方向]  [预览的链接] [输出文件]
    #
    # **注意**：如果使用wkhtmltopdf方式的自定义尺寸，不用担心，浏览器渲染完毕后，在Console上会输出wkhtmltopdf的PDF配套生成命令
```

# 生成常见问题（踩坑备忘录）

- 服务端打印失效：
    - 启动的打印服务（screenshot-api-server） 必须要能够访问到你要打印的HTML制作的PDF预览页面。

- 内容超出页面：
    - 一些如： display: float, position: absolute; overflow样式的元素可能不会页面容器高度变化。因而表现出超出页面。
    - 因为 margin样式的元素 无法撑开.nop-page-content 大小,造成.nop-page-content位置偏移，很容易造成页面出现溢出的现象，所以控制相对位置尽量使用padding
    - 在设置bookConfig.start = true ，之前#content-box下的页面内容没有经其他程序（Vue、React、Ajax..）加载完毕。导致bookjs重新分页后,其他程序在又去操作相应dom，导致节点原始大小发生改变，从而表现为内容溢出页面

- 页面出现多余空白：
    - 不要手动对html、body、.nop-book、.nop-page、.nop-page-items、nop-page-item元素做任何的border/width/height/margin/padding等样式调整
    
- 每页都多出一个空白页
    - 见bookConfig.pageFixedHeightOffset 选项，进行调节
    
- 打印出来是空白页
    - 有用户反映，页面引入polyfill.min.js后出现空白页。引入此js是为了wkhtmltopdf,对部分js特性的兼容问题。 如果去除后测试发现对打印无影响，可将此js去除。

- 字体无法显示：
    - 生成的PDF里全是框框或显示不出来,原因在于。在linux服务器环境下，通常没有安装所需字体。或使用web加载字体文件太大，加载超时
    
- 生成的PDF与预览有一些差异
    - 对于服务端生成PDF,可能时由于字体原因，可以指定页面的的字体。并在生成服务器安装对应字体。见：设计中的相关细节->字体相关

- iframe 嵌入网页失效：不能点击无法下载打印：
    - 需要在iframe上加入 sandbox="allow-downloads allow-top-navigation allow-scripts allow-modals" 属性
    
- 页面事件绑定失效：
    - 经过bookjs-eazy渲染后，： 如果失效，原绑定可能被分割到不同页面，请尝试在PDF渲染完成事件后处理事件绑定。
    
- 找不到wkhtmltopdf
    - 执行bin/pdf-xx-xx 相关命令，找不到wkhtmltopdf，需自己去下载wkhtmltopdf放置PATH目录下
    
- 使用data-op-type="table" 表格合并单元格分页显示不正确。建议：
    - 将表格布局写好  先使用data-op-type="block"  表格不写任何东西，使保持在一个页面里，看看不经过拆分的表格是否布局正确。 如果不正确，就是你自己table写的有问题，和bookjs-eazy的无关。
    - 在将数据填充进去，改用data-op-type="table" ,此时如出现问题。可以在这里重现场景<a href="https://codepen.io/pen/?template=VwPKWvq">表格测试</a>，保存并复制链接。提交issue
- 下载PDF超时
    - 服务端制作PDF超时，你的页面可能需要token和session才能访问，后端程序无法正确访问你的页面
    - 如果使用wkhtmltopdf方式生成，可能你的页面使用了wkhtmltopdf不支持的特性，如es6
    
- 页面卡死，CPU超高
    - bookjs-eazy 不能经过了import引入和再编译 解决： 需要在html中通过script标签引入。
    - 使用的block块元素，超出一页内容，即使换页也放置不下。
    常见于“[data-op-type="table"] td>[data-op-type="block"]”中
    td里的下元素如果未指定data-op-type也会默认视为block
    请合理的拆分，block块元素大小，使其可以在一页内放置。
   
- 部件无法显示
    - 页边距 bookConfig.padding = "0 0 0 0" 时，在火狐浏览器的打印预览中，空白页部件无法显示。
    调整bookConfig.padding = "1px 0 0 0"
    或者可以尝试在页面中补一个``` <span>&nbsp<span>``` 的空文本节点。

<!--
    ```bash
    :: 启动一个本地chrome headless
    "chrome.exe" --headless --disable-gpu --remote-debugging-port=9222 --disable-extensions --mute-audio
    :: 然后再使用 --agent=chrome-headless 则会成功。
    :: 默认的 --agent=puppeteer 则不需,以上操作，会启动自带的浏览器。
    ```
-->

# QQ交流群

![alt ](https://bookjs.zhouwuxue.com/static/js/bookjs/qq-group-1.png)


- 仓库地址： [GITEE](https://gitee.com/wuxue107/bookjs-eazy) | [GITHUB](https://github.com/wuxue107/bookjs-eazy)
