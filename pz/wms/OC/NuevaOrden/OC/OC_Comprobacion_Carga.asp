<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%> 
<!--#include file="../../../Includes/iqon.asp" -->
<%	
	
	var Prov_ID = Parametro("Prov_ID",-1)
	var OC_ID = Parametro("OC_ID",-1)
	var Pro_ID = Parametro("Pro_ID",0)
	var Usu_ID = Parametro("IDUsuario",-1)
	var Doc_ID = 7  // ParametroDeVentana(SistemaActual, VentanaIndex, "Tipo Documento", 1)
	//  TipoDoc 7 = factura, 16 Prueba de recepcion de mercancia, 18 pago
	var Docs_ID = Parametro("Docs_ID",-1)

	
%>
<style type="text/css">
	.espaciobtn{
		margin:0px 15px;
	}

	.textarea {
		width: 100%;
		height: auto;
		overflow-x: scroll;
		overflow-y: scroll;
		display: block;
		border: 1px solid black;
		padding: 5px;
		margin: 5px;
	}
	.formatted {
		width: 100%;
		height: auto;
		overflow-x: scroll;
		overflow-y: scroll;
		display: block;
		border: 1px solid black;
		padding: 5px;
		margin: 5px;
	}
	
</style>
<div class="ibox">


    <div class="ibox-content">
        <div class="table-responsive">
            <table class="table" width="100%">
                <tbody>
                    <tr style="width: 80%;text-align: left;">
                        <td width="90">
                            <div class="cart-product-imitation"></div>
                        </td>
                        <td>
                           <table width="100%" border="0" cellspacing="0" cellpadding="0">
                              <tr>
                                <td><h3><a class="text-navy" href="#">Nuevo documento</a></h3></td>
                              </tr>
                              <tr>
                                <td>
                                	<p>Se debe subir el archivo XML y el PDF que forman el par</p>
                                </td>
                              </tr>
                              <tr>
                                <td>&nbsp;</td>
                              </tr>
                              <tr>
                                <td>
            <div class="fileinput fileinput-new input-group" data-provides="fileinput">
                <div class="form-control" data-trigger="fileinput">
                    <i class="glyphicon glyphicon-file fileinput-exists"></i>
                <span class="fileinput-filename"></span>
                </div>
                <span class="input-group-addon btn btn-default btn-file">
                    <span class="fileinput-new">Seleccionar</span>
                    <span class="fileinput-exists">Cambiar</span>
                    <input type="file" name="file" id="file" > 
                </span>
                <a href="#" class="input-group-addon btn btn-default fileinput-exists" 
                   data-dismiss="fileinput">Quitar</a>
                <a href="#" class="input-group-addon btn btn-default fileinput-exists cargasvr" >Cargar</a>
                   <br />
            </div> 
                                </td>
                              </tr>
                            </table>

                        </td>
                    </tr>
                </tbody>
            </table>
        </div>
        
            <div class="form-group">       
                <div class="col-sm-12" style="text-align:center">	 
                	<img id="Preview" src="#" alt="vista previa" style="display:none"/>
                </div> 
            </div>
            <div class="form-group">               
                <div class="col-sm-12" style="text-align:center">	
                	<iframe id="PreviewPDF" frameborder="0" scrolling="no" width="650" height="1100" style="display:none"></iframe>
                </div>        
            </div> 
        
    </div>
    <div class="ibox-content">
        <div class="table-responsive">
            <table class="table" width="100%">
                <tbody>
                    <tr style="width: 80%;text-align: left;">
                        <td width="90">
                            <i class="fa fa-file-code-o fa-5x"></i>
                        </td>
                        <td>
                            <h3><a class="text-navy" href="#">Archivo XML</a></h3>
                            <p class="small">Nombre del archivo:</p>
                            <dl class="small m-b-none">
                                <dt>Estatus</dt>
                                <dd>Proveedor nuevo</dd>
                                <dd>Destinatario correcto</dd>
                                <dd>Validaci&oacute;n con el SAT Correcta</dd>
                            </dl>
                            <div class="m-t-sm">
                                <a class="text-muted" href="#"><i class="fa fa-file-code-o"></i> vista previa</a> | <a class="text-muted" href="#"><i class="fa fa-trash"></i> Borrar</a>
                            </div>
                        </td>
                    </tr>
                </tbody>
            </table>
        </div>
    </div>
    <div class="ibox-content">
        <div class="table-responsive">
            <table class="table" width="100%">
                <tbody>
                    <tr style="width: 80%;text-align: left;">
                        <td width="90">
                            <i class="fa fa-file-pdf-o fa-5x"></i>
                        </td>
                        <td>
                            <h3><a class="text-navy" href="#">Archivo PDF</a></h3>
                            <p class="small">Nombre del archivo:</p>
                            <dl class="small m-b-none">
                                <dt>Estatus</dt>
                                <dd>Cargado correctamente</dd>
                            </dl>
                            <div class="m-t-sm">
                                <a class="text-muted" href="#"><i class="fa fa-file-pdf-o"></i> Vista previa</a> | <a class="text-muted" href="#"><i class="fa fa-trash"></i> Borrar</a>
                            </div>
                        </td>
                    </tr>
                </tbody>
            </table>
        </div>
    </div>
</div>
<input type="hidden" name="Docs_Nombre" id="Docs_Nombre" value=""> 
<input type="hidden" name="Docs_ID" id="Docs_ID" value="<%=Docs_ID%>"> 
<script type="text/javascript">

$(document).ready(function() {
	
	$(".cargasvr").click(function(e) {
        e.preventDefault()
		SubeArchivo()
    });
	
	$("#file").change(function(){

		if($("#file").val() != "") {
			//alert("Existe archivo!!!!");
			var fileName = this.files[0].name;
				fileName = fileName.toLowerCase();
			var EsPDF = fileName.search(".pdf");
			console.log("224) EsPDF " + EsPDF)
			var fileSize = this.files[0].size;
			var fileType = this.files[0].type;
			//alert('FileName : ' + fileName + '\nFileSize : ' + fileSize + ' bytes' + '\nfileType : ' + fileType);
            var msg = "File Name: " + this.files[0].name + "<br>" + "File Size: " + this.files[0].size + "<br>" + "File Type: " + this.files[0].type;
            //console.log(msg);
			if (checkfile(fileName)) {
				//$('#btnSubir').show("slow");
				//$('#BotonesSinDocumento').show("slow");
				fileName = QuitaAcentos(fileName); 
				// Quitamos espacios y los sustituimos por _ 
                fileName = fileName.replace(/ /g,"_"); 
				fileName = QuitaCaracteresEspeciales(fileName);	
				console.log("234) nombre archivo " + 	fileName)				
				$("#Docs_Nombre").val(fileName);				
				CargaVistaPrevia(this, EsPDF);
			}
	
		} else {
			//alert("No Existe archivo!!!!");
			//$('#btnSubir').hide("slow");
			$("#Docs_Nombre").val("");
			$("#PreviewPDF").val("");
			$("#PreviewPDF").hide("slow");			
			CargaVistaPrevia(this, false);			
		}
		
	});
	
});


function SubeArchivo() {
	 
	$(".cargasvr").hide("slow");
	
	var sMensaje= "Espera un momento, el archivo esta transfiriendose y puede tardar un poco";
	Avisa("success","Guardar Archivo",sMensaje)
	
	if($("#Docs_ID").val() > -1) {
		CargaArchivoAlServidor()	
	} else {		
		$.post( "/pz/fnd/Tesoreria/Ajax.asp"
		      , { Tarea:13,Prov_ID:<%=Prov_ID%>,OC_ID:<%=OC_ID%>,Doc_ID:7}
		      , function(id){
				  $("#Docs_ID").val(id)
			 	  CargaArchivoAlServidor()
			  });
	}
		
}


function CargaArchivoAlServidor() {			

	var sRutaArch = "/Media/aura/OrdenCompra/";	
					
	var sDatos = "llaves=<%=OC_ID%>_7_" + $("#Docs_ID").val();
		sDatos += "&Ruta=OrdenCompra";	
		sDatos += "&NombreArchivo=" + $("#Docs_Nombre").val();	
		
	var fileInput = document.getElementById('file');
	var file = fileInput.files[0];
	var fdDatos = new FormData();
	fdDatos.append('file', file);

	$.ajax({
		//url: "/pz/fnd/Tesoreria/uploadAccPagos.asp",
		url: "/pz/fnd/Tesoreria/uploadAcc.asp?"+sDatos,
		data: fdDatos,
		cache: false,
		contentType: 'multipart/form-data',
		processData: false,
		type:"POST",
		success: function(data) {

					var sNomArch = "";
					var sTmp = String(data);
					var arrDatos = new Array();
					arrDatos = sTmp.split("|");
				
					if (arrDatos[0] == "OK") { 
						var sMensaje= "El archivo fue colocado en el servidor satisfactoriamente.";
						Avisa("success","Guardar Archivo",sMensaje)
						
						$("#Docs_Nombre").val(arrDatos[1]);
						GuardarABDNombreArchivo(sRutaArch, arrDatos[1]);
						CargaResumenDeArchivos();
					} else {
						var sMensaje = "Sucedio un error al colocar el archivo en el servidor"
						    sMensaje += ", favor de avisar a su administrador. <br> " + data;
	                	Avisa("error","Guardar Archivo",sMensaje)
					}
				  },  
		error: function(XMLHttpRequest, textStatus, errorThrown) {
			if(XMLHttpRequest.readyState == 0 || XMLHttpRequest.status == 0) {
              alert(" it's not really an error");
			} else {
				if (XMLHttpRequest.status == 500) {
					alert("Error HTTP 500 Internal server error (Error interno del servidor)");
				} else {
					alert(textStatus);
					alert("525) Error " + errorThrown);
				}
			}
		}	
							
	});

}	


function checkfile(fileExt) {
    var validExts = new Array('.gif', '.jpg', '.png', '.jpeg', '.pdf', '.xml');
    //var fileExt = sender.value;
	fileExt = fileExt.toLowerCase();
    fileExt = fileExt.substring(fileExt.lastIndexOf('.'));
    if (validExts.indexOf(fileExt) < 0) {
      alert("No es un archivo valido, solo se pueden colocar los siguientes tipos de archivo " + validExts.toString() + " ");
      return false;
    }
    else {
		return true;
	}
}

function CargaVistaPrevia(input,epdf) {
	if (input.files && input.files[0]) {
		var reader = new FileReader();

		reader.onload = function (e) {
			if(epdf ==0) {
				$('#PreviewPDF').attr('src','#');
				$('#PreviewPDF').hide();				
				$('#Preview').attr('src', e.target.result);
				$('#Preview').show("slow");
			} else {
				$('#Preview').attr('src','#');
				$('#Preview').hide();
				var pdffile = input.files[0]
				var pdffile_url=URL.createObjectURL(pdffile);
				$('#PreviewPDF').attr('src',pdffile_url);
				$('#PreviewPDF').show("slow");
			}
		}
		
		reader.readAsDataURL(input.files[0]);
	}
}


function GuardarABDNombreArchivo(sjsRutaArch, sNomArchivo) {

	$.post("/pz/fnd/Tesoreria/Ajax.asp"
	      , { Tarea:12,Prov_ID:<%=Prov_ID%>,OC_ID:<%=OC_ID%>,Doc_ID:7,Docs_ID:$("#Docs_ID").val()   
			 ,Docs_Nombre:sNomArchivo,Docs_RutaArchivo:sjsRutaArch,Usu_ID:$("#IDUsuario").val()}
		  , function(msg){
			  if (msg == "OK" ) {
					var sMensaje = "El archivo fue guardado en la base de datos correctamente.";
	                Avisa("success","Guardar Archivo",sMensaje)
					$('#PreviewPDF').attr('src','#');
					$('#PreviewPDF').hide();				
					$('#Preview').attr('src','#');
					$('#Preview').hide();
			  } else {
			  	var sMensaje  = "Sucedio un error al guardar el nombre  del archivo en la base de datos"
				    sMensaje += ", favor de avisar a su administrador";
	            Avisa("error","Guardar Archivo",sMensaje)
			  }
			  
	});
 
} 
 
	
function QuitaCaracteresEspeciales(str){
   // Definimos los caracteres que queremos eliminar
   var specialChars = "!@#$^\´\¨¬\~\'&%*+=-\/{}|:<>?,";

   // Los eliminamos todos
   for (var i = 0; i < specialChars.length; i++) {
       str= str.replace(new RegExp("\\" + specialChars[i], 'gi'), '');
   }  

	return str;   
}	
	
function QuitaAcentos(str) {

  var defaultDiacriticsRemovalMap = [
    {'base':'A', 'letters':/[\u0041\u24B6\uFF21\u00C0\u00C1\u00C2\u1EA6\u1EA4\u1EAA\u1EA8\u00C3\u0100\u0102\u1EB0\u1EAE\u1EB4\u1EB2\u0226\u01E0\u00C4\u01DE\u1EA2\u00C5\u01FA\u01CD\u0200\u0202\u1EA0\u1EAC\u1EB6\u1E00\u0104\u023A\u2C6F]/g},
    {'base':'E', 'letters':/[\u0045\u24BA\uFF25\u00C8\u00C9\u00CA\u1EC0\u1EBE\u1EC4\u1EC2\u1EBC\u0112\u1E14\u1E16\u0114\u0116\u00CB\u1EBA\u011A\u0204\u0206\u1EB8\u1EC6\u0228\u1E1C\u0118\u1E18\u1E1A\u0190\u018E]/g},
    {'base':'I', 'letters':/[\u0049\u24BE\uFF29\u00CC\u00CD\u00CE\u0128\u012A\u012C\u0130\u00CF\u1E2E\u1EC8\u01CF\u0208\u020A\u1ECA\u012E\u1E2C\u0197]/g},
    {'base':'N', 'letters':/[\u004E\u24C3\uFF2E\u01F8\u0143\u00D1\u1E44\u0147\u1E46\u0145\u1E4A\u1E48\u0220\u019D\uA790\uA7A4]/g},
    {'base':'O', 'letters':/[\u004F\u24C4\uFF2F\u00D2\u00D3\u00D4\u1ED2\u1ED0\u1ED6\u1ED4\u00D5\u1E4C\u022C\u1E4E\u014C\u1E50\u1E52\u014E\u022E\u0230\u00D6\u022A\u1ECE\u0150\u01D1\u020C\u020E\u01A0\u1EDC\u1EDA\u1EE0\u1EDE\u1EE2\u1ECC\u1ED8\u01EA\u01EC\u00D8\u01FE\u0186\u019F\uA74A\uA74C]/g},
    {'base':'U', 'letters':/[\u0055\u24CA\uFF35\u00D9\u00DA\u00DB\u0168\u1E78\u016A\u1E7A\u016C\u00DC\u01DB\u01D7\u01D5\u01D9\u1EE6\u016E\u0170\u01D3\u0214\u0216\u01AF\u1EEA\u1EE8\u1EEE\u1EEC\u1EF0\u1EE4\u1E72\u0172\u1E76\u1E74\u0244]/g},
    {'base':'a', 'letters':/[\u0061\u24D0\uFF41\u1E9A\u00E0\u00E1\u00E2\u1EA7\u1EA5\u1EAB\u1EA9\u00E3\u0101\u0103\u1EB1\u1EAF\u1EB5\u1EB3\u0227\u01E1\u00E4\u01DF\u1EA3\u00E5\u01FB\u01CE\u0201\u0203\u1EA1\u1EAD\u1EB7\u1E01\u0105\u2C65\u0250]/g},
    {'base':'e', 'letters':/[\u0065\u24D4\uFF45\u00E8\u00E9\u00EA\u1EC1\u1EBF\u1EC5\u1EC3\u1EBD\u0113\u1E15\u1E17\u0115\u0117\u00EB\u1EBB\u011B\u0205\u0207\u1EB9\u1EC7\u0229\u1E1D\u0119\u1E19\u1E1B\u0247\u025B\u01DD]/g},
    {'base':'i', 'letters':/[\u0069\u24D8\uFF49\u00EC\u00ED\u00EE\u0129\u012B\u012D\u00EF\u1E2F\u1EC9\u01D0\u0209\u020B\u1ECB\u012F\u1E2D\u0268\u0131]/g},
    {'base':'n', 'letters':/[\u006E\u24DD\uFF4E\u01F9\u0144\u00F1\u1E45\u0148\u1E47\u0146\u1E4B\u1E49\u019E\u0272\u0149\uA791\uA7A5]/g},
    {'base':'o', 'letters':/[\u006F\u24DE\uFF4F\u00F2\u00F3\u00F4\u1ED3\u1ED1\u1ED7\u1ED5\u00F5\u1E4D\u022D\u1E4F\u014D\u1E51\u1E53\u014F\u022F\u0231\u00F6\u022B\u1ECF\u0151\u01D2\u020D\u020F\u01A1\u1EDD\u1EDB\u1EE1\u1EDF\u1EE3\u1ECD\u1ED9\u01EB\u01ED\u00F8\u01FF\u0254\uA74B\uA74D\u0275]/g},
    {'base':'u','letters':/[\u0075\u24E4\uFF55\u00F9\u00FA\u00FB\u0169\u1E79\u016B\u1E7B\u016D\u00FC\u01DC\u01D8\u01D6\u01DA\u1EE7\u016F\u0171\u01D4\u0215\u0217\u01B0\u1EEB\u1EE9\u1EEF\u1EED\u1EF1\u1EE5\u1E73\u0173\u1E77\u1E75\u0289]/g}
  ];

  for(var i=0; i<defaultDiacriticsRemovalMap.length; i++) {
    str = str.replace(defaultDiacriticsRemovalMap[i].letters, defaultDiacriticsRemovalMap[i].base);
  }

  return str;

}
		

</script>

