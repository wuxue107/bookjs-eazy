const Chrome = require('chrome-remote-interface');
const fs = require('fs');


let sleep = async function(timeout){
    return new Promise(function(resolve){
        setTimeout(function(){
            resolve();
        },timeout)
    });
};

const html2pdf = function(pageUrl,pdfFile,timeout,printDelay,checkPdfRenderCompleteJs){
    checkPdfRenderCompleteJs = checkPdfRenderCompleteJs || 'window.document.readyState === "complete"';
    console.log({pageUrl,pdfFile,timeout,printDelay,checkPdfRenderCompleteJs})
    Chrome(function (chrome) {
        with (chrome) {
            // 显示PDF网页的Console输出消息
            Console.enable();
            Console.messageAdded(function(param){
                console.log("Console:" + param.message.level.toUpperCase() + ':' +JSON.stringify(param));
            });

            Network.enable();
            let networkRequest = {};
            Network.requestWillBeSent(function (requestParam) {
                networkRequest[requestParam.requestId] = requestParam;
            });

            Network.loadingFailed(function(param){
                let requestParam = networkRequest[param.requestId];
                if(requestParam){
                    console.warn("Network:" + requestParam.request.url + "\n" + JSON.stringify(param));
                }else{
                    console.log("Network:" + JSON.stringify(param));
                }
            });


            let printPdf = async function(filePath,userOption){
                if(userOption === undefined){
                    userOption = {};
                }
                let option = {
                    //landscape : false,
                    displayHeaderFooter: false,
                    printBackground : true,
                    scale : 1,
                    // paperWidth : '1mm',
                    // paperHeight : '1mm',
                    marginTop : 0,
                    marginBottom : 0,
                    marginLeft : 0,
                    marginRight : 0,
                    // Paper ranges to print, e.g., '1-5, 8, 11-13'. Defaults to the empty string, which means print all pages.
                    pageRanges : '',
                    // Whether to silently ignore invalid but successfully parsed page ranges, such as '3-2'. Defaults to false.
                    ignoreInvalidPageRanges : false,
                    // HTML template for the print header. Should be valid HTML markup with following classes used to inject printing values into them:
                    // date: formatted print date
                    // title: document title
                    // url: document location
                    // pageNumber: current page number
                    // totalPages: total pages in the document
                    // For example, <span class=title></span> would generate span containing the title.
                    headerTemplate : '',
                    footerTemplate : '',
                    // Whether or not to prefer page size as defined by css. Defaults to false, in which case the content will be scaled to fit the paper size.
                    preferCSSPageSize: true,
                    // Allowed Values: ReturnAsBase64, ReturnAsStream
                    transferMode : 'ReturnAsStream',
                };

                Object.assign(option,userOption);
                let result = await Page.printToPDF(option);
                // transferMode ReturnAsBase64
                // return fs.writeFileSync(filePath, result.data, 'base64');

                let pdfFd= fs.openSync(filePath,'w');
                let blockSize = 1024000;
                let block;
                let readParam = {
                    handle : result.stream,
                    size : blockSize,
                };
                do{
                    block = await IO.read(readParam);
                    let data = block.base64Encoded ? Buffer.from(block.data, 'base64') : block.data;
                    fs.writeSync(pdfFd,data);
                }while (!block.eof);
                fs.fsyncSync(pdfFd);
                fs.closeSync(pdfFd);
            };

            let waitPdfRenderComplete = async function(timeout){
                let time = 0;
                return new Promise(function(resolve, reject){
                    let t = setInterval(function(){
                        time += 500;
                        Runtime.evaluate({expression: checkPdfRenderCompleteJs}).then(function(ret){
                            let isOk = ret.result.value === true;
                            if(isOk){
                                clearInterval(t);
                                resolve();
                            }
                        });
                        if(time > timeout){
                            clearInterval(t);
                            reject('timeout');
                        }
                    },500)
                });
            };

            let renderPdf = async function(){
                console.log("open url:" + pageUrl);
                await Page.navigate({'url': pageUrl});
                console.log("wait pdf render ...");
                await waitPdfRenderComplete(timeout);
                console.log("print delay:" + printDelay);
                await sleep(printDelay);
                console.log("save pdf file:" + pdfFile);
                await printPdf(pdfFile);
            };

            once('ready', function () {
                renderPdf().finally(function(){
                    // 清除缓存
                    // Network.clearBrowserCache();
                    chrome.close()
                })
            });
        }
    }).on('error', function (err) {
        console.error('Cannot connect to Chrome:', err);
    });
};

module.exports = html2pdf;

