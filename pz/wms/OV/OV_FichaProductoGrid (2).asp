<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%> 
<!--#include file="../../../Includes/iqon.asp" -->
<%
   
    var bDebug = false
	var OV_ID = Parametro("OV_ID",-1)
   
   
   
%>
    
<div class="table-responsive">
    <table class="table table-hover table-striped">
        <tbody>
            <%
               var iRenglon = 0
               
               var sSQLProd = "SELECT Pro_ClaveAlterna AS SKU, Pro_Nombre, Pro_Descripcion "
                   sSQLProd += ",OV_ID, OVA_ID, OV_CORID, OV_CUSTOMER_SO "
                   sSQLProd += ",(SELECT ovp.OVP_Serie FROM Orden_Venta_Picking ovp WHERE ovp.OV_ID = a.OV_ID AND ovp.OVA_ID = a.OVA_ID) AS SERIEPICKING "
                   sSQLProd += "from Orden_Venta_Articulo a, Producto p "
                   sSQLProd += "where p.Pro_ID = a.Pro_ID "
                   sSQLProd += "and OV_ID = " + OV_ID
               
                   if(bDebug){ Response.Write(sSQLProd) }
               
                 var rsProd = AbreTabla(sSQLProd,1,0)

                 while (!rsProd.EOF){
                     iRenglon++               
               
            %>
            <tr>
                <td class="text-center">
                    <div style="font-size: xx-large;text-align:center">
                        <span class="text-navy"><%Response.Write(iRenglon)%></span>
                    </div>
                </td>
                <td style="width:80%">
                    <div class="row">
                        <div class="col-md-9">
                            <span class="text-navy"><h3>SKU: <%Response.Write(rsProd.Fields.Item("SKU").Value)%> - <%Response.Write(rsProd.Fields.Item("Pro_Nombre").Value)%></h3></span>
                            <h3><%Response.Write(rsProd.Fields.Item("Pro_Descripcion").Value)%></h3>
                        </div>
                        <div class="col-md-3" style="font-size: xx-large;padding-right: 35px;text-align:right">
                        	<span class="text-navy"></span>
                        </div>                                
                    </div>
                    <div class="row">
                    <small><i class="fa fa-lightbulb-o"> </i>&nbsp;<strong>CORID:</strong> <%Response.Write(rsProd.Fields.Item("OV_CORID").Value)%>
                    &nbsp;&nbsp;<i class="fa fa-barcode"> </i>&nbsp;<strong>Serie Picking:</strong> <%Response.Write(rsProd.Fields.Item("SERIEPICKING").Value)%>              
                    </small> 
                    </div>
                </td>
                <td class="text-center"></td>        
            </tr>
            <%
                rsProd.MoveNext() 
                }
            rsProd.Close()   

            %>          
        </tbody>
    </table>
</div>                         
    
    
    
    
