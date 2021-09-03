<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include file="../../../Includes/iqon.asp" -->
<%

 	var Cli_ID = Parametro("Cli_ID",-1)	
 	//var OV_ID = Parametro("CliOC_ID",-1)  //Porque CliOC_ID
    var OV_ID = Parametro("OV_ID",-1)
	var Con_ID = Parametro("Con_ID",-1)
	var Doc_ID = Parametro("Doc_ID",-1)	
	var Docs_ID = Parametro("Docs_ID",-1)			
	var Cargado = Parametro("Cargado",0)
	var IDUsuario = Parametro("IDUsuario",0)			
	
	var sCondicion = " Doc_ID = " + Doc_ID    
	var NombreDocumento = BuscaSoloUnDato("Doc_Nombre","Cat_Documento",sCondicion,"",0)
	var Doc_Nombre = ""
	var sRuta = "/Media/wms/Evidencia/" 
	var sTitulo = "" 
	var Docs_Observaciones = "" 
	var Docs_Validado = 0 
	var NombreXML = "" 		
	
	SeguridadExtendida(1,IDUsuario,SegGrupo,SistemaActual,VentanaIndex,iqCli_ID)
					   
	var PermisoValidar = Session("EXConsulta")
	
	
if (Cargado == 1) {

	var sCondArchivo = " OV_ID = " + OV_ID	
	    sCondArchivo += " AND Doc_ID = " + Doc_ID		
		sCondArchivo += " AND Docs_ID = " + Docs_ID	
		 
	var sSQL = "SELECT OV_ID, Doc_ID, Docs_ID, Docs_Nombre, Docs_RutaArchivo, Docs_FechaRegistro"
	    sSQL += " , Docs_Titulo, Docs_Observaciones, Docs_Validado, Docs_UsuarioValido "
		sSQL += " FROM Orden_Venta_Documentos "
		//sSQL += " WHERE OV_ID = " + sCondArchivo	
   		sSQL += " WHERE " + sCondArchivo

	bHayParametros = false
	ParametroCargaDeSQL(sSQL,0) 

	Doc_Nombre = Parametro("Docs_Nombre","")
	sRuta = Parametro("Docs_RutaArchivo","")
	sTitulo = Parametro("Docs_Titulo","")	
	Docs_Observaciones = Parametro("Docs_Observaciones","")
	Docs_Validado = Parametro("Docs_Validado",0)	
	
}
//Response.Write("Cargado = " + Cargado + " Docs_Validado = " + Docs_Validado + " PermisoValidar = " + PermisoValidar)

%>
<!-- start: MAIN CSS -->
<style type="text/css">
	.espaciobtn{
		margin:0px 15px;
	}
	.btn {
		margin-bottom:15px;	
	}

</style>
<link href="/Template/inspina/css/plugins/jasny/jasny-bootstrap.min.css" rel="stylesheet">
<!-- Jasny -->
<script src="/Template/inspina/js/plugins/jasny/jasny-bootstrap.min.js"></script>
<div class="wrapper wrapper-content  animated fadeInRight">
	<div class="row">
		<div class="col-lg-12">
			<div class="ibox">
            	<div class="ibox-title">
                	<h5><%=NombreDocumento%></h5>
           		</div>
            <div class="ibox-content">
            <div class="table-responsive" style="min-height: 300px;">
    <div class="row">
    	<div class="col-md-2"><h4>T&iacute;tulo</h4></div>
            <div class="col-md-8"><% 
                if (Docs_Validado==1 && Cargado == 1) { 
                Response.Write("<h4>"+sTitulo+"</h4>")
                } else { %>
                <input type="text" class="form-control" id="Docs_Titulo" name="Docs_Titulo" 
                   value="<%=sTitulo%>" placeholder="Titulo">
                <% } %>
            </div>
    </div>
    <div class="row">
        <div class="col-md-2"><h4>Observaciones</h4></div>
        <div class="col-md-8"><% 
            if (Docs_Validado==1 && Cargado == 1) { 
            Response.Write("<h4>"+Docs_Observaciones+"</h4>")
            } else { %>
            <textarea class="form-control" id="Docs_Observaciones" name="Docs_Observaciones" placeholder="Observaciones"><%=Docs_Observaciones%></textarea>
            <% } %>
        </div>

		
        <div id="BotonesSinDocumento" 
         class="col-md-2">
            <div id="areabotones">
            <% if(Docs_Validado == 0 ) {  %>             
             <button class="btn btn-w-m btn-success" type="button" onclick="javascript:DocGuardar();">
             <i class="fa fa-check"></i>&nbsp;Guardar</button> 
             <br />
            <% } %>  
             <button type="button" class="btn btn-w-m btn-primary" onclick="javascript:DocRegresar();">
             <i class="fa fa-arrow-circle-left"> </i> Regresar&nbsp;</button>
             <br />             
             
            <% if(Cargado == 1){
                  if(Docs_Validado == 0 ) {  %> 
             <button type="button" class="btn btn-w-m btn-danger" onclick="javascript:DocBorrar();">
             <i class="fa fa-trash-o"> </i> Borrar&nbsp;</button>                   
             <br />		
             	<% }  	       
			       if(Docs_Validado==0 && PermisoValidar == 1){%>
             <button class="btn btn-w-m btn-success" type="button" onclick="javascript:DocValidar();">
             <i class="fa fa-check"></i>&nbsp;Validar</button>  
             <br />
             <button class="btn btn-w-m btn-danger" type="button" onclick="javascript:DocRechazar();">
             <i class="fa fa-times"></i>&nbsp;Rechazar</button>
                 <%} } %> 
            </div>
        </div>
    </div>    

    <div id="SubirArchivo" <% if (Cargado == 1) { %>style="display:none" <% } %>>
    	<!--Nuevo upload {start} -->
        <div class="form-group">
        <div class="col-sm-offset-2 col-sm-8">     
            
<div class="fileinput input-group fileinput-new" data-provides="fileinput" id="btnSubir">
    <div class="form-control" data-trigger="fileinput">
        <i class="glyphicon glyphicon-file fileinput-exists"></i> 
        <span class="fileinput-filename"></span>
    </div>
    <span class="input-group-addon btn btn-default btn-file">
    	<span class="fileinput-new">Seleccione un archivo</span>
    	<span class="fileinput-exists">Cambiar</span>
    	<input type="hidden" value="" name="...">
        <input type="file" name="file" id="file" accept="image/*,.pdf,application/pdf">
    </span> 
    <a href="#" class="input-group-addon btn btn-default fileinput-exists" data-dismiss="fileinput">
    <i class="fa fa-trash-o"> </i> Quitar</a>
    <a href="javascript:SubeArchivo();" class="input-group-addon btn btn-default fileinput-exists" >
    <i class="fa fa-upload"> </i> Cargar</a>    
</div>

        </div>    
        </div>        
        
        <div class="form-group">       
            <div class="col-sm-offset-1 col-sm-11">	
                <div align="center">
                    <img id="Preview" src="#" alt="vista previa" style="display:none"/>
                </div>
            </div> 
        </div>
        
        
        <div class="form-group">               
            <div class="col-sm-offset-1 col-sm-11">	
                <div align="center">
                    <iframe id="PreviewPDF" frameborder="0" scrolling="no" width="800" height="1100" style="display:none"></iframe>
                </div>
            </div>        
        </div>        
 
    </div>
    <div id="MuestraArchivo" <% if (Cargado == 0) { %>style="display:none;" <% } %> >
    
    <table width="940px" border="0" cellspacing="0" cellpadding="0">
      <tr>
        <td width="81">&nbsp;</td>
        <td width="388">&nbsp;</td>
        <td width="390">&nbsp;</td>
        <td width="81">&nbsp;</td>
      </tr>
      <tr>
        <td>&nbsp;</td>
        <td colspan="2" align="center" id="dvArchivoSubido"><% 
     if (Cargado == 1) {
        var aPosition = Doc_Nombre.indexOf(".pdf");
        if(aPosition > -1) {
            Response.Write("<embed src='"+sRuta+Doc_Nombre+"#toolbar=0' width='940' height='1000' >")		
        } else if(Doc_Nombre.indexOf(".xml")>-1) { 
			NombreXML = Doc_Nombre
		 %>
                <pre class="info"></pre>
                <div id="xmlfile" style="text-align:left">
                    <pre class="formatted" style="text-align:left"></pre>
                </div>
<%  
        } else if(Doc_Nombre.indexOf(".txt")>-1) { 
			NombreXML = Doc_Nombre
		 %>
                <pre class="info"></pre>
                <div id="xmlfile" style="text-align:left">
                    <pre class="formatted" style="text-align:left"></pre>
                </div>
<%  
        } else {
            Response.Write("<img src='"+sRuta+Doc_Nombre+"' border='0'>")  
        }
	 }
        %></td>
        <td>&nbsp;</td>
      </tr>
    </table>
    
    </div>
    
</div></div></div></div></div></div>
<div id="Resultadoajax" ></div>
<!--input type="hidden" name="OV_ID" id="OV_ID" value=""-->
<input type="hidden" name="Doc_Nombre" id="Doc_Nombre" value="<%=Doc_Nombre%>">
<input type="hidden" name="Doc_ID" id="Doc_ID" value="<%=Doc_ID%>">
<input type="hidden" name="Docs_ID" id="Docs_ID" value="<%=Docs_ID%>">

<script type="text/javascript" src="/js/vkbeautify.0.99.00.beta.js"></script>
<script type="text/javascript">
	
$(document).ready(function() {
	
	$("#file").change(function(){
		//alert($("#file").val());
		if($("#file").val() != "") {
			//alert("Existe archivo!!!!");
			var fileName = this.files[0].name;
				fileName = fileName.toLowerCase();
			var EsPDF = fileName.search(".pdf");
			var fileSize = this.files[0].size;
			var fileType = this.files[0].type;
			//alert('FileName : ' + fileName + '\nFileSize : ' + fileSize + ' bytes' + '\nfileType : ' + fileType);			
			if (checkfile(fileName)) {
				$('#btnSubir').show("slow");
				//$('#BotonesSinDocumento').show("slow");
				fileName = QuitaAcentos(fileName); 
				// Quitamos espacios y los sustituimos por _ 
                fileName = fileName.replace(/ /g,"_"); 
				fileName = QuitaCaracteresEspeciales(fileName);						
				$("#Doc_Nombre").val(fileName);				
				CargaVistaPrevia(this, EsPDF);
			}
	
		} else {
			//alert("No Existe archivo!!!!");
			$('#btnSubir').hide("slow");
			$("#Doc_Nombre").val("");
			$("#PreviewPDF").val("");
			$("#PreviewPDF").hide("slow");			
			//CargaVistaPrevia(this, false);			
		}
		
	});
	
<% if(NombreXML != "") {%>

	var url = "/Media/wms/Evidencia/<%=NombreXML%>";

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
	
<% } %>	

					 
});
 
function DocRechazar(){
	$.post("/pz/wms/Documentos/DocsAdminOC_Ajax.asp"
	  , { Tarea:4,OV_ID:$("#OV_ID").val()
	     ,Doc_ID:$("#Doc_ID").val(),Docs_ID:$("#Docs_ID").val()
	     ,Validado:2,Usu_ID:$("#IDUsuario").val() }
	  , function(ID){
		  	var sMensaje= "El documento fue marcado como rechazado";
			Avisa("info",'Validacion de documentos',sMensaje)
			EscondeBotones();
		});
}

function DocValidar(){
	$.post("/pz/wms/Documentos/DocsAdminOC_Ajax.asp"
	  , { Tarea:4,OV_ID:$("#OV_ID").val()
	     ,Doc_ID:$("#Doc_ID").val(),Docs_ID:$("#Docs_ID").val(),Validado:1
		 ,Usu_ID:$("#IDUsuario").val() }
	  , function(ID){
		  	var sMensaje= "El documento fue validado correctamente";
			Avisa("success",'Validacion de documentos',sMensaje)
			EscondeBotones();
				
		});	
}


function DocGuardar(){

		SubeArchivo();
}

function SubeArchivo() {

	var sMensaje= "Espera un momento, el archivo esta procesandose, puede tardar un poco";
	Avisa("info",'Carga de documentos',sMensaje)
	
	if($("#Docs_ID").val() == -1) {
		$.post( "/pz/wms/Documentos/DocsAdminOC_Ajax.asp"
		      , { Tarea:3,OV_ID:$("#OV_ID").val(),Doc_ID:$("#Doc_ID").val()}
		      , function(id){
				  $("#Docs_ID").val(id)
			 	 CargaArchivoAlServidor()
			  });
	} else {
		CargaArchivoAlServidor()	
	}
		
}

function CargaArchivoAlServidor() {		

	var sRutaArch = "/Media/wms/Evidencia/";	
	var sMensaje = ""
					
		var sDatos = "OV_ID=" + $("#OV_ID").val();
		sDatos += "&Doc_ID=" + $("#Doc_ID").val();
		sDatos += "&Docs_ID=" + $("#Docs_ID").val();	
		sDatos += "&Doc_Nombre=" + $("#Doc_Nombre").val();	
		//alert(sDatos);

		
//	var data = new FormData();
//	jQuery.each($('#file')[0].files, function(i, file) {
//		//alert($("#file").val());
//		data.append('file-'+i, file);
//	});
    var formElement = document.getElementById("file");
	var data = new FormData();    
	//data.append( 'file', input.files[0] );
	data.append("file", formElement.files[0]);

    //data.append( 'file', $( '#file' )[0].files[0] );
	//var formData = new FormData($('#file')[0]);
			
	/*
	var sRutaArch = $('#file')[0].val(); //$("#DocC_NombreImagenID").val() //$("#file").val();
	var iLong = sRutaArch.length;
	var iPosUltim =	sRutaArch.lastIndexOf("\\");
		sRutaArch = sRutaArch.substring(iPosUltim+1,iLong)
	*/
	
	$.ajax({
		url: "/pz/wms/Documentos/uploadAccAdminOC.asp?"+sDatos,
		data: data,
		cache: false,
		contentType: 'multipart/form-data',
		//contentType: false,
		processData: false,
		//mimeType: 'multipart/form-data',
		type:"POST",
		success: function(data) {
 				 //alert(data);
					var sNomArch = "";
					var sTmp = String(data);
					var arrDatos = new Array();
					arrDatos = sTmp.split("|");
					if (arrDatos[0] == "OK") { 
				
					Avisa("success",'Carga de documentos',sMensaje)
					var sMensaje = "El archivo fue colocado en el servidor satisfactoriamente."
					$("#Doc_Nombre").val(arrDatos[1]);
					GuardarABDNombreArchivo(sRutaArch);
					sNomArch = String(arrDatos[1]);
							
	if(sNomArch.indexOf(".pdf") > -1) {
		$("#dvArchivoSubido").append($('<embed>')
										.attr('src', '/Media/wms/Evidencia/' + sNomArch+'#toolbar=0')
										.attr('width','940')
										.attr('height','1000')
									)
	} else if (sNomArch.indexOf(".xml") > -1) { 
	   $("#dvArchivoSubido").html(sNomArch)
	} else if (sNomArch.indexOf(".txt") > -1) { 
	   $("#dvArchivoSubido").html(sNomArch)	      
	} else { 
		$("#dvArchivoSubido").append($('<img>')
										.attr('src', '/Media/wms/Evidencia/' + sNomArch)
										.attr('border','0')
									)
	}
//							var sMensaje= "Si el archivo es de su agrado por favor guardelo";
//							$.jGrowl(sMensaje, { header: 'Guardar Archivo', sticky: false, life: 7000, glue:'before'});	
						
						//$('#BotonesSinDocumento').hide();
						//$('#BotonesConDocumento').show("slow");
						$("#MuestraArchivo").show("slow");
						//FicEscribeArchivoEnBD(sNomArch);
					} else {
					/*	var sMensaje = "Sucedio un error al colocar el archivo en el servidor, favor de avisar a su administrador."
						Avisa("error",'Borrado de documentos',sMensaje)		*/
					}
				  },  
		error: function(XMLHttpRequest, textStatus, errorThrown) {
			if(XMLHttpRequest.readyState == 0 || XMLHttpRequest.status == 0) {
              alert(" it's not really an error");
			} else {
				if (XMLHttpRequest.status == 500) {
					alert("Error HTTP 500 Internal server error (Error interno del servidor)");
					alert("Error " + errorThrown);
					
				//	
//					var
//						oData = new FormData(document.forms.namedItem("file"));
//					var oReq = new XMLHttpRequest();
//					  oReq.open("POST",  "/pz/agt/Documentos/uploadAccDocCliente.asp?"+sDatos, true);
//					  oReq.onload = function(oEvent) {
//						if (oReq.status == 200) {
//						  alert("Uploaded!")
//						} else {
//						  alert("Error " + oReq.status + " occurred uploading your file.<br \/>")
//						}
//					  };
//					
//					  oReq.send(oData);

				} else {
					alert(textStatus);
					alert("Error " + errorThrown);
				}
			}
		}	
							
	});

}
						
function GuardarABDNombreArchivo(sjsRutaArch) {
		
			$.post("/pz/wms/Documentos/DocsAdminOC_Ajax.asp", { Tarea:1,OV_ID:$("#OV_ID").val()
			 ,Doc_ID:$("#Doc_ID").val(),Docs_ID:$("#Docs_ID").val()
			 ,Doc_Nombre:$("#Doc_Nombre").val(),Doc_RutaArchivo:sjsRutaArch
			 ,Docs_Titulo:$("#Docs_Titulo").val(),Docs_Observaciones:$("#Docs_Observaciones").val()}
		  , function(msg){
			  if (msg == "OK" ) {
				  var sMensaje = "El nombre del archivo fue guardado en la base de datos satisfactoriamente."
				  Avisa("success",'Guardando el documento',sMensaje) 
			  } else { 
				/*  var sMensaje = "Sucedio un error al guardar el nombre  del archivo en la base de datos, favor de avisar a su administrador."
				  Avisa("error",'Guardando el documento',sMensaje) 				*/
			  }
			  
	});
}



function EscondeBotones(){
	$("#btnValidar").hide() 
	$("#btnRechazar").hide()
	 
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


</script>

