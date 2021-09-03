<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include file="../../../Includes/iqon.asp" -->
<%
// RG ID: 1 29-jun-2020 Creación de Archivo: Reporte de inventario en tiendas
// HA ID: 2 2020-NOV-11 Inventario: Se agrega filtrado de informacion del inventario actual

var Cli_ID = Parametro("Cli_ID", -1)
var Alm_ID = Parametro("Alm_ID", -1)
   
   
if (Cli_ID == -1 && Alm_ID> -1){
    var sCondicion = " Alm_ID = " + Alm_ID
    Cli_ID = BuscaSoloUnDato("Cli_ID","Almacen",sCondicion,-1,0)
    ParametroCambiaValor("Cli_ID",Cli_ID)
}

//var sqlInvTie = "SELECT DISTINCT i.Pro_ID "
//		+ ", Pro_ClaveAlterna as SKU "
//		+ ", Pro_Nombre "
//		+ ", Pro_Descripcion "
//		+ ", ( select count(*) "
//			+ "from Inventario i2, Inventario_Lote il2 "
//			+ "where il2.Lot_Dummy = 0 and "
//				+ "il2.Lot_ID =  i2.[Inv_LoteIngreso] "
//				+ "AND i2.Pro_ID = i.Pro_ID "
//				+ "and i.Cli_ID = i2.Cli_ID "
//		+ ") as ConteoInicial "
//		+ ", ( "
//			+ "select count(*) " 
//			+ "from Inventario i2 "
//				+ ", Inventario_Lote il2  "
//			+ "where il2.Lot_Dummy = 0  "
//				+ "and il2.Lot_ID =  i2.[Inv_LoteIngreso] "
//				+ "AND i2.Pro_ID = i.Pro_ID  "
//				+ "and i.Cli_ID = i2.Cli_ID   "
//				//+ "and i2.Inv_EnAlmacen = 1 "
//		+ ") as CantidadActual "
//	+ "FROM Inventario_Lote il "
//		+ ", Inventario i "
//		+ ", Producto p  "
//	+ "where il.Lot_ID = i.Inv_LoteIngreso  "
//		//+ "AND i.Inv_EnAlmacen = 0  "
//		+ "and Lot_Dummy = 0  "
//		+ "and i.Pro_ID = p.Pro_ID "
//		 
//		+ "and i.Cli_ID = " + Cli_ID + " "
//		+ "AND Alm_ID = " + Alm_ID
   

//HA ID: 2 SE cambia el conteo actual por el disponible EstatusCG20 = 2 y que no esté en transferencia ni apartado
var sqlInvTie = "SELECT Pro.Pro_ID "
            + "    , PRo.PRo_Nombre "
                + ", Pro.Pro_Descripcion "
                + ", Pro.Pro_SKU SKU "
                + ", COUNT(*) AS ConteoInicial "
                + ", SUM( CASE WHEN Inv.Inv_EstatusCG20 in (1) "
                                //+ " AND ISNULL(inv.Inv_EnTransferencia, 0) = 0 "
                                //+ " AND ISNULL(inv.Inv_EsApartado, 0) = 0 "
                                + " and inv_Estatuscg20 = 1 "               
                                + " and Inv_EnAlmacen = 1 "
                           + " THEN 1 ELSE 0 END ) AS CantidadActual "
           + " FROM Inventario Inv "
                + "INNER JOIN Producto PRo "
                   + " ON Inv.Pro_ID = Pro.Pro_ID "
           + " WHERE Inv.Cli_ID = " + Cli_ID + " "
               + " AND Inv.Alm_ID = " + Alm_ID + " "
      + "  GROUP BY Pro.Pro_ID "
               + " , PRo.PRo_Nombre "
               + " , Pro.Pro_Descripcion "
               + " , Pro.Pro_SKU "
	 
var rsInvTie = AbreTabla( sqlInvTie, 1 , 0 )

%>						
					<div class="ibox-content">
						<div class="table-responsive">
                            <table class="table table-hover issue-tracker">
								<thead>
									<tr>
                                        <th>Num</th>
										<th>Producto</th>
										<th  class="text-right">Cantidad Inicial</th>
										<th  class="text-right">Cantidad Actual</th>
									</tr>
								</thead>
                                <tbody>
<%
var iCons = 1
while( !(rsInvTie.EOF) ){
%>
                                <tr>
                                    <td class="text-right"><%= iCons %></td>
									<td class="issue-info">
                                        <a href="#">
                                            <%= rsInvTie("SKU") %> - <%= rsInvTie("Pro_Nombre") %>
                                        </a>
                                        <small>
											<%= rsInvTie("Pro_Descripcion") %>
                                        </small>
                                    </td>
                                    <td class="text-right"><%= formato(rsInvTie("ConteoInicial"),0) %></td>
                                    <td class="text-right"><%= formato(rsInvTie("CantidadActual"),0) %></td>
                                </tr>
<%
	rsInvTie.MoveNext()
    iCons++
}
%>
                               
                                </tbody>
                            </table>
                        </div>
                    </div>
<%
rsInvTie.close()
%>
<script type="text/javascript">

    $(document).ready(function(){
 
        $("#Cli_ID").val(<%=Cli_ID%>);
       
    })
    
</script>
