<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include file="../../../Includes/iqon.asp" -->
<%
   var bIQDebug = false 
   var TA_ID = Parametro("TA_ID",-1)
   var Usu_ID = Parametro("Usu_ID",-1)
   var Gru_ID = Parametro("SegGrupo",1)
   
   if(bIQDebug){ Response.Write("<br>TA_ID: " + TA_ID) }
   
   var Cajas =  BuscaSoloUnDato("TA_CantidadCaja","TransferenciaAlmacen","TA_ID = " + TA_ID,1,0)
   var sCajas = "1 caja"
   if(Cajas<1){
       Cajas = 1 
   }
   if(Cajas>1){
       sCajas =  Cajas +" cajas"
   }
   if(TA_ID > -1){
   
%>
<link href="/Template/inspina/css/plugins/clockpicker/clockpicker.css" rel="stylesheet">
    <link href="/Template/inspina/css/plugins/datapicker/datepicker3.css" rel="stylesheet">
    <div class="ibox float-e-margins">
        <div class="ibox-title">
          <h5><i class="fa fa-cube"></i> <%=sCajas%></h5>
        </div>
    </div>
        
<div class="ibox float-e-margins">
   <div class="ibox-title">
      <h5><i class="fa fa-clock-o"></i> Hist&oacute;rico</h5>
   </div>
   <div class="ibox-content">
      <table width="27%" class="table table-hover no-margins">
         <thead>
            <tr>
               <th width="42%">Estatus</th>
               <th width="58%">Fecha</th>
            </tr>
         </thead>
         <tbody>
            <%
               var iRenglon = 0
               var stts = 0
               var sFecha = ""
               var sHora = ""
           
               var sSQLHist  = "SELECT dbo.fn_CatGral_DameDato(51,TA_EstatusCG51) AS ESTATUS, TA_EstatusCG51 "
                   sSQLHist += ",CONVERT(NVARCHAR, TA_FechaRegistro,103) AS FECHA "
                   sSQLHist += ", CONVERT(NVARCHAR, TA_FechaRegistro,108) AS HORA "
                   sSQLHist += " FROM TransferenciaAlmacen_Historico "
                   sSQLHist += " WHERE TA_ID = " + TA_ID
                   sSQLHist += " ORDER BY TA_FechaRegistro ASC " 
               
                 if(bIQDebug){ Response.Write("<br>sSQLHist: " + sSQLHist) }
               
                 var rsHist = AbreTabla(sSQLHist,1,0)

                 while (!rsHist.EOF){
                     iRenglon++  
                     stts = rsHist.Fields.Item("TA_EstatusCG51").Value
                     sFecha = rsHist.Fields.Item("FECHA").Value
                     sHora = rsHist.Fields.Item("HORA").Value
            %>                
            <tr>
               <td><small><strong><%Response.Write(rsHist.Fields.Item("ESTATUS").Value)%></strong></small></td>
               <td><i class="fa fa-clock-o" data-stts="<%=stts%>"  data-fecha="<%=sFecha%>"></i>&nbsp;
                   <span id="hora<%=stts%>">
                       <%= sFecha %>&nbsp;<%= sHora %>
                   </span>
               </td>
             </tr>      
            <tr id="tr_fch<%=stts%>" class="tr_fechas" style="display: none">
               <td colspan="2"  id="fch<%=stts%>">
                
                
                 <div class='input-group date' style='width: 52%; float:left'> 
                     <span class='input-group-addon'><i class='fa fa-calendar'></i></span>
                    <input type='text' id="cbFch<%=stts%>" class='form-control' value='<%= sFecha %>'>
                </div>
                <div class='input-group clockpicker' data-autoclose='true' style='width: 25%; float:left'>
                    <input type='text' id="cbHra<%=stts%>" class='form-control' value='<%= sHora %>' >
                </div>
                <div class='input-group' style='float:left;padding-top: 5px;padding-left: 6px;'>
                     <button class='btn btn-primary btn-xs fchOk' type='button'
                             data-stts="<%=stts%>"><i class='fa fa-check'></i></button>
                     <button class='btn btn-danger btn-xs fchX' type='button'><i class='fa fa-times'></i></button>
                </div>
                </td>
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

<script type="application/javascript">
    
  $(document).ready(function(){



  });

</script>

<% } else {
  Response.Write("Ocurri&oacute; un error al cargar intenta de nuevo")	
	
}
%>
<%
// =============================================
// Author: JD
// Create date: 13/04/2021
// Description:	Histórico de la primer Transferencia de la Guía seleccionada
// ----- Modify ------
// Author: JD
// Modify date: 15/04/2021
// Description: Cambios de la información a mostrar
// Author: 
// Modify date: dd/mm/aaaa
// Description:
// =============================================   
%>      
