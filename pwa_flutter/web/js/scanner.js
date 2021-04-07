async function detectCode(dataUrl,callback){
    const codeReader = new ZXingBrowser.BrowserQRCodeReader();

    const codeResult = await codeReader.decodeFromImageUrl(dataUrl);

    console.log("Code result :",codeResult);

    callback(codeResult);
}
