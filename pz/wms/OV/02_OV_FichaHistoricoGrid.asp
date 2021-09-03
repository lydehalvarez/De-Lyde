<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%> 
<!--#include file="../../../Includes/iqon.asp" -->
<%
//HA ID: 2 2020-Jul-22	Agregado de Comentarios y Bitacora: Se quita la scción de Rastreo

   
	var OV_ID = Parametro("OV_ID",-1)
	var TA_ID = Parametro("TA_ID",-1)
   
%>
    
<div class="ibox float-e-margins">
   <div class="ibox-title">
      <h5><i class="fa fa-clock-o"></i> Hist&oacute;rico</h5>
      <!--div class="ibox-tools">
         <a class="collapse-link"><i class="fa fa-chevron-up"></i></a> <a class="close-link"><i class="fa fa-times"></i></a>
      </div-->
   </div>
   <div class="ibox-content">
      <table class="table table-hover no-margins">
         <thead>
            <tr>
               <th>Estatus</th>
               <th>Fecha</th>
            </tr>
         </thead>
         <tbody>
            <%
               var iRenglon = 0
           
               var sSQLHist = "SELECT dbo.fn_CatGral_DameDato(51,OV_EstatusCG51) AS ESTATUS "
                            + ", CONVERT(NVARCHAR, OV_FechaCambio,103) AS FECHA "
                            + ", CONVERT(NVARCHAR, OV_FechaCambio,108) AS HORA "
                            + ", OV_FechaCambio "
                            + " FROM Orden_Venta_Historia "
                            + " WHERE OV_ID = " + OV_ID
                        + " AND OV_Reintento = 1 "
                            + " ORDER BY OV_FechaCambio "
               
                 var rsHist = AbreTabla(sSQLHist,1,0)

                 while (!rsHist.EOF){
                     iRenglon++               
               
            %>                
            <tr>
               <td><small><strong><%Response.Write(rsHist.Fields.Item("ESTATUS").Value)%></strong></small></td>
               <td><i class="fa fa-clock-o"></i>&nbsp;<%Response.Write(rsHist.Fields.Item("FECHA").Value)%>&nbsp;<%Response.Write(rsHist.Fields.Item("HORA").Value)%> </td>
            </tr>
            <%
                rsHist.MoveNext() 
                }
            rsHist.Close()   

            %>                 
         </tbody>
      </table>
   </div>
</div>
<% //HA ID: 2 Se Elimina Rastreo
%> 
