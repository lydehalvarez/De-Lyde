<%@LANGUAGE="JAVASCRIPT" CODEPAGE="65001"%>
<!--#include file="../../../Includes/iqon.asp" -->
<%
// HA ID: 1 29-jun-2020 Creación de Archivo: Reporte de inventario en tiendas

var rqIntCli_Id = Parametro("Cli_ID", -1)
var rqIntAlm_Id = Parametro("Alm_ID", -1)

var sqlInvTie = "SELECT DISTINCT i.Pro_ID "
		+ ", [Pro_ClaveAlterna] as SKU "
		+ ", [Pro_Nombre] "
		+ ", [Pro_Descripcion] "
		+ ", ( "
			+ "select count(*) "
			+ "from Inventario i2, Inventario_Lote il2 "
			+ "where il2.Lot_Dummy = 0 and "
				+ "il2.Lot_ID =  i2.[Inv_LoteIngreso] "
				+ "AND i2.Pro_ID = i.Pro_ID "
				+ "and i.Cli_ID = i2.Cli_ID "
		+ ") as ConteoInicial "
		+ ", ( "
			+ "select count(*) " 
			+ "from Inventario i2 "
				+ ", Inventario_Lote il2  "
			+ "where il2.Lot_Dummy = 0  "
				+ "and il2.Lot_ID =  i2.[Inv_LoteIngreso] "
				+ "AND i2.Pro_ID = i.Pro_ID  "
				+ "and i.Cli_ID = i2.Cli_ID   "
				+ "and i2.Inv_EnAlmacen = 1 "
		+ ") as CantidadActual "
	+ "FROM Inventario_Lote il "
		+ ", Inventario i "
		+ ", Producto p  "
	+ "where il.Lot_ID = i.Inv_LoteIngreso  "
		+ "AND i.Inv_EnAlmacen = 0  "
		+ "and Lot_Dummy = 0  "
		+ "and i.Pro_ID = p.Pro_ID "
		 
		+ "and i.Cli_ID = " + rqIntCli_Id + " "
		+ "AND Alm_ID = " + rqIntAlm_Id
		
var rsInvTie = AbreTabla( sqlInvTie, 1 , 0 )

%>						
					<div class="ibox-content">
						<div class="table-responsive">
                            <table class="table table-hover issue-tracker">
								<thead>
									<tr>
										<th>Producto</th>
										<th>Cantidad Inicial</th>
										<th>Cantidad Actual</th>
									</tr>
								</thead>
                                <tbody>
<%
while( !(rsInvTie.EOF) ){
%>
                                <tr>
									<td class="issue-info">
                                        <a href="#">
                                            <%= rsInvTie("SKU") %> - <%= rsInvTie("Pro_Nombre") %>
                                        </a>
                                        <small>
											<%= rsInvTie("Pro_Descripcion") %>
                                        </small>
                                    </td>
                                    <td><%= rsInvTie("ConteoInicial") %></td>
                                    <td><%= rsInvTie("CantidadActual") %></td>
                                </tr>
<%
	rsInvTie.MoveNext()
}
%>
                               
                                </tbody>
                            </table>
                        </div>
                    </div>
<%
rsInvTie.close()
%>