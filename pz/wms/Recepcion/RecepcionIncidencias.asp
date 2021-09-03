<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include file="../../../Includes/iqon.asp" -->

<%

	var Cort_ID = 31
	var Ordenes = "SELECT * "
		Ordenes += " FROM Orden_Venta h"
		Ordenes += " WHERE Cort_ID = "+Cort_ID 
		Ordenes += " AND OV_Test = 0"
		Ordenes += " AND OV_Cancelada = 0"
		Ordenes += " AND OV_CUSTOMER_NAME is not null "
		Ordenes += " ORDER BY (SELECT TOP 1 OVA_PART_NUMBER FROM [dbo].[Orden_Venta_Articulo] WHERE OV_ID = h.OV_ID) DESC"
			
%>

<div class="form-horizontal" id="toPrint">
    <div class="row">
        <div class="col-lg-12">
            <div class="ibox float-e-margins">
                <div class="ibox-content">
                    <div class="form-group">
                        <legend class="control-label col-md-12" style="text-align: left;"><h1>O.C.&nbsp;<%=Cort_ID%></h1></legend>
                     </div>
                     <div class="form-group">
                        <legend class="control-label col-md-12" style="text-align: left;"><h1>Cantidad:&nbsp;<%=Cort_ID%></h1></legend>
                     </div>
                 
                <div style="overflow-y: scroll; height:655px; width: 200;">
                <%
                    var rsOrd = AbreTabla(Ordenes,1,0)
    
                    while (!rsOrd.EOF){
                        var OV_ID = rsOrd.Fields.Item("OV_ID").Value 
                        var OV_Folio = rsOrd.Fields.Item("OV_Folio").Value 
						var background = rsOrd.Fields.Item("OV_EstatusCG51").Value 
						var fondo = ""
						if(background > 1){
							fondo = "bg-success"
						}
						
						var Articulos = "SELECT * "
							Articulos += " ,(SELECT OV_Folio FROM Orden_Venta p WHERE p.OV_ID = a.OV_ID) Folio"
							Articulos += " ,ISNULL((SELECT ISNULL(Pro_Nombre,'') FROM Producto p WHERE p.Pro_ClaveAlterna = a.OVA_PART_NUMBER),'') PRO_NOM"
							Articulos += " FROM Orden_Venta_Articulo a"
							Articulos += " WHERE OV_ID = "+OV_ID

                        var rsArt = AbreTabla(Articulos,1,0)
                        var rsArt2 = AbreTabla(Articulos,1,0)
                        var rsArt3 = AbreTabla(Articulos,1,0)
						
					if(rsArt.Fields.Item("PRO_NOM").Value != ""){
                                
                %>
                    <div class="ibox-content <%=fondo%>" id="bg_<%=OV_ID%>">
                        <div class="table-responsive">
                            <table class="table shoping-cart-table">
                                <tbody>
                                <tr>
                                    <td class="desc">
                                        <h3 class="text-navy">  
                                            <%=rsOrd.Fields.Item("OV_Folio").Value%>
                                        </h3>
                                       
                             </td>
                                    <td class="desc">
                                    <h3>Folio</h3>

                                    <%
                                        while(!rsArt.EOF){
                                            var PRO_NOM = rsArt.Fields.Item("PRO_NOM").Value 
                                    %>		
                                        <h4>1</h4>
                                    <%	
                                        rsArt.MoveNext() 
                                    }
                                    rsArt.Close()   
                                    %>
                                    </td>
                                    <td class="desc">
                                    <h3>SKU</h3>
                                    <%
									var Limiteishon = 0
                                        while(!rsArt2.EOF){
										Limiteishon++
                                            var OVA_Cantidad = 1 
                                    %>		
                                        <h4>565945TU5409U5409</h4>
                                            
                                    <%	
                                        rsArt2.MoveNext() 
                                    }
                                    rsArt2.Close()   
                                    %>
                                    </td>
                                     <td class="desc">
                                <h3>Modelo</h3>

                                     <h4>Huawei Y9</h4>
   </td>
   <td class="desc">
                                <h3>Color</h3>
<h4>Negro</h4>
                                     
   </td>
      <td class="desc">
                                <h3>LPN</h3>

                                     <h4>HY340RU3034R30</h4>
   </td>
   <td class="desc">
                               <input type="button" value="Ver Incidencias" data-ovid="<%=OV_ID%>" id="btnIncidencias<%=OV_ID%>" class="btn btn-info btnIncidencias"/>
                                     
   </td>
                                </tr>
                                </tbody>
                            </table>
                        </div>
                    </div>
                    <%}
                        rsOrd.MoveNext() 
                    }
                    rsOrd.Close()   
                    %>
                </div>

            </div>
        </div>
    </div>    
</div>

<script src="/Template/inspina/js/plugins/jquery-ui/jquery-ui.min.js"></script>
<script type="text/javascript">
$(document).ready(function(e) {
	
	$('.btnImprimirEtiqueta').click(function(e) {
		e.preventDefault()
		var newWin = window.open("http://wms.lyde.com.mx/pz/wms/OV/Etiqueta.asp?OV_ID="+$(this).data("ovid"))
	});
	$('.btnEtiquetasTotal').click(function(e) {
		e.preventDefault()
		console.log ($(this))
		var newWin = window.open("http://wms.lyde.com.mx/pz/wms/OV/Todas_Etiqueta.asp?Cort_ID="+<%=Cort_ID%>)
	});
	
	$('.btnImprimirSalida').on('click',function(e){
		e.preventDefault()
		var newWin = window.open("http://wms.lyde.com.mx/pz/wms/OV/HojaRemision.asp?OV_ID="+$(this).data("ovid"))
	});
	
	
});
$('.btnEscanear').click(function(e) {
	e.preventDefault()
	var OV_ID = $(this).data("ovid")
	$('#InputPeso'+OV_ID).css('display','block')
	$('#InputPeso'+OV_ID).focus()

});

$('.InputPeso').on('change',function(e) {
	e.preventDefault()
	var OV_ID = $(this).data("ovid")
	$('#InputScan'+OV_ID).css('display','block')
	
});

$('.btnPrueba').click(function(e) {
	e.preventDefault()
	var OV_ID = $(this).data("ovid")
	//finishPicking(OV_ID)
});
$('.btnEnviarShipping').click(function(e) {
	e.preventDefault()
	var OV_ID = $(this).data("ovid")
	Shipping(OV_ID)
});
$('.btnEnviarTransito').click(function(e) {
	e.preventDefault()
	var OV_ID = $(this).data("ovid")
	Trnasit(OV_ID)
});



$('.InputStartPick').on('keypress',function(e) {
    if(e.which == 13) {
		var datos = {
			OV_ID:$(this).data("ovid"),
			OVP_Serie:$(this).val(),
			IDUsuario:$('#IDUsuario').val(),
			Tarea:5,
			Cli_ID:2,
			Limite:$('#Limiteishon'+$(this).data("ovid")).val()
		}
		Picked(datos,$(this))
    }
});

$('.btnImprimirConsolidado').click(function(e){
	e.preventDefault()
	var newWin = window.open("http://wms.lyde.com.mx/pz/wms/OV/HojaSurtido.asp?Cort_ID=<%=Cort_ID%>")
});


 


</script>            