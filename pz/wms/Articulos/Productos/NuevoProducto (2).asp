<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include file="../../../../Includes/iqon.asp" -->
<%

	var Pro_ID = Parametro("Pro_ID",-1)
	
	var MaxProE_ID = BuscaSoloUnDato("ISNULL(MAX(ProE_ID),0)","Producto_Extras","Pro_ID = " + Pro_ID,0,0)
	
	var sSQLPro = "SELECT * "
		sSQLPro += "FROM Producto WHERE Pro_ID = " + Pro_ID
		
	bHayParametros = false
	ParametroCargaDeSQL(sSQLPro,0)
	
%>

<style>

.dimension-fields{
    display: flex;
/*  border: 1px solid #b0c0d6;*/
}
.dimension-fields .dimension-input {
    flex-basis: 33%;
}
.dimension-fields .dimension-seperator {
    padding: 8px 7px;
    color: #ccc;
    background-color: #fff;
    font-size: 12px;
}
.required {
    color: #b94a48;
}
.required:after {
    content: "*";
    color: #b94a48;
}
.Espacio {
    margin-top: 35px;
    margin-bottom: 35px;
}
.ColorTitulo{
	color: #1ab394;
	/*color: #14c5b5;	*/
}
</style>


<link href="/Template/inspina/css/plugins/iCheck/green.css" rel="stylesheet">
<link href="/Template/inspina/css/plugins/dropzone/basic.css" rel="stylesheet">

<div class="form-horizontal">
    <div class="row">
     	<div id="Relacion"></div>
        <div class="col-lg-8" id="MoveRight">
            <div class="ibox float-e-margins">
                <div class="ibox-content">
                    <div class="form-group">
                        <legend class="control-label col-md-5 ColorTitulo">Datos escenciales&nbsp;&nbsp;<i class="fa fa-pencil"></i></legend>
                     </div>
                    <div class="form-group">
                        <label class="control-label col-md-3 required">Nombre</label>
                        <div class="col-lg-8">
                            <input autofocus="" value="<%=Parametro("Pro_Nombre","")%>" autocomplete="off"  placeholder="Nombre del producto" class="form-control getdatos" id="Pro_Nombre" type="text">
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="control-label col-md-3 required">SKU</label>
                        <div class="col-lg-8">
                            <input placeholder="SKU"  value="<%=Parametro("Pro_SKU","")%>" autocomplete="off" class="form-control getdatos" id="Pro_SKU" type="text">
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="control-label col-md-3 required">Tipo de producto</label>
                        <div class="col-lg-8">
							<%CargaCombo("TPro_ID","class='form-control getdatos TPro_ID'","TPro_ID","TPro_Nombre"
							,"Cat_TipoProducto","","TPro_Nombre",-1,0,"Selecciona","Editar")					   
							%>
                        </div>
                    </div>
                    <div id="cmboCategoria" class="clean"></div>
                    <div id="cmboSubCategoria" class="clean"></div>
                </div>
            </div>
        </div>
<!-------------------Start Dropzone---------------------------------------------------->        
        <div class="col-lg-4 Esconde">
            <div class="ibox float-e-margins">
                <div class="ibox-content">
                    <div class="dropzone dz-clickable" id="dropzoneForm">
                      <div class="dz-default dz-message" id="dropImagen" data-dz-message="">
                        <span><div style='text-align:center;'>
                        <i class='fa fa-file-photo-o fa-3x'></i><br><br><strong>Arrastra aqu&iacute; la imagen del producto </strong>
                        </br><br>(El m&aacute;ximo de peso posible es 2 mb.)</div>
                        </span>
                      </div>
                    </div>
  <button type="button" class="btn btn-md btn-danger" id="btnSubirDocs">Prueba Array</button>
                 </div>
             </div>
        </div>
<!-------------------End Dropzone---------------------------------------------------->        
    </div>
    <div class="row Esconde">
        <div class="col-lg-12">
            <div class="ibox float-e-margins">
                <div class="ibox-content">
<!-------------------Atributos---------------------------------------------------->        
                    <div class="form-group">
                        <legend class="control-label col-md-3 ColorTitulo">Atributos&nbsp;&nbsp;<i class="fa fa-gear"></i></legend>
                    </div>
                            <div class="row form-group">
                                <label class="control-label col-md-2">Marca</label>
                                <div class="col-md-4">
                                    <%CargaCombo("Mar_ID"," class='form-control getdatos'","Mar_ID","Mar_Nombre","Cat_Marca","","Mar_Nombre",
                                    Parametro("Mar_ID",-1),0,"Selecciona","Editar")%>
                                </div>
                                <label class="control-label col-md-2">Color</label>
                                <div class="col-md-4">
                                    <%CargaCombo("Col_ID"," class='form-control getdatos'","Col_ID","Col_Nombre","Cat_Color","","Col_Nombre",
                                    Parametro("Col_ID",-1),0,"Selecciona","Editar")%>
                                </div>
                            </div>
                            <div class="row form-group">
                                <label class="control-label col-md-2">Moneda</label>
                                <div class="col-md-4">
                                    <%CargaCombo("Mon_ID"," class='form-control getdatos'","Mon_ID","Mon_Moneda","Cat_Moneda","","Mon_Moneda",
                                    Parametro("Mon_ID",-1),0,"Selecciona","Editar")%>
                                </div>
                                <label class="control-label col-md-2">Unidad de medida</label>
                                <div class="col-md-4">
                                    <%CargaCombo("UdM_ID"," class='form-control getdatos'","UdM_ID","UdM_Nombre","Cat_UnidadDeMedida","","UdM_Nombre",
                                    Parametro("UdM_ID",-1),0,"Selecciona","Editar")%>
                                </div>
                            </div>
                            <div class="row form-group">
                                <label class="control-label col-md-2">Estado</label>
                                <div class="col-md-4">
                                    <%CargaCombo("Edo_ID"," class='form-control getdatos'","Edo_ID","Edo_Estado","Cat_Estado","","Edo_Estado",
                                    Parametro("Edo_ID",-1),0,"Selecciona","Editar")%>
                                </div>
                            </div> 
                            
                            <div class="row form-group">
                                <label class="control-label col-md-2">Liberado</label>
                                <div class="col-md-4 checkbox-inline">
                                    <input type="checkbox" id="Pro_EsDesbloqueado" class="CheckBoxInput">
                                </div>
                                <label class="control-label col-md-2">Fecha caducidad almac&eacute;n</label>
                                <div class="col-md-4">
                                    <input autocomplete="off" value="<%=Parametro("Pro_FechaCaducidad","")%>" placeholder="D&iacute;as" class="form-control getdatos" id="Pro_FechaCaducidad" type="text">
                                </div>
                            </div> 
<!-------------------Codigos---------------------------------------------------->        
                        <div class="form-group Espacio">
                            <legend class="control-label col-md-3 ColorTitulo">C&oacute;digos&nbsp;&nbsp;<i class="fa fa-barcode"></i></legend>
                        </div>
                    		<div class="row form-group">
                                <label class="control-label col-md-2">UPC</label>
                                <div class="col-md-4">
                                    <input autocomplete="off" value="<%=Parametro("Pro_UPC","")%>" placeholder="C&oacute;digo Universal de Producto" class="form-control getdatos" id="Pro_UPC" type="text">
                                </div>
                                <label class="control-label col-md-2">EAN</label>
                                <div class="col-md-4">
                                    <input autocomplete="off" value="<%=Parametro("Pro_EAN","")%>" placeholder="European Article Number" class="form-control getdatos" id="Pro_EAN" type="text">
                                </div>
                            </div>
                            <div class="row form-group">
                                <label class="control-label col-md-2">C&oacute;digo de marca</label>
                                <div class="col-md-4">
                                    <input autocomplete="off" maxlength="2" pattern="[A-Za-z]{2}" onkeyup="javascript:this.value=this.value.toUpperCase();" 
                                    title="EJEMPLO Nokia: NK, con limite de 2 letras"
                                     placeholder="C&oacute;digo del producto" value="<%=Parametro("Pro_CodigoMarca","")%>" class="form-control getdatos" id="Pro_CodigoMarca" type="text">
                                </div>
                                <label class="control-label col-md-2">C&oacute;digo de desbloqueo</label>
                                <div class="col-md-4">
                                    <input autocomplete="off" value="<%=Parametro("Pro_DesbloqueoCodigo","")%>" placeholder="C&oacute;digo de desbloqueo" class="form-control getdatos" id="Pro_DesbloqueoCodigo" type="text">
                                </div>
                            </div> 
<!-------------------RFID---------------------------------------------------->        
                        <div class="form-group Espacio">
                            <legend class="control-label col-md-3 ColorTitulo">RFID&nbsp;&nbsp;<i class="fa fa-tags"></i></legend>
                        </div>
                    		<div class="row form-group">
                                <label class="control-label col-md-2">RFID</label>
                                <div class="col-md-4">
                                    <%CargaCombo("Pro_RFIDCG160"," class='form-control getdatos'","Cat_ID","Cat_Nombre","Cat_Catalogo","Sec_ID = 160","Cat_Nombre",
                                    -1,0,"Selecciona","Editar")%>
                                </div>
                                <label class="control-label col-md-2">D&iacute;gitos</label>
                                <div class="col-md-4">
                                    <input autocomplete="off" value="<%=Parametro("Pro_RFID_Digitos","")%>" placeholder="Digitos del RFID" class="form-control getdatos" id="Pro_RFID_Digitos" type="text">
                                </div>
                            </div>
                            <div class="row form-group">
                                <label class="control-label col-md-2">Prefijo de RFID</label>
                                <div class="col-md-4">
                                    <input autocomplete="off" value="<%=Parametro("Pro_PrefijoRFID","")%>" placeholder="Prefijo de rfid" class="form-control getdatos" id="Pro_PrefijoRFID" type="text">
                                </div>
                            </div> 
<!-------------------Medidas---------------------------------------------------->        
                        <div class="form-group  Espacio">
                            <legend class="control-label col-md-3 ColorTitulo">Medidas&nbsp;&nbsp;<i class="fa fa-arrows"></i></legend>
                        </div>
                            <div class="row form-group">
                                 <label class="control-label col-md-2"><strong>Dimensiones</strong> <span class="text-muted">(cm)</span></label>
                                <div class="col-md-4">
                                    <div class="dimension-fields">
                                        <span class="dimension-input"><input value="<%=Parametro("Pro_DimLargo","")%>" class="form-control getdatos text-center" autocomplete="off" id="Pro_DimLargo" placeholder="Longitud" type="text"></span> <span class="dimension-seperator">x</span><span class="dimension-input"><input autocomplete="off" placeholder="Ancho" value="<%=Parametro("Pro_DimAncho","")%>" id="Pro_DimAncho" class="form-control getdatos text-center" type="text"></span> <span class="dimension-seperator">x</span> <span class="dimension-input"><input autocomplete="off"  value="<%=Parametro("Pro_DimAlto","")%>" placeholder="Altura" id="Pro_DimAlto" class="form-control getdatos text-center" type="text"></span>
                                    </div>
                                </div>
                                <label class="control-label col-md-2">Tama&ntilde;o</label>
                                <div class="col-md-4">
                                    <%CargaCombo("Tam_ID"," class='form-control getdatos'","Tam_ID","Tam_Nombre","Cat_Tamanio","","Tam_Nombre",
                                    Parametro("Tam_ID",-1),0,"Selecciona","Editar")%>
                                </div>
                            </div>
                            <div class="row form-group">
                                <label class="control-label col-md-2">Peso neto<span class="text-muted">(kg)</span></label>
                                <div class="col-md-4">
                                    <input class="form-control getdatos" value="<%=Parametro("Pro_PesoNeto","")%>" autocomplete="off" placeholder="Peso sin la caja" id="Pro_PesoNeto" type="text">
                                </div>
                            </div>
                            <div class="row form-group">
                                <label class="control-label col-md-2">Peso bruto <span class="text-muted">(kg)</span></label>
                                <div class="col-md-4">
                                    <input autocomplete="off" value="<%=Parametro("Pro_PesoBruto","")%>" placeholder="Peso con todo y caja" class="form-control getdatos" id="Pro_PesoBruto" type="text">
                                </div>
                                <label class="control-label col-md-2">Volumen</label>
                                <div class="col-md-4">
                                    <input autocomplete="off" placeholder="Volumen" value="<%=Parametro("Pro_Volumen","")%>" class="form-control getdatos" id="Pro_Volumen" type="text">
                                </div>
                            </div> 
<!-------------------Extras---------------------------------------------------->     
						<div id="divAddExtras">   
                            <div class="form-group Espacio">
                                <legend class="control-label col-md-3 ColorTitulo">Extras&nbsp;&nbsp;<i class="fa fa-plus"></i></legend>
                            </div>
                            <div class="form-group">
                                <label class="control-label col-md-2"><strong>Extras</strong></label>
                                <div class="col-md-4" id="btnExtras">
                                    <div class="input-group">
                                        <button type="button" class="btn btn-sm btn-info btnAddExt"><i class="fa fa-plus"></i>&nbsp;Agregar</button></span>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group">
                                <div id="dvextras">
						   <%
                           
                        var sSQLExtras = "SELECT * "
                            sSQLExtras += " FROM Producto_Extras "
                            sSQLExtras += " WHERE Pro_ID = " + Pro_ID
        
                            var iPro_ID = -1
                            var iProE_ID = -1
                            var sProE_ID = ""
                            var ProE_Nombre = ""
                            var ProE_Valor = ""
        
                            Renglon = 0
                            iRegistros = 0
        
                            var rsExt = AbreTabla(sSQLExtras,1,0)
        
                            while (!rsExt.EOF){
        
                                Renglon++
                                iRegistros++
        
                                iPro_ID = rsExt.Fields.Item("Pro_ID").Value
                                iProE_ID = rsExt.Fields.Item("ProE_ID").Value	
                                ProE_Nombre = rsExt.Fields.Item("ProE_Nombre").Value
                                ProE_Valor = rsExt.Fields.Item("ProE_Valor").Value
        
                                sProE_ID = " data-proeid='"+iProE_ID+"'"
        
                            %>
                                <div class="form-group" id="renglonExt<%=iProE_ID%>">
                                    <label class="control-label col-md-2">&nbsp;</label>
                                   <div class="col-md-8">
                                        <div class="input-group">
                                            <div class="col-md-4">
                                                <input class="form-control datosextras" autocomplete="off" value="<%=ProE_Nombre%>" id="ProE_Nombre<%=iProE_ID%>" placeholder="Nombre" type="text">
                                            </div>
                                            <div class="col-md-4">
                                                <input class="form-control datosextras" autocomplete="off" value="<%=ProE_Valor%>" id="ProE_Valor<%=iProE_ID%>" placeholder="Valor" type="text">
                                            </div>
                                            <div class="col-md-4">
                                                <div aria-label="Basic example" class="btn-group" role="group">
                                                    <button class="btn btn-danger btnDelExt datosextras" <%=sProE_ID%> type="button"><i class="fa fa-trash"></i></button>&nbsp;<button class="btn btn-primary btnSaveExt datosextras" <%=sProE_ID%> type="button"><i class="fa fa-save"></i></button>
                                                </div>
                                            </div>                                
                                        </div>
                                    </div>
                                </div>
                            <%	
                            
                                rsExt.MoveNext() 
                            }
                            
                            rsExt.Close()   
                            %>
                                </div>
                        </div> 
<!-------------------Guardar Producto---------------------------------------------------->        
                            <div class="form-group" id="botonesEditar" style="text-align:end;display:none" >
                              <button type="button" class="btn btn-md btn-info btnEditarPro">Editar</button>
                                <div class="btn-group" role="group" aria-label="Basic example">
                                  <button type="button" class="btn btn-md btn-danger btnCancelarPro">Cancelar</button>
                                  <button type="button" class="btn btn-md btn-success btnGuardarPro"><i class="fa fa-save"></i>&nbsp;&nbsp;Guardar producto</button>
                                </div>
                            </div>
                    </div> 
                </div>
            </div>
        </div>
    </div>    
</div>
<input type="hidden" id="Pro_ID" value="<%=Pro_ID%>"/>
<script src="/Template/inspina/js/plugins/dropzone/dropzone.js"></script>
<script src="/Template/inspina/js/plugins/iCheck/icheck.min.js"></script>

<script>
Dropzone.autoDiscover = false;

$(document).ready(function(){
	
	var Pro_ID = <%=Pro_ID%>
	var ProE_ID = <%=MaxProE_ID%>
	
	$('#botonesEditar').css('display','block')
	
	if(Pro_ID > -1){
		$('.getdatos').prop("disabled", true);
		$('.CheckBoxInput').iCheck('disable')
		$('.btnCancelarPro').hide()
		$('.btnGuardarPro').hide()
		$('#btnExtras').hide()
		$('.datosextras').prop("disabled", true);
	}else{
		$('.btnEditarPro').hide()
		$('.btnCancelarPro').hide()
	}
	

	$('.btnEditarPro').click(function(e) {
        e.preventDefault()
		$('.getdatos').hide('slow')
		$('.getdatos').prop("disabled", false);
		$('.datosextras').prop("disabled", false);
		$('.getdatos').show('slow')
		$(this).hide('slow')
		$('.btnGuardarPro').text('Guardar cambios')
		$('.btnCancelarPro').show('slow')
		$('.btnGuardarPro').show('slow')
		$('#btnExtras').show('slow')
    });
	$('.btnCancelarPro').click(function(e) {
        e.preventDefault()
		$('.getdatos').hide('slow')
		$('.getdatos').prop("disabled", true);
		$('.datosextras').prop("disabled", true);
		$('.getdatos').show('slow')
		$('.btnCancelarPro').hide('slow')
		$('.btnGuardarPro').hide('slow')
		$('.btnEditarPro').show('slow')
		$('#btnExtras').hide()
    });
	$('.btnGuardarPro').click(function(e) {
        e.preventDefault()
		swal({
			title: "&iquest;Deseas guardar el producto &quot;"+$('#Pro_Nombre').val()+"&quot;?",
			text: "<strong>Para poder agregar cualquier campo extra se debe de guardar el producto</strong>",
			type: "info",
			showCancelButton: true,
			confirmButtonColor: "#57D9DF",
			confirmButtonText: "Si, adelante!",
			closeOnConfirm: true,
			closeOnCancel: true,
			html: true
		}, function (data) {
			if(data){
				$('#btnExtras').hide()
				GetData()
				//GetRelacion()
				
			}else{
				var texto = "El producto NO se guardo!"
				var cuerpo = "<strong>No has guardado el producto, si sales de est&a ventana se perder&aacute; la informaci&oacute;n.</strong>"
				var tipo = "warning"
				AlertSweet(texto,cuerpo,tipo)
			}
		});

    });
	
	$('.CheckBoxInput').iCheck({  checkboxClass: 'icheckbox_square-green' }); 
	$('.CheckBoxInput').on('ifChanged', function(event) {
			if(event.target.checked) {
					var Nombre = $(this).attr('id')	
					var Valor = $(this).val()
				console.log("Check en "+Nombre+" "+Valor);
			}
	});
	$('.CheckBoxInput').on('ifUnchecked', function(event) {			
				var Nombre = $(this).attr('id')	
				var Valor = 0
				console.log("Uncheck en "+Nombre+" "+Valor);

	});
	var fileSubir = []
	$("#dropzoneForm").dropzone({  
			url:"#",
			addRemoveLinks: true,
			removedfile:function(file) {
				
			var pos = fileSubir.indexOf(file.name); 
				fileSubir.splice(pos, 1)
				
			var _ref;
			return (_ref = file.previewElement) != null ? _ref.parentNode.removeChild(file.previewElement) : void 0;        
			 },
			acceptedFiles:"image/*",
			paramName: "NomArchivo", // The name that will be used to transfer the file
            maxFilesize: 2, // MB
			accept: function (file, done) {
				$("#dropImagen").html(file)
				console.log(file)
				console.log(this) 
				done()
				//fileSubir[file.name] = file
				FileUploadPro(file)
			}
   });
   $('#btnSubirDocs').click(function(e) {
		e.preventDefault()
		console.log(fileSubir)
    });

});

function GetRelacion(){
	$.post("/pz/wms/Articulos/Productos/NuevoProducto_Relacion.asp", function(data){
		$('.Esconde').hide('slow')
		$('#MoveRight').hide('slow')
		$('#MoveRight').removeClass('col-lg-8')
		$('#Relacion').hide('slow')
		$('#MoveRight').addClass('col-lg-4')
		$('#Relacion').html(data)
		$('#Relacion').addClass('col-lg-8')
		$('#MoveRight').show('slow')
		$('#Relacion').show('slow')
		$('#Relacion').focus()
	});				
}

	$('.TPro_ID').change(function(e) {
		e.preventDefault()
		$(".clean").hide('slow')
		$(".clean").html("")
		NuevaOrden.GetCategoria($(this))
		$(".clean").show('slow')
	});
	
	$("#cmboCategoria").on("change", ".ProC_ID", function(){
		$(".clean").hide('slow')
		NuevaOrden.GetSubCategoria($(this))
		$(".clean").show('slow')
    });
	
function FileUploadPro(file){

	var form = new FormData();
	form.append("", file);
	form.append("RutaBD", "Media/wms/Producto/");
	form.append("Llave", "Pro_ID");
	form.append("Llave_Valor", $('#Pro_ID').val());
	form.append("Doc_ID", "100");
	form.append("BD", "WMS");
	form.append("IDUsuario", $('#IDUsuario').val());
	form.append("Table", "Producto_Documentos");
	form.append("Keys", $('#Pro_ID').val()+"_100_");
	form.append("Route", "C:/AGT/www/Media/wms/Producto");
	
	$.ajax({
		method: 'post',
		processData: false,
		contentType: false,
		cache: false,
		data: form,
		enctype: 'multipart/form-data',
		url: 'http://198.38.94.238:8543/api/iqon/CargaDocumentos',
		success: function (data) {
			console.log(data)			
		}
	});	
}

function GetData(){
	
	var map = {};
	$(".getdatos").each(function() {
		map[$(this).attr("id")] = $(this).val()
	});
	$.each($("input[class='CheckBoxInput']:checked"), function(){
		map[$(this).attr("id")] = 1
	});
			
	map[$('#Pro_ID').attr("id")] = $('#Pro_ID').val()
	map['Pro_Usuario'] = $('#IDUsuario').val()
	map['Tarea'] = 15
	console.log(map)
	$.post("/pz/wms/Articulos/Productos/NuevoProducto_Ajax.asp",map
    , function(data){
		console.log(data)

		if(data > 0){
			$('.btnCancelarPro').hide('slow')
			$('.btnGuardarPro').hide('slow')
			$('.btnEditarPro').show('slow')
			$('.getdatos').prop("disabled", true);
			$('.datosextras').prop("disabled", true);
			$('#Pro_ID').val(data)
			var texto = $('#Pro_Nombre').val()
			var cuerpo = "El producto "+texto+" se ha guardado exitosamente!"
			var tipo = "success"
			AlertSweet(texto,cuerpo,tipo)
		}
		
	});
}

function AlertSweet(T,b,t){
	swal({
		title: T,
		text: b,
		type: t,
		confirmButtonColor: "#57D9DF",
		confirmButtonText: "Ok!",
		closeOnConfirm: true,
		html: true
	}, function (data) {
		
	});
}

function UploadImg(file){
	
	var that = this;
	var formData = new FormData();

	// add assoc key values, this will be posts values
	formData.append("file", this.file, this.getName());
	formData.append("upload_file", true);
	
	$.ajax({
            type: "POST",
            beforeSend: function(request) {
                request.setRequestHeader("Authorization", "Bearer" + " " + localStorage.getItem("accessToken"));
                
            },
            url: "https://www.googleapis.com/upload/drive/v2/files",
            data:{
                uploadType:"media"
            },
            success: function (data) {
                console.log(data);
            },
            error: function (error) {
                console.log(error);
            },
            async: true,
            data: formData,
            cache: false,
            contentType: false,
            processData: false,
            timeout: 60000
        });
}
// ========================================== Extras =================================== 		
var nextinput = <%=MaxProE_ID%>;
var sinput = '';
	
$(".btnAddExt").click(function(event) {
	event.preventDefault();		
	if($("#Pro_ID").val()>0){
		nextinput++;
		var o = $(this);
	
			sinput = '<div class="form-group" id="renglonExt' + nextinput + '">'
				sinput += '<label class="control-label col-md-2">&nbsp;</label>'
				sinput += '<div class="col-md-8">'
					sinput += '<div class="input-group">'
						sinput += '<div class="col-md-4"><input type="text" placeholder="Nombre" autocomplete="off" class="form-control" id="ProE_Nombre' + nextinput + '"></div><div class="col-md-4"><input type="text" autocomplete="off" placeholder="Valor" class="form-control" id="ProE_Valor' + nextinput + '"></div><div class="col-md-4"><div class="btn-group" role="group" aria-label="Basic example"><button type="button" class="btn btn-danger btnDelExt" data-proeid="' + nextinput + '"><i class="fa fa-trash"></i></button></span>&nbsp;<button type="button" class="btn btn-primary btnSaveExt" data-proeid="' + nextinput + '"><i class="fa fa-save"></i></button></div></div>'
					sinput += '</div>'
				sinput += '</div>'
			sinput += '</div>'
			
			$("#dvextras").append(sinput);
			$("#renglonExt"+nextinput).hide()
			$("#renglonExt"+nextinput).show('slow')
	}else{
		var texto = "Primero genera el nuevo producto"
		var cuerpo = "<strong>&iexcl;Antes de colocar los extras se debe de guardar el producto!</strong>"
		var tipo = "warning"
		AlertSweet(texto,cuerpo,tipo)
	}
		
});	

	
var sMensaje = "";
var sTipo = "";

$("#frmDatos").on("click", ".btnSaveExt", function(){
	var o = $(this);
	var ProE_ID = o.data("proeid");

	var Nombre = $("#ProE_Nombre"+ProE_ID).val();
	var Valor = $("#ProE_Valor"+ProE_ID).val();
		//alert(sSerFolNoFolio);
	// /pz/agt/Formatos/AgregaCampo_Ajax.asp
	if(Nombre != "" && Valor != ""){
	$.post("/pz/wms/Articulos/Productos/NuevoProducto_Ajax.asp",{
		Tarea:1
		,Pro_ID:$("#Pro_ID").val()
		,ProE_ID:ProE_ID
		,ProE_Nombre:Nombre
		,ProE_Valor:Valor 
		,IDUsuario:$("#IDUsuario").val()
	}
    , function(data){
		  
			var sTmp = String(data); 
				arrDatos = sTmp.split("|");	

			if (arrDatos[0] == 1) {
				sTipo = "info";
				sMensaje = "El registro se ha guardado correctamente ";
				o.prop('disabled', true);
				
			} else {
				sTipo = "warning";
				sMensaje = "Ocurrio un error al realizar el guardado";
				
			}
			Avisa(sTipo,"Aviso",sMensaje);
	});
	}else{
		sTipo = "error";
		sMensaje = "No se ha colocado informaci&oacute;n";
		Avisa(sTipo,"Aviso",sMensaje);
		$("#renglonExt"+ProE_ID).addClass('has-error')
		setTimeout(function(){
		$("#renglonExt"+ProE_ID).removeClass('has-error')
			},3500)
	}
	
});

$("#frmDatos").on("click", ".btnDelExt", function(){
	var o = $(this);

	var ProE_ID = o.data("proeid");

	$.post("/pz/wms/Articulos/Productos/NuevoProducto_Ajax.asp",{
		Tarea:2
		,Pro_ID:$("#Pro_ID").val()
		,ProE_ID:ProE_ID
		}
    , function(data){
		  console.log(data)
			var sTmp = String(data); 
				arrDatos = sTmp.split("|");	

			if (arrDatos[0] == 1) {
				sTipo = "info";
				sMensaje = "El registro se ha eliminado correctamente ";
				$("#renglonExt"+ProE_ID).hide('slow')
				setTimeout(function(){
				$("#renglonExt"+ProE_ID).remove();
					},400)
				
			} else {
				sTipo = "warning";
				sMensaje = "Ocurrio un error al realizar el guardado";
				
			}

			Avisa(sTipo,"Aviso",sMensaje);

	});				
	
});
	
	
// ========================================== Extras ===================================
var NuevaOrden = {
	GetCategoria:function(dato){
		$.post("/pz/wms/Articulos/Productos/NuevoProducto_Ajax.asp",{
			Tarea:3
			,TPro_ID:dato.val()
			}
		, function(data){
			$('#cmboCategoria').html(data)
		});				
	},
	GetSubCategoria:function(dato){
		$.post("/pz/wms/Articulos/Productos/NuevoProducto_Ajax.asp",{
			Tarea:4
			,TPro_ID:$(".TPro_ID").val()
			,ProC_ID:dato.val()
			}
		, function(data){
			$('#cmboSubCategoria').html(data)
		});				
	}
}
</script>




