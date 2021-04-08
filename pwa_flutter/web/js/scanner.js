async function detectCode(stream, callback) {
    const formats = [
        ZXing.BarcodeFormat.AZTEC,
        //ZXing.BarcodeFormat.CODABAR,
        ZXing.BarcodeFormat.CODE_128,
        ZXing.BarcodeFormat.CODE_39,
        //ZXing.BarcodeFormat.CODE_93,
        ZXing.BarcodeFormat.DATA_MATRIX,
        ZXing.BarcodeFormat.EAN_13, 
        ZXing.BarcodeFormat.EAN_8,
        ZXing.BarcodeFormat.ITF,
        //ZXing.BarcodeFormat.MAXICODE,
        ZXing.BarcodeFormat.PDF_417,
        ZXing.BarcodeFormat.QR_CODE,
        ZXing.BarcodeFormat.RSS_14,
        //ZXing.BarcodeFormat.RSS_EXPANDED,
        ZXing.BarcodeFormat.UPC_A,
        ZXing.BarcodeFormat.UPC_E,
        //ZXing.BarcodeFormat.UPC_EAN_EXTENSION,
        /*BARCODEFORMAT :https://zxing.github.io/zxing/apidocs/com/google/zxing/BarcodeFormat.html */
    ];
    const hints = new Map();
    hints.set(ZXing.DecodeHintType.POSSIBLE_FORMATS, formats);
    const codeReader = new ZXing.BrowserMultiFormatReader(hints);
    await codeReader.decodeFromStream(stream, undefined, (response) => {
        if (response != null) {
            console.log("Code result :", response.text);
            callback(response.text);
        } else {
            console.log("No code detected");
        }
    }).catch((err) => console.error(err));
}
