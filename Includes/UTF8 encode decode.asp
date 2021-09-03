<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>Documento sin t�tulo</title>
</head>

<body>



A modo de referencia, os comento que estas funciones para pasar entre juegos de caracteres fueron publicadas originalmente en WebToolkit.info, aunque os recomiendo descargarlas directamente de las librer�as php.js, pues varios contribuidores las han mejorado y han reparado algunos errores que se han detectado.

Este enlace es para acceder a la funci�n JavaScript utf8_decode().
Este otro enlace te llevar� a la funci�n JavaScript utf8_encode().
http://phpjs.org/functions/utf8_decode:576




function utf8_encode (argString) {
    // http://kevin.vanzonneveld.net
    // +   original by: Webtoolkit.info (http://www.webtoolkit.info/)
    // +   improved by: Kevin van Zonneveld (http://kevin.vanzonneveld.net)
    // +   improved by: sowberry
    // +    tweaked by: Jack
    // +   bugfixed by: Onno Marsman
    // +   improved by: Yves Sucaet
    // +   bugfixed by: Onno Marsman
    // +   bugfixed by: Ulrich
    // +   bugfixed by: Rafal Kukawski
    // +   improved by: kirilloid
    // *     example 1: utf8_encode('Kevin van Zonneveld');
    // *     returns 1: 'Kevin van Zonneveld'

    if (argString === null || typeof argString === "undefined") {
        return "";
    }

    var string = (argString + ''); // .replace(/\r\n/g, "\n").replace(/\r/g, "\n");
    var utftext = '',
        start, end, stringl = 0;

    start = end = 0;
    stringl = string.length;
    for (var n = 0; n < stringl; n++) {
        var c1 = string.charCodeAt(n);
        var enc = null;

        if (c1 < 128) {
            end++;
        } else if (c1 > 127 && c1 < 2048) {
            enc = String.fromCharCode((c1 >> 6) | 192, (c1 & 63) | 128);
        } else {
            enc = String.fromCharCode((c1 >> 12) | 224, ((c1 >> 6) & 63) | 128, (c1 & 63) | 128);
        }
        if (enc !== null) {
            if (end > start) {
                utftext += string.slice(start, end);
            }
            utftext += enc;
            start = end = n + 1;
        }
    }

    if (end > start) {
        utftext += string.slice(start, stringl);
    }

    return utftext;
}


function utf8_decode (str_data) {
    // http://kevin.vanzonneveld.net
    // +   original by: Webtoolkit.info (http://www.webtoolkit.info/)
    // +      input by: Aman Gupta
    // +   improved by: Kevin van Zonneveld (http://kevin.vanzonneveld.net)
    // +   improved by: Norman "zEh" Fuchs
    // +   bugfixed by: hitwork
    // +   bugfixed by: Onno Marsman
    // +      input by: Brett Zamir (http://brett-zamir.me)
    // +   bugfixed by: Kevin van Zonneveld (http://kevin.vanzonneveld.net)
    // *     example 1: utf8_decode('Kevin van Zonneveld');
    // *     returns 1: 'Kevin van Zonneveld'
    var tmp_arr = [],
        i = 0,
        ac = 0,
        c1 = 0,
        c2 = 0,
        c3 = 0;

    str_data += '';

    while (i < str_data.length) {
        c1 = str_data.charCodeAt(i);
        if (c1 < 128) {
            tmp_arr[ac++] = String.fromCharCode(c1);
            i++;
        } else if (c1 > 191 && c1 < 224) {
            c2 = str_data.charCodeAt(i + 1);
            tmp_arr[ac++] = String.fromCharCode(((c1 & 31) << 6) | (c2 & 63));
            i += 2;
        } else {
            c2 = str_data.charCodeAt(i + 1);
            c3 = str_data.charCodeAt(i + 2);
            tmp_arr[ac++] = String.fromCharCode(((c1 & 15) << 12) | ((c2 & 63) << 6) | (c3 & 63));
            i += 3;
        }
    }

    return tmp_arr.join('');
}

</body>
</html>
//http://phpjs.org/functions/utf8_decode/
function utf8_decode (utf8) {
    // control characters are left for alignment reasons, they will not be used anyway!
    var i, iso885915 = '', 
    utf8ToIso885915 = {
    'NBSP': '\xA0', '�': '\xA1', '�': '\xA2', '�': '\xA3', '�': '\xA4', '�': '\xA5', '�': '\xA6', '�': '\xA7', 
    '�': '\xA8', '�': '\xA9', '�': '\xAA', '�': '\xAB', '�': '\xAC', 'SHY': '\xAD', '�': '\xAE', '�': '\xAF',
    '�': '\xB0', '�': '\xB1', '�': '\xB2', '�': '\xB3', '�': '\xB4', '�': '\xB5', '�': '\xB6', '�': '\xB7', 
    '�': '\xB8', '�': '\xB9', '�': '\xBA', '�': '\xBB', '�': '\xBC', '�': '\xBD', '�': '\xBE', '�': '\xBF', 
    '�': '\xC0', '�': '\xC1', '�': '\xC2', '�': '\xC3', '�': '\xC4', '�': '\xC5', '�': '\xC6', '�': '\xC7', 
    '�': '\xC8', '�': '\xC9', '�': '\xCA', '�': '\xCB', '�': '\xCC', '�': '\xCD', '�': '\xCE', '�': '\xCF', 
    '�': '\xD0', '�': '\xD1', '�': '\xD2', '�': '\xD3', '�': '\xD4', '�': '\xD5', '�': '\xD6', '�': '\xD7', 
    '�': '\xD8', '�': '\xD9', '�': '\xDA', '�': '\xDB', '�': '\xDC', '�': '\xDD', '�': '\xDE', '�': '\xDF', 
    '�': '\xE0', '�': '\xE1', '�': '\xE2', '�': '\xE3', '�': '\xE4', '�': '\xE5', '�': '\xE6', '�': '\xE7', 
    '�': '\xE8', '�': '\xE9', '�': '\xEA', '�': '\xEB', '�': '\xEC', '�': '\xED', '�': '\xEE', '�': '\xEF', 
    '�': '\xF0', '�': '\xF1', '�': '\xF2', '�': '\xF3', '�': '\xF4', '�': '\xF5', '�': '\xF6', '�': '\xF7', 
    '�': '\xF8', '�': '\xF9', '�': '\xFA', '�': '\xFB', '�': '\xFC', '�': '\xFD', '�': '\xFE', '�': '\xFF'
    }
    
    for (i = 0; i < utf8.length; i++){
        iso885915 += utf8ToIso885915[utf8[i]]? utf8ToIso885915[utf8[i]] : utf8[i];
    }

    return iso885915;
}