// JavaScript Document

function checkfile(fileExt) {
    var validExts = new Array('.gif', '.jpg', '.png', '.jpeg', '.pdf', '.xml', '.txt');
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

//Deu_ID + "," + Doc_ID + "," + Docs_ID + "," + Cargado
function LlamaDocumento(ProvID,OCID,DocID,DocsID,Cargado) {

		var llaves = "Prov_ID=" + ProvID 
		 llaves += "&OC_ID=" + OCID 
		llaves += "&Doc_ID=" + DocID 
		llaves += "&Docs_ID="+ DocsID 		
		llaves += "&Cargado=" + Cargado 
		llaves += "&IDUsuario=" + $("#IDUsuario").val() 
		llaves += "&SistemaActual=" + $("#SistemaActual").val() 		
		llaves += "&VentanaIndex=" + $("#VentanaIndex").val() 		
		llaves += "&iqCli_ID=" + $("#iqCli_ID").val() 					
		//alert(llaves);
							 
	$('#dvCargaDeInformacion').load("/pz/wms/Documentos/DocumentoProveedorOC.asp?"+llaves,function(){
		
		$("#DocsGrid").hide("slow");
		$("#dvCargaDeInformacion").show("slow");
		
		if (DocsID == -1) {
			$.post("/pz/wms/Documentos/DocsCliente_Ajax.asp"
			  , { Tarea:3,Prov_ID:ProvID,OC_ID:OCID,Doc_ID:DocID,Docs_ID:DocsID }
			  , function(ID){
				  $("#Docs_ID").val(ID) 
				});
		} 
	});	
}


function DocRegresar() {
	
	RecargaEnSiMismo();
		
}

function DocBorrar(){
	
	$.post("/pz/wms/Documentos/DocsProveedor_Ajax.asp"
		  , { Tarea:2,Prov_ID:$("#Prov_ID").val(),OC_ID:$("#OC_ID").val()
			 ,Doc_ID:$("#Doc_ID").val(),Docs_ID:$("#Docs_ID").val()}
		  , function(msg){
			  if (msg == "OK" ) {
				  
				var sMensaje= "El archivo fue eliminado en la base de datos satisfactoriamente.";
			    Avisa("info",'Borrado de documentos',sMensaje)
				RecargaEnSiMismo();
			  } else {
				var sMensaje= "Sucedio un error al borrar el nombre  del archivo en la base de datos, favor de avisar a su administrador.";
			    Avisa("error",'Borrado de documentos',sMensaje)				  
			  }
	});
	
}

//function SubeArchivo() {
//	
//	$('#btnSubir').hide("slow");
//	
//	var sMensaje= "Espera un momento, el archivo esta procesandose, puede tardar un poco";
//	Avisa("info",'Carga de documentos',sMensaje)
//	
//	if($("#Docs_ID").val() == -1) {
//		$.post( "/pz/agt/Documentos/DocsCliente_Ajax.asp"
//		      , { Tarea:3,Cli_ID:$("#Cli_ID").val(),CliOC_ID:$("#CliOC_ID").val(),Doc_ID:$("#Doc_ID").val()}
//		      , function(id){
//				  $("#Docs_ID").val(id)
//			 	 CargaArchivoAlServidor()
//			  });
//	} else {
//		CargaArchivoAlServidor()	
//	}
//		
//}
//
//function CargaArchivoAlServidor() {		
//
//	var sRutaArch = "/Media/agt/Cliente/";	
//	var sMensaje = ""
//					
//	var sDatos = "Cli_ID=" + $("#Cli_ID").val();
//		 llaves = "CliOC_ID=" + CliOCID 
//		sDatos += "&Doc_ID=" + $("#Doc_ID").val();
//		sDatos += "&Docs_ID=" + $("#Docs_ID").val();	
//		sDatos += "&Doc_Nombre=" + $("#Doc_Nombre").val();	
//		//alert(sDatos);
//
//		
////	var data = new FormData();
////	jQuery.each($('#file')[0].files, function(i, file) {
////		//alert($("#file").val());
////		data.append('file-'+i, file);
////	});
//    var formElement = document.getElementById("file");
//	var data = new FormData();    
//	//data.append( 'file', input.files[0] );
//	data.append("file", formElement.files[0]);
//
//    //data.append( 'file', $( '#file' )[0].files[0] );
//	//var formData = new FormData($('#file')[0]);
//			
//	/*
//	var sRutaArch = $('#file')[0].val(); //$("#DocC_NombreImagenID").val() //$("#file").val();
//	var iLong = sRutaArch.length;
//	var iPosUltim =	sRutaArch.lastIndexOf("\\");
//		sRutaArch = sRutaArch.substring(iPosUltim+1,iLong)
//	*/
//	
//	$.ajax({
//		url: "/pz/agt/Documentos/uploadAccDocCliente.asp?"+sDatos,
//		data: data,
//		cache: false,
//		contentType: 'multipart/form-data',
//		//contentType: false,
//		processData: false,
//		//mimeType: 'multipart/form-data',
//		type:"POST",
//		success: function(data) {
// 				 //alert(data);
//					var sNomArch = "";
//					var sTmp = String(data);
//					var arrDatos = new Array();
//					arrDatos = sTmp.split("|");
//					if (arrDatos[0] == "OK") { 
//					$('#SubirArchivo').hide("slow");					
//					Avisa("success",'Carga de documentos',sMensaje)
//					var sMensaje = "El archivo fue colocado en el servidor satisfactoriamente."
//					$("#Doc_Nombre").val(arrDatos[1]);
//					GuardarABDNombreArchivo(sRutaArch);
//					sNomArch = String(arrDatos[1]);
//							
//	if(sNomArch.indexOf(".pdf") > -1) {
//		$("#dvArchivoSubido").append($('<embed>')
//										.attr('src', '/Media/agt/Cliente/' + sNomArch+'#toolbar=0')
//										.attr('width','940')
//										.attr('height','1000')
//									)
//	} else if (sNomArch.indexOf(".xml") > -1) { 
//	   $("#dvArchivoSubido").html(sNomArch)
//	} else if (sNomArch.indexOf(".txt") > -1) { 
//	   $("#dvArchivoSubido").html(sNomArch)	      
//	} else { 
//		$("#dvArchivoSubido").append($('<img>')
//										.attr('src', '/Media/agt/Cliente/' + sNomArch)
//										.attr('border','0')
//									)
//	}
////							var sMensaje= "Si el archivo es de su agrado por favor guardelo";
////							$.jGrowl(sMensaje, { header: 'Guardar Archivo', sticky: false, life: 7000, glue:'before'});	
//						
//						//$('#BotonesSinDocumento').hide();
//						//$('#BotonesConDocumento').show("slow");
//						$("#MuestraArchivo").show("slow");
//						//FicEscribeArchivoEnBD(sNomArch);
//					} else {
//						var sMensaje = "Sucedio un error al colocar el archivo en el servidor, favor de avisar a su administrador."
//						Avisa("error",'Borrado de documentos',sMensaje)		
//					}
//				  },  
//		error: function(XMLHttpRequest, textStatus, errorThrown) {
//			if(XMLHttpRequest.readyState == 0 || XMLHttpRequest.status == 0) {
//              alert(" it's not really an error");
//			} else {
//				if (XMLHttpRequest.status == 500) {
//					alert("Error HTTP 500 Internal server error (Error interno del servidor)");
//					alert("Error " + errorThrown);
//					
//				//	
////					var
////						oData = new FormData(document.forms.namedItem("file"));
////					var oReq = new XMLHttpRequest();
////					  oReq.open("POST",  "/pz/agt/Documentos/uploadAccDocCliente.asp?"+sDatos, true);
////					  oReq.onload = function(oEvent) {
////						if (oReq.status == 200) {
////						  alert("Uploaded!")
////						} else {
////						  alert("Error " + oReq.status + " occurred uploading your file.<br \/>")
////						}
////					  };
////					
////					  oReq.send(oData);
//
//				} else {
//					alert(textStatus);
//					alert("Error " + errorThrown);
//				}
//			}
//		}	
//							
//	});
//
//}
//
//function GuardarABDNombreArchivo(sjsRutaArch) {
//		
//	$.post("/pz/agt/Documentos/DocsCliente_Ajax.asp", { Tarea:1,Cli_ID:$("#Cli_ID").val()
//			 ,Doc_ID:$("#Doc_ID").val(),Docs_ID:$("#Docs_ID").val()
//			 ,Doc_Nombre:$("#Doc_Nombre").val(),Doc_RutaArchivo:sjsRutaArch
//			 ,Docs_Titulo:$("#Docs_Titulo").val(),Docs_Observaciones:$("#Docs_Observaciones").val()}
//		  , function(msg){
//			  if (msg == "OK" ) {
//				  var sMensaje = "El nombre del archivo fue guardado en la base de datos satisfactoriamente."
//				  Avisa("success",'Guardando el documento',sMensaje) 

//			  } else { 
//				  var sMensaje = "Sucedio un error al guardar el nombre  del archivo en la base de datos, favor de avisar a su administrador."
//				  Avisa("error",'Guardando el documento',sMensaje) 				
//			  }
//			  
//	});
//
//
//}
//


