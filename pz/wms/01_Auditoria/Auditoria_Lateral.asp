<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%> 
<!--#include file="../../../Includes/iqon.asp" -->
<%
 
	var Aud_ID = Parametro("Aud_ID", -1)
	var Visita = 0
   
    //validacion de visualizacion de Boton "Establecer Objetivo"
   
	var sqlVec = "SELECT ISNULL(MAX(AudU_Veces), 0) AS AudU_Veces_Ultimo "
   		+ "FROM Auditorias_Ubicacion "
		+ "WHERE Aud_ID = " + Aud_ID
		
	var rsVec = AbreTabla(sqlVec, 1, 0)
	
	if( !(rsVec.EOF) ){
		Visita = rsVec("AudU_Veces_Ultimo").Value
	}
	
  	rsVec.Close()
	
	bolInicia = ( !(parseInt(Visita) > 0) )
%>
   
   <style>
       
       .list-group-item {
           line-height: 30px;
       }
    </style>
  
<div class="wrapper wrapper-content animated fadeInUp">
    <div class="ibox">
        <div class="ibox-content">
            <div class="row" style="margin-bottom: 30px;">
                <div class="col-lg-12">
                    <strong>
                        Nuevo inventario
                    </strong>
                    <p>
                        Acaba de crear un nuevo inventario, es necesario que establezca el objetivo a inventariar
                    </p>
<%	
	if( !(bolInicia) ){
		// Visita Posterior
%>
                    <button type="button" class="btn btn-primary btn-sm btn-block" onclick="AuditoriaSeleccionLPN.CerrarVisitaVigente({Aud_ID: <%= Aud_ID %>, Visita: <%= Visita + 1 %>,Conteo: <%= Visita %>});">
                        <i class="fa fa-thumbs-o-up"></i> Cerrar conteo <%=Visita%>
                    </button>
                    
                    <button type="button" class="btn btn-primary btn-sm btn-block" onclick="AuditoriaLPNSeleccion.Abrir({Aud_ID: <%= Aud_ID %>, Visita: <%= Visita %>});">
                        <i class="fa fa-file-text-o"></i> Objetivo auditoria

<%
	} else {
		// Visita Inicial
%>
					<button type="button" class="btn btn-primary btn-sm btn-block" onclick="AuditoriaSeleccionLPN.Abrir();">
                        <i class="fa fa-files"></i> Generar Visita
                    </button>
<%
	}
%>
                </div>
            </div>
<%
	if( !(bolInicia) ){
%>
            <div class="row">
                <div class="col-lg-12">
                    <strong>Res&uacute;men</strong>
                    <ul class="list-group clear-list">
                             <li class="list-group-item fist-item">
                                <span class="pull-right"> 
                                    <button type="button" class="btn btn-primary btn-sm btn-block btnDescargaExcel" data-tipo="1">
                                    <i class="fa fa-download"></i> Exportar </button></span>              
                                     Inventario congelado
                            </li>
                            <div class="text-center" id="loading1"></div>
                            <li class="list-group-item">
                                 <span class="pull-right"> 
                                    <button type="button" class="btn btn-primary btn-sm btn-block btnDescargaExcel" data-tipo="2">
                                      <i class="fa fa-download"></i> Exportar </button></span>
                             Existencias congeladas
                            </li>
                            <div class="text-center" id="loading2"></div>
                            <li class="list-group-item">
                                <span class="pull-right"> 
                                    <button type="button" class="btn btn-primary btn-sm btn-block btnDescargaExcel" data-tipo="3" >
                            <i class="fa fa-download"></i> Exportar </button></span>       
                                Sin diferencias
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
                                    <button type="button" class="btn btn-primary btn-sm btn-block btnDescargaExcel" data-tipo="5" >
                                    <i class="fa fa-download"></i> Exportar </button></span>       
                                   Faltantes
                            </li>
                            <div class="text-center" id="loading5"></div>
                    </ul>
                </div>

            </div>
<%
	}
%>          
        </div>
    </div>
</div>
<script type="text/javascript">


var loading = '<div class="spiner-example">'+
				'<div class="sk-spinner sk-spinner-three-bounce">'+
					'<div class="sk-bounce1"></div>'+
					'<div class="sk-bounce2"></div>'+
					'<div class="sk-bounce3"></div>'+
				'</div>'+
			'</div>'+
			'<div>Descargando informaci&oacute;n, espere un momento...</div>'
		
	$('#numConteo').html(<%= Visita %>)
	$('#AudC_ID').val(<%= Visita %>)	
	$('.btnDescargaExcel').click(function(e) {
		$(this).prop('disabled',true);
        e.preventDefault();
		var tipo = $(this).data('tipo');
		$('#loading'+tipo).html(loading)
		ExportarExcel(tipo,$(this));
		$(this).prop('disabled',false);
    });			

</script>