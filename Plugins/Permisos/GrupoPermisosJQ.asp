
//UsuarioPermnisosJQ.asp

  var options = { 
        target:        '#Contenido',   // target element(s) to be updated with server response 
        //beforeSubmit:  showRequest,  // pre-submit callback 
        success:       Notifica,  // post-submit callback 
 		//error:       showResponse,  // post-submit callback 
        // other available options:  
        url:       '/Plugins/Permisos/GrupoPermisos.asp'         // override for form's 'action' attribute 
        //type:      type        // 'get' or 'post', override for form's 'method' attribute 
        //dataType:  null        // 'xml', 'script', or 'json' (expected server response type) 
        //clearForm: true        // clear all form fields after successful submit 
        //resetForm: true        // reset the form after successful submit 
 
        // $.ajax options can be used here too, for example: 
        //timeout:   3000 
    }; 
     
  //  //esto es para los malditos acentos
  	$.ajaxSetup({'beforeSend' : function(xhr) {
            try {
                //FF & Chrome
                xhr.overrideMimeType('text/html; charset=iso-8859-1');
            } catch (e) {
                //IE8
                xhr.setRequestHeader("contentType","text/html; charset=iso-8859-1");
            }
        }
	});   

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