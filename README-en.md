# WEB print, HTML to PDF tool. bookjs-eazy

- Readme: [中文](./README.md) | [English](./README-en.md)
- Repository: [GITEE](https://gitee.com/wuxue107/bookjs-eazy) | [GITHUB](https://github.com/wuxue107/bookjs-eazy)
- Mainly solve the problem of HTML generating PDF and paging control. From then on, it is no longer difficult to generate high-quality PDF.
- Dependent js libraries: polyfill, jquery, lodash, bookjs-eazy
- Advantages:

1. Just focus on using H5 to construct your PDF content, without worrying about paging and content truncation, and automatically paging according to rules.
2. Support preview, WYSIWYG. Support WEB printing, support custom page number/directory/header/footer.
3. Both the front and back ends can generate PDF, the front end can print and save as PDF, and the back end can use chrome headless and wkhtmltopdf command line PDF generation tools.
4. Docker mirror. A print generation service that can quickly build your online PDF
5. Compatible with mainstream browsers and mobile terminals


- Defect tips:

1. Modern js frameworks VUE, React and other single-page multi-routing scenarios are not supported. Script tags need to be directly introduced in html, and cannot be introduced in import and compiled again.
2. Dynamic refresh is not supported, and the entire page needs to be refreshed for re-rendering.
3. PDF pages require a separate html file entry.
4. If you want to embed inside the application web page, you can use the iframe method.


# Preview Case (./dist)

- <a href="https://bookjs.zhouwuxue.com/eazy-1.html" target="_blank" rel="noopener noreferrer">eazy-1.html</a>

![alt ](https://bookjs.zhouwuxue.com/static/js/bookjs/eazy-1-qrcode.png)

- Another novel case
- JS : <a href="https://bookjs.zhouwuxue.com/eazy-2.html" target="_blank" rel="noopener noreferrer">eazy-2.html</a>
- Lodash template:<a href = "https://bookjs.zhouwuxue.com/eazy-4.html" target = "_blank" rel = "noopener noreferrer">eazy-4.html</a>
- Vue template: <a href = "https://bookjs.zhouwuxue.com/eazy-3.html" target = "_blank" rel = "noopener noreferrer">eazy-3.html</a>


![alt ](https://bookjs.zhouwuxue.com/static/js/bookjs/eazy-2-qrcode.png)

- Invoice case
- <a href="https://bookjs.zhouwuxue.com/eazy-5.html" target="_blank" rel="noopener noreferrer">eazy-5.html</a>
- **Note**: For pages with custom paper, it can be displayed correctly only when chrome "Print Save as PDF" or the corresponding printer and paper are installed and selected in web printing. Otherwise there may be confusion. Using chrome headless and wkhtmltopdf does not affect

![alt ](https://bookjs.zhouwuxue.com/static/js/bookjs/eazy-5-qrcode.png)

- Table: Merge Cells
- Reference example:<a href = "https://bookjs.zhouwuxue.com/eazy-6.html" target = "_blank" rel = "noopener noreferrer">eazy-6.html</a>


# Use docker quick experience (you can not use docker, please refer to the chapter [PDF generation service installation](# self-built printing service native installation pdf generation service))

- Download or clone the project, the command line into the project directory.
- Run./docker-start.sh or docker-start.bat
- You can access demo through the browser http:// 127.0.0.1:3000/eazy-1.html, print and create PDF
- You can try to write your own pdf page in the dist directory.

# Usage:

    Rendering Mechanism:
    1. place the PDF page content elements under the body>#content-box node (reference: PDF content design)
    2. The program will check the value of the global variable window.bookConfig.start (reference: configuration page parameters)
    Rendering does not start until this value is true renders the contents of the# content-box node to PDF style. 
    **Important**: If your page is dynamic, set the default value to false first, and set it to true when the content is ready. 
    3. Height page overflow detection principle:
    The page content node. nop-page-content is a container node with an elastic height. 
    Adding content to the page causes the height of the container node to change. 
    To calculate whether the page overflows, it is obtained by calculating its height. 
    **NOTE * *: 
    a. display: float, position: absolute; Insertion of overflow-style elements does not change the height of the page container. May cause page overflow to go undetected. 
    B because margin style elements cannot be stretched out. nop-page-content size, resulting in. nop-page-content position offset, it is easy to cause page overflow phenomenon, so control the relative position as far as possible to use padding

## Configure page parameters:

- Define a global configuration variable bookConfig

```html
<script>
bookConfig = {
        
    // ! ! Important! ! Important! !  
    // When this value is true, the page starts rendering. If your page is dynamic, 
    // Set the default value to false first, and set it to true after the# content-box node content in the following section is * * ready *
    // **Ready** means that all html rendering is complete. For example: there are multiple asynchronous requests, there are charts, etc. Reference: eazy-1.html
    // bookConfig.start = true; // Start bookjs rendering, differential page. 
    // All other parameters except this configuration item are optional! ! ! 
    start : true

    /**All paper types, not fully tested, commonly used ISO_A4
    ISO_A0, ISO_A1, ISO_A2, ISO_A3, ISO_A4, ISO_A5
    ISO_B0, ISO_B1, ISO_B2, ISO_B3, ISO_B4, ISO_B5, ISO_B6, ISO_B7, ISO_B8, ISO_B9, ISO_B10
    ISO_C0, ISO_C1, ISO_C2, ISO_C3, ISO_C4, ISO_C5, ISO_C6, ISO_C7, ISO_DL, ISO_C7_6
    JIS_B0, JIS_B1, JIS_B2, JIS_B3, JIS_B4, JIS_B5, JIS_B6, JIS_B7, JIS_B8, JIS_B9
    NA_LEGAL, NA_LETTER, NA_LEDGER, NA_EXECUTIVE, NA_INVOICE, 
    BIG_K32
    * */
    // Define the paper size, two ways, optional, default: ISO_A4
    pageSize : 'ISO_A4 ', 
    orientation : 'landscape', // portrait/landscape definition paper is vertical/horizontal screen placement
    /**pageSizeConfig and pageSize/orientation combinations, just choose one * */
    pageSizeOption : {
        width : '15cm', // custom width and height
        height : '20cm ',
    }

    // optional, margin, listed options are default
    padding : "31.8mm 25.4mm 31.8mm 25.4mm ", 

    //
    // -- !!!!  See here can go to the "PDF content design" chapter, when necessary to learn more about the following parameters!!!! --//
 
    // Optional, height repair option. 
    // Different browsers may have blank pages on each page when printing PDF
    // Commonly used to customize paper that does not fit.  
    // Adjust the correction by this value
    pageFixedHeightOffset : -1.0, //unit mm, generally negative

    // Optional, force the background page to print, the options listed are the default values
    forcePrintBackground : true
    // Optional. When the text content is spread across pages, the character that does not appear at the beginning of the paragraph. The listed options are the default values.
    textNoBreakChars : [',','. ',':',' "','! ','? ',',',';',',','] ','... ',',',',','! ',']','}','}'],
    // Optional, milliseconds, PDF generation delay time, (this configuration item does not affect the preview). Some pages contain asynchronous uncontrollable factors. Adjust this value to ensure that the page prints properly. This value can be adjusted appropriately to optimize the speed of PDF generation by the server
    printDelay : 1000 

    // Simple page number plug-in, optional (not enabled by default), the listed options are the default values when enabled
    simplePageNum : {
        //Number from which page, default 0 is the first page, there is no page number, or it can be a css selector such as ".first_page", number from the page containing the selector contact
        pageBegin : 0 
        //From the end number of the page, the default -1 is the end of the last 1 page. Without a page number, it can also be a css selector such as ".end_page" to the end number of the page containing the selector contact
        pageEnd : -1
        // Page part, optional
        pendant : '<div class="page-num-simple"><span style="">${PAGE} / ${TOTAL_PAGE}</span></div> ',
    }, 

    // directory/bookmark plug-in, optional (not enabled by default), the listed options are the default values when enabled
    simpleCatalog : {
        // current version, if you need to generate PDF bookmarks, toolBar.serverPrint.wkHtmlToPdf must be true
        // titlesSelector do not modify, use h1-h6 to mark bookmarks
        titlesSelector : 'h1,h2,h3,h4,h5,h6', // optional, as a selector for directory titles, in turn by directory level

        
        /**Directory-related options * */
        showCatalog : true, // optional, whether to insert a directory into the page, default, insert a directory into the page
        Header: '<div class = "catalog-title"> directory </div>', //optional, Header section of directory page, put everything you want to add
        itemFillChar : '...', // optional, directory entry padding character, "" empty string, no padding, ignored when using custom makeItem configuration
        positionSelector : '.nop-page-item-pagenum-1', //optional, the directory location will be inserted before the matching page, and the default is before the first numbered page.
        // Optional, custom directory entry. 
        makeItem : function(itemEl,itemInfo) {
           /* * 
            * @var itemEl jQuery Element 
            * @var object itemInfo PS: {title, pageNum, level,linkId}
            * */
            return '<div> custom directory item html content, constructed according to the itemInfo </div>';
        },

        /**Sidebar (PDF Bookmarks) Related Options * */
        showSlide : true, // optional, whether to display sidebar, directory navigation, toolbar button order index: 200, invalid when bookConfig.toolBar option is false
        slideOn : false, // optional, directory navigation, default open state
        slideHeader : '<div class = "title"> Purpose & nbsp;& nbsp; Record </div>', // Optional, sidebar title
        slideClassName : '', // optional, sidebar custom class
        slidePosition : 'left', // optional, position left, right
        slideMakeContent : null, // custom sidebar content processing function, when null, the default behavior: fill with directory content, function(){return'sidebar content';}
    },

    // Toolbar plug-in, optional (enabled by default),object | false, false will not display the toolbar, the listed options are the default values when enabled
    toolBar : {
        // Web print button function is optional, default true, button order index: 100
        webPrint : true 

        /* *
         * HTML save button, optional, bool | object, default false: disable saving HTML feature, true: enable and use default option
         * Button order index: 300
         * saveHtml : {
         * // Optional. The saved file name. Default value: document.title + '.html'
         * fileName : 'output.html ',
         * // Optional, custom download and save. Can be used for downloading in mixed APP
         * save : function(getStaticHtmlPromiseFunc,fileName) {
         * getStaticHtmlPromiseFunc().then(function(htmlBlob) {
         * ...
         * })
         *}
         *}
         */
        saveHtml : false

        /* *
         * The server prints the download button, and the button sequence index: 400
         * optional, bool | object, default false: not enabled, true: enable and use the default option, object: use custom server printing
         * true Equivalent object configuration: serverPrint : { serverUrl : '/' }, 
         * Official website available serverUrl : '// bookjs.zhouwuxue.com/'
         * To use serverPrint, you must have server access to your web page. Web pages do not use login status authorization, it is recommended to pass temporary authorization through URL parameters.
         * If you use the official server for printing, you need to correctly access the web page you constructed with bookjs-eazy on the public network.
         * 
         * serverPrint : {
         * // Optional, print server address, button order index: 400
         * serverUrl : '/',
         *
         * // Optional. If true, use wkHtmlPdf creation. If false, use chrome headless by default.
         * // **Note**: The wkhtmltopdf does not support es6 and lacks some new web features. The advantage is that it can generate PDF directory bookmarks. 
         * // For better debugging, please download QtWeb browser, its kernel is the same as wkhtmltopdf. 
         * // menu-> tools-> enable web page inspector, right-click the page content, select check to enter the debug toolbar
         * // to discover various compatibility issues
         * // Default to the print mode style in QtWeb browser. do not display page intervals, and toolbars
         * // Download link: http://www.qtweb.net/download.html
         * wkHtmlToPdf : false 
         *
         * // Optional. The name of the saved file document.title + '.pdf 'by default'
         * fileName : 'output.pdf ',
         * // Optional, print subsidiary parameters
         * params : {
         * // Print timeout
         * timeout : 30000
         * // After the page is rendered, delay before printing
         * delay : 1000
         * }, 
         * // Optional, custom download. Can be used for downloading in mixed APP
         * save : function(pdfUrl, serverPrintOption) {
         *         
         *}
         *}
         */
        serverPrint : false
        
        buttons : [
            // You can customize the toolbar button here
            // {
            // id : 'cloudPrint ',
            // index : 1, // the order of the button position. the smaller one is displayed in the front. the system's built-in button index value. see the description of each configuration item. 
            // icon : 'https://xxxx.../aa.png'
            // onClick : function(){ console.log("...do some thing");}
            //}
        ],

        className: '', // extra custom class attribute
        position : 'right',// Location: right, left
    }
}
</script>
```

## PDF content design (page content paging method)

- Define the content to be inserted into the document in an id content-box node;
- Each first-level child node under the content-box needs to define attributes data-op-type indicate how it is inserted in the document.
- Example:

```html
<body>
    <div id="content-box">
        <p data-op-type="text">Hello World! </p>
    </div>
</body>
```

- Except that block and text can be nested in container nodes of box types (mix-box, table, block-box, text-box), other types do not support nesting each other.
- Specific attention to view each type of "use in locations that meet the following selector rules" description

### block: block, indivisible (default)

- If the current page has enough space, it will be inserted as a whole, and if the space is insufficient, a new page will be automatically created and inserted as a whole to the next page
- **Note**: The block here is only the content and does not span pages. Regardless of the display in css, you can display the: inline style.
  A previous user asked this question. Thus limiting his thinking on PDF content design.
- Example: [Block Example](https://bookjs.zhouwuxue.com/static/book-tpl/editor.html?code=4ELVR92Y)
```html
<div data-op-type="block">...</div>
```
- Use in one of the positions that meet the following selector rules:
```
# content-box> next level node
[data-op-type = mix-box] .nop-fill-box> Level 1 node under the mixed box container node
[data-op-type = table] tbody td> Of the cells of the table
```

### text: text, which can be split into different pages

- Automatic splitting of cross-page content, with text content directly placed in nodes. (internal can only be text, if it contains child nodes, the child node label will be deleted)
- Example: [Text Example](https://bookjs.zhouwuxue.com/static/book-tpl/editor.html?code=D8PBJHC5)
```html
<p data-op-type="text"> long text...</p>
<p data-op-type="text"> long text2...</p>
```

- Use in one of the positions that meet the following selector rules:
```
# content-box> next level node
[data-op-type = mix-box] .nop-fill-box> Level 1 node under the mixed box container node
[data-op-type = table] tbody td> The first-level node of the cell of the table
```


### new-page: new page, manual control to add new page
- The content after the marked node will be written starting from the new 1 page
- Example: [New Page Example](https://bookjs.zhouwuxue.com/static/book-tpl/editor.html?code=R992XN88)
```html
<div data-op-type = "new-page"> is just a tag node, the content here is not rendered </div>
```
- Use in one of the positions that meet the following selector rules:
```
# content-box> next level node
[data-op-type = mix-box] .nop-fill-box> Level 1 node under the mixed box container node
[data-op-type = table] tbody>tr nodes under tbody of tr table, (unlike marked to other positions, marked tr nodes will remain and will not be deleted from the page)

```



### pendants: page parts, elements that are fixed relative to the page position (header, footer, page label,...)

- The child node inside the pendants will be automatically marked with class:nop-page-pendants, and every page after its definition will be displayed until the next pendants appears.
- The widget nop-page-pendants contains the css: {position: absolute} attribute, which is fixed relative to the page paper position.
- When designing the page, you need to set css: left/right/top/bottom/width/height and other properties for the part node to control the position and size of the part.
- Use in one of the positions that meet the following selector rules:
```
# content-box> next level node
```
- Example: [Part Example](https://bookjs.zhouwuxue.com/static/book-tpl/editor.html?code=V86PPDPA)
```html
<div data-op-type="pendants">
    <div style="top: 50px;left: 100px;width: 100px;height: 100px"><img src="...." alt="logo"></div>
    <div style = "bottom: 50px;left: 400px;width: 100px; height: 30px"><span> Footer: Chapter: xxx</span></div>
</div>
```


### Box, differential, and carry layout style
- Includes mix-box, table, block-box, and text-box types. See details for details.
- **Note**: Do not limit the height of the box and container nodes (such as height and max-height style), which affects overflow detection and causes unknown results.

#### mix-box: mix box (commonly used)
- box internal class:nop-fill-box marked container node can contain multiple [data-op-type = "text"],[data-op-type = "block"] elements
- When the element in the box is beyond the 1 page, it will be automatically divided to the next page according to the rules of text/block, and the external node carrying the package element will be copied.
- Example: See Example: [Mixed Box Example](https://bookjs.zhouwuxue.com/static/book-tpl/editor.html?code=EM8ANL97)
```html
    <div data-op-type="mix-box"><!-- when crossing pages: this node will be copied to the next page, except that all contents in the nop-fill-box page will be reused. there can only be one container node (class:nop-fill-box) in a data-op-type page, and the container node can be anywhere in the data-op-type = "mix-box" -->
        <div class = "title"> Layout 1</div>
        <div class="nop-fill-box">
            <!-- when crossing pages, the contents of class: nop-fill-box will continue to fill in the previous page -->
            <span data-op-type="text">AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA</span>
            <span data-op-type="new-page"></span><!--  Insert New Page -->
            <span data-op-type="text" sytle="color:red">BBBBBBBBBBBBBBBBBBBBBBB</span>
            <a data-op-type = "text" target = "_blank" href = "https://baijiahao.baidu.com/s?id=1726750581584920901&wfr=spider&for=pc"> Article link...</a><!-- link text here: if there are hyperlinks in the last two pages of the spread -->
        </div>
        <div class = "title"> Layout 2</div>
        <div class = "title"> Layout 3</div>
    </div>
```
- Use in one of the positions that meet the following selector rules:
```
 # content-box> next level node
```

#### table: table, also 1 kind of special box
- some display problems occurred when paging was encountered in the table, and some optimization treatment was made (* * note * *: the column must have a fixed width),(reference: ezay-6 example)
- For merged cells: the tag attribute data-split-repeat = "true" on td, the text in the pagination td will also be displayed on the new page.
- td : td> Direct child nodes can be [data-op-type = "text"],[data-op-type = "block"] elements
- Use in one of the positions that meet the following selector rules:
```
 # content-box> next level node
```

- Example: See Example: [Table Example](https://bookjs.zhouwuxue.com/static/book-tpl/editor.html?code=J2QR8NGC)
```html
<table data-op-type="table" class="nop-simple-table-2">
    <thead>
        <tr>
            <td width = "100"> Biological species </td>
            <td width = "100"> Subcategories </td>
            <td width = "500"> Detailed introduction </td>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td data-split-repeat = "true" rowspan = "2"> Animals </td>
            <td data-split-repeat = "true"> Reptile </td>
            <td>
                <p data-op-type="text">long text1 ...<p>
                <img data-op-type="block" src="..." /> 
                <p data-op-type="text">long text2 ...</p>
                <div data-op-type="block">... </div> 
            </td>
        </tr>
        <tr>
            <td data-split-repeat = "true"> Mammals </td>
            <td>
                <p data-op-type="text">long text1 ...</p>
                <img data-op-type="block" src="..." /> 
                <p data-op-type="text">long text2 ...</p>
                <div data-op-type="block">... </div> 
            </td>
        </tr>
        <tr>
            <td> Plants </td>
            <td> Ferns </td>
            <td>
                <p>long text...</p>
            </td>
        </tr>
   </tbody>
</table>
```

#### block-box: block box,(@ deprecated its function has been completely replaced by mix-box)
- The first-level child nodes inside the nop-fill-box marked nodes in the block box are all regarded as "blocks". When multiple blocks in the box are divided into multiple pages, the external nodes of the wrapped block are copied.
- Take the simple table in the next example:
- table node defined as a block box
  The-tbody node is defined as the container node that holds the block (using the class: nop-fill-box notation)
- In this way, when filling the line tr, when the current page is short of space, page change and copy the external table (excluding the part marked by the nop-fill-box) to continue filling. In this way, the header is reused.
- Use in one of the positions that meet the following selector rules:
```
 # content-box> next level node
```

- Example: See Example: [Block Example](https://bookjs.zhouwuxue.com/static/book-tpl/editor.html?code=6AYD2RET)
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

#### text-box: text box (@ deprecated its function has been completely replaced by mix-box)
- Similar to block boxes, when large text content spans multiple pages, the part of the box that wraps the text outside is copied.
- The first-level child nodes inside nop-fill-box marked nodes inside the text box are treated as "text"

### Example

- Use sample

```html
<div id="content-box" style="display: none">
    <div data-op-type="pendants"><!--  Define page parts (header/footer/page label/watermark background, etc.) -->
        <div class = 'pendant-title'> Chapter 1: Block Box </div>
    </div>
    <h1 data-op-type = 'block'> Chapter 1 Block Box </h1><!--  Block -->
    <table data-op-type="block-box" class="nop-simple-table-2" border="1"><!--  Block Box -->
        <thead>
            <tr><th>ID</th><th> Name </th><th> Age </th></tr>
        </thead>
        <tbody class="nop-fill-box"><!--  list of sub-blocks, the program will automatically differential -->
            <tr><td>1</td><td> Zhang San </td><td>12</td></tr>
            It's...
        </tbody>
        <tfoot>
            <tr><td colspan = "3"> Tail of table </td></tr>
        </tfoot>
    </table>
    <div data-op-type="new-page"></div><!--  New page tag, force start from new page -->
    <div data-op-type="pendants"><!--  Define page parts (header/footer/bookmark/watermark background, etc.) -->
        <div class = 'pendant-title'> Chapter 2: Text Box </div>
    </div>
    <h1 data-op-type = 'block'> Chapter 2 Text Box </h1><!--  Block -->
    <p data-op-type="text-box"><!--  Text Box -->
        <span class = "nop-fill-box">1234566 .... </span><!--  large text, the program will automatically differential -->
    </p>
    <div data-op-type="new-page"></div><!--  New page tag, force start from new page -->
    <div data-op-type="pendants"><!--  Define page parts (header/footer/bookmark/watermark background, etc.) -->
        <div class = 'pendant-title'> Chapter 3: Mixing Boxes </div>
    </div>
    <h1 data-op-type = 'block'> Chapter 3 Mixed Box </h1><!--  Block -->
    <div data-op-type="mix-box"><!--  Mixing Box -->
        <div class="nop-fill-box" style='font-size: 14px;line-height: 1.5;color: white'><!--  Text or block list, the program will automatically differential -->
            <div data-op-type='block' style='background-color: red;height: 300px;'>red</div>
            <div data-op-type='block' style='background-color: green;height: 300px;'>green</div>
            <div data-op-type='block' style='background-color: blue;height: 300px;'>blue</div>
            <span data-op-type='text' style='color: red'>ABCDEFGHIJKLMNOPQRSTUVWXYZ...</span>
        </div>
    </div>
</div>
```

# Online Experience

- <a href = "https://bookjs.zhouwuxue.com/static/book-tpl/editor.html"> Online template editing </a>
- Try it: <a href = "https://codepen.io/pen/?template=VwPKWvq">CodePen online test </a>

# Use Examples

## Page background image

- <a href = "https://bookjs.zhouwuxue.com/static/book-tpl/editor.html?code=5R4E4EJU"> Example of a page background image </a>

## Page Watermark

- <a href = "https://bookjs.zhouwuxue.com/static/book-tpl/editor.html?code=ESWDZ5G2"> Page Watermark Example </a>

## No paging PDF

- No paging PDF, only back-end generation is supported
- <a href = "https://bookjs.zhouwuxue.com/static/book-tpl/editor.html?code=W83KPQXV"> Do not page PDF</a>


# Relevant details in the design

## Font Related

- If the PDF is generated on the server, it is recommended that the fonts used be pre-installed on the server that generates the PDF to ensure the consistency of the experience between the generated PDF and the browser preview.
- If docker starts, you can put the font file into./dist/fonts, and the font file will be automatically loaded when docker starts.
- In order to speed up the screenshot or PDF generation, the font file is usually large and time-consuming to download. To prevent font inconsistency in rendered screenshots or PDF, it is recommended that when setting fonts in css, the original font name should be used first, and then the network font alias should be used. For example:

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

## Event callback before page rendering
```javascript
    /* *
    * book.before-complete before BOOK rendering
    * */
    $(document).on('book.before-complete',function (e,info) {
        /* *
         * info: 
         * {
         * "PAGE_BEGIN_INDEX": 0, // the page sequence number of the starting page number tag
         * "PAGE_END_INDEX": 2, // the page sequence number of the end page number tag
         * "TOTAL_PAGE": 3 // total pages
         *}
         * */
    });
```

## Do not display and force printing background when printing

class: nop-no-print marked nodes are not displayed when printing
class: nop-force-background the marked node to force the printing background, available when the forcePrintBackground option is false

## parity page implementation

- After setting the simple page number plug-in, the corresponding class: nop-page-item-odd (odd pages), nop-page-item-even (even pages) nop-page-item-pagenum-1 (page number) will be added to the page node.

## After the text and box are divided into different pages, they are processed by the special style of the differential part.

- The same paragraph text, the text part node that is divided into the next page, will be marked by class: nop-link-last. Special indentation processing can be performed according to this class

- text-box, block-box, and mix-box content will also be marked by class: nop-link-last

## Browser type tag

- Book node. The browser type is marked on. class: chrome, firefox, safari, ie, qq, wechat, wkhtmltopdf

## Processing of style differences during printing and previewing

- Book node. In different modes, will use class: nop-book-preview (preview), nop-book-print (print) for marking

## PDF attribute information generation

- You can add meta tags to the page, and the bookjs-eazy will generate them into the attribute information of the pdf.
- Starting from version 1.12.0, server generation is valid.

```html
<meta name="author" content="nop">
<meta name="description" content="bookjs-eazy so eazy !! ">
<meta name = "keywords" content = "PDF, bookjs">
```

## Auxiliary function, see [BookJsHelper.md](BookJsHelper.md)

# Use of PDF generation and supporting PDF generation command line tools

## Click the print button through the browser to print and save as PDF

- Click the WEB print button to print and select "Save as PDF"

## Server-side printing
- Reference: bookConfig.toolBar.serverPrint server-side printing options
- can be configured as: true (and {serverUrl : '/'} equivalent) or {serverUrl : '// your_screenshot_api_server_host[:WEB_PORT]/'}

### Self-built printing service, use official website docker image, click to download PDF directly (server-side printing, recommended)

- Can be quickly deployed using./docker-start.sh
```bash
    # Own command for the docker print service
    # ./docker-start.sh [WEB port, default 3000]
    
    ./docker-start.sh
    # Run the print service
    # will create a web site with dist as the root directory. The sample can be accessed at http:// 127.0.0.1:3000/eazy-1.html and printed on the server.
    # 
    # You can create book.html with bookjs-eazy in the dist root directory (see example: eazy-1.html). 
    # Access http:// 127.0.0.1:3000/book.html for preview/print download
    # The generated pdf will be in the dist/pdf/directory. 
```

For more information, see the <a href = "https://gitee.com/wuxue107/screenshot-api-server" target = "_blank">wuxue107/screenshot-api-server</a> project

### Self-built printing service, local installation PDF generation service

```shell script
    # You need to pre-install the nodejs environment and install yarn
    git clone https://gitee.com/wuxue107/screenshot-api-server.git
    cd screenshot-api-server
    # Install dependencies
    yarn
    # Start the service. The default service port number is 3000
    # Specify the port number to start
    # Environment variables that can be specified at startup
    # MAX_BROWSER = 1 The maximum number of puppeteer instances. If the option is ignored, the default value is [Available Memory]/200M
    # PDF_KEEP_DAY = 0 Automatically delete the file directory generated num days ago, default 0: do not delete files
    # PORT = 3001 listening port, default: 3000
    yarn start
```

Specify the configuration bookConfig.toolBar.serverPrint.serverUrl value as: '// your-screenshot-api-server[:PORT]/'



## Command line printing, using chrome headless mode rendering

- This plugin adapts wkhtmltopdf and chrome headless. You can use the command-line tools packaged in this project to generate beautiful PDFs from the back end.

```bash
    # When using for the first time, install the dependency package of bin/html2pdf
    yarn install
```

```bash
    # After installation, execute the command
    # Example:
    bin/html2pdf print --output eazy-2-1.pdf "https://bookjs.zhouwuxue.com/eazy-2.html"
    
    #
    # Command line description:
    # Usage: html2pdf print [options] <url>
    #   
    # Options:
    # -o -- output [outputfile] Path to save the PDF file (default: "output.pdf")
    # -t -- timeout [type] timeout (default: 60000)
    # -a -- agent [agent] specifies the conversion engine chrome-headless | puppeteer, default: puppeteer (default: "puppeteer")
    # -d -- printDelay [delay] wait delay (ms) before printing (default: 1000)
    # -c -- checkJs [jsExpression] js expression to check whether rendering is completed (default: "window.status === 'PDFComplete'")
    # "window.document.readyState === 'complete'" This expression can be used as a non-bookjs-eazy built web page
    # -h, --help display help for command
    #
    #
```

## Command line printing, using wkhtmltopdf rendering (PDF bookmarks will be generated according to h1-h6), you need to download the command line yourself and put it into the directory where the PATH environment variable is located.

```bash

    bin/pdf-a4-landscape "https://bookjs.zhouwuxue.com/eazy-2.html" eazy-2-2.pdf
    #
    # There are several similar script files in the bin directory. 
    # 
    # bin/pdf-[Paper]-[Paper Orientation] [Preview Link] [Output File]
    #
    # **Note**: If you use wkhtmltopdf custom size, don't worry, after the browser renders, the wkhtmltopdf PDF matching generation command will be output on the Console
```

# Generate FAQ (Pit Stamping Memo)

- Server printing failure:
  -Starting the print service (screenshot-api-server) must be able to access the PDF preview page you want to print from HTML.

- Content beyond the page:
  -Some such as: display: float, position: absolute; overflow style elements may not change the height of the page container. Thus showing beyond the page.
  -because margin style elements cannot be stretched out. nop-page-content size, resulting in. nop-page-content position offset, it is easy to cause page overflow phenomenon, so control the relative position as far as possible to use padding
  -Before setting bookConfig.start = true, the page content under# content-box has not been loaded by other programs (Vue, React, Ajax ..). After bookjs is re-paginated, other programs are operating the corresponding dom again, resulting in a change in the original size of the node, thus showing that the content overflows the page.

- Extra blank space on the page:
  -do not manually make any border/width/height/margin/padding style adjustments to html, body,. nop-book,. nop-page,. nop-page-items, and nop-page-item elements

- One more blank page per page
  -See bookConfig.pageFixedHeightOffset option for adjustment

- Print out is a blank page
  -Some users reflected that a blank page appeared after the page was introduced into polyfill.min.js. The introduction of this js is to wkhtmltopdf the compatibility of some js features.  If the test finds no effect on printing after removal, this js can be removed.

- Font cannot be displayed:
  -The generated PDF is full of frames or cannot be displayed because. In linux server environments, the required fonts are usually not installed. Or use web load font file too large, load timeout

- The generated PDF has some differences from the preview
  -For PDF generated by the server, the font of the page can be specified if possible due to the font. And install the corresponding font on the build server. See: Related Details in Design-> Font Related

- iframe embedded web page invalid: cannot click cannot download print:
  -need to add sandbox = "allow-downloads allow-top-navigation allow-scripts allow-modals" attribute to iframe

- page event binding failure:
  -After bookjs-eazy rendering,: If it fails, the original binding may be split into different pages. Please try to post the event binding after the PDF rendering is completed.

- Can't find wkhtmltopdf
  -Execute bin/pdf-xx-xx related commands. No wkhtmltopdf can be found. You need to download the wkhtmltopdf yourself and place it in the PATH directory.

- Merged cells with data-op-type = "table" are not displayed correctly. Recommendations:
  -Write the table layout well. First, use the data-op-type = "block" table without writing anything. Keep it in one page and see if the table without splitting is correctly laid out.  If it is not correct, there is something wrong with your own table, which has nothing to do with the bookjs-eazy.
  -When filling data in, use data-op-type = "table" instead. If there is a problem at this time. You can reproduce the scene here <a href = "https://codepen.io/pen/?template=VwPKWvq"> table test </a>, save and copy the link. Submit issue
- Download PDF timeout
  -The server timed out making PDF, your page may need token and session to access, and the back-end program cannot access your page correctly.
  -If you use wkhtmltopdf method, your page may use wkhtmltopdf unsupported features, such as es6.

- Page stuck, CPU super high
  -bookjs-eazy cannot be solved by import introduction and recompilation: it needs to be introduced through script tags in html.
  -The block element used exceeds the content of the 1 page and cannot be placed even if the page is changed.
  Common in "[data-op-type =" table "] td>[data-op-type =" block "]"
  The next element in td will be regarded as block by default if no data-op-type is specified.
  Please split the block element reasonably so that it can be placed in the 1 page.

- Parts cannot be displayed
  -When the margin is bookConfig.padding = "0 0 0 0", the blank page part cannot be displayed in the print preview of the Firefox browser.
  Adjustment bookConfig.padding = "1px 0 0 0"
  Or you can try to fill an empty text node for ``` <span>& nbsp<span>``` in the page.

<!--
    ```bash
    :: Start a local chrome headless
    "chrome.exe" --headless --disable-gpu --remote-debugging-port=9222 --disable-extensions --mute-audio
    :: Then use -- agent = chrome-headless to succeed. 
    :: The default -- agent = puppeteer is not required. The above operation will start its own browser. 
    ```
-->

# QQ communication group

![alt ](https://bookjs.zhouwuxue.com/static/js/bookjs/qq-group-1.png)


- Repository: [GITEE](https://gitee.com/wuxue107/bookjs-eazy) | [GITHUB](https://github.com/wuxue107/bookjs-eazy)
