<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include virtual="/Includes/iqon.asp" -->

<%
var EsOV = Parametro("EsOV",-1)
var ID = Parametro("ID",-1)


	var Articulos = ""

if(EsOV == 0){
	Articulos = "SELECT TA_Folio as Folio,a.TA_ID as ID,TAA_ID as ident, TAA_SKU as SKU "
	Articulos += " ,TAA_Cantidad as Cantidad,TAA_CantidadNotaEntrada as CantidadDevuelta "
	Articulos += " ,Pro_EsSerializado as Serializado, Pro_Nombre "
	Articulos += " FROM TransferenciaAlmacen_Articulos a, TransferenciaAlmacen b, Producto c "
	Articulos += " WHERE a.TA_ID = "+ID
	Articulos += " AND a.TA_ID = b.TA_ID "
	Articulos += " AND a.Pro_ID = c.Pro_ID "


}else{
	Articulos = "SELECT OV_Folio as Folio,a.OV_ID as ID,OVA_ID as ident, OVA_PART_NUMBER as SKU "
	Articulos += " , OV_Cantidad as Cantidad "
	Articulos += " ,Pro_EsSerializado as Serializado, Pro_Nombre "
	Articulos += " FROM Orden_Venta_Articulo a, Orden_Venta b, Producto c  "
	Articulos += " WHERE a.OV_ID = "+ID
	Articulos += " AND a.OV_ID = b.OV_ID "
	Articulos += " AND a.Pro_ID = c.Pro_ID "
}


%>



<div class="ibox">
    <strong><p>Nota: Verifica que el contenido de la caja coincida con el contenido del pedido de no ser as&iacute;, se deber&aacute; levantar una incidencia y dar nota de entrada a los producto que si se encuentran f&iacute;sicamente.</p>
    </strong>
    <input type="button" class="btn btn-success" id="btnConfir" value="Adelante"/>
</div>

<div class="ibox-content" id="divTipo">
    <div>
        <label>Tipo de devoluci&oacute;n:</label>&nbsp;&nbsp;&nbsp;
        <label><input class="i-checks" type="radio" value="3" id="Completo" name="gpo1"/>&nbsp;Completa </label>
        <label>&nbsp;&nbsp;&nbsp;&nbsp;<input class="i-checks" type="radio" value="1" id="Parcial" name="gpo1"/>&nbsp;Parcial </label>
    </div>
</div>

<div class="ibox-content" id="PedidoContenido">
	<h2><div>Nota de entrada tipo:&nbsp;<strong><span id="Titulo"></span></strong></div></h2>
    <br>
    <div class="col-sm-12 m-b-xs">
        <input class="form-control Serie pull-right" style="width:30%"   placeholder="Ingresa la serie" type="text" autocomplete="off" value="" />
    </div>
    <table class="table" style="font-size:medium">
    <thead>
        <tr>
            <th>Pedido</th>
            <th>SKU</th>
            <th>Descripcion</th>
            <th class="text-center">Cantidad Solicitada</th>
            <th class="text-center">Cantidad F&iacute;sica</th>
        </tr>
    </thead>
    <tbody>
       <% 
       var rsArt = AbreTabla(Articulos,1,0)
		var ID = -1
		var ident = -1
		var Nombre = -1
		var Cantidad = -1
		var CantidadDevuelta = -1
		var SKU = -1
		var Serializado = -1
        if(!rsArt.EOF){
            while (!rsArt.EOF){
                ID = rsArt.Fields.Item("ID").Value
                ident = rsArt.Fields.Item("ident").Value
				Nombre = rsArt.Fields.Item("Pro_Nombre").Value
                Cantidad = rsArt.Fields.Item("Cantidad").Value
				CantidadDevuelta = rsArt.Fields.Item("CantidadDevuelta").Value
                SKU = rsArt.Fields.Item("SKU").Value
				Serializado = rsArt.Fields.Item("Serializado").Value
           %>    <tr>
                    <td><%=rsArt.Fields.Item("Folio").Value%></td>
                    <td><strong><%=SKU%></strong></td>
                    <td><%=Nombre%></td>
                    <td align="center"><%=Cantidad%></td>
                    <%if(Serializado == 0){%>
                    <td align="center"><input onkeypress="Check(event)" type="number" min="0" max="<%=Cantidad%>" class="idContenido" data-serializado="0" data-id="<%=ID%>" data-idcont="<%=ident%>" data-sku="<%=SKU%>" id="Contenido_<%=ident%>" value="<%=CantidadDevuelta%>" /></td>
                    <%}else{%>
                    <td align="center"><span id="Cant_<%=ID%>_<%=ident%>"><%=CantidadDevuelta%></span>
                        <input type="hidden" onkeypress="Check(event)" class="idContenido" data-id="<%=ID%>" data-idcont="<%=ident%>" data-serializado="0" data-sku="<%=SKU%>" id="Cant_Resul_<%=ID%>_<%=ident%>" value="<%=CantidadDevuelta%>"/></td>
                    <%}%>
               </tr>
        <%
            rsArt.MoveNext() 
            }
        rsArt.Close()
    }else{   
    %>       
    <tr><td colspan="4">No hay informaci&oacute;n</td></tr>
    
    <%}%>
    </tbody>
    
    </table>
</div>
    

<script type="application/javascript">

$('#PedidoContenido').hide();
$('#divTipo').hide();

$('.i-checks').iCheck({ radioClass: 'iradio_square-green' }); 
$('.i-checks').on('ifChanged', function(event) {
	$('#PedidoContenido').hide('slow',function(){
		if(event.target.checked) {
			$('#Titulo').html($(event.target).prop('id'))
			$('#Motivo').val($(event.target).val());
			$('#PedidoContenido').show('slow',function(){
				$('.btnCreaNota').prop('disabled',false);
			});
		}
	});
});

$('#btnConfir').click(function(e) {
    e.preventDefault();
	$(this).hide("slow",function(){
		$('#divTipo').show('slow');
	});
	
});

function Check(e) {
    var keyCode = (e.keyCode ? e.keyCode : e.which);
    if (keyCode > 0 && keyCode < 1000) {
        e.preventDefault();
    }
}

$('.Serie').on('keypress',function(e) {
	if(e.which == 13) {
		var DatoIngreso = $(this).val()
		$(this).val("");
		NotaEntradaFunciones.VerificaSerie(DatoIngreso); 
	}
});

$('.idContenido').change(function(e) {
   	//console.log($(this).val())
	var Aumenta = 0
	
	var direction = this.defaultValue < this.value
	
    this.defaultValue = this.value;
	
    if (direction){ Aumenta = 1;}
	
	var info = $(this)
	var Request = {
		ID:info.data('id'),
		ID2:info.data('idcont'),
		SKU:info.data('sku').toString(),
		Aumenta:Aumenta
	}
	//console.log(Request)
	NotaEntradaFunciones.VerificaNOSerializado(Request); 
	//NotaEntradaFunciones.Condicion($(this).data('id'),$(this).data('idcont'),1,0);

});
</script>


