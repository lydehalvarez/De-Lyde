<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%> 
<!--#include file="../../../Includes/iqon.asp" -->
<%
	//HA ID: 2	2020-JUN-09 Agregado de impresion: Se agregan Botones para imprimir
    //HA ID: 3  2020-SEP-07 Agregado de Boton de Liberacion de Recepcion

   	var Cli_ID = Parametro("Cli_ID",-1)
	var TA_ID = Parametro("TA_ID",-1)
	var Usu_ID = Parametro("IDUsuario",0)
   
	var sSQLTr  = "SELECT TA_ID, TA_CodigoIdentificador, TA_End_Warehouse_ID, TA_FolioCliente, TA_Folio, Alm_Numero "
        sSQLTr += " , (SELECT Alm_Nombre FROM Almacen a1 WHERE a1.Alm_ID = t.TA_Start_Warehouse_ID ) as ALMACENORIGEN "
        sSQLTr += " , (SELECT Alm_Nombre FROM Almacen WHERE Alm_ID = t.TA_Start_Warehouse_ID) as Origen " 
        sSQLTr += " , (SELECT Alm_Nombre FROM Almacen WHERE Alm_ID = t.TA_End_Warehouse_ID) as Destino "
        sSQLTr += " , ISNULL((SELECT Alm_Numero FROM Almacen WHERE Alm_ID = t.TA_Start_Warehouse_ID),'Sin numero') as Num_Origen "
        sSQLTr += " , ISNULL((SELECT Alm_Numero FROM Almacen WHERE Alm_ID = t.TA_End_Warehouse_ID),'Sin numero') as Num_Destino "
        sSQLTr += " , (SELECT Cli_Nombre FROM Cliente c WHERE c.Cli_ID = t.Cli_ID) as Cliente "
        sSQLTr += " , dbo.fn_CatGral_DameDato(65,t.TA_TipoTransferenciaCG65) as Tipo, TA_TipoTransferenciaCG65 "
        sSQLTr += " , Alm_Nombre, Alm_Responsable, Alm_RespTelefono, Alm_Clave, Alm_Calle, Alm_Colonia "
        sSQLTr += " , Alm_Delegacion, Alm_Ciudad, Alm_CP, Lot_ID, TA_Transportista, TA_Guia "
        sSQLTr += " , Alm_RequierePermiso, Alm_HorarioIngreso, Alm_TipoAcceso, TA_Start_Warehouse_ID "
        sSQLTr += " , TA_EstatusCG51,dbo.fn_CatGral_DameDato(51,TA_EstatusCG51) as ESTATUS "
        sSQLTr += " , TA_UbicacionTienda, TA_HorarioAtencion, TA_ArchivoID, TA_RemisionRecibida "
        sSQLTr += " , Alm_CiudadC, Alm_HorarioLV, Alm_HorarioSabado, Alm_Domingo "
        sSQLTr += " , CONVERT(NVARCHAR(20),TA_FechaRegistro,103) as FECHAREGISTRO "
        sSQLTr += " , CONVERT(NVARCHAR(20),TA_FechaElaboracion,103) as FECHAELABRACION "
        sSQLTr += " , CONVERT(NVARCHAR(20),TA_FechaEntrega,103) as FECHAENTREGA "
        sSQLTr += " , ISNULL(TA_Recibido, 0 ) AS TA_EsRecibido "
        sSQLTr += " , t.Cli_ID as CLIID "
        sSQLTr += " FROM TransferenciaAlmacen t, Almacen a "
        sSQLTr += " WHERE t.TA_End_Warehouse_ID = a.Alm_ID "
        sSQLTr += " AND t.TA_ID = " + TA_ID

	    bHayParametros = false
	    ParametroCargaDeSQL(sSQLTr,0)  
   
       if(Cli_ID == -1){
           Cli_ID = Parametro("CLIID",-1)
       }
  

%>

<style type="text/css">
 
	.Caja-Flotando {
        position: fixed;
        right: 10px;
        top: 10px;
        width: auto;
	  }
 
</style>
    
<link href="/Template/Inspina/css/plugins/iCheck/custom.css" rel="stylesheet">
    <div id="wrapper">
        <div class="row">
            <div class="col-sm-8">
                <div class="ibox">    
                    <div class="ibox-content">
                        <div class="row">
                            <div class="col-lg-12">
                                <div class="m-b-md">
                                    <h2 class="pull-right"><%=Parametro("TA_Folio","")%><p><small><%=Parametro("TA_FolioCliente","")%></small></p></h2>
                                    <h2><%=Parametro("Alm_Numero","")%> - <%=Parametro("Alm_Nombre","")%></h2>
                                </div>
                            </div>
                        </div>
                        <hr>        
                        <div class="row">
                            <div class="col-lg-5">
                                <dl class="dl-horizontal">
                                    <dt>Estatus:</dt> <dd><span class="label label-primary"><%=Parametro("ESTATUS","")%></span></dd>
                                </dl>
                                <dl class="dl-horizontal">
                                    <dt>Origen:</dt> <dd><%=Parametro("Num_Origen","")%>&nbsp;-&nbsp;<%=Parametro("Origen","")%></dd>
                                </dl>
                            </div>
                            <div class="col-lg-7">
                                <dl class="dl-horizontal">
                                    <dt>Tipo:</dt> <dd><span class="label label-primary"><%=Parametro("Tipo","")%></span></dd>
                                </dl>
                                <dl class="dl-horizontal">
                                    <dt>Destino:</dt><dd><%=Parametro("Num_Destino","")%>&nbsp;-&nbsp;<%=Parametro("Destino","")%></dd>
                                </dl>
                            </div>
                        </div> 
                        <div class="row">
                            <div class="col-lg-5">
                                <!--Datos de la Orden de compra-->
                                <dl class="dl-horizontal">
                                    <dt>Fecha entrega:</dt>
                                    <dd><%=Parametro("FECHAENTREGA","")%></dd>
                                    <dt>Fecha de elaboraci&oacute;n:</dt>
                                    <dd><%=Parametro("FECHAELABRACION","")%></dd>
                                    <dt>Fecha de registro:</dt>
                                    <dd><%=Parametro("FECHAREGISTRO","")%></dd>
                                    <dt>Transportista:</dt>
                                    <dd><%=Parametro("TA_Transportista","")%></dd>
                                     <dt>Gu&iacute;a:</dt>
                                    <dd><%=Parametro("TA_Guia","")%></dd>                                        
                                </dl>
                            </div>
                            <!--Datos del Proveedor-->
                            <div class="col-lg-7" id="cluster_info">
                             <dl class="dl-horizontal">
                             <dt>Direcci&oacute;n de entrega</dt>
                             </dl>   
                             <dl class="dl-horizontal">
                                    <dt>Calle:</dt>
                                    <dd><%=Parametro("Alm_Calle","")%></dd>
                                    <dt>Colonia:</dt>
                                    <dd><%=Parametro("Alm_Colonia","")%></dd>
                                    <dt>Delegaci&oacute;n/Municipio:</dt>
                                    <dd><%=Parametro("Alm_Delegacion","")%></dd>
                                    <dt>Ciudad:</dt>
                                    <dd><%=Parametro("Alm_CiudadC","")%></dd>
                                    <dt>Estado:</dt>
                                    <dd></dd>
                                    <dt>C&oacute;digo postal:</dt>
                                    <dd><%=Parametro("Alm_CP","")%></dd>
									<dt>Responsable:</dt>
                                    <dd><%=Parametro("TA_Responsable","")%></dd>
									<dt>Tel&eacute;fono:</dt>
                                    <dd><%=Parametro("Alm_RespTelefono","")%></dd>
									<dt>Horario de atenci&oacute;n:</dt>
                                    <dd><%=Parametro("Alm_HorarioLV","")%></dd>
                                </dl>   
                            </div>
                        </div>
<%  
   if( Cli_ID == 6) { 
   if( Parametro("TA_EstatusCG51",0) > 5  && Parametro("TA_RemisionRecibida",0) == 0 ) {  
%>                                
                        <div class="row">
                            <div class="col-lg-12"> 
                                <div class="pull-right">
                                    <label> <input type="checkbox" class="i-checks" id="TA_RemisionRecibida"> 
                                        La nota de remisi&oacute;n firmada ya se carg&oacute; al sistema&nbsp;&nbsp;&nbsp;
                                    </label>
                                </div>
                            </div>       
                        </div> 
<%	}}
%>
                        <hr>                             
<%	//HA ID: 2 INI Se agregan botones de Impresión de Documentos
    //HA ID: 3 INI Se agregan botones de Liberacion de articulos de recepcion
%>
						
                        <div class="form-group ">
                            <input type="button" value="Intentar hoja de ruta" data-taid="<%=TA_ID%>"  class="btn btn-success btnSendHoja"/>

                          
                            <div class="tooltip-demo pull-right">
                                <button type="button" class="btn btn-danger" onclick="TA.Imprimir.Orden();">
                                    <i class="fa fa-print"></i> Orden
                                </button>
							
                                <button type="button" class="btn btn-danger" onclick="TA.Imprimir.Albaran();">
                                    <i class="fa fa-print"></i> Albaran
                                </button>
                            </div>
<%  
   //DT: ROG 13/10/2020 - cuando vienen de tienda a CEDI no se cambian a estatus de transferencia
   //                     estan llegando con estatus de pickeo o de empaque (izzi)
   var bPasa = Parametro("TA_EsRecibido",0) == 0 && Parametro("TA_EstatusCG51",0) >= 5 
   if(Parametro("TA_TipoTransferenciaCG65",0) == 1 && Parametro("TA_End_Warehouse_ID",0) == 3){
        bPasa = true
   }
   if( bPasa ) {  
%>
                            <div class="tooltip-demo">
                                <button type="button" id="btnRecibido" class="btn btn-success" onclick="TA.Recibir();">
                                    <i class="fa fa-download"></i> Recibido
                                </button>                               
                            </div>
<% }
%>
                        </div>

						<br />
                    
<%	//HA ID: 2 FIN
%>
                        <div class="row">
                               
							<div class="row m-t-sm">
                                <div class="col-lg-12">
									<div class="panel blank-panel">
										<div class="panel-heading">
											<div class="panel-options">
												<ul class="nav nav-tabs">
													<li class="active"><a href="#tab-1" data-toggle="tab">Art&iacute;culos</a></li>
													<li class=""><a href="#tab-2" data-toggle="tab">Bit&aacute;cora</a></li>
													<li class=""><a href="#tab-3" data-toggle="tab">Hist&oacute;rico</a></li>
													<li class=""><a href="#tab-4" data-toggle="tab">Rastreo</a></li>
												</ul>
											</div>
										</div>

										<div class="panel-body">
											<div class="tab-content">
												
												<div class="tab-pane active" id="tab-1">
													<div id="divArticulos"></div>
												</div>
												
												<div class="tab-pane" id="tab-2">
													
													<div id="divComentarios"></div> 
													
												</div>
												
												<div class="tab-pane" id="tab-3">
													
													<div id="divBitacora"></div>

												</div>
												
												<div class="tab-pane" id="tab-4">
													
													<div id="divRastreo"></div>
													
												</div>
												
											</div>
										</div>

									</div>
                                </div>
                            </div>
                        </div>        
                    </div>
                </div>
            </div>
            <div class="col-sm-4" id="dvHistoria">
                <div id="divHistLineTimeGrid"></div>
                <div id="divSeries"></div>
            </div>
        </div>
    </div>
 
                                    
<div class="modal fade" id="modalComentario" tabindex="-1" role="dialog" aria-labelledby="divModalComentario" aria-hidden="true">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <h4 class="modal-title" id="divModalComentario"><%= "Comentarios" %></h4>
                <button type="button" class="close"  data-toggle="modal" data-target="#modalComentario" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <input type="hidden" id="comNodo" value="" />
            <div class="modal-body">
                <div class="form-group row">
                    <label for="comTitulo" class="col-sm-2 col-form-label">Titulo</label>
                    <div class="col-sm-10">
                        <input type="text" autocomplete="off" class="form-control" id="comTitulo" placeholder="Titulo" maxlength="50">
                    </div>
                </div>
                <div class="form-group row">
					<label for="comComentario" class="col-sm-2 col-form-label">Comentarios</label>
                    <div class="col-sm-10">
                        <textarea id="comComentario" class="form-control" placeholder="Comentario" maxlength="150"></textarea>
                    </div>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-toggle="modal" data-target="#modalComentario">
					<i class="fa fa-times"></i> Cerrar
				</button>
                <button type="button" class="btn btn-danger" onclick="Comentarios.Agregar();">
					<i class="fa fa-plus"></i> Agregar
				</button>
            </div>
		</div>
	</div>
</div>                                 
                                    
<!-- iCheck -->
<script src="/Template/Inspina/js/plugins/iCheck/icheck.min.js"></script>                                
<script type="text/javascript">

    var VerSeries = 0
    $(document).ready(function() { 
        
         $('.i-checks').iCheck({
            checkboxClass: 'icheckbox_square-green',
            radioClass: 'iradio_square-green',
        });
        
        $('#TA_RemisionRecibida').on('ifChanged', function(event) {
            //alert('checked = ' + event.target.checked);
            //alert('value = ' + event.target.value);
            TA.ActualizaRemision();
//            $('input').iCheck('check'); — change input's state to checked
//            $('input').iCheck('uncheck'); — remove checked state
//            $('input').iCheck('toggle'); — toggle checked state
//            $('input').iCheck('disable'); — change input's state to disabled
//            $('input').iCheck('enable'); — remove disabled state
//            $('input').iCheck('indeterminate'); — change input's state to indeterminate
//            $('input').iCheck('determinate'); — remove indeterminate state
//            $('input').iCheck('update'); — apply input changes, which were done outside the plugin
//            $('input').iCheck('destroy'); — remove all traces of iCheck
        });

        if($("#Cli_ID").val() != <%=Cli_ID%>){
            $("#Cli_ID").val(<%=Cli_ID%>)
        }
        
        CargaProductos();
        CargaHistoricoLineTime();
        OrdenCompraRastreo();
        Comentarios.Cargar();
    });
	
    $(document).scroll(function(e) {

      if(VerSeries == 0) {    
          if ($(document).scrollTop() > 200) {
            $("#dvHistoria").addClass("Caja-Flotando");
          } else {
            $("#dvHistoria").removeClass("Caja-Flotando");
          }
      }
	  
	}); 
    
    
    
	var urlBase="/pz/wms/Transferencia/";
	
	var TA = {
		Imprimir: {
			  Orden: function(){
				var TA_ID = $("#TA_ID").val();
				window.open(urlBase+"SalidaAlmacenDoc.asp?TA_ID="+TA_ID,"Albaran","toolbar=no,menubar=no,location=no,resizable=yes,scrollbars=yes,status=no");
			}
			, Albaran: function(){
				var TA_ID = $("#TA_ID").val();
				window.open(urlBase+"AlbaranDoc.asp?TA_ID="+TA_ID,"Albaran","toolbar=no,menubar=no,location=no,resizable=yes,scrollbars=yes,status=no");
			}
        }
        , Recibir: function(){

            $.ajax({
                url: "/pz/wms/TA/TA_Ajax.asp"
                , method: "post"
                , async: false
                , dataType: "json"
                , data: {
                    Tarea: 13
                    , TA_ID: $("#TA_ID").val()
                    , IDUsuario: $("#IDUsuario").val()
                }
                , success: function(res){
                    if( parseInt(res.Error) == 0 ){
                        Avisa("success", "Transferencia", res.Mensaje);
                        $("#btnRecibido").remove();
                    } else {
                        Avisa("warning", "Transferencia", res.Mensaje);
                    }
                }
            })
        }
        , ActualizaRemision: function(){
            
            $.ajax({
                url: "/pz/wms/TA/TA_Ajax.asp"
                , method: "post"
                , async: false
                , dataType: "json"
                , data: {
                    Tarea: 14
                    , TA_ID: $("#TA_ID").val()
                    , IDUsuario: $("#IDUsuario").val()
                }
                , success: function(res){
                    if( parseInt(res.Error) == 0 ){
                        Avisa("success", "Transferencia", res.Mensaje);
                    } else {
                        // $("#TA_RemisionRecibida").iCheck('toggle');
                        //$("#TA_RemisionRecibida").parent().get( 0 ).removeClass("checked")
                        Avisa("warning", "Transferencia", res.Mensaje);
                    }
                }
            })
        }
         
        
	}
	
	function CargaProductos(){
		var sDatos  = "?TA_ID="+$("#TA_ID").val(); 
		$("#divArticulos").load("/pz/wms/TA/TA_FichaPicked.asp" + sDatos);
	}    
    
    function CargaHistoricoLineTime(){
		var sDatos  = "?TA_ID="+$("#TA_ID").val(); 	
		$("#divHistLineTimeGrid").load("/pz/wms/TA/TA_Historico.asp" + sDatos);        
    }
    
    function OrdenCompraRastreo(){
        var sDatos  = "?TA_ID="+$("#TA_ID").val(); 	
		$("#divRastreo").load("/pz/wms/TA/TA_Rastreo.asp" + sDatos);     
    }
 

var Comentarios = {
	Cargar: function(){
        var sDatos  = "?TA_ID="+$("#TA_ID").val(); 	
		$("#divComentarios").load("/pz/wms/TA/TA_Comentario.asp" + sDatos); 
	}
	, VisualizarModal: function( prmIntComnId ){
		Comentarios.LimpiarModal();
		
		$("#comNodo").val(prmIntComnId);
	}
	, Agregar: function(){
		
		var intIdUsuario = $("#IDUsuario").val();
		var TA_ID = $("#TA_ID").val();
		var intComn_ID = $("#comNodo").val();
		var strTitulo = $("#comTitulo").val();
		var strComentario = $("#comComentario").val();
		
		var arrRes = [];
		var bolError = false;
		
		if( strTitulo == '' ){
			arrRes.push("Agregar el Titulo");
			bolError = true;
		}

		if( strComentario == '' ){
			arrRes.push("Agregar el Comentario");
			bolError = true;
		}
		
		if( bolError ){
			
			Avisa("warning", "Comentario", "Validar Formulario: <br>" + arrRes.join("<br>") );
			
		} else {
		
			$.ajax({
				  url: "/pz/wms/TA/TA_Ajax.asp"
				, method: "post"
				, async: false
				, dataType: "json"
				, data: {
					  Tarea: 15
					, IdUsuario: intIdUsuario
					, TA_ID: $("#TA_ID").val()
					, Comn_ID: intComn_ID
					, Titulo: strTitulo
					, Comentario: strComentario
				}
				, success: function(res){
					if( parseInt(res.Error) == 0 ){
						
						Avisa("success", "Comentario", "Se agreg&oacute; el comentario a la Transferencia");
						Comentarios.Cargar();
					} else {
						Avisa("warning", "Comentario", "NO se agreg&oacute; el comentario a la transferencia");
					}
                    Comentarios.CerrarModal();
				}
			})
		}
	}
	, LimpiarModal: function(){
		$("#comNodo").val("");
		$("#comTitulo").val("");
		$("#comComentario").val("");
	}
	, CerrarModal: function(){
		Comentarios.LimpiarModal();
		
		var bolSeAbrePorModal = parseInt($("#SeAbrePorModal").val());
 
		//if( bolSeAbrePorModal == 0 ){
			$("#modalComentario").modal("hide");
		//} else {
//			
//			$.post("/pz/wms/OV/OV_Ficha.asp"
//				, {TA_ID:$("#TA_ID").val()}
//				, function(data){
//					$("#modalBodySO").html(data);
//					$("#SeAbrePorModal").val(1);
//				}
//			);
//			
//		}
	}
}

$('.btnSendHoja').click(function(e) {
    e.preventDefault();
	var TA_ID = $(this).data('taid')
		$.ajax({
			type: 'GET',
			contentType:'application/json',
			url: "https://elektra.lydeapi.com/api/recupera/hoja/ruta?TA_ID="+TA_ID,
			success: function(data){
				console.log(data) 
				if(data.data.result != -1){
					Avisa("success","Aviso","Hoja de ruta recibida");
					if(data.data.data.folios != null){
						TransferenciasFunciones.ImprimeGuia(data.data.data.documento,"Hoja de ruta "+data.data.data.folios[0])
					}
				}else{
					swal({
					  title: data.data.message,
					  text: "Elektra no gener&oacute; correctamente el documento",
					  type: "warning",
					  confirmButtonClass: "btn-success",
					  confirmButtonText: "Ok" ,
					  closeOnConfirm: true,
					  html: true
					},
					function(data){
					});		
				}
			}
		});

	
	
});

var TransferenciasFunciones = {
	ImprimeGuia:function(guia,name) {
			
		var winparams = 'dependent=yes,locationbar=no,scrollbars=yes,menubar=yes,'+
		'resizable,screenX=50,screenY=50,width=850,height=1050';

		var htmlPop = '<title>'+name+'</title> '
						+'<embed width=100% height=100%'
						 + ' type="application/pdf"'
						 + ' src="data:application/pdf;base64,'
						 + guia
						 + '"></embed>'; 

		var printWindow = window.open ("", "_blank", winparams);
		printWindow.document.write (htmlPop);
	},
}


    
</script>    
