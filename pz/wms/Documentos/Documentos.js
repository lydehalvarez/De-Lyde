// JavaScript Document

function checkfile(fileExt) {
    var validExts = new Array('.gif', '.jpg', '.png', '.jpeg', '.pdf');
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

//Cli_ID + "," + Doc_ID + "," + Docs_ID + "," + Cargado
function LlamaDocumento(CliID,DocID,DocsID,Cargado) {

	var llaves = "Cli_ID=" + CliID 
		llaves += "&Doc_ID=" + DocID 
		llaves += "&Docs_ID="+ DocsID 		
		llaves += "&Cargado=" + Cargado 
		//alert(llaves);
							 
	$('#dvCargaDeInformacion').load("/pz/mh/Documentos/Clientes/Documento.asp?"+llaves,function(){
		
		$("#DocsGrid").hide("slow");
		$("#dvCargaDeInformacion").show("slow");
		
		if (DocsID == -1) {
			$.post("/pz/mh/Documentos/Clientes/DocsCli_Ajax.asp"
			  , { Tarea:3,Cli_ID:CliID,Doc_ID:DocID,Docs_ID:DocsID }
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
	
	$.post("/pz/mh/Documentos/Clientes/DocsCli_Ajax.asp"
		  , { Tarea:2,Cli_ID:$("#Cli_ID").val()
			 ,Doc_ID:$("#Doc_ID").val(),Docs_ID:$("#Docs_ID").val()}
		  , function(msg){
			  if (msg == "OK" ) {
				$.gritter.add({position: 'top-right',title: 'Aviso',text: "El nombre del archivo fue eliminado en la base de datos satisfactoriamente.",sticky: false,time: 1200});  
				RecargaEnSiMismo();
			  } else {
				$.gritter.add({position: 'top-right',title: 'Aviso',text: "Sucedio un error al borrar el nombre  del archivo en la base de datos, favor de avisar a su administrador, gracias.",sticky: true,time: 1200});  
			  }
	});
	
}

function SubeArchivo() {
	//alert("Entra..");
	$('#btnSubir').hide("slow");
	
	var sMensaje= "Espera un momento, el archivo esta procesandose, puede tardar un poco";
	//$.jGrowl(sMensaje, { header: 'Guardar Archivo', sticky: false, life: 10000, glue:'before'});
	$.gritter.add({position: 'top-right',title: 'Guardar Archivo',text: sMensaje,sticky: false,time: 10000});
		
	var sRutaArch = "/Media/mh/Cliente/Cliente/";		
				
	var sDatos = "Cli_ID=" + $("#Cli_ID").val();
		sDatos += "&Doc_ID=" + $("#Doc_ID").val();
		sDatos += "&Docs_ID=" + $("#Docs_ID").val();	
		sDatos += "&Doc_Nombre=" + $("#Doc_Nombre").val();
		//alert(sDatos);
	var data = new FormData();
	jQuery.each($('#file')[0].files, function(i, file) {
		//alert(file);
		data.append('file-'+i, file);
	});
	/*
	var sRutaArch = $('#file')[0].val(); //$("#DocC_NombreImagenID").val() //$("#file").val();
	var iLong = sRutaArch.length;
	var iPosUltim =	sRutaArch.lastIndexOf("\\");
		sRutaArch = sRutaArch.substring(iPosUltim+1,iLong)
	*/
	
	$.ajax({
		url: "/pz/mh/Documentos/Clientes/uploadAccDocCli.asp?"+sDatos,
		data: data,
		cache: false,
		contentType: 'multipart/form-data',
		processData: false,
		type:"POST",
		success: function(data) {
 				 //alert(data);
					var sNomArch = "";
					var sTmp = String(data);
					var arrDatos = new Array();
					arrDatos = sTmp.split("|");
					if (arrDatos[0] == "OK") { 
					$('#SubirArchivo').hide("slow");
					//$.jGrowl("El archivo fue colocado en el servidor satisfactoriamente.", { header: ' Aviso ', sticky: false, life: 1200, glue:'before'});
					$.gritter.removeAll();
					$.gritter.add({position: 'top-right',title: 'Aviso',text: "El archivo fue colocado en el servidor satisfactoriamente.",sticky: false,time: 1200});
					
							$("#Doc_Nombre").val(arrDatos[1]);
							GuardarABDNombreArchivo(sRutaArch);
							sNomArch = String(arrDatos[1]);
							var aPosition = sNomArch.indexOf(".pdf");
							
	if(aPosition > -1) {
		$("#dvArchivoSubido").append($('<embed>')
										.attr('src', '/Media/mh/Cliente/Cliente/' + sNomArch+'#toolbar=0')
										.attr('width','940')
										.attr('height','1000')
									)
	} else { 
		$("#dvArchivoSubido").append($('<img>')
										.attr('src', '/Media/mh/Cliente/Cliente/' + sNomArch)
										.attr('border','0')
									)
	}
//							var sMensaje= "Si el archivo es de su agrado por favor guardelo";
//							$.jGrowl(sMensaje, { header: 'Guardar Archivo', sticky: false, life: 7000, glue:'before'});	
						
						$('#BotonesSinDocumento').hide();
						$('#BotonesConDocumento').show("slow");
						$("#MuestraArchivo").show("slow");
						//FicEscribeArchivoEnBD(sNomArch);
					} else {
						//$.jGrowl("Sucedio un error al colocar el archivo en el servidor, favor de avisar a su administrador, gracias.", { header: ' Aviso ', sticky: false, life: 1200, glue:'before'});
						$.gritter.removeAll();
						$.gritter.add({position: 'top-right',title: 'Aviso',text: "Sucedio un error al colocar el archivo en el servidor, favor de avisar a su administrador, gracias.",sticky: false,time: 1200});
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
					alert("Error " + errorThrown);
				}
			}
		}	
							
	});

}

function GuardarABDNombreArchivo(sjsRutaArch) {
		
	$.post("/pz/mh/Documentos/Clientes/DocsCli_Ajax.asp", { Tarea:1,Cli_ID:$("#Cli_ID").val()
			 ,Doc_ID:$("#Doc_ID").val(),Docs_ID:$("#Docs_ID").val()
			 ,Doc_Nombre:$("#Doc_Nombre").val(),Doc_RutaArchivo:sjsRutaArch
			 ,Docs_Titulo:$("#Docs_Titulo").val(),Docs_Observaciones:$("#Docs_Observaciones").val()}
		  , function(msg){
			  if (msg == "OK" ) {
					$.gritter.add({position: 'top-right',title: 'Aviso',text: "El nombre del archivo fue guardado en la base de datos satisfactoriamente.",sticky: false,time: 1200});  
			  } else {
				$.gritter.add({position: 'top-right',title: 'Aviso',text: "Sucedio un error al guardar el nombre  del archivo en la base de datos, favor de avisar a su administrador, gracias.",sticky: true,time: 1200});  
			  }
			  
	});

}



