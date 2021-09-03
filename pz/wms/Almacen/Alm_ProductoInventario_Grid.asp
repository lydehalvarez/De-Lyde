<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%> 
<!--#include file="../../../Includes/iqon.asp" -->
<%

   var Cli_ID = Parametro("Cli_ID", -1)
   var Pro_ID = Parametro("Pro_ID", -1)

   var almid = 0
   var sCiudad = ""

   var sqlInv  = "SELECT Alm_ID, Alm_Nombre, Alm_Descripcion, Alm_Clave, Alm_CiudadC "
//       sqlInv += " ,( SELECT count(*) FROM Inventario i "
//       sqlInv +=     " WHERE Pro_ID = " + Pro_ID
//       sqlInv +=       " AND Inv_Dummy = 0 "
//       sqlInv +=       " AND Cli_ID = " + Cli_ID
//       sqlInv +=       " AND i.Alm_ID = a.Alm_ID) as Recibidos  "
//       sqlInv += " ,( SELECT count(*) FROM Inventario i "
//       sqlInv +=     " WHERE Pro_ID = " + Pro_ID
//       sqlInv +=       " AND Inv_Dummy = 0 and Inv_EstatusCG20 = 1 "
//       sqlInv +=       " AND Cli_ID = " + Cli_ID
//       sqlInv +=       " AND i.Alm_ID = a.Alm_ID) as Disponibles "
//       sqlInv += " ,( SELECT count(*) FROM Inventario i "
//       sqlInv +=     " WHERE Pro_ID = " + Pro_ID
//       sqlInv +=       " AND Inv_Dummy = 0 and Inv_EstatusCG20 = 5 "
//       sqlInv +=       " AND Cli_ID = " + Cli_ID
//       sqlInv +=       " AND i.Alm_ID = a.Alm_ID) as vendidas "
//	     sqlInv +=      ", (select count(*)  "
//		 sqlInv += 		"from  inventario  "
//		 sqlInv += 		" where pro_id =  " + Pro_ID + " and Cli_ID = " + Cli_ID
//		 sqlInv += 	" and inv_enalmacen = 1 "
//		 sqlInv += 	" and Alm_ID = 3"
//		 sqlInv += 		" and inv_esapartado = 1) as comprometidos "
//       sqlInv += " ,( SELECT count(*) FROM Inventario i "
//       sqlInv +=     " WHERE Pro_ID = " + Pro_ID
//       sqlInv +=       " AND Inv_Dummy = 0 and Inv_EstatusCG20 not in (1,5) "
//       sqlInv +=       " AND Cli_ID = " + Cli_ID
//       sqlInv +=       " AND i.Alm_ID = a.Alm_ID) as otros "
       sqlInv += " FROM Almacen a "
       sqlInv += " WHERE Alm_ID in (SELECT Alm_ID from Inventario "
       sqlInv +=                   " WHERE Pro_ID = " + Pro_ID
       sqlInv +=                   " AND Inv_Dummy = 0 "
       sqlInv +=                   " AND Cli_ID = " + Cli_ID + ") "
       sqlInv += " ORDER BY Alm_TipoCG84 "


   
   var rsInv = AbreTabla( sqlInv, 1 , 0 )

%>						
	<div class="ibox-content">
		<div class="table-responsive">
			<table width="848" class="table table-hover issue-tracker">
				<thead>
					<tr>
						<th width="470">Almac&eacute;n</th>
						<th width="119">Total Recibido en tienda</th>
                        <th width="115">Cantidad Vendidas</th>
                        <th width="115" title="Cuarentena, asignados directos">Comprometidos</th>
						<th width="124">Cantidad Disponible</th>
                        
					</tr>
				</thead>
				<tbody>
<%
while( !(rsInv.EOF) ){
   almid = rsInv.Fields.Item("Alm_ID").Value
   sCiudad = FiltraVacios(rsInv.Fields.Item("Alm_CiudadC").Value)
   
%>
				<tr>
					<td class="issue-info coldato" data-almid="<%=almid%>">
						<a href="#">
							<%= rsInv.Fields.Item("Alm_Clave").Value %> - 
							<%= rsInv.Fields.Item("Alm_Nombre").Value %> 
				            <% if(sCiudad != "") { Response.Write("(" + sCiudad + ")") } %>
						</a>
						<small>
							<%= rsInv.Fields.Item("Alm_Descripcion").Value %> 
						</small>
					</td>						  
					<td id="td-<%=almid%>-R"><img src="/Img/ajaxLoader.gif" width="10" height="10" alt=""/></td>
                    <td id="td-<%=almid%>-V"><img src="/Img/ajaxLoader.gif" width="10" height="10" alt=""/></td> 
                    <td id="td-<%=almid%>-C"><img src="/Img/ajaxLoader.gif" width="10" height="10" alt=""/></td>     
					<td id="td-<%=almid%>-D"><img src="/Img/ajaxLoader.gif" width="10" height="10" alt=""/></td>
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
						
									
