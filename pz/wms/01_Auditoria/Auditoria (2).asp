<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252" %>
<!--#include file="../../../Includes/iqon.asp" -->
<%
   
   var Aud_ID = Parametro("Aud_ID",-1)
   
%>
<!--#include file="./Auditoria-js.asp" -->
<!--#include file="./EditarAuditoria_Modal.asp" -->
<!--#include file="./utils-js.asp" -->
<% var model=getAuditInformation(); %>

<style>

	.profileImage {
	  padding: 6px 10px 4px 10px;
	  background: #1bb394;
	  color: #fff;
	  text-align: center;
	}

</style>


<div class="row">
    <div class="col-lg-9">
        <div class="wrapper wrapper-content animated fadeInUp">
            <div class="ibox">
                <div class="ibox-content">
                    <div class="row">
                        <div class="col-lg-12">
                            <div class="m-b-md">
                                <a href="#" class="btn btn-white btn-xs pull-right" data-toggle="modal" data-target="#editModal">Editar</a>
                                <h2>
                                    <%=model.Client%>
                                </h2>
                            </div>
                            <dl class="dl-horizontal">
                                <dt>Status:</dt>
                                <dd><span class="label label-primary">
                                        <%=model.Status%>
                                    </span></dd>
                            </dl>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-lg-5">
                            <dl class="dl-horizontal">
                                <dt>Creada por:</dt>
                                <dd>
                                    <%=model.Creator%>
                                </dd>
                                <dt>Auditor Responsable:</dt>
                                <dd>
                                    <%=model.Responsable%>
                                </dd>
                                <dt>Messages:</dt>
                                <dd>
                                    <%=model.Messages%>
                                </dd>
                                <dt>Cliente:</dt>
                                <dd><a href="#" class="text-navy">
                                        <%=model.Client%>
                                    </a> </dd>
                                <dt>Tipo:</dt>
                                <dd>
                                    <%=model.Type%>
                                </dd>
                                <dt>Forma de trabajarse:</dt>
                                <dd>
                                    <%=model.WorkType%>
                                </dd>
                            </dl>
                        </div>
                        <div class="col-lg-7" id="cluster_info">
                            <dl class="dl-horizontal">

                                <dt>Ultima actualizaci&oacute;n:</dt>
                                <dd>
                                    <%
									var Dat = model.RegisterLastUpdateDate
									
									if(Dat > -1){Dat}else{Response.Write(1)}%>
                                </dd>
                                <dt>Creada:</dt>
                                <dd>
                                    <%=model.RegisterDate%> hrs
                                </dd>
                                <dt>Fecha inicio:</dt>
                                <dd>
                                    <%=model.RegisterStartDate%>
                                </dd>
                                <dt>Fecha terminaci&oacute;n:</dt>
                                <dd>
                                    <%var Termina = model.RegisterLastUpdateDate
									
									if(Termina > -1){Termina}else{Response.Write("Sin datos")}
									%>
                                </dd>
                                <dt>Participantes:</dt>
                                <dd class="project-people">
                                    <% var auditors=model.Auditors; for(var count=0; count < auditors.length;
                                        count++){ var auditor=auditors[count]; if(auditor.url !=undefined) { %>
                                        <span><img title="<%=auditor.name%>" class="img-circle"
                                                src="<%=auditor.url%>"/></span>
                                        <% } else { %>
                                        <span class="img-circle profileImage"><%=auditor.name.substring(0,1)%></span>
                                        
<%/*%>                                            <span title="<%=auditor.name%>"><span
                                                    class="fa fa-user-circle"></span>
                                                <%=auditor.name.substring(0,1)%>
                                            </span>
<%*/%>                                            <% } } %>
                                </dd>
                            </dl>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-lg-12">
                            <dl class="dl-horizontal">
                                <dt>Completed:</dt>
                                <dd>
                                    <div class="progress progress-striped active m-b-sm">
                                        <div style="width: <%=model.CompletedUbicationsInfo.PorcentComplete%>%;"
                                            class="progress-bar"></div>
                                    </div>
                                    <small>
                                        <strong>
                                            <%=model.CompletedUbicationsInfo.Visited%>
                                        </strong> ubicaciones visitadas de <strong>
                                            <%=model.CompletedUbicationsInfo.Totals%>
                                        </strong>
                                    </small>
                                </dd>
                            </dl>
                        </div>
                    </div>
                    <div class="row m-t-sm">
                        <div class="col-lg-12">
                            <div class="panel blank-panel">
                                <div class="panel-heading">
                                    <div class="panel-options">
                                        <ul class="nav nav-tabs">
                                            <li class="active"><a href="#tab-1" data-tabnm="1"
                                                    data-toggle="tab">Mensajes</a></li>
                                            <li class=""><a href="#tab-2" data-tabnm="2"
                                                    data-toggle="tab">Ubicaciones en proceso</a></li>
                                            <li class=""><a href="#tab-3" data-tabnm="3"
                                                    data-toggle="tab">Recepci&oacute;n</a></li>
                                            <li class=""><a href="#tab-4" data-tabnm="4"
                                                    data-toggle="tab">Existencias</a></li>
                                        </ul>
                                    </div>
                                </div>
                                <div class="panel-body">
                                    <div class="tab-content">
                                        <div class="tab-pane active" id="tab-1"></div>
                                        <div class="tab-pane" id="tab-2"></div>
                                        <div class="tab-pane" id="tab-3"></div>
                                        <div class="tab-pane" id="tab-4"></div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
                            

    <div class="col-lg-3" id="dvAudLateral">
    </div>
                            
</div>

<script src="/Template/inspina/js/plugins/sheetJs/xlsx.full.min.js"></script>
<script src="/pz/wms/Auditoria/js/Auditoria_Seleccion_LPN.js"></script>
<script src="/pz/wms/Auditoria/js/Auditoria_LPN_Seleccion.js"></script>
<script src="/Template/inspina/js/loading.js"></script>

<script type="text/javascript">


    $(document).ready(function () {
$("#loading1").hide();
$("#loading2").hide();
$("#loading3").hide();
$("#loading4").hide();
$("#loading5").hide();

        $("#Aud_ID").val(<%=Aud_ID %>)
        
        CargaInicial()

        $('a[data-toggle="tab"]').on('shown.bs.tab', function (e) {
            var dato = {};
            var Archivo = "";

            var target = $(e.target).attr("href") // activated tab
            var Numtab = 0
            $(".tab-pane").empty();

            dato['Aud_ID'] = $("#Aud_ID").val();

            switch (target) {
                case "#tab-1":
                    Archivo = "Auditoria_Mensajes.asp";
                    Numtab = 1;
                    dato.Aud_ID =<%=Aud_ID %>;
                    break;
                case "#tab-2":
                    Archivo = "Ubicacion_EnProceso.asp"
                    Numtab = 2
                    dato.Aud_ID =<%=Aud_ID %>;
                    break;
                case "#tab-3":
                    Archivo = "Auditoria_Recepcion.asp"
                    Numtab = 3
                    break;
                case "#tab-4":
                    Archivo = "Auditoria_Existencias.asp"
                    Numtab = 4
                    break;
            }
            $("#tab-" + Numtab).load("/pz/wms/Auditoria/" + Archivo, dato);
        });

    });

        function ExportarExcel(t,input) {
			
			var Ruta = "";
			var ip = "";
			
			switch(t){
				case 1:
					Ruta ="Excel_InvCongelado.asp"
					ip = "Congelados_"
				break;	
				case 2:
					Ruta ="Excel_ExistCongeladas.asp"
					ip = "Existencias_Congeladas_"
				break;	
				case 3:
					Ruta ="ExcelSinDiferencias.asp"
					ip = "SinDiferencias_"
				break;	
				case 4:
					Ruta ="ExcelSobrantes.asp"
					ip = "Sobrantes_"
				break;	
				case 5:
					Ruta ="ExcelFaltantes.asp"
					ip = "Faltantes_"
				break;		
				
			}

			$.post("/pz/wms/Auditoria/"+Ruta

			, { Aud_ID: <%=Aud_ID%> }
               , function(data){
					$("#loading"+t).hide('slow');
					input.prop('disabled',false);
                    var response = JSON.parse(data)
					var len = response.length
					if(len > 0){
                    var ws = XLSX.utils.json_to_sheet(response);
					var wb = XLSX.utils.book_new(); 
                    XLSX.utils.book_append_sheet(wb, ws, "Sheet1");
                    XLSX.writeFile(wb, ip +"Inventario.xlsx");
					}else{
						Avisa("error","No hay datos para descargar","Error")
					}
				});
		
		}
    
    function CargaInicial() {
        var dato = {};
        dato.Aud_ID = <%=Aud_ID %>;
        $("#tab-1").load("/pz/wms/Auditoria/Auditoria_Mensajes.asp", dato);
        $("#dvAudLateral").load("/pz/wms/Auditoria/Auditoria_Lateral.asp", dato);
    }
    
    


</script>