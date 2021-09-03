<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include file="../../../Includes/iqon.asp" -->
<%
   
  var bIQDebug = false 
  var OV_ID = Parametro("OV_ID",-1)   

  if(bIQDebug){ Response.Write("OV_ID:" + OV_ID) }   
   
   
if(OV_ID > -1) {   
%>
<div class="ibox float-e-margins">
  <div class="ibox-title">
    <h5><i class="fa fa-clock-o"></i> Hist&oacute;rico</h5><!--div class="ibox-tools">
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

           var sSQLHist  = "SELECT dbo.fn_CatGral_DameDato(51,OV_EstatusCG51) AS ESTATUS "
               sSQLHist += ",CONVERT(NVARCHAR, OV_FechaCambio,103) AS FECHA "
               sSQLHist += ",CONVERT(NVARCHAR, OV_FechaCambio,108) AS HORA "
               sSQLHist += ",OV_FechaCambio "
               sSQLHist += "FROM Orden_Venta_Historia "
               sSQLHist += "WHERE OV_ID = " + OV_ID
               sSQLHist += " ORDER BY OV_FechaCambio "

           var rsHist = AbreTabla(sSQLHist,1,0)

             while (!rsHist.EOF){
                 iRenglon++               

        %>
        <tr>
          <td><small><strong><%Response.Write(rsHist.Fields.Item("ESTATUS").Value)%></strong></small></td>
          <td><i class="fa fa-clock-o"></i>&nbsp;<%Response.Write(rsHist.Fields.Item("FECHA").Value)%>&nbsp;<%Response.Write(rsHist.Fields.Item("HORA").Value)%></td>
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
<% } %>  
<%
// =============================================
// Author: JD
// Create date: 13/04/2021
// Description:	Histórico de la primer Orden de Venta de la Guía seleccionada
// ----- Modify ------
// Author: JD
// Modify date: 15/04/2021
// Description: Cambios de la información a mostrar
// Author: 
// Modify date: dd/mm/aaaa
// Description:
// =============================================   
%>  
  