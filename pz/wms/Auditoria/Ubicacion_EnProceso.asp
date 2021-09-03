<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%> 
<!--#include virtual="/Includes/iqon.asp" -->
<%
    // HA ID: 2     2021-AGO-04 Ajustes: Agrega Estatus del pallet

    var rqIntAud_ID = Parametro("Aud_ID", -1);
        
     // HA ID: 2 Se agrega estatus (2)
    var sqlAudU = "EXEC SPR_Auditorias_Ubicacion "
          + "@Opcion = 1000 "
        + ", @Aud_ID = " + rqIntAud_ID + " "
        + ", @AudPT_Est_ID = 2 "

    var rsAudU = AbreTabla(sqlAudU,1,0)
%>

<div class="wrapper wrapper-content">
    <div class="row animated fadeInRight">
        <div class="col-lg-12">
            <div class="ibox">
                <div class="ibox-title">
                    <h4>Resultado de las visitas a la ubicaci&oacute;n</h4>
                </div>
<%
    if(!rsAudU.EOF) {

        var bolIni = true;
        while( !(rsAudU.EOF) ) {
            
%>
                <div class="row">
                    <div class="col-lg-12">
                        <div class="m-b-md">
<%          if(! bolIni ) {
                bolIni = false
%>                                                        
                            <a class="btn btn-info btn-sm pull-right" title="NuevaVisita" 
                             onclick="AUbicacion.Crear();">
                                <i class="fa fa-plus"></i> Nueva Visita
                            </a>
<%          }
%>
                            <a class="btn btn-white btn-sm pull-right" style="margin-right: 5px;"
                             title="Imprimir Papeleta" onclick='ImprimirPapeleta(<%= rsAudU("Aud_ID").Value %>, <%= rsAudU("PT_ID").Value %>);'>
                                <i class="fa fa-print"></i> Papeleta
                            </a>

                            <h2> 
                                <img width="40" height="40" title="<%= rsAudU("Usu_Nombre").Value %>" class="img-circle" src='<%= rsAudU("Usu_Imagen").Value %>'>
                                 <%= rsAudU("Usu_Nombre").Value %>
                            </h2>
                        </div>
                        
                    </div>
                </div>

                <div class="row">
                    <div class="col-lg-6">
                        <dl class="dl-horizontal">

                            <dt>Cantidad:</dt> 
                                <dd class="text-navy">
                                    <h1><%= rsAudU("PT_Cantidad_Actual").Value %></h1>
                                </dd>
                        </dl>
                    </div>
                    <div class="col-lg-6">
                        <dl class="dl-horizontal">

                            <dt>Conteo Auditor:</dt> 
                                <dd class="text-navy">
                                    <h1><%= rsAudU("AudU_ArticulosConteoTotal").Value %></h1>
                                </dd>
                        </dl>
                    </div>
                    
                </div>
               
                <div class="row">

                    <div class="col-lg-6">
                        <dl class="dl-horizontal">
                            <dt>Ubicaci&oacute;n:</dt> 
                                <dd class="text-navy">
                                    <h3><%= rsAudU("Ubi_Nombre").Value %><h3>
                                </dd>

                            <dt>LPN</dt> 
                                <dd class="text-navy"><h3><%= rsAudU("PT_LPN").Value %><h3></dd>
                            <dt>SKU:</dt> 
                                <dd><%= rsAudU("Pro_SKU").Value %></dd>
                            <dt>Modelo:</dt> 
                                <dd><%= rsAudU("Pro_Nombre").Value %></dd>

                            <dt>Estatus:</dt> 
                                <dd><%= rsAudU("Est_Nombre").Value %></dd>
                            <dt>Resultados:</dt> 
                                <dd><%= rsAudU("Res_Nombre").Value %></dd>
                           
                        </dl>
                    </div>
                
                    <div class="col-lg-6">
                        <dl class="dl-horizontal">
                            <dt>Visita:</dt> 
                                <dd class="text-navy"><h3><%= rsAudU("AudU_Veces").Value %></h3></dd>
                            <dt>Tipo de Conteo:</dt> 
                                <dd class="text-navy"><h3><%= rsAudU("TIC_Nombre").Value %></h3></dd>
                            <dt>Hallazgo:</dt> 
                                <dd class="text-navy"><%= rsAudU("HLL_Nombre").Value %></dd>
                            <dt>Comentario:</dt> 
                                <dd><%= rsAudU("AudU_Comentario").Value %></dd>

                            <dt>Fecha Registro:</dt> 
                                <dd><%= rsAudU("AudU_FechaRegistro").Value %></dd>
                            <dt>Fecha Conteo:</dt> 
                                <dd><%= rsAudU("AudU_FechaConteo").Value %></dd>
                            <dt>Fecha Terminado:</dt> 
                                <dd><%= rsAudU("AudU_TerminadoFecha").Value %></dd>
                        </dl>
                    </div>

                </div>


                
<%
            Response.Flush()
            rsAudU.MoveNext();
        }
                
    } else {
%>
    No tiene ubicaciones en proceso
<%
    }

    rsAudU.Close();
%>
            </div>
        </div>
    </div>
</div>
 