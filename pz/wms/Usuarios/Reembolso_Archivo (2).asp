<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%> 
<!--#include file="../../../Includes/iqon.asp" -->
<%	

var Emp_ID = Parametro("Emp_ID",-1)
var ERmb_ID = Parametro("ERmb_ID",-1)
var Usu_ID = Parametro("IDUsuario",-1)
var Doc_ID = Parametro("Doc_ID",7)
var Docs_ID = Parametro("Docs_ID",-1)
//  TipoDoc   7 = factura, 16 Prueba de recepcion de mercancia, 18 pago

var DetDescripcion = ""
var EsXML = false
var EstatusCSS = "" 
var ERmb_EstatusCG90 = 0
var ERmb_Folio = ""
 
 var sSQL  = " SELECT * "
	 sSQL += " ,dbo.fn_CatGral_DameDato(90,ERmb_EstatusCG90) as Estatus "
	 sSQL += " FROM Empleado_Reembolso " 
	 sSQL += " WHERE Emp_ID = " + Emp_ID
	 sSQL += " AND ERmb_ID = " + ERmb_ID
	  
var rsReembolso = AbreTabla(sSQL,1,0)
  if (!rsReembolso.EOF){
	  DetDescripcion = rsReembolso.Fields.Item("ERmb_Descripcion").Value	  
	  Estatus = rsReembolso.Fields.Item("Estatus").Value
	  ERmb_EstatusCG90 = rsReembolso.Fields.Item("ERmb_EstatusCG90").Value	  
	  ERmb_Folio = rsReembolso.Fields.Item("ERmb_Folio").Value
	  if(ERmb_EstatusCG90 == 1 ) {
	  	EstatusCSS = " label-primary "
      }
	  if(ERmb_EstatusCG90 == 2 ) {
	  	EstatusCSS = " label-success "
      } 	
	  if(ERmb_EstatusCG90 == 3 ) {
	  	EstatusCSS = " label-plain "
      }	  
  }
 rsReembolso.Close() 
 
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
<%
var sRuta = ""
var Docs_Nombre = ""
var Cargado = 0
var sObs = ""
var Docs_Titulo = ""
var Cob_EsUnCFDI = 0
var Docs_FechaRegistro = ""


 var sSQL  = " SELECT * "
	 sSQL += " FROM Empleado_Reembolso_Documentos " 
	 sSQL += " WHERE Emp_ID = " + Emp_ID
	 sSQL += " AND ERmb_ID = " + ERmb_ID 
	 sSQL += " AND Doc_ID = " + Doc_ID	
	 sSQL += " AND Docs_ID = " + Docs_ID		  
  
 var rsArchivos = AbreTabla(sSQL,1,0)
 if (!rsArchivos.EOF){
   Llaves = rsArchivos.Fields.Item("Doc_ID").Value  
   Llaves += "," + rsArchivos.Fields.Item("Docs_ID").Value  
   sRuta = rsArchivos.Fields.Item("Docs_RutaArchivo").Value 
   Docs_Nombre = rsArchivos.Fields.Item("Docs_Nombre").Value 
   Docs_Titulo = rsArchivos.Fields.Item("Docs_Titulo").Value       
   Cob_EsUnCFDI = rsArchivos.Fields.Item("Docs_EsUnCFDI").Value
   sObs = rsArchivos.Fields.Item("Docs_Observaciones").Value   
   Docs_FechaRegistro = rsArchivos.Fields.Item("Docs_FechaRegistro").Value 
%>
<div class="row">             
	<div class="ibox">
		<div class="ibox-content">
	    	<div class="row">
                <div class="col-lg-12">
                    <div class="m-b-md">
                         <h2><%=Docs_Titulo%></h2> 
                         <p><%=DetDescripcion%></p>
                         <p><%=sObs%></h2>
                    </div>
                    <dl class="dl-horizontal">
                        <dt>Estatus:</dt> <dd><span class="label <%=EstatusCSS%>"><%=Estatus%></span></dd>
                    </dl>
                </div>
            </div>
            <div class="row">
                <div class="col-lg-12">
                    <dl class="dl-horizontal">
                        <dt>Folio:</dt> <dd><%=ERmb_Folio%></dd>
                         
                        <dt>Fecha de carga:</dt> <dd><%=Docs_FechaRegistro%></dd>
                        <dt>Nombre del archivo:</dt> <dd><%=Docs_Nombre%></dd>
                      
                    </dl>
                </div>              
            </div>
            <div class="row">
				<div class="col-lg-12" style="text-align:center">    
<%   
    
   var aPosition = Docs_Nombre.indexOf(".pdf");
	if(aPosition > -1) {
		Response.Write("<embed src='" + sRuta + Docs_Nombre + "#toolbar=0' width='100%' height='1000' >")
	} else if (Docs_Nombre.indexOf(".xml") > -1) {
		EsXML = true
		 %>
		<div class="form-group">       
        <div class="col-sm-12">	
            <div align="center">
                <h1>Archivo XML <%=Docs_Nombre%></h1>
            </div>
        </div> 
        <div class="col-sm-12">	
        	<pre class="info"></pre>
            <div id="xmlfile" align="left">
				<pre class="formatted"></pre>
            </div>
        </div>          
               
    </div>

<script type="text/javascript" src="/js/vkbeautify.0.99.00.beta.js"></script>

<%	} else {	
		Response.Write("<img src='"+sRuta+Docs_Nombre+"' border='0'>")  
	}	
%>  
           </div></div>
    </div>
   </div>
  </div>
   
<%  } else {   %>
        <div class="row">
          <div class="col-md-2"><h4>T&iacute;tulo</h4></div>
            <div class="col-md-8"><% 
                if (Cargado == 1) { 
                Response.Write("<h4>"+sTitulo+"</h4>")
                } else { %>
                <input type="text" class="form-control arTexto" id="Docs_Titulo" name="Docs_Titulo" placeholder="Titulo">
                <% } %><br />
          </div>
        </div>
        
<% if(Doc_ID==7){  %>    
        <div class="row">
          <div class="col-md-2"><h4>Folio Factura</h4></div>
            <div class="col-md-8"><% 
                if (Cargado == 1) { 
                Response.Write("<h4>"+ERmb_Folio+"</h4>")
                } else { %>
                <input type="text" class="form-control arTexto" id="ERmb_Folio" name="ERmb_Folio" placeholder="Folio de la factura">
                <% } %><br />
          </div>
        </div>        
         
                
         <br />
<% } %>      
        
        <div class="row">
            <div class="col-md-2"><h4>Observaciones</h4></div>
            <div class="col-md-8"><% 
                if (Cargado == 1) { 
                Response.Write("<h4>"+sObs+"</h4>")
                } else { %>
                <textarea class="form-control arTexto" id="Docs_Observaciones" name="Docs_Observaciones" placeholder="Observaciones"></textarea>
                <% } %><br />
            </div>
        </div>

        <div class="row">
         <div class="col-md-2"><h4>Archivo a cargar</h4></div>
          <div class="col-md-8">
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
            </div>
		</div> 

        <div class="row">
            <div class="form-group">       
                <div class="col-sm-12" style="text-align:center">	 
                	<img id="Preview" src="#" alt="vista previa" style="display:none"/>
                    <div id="PreviewXML" style="display:none"></div>
                </div> 
            </div>
            <div class="form-group">               
                <div class="col-sm-12" style="text-align:center">	
                	<iframe id="PreviewPDF" frameborder="0" scrolling="no" width="800" height="1100" style="display:none"></iframe>
                </div>        
            </div>   
        </div> 
			<div id="dvArchivoSubido"></div>

           </div></div>
    </div>
   </div>
  </div> 

<%  
  }
%>
<input type="hidden" name="Docs_Nombre" id="Docs_Nombre" value="<%=Docs_Nombre%>"> 
<input type="hidden" name="Docs_ID" id="Docs_ID" value="<%=Docs_ID%>"> 

<!-- script src="js/plugins/iCheck/icheck.min.js"></script  -->
        
<script type="text/javascript">

$(document).ready(function() {
	
	$("#file").change(function(){
		console.log("218) " +  $("#file").val() );
		if($("#file").val() != "") {
			//alert("Existe archivo!!!!");
			var fileName = this.files[0].name;
				fileName = fileName.toLowerCase();
			var EsPDF = fileName.search(".pdf");
			var EsXML = fileName.search(".xml");			
			console.log("224) EsPDF " + EsPDF)
			console.log("224) EsXML " + EsXML)			
			var fileSize = this.files[0].size;
			var fileType = this.files[0].type;
			//alert('FileName : ' + fileName + '\nFileSize : ' + fileSize + ' bytes' + '\nfileType : ' + fileType);			
			if (checkfile(fileName)) {
				//$('#btnSubir').show("slow");
				//$('#BotonesSinDocumento').show("slow");
				fileName = QuitaAcentos(fileName); 
				// Quitamos espacios y los sustituimos por _ 
                fileName = fileName.replace(/ /g,"_"); 
				fileName = QuitaCaracteresEspeciales(fileName);	
				console.log("234) nombre archivo " + 	fileName)				
				$("#Docs_Nombre").val(fileName);				
				CargaVistaPrevia(this, EsPDF,EsXML);
			}
	
		} else {
			//alert("No Existe archivo!!!!");
			//$('#btnSubir').hide("slow");
			$("#Docs_Nombre").val("");
			$("#PreviewPDF").val("");
			$("#PreviewPDF").hide("slow");			
			//CargaVistaPrevia(this, false);			
		}
		
	});
	
	$(".cargasvr").click(function(e) {
        e.preventDefault()
		SubeArchivo()
    });
	
		
	$(".arTexto").blur(function(e) {
        e.preventDefault()
		ActualizaDatos()
    });
	
		
		//$('input').iCheck('check'); 
		//$('input').iCheck('uncheck'); 
		
		//$(this).iCheck('update');  //cuando cambias el valor del check a mano y no usas el app
		//$('#checkBox').is(':checked')

		//$('#id1').iCheck('uncheck'); //To uncheck the radio button
//		$('#id1').iCheck('check'); //To check the radio button


//checked
//$('#id-checkbox').prop('checked',true).iCheck('update');
//
//unchecked
//$('#id-checkbox').prop('checked',false).iCheck('update');

//All callbacks and functions are documented here: http://fronteed.com/iCheck/#usage
//$('input').iCheck('check'); — change input's state to checked
//$('input').iCheck('uncheck'); — remove checked state
//$('input').iCheck('toggle'); — toggle checked state
//$('input').iCheck('disable'); — change input's state to disabled
//$('input').iCheck('enable'); — remove disabled state
//$('input').iCheck('indeterminate'); — change input's state to indeterminate
//$('input').iCheck('determinate'); — remove indeterminate state
//$('input').iCheck('update'); — apply input changes, which were done outside the plugin
//$('input').iCheck('destroy'); — remove all traces of iCheck	
	
	
	$('.i-checks').iCheck({
		checkboxClass: 'icheckbox_square-green',
		radioClass: 'iradio_square-green'
	});
	
	
	//                ifUnchecked, ifChecked, ifChanged	
//	$('.i-checks').on('ifChecked', function(event) {
//		//if (event.target.checked) {
//		console.log('checked = ' + event.target.checked);
//		console.log('value = ' + event.target.value);
//		//}
//	});
//	$('.i-checks').on('ifChanged', function(event) {
//		if (event.target.checked == true) {
//		console.log('checked = ' + event.target.checked);
//		console.log('value = ' + event.target.value);
//		}
//		console.log('evento = ' + event.type);
//	 
//	});	
	
	
//	$('input').on('ifChecked', function(event){
//	  console.log(event.type + ' callback');
//	});

			 
});
 
 
// function boton(){
//	 
//	 console.log("seleccionado = " + $("input[type='radio']:checked").val()   )
//	 console.log("otra opcion = " + $("input[name='Qpg']:checked").val()   )
// }

function SubeArchivo() {
	 
	$(".cargasvr").hide("slow");
	
	var sMensaje= "Espera un momento, el archivo esta transfiriendose y puede tardar un poco";
	Avisa("success","Guardar Archivo",sMensaje)
	
	if($("#Docs_ID").val() > -1) {
		CargaArchivoAlServidor()	
	} else {	
		$.post( "/pz/agt/Usuarios/Usuarios_Ajax.asp"
		      , { Tarea:14,Emp_ID:$("#Emp_ID").val(),ERmb_ID:$("#ERmb_ID").val(),Doc_ID:$("#Doc_ID").val()}
		      , function(id){
				  $("#Docs_ID").val(id)
			 	  CargaArchivoAlServidor()
			  });
	}
		
}

function CargaArchivoAlServidor() {			

	var sRutaArch = "/Media/agt/EmpReembolso/";	
					
	var sDatos = "llaves=" + $("#Emp_ID").val() + "_" + $("#ERmb_ID").val() + "_" + $("#Doc_ID").val() + "_" + $("#Docs_ID").val();
		sDatos += "&Ruta=/agt/EmpReembolso/";	
		sDatos += "&NombreArchivo=" + $("#Docs_Nombre").val();				
	
		
	//console.log("292) sDatos " + sDatos) 			
// **********   forma 1    ***************************************	 
//	var data = new FormData();
//	jQuery.each($("#file")[0].files, function(i, file) {
//		data.append('file-'+i, file);
//	});
// **********   forma 2    ***************************************	 este es el que jala	
//	var formElement = document.getElementById("file");
//	var fdDatos = new FormData();    
//	fdDatos.append("file", formElement.files[0]);


	var fileInput = document.getElementById('file');
	var file = fileInput.files[0];
	var fdDatos = new FormData();
	fdDatos.append('file', file);
////	data.append('Fon_ID', $("#Fon_ID").val());	
////	data.append('Con_ID', $("#Con_ID").val());	
////	data.append('Cob_ID', $("#Cob_ID").val());	
////	data.append('CobD_ID', $("#CobD_ID").val());
////	data.append('Docs_Nombre', $("#Docs_Nombre").val());

// **********   forma 3    ***************************************	
//		var elemento= $("#file");
//		if(elemento.val() !== ''){
//		  for(var i=0; i< $('#'+elemento.id).prop("files").length; i++){
//			  nuevoFormulario.append(elemento.name, $('#'+elemento.id).prop("files")[i]);
//		   }
//		}  

// **********   forma 4    ***************************************	
//if (window.File && window.FileReader && window.FileList && window.Blob) {
//    //alert('Great success! All the File APIs are supported.'); 
// 	var data = new FormData();
//	var file = document.querySelector('input[type=file]').files[0];
//	var reader  = new FileReader();
//	var content = reader.readAsDataURL(file);
//	var archivoBlob = new Blob([content], { type: "text/xml"}); 
//	data.append("file", archivoBlob); 
//} else {
//  //alert('The File APIs are not fully supported in this browser.');
//}			

	
//	//Aquí capturas el fileInput seleccionado por el usuario
//	data.append("archivoDelUsuario", fileInputElement.files[0]);
//	 //creamos un archivo tipo blob
//  var content = '<a id="a"><b id="b">hey!</b></a>'; // the body of the new file...
//	var archivoBlob = new Blob([content], { type: "text/xml"}); 
//	//listo agregamos el archivo
//	data.append("elArchivo", archivoBlob); 


	$.ajax({
		//url: "/pz/fnd/Tesoreria/uploadAccPagos.asp",
		url: "/pz/agt/Usuarios/uploadAcc.asp?"+sDatos,
		data: fdDatos,
		cache: false,
		contentType: 'multipart/form-data',
		processData: false,
		type:"POST",
		success: function(data) {
			//console.log("317) data " + data )
					var sNomArch = "";
					var sTmp = String(data);
					var arrDatos = new Array();
					arrDatos = sTmp.split("|");
			//console.log("322) arrDatos[0] " + arrDatos[0] )					
					if (arrDatos[0] == "OK") { 
					//$('#SubirArchivo').hide("slow");

					var sMensaje= "El archivo fue colocado en el servidor satisfactoriamente.";
	                Avisa("success","Guardar Archivo",sMensaje)
					
							$("#Docs_Nombre").val(arrDatos[1]);
							GuardarABDNombreArchivo(sRutaArch, arrDatos[1]);
							CargaResumenDeArchivos($("#Doc_ID").val(), $("#Docs_ID").val());
							//CargaDocumento($("#Doc_ID").val(), $("#Docs_ID").val())
//							sNomArch = String(arrDatos[1]);
//							var aPosition = sNomArch.indexOf(".pdf");
//							
//	if(aPosition > -1) {
//		$("#dvArchivoSubido").append($('<embed>')
//										.attr('src', sRutaArch + sNomArch+'#toolbar=0')
//										.attr('width','940')
//										.attr('height','1000')
//									)
//	} else { 
//		$("#dvArchivoSubido").append($('<img>')
//										.attr('src', sRutaArch + sNomArch)
//										.attr('border','0')
//									)
//	}
//							var sMensaje= "Si el archivo es de su agrado por favor guardelo";
//							$.jGrowl(sMensaje, { header: 'Guardar Archivo', sticky: false, life: 7000, glue:'before'});	
						
						//$('#BotonesSinDocumento').hide();
						//$('#BotonesConDocumento').show("slow");
						//$("#MuestraArchivo").show("slow");
						
					} else {
						var sMensaje= "Sucedio un error al colocar el archivo en el servidor, favor de avisar a su administrador. <br> " + data;
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

function ActualizaDatos(){
 
}

function GuardarABDNombreArchivo(sjsRutaArch, sNomArchivo) {
			
	$.post("/pz/agt/Usuarios/Usuarios_Ajax.asp", { Tarea:15,Emp_ID:$("#Emp_ID").val()
			 ,ERmb_ID:$("#ERmb_ID").val(),Doc_ID:$("#Doc_ID").val(),Docs_ID:$("#Docs_ID").val()
<% if(Doc_ID==7){  %>  ,ERmb_Folio:$("#ERmb_Folio").val() <% }  %>    
			 ,Docs_Nombre:sNomArchivo,Docs_RutaArchivo:sjsRutaArch,Usu_ID:$("#IDUsuario").val()
			 ,Docs_Titulo:$("#Docs_Titulo").val(),Docs_Observaciones:$("#Docs_Observaciones").val()}
		  , function(msg){
			  if (msg == "OK" ) {
					var sMensaje= "El archivo fue guardado en la base de datos correctamente.";
	                Avisa("success","Guardar Archivo",sMensaje)
			  } else {
			  	var sMensaje= "Sucedio un error al guardar el nombre  del archivo en la base de datos, favor de avisar a su administrador";
	                	Avisa("error","Guardar Archivo",sMensaje)
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

function CargaVistaPrevia(input,epdf,exml) {
	
	if (input.files && input.files[0]) {
		var reader = new FileReader();
	
		reader.onload = function (e) {
			if(epdf > 0) {
				$('#Preview').attr('src','#');
				$('#Preview').hide();
				var pdffile = input.files[0]
				var pdffile_url=URL.createObjectURL(pdffile);
				$('#PreviewPDF').attr('src',pdffile_url);
				$('#PreviewPDF').show("slow");				
			} else if(exml > 0) {
				//var xml_neat = formatXml(input.files[0]);
				var xml_neat = e.target.result;
				//xml_neat = xml_neat.toString('base64')
				xml_neat = formatXml(xml_neat)
			    $('#PreviewXML').text(xml_neat).toString('base64');
				$('#PreviewXML').show("slow");
			} else {	
                $('#PreviewPDF').attr('src','#');
				$('#PreviewPDF').hide();				
				$('#Preview').attr('src', e.target.result);
				$('#Preview').show("slow");
			}
			
			
			
		}
		
		reader.readAsDataURL(input.files[0]);
	}
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

<% if (EsXML) { %>

 $(function(){
	
	var url = "<%=sRuta%><%=Docs_Nombre%>";

	$.ajax({
		url: url,
		dataType:"text",
	   // beforeSend:function(){
	   //     $('.info').append($('<p>requesting '+url+'</p>'));
	   //     $('.info').append($('<p>and formatting the response!'));
	   // },
		error:function(){$('.info').append($('<p>error! '+url+'</p>'));},
		success: function(data) {
			xml_neat = formatXml(data);
			$('.formatted').text(xml_neat);
		}
	});
});
			
<% } %>

			
function formatXml(xml) {
	var formatted = '';
	var reg = /(>)(<)(\/*)/g;
	xml = xml.replace(reg, '$1\r\n$2$3');
	var pad = 0;
	jQuery.each(xml.split('\r\n'), function(index, node)
	{
		var indent = 0;
		if (node.match( /.+<\/\w[^>]*>$/ ))
		{
			indent = 0;
		}
		else if (node.match( /^<\/\w/ ))
		{
			if (pad != 0)
			{
				pad -= 1;
			}
		}
		else if (node.match( /^<\w[^>]*[^\/]>.*$/ ))
		{
			indent = 1;
		}
		else
		{
			indent = 0;
		}
		var padding = '';
		for (var i = 0; i < pad; i++)
		{
			padding += '  ';
			
		}
		var nodo = node
		var T1 = ""
		var T2 = ""
		
		while (nodo.length > 135) {
			T1 += nodo.substring(0, 135);
			T1 += '\r\n';
			nodo = nodo.substring(135, nodo.length);			
		}
		nodo = T1 + nodo

		formatted += padding + nodo + '\r\n';
		pad += indent;
	});
	return formatted;
}

function decode_base64 (s)
{
    var e = {}, i, k, v = [], r = '', w = String.fromCharCode;
    var n = [[65, 91], [97, 123], [48, 58], [43, 44], [47, 48]];

    for (z in n)
    {
        for (i = n[z][0]; i < n[z][1]; i++)
        {
            v.push(w(i));
        }
    }
    for (i = 0; i < 64; i++)
    {
        e[v[i]] = i;
    }

    for (i = 0; i < s.length; i+=72)
    {
        var b = 0, c, x, l = 0, o = s.substring(i, i+72);
        for (x = 0; x < o.length; x++)
        {
            c = e[o.charAt(x)];
            b = (b << 6) + c;
            l += 6;
            while (l >= 8)
            {
                r += w((b >>> (l -= 8)) % 256);
            }
         }
    }
    return r;
}


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

 // var string = (argString + ''); // .replace(/\r\n/g, "\n").replace(/\r/g, "\n");
  var argString = argString.replace(/\r\n/g, "\n").replace(/\r/g, "\n"); 
  var utftext = '',
    start, fin, stringl = 0;

  start = fin = 0;
  stringl = argString.length;
  for (var n = 0; n < stringl; n++) {
    var c1 = argString.charCodeAt(n);
    var enc = null;

    if (c1 < 128) {
      fin++;
    } else if (c1 > 127 && c1 < 2048) {
      enc = String.fromCharCode((c1 >> 6) | 192, (c1 & 63) | 128);
    } else {
      enc = String.fromCharCode((c1 >> 12) | 224, ((c1 >> 6) & 63) | 128, (c1 & 63) | 128);
    }
    if (enc !== null) {
      if (fin > start) {
        utftext += argString.slice(start, fin);
      }
      utftext += enc;
      start = fin = n + 1;
    }
  }

  if (fin > start) {
    utftext += argString.slice(start, stringl);
  }

  return utftext;
}
 

</script>



