function detectCode(selectedDeviceId,callback){
    const codeReader = new ZXingBrowser.BrowserQRCodeReader();

    const codeResult = codeReader.decodeFromVideoDevice(selectedDeviceId);

    console.log("Code result :",codeResult);

    callback(codeResult);
}
