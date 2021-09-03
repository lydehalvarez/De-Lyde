<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%> 
<!--#include file="../../../Includes/iqon.asp" -->
<%

	var Prov_ID = Parametro("Prov_ID",-1)
	var OC_ID = Parametro("OC_ID",-1)
  
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

             var sSQL  = " SELECT Prov_ID, OC_ID, OCP_ID, OCP_Partida "
				 sSQL += " , OCP_SKU, OCP_Sol_Ped_Pur_Req, OCP_FechaEntrega "
				 sSQL += " , OCP_UDM, OCP_Cantidad, OCP_PrecioUnitario "
				 sSQL += " , OCP_Total, OCP_CantidadEntregada "
			     sSQL += " , Pro_Nombre, Pro_Descripcion "
			     sSQL += " , (SELECT OC_SubTotal FROM Proveedor_OrdenCompra "
						  sSQL += " WHERE Prov_ID = " + Prov_ID
			              sSQL += " AND OC_ID = " + OC_ID + ") as SubTotal "
			   	 sSQL += " , (SELECT OC_IVA FROM Proveedor_OrdenCompra "
						  sSQL += " WHERE Prov_ID = " + Prov_ID
			              sSQL += " AND OC_ID = " + OC_ID + ") as IVA "
                 sSQL += " FROM Proveedor_OrdenCompra_Articulos a, Producto p " 
                 sSQL += " WHERE a.Pro_ID = p.Pro_ID "
			     sSQL += " AND Prov_ID = " + Prov_ID
			     sSQL += " AND OC_ID = " + OC_ID
										                            
                 var rsArticulos = AbreTabla(sSQL,1,0)

                 while (!rsArticulos.EOF){
                   iRenglon++
                   Suma += rsArticulos.Fields.Item("OCP_Total").Value
                   Llaves = Prov_ID + "," + OC_ID
                   Llaves += "," + rsArticulos.Fields.Item("OCP_ID").Value
				   IVA = rsArticulos.Fields.Item("IVA").Value
			       SubTotal = rsArticulos.Fields.Item("SubTotal").Value

            %>             
            <tr>
                
                <td class="text-center"><div><strong><%Response.Write(iRenglon)%></strong></div></td>
                <td class="text-left"><%Response.Write(rsArticulos.Fields.Item("OCP_SKU").Value)%></td>    
                <td class="text-left form-group row issue-info">
                	<a href="#" onclick="Carga.Ver(<%= rsArticulos("Prov_ID").Value %>, <%= rsArticulos("OC_ID").Value %>, <%= rsArticulos("OCP_ID").Value %>)">
                    	<i class="fa fa-tag"></i> <%= rsArticulos("Pro_Nombre").Value %>
                    </a>
                	<small>
                        <%= rsArticulos("Pro_Descripcion").Value %>
                    </small>

                </td>   
                <td class="text-center"><%Response.Write(rsArticulos.Fields.Item("OCP_Cantidad").Value)%></td>
                <td class="text-right" style="white-space: nowrap;"><%Response.Write(FM + " " + formato(rsArticulos.Fields.Item("OCP_PrecioUnitario").Value,2))%></td>    
                <td class="text-right" style="white-space: nowrap;"><%Response.Write(FM + " " + formato(rsArticulos.Fields.Item("OCP_Total").Value,2))%></td>   
                <td class="text-center">
                    <% if(Parametro("BPM_Flujo",-1) == 1) { %>
                        <a id="btnCargaArticulo" href="javascript:MuestraArticulo(<%=rsArticulos.Fields.Item("OCP_ID").Value%>);" class="btn-white btn btn-xs" type="button"><i class="fa fa-eye"></i> Ver</a>
                    <% } if(Parametro("BPM_Flujo",-1) == 2) { %>
                        <a id="btnCargaArticulo" href="javascript:MuestraArticulo(<%=rsArticulos.Fields.Item("OCP_ID").Value%>);" class="btn-white btn btn-xs" type="button"><i class="fa fa-handshake-o"></i> Autorizar</a>
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

    
    
    
    