<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%> 
<!--#include file="../../../Includes/iqon.asp" -->
<%
   
    var bDebug = false
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
           
               var sSQLHist = "SELECT dbo.fn_CatGral_DameDato(51,OV_EstatusCG51) AS ESTATUS, CONVERT(NVARCHAR, OV_FechaCambio,22) AS FECHA, OV_FechaCambio "
                   sSQLHist += "FROM Orden_Venta_Historia WHERE OV_ID = " + OV_ID
                   sSQLHist += "ORDER BY OV_FechaCambio "
               
                   if(bDebug){ Response.Write(sSQLHist) }
               
                 var rsHist = AbreTabla(sSQLHist,1,0)

                 while (!rsHist.EOF){
                     iRenglon++               
               
            %>                
            <tr>
               <td><small><strong><%Response.Write(rsHist.Fields.Item("ESTATUS").Value)%></strong></small></td>
               <td><i class="fa fa-clock-o"></i>&nbsp;<%Response.Write(rsHist.Fields.Item("FECHA").Value)%></td>
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
    
<div class="wrapper wrapper-content animated fadeInRight">
    <div class="row">
        <div class="ibox">
            <div class="ibox-content">
               <div class="tab-content">
                  <div class="tab-pane active" id="contact-1">
                     <!-- div class="client-detail"  -->
                        <div class="full-height-scroll">
                           <strong>Rastreo</strong>
                           <div class="vertical-container dark-timeline" id="vertical-timeline">
                                <%
                                   var iRengRas = 0

                                   var sSQLRas = "SELECT CONVERT(NVARCHAR(20), ProvR_Fecha,22) AS FECHA, ProvR_Fecha"
								       sSQLRas += " , ProvR_Evento, ProvR_Observaciones, ProvR_Localizacion "
                                       sSQLRas += " FROM Proveedor_Rastreo "
								       sSQLRas += " WHERE OV_ID = " + OV_ID
								       sSQLRas += " AND TA_ID = " + TA_ID
                                       sSQLRas += " ORDER BY ProvR_Fecha DESC "

                                       if(bDebug){ Response.Write(sSQLRas) }

                                     var rsRas = AbreTabla(sSQLRas,1,0)

                                     while (!rsRas.EOF){
                                         iRengRas++               

                                %>                
                              <div class="vertical-timeline-block">
                                 <div class="vertical-timeline-icon navy-bg">
                                    <!--<i class="fa fa-coffee"></i>-->
                                 </div>
                                 <div class="vertical-timeline-content">
                                     <h3><%Response.Write(rsRas.Fields.Item("ProvR_Evento").Value)%></h3>
                                     <p><%Response.Write(rsRas.Fields.Item("ProvR_Observaciones").Value)%></p><span class="vertical-date small text-muted"> <i class="fa fa-calendar"> </i> <%Response.Write(rsRas.Fields.Item("FECHA").Value)%>&nbsp;&nbsp; <i class="fa fa-map-marker"> </i> <%Response.Write(rsRas.Fields.Item("ProvR_Localizacion").Value)%></span>
                                 </div>
                              </div>
                                <%
                                    rsRas.MoveNext() 
                                    }
                                rsRas.Close()   

                                %>                    
                           </div>
                        </div>
                     <!-- /div  -->
                  </div>

               </div>
            </div>
        </div>
   </div>
</div>    
<!-- script src="/Template/inspina/js/inspinia.js"></script  -->    
<!-- script src="/Template/inspina/js/plugins/slimscroll/jquery.slimscroll.min.js"></script  -->      
    