<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252" %>
<!--#include file="../../../Includes/iqon.asp" -->
<%
// HA ID: 3 2021-Jul-09 Se cambia pantalla de ubicaciones en proceso
// HA ID: 4 2021-Ago-05 Ajustes: Exportación condiferencias, visualización de pestaña en proceso modo de selección de objetivos.

var urlBase = "/pz/wms/"
var urlBaseTemplate = "/Template/inspina/";

var Aud_ID = Parametro("Aud_ID",-1);

%>
<!--#include file="./Auditoria-js.asp" -->
<!--#include file="./EditarAuditoria_Modal.asp" -->
<!--#include file="./utils-js.asp" -->
<%

    var model=getAuditInformation();
   
%>

<style>

	.profileImage {
	  padding: 6px 10px 4px 10px;
	  background: #1bb394;
	  color: #fff;
	  text-align: center;
	}

</style>

 <!-- c3 Charts -->
<link href="<%= urlBaseTemplate %>css/plugins/c3/c3.min.css" rel="stylesheet">
<link href="<%= urlBaseTemplate %>css/animate.css" rel="stylesheet">
<link href="<%= urlBaseTemplate %>css/style.css" rel="stylesheet">

<div class="wrapper wrapper-content animated fadeInUp">
    <div class="row">
        <div class="col-lg-9">
            <div class="ibox float-e-margins">
                <div class="ibox-title">
                    <!--<a href="#" class="btn btn-white btn-xs pull-right" data-toggle="modal" data-target="#editModal">Editar</a>-->
                    <h2>Auditoria de: <%=model.Client%></h2>
                </div>
                <div class="ibox-content">
                    <div class="row">
                        <div class="col-lg-12">
                            <div class="row">
                                <div class="col-lg-5">
                                    <dl class="dl-horizontal">
                                        <dt>Estatus:</dt>
                                        <dd><span class="label label-primary">
                                                <%=model.Status%>
                                            </span></dd>
                                    </dl>
                                </div>
                                <div class="col-lg-7">
                                    <dl class="dl-horizontal">
                                        <dt>N&uacute;mero de auditoria:</dt>
                                        <dd><span class="label label-primary">
                                                <%=model.Aud_ID%>
                                            </span></dd>
                                        <dt>&nbsp;</dt>
                                        <dd>&nbsp;</dd>
                                        <dt>Conteo:</dt>
                                        <dd><span class="label label-success">
                                                <%=model.Aud_VisitaActual%>
                                            </span></dd>
                                    </dl>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-lg-5">
                            <dl class="dl-horizontal">
                                <dt>Titulo:</dt>
                                <dd>
                                    <%=model.Aud_Nombre%>
                                </dd>
                                <dt>Descripci&oacute;n:</dt>
                                <dd>
                                    <%=model.Aud_Descripcion%>
                                </dd>
                                <dt>&nbsp;</dt>
                                <dd>&nbsp;</dd>
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
                                <dt>Conteo ciego:</dt>
                                <dd><%=model.ConteoCiego%></dd>
                                <dt>Tipo de auditoria:</dt>
                                <dd><%=model.AudHayConteoExterno%></dd>
                                <dt>&nbsp;</dt>
                                <dd>&nbsp;</dd>
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
                    <div class="text-center" id="loading">
                        <div class="spiner-example">
                            <div class="sk-spinner sk-spinner-three-bounce">
                                <div class="sk-bounce1"></div>
                                <div class="sk-bounce2"></div>
                                <div class="sk-bounce3"></div>
                            </div>
                        </div>
                        <div>Cargando informaci&oacute;n, espere un momento...</div>
                    </div>
                    <div class="text-center"  id="dvDashboard" style="min-height: 100px "></div> 
                    

                    <div class="row m-t-sm">
                        <div class="col-lg-12">
                            <div class="panel blank-panel">
                                <div class="panel-heading">
                                    <div class="panel-options">
                                        <ul class="nav nav-tabs">
                                            <li class="active"><a href="#tab-3" data-tabnm="3"
                                                    data-toggle="tab">Recepci&oacute;n</a></li>
                                            <li class=""><a href="#tab-2" data-tabnm="2"
                                                    data-toggle="tab">Ubicaciones en proceso</a></li>
                                            <li class=""><a href="#tab-4" data-tabnm="4"
                                                    data-toggle="tab">Existencias</a></li>
                                            <li class=""><a href="#tab-5" data-tabnm="5"
                                                    data-toggle="tab">Seguimiento</a></li>
                                            <li class=""><a href="#tab-1" data-tabnm="1"
                                                    data-toggle="tab">Mensajes</a></li>                                    
                                        </ul>
                                    </div>
                                </div>
                                <div class="panel-body">
                                    <div class="tab-content">
                                        <div class="tab-pane active" id="tab-3"></div>
                                        <div class="tab-pane" id="tab-2"></div>
                                        <div class="tab-pane" id="tab-4"></div>
                                        <div class="tab-pane" id="tab-5"></div>                                        
                                        <div class="tab-pane" id="tab-1"></div>
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
</div>

<script src="/Template/inspina/js/plugins/sheetJs/xlsx.full.min.js"></script>
<script src="/pz/wms/Auditoria/js/Auditoria_Seleccion_LPN.js"></script>
<script src="/pz/wms/Auditoria/js/Auditoria_LPN_Seleccion.js"></script>
<script src="/Template/inspina/js/loading.js"></script>

<script type="text/javascript">


    $(document).ready(function () {
        
        //para las descargas de datos
        //$("#loading1").hide();
//        $("#loading2").hide();
//        $("#loading3").hide();
//        $("#loading4").hide();
//        $("#loading5").hide();

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
<% /* HA ID: 3 Se cambia archivo "Ubicacion_EnProceso.asp" por "Ubicaciones2.asp" */ %>
                    Archivo = "Ubicaciones2.asp"
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
                case "#tab-5":
                    Archivo = "Ubicacion_EnProceso.asp"
                    Numtab = 5
                    dato.Aud_ID =<%=Aud_ID %>;
                    break;
            }
            $("#tab-" + Numtab).load("/pz/wms/Auditoria/" + Archivo, dato);
            CargaGraficos();
        });

    });

        function ExportarExcel(t,input) {
			
			var Ruta = "";
			var ip = "";
			
			switch(t){
				case 0:
					Ruta ="Excel_InvCongelado.asp"
					ip = "Congelados_"
				break;	 
				case 1:
					Ruta ="Excel_ExistCongeladas.asp"
					ip = "Existencias_Congeladas_"
				break;	
				case 2:
					Ruta = "AuditoriaExcel.asp";
//					Ruta ="ExcelSinDiferencias.asp"
					ip = "SinDiferencias_"
				break;	
				case 3:
					Ruta = "AuditoriaExcel.asp";
//					Ruta ="ExcelFaltantes.asp"
					ip = "Faltantes_"
				break;	
				case 4:
					Ruta = "AuditoriaExcel.asp";
//					Ruta ="ExcelSobrantes.asp"
					ip = "Sobrantes_"
				break;	
        <% /* HA ID: 4 Se agrega opcion de Excel con diferencias */ %>
                case 5:
					Ruta = "AuditoriaExcel.asp";
                    //Ruta = "ExcelConDiferencias.asp";
                    ip = "ConDiferencias_";
                break;
				case 7:
                    Ruta = "ExcelResultado.asp";
                    ip = "Resultado_General_";
                break;
			}

			$.post("/pz/wms/Auditoria/"+Ruta

			, { 
				Aud_ID: <%=Aud_ID%>
				,Aud_HayConteoExterno : <%= model.Aud_HayConteoExterno %>
				,Pt_ResultadoCG147: t 
			}, function(data){
					$("#loading"+t).hide('slow');
					input.prop('disabled',false);
                    var response = JSON.parse(data)
					var len = response.length
					if(len > 0){
						var ws = XLSX.utils.json_to_sheet(response);
						var wb = XLSX.utils.book_new(); 
						XLSX.utils.book_append_sheet(wb, ws, ip);
						XLSX.writeFile(wb, ip +"Inventario.xlsx");
					} else {
						Avisa("error","No hay datos para descargar","No hay informaci&oacute;n para exportar")
					}
				});
		
		}
    
    function CargaInicial() {
        var dato = {
			Aud_ID:<%=Aud_ID %>,
			Aud_VisitaActual:<%=model.Aud_VisitaActual%>,
			Aud_EstatusCG141:<%=model.Aud_EstatusCG141%>
		};

        $("#tab-3").load("/pz/wms/Auditoria/Auditoria_Recepcion.asp", dato);
        CargaGraficosInicial()
        $("#dvAudLateral").load("/pz/wms/Auditoria/Auditoria_Lateral.asp", dato);
                
    }
    

    function CargaGraficosInicial(){
        
        var dato = {
		   Aud_ID:<%=Aud_ID %>
		}
        
        $("#loading").show('slow');
	    $("#dvDashboard").hide('slow'); 
		$("#dvDashboard").load("/pz/wms/Auditoria/AuditoriasCiclicas_Dashboard.asp", dato, function() {
			$("#loading").hide('slow');
			$("#dvDashboard").show('slow');
		});
    }
            
    function CargaGraficos(){

        var dato = {
		   Aud_ID:<%=Aud_ID %>
		}
		$("#dvDashboard").load("/pz/wms/Auditoria/AuditoriasCiclicas_Dashboard.asp", dato);
    }
	
	var Auditoria = {
		Concluir:function(Aud_ID){
			swal({
				title: "Concluir auditoria "+Aud_ID,
				text: "Una vez concluida la auditoria, ya no se podr&aacute;n hacer m&aacute;s conteos",
				type: "warning",
				showCancelButton: true,
				confirmButtonText: "Ok, finalizar",
				closeOnConfirm: false,
				html:true
			}, function (data) {
				if(data){
					swal("Espere un momento, por favor!", "Analizando cierre de auditoria", "warning");
					
                    $.ajax({
						url: "/pz/wms/Auditoria/Auditoria_Ajax.asp"
						, method: "post"
						, cache: false
						, data: {  Tarea: 6
								 , Aud_ID: Aud_ID
						}
						, success: function(data){
							var response = JSON.parse(data)
							console.log(response)
							
							if(response.result == 0){
								swal({
									title: "No se puede concluir",
									<%if(model.Aud_HayConteoExterno == 0){%>
									text: "Faltan "+response.data.Total+" papeletas, "+response.data.AuditorInterno+" del auditor interno",
									<%}else{%>
									text: "Faltan "+response.data.Total+" papeletas, "+response.data.AuditorInterno+" del auditor interno y "+response.data.AuditorExterno+" del auditor externo",
									<%}%>
									type: "error",
									confirmButtonText: "Ok!",
									closeOnConfirm: true
								});								
							}else if(response.result == 1){
								swal({
									title: "Auditoria concluida",
									text: response.message,
									type: "success",
									confirmButtonText: "Ok!",
									closeOnConfirm: true
								}, function () {
									$("#Contenido").load("/pz/wms/Auditoria/Auditoria.asp", {Aud_ID: Aud_ID});
								});								
							}else{
								swal("Ups!",response.message , "error");
							}
						 }
					}); 
				}
			});
		}
		
	}


</script>
<script src="<%= urlBaseTemplate %>js/inspinia.js"></script>
<script src="<%= urlBaseTemplate %>js/plugins/pace/pace.min.js"></script>

<script src="<%= urlBaseTemplate %>js/plugins/d3/d3.min.js"></script>
<script src="<%= urlBaseTemplate %>js/plugins/c3/c3.min.js"></script>
