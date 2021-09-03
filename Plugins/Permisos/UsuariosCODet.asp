<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include file="../../Includes/iqon.asp" -->
<%
	
	var bIQon4Web = false

	var iUsu_ID = Parametro("IDUsuario",-1)

	var sSQLUsuario = ""

	var sSQLUsuario = "" 

		sSQLUsuario = " SELECT * FROM Usuario WHERE Usu_ID = ( "
		sSQLUsuario += " SELECT Usu_ID FROM Seguridad_Indice WHERE IDUnica = " + iUsu_ID + " ) "	
			
		if(bIQon4Web) { Response.Write(sSQLUsuario) }
		
		ParametroCargaDeSQL(sSQLUsuario,0)

	




%>
<link rel="stylesheet" href="/Template/ClipOne/admin/clip-one/assets/plugins/datepicker/css/datepicker.css">
<script type="text/javascript" src="/Template/ClipOne/admin/clip-one/assets/plugins/bootstrap-datepicker/js/bootstrap-datepicker.js"></script>
<script type="text/javascript" src="/Template/ClipOne/admin/clip-one/assets/plugins/bootstrap-datepicker/js/locales/bootstrap-datepicker.es.js"></script>

<div class="form-horizontal" id="frmFicha" name="frmFicha">
    <div class="form-group">
        <div class="col-xs-6" id="areafunciones">
          &nbsp;
        </div>
        <div class="col-xs-6" id="areabotones" style="text-align: right;padding-right:100px;">
          &nbsp;<a class="btn btn-blue btnCancelar" id="btnCancelar" name="btnCancelar">Cancelar&nbsp;<i class="fa fa-ban"></i></a>&nbsp;
          <a class="btn btn-green btnGuardar" id="btnGuardar" name="btnGuardar">Guardar&nbsp;<i class="fa fa-save"></i></a>
          <hr>
        </div>
    </div>
    <div class="form-group">
        <label class="col-xs-12"><h2><i class="fa fa-pencil-square teal"></i>Informaci&oacute;n general</h2><hr></label>
    </div>
    <div class="form-group">
        <label class="col-sm-1 control-label"><strong>Nombre</strong></label>
        <div class="col-sm-5">
        	<input type="text" class="form-control" name="Usu_Nombre" id="Usu_Nombre" placeholder="Nombre" value="<%=Parametro("Usu_Nombre","")%>" autocomplete="off">
        </div>
        <label class="col-sm-1 control-label"><strong>Titulo</strong></label>
        <div class="col-sm-5">
			<%ComboSeccion("Usu_TituloCG8"," class='form-control'",8,Parametro("Usu_TituloCG8",-1),0,"Seleccione","Cat_Nombre","Editar")%>
        </div>
    </div>
    <div class="form-group">
        <label class="col-sm-1 control-label"><strong>Usuario</strong></label>
        <div class="col-sm-5">	
        	<input type="text" class="form-control" name="Usu_Usuario" id="Usu_Usuario" placeholder="Usuario" value="<%=Parametro("Usu_Usuario","")%>" autocomplete="off">
        </div>
        <label class="col-sm-1 control-label"><strong>Contrase&ntilde;a</strong></label>
        <div class="col-sm-5 ">	
        	<input type="text" class="form-control" name="Usu_Password" id="Usu_Password" placeholder="Contrase&ntilde;a" value="<%=Parametro("Usu_Password","")%>" autocomplete="off">
        </div>
    </div>
    <div class="form-group">
        <label class="col-sm-1 control-label"><strong>Depende de</strong></label>
        <div class="col-sm-5">
			<%CargaCombo("Usu_Padre"," class='form-control'","Usu_ID","Usu_Nombre","Usuario","","Usu_Nombre",Parametro("Usu_Padre",-1),0,"Seleccione","Editar")%>
        </div>
    </div>
	<div class="form-group">
		<label class="col-sm-1 control-label"> Foto de perfil </label>
		<div class="col-sm-11">
			<input type="hidden" name="Usu_NombreLogoArchivo" id="Usu_NombreLogoArchivo" value="<%=Parametro("Usu_NombreLogoArchivo","")%>">
			<%
				var sRutaImg = ""
				var Usu_NombreLogoArchivo = "/images/noimage.png"

				//Response.Write(Parametro("Usu_RutaArchivo","") + " " + Parametro("Usu_NombreLogoArchivo",""))

					if(!EsVacio(Parametro("Usu_NombreLogoArchivo",""))) {
						sRutaImg = Parametro("Usu_RutaArchivo","")
						Usu_NombreLogoArchivo = Parametro("Usu_NombreLogoArchivo","")
					}
			%>
			<div class="fileupload fileupload-new" data-provides="fileupload"> <!--img src="/images/noimage.png" alt=""-->
				<div class="fileupload-new thumbnail" style="width: 200px; height: 150px;"><%Response.Write("<img id='imgUploadBDD' src='"+sRutaImg+Usu_NombreLogoArchivo+"' width='250' height='150'>")%></div>
				<div class="fileupload-preview fileupload-exists thumbnail" style="max-width: 150px; max-height: 150px; line-height: 20px;"></div>
				<div class="user-edit-image-buttons">
					<span class="btn btn-success btn-file"><span class="fileupload-new"><i class="glyphicon glyphicon-plus"></i> Agregar archivo</span>
					<span class="fileupload-exists"><i class="glyphicon glyphicon-camera"></i> Cambiar</span>
						<input type="file" style="width: 200px; height: 150px;" name="file" id="file">
					</span>
					<a href="#" class="btn fileupload-exists btn-danger" data-dismiss="fileupload">
						<i class="glyphicon glyphicon-remove"></i> Remover
					</a>
					<a class="btn btn-primary" href="javascript:SubeArchivo();" id="btnSubir" style="display:none">
						<i class="glyphicon glyphicon-upload"></i> Cargar la imagen al servidor
					</a>
				</div>
			</div>
			<div class="alert alert-warning">
				<span class="label label-warning">NOTA!</span> <span>La previsualizaci&oacute;n de la imagen s&oacute;lo funciona en IE10 +, FF3.6 +, Chrome6.0 + y Opera11.1 +. En navegadores antiguos y Safari, se muestra el nombre de archivo.</span>
			</div>
		</div>
	</div>  
    <div class="form-group">
        <label class="col-xs-12"><h2><i class="fa fa-pencil-square teal"></i>Informaci&oacute;n de control</h2><hr></label>
    </div>
    <div class="form-group">
        <label class="col-sm-2 control-label"><strong>Tipo de usuario</strong></label>
        <div class="col-sm-4">
			<%ComboSeccion("Usu_TipoUsuarioCG61"," class='form-control'",61,Parametro("Usu_TipoUsuarioCG61",-1),0,"Seleccione","Cat_Nombre","Editar")%>
        </div>
    </div>
    <div class="form-group">
        <label class="col-sm-2 control-label"><strong>Fecha de inicio</strong></label>
        <div class="col-sm-2">
            <div class="input-group">
                <input type="text" class="form-control" id="Usu_FechaInicio" size="25" placeholder="dd/mm/yyyy" value="<%=IFAnidado(!EsVacio(Parametro("Usu_FechaInicio","")),CambiaFormatoFecha(Parametro("Usu_FechaInicio",""),"yyyy-mm-dd","dd/mm/yyyy"),"")%>">
                <span class="input-group-addon"> <i class="fa fa-calendar"></i> </span>
            </div>
        </div>
        <label class="col-sm-2 control-label"><strong>Fecha de termino</strong></label>
        <div class="col-sm-2">
            <div class="input-group">
                <input type="text" class="form-control" id="Usu_FechaFin" size="25" placeholder="dd/mm/yyyy" value="<%=IFAnidado(!EsVacio(Parametro('Usu_FechaFin','')),CambiaFormatoFecha(Parametro('Usu_FechaFin',''),'yyyy-mm-dd','dd/mm/yyyy'),'')%>">
                <span class="input-group-addon"> <i class="fa fa-calendar"></i> </span>
            </div>
        </div>
    </div>
    <div class="form-group">
        <label class="col-sm-2 control-label"><strong>Observaciones</strong></label>
        <div class="col-sm-6">
        <textarea placeholder="Observaciones" id="Usu_Descripcion" name="Usu_Descripcion" class="form-control"><%=Parametro("Usu_Descripcion","")%></textarea>
        </div>
    </div>
    <div class="form-group">
        <label class="col-xs-12"><h2><i class="fa fa-pencil-square teal"></i>Informaci&oacute;n de contacto</h2><hr></label>
    </div>
    <div class="form-group">
        <label class="col-sm-1 control-label"><strong>Url</strong></label>
        <div class="col-sm-5">
        	<input type="text" class="form-control" name="Usu_Url" id="Usu_Url" placeholder="Url" value="<%=Parametro("Usu_Url","")%>" autocomplete="off">
        </div>
        <label class="col-sm-1 control-label"><strong>Correo electr&oacute;nico</strong></label>
        <div class="col-sm-5">	
        	<input type="text" class="form-control" name="Usu_Email" id="Usu_Email" placeholder="Correo electr&oacute;nico" value="<%=Parametro("Usu_Email","")%>" autocomplete="off">
        </div>
    </div>
    <div class="form-group">
        <label class="col-sm-1 control-label"><strong>Tel&eacute;fono</strong></label>
        <div class="col-sm-5">
        	<input type="text" class="form-control" name="Usu_Telefono" id="Usu_Telefono" placeholder="Tel&eacute;fono" value="<%=Parametro("Usu_Telefono","")%>" autocomplete="off">
        </div>
    </div>
    <div class="form-group">
        <label class="col-xs-12"><h2><i class="fa fa-pencil-square teal"></i>Informaci&oacute;n  adicional</h2><hr></label>
    </div>
    <div class="form-group">
        <label class="col-sm-1 control-label"><strong>Cumplea&ntilde;os</strong></label>
        <div class="col-sm-2">
            <div class="input-group">
                <input type="text" class="form-control" id="Usu_FechaNacimiento" size="25" placeholder="dd/mm/yyyy" value="<%=IFAnidado(!EsVacio(Parametro("Usu_FechaNacimiento","")),CambiaFormatoFecha(Parametro("Usu_FechaNacimiento",""),"yyyy-mm-dd","dd/mm/yyyy"), "")%>">
                <span class="input-group-addon"> <i class="fa fa-calendar"></i> </span>
            </div>
        </div>        
        <label class="col-sm-offset-3 col-sm-1 control-label"><strong>Skype</strong></label>
        <div class="col-sm-5">	
            <span class="input-icon">
                <input class="form-control" type="text" name="Usu_Skype" id="Usu_Skype" placeholder="Skype" value="<%=Parametro("Usu_Skype","")%>" autocomplete="off">
                <i class="clip-skype"></i>
            </span>            
        </div>
    </div>
    <div class="form-group">
    	<label class="col-sm-1 control-label"><strong>Twitter</strong></label>
        <div class="col-sm-5">
            <span class="input-icon">
                <input class="form-control" type="text" name="Usu_Twitter" id="Usu_Twitter" placeholder="Twitter" value="<%=Parametro("Usu_Twitter","")%>" autocomplete="off">
                <i class="clip-twitter"></i>
            </span>
    	</div>
        <label class="col-sm-1 control-label"><strong>Facebook</strong></label>
        <div class="col-sm-5">
            <span class="input-icon">
                <input class="form-control" type="text" name="Usu_Facebook" id="Usu_Facebook" placeholder="Facebook" value="<%=Parametro("Usu_Facebook","")%>" autocomplete="off">
                <i class="clip-facebook"></i>
            </span> 
        </div>   
    </div>
    <div class="form-group">
        <label class="col-sm-1 control-label"><strong>Google Plus</strong></label>
        <div class="col-sm-5">
            <span class="input-icon">
                <input class="form-control" type="text" name="Usu_GooglePlus" id="Usu_GooglePlus" placeholder="Google" value="<%=Parametro("Usu_GooglePlus","")%>" autocomplete="off">
                <i class="clip-google-plus"></i>
            </span>
        </div>
        <label class="col-sm-1 control-label"><strong>Linkedin</strong></label>
        <div class="col-sm-5">
        <span class="input-icon">
            <input class="form-control" type="text" name="Usu_Linkedin" id="Usu_Linkedin" placeholder="Linkedin" value="<%=Parametro("Usu_Linkedin","")%>" autocomplete="off">
            <i class="clip-linkedin"></i>
        </span>

    </div>    
</div>

<script type="text/javascript">

	if($('input[type="checkbox"]').length || $('input[type="radio"]').length) {
		$('input[type="checkbox"].grey, input[type="radio"].grey').iCheck({
			checkboxClass: 'icheckbox_minimal-grey',
			radioClass: 'iradio_minimal-grey',
			increaseArea: '10%' // optional
		});
	}

//=================== Elementos {start} ====================
	//Usu_FechaInicio 
	$('#Usu_FechaInicio').datepicker({
		format: 'dd/mm/yyyy',
		language: 'es',
		autoclose: true
	});

	var checkin = $('#Usu_FechaInicio').datepicker({
	  onRender: function(date) {
		return date.valueOf() < now.valueOf() ? 'disabled' : '';
	  }
	}).on('changeDate', function(ev) {
	   checkin.hide();
	}).data('datepicker');	
	
	//Usu_FechaFin
	$('#Usu_FechaFin').datepicker({
		format: 'dd/mm/yyyy',
		language: 'es',
		autoclose: true
	});

	var checkin = $('#Usu_FechaFin').datepicker({
	  onRender: function(date) {
		return date.valueOf() < now.valueOf() ? 'disabled' : '';
	  }
	}).on('changeDate', function(ev) {
	   checkin.hide();
	}).data('datepicker');	

	//Usu_FechaNacimiento
	$('#Usu_FechaNacimiento').datepicker({
		format: 'dd/mm/yyyy',
		language: 'es',
		autoclose: true
	});

	var checkin = $('#Usu_FechaNacimiento').datepicker({
	  onRender: function(date) {
		return date.valueOf() < now.valueOf() ? 'disabled' : '';
	  }
	}).on('changeDate', function(ev) {
	   checkin.hide();
	}).data('datepicker');	



	$(".btnCancelar").unbind("click").click(function(e) {

		e.preventDefault();	
	
		RecargaEnSiMismo();
		/*
		var e = $(this);
		$("#frmConsulta").show("slow");
		$("#frmEdiNvo").hide("slow");
		*/
	});


	$(".btnGuardar").unbind("click").click(function(e) {
		e.preventDefault();	

		var iTarea = 2
		
			if($("#Usu_ID").val() == -1) { iTarea = 1 }
				
			var sMensaje = ""
			var stiqui = false
		
		$.post("/Plugins/Permisos/UsuariosCO_Ajax.asp",{ 
			Tarea:iTarea,Usu_ID:$("#Usu_ID").val(),Usu_Nombre:$("#Usu_Nombre").val(),Usu_TituloCG8:$("#Usu_TituloCG8").val()
			,Usu_Usuario:$("#Usu_Usuario").val(),Usu_Password:$("#Usu_Password").val()
			,Usu_Padre:$("#Usu_Padre").val(),Usu_TipoUsuarioCG61:$("#Usu_TipoUsuarioCG61").val()
			,Usu_FechaInicio:$("#Usu_FechaInicio").val(),Usu_FechaFin:$("#Usu_FechaFin").val()
			,Usu_Descripcion:$("#Usu_Descripcion").val(),Usu_Url:$("#Usu_Url").val()
			,Usu_Email:$("#Usu_Email").val(),Usu_Telefono:$("#Usu_Telefono").val()
			,Usu_FechaNacimiento:$("#Usu_FechaNacimiento").val(),Usu_Skype:$("#Usu_Skype").val()
			,Usu_Twitter:$("#Usu_Twitter").val(),Usu_Facebook:$("#Usu_Facebook").val()
			,Usu_GooglePlus:$("#Usu_GooglePlus").val(),Usu_Linkedin:$("#Usu_Linkedin").val()
		}
		, function(data){
			//alert(data);
			if (data > -1) {

				$("#Usu_ID").val(data);
				sMensaje = "El registro se guardo correctamente";
				RecargaEnSiMismo();

			} else {
				sMensaje = "Ocurrio un error, verifique con su administrador";
				//stiqui = true;
			}
			$.gritter.add({position: 'top-right',title: 'Aviso',text: sMensaje,sticky: stiqui,time: 1200});  
		});			
		


	});


	//============Para subir la imagen =========== {start}

	$("#file").change(function(){
	
		if($("#file").val() != "") {
			//alert("Existe archivo!!!!");
			var fileName = this.files[0].name;
				fileName = fileName.toLowerCase();
			//var EsPDF = fileName.search(".pdf");
			var fileSize = this.files[0].size;
			var fileType = this.files[0].type;
			//alert('FileName : ' + fileName + '\nFileSize : ' + fileSize + ' bytes' + '\nfileType : ' + fileType);
			//alert(checkfile(fileName));			
			if (checkfile(fileName)) {
				$('#btnSubir').show("slow");
				$('#BotonesSinDocumento').show("slow");
				fileName = fileName.replace(/ /g, '_');
				fileName = fileName.replace(/\s/g, '_');
				fileName = fileName.replace(/á/g, 'a');				
				fileName = fileName.replace(/é/g, 'e');				
				fileName = fileName.replace(/í/g, 'i');	
				fileName = fileName.replace(/ó/g, 'o');				
				fileName = fileName.replace(/ú/g, 'u');				
				fileName = fileName.replace(/ñ/g, 'n');	
				//alert('FileName : ' + fileName + '\nFileSize : ' + fileSize + ' bytes' + '\nfileType : ' + fileType);	
				
				fileName = LimpiaCadena(fileName);
				
				$("#Usu_NombreLogoArchivo").val(fileName);				
				//CargaVistaPrevia(this, EsPDF);
			}
	
		} else {
	
			$('#btnSubir').hide("slow");
			$("#Usu_NombreLogoArchivo").val("");
			//$("#PreviewPDF").val("");
			//$("#PreviewPDF").hide("slow");			
			//CargaVistaPrevia(this, false);			
		}
		
	});

	function LimpiaCadena(sCadena){
		// Definimos los caracteres que queremos eliminar
		var specialChars = "!@#$^&%*()+=-[]\/{}|:<>?";

		// Los eliminamos todos
		for (var i = 0; i < specialChars.length; i++) {
			sCadena = sCadena.replace(new RegExp("\\" + specialChars[i], 'gi'), '');
		}

		// Lo queremos devolver limpio en minusculas
		sCadena = sCadena.toLowerCase();

		// Quitamos espacios y los sustituimos por _ porque nos gusta mas asi
		sCadena = sCadena.replace(/ /gi,"_");
		sCadena = sCadena.replace(/\s/gi, "_");

		// Quitamos acentos y "ñ". Fijate en que va sin comillas el primer parametro
		sCadena = sCadena.replace(/á/gi,"a");
		sCadena = sCadena.replace(/é/gi,"e");
		sCadena = sCadena.replace(/í/gi,"i");
		sCadena = sCadena.replace(/ó/gi,"o");
		sCadena = sCadena.replace(/ú/gi,"u");
		sCadena = sCadena.replace(/ñ/gi,"n");

		var arrSubCadena = sCadena.split("");

		for (var i = 0; i < arrSubCadena.length; i++) {
			switch(arrSubCadena[i].charCodeAt(0)) {
				case 225:		//á
					arrSubCadena[i] = "a";
					break;

				case 233:		//é
					arrSubCadena[i] = "e";
					break;

				case 237:		//í
					arrSubCadena[i] = "i";
					break;

				case 243:		//ó
					arrSubCadena[i] = "o";
					break;

				case 250:		//ú
					arrSubCadena[i] = "u";
					break;

				case 241:		//ñ
					arrSubCadena[i] = "n";
					break;
			}
		}

		sCadena = arrSubCadena.join("");

		return sCadena;
	}
	
	
	function checkfile(fileExt) {
		var validExts = new Array('.gif', '.jpg', '.png', '.jpeg'); //, '.pdf'
		//var fileExt = sender.value;
		fileExt = fileExt.toLowerCase();
		fileExt = fileExt.substring(fileExt.lastIndexOf('.'));
		if (validExts.indexOf(fileExt) < 0) {
			//alert("No es un archivo valido, solo se pueden colocar los siguientes tipos de archivo " + validExts.toString() + " ");
			bootbox.alert("No es un archivo valido, solo se pueden colocar los siguientes tipos de archivo " + validExts.toString() + " ");
		  return false;
		}
		else { 
			return true; 
		}
	}

	function SubeArchivo() {
		//alert("Entra..");
		$('#btnSubir').hide("slow");

		var sMensaje= "Espera un momento, el archivo esta procesandose, puede tardar un poco";
			$.gritter.add({position: 'top-right',title: 'Guardar Archivo',text: sMensaje,sticky: false,time: 10000});

		var sRutaArch = "/Media/mh/Perfil/PerfilImagen/";
		var sDatos = "Usu_ID=" + $("#IDUsuario").val();
			sDatos += "&Usu_NombreLogoArchivo=" + encodeURIComponent($("#Usu_NombreLogoArchivo").val());	
			//alert(sDatos);
		var data = new FormData();
		jQuery.each($('#file')[0].files, function(i, file) {
			data.append('file-'+i, file);
		});

		$.ajax({ // /Plugins/Permisos/UsuariosCO_Ajax.asp
			url: "/Plugins/Permisos/PerfilUpload.asp?"+sDatos,
			data: data,
			cache: false,
			contentType: 'multipart/form-data',
			processData: false,
			type:"POST",
			success: function(data) {
					 //alert(data);
						var sNomArch = ""
						var sTmp = String(data); 
						arrDatos = sTmp.split("|");
						if (arrDatos[0] == "OK") { 
						//alert(arrDatos[0] + " - " + arrDatos[1]);
						$('#SubirArchivo').hide("slow");
						//$.jGrowl("El archivo fue colocado en el servidor satisfactoriamente.", { header: ' Aviso ', sticky: false, life: 1200, glue:'before'});
						$.gritter.removeAll();
						$.gritter.add({position: 'top-right',title: 'Aviso',text: "El archivo fue colocado en el servidor satisfactoriamente.",sticky: false,time: 2400});

								$("#Usu_NombreLogoArchivo").val(arrDatos[1]);
								GuardarABDNombreArchivo();
								sNomArch = String(arrDatos[1]);
								$("#imgperfil").attr("src",String(sRutaArch)+String(arrDatos[1]));
						} else {
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


	function GuardarABDNombreArchivo() {

		var sRutaArch = "/Media/mh/Perfil/PerfilImagen/";

		$.post("/Plugins/Permisos/UsuariosCO_Ajax.asp",{ Tarea:4,Usu_ID:$("#Usu_ID").val(),Usu_NombreLogoArchivo:encodeURIComponent($("#Usu_NombreLogoArchivo").val()),Usu_RutaArchivo:sRutaArch }
			  , function(msg){

				  if (msg == "OK" ) {
					  $.gritter.add({position: 'top-right',title: 'Aviso',text: "El nombre del archivo fue guardado en la base de datos satisfactoriamente.",sticky: false,time: 1200});  
				  } else {
					$.gritter.add({position: 'top-right',title: 'Aviso',text: "Sucedio un error al guardar el nombre del archivo en la base de datos, favor de avisar a su administrador, gracias.",sticky: true,time: 1200});  
				  }
		});

	}
	
	
	
	
	
</script>
