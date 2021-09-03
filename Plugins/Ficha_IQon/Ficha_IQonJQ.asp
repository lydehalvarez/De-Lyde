
	var options = { 
        target:        '#Contenido',   // target element(s) to be updated with server response 
        //beforeSubmit:  showRequest,  // pre-submit callback 
        beforeSubmit:  function() { 
        				alert("antes");
                        AntesDelSubmit(); 
                        },  // pre-submit callback 
        //success:       showResponse,  // post-submit callback 
        success: function(){
        	alert("despues"); 
        	DespuesDelSubmit() 
                           },  // post-submit callback 
        error:       showResponse,  // post-submit callback 
        // other available options:  
        url:       '/Plugins/Ficha_IQon/Ficha_IQon.asp'         // override for form's 'action' attribute 
        //type:      'get'        // 'get' or 'post', override for form's 'method' attribute 
        //dataType:  null        // 'xml', 'script', or 'json' (expected server response type) 
        //clearForm: true        // clear all form fields after successful submit 
        //resetForm: true        // reset the form after successful submit 
        
        // $.ajax options can be used here too, for example: 
        //timeout:   3000 
//        beforeSend : function(xhr) {
//            try {
//                //FF & Chrome
//                xhr.overrideMimeType('text/html; charset=iso-8859-1');
//            } catch (e) {
//                //IE8
//                xhr.setRequestHeader("contentType","text/html; charset=iso-8859-1");
//            }
//        }
    }; 
    
  //  //esto es para los malditos acentos
  	$.ajaxSetup({'beforeSend' : function(xhr) {
            try {
                //FF & Chrome
                xhr.overrideMimeType('text/html;charset=iso-8859-1');
            } catch (e) {
                //IE8
                xhr.setRequestHeader('contentType','text/html;charset=iso-8859-1');
            }
        }
	});   

//Para devolver HTML
//
//header("Content-Type: text/html; charset=iso-8859-1");
//Para devolver Javascript
//
//header("Content-type: text/javascript; charset=iso-8859-1");
//Para devolver XML
//
//header('Content-type: text/xml;  charset=iso-8859-1');
//echo "<?xml version="1.0" encoding="ISO-8859-1"?>\n";

//ajaxSetup
    // bind to the form's submit event 
    $('#frmDatos').submit(function() { 
        // inside event callbacks 'this' is the DOM element so we first 
        // wrap it in a jQuery object and then invoke ajaxSubmit 
        $(this).ajaxSubmit(options); 
              
        // !!! Important !!! 
        // always return false to prevent standard browser submit and page navigation 
        return false; 
    });
    
    