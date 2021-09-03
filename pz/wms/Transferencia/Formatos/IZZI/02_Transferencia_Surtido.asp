 <%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%> 
<!--#include file="../../../../../Includes/iqon.asp" -->
<%
	var TA_ArchivoID = Parametro("TA_ArchivoID",-1)
	
	var Transfer = "SELECT * "
		Transfer += " ,(SELECT Alm_Nombre FROM Almacen a WHERE  a.Alm_ID = h.TA_Start_Warehouse_ID) Sucursal_Origen "
		Transfer += " ,(SELECT Alm_Nombre FROM Almacen a WHERE  a.Alm_ID = h.TA_End_Warehouse_ID) Sucursal_Destino "
		Transfer += " FROM TransferenciaAlmacen h"
		Transfer += " WHERE TA_ArchivoID = "+TA_ArchivoID
	
%>
<div class="wrapper wrapper-content animated fadeInRight">
	<div class="row">
        <div class="col-md-12">
        	<div class="form-group">
                <input type="button" value="Imprimir etiquetas" data-archid="<%=TA_ArchivoID%>" class="btn btn-info btnEtiquetas"/>
                <input type="button" value="Imprimir consolidado" data-archid="<%=TA_ArchivoID%>" class="btn btn-info btnConsolidado"/>
                <input type="button" value="Obtener series" data-archid="<%=TA_ArchivoID%>" class="btn btn-info btnSeries"/>
                </div>
            <div class="ibox">
                <div style="overflow-y: scroll; height:500px; width: auto;">
                <%
                    var rsTran = AbreTabla(Transfer,1,0)
    
                    while (!rsTran.EOF){
                        var TA_ID = rsTran.Fields.Item("TA_ID").Value 
                        var Articulos = "SELECT *,(SELECT Pro_Nombre FROM Producto p WHERE p.Pro_ClaveAlterna = a.TAA_SKU) PRO_NOM "
                            Articulos += " FROM TransferenciaAlmacen_Articulos a"
                            Articulos += " WHERE TA_ID = "+TA_ID
							
                        var rsArt = AbreTabla(Articulos,1,0)
                        var rsArt2 = AbreTabla(Articulos,1,0)
                        var rsArt3 = AbreTabla(Articulos,1,0)
                                
                %>
                    <div class="ibox-content" id="<%=TA_ID%>">
                        <div class="table-responsive">
                            <table class="table shoping-cart-table">
                                <tbody>
                                <tr>
                                    <td class="desc" width="50%">                                    
                                        <div class="widget style1 navy-bg">
                                            <div class="row vertical-align">
                                                <div class="col-xs-3">
                                                    <i class="fa fa-dropbox fa-2x"></i>
                                                </div>
                                                <div class="col-xs-9 text-right">
                                                    <h3 class="font-bold"><%=rsTran.Fields.Item("TA_Folio").Value%></h3>
                                                </div>
                                            </div>
                                        </div>
                                    
<%/*%>                                        <h3 class="text-navy">
                                            <%=rsTran.Fields.Item("TA_Folio").Value%>
                                        </h3>
<%*/%>                                        <p>
                                            <span class="label label-primary">Origen <%=rsTran.Fields.Item("Sucursal_Origen").Value%></span>
                                        </p>
                                        <p>
                                            <span class="label label-warning">Destino <%=rsTran.Fields.Item("Sucursal_Destino").Value%></span>
                                        </p>
                                        <input type="text" value="" style="display:none;width:50%" data-taid="<%=TA_ID%>" class="form-control InputStartPick" id="InputStartPick<%=TA_ID%>"/>
                                        <p class="small" id="Mensaje<%=TA_ID%>"></p>
                                        <input type="button" value="Empezar pick" data-taid="<%=TA_ID%>" id="btnStartPick<%=TA_ID%>" class="btn btn-info btnStartPick"/>
                                        <input type="button" value="Cancelar pick" style="display:none"  id="btnCancelPick<%=TA_ID%>" class="btn btn-danger btnCancelPick"/>
                                        <input type="button" value="Imprimir salida"  data-taid="<%=TA_ID%>" class="btn btn-info btnImprimirSalida"/>
                                        <input type="button" value="Imprimir albaran"  data-taid="<%=TA_ID%>" class="btn btn-info btnImprimirAlbaran"/>
                                    </td>
                                    <td class="desc" style="padding-top: 20px;" width="30%">
                                    <%
                                        while(!rsArt.EOF){
                                            var PRO_NOM = rsArt.Fields.Item("PRO_NOM").Value 
                                    %>		
                                        <h4><%=PRO_NOM%></h4>
                                            
                                    <%	
                                        rsArt.MoveNext() 
                                    }
                                    rsArt.Close()   
                                    %><strong>Total:</strong>
                                    </td>
                                    <td class="desc" style="padding-top: 20px;" width="10%">
                                    <%
									var cantidadTotal = 0
                                        while(!rsArt2.EOF){
                                            var TAA_Cantidad = rsArt2.Fields.Item("TAA_Cantidad").Value 
											cantidadTotal = cantidadTotal + TAA_Cantidad
                                    %>		
                                        <h4><%=TAA_Cantidad%></h4>
                                    <%	
                                        rsArt2.MoveNext() 
                                    }
                                    rsArt2.Close()   
                                    %>
                                    <strong><%=cantidadTotal%></strong>
                                    </td>
                                    <td class="desc" style="padding-top: 20px;" width="10%">
                                    <%
									var totalSuma = 0
										var YaPickeados = 0
                                        while(!rsArt3.EOF){
										 var TAA_ID = rsArt3.Fields.Item("TAA_ID").Value 
										 
											
										var Picked = "SELECT COUNT(TAA_ID) Artis "
											Picked += " FROM TransferenciaAlmacen_Articulo_Picking "
											Picked += " WHERE TA_ID = "+TA_ID
											Picked += " AND TAA_ID = "+TAA_ID
												 
										var rsPicked = AbreTabla(Picked,1,0)
                                        if(!rsPicked.EOF){
										 YaPickeados = rsPicked.Fields.Item("Artis").Value 
										}   

                                    %>		
                                        <h4 id="Cont_<%=TA_ID%>_<%=TAA_ID%>"><%=YaPickeados%></h4>
                                            
                                    <%	
										totalSuma = totalSuma + YaPickeados
                                        rsArt3.MoveNext() 
                                    }
                                    rsArt3.Close()  
                                    %>
                                   <strong><%=totalSuma%></strong>
                                    </td>
                                </tr>
                                
                                </tbody>
                            </table>
                        </div>
                    </div>
                    <%	
                        rsTran.MoveNext() 
                    }
                    rsTran.Close()   
                    %>
                </div>
            </div>
        </div>
    </div>
</div>
 

<script type="application/javascript">
$('.btnStartPick').click(function(e) {
	var TA_ID = $(this).data("taid")
	$(this).hide('slow')
    $('#btnCancelPick'+TA_ID).css('display','block')
    $('#InputStartPick'+TA_ID).css('display','block')
    $('#InputStartPick'+TA_ID).focus()
});

$('.btnImprimirSalida').click(function(e) {
	var TA_ID = $(this).data("taid")
	var newWin=window.open("http://qawms.lyde.com.mx/pz/wms/Transferencia/SalidaAlmacenDoc.asp?TA_ID="+TA_ID);

});
$('.btnImprimirAlbaran').click(function(e) {
	var TA_ID = $(this).data("taid")
	var newWin=window.open("http://qawms.lyde.com.mx/pz/wms/Transferencia/AlbaranDoc.asp?TA_ID="+TA_ID);

});

$('.btnEtiquetas').click(function(e) {
	var TA_ID = $(this).data("taid")
	var newWin=window.open("http://qawms.lyde.com.mx/pz/wms/Transferencia/EtiquetasTransferencia.asp?TA_ArchivoID="+<%=TA_ArchivoID%>);

});
$('.btnConsolidado').click(function(e) {
	var TA_Archivo = $(this).data("archid")
	var newWin=window.open("http://qawms.lyde.com.mx/pz/wms/Transferencia/HojaSurtido.asp?TA_ArchivoID="+TA_Archivo);
});
$('.btnSeries').click(function(e) {
	var TA_Archivo = $(this).data("archid")
	var newWin=window.open("http://qawms.lyde.com.mx/pz/wms/Transferencia/SeriesTransferencias.asp?TA_ArchivoID="+TA_Archivo);
});


$('.btnCancelPick').click(function(e) {
	var TA_ID = $(this).data("taid")
	$(this).hide('slow')
	$('#btnStartPick'+TA_ID).show('slow')
    $('#InputStartPick'+TA_ID).css('display','none')
});

$('.InputStartPick').on('keypress',function(e) {
    if(e.which == 13) {
		var datos = {
			TA_ID:$(this).data("taid"),
			TAS_Serie:$(this).val(),
			IDUsuario:$('#IDUsuario').val(),
			Tarea:3
		}
		SeriesTransferencia(datos,$(this))
    }
});
function SeriesTransferencia(datos,Th){
	$.post("/pz/wms/Transferencia/Transferencia_Ajax.asp",datos
    , function(data){
		console.log(data)
		var obj = JSON.parse(data)
		
		Th.val("")
		$('#Cont_'+datos.TA_ID+'_'+obj.TAA_ID).html(obj.con)
		$('#Mensaje'+datos.TA_ID).html(obj.message).css('color','#F00')
	});
}


</script>