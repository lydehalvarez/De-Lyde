<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%> 
<!--#include file="../../../Includes/iqon.asp" -->
<%
//HA ID: 2 2020-Jul-22	Agregado de Comentarios y Bitacora: Se quita la scción de Rastreo

   
	var OV_ID = Parametro("OV_ID",-1)
	var TA_ID = Parametro("TA_ID",-1)

if(OV_ID > -1) {
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

<div class="ibox float-e-margins">
   <div class="ibox-title">
      <h5><i class="fa fa-truck"></i> Guias asignadas</h5>
      <!--div class="ibox-tools">
         <a class="collapse-link"><i class="fa fa-chevron-up"></i></a> <a class="close-link"><i class="fa fa-times"></i></a>
      </div-->
   </div>
   <div class="ibox-content">
      <table class="table table-hover no-margins">
         <thead>
            <tr>
               <th>Guia</th>
               <th>Estatus</th>
               <th>Fecha Registro</th>
            </tr>
         </thead>
         <tbody>
            <%
               var sSQLGuia = "SELECT ProG_NumeroGuia, ISNULL([dbo].[fn_CatGral_DameDato](51,ProG_EstatusCG51),'Sin estatus') Estatus"+
			   			", CONVERT(NVARCHAR(10),ProG_FechaRegistro,103) + ' - ' +CONVERT(NVARCHAR(10),ProG_FechaRegistro,108) + ' hrs' as Fecha" +
						" FROM [dbo].[Proveedor_Guia] " +
						" WHERE OV_ID = " + OV_ID +
						" ORDER BY  ProG_FechaRegistro ASC "  
						             
                 var rsGuia = AbreTabla(sSQLGuia,1,0)

				 var Guia = ""
				 var Fecha = ""
				 var Estatus = ""
                 while (!rsGuia.EOF){
					 Guia = rsGuia.Fields.Item("ProG_NumeroGuia").Value
					 Fecha = rsGuia.Fields.Item("Fecha").Value
					 Estatus = rsGuia.Fields.Item("Estatus").Value
            %>                
            <tr>
               <td><small><strong><%=Guia%></strong></small></td>
               <td><small><strong><%=Estatus%></strong></small></td>
               <td><i class="fa fa-clock-o"></i>&nbsp;<%=Fecha%> </td>
            </tr>
            <%
                rsGuia.MoveNext() 
                }
            rsGuia.Close()   

            %>                 
         </tbody>
      </table>
   </div>
</div>

<% //HA ID: 2 Se Elimina Rastreo
}
%> 
