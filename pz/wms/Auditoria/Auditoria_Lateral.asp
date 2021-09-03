<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%> 
<!--#include file="../../../Includes/iqon.asp" -->
<%
// HA ID: 2     2021-JUL-14 Ajustes: Se cambios de texto
// HA ID: 3     2021-AGO-05 Ajustes: Exportación con diferencias
 
	var Aud_ID = Parametro("Aud_ID", -1)
	var Conteo = Parametro("Aud_VisitaActual", -1)
	var Aud_EstatusCG141 = Parametro("Aud_EstatusCG141", -1)
   
    //validacion de visualizacion de Boton "Establecer Objetivo"
	Conteo = parseInt(Conteo)
	var bolInicia = false
	var bolActiva = true
	if(Aud_EstatusCG141 > 2 )
	{
		bolActiva = false
	}
	if(Aud_EstatusCG141 == 1){
		bolInicia = true
	}
	
%>
   
   <style>
       
       .list-group-item {
           line-height: 30px;
       }
    </style>
  
  
  
<div class="wrapper animated fadeInUp">
<%	
	if( !(bolInicia) ){ 
		// Conteo Posterior
%>        
    <div class="ibox float-e-margins">
        <div class="ibox-title">
        <%if(bolActiva){%>
            <span class="pull-right"><h4>conteo (<strong><%=Conteo%></strong>)</h4></span>
            <h4>&Uacute;ltimo conteo</h4>
        <%}else{%>
            <span class="pull-right"><h4>conteo (<strong><%=Conteo%></strong>)</h4></span>
            <h4>Conteo en curso</h4>
        <%}%>
        </div>
        <div class="ibox-content">
        <%if(bolActiva){%>
            <button type="button" class="btn btn-primary btn-sm btn-block" onclick="AuditoriaSeleccionLPN.CerrarVisitaVigente({Aud_ID: <%= Aud_ID %>, Visita: <%= Conteo + 1 %>});">
                <i class="fa fa-envelope"></i> Cerrar Conteo / Iniciar
            </button>
        <%}%>
            <button type="button" class="btn btn-primary btn-sm btn-block" onclick="AuditoriaLPNSeleccion.Abrir({Aud_ID: <%= Aud_ID %>, Visita: <%= Conteo %>});">
                <i class="fa fa-file-text-o"></i> Ver Objetivos
            </button>
        <%if(bolActiva){%>
            <button type="button" class="btn btn-danger btn-sm btn-block" onclick="Auditoria.Concluir(<%= Aud_ID %>);">
                <i class="fa fa-times-circle"></i> Concluir auditoria
            </button>
        <%}%>
        </div>
    </div>


<%
	} else {
		// Conteo Inicial

        // HA ID: 2 Se cambia "Generar Texto -> Establecer Obejtivo"
%>
    <div class="ibox float-e-margins">
        <div class="ibox-title">
            <h4>Objetivo de auditoria</h4>
        </div>
        <div class="ibox-content">
            <p>
                Acaba de crear un nuevo inventario, es necesario que establezca el objetivo a inventariar.
                <br>Tambi&eacute;n es necesario seleccionar a los auditores que participaran en este conteo
            </p>
            <button type="button" class="btn btn-primary btn-sm btn-block" onclick="AuditoriaSeleccionLPN.Abrir();">
                <i class="fa fa-files"></i>  Establecer Objetivo
            </button>
        </div>
    </div>

<%
	}
	
	if( !(bolInicia) ){
%>
    <div class="ibox">
        <div class="ibox-title">
            <h4>Reportes</h4>
        </div>
        <div class="ibox-content">
            <ul class="list-group clear-list">
                         <li class="list-group-item fist-item">
                            <span class="pull-right"> 
                                <button type="button" class="btn btn-primary btn-sm btn-block btnDescargaExcel" data-tipo="0">
                                <i class="fa fa-download"></i> Exportar </button></span>              
                                 Inventario congelado
                        </li>
                        <div class="text-center" id="loading1"></div>
                        <!--<li class="list-group-item">
                             <span class="pull-right"> 
                                <button type="button" class="btn btn-primary btn-sm btn-block btnDescargaExcel" data-tipo="1">
                                  <i class="fa fa-download"></i> Exportar </button></span>
                                 Existencias congeladas<br />
								 (Por SKU)
                        </li>
                        <div class="text-center" id="loading2"></div>-->
                        <li class="list-group-item">
                            <span class="pull-right"> 
                                <button type="button" class="btn btn-primary btn-sm btn-block btnDescargaExcel" data-tipo="2" >
                        <i class="fa fa-download"></i> Exportar </button></span>       
                            Conteo sin diferencias
                        </li>
                        <div class="text-center" id="loading3"></div>
                        <li class="list-group-item">
                            <span class="pull-right"> 
                                <button type="button" class="btn btn-primary btn-sm btn-block btnDescargaExcel"  data-tipo="4">                     
                        <i class="fa fa-download"></i> Exportar </button></span>       
                         Sobrantes
                        </li>
                        <div class="text-center" id="loading4"></div>
                        <li class="list-group-item">
                            <span class="pull-right"> 
                                <button type="button" class="btn btn-primary btn-sm btn-block btnDescargaExcel" data-tipo="3" >
                                <i class="fa fa-download"></i> Exportar </button></span>       
                               Faltantes
                        </li>
                        <div class="text-center" id="loading5"></div>

                <% /* HA ID: 3 INI Exportación con Diferencias */ %>

                        <li class="list-group-item">
                            <span class="pull-right"> 
                                <button type="button" class="btn btn-primary btn-sm btn-block btnDescargaExcel" data-tipo="5" >
                                <i class="fa fa-download"></i> Exportar </button></span>       
                               Conteo diferente <br />
                               (Entre auditores)
                        </li>
                        <div class="text-center" id="loading6"></div>

                <% /* HA ID: 3 FIN */ %>
                         <li class="list-group-item">
                            <span class="pull-right"> 
                                <button type="button" class="btn btn-primary btn-sm btn-block btnDescargaExcel" data-tipo="7" >
                                <i class="fa fa-download"></i> Exportar </button></span>       
                               Resultado general
                        </li>
                        <div class="text-center" id="loading7"></div>
                
            </ul>

        </div>
    </div>

<%
	}
%>          

</div>
<script type="text/javascript">


var loading = Global_loading
			
	$('.btnDescargaExcel').click(function(e) {
		$(this).prop('disabled',true);
        e.preventDefault();
		var tipo = $(this).data('tipo');
		$('#loading'+tipo).html(loading).show()
		ExportarExcel(tipo,$(this));
		$(this).prop('disabled',false);
    });			

</script>