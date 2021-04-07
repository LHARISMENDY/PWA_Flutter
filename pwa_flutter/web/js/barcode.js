function detectBarcode (dataUrl,callback){
    const codeReader = new ZXingBrowser.BrowserQRCodeReader();
    const codeResult = codeReader.decodeFromImageElement(dataUrl).then(function(result){
        if(result && result.codeResult){
            console.log('Found code :', result.codeResult.code);
            callback(codeResult.result);
        } else {
            console.log("not detected");
        }
    });
}