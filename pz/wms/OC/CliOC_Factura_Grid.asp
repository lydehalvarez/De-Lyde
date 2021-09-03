<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%> 
<!--#include file="../../../Includes/iqon.asp" -->
<%
 // HA ID: 2 2020-JUL-17 Se agrega Metodos de Detalle de Carga
 
	var Cli_ID = Parametro("Cli_ID",-1)
	var CliOC_ID = Parametro("CliOC_ID",-1)
  
%>
<div class="table-responsive">
    <table class="table table-hover table-striped">
        <thead>
            <tr>
                <th width="18" class="text-center">#</th>
                <th width="32" class="text-center">SKU</th>
                <th width="260" class="text-center">Nombre</th>
                <th width="60" class="text-center">Cantidad</th>
                <th width="86" class="text-center">Precio unitario</th>
                <th width="98" class="text-center">Total</th>
                <th width="180" class="text-center">Acci&oacute;n</th>
            </tr>
        </thead>
        <tbody>
            <%

             var Llaves = ""
             var iRenglon = 0  
             var Suma = 0
             var SumaDesc = 0   
             var Folio = ""
			 var IVA = 0
			 var SubTotal = 0

             var sSQL  = " SELECT Cli_ID, CliOC_ID, CliOCP_ID, CliOCP_Partida, CliOCP_SKU "
				 sSQL += " , CliOCP_Sol_Ped_Pur_Req, CliOCP_FechaEntrega "
				 sSQL += " , CliOCP_UDM, CliOCP_Cantidad, CliOCP_PrecioUnitario "
				 sSQL += " , CliOCP_Total, CliOCP_CantidadEntregada  "
			     sSQL += " , Pro_Nombre, Pro_Descripcion "
			     sSQL += " , (SELECT CliOC_SubTotal FROM Cliente_OrdenCompra "
						  sSQL += " WHERE Cli_ID = " + Cli_ID
			              sSQL += " AND CliOC_ID = " + CliOC_ID + ") as SubTotal "
			   	 sSQL += " , (SELECT CliOC_IVA FROM Cliente_OrdenCompra "
						  sSQL += " WHERE Cli_ID = " + Cli_ID
			              sSQL += " AND CliOC_ID = " + CliOC_ID + ") as IVA "
                 sSQL += " FROM Cliente_OrdenCompra_Articulos a, Producto p " 
                 sSQL += " WHERE a.Pro_ID = p.Pro_ID "
			     sSQL += " AND Cli_ID = " + Cli_ID
			     sSQL += " AND CliOC_ID = " + CliOC_ID
										                            
                 var rsArticulos = AbreTabla(sSQL,1,0)

                 while (!rsArticulos.EOF){
                   iRenglon++
                   Suma += rsArticulos.Fields.Item("CliOCP_Total").Value
                   Llaves = Cli_ID + "," + CliOC_ID
                   Llaves += "," + rsArticulos.Fields.Item("CliOCP_ID").Value
				   IVA = rsArticulos.Fields.Item("IVA").Value
			       SubTotal = rsArticulos.Fields.Item("SubTotal").Value

            %>             
            <tr>
                
                <td class="text-center"><div><strong><%Response.Write(iRenglon)%></strong></div></td>
                <td class="text-left"><%Response.Write(rsArticulos.Fields.Item("CliOCP_SKU").Value)%></td>    
                <td class="text-left form-group row issue-info">
                	<a href="#" onclick="Carga.Ver(<%= rsArticulos("Cli_ID").Value %>, <%= rsArticulos("CliOC_ID").Value %>, <%= rsArticulos("CliOCP_ID").Value %>)">
                    	<i class="fa fa-tag"></i> <%= rsArticulos("Pro_Nombre").Value %>
                    </a>
                	<small>
                        <%= rsArticulos("Pro_Descripcion").Value %>
                    </small>

                </td>   
                <td class="text-center"><%Response.Write(rsArticulos.Fields.Item("CliOCP_Cantidad").Value)%></td>
                <td class="text-right" style="white-space: nowrap;"><%Response.Write(FM + " " + formato(rsArticulos.Fields.Item("CliOCP_PrecioUnitario").Value,2))%></td>    
                <td class="text-right" style="white-space: nowrap;"><%Response.Write(FM + " " + formato(rsArticulos.Fields.Item("CliOCP_Total").Value,2))%></td>   
                <td class="text-center">
                    <% if(Parametro("OC_BPM_Flujo",-1) == 1) { %>
                        <a id="btnCargaArticulo" href="javascript:MuestraArticulo(<%=rsArticulos.Fields.Item("CliOCP_ID").Value%>);" class="btn-white btn btn-xs" type="button"><i class="fa fa-eye"></i> Ver</a>
                    <% } if(Parametro("OC_BPM_Flujo",-1) == 2) { %>
                        <a id="btnCargaArticulo" href="javascript:MuestraArticulo(<%=rsArticulos.Fields.Item("CliOCP_ID").Value%>);" class="btn-white btn btn-xs" type="button"><i class="fa fa-handshake-o"></i> Autorizar</a>
                    <% } %>    
                </td>
            </tr>
            <%
                rsArticulos.MoveNext() 
                }
            rsArticulos.Close()   

            %>
            <tr>   
                <td class="text-center">&nbsp;</td>
				<td class="text-center">&nbsp;</td>
                <td class="text-center">&nbsp;</td>
                <td class="text-center">&nbsp;</td>
                <td colspan="2" class="text-right"><strong>Sub Total :&nbsp;&nbsp;<%Response.Write(FM + " " + formato(SubTotal,2))%></strong></td>
                <td class="text-right">&nbsp;</td>
            </tr>  
            <tr>   
                <td class="text-center">&nbsp;</td>
				<td class="text-center">&nbsp;</td>
                <td class="text-center">&nbsp;</td>
                <td class="text-center">&nbsp;</td>
                <td colspan="2" class="text-right"><strong>IVA :&nbsp;&nbsp;<%Response.Write(FM + " " + formato(IVA,2))%></strong></td>
                <td class="text-right">&nbsp;</td>
            </tr>  		
            <tr>   
                <td class="text-center">&nbsp;</td>
				<td class="text-center">&nbsp;</td>
                <td class="text-center">&nbsp;</td>
                <td class="text-center">&nbsp;</td>
                <td colspan="2" class="text-right"><strong>Total :&nbsp;&nbsp;<%Response.Write(FM + " " + formato(Suma,2))%></strong></td>
                <td class="text-right">&nbsp;</td>
            </tr>                    
        </tbody>
    </table>
</div>

    
    
    
    