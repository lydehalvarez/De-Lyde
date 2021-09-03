<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%> 
<!--#include file="../../../Includes/iqon.asp" -->
<!--#include file="./utils-js.asp" -->
<%
    var rqIntAud_ID = Parametro("aud_id", -1);
    var rqIntPT_ID = Parametro("pt_id", -1);
        
    var sqlAudU = "EXEC SPR_Auditorias_Ubicacion "
          + "@Opcion = 1010 "
        + ", @Aud_ID = " + rqIntAud_ID + " "
        + ", @Pt_ID = " + rqIntPT_ID + " "

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
                        <div class="m-b-md" class="border-bottom: solid #333 1px;">
<%          if( bolIni ) {
                bolIni = false
%>                                                        
                            <a class="btn btn-info btn-sm pull-right" title="NuevaVisita" 
                             onclick="AuditoriasUbicacion.Crear({Aud_ID: <%= rqIntAud_ID %>, PT_ID: <%= rqIntPT_ID %>});">
                                <i class="fa fa-plus"></i> Nueva Visita
                            </a>
<%          }

%>
                            <a class="btn btn-white btn-sm pull-right" style="margin-right: 5px;"
                             title="Imprimir Papeleta" onclick="AuditoriasUbicacion.ImprimirPapeleta({Aud_ID: <%= rqIntAud_ID %>, PT_ID: <%= rqIntPT_ID %>});">
                                <i class="fa fa-print"></i> Papeleta
                            </a>

                            <h2><%= rsAudU("Pt_LPN").Value %></h2>
                        </div>
                        
                    </div>
                </div>

                <div class="row">
                    <div class="col-lg-4">
                        <dl class="dl-horizontal">

                            <dt>Visita:</dt> 
                                <dd class="text-navy">
                                    <h1><%= rsAudU("AudU_Veces").Value %></h1>
                                </dd>
                        </dl>
                    </div>
                    <div class="col-lg-4">
                        <dl class="dl-horizontal">

                            <dt>Tipo de Conteo:</dt> 
                                <dd class="text-navy">
                                    <h1><%= rsAudU("TPC_Nombre").Value %></h1>
                                </dd>
                        </dl>
                    </div>
                    
                </div>
               
                <div class="row">

                    <div class="col-lg-6">
                        <dl class="dl-horizontal">
                            <dt>Auditor Interno:</dt> 
                                <dd>
                                    <img width="40" height="40" title="<%= rsAudU("IUsu_Nombre").Value %>" class="img-circle" src='<%= rsAudU("IUsu_Imagen").Value %>'>
                                    <%= rsAudU("IUsu_Nombre").Value %>
                                </dd>

                            <dt>Conteo:</dt> 
                                <dd class="text-navy"><h1><%= rsAudU("IAudU_ArticulosConteoTotal").Value %></h1></dd>
                            <dt>Hallazgo:</dt> 
                                <dd><%= rsAudU("ITPH_Nombre").Value %></dd>
                            <dt>Comentario:</dt> 
                                <dd><%= rsAudU("IAudU_Comentario").Value %></dd>

                            <dt>Fecha Registro:</dt> 
                                <dd><%= rsAudU("IAudU_FechaRegistro").Value %></dd>
                            <dt>Fecha Conteo:</dt> 
                                <dd><%= rsAudU("IAudU_FechaConteo").Value %></dd>
                            <dt>Fecha Terminado:</dt> 
                                <dd><%= rsAudU("IAudU_TerminadoFecha").Value %></dd>
                        </dl>
                    </div>
                
                    <div class="col-lg-6">
                        <dl class="dl-horizontal">
                            <dt>Auditor Externo:</dt> 
                                <dd>
                                    <img width="40" height="40" title="<%= rsAudU("EUsu_Nombre").Value %>" class="img-circle" src='<%= rsAudU("EUsu_Imagen").Value %>'>
                                    <%= rsAudU("EUsu_Nombre").Value %>
                                </dd>

                            <dt>Conteo:</dt> 
                                <dd class="text-navy"><h1><%= rsAudU("EAudU_ArticulosConteoTotal").Value %></h1></dd>
                            <dt>Hallazgo:</dt> 
                                <dd><%= rsAudU("ETPH_Nombre").Value %></dd>
                            <dt>Comentario:</dt> 
                                <dd><%= rsAudU("EAudU_Comentario").Value %></dd>

                            <dt>Fecha Registro:</dt> 
                                <dd><%= rsAudU("EAudU_FechaRegistro").Value %></dd>
                            <dt>Fecha Conteo:</dt> 
                                <dd><%= rsAudU("EAudU_FechaConteo").Value %></dd>
                            <dt>Fecha Terminado:</dt> 
                                <dd><%= rsAudU("EAudU_TerminadoFecha").Value %></dd>
                        </dl>
                    </div>

                </div>


                
<%
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
 