<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%> 
<!--#include file="../../../Includes/iqon.asp" -->
<%
// ROG ID: 1 1-jul-2020 Creación de Archivo: inventario por producto

var Cli_ID = Parametro("Cli_ID", -1)
var Pro_ID = Parametro("Pro_ID", -1)

var sqlInv = "select * from Producto where Pro_ID = " + Pro_ID

var rsProd = AbreTabla( sqlInv, 1 , 0 )
if(!rsProd.EOF){
	var NombreProducto = rsProd.Fields.Item("Pro_ClaveAlterna").Value
        NombreProducto += " - " +rsProd.Fields.Item("Pro_Nombre").Value 
    var Descripcion = rsProd.Fields.Item("Pro_Descripcion").Value
   
var iTot = 0
var iDisp = 0
var sSQLTot =  "select COUNT(*) "
    sSQLTot += " from Inventario "
    sSQLTot += " where Pro_ID = " + Pro_ID
    sSQLTot += " and Inv_Dummy = 0 "
    sSQLTot += " and Cli_ID = " + Cli_ID
var rsTot = AbreTabla( sSQLTot, 1 , 0 )
 if(!rsTot.EOF){
   	iTot = rsTot.Fields.Item(0).Value
 }
 rsTot.close() 

var sSQLDis =  "select COUNT(*) "
    sSQLDis += " from Inventario "
    sSQLDis += " where Pro_ID = " + Pro_ID
    sSQLDis += " and Inv_Dummy = 0 "
    sSQLDis += " and Inv_EstatusCG20 = 1 "
    sSQLDis += " and Cli_ID = " + Cli_ID
   
var rsDis = AbreTabla( sSQLDis, 1 , 0 )
 if(!rsDis.EOF){
   	iDisp = rsDis.Fields.Item(0).Value
 }
 rsDis.close() 
   
%>
<div class="ibox-content">
	<div class="table-responsive">
		 <h1><%= NombreProducto %>  <br> <small><%= Descripcion  %></small> </h1> 
		<hr> 
		 <div class="col-lg-4">
			<div class="ibox float-e-margins">
				<div class="ibox-title">
					<span class="label label-primary pull-right">Activo</span>
					<h5>Existencias</h5>
					
				</div>
				<div class="ibox-content">
					<div class="row">
						<div class="col-md-6">
							<h1 class="no-margins"><%=formato(iTot,0) %></h1>
							<div class="font-bold text-navy">
								Total
							</div>
						</div>
						<div class="col-md-6">
							<h1 class="no-margins"><%=formato(iDisp,0) %></h1>
							<div class="font-bold text-navy">
								Disponibles
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>
	
<%

   var sqlInv  = "SELECT Alm_ID, Alm_Nombre, Alm_Descripcion, Alm_Clave, Alm_CiudadC "
       sqlInv += " ,( SELECT count(*) FROM Inventario i "
       sqlInv +=     " WHERE Pro_ID = " + Pro_ID
       sqlInv +=       " AND Inv_Dummy = 0 "
       sqlInv +=       " AND Cli_ID = " + Cli_ID
       sqlInv +=       " AND i.Alm_ID = a.Alm_ID) as Recibidos  "
       sqlInv += " ,( SELECT count(*) FROM Inventario i "
       sqlInv +=     " WHERE Pro_ID = " + Pro_ID
       sqlInv +=       " AND Inv_Dummy = 0 and Inv_EstatusCG20 = 1 "
       sqlInv +=       " AND Cli_ID = " + Cli_ID
       sqlInv +=       " AND i.Alm_ID = a.Alm_ID) as Disponibles "
       sqlInv += " FROM Almacen a "
       sqlInv += " WHERE Alm_ID in (SELECT Alm_ID from Inventario "
       sqlInv +=                   " WHERE Pro_ID = " + Pro_ID
       sqlInv +=                   " AND Inv_Dummy = 0 "
       sqlInv +=                   " AND Cli_ID = " + Cli_ID + ") "

   var rsInv = AbreTabla( sqlInv, 1 , 0 )

%>						
	<div class="ibox-content">
		<div class="table-responsive">
			<table width="848" class="table table-hover issue-tracker">
				<thead>
					<tr>
						<th width="282">Almac&eacute;n</th>
						<th width="133">Cantidad Recibida</th>
						<th width="133">Cantidad Disponible</th>
					</tr>
				</thead>
				<tbody>
<%
while( !(rsInv.EOF) ){
%>
				<tr>
					<td class="issue-info">
						<a href="#">
							<%= rsInv.Fields.Item("Alm_Clave").Value %> - 
							<%= rsInv.Fields.Item("Alm_Nombre").Value %> 
							( <%= rsInv.Fields.Item("Alm_CiudadC").Value %> )
						</a>
						<small>
							<%= rsInv.Fields.Item("Alm_Descripcion").Value %> 
						</small>
					</td>						  
					<td><%= formato(rsInv.Fields.Item("Recibidos").Value,0) %> </td>
					<td><%= formato(rsInv.Fields.Item("Disponibles").Value,0) %> </td>
				</tr>
<%
	rsInv.MoveNext()
	}
rsInv.close()   
%>
                               
				</tbody>
			</table>
		</div>
	</div>
<%

	}
rsProd.close()   
%>								
									
