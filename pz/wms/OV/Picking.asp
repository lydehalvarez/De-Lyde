<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include file="../../../Includes/iqon.asp" -->

<%

	var OV_ID = Parametro("OV_ID",-1)
	
	var sSQLOV = "SELECT TOP 1 * "
		sSQLOV += "FROM Izzi_Orden_Venta WHERE OV_ID = " + OV_ID
		
		bHayParametros = false
		ParametroCargaDeSQL(sSQLOV,0)
	var Folio = Parametro("OC_Folio",-1)
	var CUSTOMER_NAME = Parametro("CUSTOMER_NAME",-1)
	var SHIPPING_ADDRESS = Parametro("SHIPPING_ADDRESS",-1)
		
 
	var sSQLGrid = "SELECT count(OV_ID) as OVID,OVA_PART_NUMBER "
		sSQLGrid += " ,(SELECT Pro_Nombre FROM Producto p WHERE p.Pro_SKU = O.OVA_PART_NUMBER OR p.Pro_ClaveAlterna = O.OVA_PART_NUMBER ) as Nombre "
		sSQLGrid += " ,(SELECT Pro_Descripcion FROM Producto p WHERE p.Pro_SKU = O.OVA_PART_NUMBER OR p.Pro_ClaveAlterna = O.OVA_PART_NUMBER  ) as Descripcion "
		sSQLGrid += " ,(SELECT Pro_ID FROM Producto p WHERE p.Pro_SKU = O.OVA_PART_NUMBER OR p.Pro_ClaveAlterna = O.OVA_PART_NUMBER  ) as ProID "
		sSQLGrid += " FROM Orden_Venta_Articulo O "
		sSQLGrid += " WHERE OV_ID = " +OV_ID 
		sSQLGrid += " GROUP BY  OV_ID, Pro_ID,OVA_PART_NUMBER "
		 
		 
	   var rsProductos = AbreTabla(sSQLGrid,1,0)
	 
		 
	var sSQLCue = "SELECT Count(Inv_ID) as Cuenta,Count(OV_ID) ToltalArticulos "
		sSQLCue += "FROM Orden_Venta_Articulo"
		sSQLCue += " WHERE OV_ID = " +OV_ID 
		
	var rsCue = AbreTabla(sSQLCue,1,0)
	if (!rsCue.EOF){
		var Realizados  = rsCue.Fields.Item("Cuenta").Value
		var LimiteArcticulos  = rsCue.Fields.Item("ToltalArticulos").Value
	}
	
	//Response.Write(OV_ID)
%>

<div class="form-horizontal" id="toPrint">
    <div class="row">
        <div class="col-lg-12">
            <div class="ibox float-e-margins">
                <div class="ibox-content">
                    <div class="form-group">
                        <legend class="control-label col-md-12" style="text-align: right;" id="OVName"><h1>Orden de venta&nbsp;<strong><%=Folio%></strong></i></h1></legend>
                     </div>
                    <div class="form-group" id="SeVan">
                       <div class="col-md-3">
                         <input type="text" autocomplete="off"  style="display:block" class="form-control" id="SerialNumber" value="" placeholder="SERIE">
                       </div>
                      <div class="col-lg-5"  style="text-align: right;">
                            <button class="btn btn-info btnRemision">Hoja remisi&oacute;n</button>
                            <button class="btn btn-success btnImprimir">Imprimir</button>
                      </div>
                     </div>
                     
                    <div class="col-md-5">
                        <table class="table">
                        <tr>
                        	<td colspan="5" style="text-align:center"><canvas id="barcode"></canvas></td>
                        </tr>
                        <tr>
                        	<td>Direcci&oacute;n:</td>
                        	<td colspan="4"><%=SHIPPING_ADDRESS%></td>
                        </tr>
                        <tr>
                        	<td>Destinatario:</td>
                        	<td colspan="4"><%=CUSTOMER_NAME%></td>
                        </tr>
                        </table>
                     </div>
                     
                     
                    <table class="table table-striped table-hover" id="PickingTabla">     
                    <thead>
                        <tr>
                            <th scope="col">Ubicaci&oacute;n</th>
                            <th scope="col">Nombre</th>
                            <th scope="col">Descripci&oacute;n</th>
                            <th scope="col">SKU</th>
                            <th scope="col">Cantidad</th>
                        </tr>
                    </thead>
                    <tbody>
                    <%
					   var sumatotal = 0
                        while (!rsProductos.EOF){
							
                            var Nombre = rsProductos.Fields.Item("Nombre").Value	
                            var Descripcion = rsProductos.Fields.Item("Descripcion").Value	
                            var Cantidad = rsProductos.Fields.Item("OVID").Value
                            var SKU = rsProductos.Fields.Item("OVA_PART_NUMBER").Value
                            var Pro = rsProductos.Fields.Item("ProID").Value
                            
                            sumatotal = sumatotal + Cantidad
                    %>			
                        <tr class="Producto<%=Pro%> info" id="Producto<%=Pro%>">
                            <td>Pendiente</td>
                            <td><strong><%=Nombre%></strong></td>
                            <td><%=Descripcion%></td>
                            <td><%=SKU%></td>
                            <td style="text-align: center;"><strong><%=Cantidad%></strong></td>
                        </tr>
                  <%
                        rsProductos.MoveNext() 
                    }
                    rsProductos.Close()   
                %>
                     </tbody>
                    </table>      
                </div>
            </div>
        </div>
    </div>    
</div>
<input type="hidden" id="OVP_Dupla" value=""/>
<input type="hidden" id="Esperado" value=""/>
<script src="/Template/inspina/js/plugins/JsBarcode/JsBarcode.all.min.js"></script>
<script type="application/javascript">
$(document).ready(function(e) {
	
	$('.btnImprimir').click(function(e) {
		e.preventDefault() 
		$('#SeVan').hide()
		var divToPrint=document.getElementById('toPrint');
		var newWin=window.open();
		newWin.document.open();
		newWin.document.write('<html><title>'+$('#OVName').text()+'</title>');
		newWin.document.write('<link href="http://wms.agtransportes.mx/Template/inspina/css/style.css" rel="stylesheet"><link href="http://wms.agtransportes.mx/Template/inspina/css/bootstrap.min.css" rel="stylesheet">');
		newWin.document.write('<body>'+divToPrint.innerHTML+'</body>');
		newWin.document.write('</html>');
		
		setTimeout(function(){
			newWin.print()
			newWin.close()
			
			},800)
		$('#SeVan').show()

	});
	$("#barcode").JsBarcode("<%=Folio%>",{
		displayValue:true,
		width:2
	});
	
});
	
$('#SerialNumber').on('keypress',function(e) {
	if(e.which == 13) {
		e.preventDefault()
		var codigo = $(this).val()
		Picked(codigo)

	}
});

$('.btnRemision').click(function(e) {
    e.preventDefault()
	window.open("http://wms.lyde.com.mx/pz/wms/OV/HojaRemision.asp?OV_ID="+<%=OV_ID%>)
});


$('.btnFinishPicking').click(function(e) {
    e.preventDefault()
	finishPicking()
});

function Picked(dato){
	$.post("/pz/wms/OV/OV_Ajax.asp",{
	Tarea:2,
	SerialNumber:dato,
	Esperado:$('#Esperado').val(),
	LimiteArticulos:<%=LimiteArcticulos%>,
	OV_ID:<%=OV_ID%>,
	IDUsuario:$('#IDUsuario').val(),
	OVP_Dupla:$('#OVP_Dupla').val()
	},function(data){
		var response = JSON.parse(data)
		
		$('#Esperado').val(response.Esperado)
		$('#OVP_Dupla').val(response.OVP_Dupla)
		//console.log(response)

	});
}

function finishPicking(){
	
		var data = {
			"Tarea":"1",
			"OV_ID":
		}
	var myJSON = JSON.stringify(data);
	
		$.ajax({
			type: 'post',
			contentType:'application/json',
			data: myJSON,
			url: "http://198.38.94.238:1117/lyde/api/ServiceZZ",
			success: function(datos){
			}
		});
	
}





</script>            