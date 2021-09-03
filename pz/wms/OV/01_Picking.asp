<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include file="../../../Includes/iqon.asp" -->

<%

	var OV_ID = Parametro("OV_ID",-1)
	
	var sSQLOV = "SELECT * "
		sSQLOV += "FROM Orden_Venta WHERE OV_ID = " + OV_ID
		
		bHayParametros = false
		ParametroCargaDeSQL(sSQLOV,0)

 
	var sSQLGrid = "SELECT count(OV_ID) as OVID,OVA_PART_NUMBER "
		sSQLGrid += " ,(SELECT Pro_Nombre FROM Producto p WHERE p.Pro_SKU = O.OVA_PART_NUMBER OR p.Pro_ClaveAlterna = O.OVA_PART_NUMBER ) as Nombre "
		sSQLGrid += " ,(SELECT Pro_Descripcion FROM Producto p WHERE p.Pro_SKU = O.OVA_PART_NUMBER OR p.Pro_ClaveAlterna = O.OVA_PART_NUMBER  ) as Descripcion "
		sSQLGrid += " ,(SELECT Pro_ID FROM Producto p WHERE p.Pro_SKU = O.OVA_PART_NUMBER OR p.Pro_ClaveAlterna = O.OVA_PART_NUMBER  ) as ProID "
		sSQLGrid += " FROM Orden_Venta_Articulo O "
		sSQLGrid += " WHERE OV_ID = " +OV_ID 
		sSQLGrid += " GROUP BY  OV_ID, Pro_ID,OVA_PART_NUMBER "
		 
		 
	   var rsProductos = AbreTabla(sSQLGrid,1,0)
	 
		 
	var sSQLCue = "SELECT Count(Inv_ID) as Cuenta "
		sSQLCue += "FROM Orden_Venta_Articulo"
		sSQLCue += " WHERE Inv_ID > -1"
		sSQLCue += " AND  OV_ID = " +OV_ID 
		
	var rsCue = AbreTabla(sSQLCue,1,0)
	if (!rsCue.EOF){
		var Realizados  = rsCue.Fields.Item("Cuenta").Value
	}
	
	//Response.Write(OV_ID)
%>

<div class="form-horizontal" id="toPrint">
    <div class="row">
        <div class="col-lg-12">
            <div class="ibox float-e-margins">
                <div class="ibox-content">
                    <div class="form-group">
                        <legend class="control-label col-md-12" style="text-align: right;" id="OVName"><h1>Orden de venta <strong><%=Parametro("OV_Folio",-1)%></strong></i></h1></legend>
                     </div>
                    <div class="form-group" id="SeVan">
                      <div class="col-md-3">
                      	<input type="button" class="btn btn-success btnGenerarDuplas" value="Generar duplas">
                        
                      
                      
<!--                            <input class="form-control" autocomplete="off" id="Codigo" placeholder="C&oacute;digo" type="text">
-->                      </div>
                      <label class="control-label col-md-4" style="text-align: left;" id="Contador"></label>
                      <div class="col-lg-5"  style="text-align: right;">
                            <button class="btn btn-success btnImprimir">Imprimir</button>
                      </div>
                     </div>
                    <table class="table table-striped table-hover" id="PickingTabla">     
                    <thead>
                        <tr>
                            <th scope="col">Cantidad</th>
                            <th scope="col">SKU</th>
                            <th scope="col">Ubicaci&oacute;n</th>
                            <th scope="col">Nombre</th>
                            <th scope="col">Descripci&oacute;n</th>
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
                            <td style="text-align: center;"><strong><%=Cantidad%></strong></td>
                            <td><%=SKU%></td>
                            <td>Pendiente</td>
                            <td><strong><%=Nombre%></strong></td>
                            <td><%=Descripcion%></td>
                        </tr>
                        
                    <%
                    var sSQLGrid2 = "SELECT * "
                        sSQLGrid2 += " ,(SELECT Inv_Serie FROM Inventario WHERE Inv_ID = O.Inv_ID) as Serie "
                        sSQLGrid2 += " FROM Orden_Venta_Articulo O "
                        sSQLGrid2 += " WHERE OV_ID = " +OV_ID 
                        sSQLGrid2 += " AND Inv_ID > -1 " 
                        sSQLGrid2 += " AND Pro_ID = " +Pro
                        
                        var Renglon = 0
                        
                       var rsCargados = AbreTabla(sSQLGrid2,1,0)
                    if(!rsCargados.EOF){
                    %>
                    <tr>
                        <td colspan="5">
                        <div class="col-md-offset-1">
                            <table class="table table-striped table-hover">
                            <thead>
                                <tr>
                                    <th scope="col">#</th>
                                    <th scope="col">Serie</th>
                                </tr>
                            </thead>
    
                    <%   
                        while (!rsCargados.EOF){
                        Renglon++
                            var Serie = rsCargados.Fields.Item("Serie").Value	
                            %>			
                                <tr>
                                    <td><%=Renglon%></td>
                                    <td><%=Serie%></td>
                                </tr>
                                
                            <%
                                rsCargados.MoveNext() 
                            }
                            rsCargados.Close()  
                        %>	
                            </table>
                        </div>
                        </td>
                    </tr>
                  <%}
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
<script type="application/javascript">
$(document).ready(function(e) {
	
	//$('#Contador').html(<%=Realizados%>+" de "+<%=sumatotal%>)
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
	
});

	
$(document).on('keypress',function(e) {
	if(e.which == 13) {
		e.preventDefault()
		var codigo = $('#Codigo').val()
		//GetValidationInventario(codigo)
		$('#Codigo').val("")
	}
});








//var con = <%=Realizados%>
//
//function Contador(){
//	if(con <<%=sumatotal%>){
//		con++
//		$('#Contador').html(con+" de "+<%=sumatotal%>)
//		$('#Contador').css('color','#000')
//
//	}
//	if(con == <%=sumatotal%>){
//		$('#Contador').css('color','#F00')
//	}
//}
//var RengloN = <%=Renglon%>
//function GetValidationInventario(d){
//	$.post("/pz/wms/OV/OV_Ajax.asp",{
//		Tarea:1,
//		Codigo:d,
//		OV_ID:<%=OV_ID%>
//		}
//    , function(data){
//		var sTmp = String(data)
//		var arrayDatos = new Array()
//		arrayDatos = sTmp.split("|")
//		
//		console.log(data)
//
//		if(arrayDatos[0] == 1){
//			RengloN++
//			var Existe = $('#NuevoTr'+arrayDatos[1]).length
//			console.log(Existe)
//			if(Existe == 0){
//			var row = '<tr id="NuevoTr'+arrayDatos[1]+'">'
//					row += '<td colspan="5">'
//						row += '<div class="col-md-12">'
//							row += ' <table class="table table-striped table-hover">'
//								row += '<thead>'
//									row += '<tr>'
//										row += '<th scope="col">#</th>'
//										row += '<th scope="col">Serie</th>'
//									row += '</tr>'
//								row += '</thead>'
//								row += '<tr id="NuevoArt'+arrayDatos[1]+'">'
//									row += '<td>'+RengloN+'</td>'
//									row += '<td>'+d+'</td>'
//								row += '</tr>'
//							row += '</table>'
//						row += '</div>'
//					row += '</td>'
//				row += '</tr>'
//			$(".Producto"+arrayDatos[1]).closest('tr').after(row);	
//			//$("#PickingTabla tr:last").closest('tr').after(row);
//			}else{
//				var row = '<tr class="success">'
//					row += '<td>'+RengloN+'</td>'
//					row += '<td >'+d+'</td>'
//					row += '</tr>'
//				$("#NuevoArt"+arrayDatos[1]).closest('tr').after(row);
//			}
//			Contador()
//		}else{
//			$('#Contador').html(con+" de "+<%=sumatotal%>+" "+arrayDatos[2])
//		}
//	});
//	
//	
//}

</script>            