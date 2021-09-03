<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include file="../../../Includes/iqon.asp" -->

<%

	var OV_ID = Parametro("OV_ID",-1)
	
	var sSQLOV = "SELECT * "
		sSQLOV += "FROM Orden_Venta WHERE OV_ID = " + OV_ID
		
		bHayParametros = false
		ParametroCargaDeSQL(sSQLOV,0)
		
	var sSQLPro = "SELECT * "
		sSQLPro += "FROM Producto WHERE Pro_SKU = '"+Parametro("OV_PART_NUMBER","")+"'"
		
		bHayParametros = false
		ParametroCargaDeSQL(sSQLPro,0)
		
 
	var sSQLGrid = "SELECT count(OV_ID) as OVID,OVA_PART_NUMBER "
		sSQLGrid += " ,(SELECT TOP 1 Pro_Nombre FROM Producto p WHERE p.Pro_ID = O.Pro_ID ) as Nombre "
		sSQLGrid += " ,(SELECT TOP 1 Pro_Descripcion FROM Producto p WHERE p.Pro_ID = O.Pro_ID ) as Descripcion "
		sSQLGrid += " , Pro_ID "
		sSQLGrid += " FROM Orden_Venta_Articulo O "
		sSQLGrid += " WHERE OV_ID = " +OV_ID 
		sSQLGrid += " GROUP BY  OV_ID, Pro_ID,OVA_PART_NUMBER "
		 
		 
	var sSQLCue = "SELECT Count(Inv_ID) as Cuenta "
		sSQLCue += "FROM Orden_Venta_Articulo "
		sSQLCue += " WHERE Inv_ID > -1"
		
	var rsCue = AbreTabla(sSQLCue,1,0)
	if (!rsCue.EOF){
		var Realizados  = rsCue.Fields.Item("Cuenta").Value
	}
	
	//Response.Write(OV_ID)
%>
<link href="/Template/inspina/css/plugins/iCheck/green.css" rel="stylesheet">

<div class="form-horizontal">
    <div class="row">
        <div class="col-lg-12">
            <div class="ibox float-e-margins">
                <div class="ibox-content">
                    <div class="form-group">
                        <legend class="control-label col-md-12"><h1><strong>Control de Calidad: Orden de venta <%=Parametro("OV_Folio",-1)%></strong></i></h1></legend>
                     </div>
            <div class="table-responsive">
                <table class="table table-striped table-hover tableishon" id="PickingTabla">     
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
				   var rsProductos = AbreTabla(sSQLGrid,1,0)
				   var sumatotal = 0


					while (!rsProductos.EOF){
						var Nombre = rsProductos.Fields.Item("Nombre").Value	
						var Descripcion = rsProductos.Fields.Item("Descripcion").Value	
						var Cantidad = rsProductos.Fields.Item("OVID").Value
						var SKU = rsProductos.Fields.Item("OVA_PART_NUMBER").Value
						var Pro = rsProductos.Fields.Item("Pro_ID").Value
						
						sumatotal = sumatotal + Cantidad
				%>			
                    <tr class="Producto<%=Pro%> info">
						<td style="text-align: center;"><%=Cantidad%></td>
						<td><%=SKU%></td>
						<td>Palet Xy</td>
						<td><%=Nombre%></td>
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
                    <table class="table table-striped table-hover">
                    <thead>
                        <tr>
                            <th scope="col">#</th>
                            <th scope="col">Serie</th>
                            <th scope="col" style="text-align: center;">Empaque da&ntilde;ado <input type="checkbox" class="CheckBoxInput" id="AllDan" value="0"/></th>
                            <th scope="col" style="text-align: center;">Empaque mojado <input type="checkbox" class="CheckBoxInput" id="AllMoj" value="1"/></th>
                            <th scope="col" style="text-align: center;">Empaque abierto <input type="checkbox" class="CheckBoxInput" id="AllAbi" value="2" /></th>
                        </tr>
                    </thead>

				<%   
					while (!rsCargados.EOF){
					Renglon++
						var Serie = rsCargados.Fields.Item("Serie").Value	
						var Inv_ID = rsCargados.Fields.Item("Inv_ID").Value	
						%>			
                            <tr>
								<td><%=Renglon%></td>
								<td><%=Serie%></td>
								<td style="text-align: center;"><input type="checkbox" class="CheckBoxInput Dan" value="<%=Inv_ID%>" /></td>
								<td style="text-align: center;"><input type="checkbox" class="CheckBoxInput Moj" value="<%=Inv_ID%>"/></td>
								<td style="text-align: center;"><input type="checkbox" class="CheckBoxInput Abi" value="<%=Inv_ID%>"/></td>
							</tr>
							
						<%
							rsCargados.MoveNext() 
						}
						rsCargados.Close()  
					%>	
                    </table>
                    </td>
                </tr>
              <%      
				}else{
			%>	
                <tr>
                	<td colspan="5" style="color: red;text-align: center;">No hay datos</td>
                </tr>
             <%       
				}
					
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
</div>
<script src="/Template/inspina/js/plugins/iCheck/icheck.min.js"></script>
<script type="application/javascript">
$(document).ready(function(){
	$('.CheckBoxInput').iCheck({  checkboxClass: 'icheckbox_square-green' }); 
	$('.CheckBoxInput').on('ifChanged', function(event) {
		var Valor = $(this).val()	
			if(event.target.checked) {
				if(Valor == 0){
						$('.Dan').iCheck('check');
				}if(Valor == 1){
						$('.Moj').iCheck('check');
				}if(Valor == 2){
						$('.Abi').iCheck('check');
				}
			}
	});
	$('.CheckBoxInput').on('ifUnchecked', function(event) {			
		var Valor = $(this).val()	
		if(Valor == 0){
				$('.Dan').iCheck('uncheck'); 
		}if(Valor == 1){
				$('.Moj').iCheck('uncheck'); 
		}if(Valor == 2){
				$('.Abi').iCheck('uncheck'); 
		}
	});
});
</script>            