<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include file="../../../Includes/iqon.asp" -->


<%
	var Pro_ID = Parametro("Pro_ID",-1)
	var Pt_ID = Parametro("Pt_ID",-1)
	var MultiplesPallets = Parametro("MultiplesPallets",-1)

	var sSQL = "SELECT Pro_SKU,Pro_EsSerializado,Pro_SerieDigitos,Pro_RFIDCG160,Pro_Nombre "
			+ " FROM Producto "
			+ " WHERE Pro_ID = "+Pro_ID
			

	ParametroCargaDeSQL(sSQL,0)
	
	var Pro_EsSerializado = Parametro("Pro_EsSerializado",-1)
	var Pro_RFIDCG160 = Parametro("Pro_RFIDCG160",-1)
	var Pt_EsCuarentena = Parametro("Pt_EsCuarentena",0)
	
	
	var Pt_Color = ""
	var Ubi_Nombre = "Sin ubicaci&oacute;n"
	var Pt_LPNCliente = ""
	var Pt_MB = ""
	var Pt_PiezaXMB = ""
	var Pt_Cantidad = ""
	var Pt_CantidadEsperada = ""
	if(Pt_ID > -1){
		
		var PalletConfi = "SELECT a.*,ISNULL(Ubi_Nombre,'Sin ubicaci&oacute;n') Ubi "
						+ " FROM Recepcion_Pallet a "
						+ " LEFT JOIN Ubicacion u "
							+ " ON a.Ubi_ID = u.Ubi_ID "
						+ " WHERE a.Pt_ID ="+Pt_ID
		
		var rsPallets = AbreTabla(PalletConfi, 1, 0)
		
		if(!rsPallets.EOF && rsPallets){ 
			Pt_Color = rsPallets.Fields.Item("Pt_Color").Value
			Pt_LPNCliente = rsPallets.Fields.Item("Pt_LPNCliente").Value
			Ubi_Nombre = rsPallets.Fields.Item("Ubi").Value
			Pt_MB = rsPallets.Fields.Item("Pt_MB").Value
			Pt_PiezaXMB = rsPallets.Fields.Item("Pt_PiezaXMB").Value
			Pt_Cantidad = rsPallets.Fields.Item("Pt_Cantidad").Value
			Pt_CantidadEsperada = rsPallets.Fields.Item("Pt_CantidadEsperada").Value
		}
		rsPallets.Close()
	}
	
	
%>

<link href="/Template/inspina/css/plugins/iCheck/green.css" rel="stylesheet">

<div class="ibox-title">
    <h4 class="text-navy">Configuraci&oacute;n actual del producto</h4>
    <small class="font-bold text-warning"><i class="fa fa-info-circle"></i>&nbsp;Si la configuraci&oacute;n esta correcta no es necesario realizar algun cambio</small>
    <br>
</div> 
	<hr />
    <div class="form-group">
        <label  class="control-label col-md-2"><strong>SKU</strong></label>
        <legend class="col-md-3"><h3><%=Parametro("Pro_SKU","N/A")%></h3></legend>
        <label  class="control-label col-md-3"><strong>Nombre</strong></label>
        <legend class="col-md-4"><h3><%=Parametro("Pro_Nombre","N/A")%></h3></legend>
    </div> 
    
    <div class="form-group">
        <label class="control-label col-md-2"><strong>Digitos serie</strong></label>
        <div class="col-md-3">
            <input class="form-control ProductoConf" id="Pro_SerieDigitos" value="<%=Parametro("Pro_SerieDigitos",0)%>" placeholder="Cantidad de caracteres" type="number" min="1" max="21" autocomplete="off"/>
        </div>
    </div>
    <div class="form-group">
        <label class="control-label col-md-2"><strong>Serializar</strong></label>
        <div class="col-md-3">
            <label class="radio-inline"><input class="radioOpt ProductoBtn" type="radio" name="Serializar" <%if(Pro_EsSerializado == 1){Response.Write("checked")}%> value="1">&nbsp;<strong>Si</strong></label>
            <label class="radio-inline"><input class="radioOpt ProductoBtn" type="radio" name="Serializar" <%if(Pro_EsSerializado == 0){Response.Write("checked")}%> value="0">&nbsp;<strong>No</strong></label>
        </div>
        <label class="control-label col-md-2"><strong>Requiere RFID</strong></label>
        <div class="col-md-3">
            <label class="radio-inline"><input class="radioOpt ProductoBtn" type="radio" name="Pro_RFIDCG160" <%if(Pro_RFIDCG160 == 1){Response.Write("checked")}%> value="1">&nbsp;<strong>Si</strong></label>
            <label class="radio-inline"><input class="radioOpt ProductoBtn" type="radio" name="Pro_RFIDCG160" <%if(Pro_RFIDCG160 == 0){Response.Write("checked")}%> value="0">&nbsp;<strong>No</strong></label>
        </div>
    </div>
    <div class="form-group">
        <div class="col-md-12 text-right">
            <a class="btn btn-info" onclick="GridFunctions.Editar($(this))"><i class="fa fa-pencil"></i> Editar</a>
        </div>
    </div>
	<%if(MultiplesPallets == 1){%>
    <div class="ibox-title text-navy">
        <h4>Configuraci&oacute;n de pallets masivo</h4>
        <small class="font-bold text-warning"><i class="fa fa-info-circle"></i>&nbsp;Esta opci&oacute;n permite al usuario poder crear multiples pallets a la veces, el m&aacute;ximo de pallets multiples que se pueden crear a la vez es de 25, si se requieren crear m&aacute;s
        es posible volver a abrir la ventana para crear de nuevo otros 25 pallets</small>
    </div>
	<hr />	
    <div class="form-group">
        <label class="control-label col-md-2 text-warning"><strong>Cantidad pallets</strong></label>
        <div class="col-md-3">
            <input class="form-control" id="Pt_CantidadPallets" placeholder="Numero de pallets" type="number" autocomplete="off" value="1"/> 
        </div>
    </div>
	<%}else{%>
    <div class="ibox-title text-navy">
        <h4>Configuraci&oacute;n del pallet</h4>
    </div>
	<hr />	
    <%}%>
    <div class="form-group">
    	<%
		var ColocaRFID = "none"
		if(Pro_RFIDCG160 == 1){
			ColocaRFID = "block"			
		}%>
        <div id="ColocaRFID" style="display:<%=ColocaRFID%>;">
            <label class="control-label col-md-2"><strong>Etiqueta RFID</strong></label>
            <div class="col-md-3">
                <%var sCondicion = "Pro_EsInsumo=1 AND TPro_ID= 15  AND Pro_Habilitado =1 AND Pro_Disponible > 0"
                CargaCombo("Pro_ID_RFID",'class="form-control"',"Pro_ID","Pro_Nombre","Producto",sCondicion,"",-1,0,"Selecciona Etiqueta")%>
            </div>
        </div>
        <label class="control-label col-md-2"><strong>Es cuarentena</strong></label>
        <div class="col-md-3">
            <label class="radio-inline"><input class="radioOpt" type="radio" name="Pt_EsCuarentena" <%if(Pt_EsCuarentena == 1){Response.Write("checked")}%> value="1">&nbsp;<strong>Si</strong></label>
            <label class="radio-inline"><input class="radioOpt" type="radio" name="Pt_EsCuarentena" <%if(Pt_EsCuarentena == 0){Response.Write("checked")}%> value="0">&nbsp;<strong>No</strong></label>
        </div>
    </div>
    <div class="form-group">
        <label class="control-label col-md-2"><strong>LPN cliente</strong></label>
        <div class="col-md-3">
            <input class="form-control" id="Pt_LPNCliente" placeholder="LPN del cliente" value="<%=Pt_LPNCliente%>" type="text" autocomplete="off"/>
        </div>
        <label class="control-label col-md-2"><strong>Color</strong></label>
        <div class="col-md-3">
            <input class="form-control" id="Pt_Color" value="<%=Pt_Color%>" placeholder="Color del producto" type="text" autocomplete="off"/> 
        </div>
    </div>
    <div class="form-group">
        <label class="control-label col-md-2">Ubicaci&oacute;n</label>
        <label class="control-label col-md-3" id="lblUbiNombre"><%=Ubi_Nombre%></label>
    </div>
    <div class="form-group">
        <div class="col-md-5 text-right">
            <a class="btn btn-primary" data-toggle="modal" 
            data-target="#myModal" 
            onclick="Ubicacion.SeleccionAvanzadaAbrir({Selector: 'inpUbiID', Etiqueta: 'lblUbiNombre'});"><i class="fa fa-plus"></i>&nbsp;Ubicaci&oacute;n</a>
        </div>
    </div>
     
	<hr />	
    <div class="form-group">
        <label class="control-label col-md-2"><strong>Cantidad masters</strong></label>
        <div class="col-md-3">
            <input class="form-control" id="Pt_MB" value="<%=Pt_MB%>" disabled="disabled" placeholder="Cantidad de masters" type="number" min="1" />
        </div>
        <label class="control-label col-md-2"><strong>Piezas por master</strong></label>
        <div class="col-md-3">
            <input class="form-control" id="Pt_PiezaXMB" value="<%=Pt_PiezaXMB%>" placeholder="Piezas por master" min="1" type="number" />
        </div>
    </div>
    
	<hr />	
    <div class="form-group">
        <label class="control-label col-md-2"><strong>Piezas esperadas</strong></label>
        <div class="col-md-3">
            <input class="form-control" id="Pt_CantidadEsperada" value="<%=Pt_CantidadEsperada%>" placeholder="Piezas esperadas" type="number" min="1" />
        </div>
        <label class="control-label col-md-2"><strong>Piezas recibidas</strong></label>
        <div class="col-md-3">
            <input class="form-control" id="Pt_Cantidad" value="<%=Pt_Cantidad%>"  placeholder="Piezas recibidas" type="number" min="1" />
        </div>
    </div>
        
        
        
<input type="hidden" id="Ubi_ID" value="-1"/>
<input type="hidden" id="ProductoEditado" value="0"/>
<%
var urlBase = "/pz/wms/Almacen/"
%>
<script src="/Template/inspina/js/plugins/iCheck/icheck.min.js"></script>
<script type="text/javascript" src="<%=urlBase%>Catalogo/js/Catalogo.js"></script>
<script type="text/javascript" src="<%=urlBase%>Ubicacion/js/Ubicacion.js"></script>
<script type="text/javascript" src="<%=urlBase%>Ubicacion_Area/js/Ubicacion_Area.js"></script>
<script type="text/javascript" src="<%=urlBase%>Ubicacion_Rack/js/Ubicacion_Rack.js"></script>

<script type="application/javascript">

$('.ProductoConf').prop('disabled',true);
$('.ProductoBtn').iCheck('disable');

$('#Pt_Cantidad').blur(function(e) {
	ColocaValor()
});

$('#Pt_PiezaXMB').blur(function(e) {
	ColocaValor()
});

var GridFunctions = {
	Editar:function(inp){
		inp.hide('fast')
		var e = $('.ProductoConf');
		if(e.is(':disabled')){
			e.prop('disabled',false);
			$('#ProductoEditado').val(1)
			$('.ProductoBtn').iCheck('enable');
			inp.removeClass('btn-info').addClass('btn-danger');
			inp.html('<i class="fa fa-times"></i> Cancelar');
		}else{
			swal({
				title: "Cancelar edici&oacute;n",
				text: "Si cancela la edici&oacute;n se restablecera la configuraci&oacute;n actual",
				type: "warning",
				showCancelButton: true,
				confirmButtonColor: "#DD6B55",
				confirmButtonText: "Si, cancelar!",
				closeOnConfirm: true,
				html:true
			},function (data) {
				if(data){
					$('#Pro_SerieDigitos').val(<%=Parametro("Pro_SerieDigitos",0)%>)
					$('input[name=Pro_RFIDCG160][value=<%=Pro_RFIDCG160%>]').iCheck('check')
					$('input[name=Serializar][value=<%=Pro_EsSerializado%>]').iCheck('check')
					e.prop('disabled',true);
					$('#ProductoEditado').val(0)	
					$('.ProductoBtn').iCheck('disable');
					inp.removeClass('btn-danger').addClass('btn-info');
					inp.html('<i class="fa fa-pencil"></i> Editar');
				}
			});			
			
		}
		inp.show('fast')
	}
	
}
function ColocaValor(){
	var Result = parseInt($("#Pt_Cantidad").val()) / parseInt($("#Pt_PiezaXMB").val())
	$('#Pt_MB').val(Math.ceil(Result))
}



$('.radioOpt').iCheck({  radioClass: 'iradio_square-green', }); 


$('input[name="Pro_RFIDCG160"]').on('ifChanged', function (event) {
       if(this.value == 1){
		   $('#ColocaRFID').css('display','block');
		   $('#ColocaRFID').addClass('has-success');
	   }else{
		   $('#ColocaRFID').css('display','none');
		   $('#Pro_ID_RFID').val(-1)
	   }
});

</script>        
