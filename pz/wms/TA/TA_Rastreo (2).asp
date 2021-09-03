<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%> 
<!--#include file="../../../Includes/iqon.asp" -->
<%


    var TA_ID = Parametro("TA_ID", -1)
		
    var sqlPrvR = "SELECT ProG.ProG_FechaRegistro "
            + ", ProG.ProG_NumeroGuia "
            + ", CONVERT(NVARCHAR(20), ProvR.ProvR_Fecha,22) AS FECHA "
            + ", ProvR.ProvR_Fecha "
            + ", ProvR.ProvR_Evento "
            + ", ProvR.ProvR_Observaciones "
            + ", ProvR.ProvR_Localizacion "
         + " FROM Proveedor_Rastreo ProvR, Proveedor_Guia ProG "
        + " WHERE ProvR.ProG_ID = ProG.ProG_ID "
          + " AND ProvR.Prov_ID = ProG.Prov_ID "
          + " AND ProG.TA_ID = " + TA_ID 
        + " ORDER BY ProvR.ProvR_Fecha DESC "
   
  		var rsPrvR = AbreTabla(sqlPrvR, 1, 0)
		
		var strNumeroGuia = ""
		var i = 0 
%>
   		<div class="panel-body"> 
<%
		while ( !(rsPrvR.EOF) ){
			i++
		
			//Encabeado e inicio de  Acordeon
			if( strNumeroGuia != rsPrvR("ProG_NumeroGuia").Value ){
%>
	        	<div class="panel-group" id="accordionOrdenVenta">
               
					<div class="panel panel-<%= (i == 1) ? "success": "info" %>">
                        <div class="panel-heading">
                            <h5 class="panel-title">
                                <a class="form-group row" data-toggle="collapse" data-parent="#accordionOrdenVenta" href="#collapse<%= i %>">
                                   <i class="fa fa-location-arrow"></i> No. Guia: <%= rsPrvR("ProG_NumeroGuia").Value %>
                                </a>
                            </h5>
                        </div>
                        <div id="collapse<%= i %>" class="panel-collapse collapse in">
                            <div class="panel-body">
                            	<div class="vertical-container dark-timeline" id="vertical-timeline">
<%				
			}
%> 
                                
                                    <div class="vertical-timeline-block">
                                        <div class="vertical-timeline-icon navy-bg">
                                            <i class="fa fa-map-marker"></i>
                                        </div>
                                        <div class="vertical-timeline-content">
                                            <h3><%= rsPrvR("ProvR_Evento").Value %></h3>
                                            <p><%= rsPrvR("ProvR_Observaciones").Value %></p>
                                            <span class="vertical-date small text-muted"> 
                                                <i class="fa fa-calendar"> </i> <%= rsPrvR("FECHA").Value %>
                                                &nbsp;&nbsp; 
                                                <i class="fa fa-map-marker"> </i> <%= rsPrvR("ProvR_Localizacion").Value %>
                                            </span>
                                        </div>
                                    </div>
<%
			strNumeroGuia = rsPrvR("ProG_NumeroGuia").Value
			
			rsPrvR.MoveNext() 
			
			//Pie y final de Acordeon
			if( rsPrvR.EOF || ( !(rsPrvR.EOF) && strNumeroGuia != rsPrvR("ProG_NumeroGuia").Value ) ){
%>
                                </div>
							</div>
                    	</div>
                    </div>
                </div>
<%				
			}
		}
		
		rsPrvR.Close()   
%>                    
		</div>