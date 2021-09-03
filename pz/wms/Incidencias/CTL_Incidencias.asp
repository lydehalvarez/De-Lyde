<%@LANGUAGE="JAVASCRIPT"  CODEPAGE="949"%>
<!--#include file="../../../Includes/iqon.asp" -->
<%
   
    var IDUsuario = Parametro("IDUsuario", -1)  
    var reporta = Parametro("reporta", -1)  
    var recibe = Parametro("recibe", -1)  
    var insid = Parametro("insid", -1)  

    var InsO_Nombre = ""
    var InsO_Descripcion = ""
    var InsO_Icono = ""
    var InsO_ID = ""
    var InsT_Nombre = ""
	var InsT_Descripcion = ""
    var Asuntos = 0

%>
<div class="ibox-content">
    <div class="row m-b-sm m-t-sm">
        <div class="col-md-12">
            <div class="input-group"><input type="text" placeholder="Buscar ticket" class="input-sm form-control inpBuscar" onkeydown=""> <span class="input-group-btn">
                <button type="button" class="btn btn-sm btn-primary btnBuscar"> Buscar ticket</button>      </span></div>
               
        </div>
            	
       
    </div>

    <div class="wrapper wrapper-content">
        <div class="row">
            <div class="col-lg-3">
                <div class="ibox float-e-margins">
                    <div class="ibox-content mailbox-content">
                        <div class="file-manager">
                            <a class="btn btn-block btn-primary compose-mail" href="#" onclick="ModalAbrir()">+ Nueva incidencia</a>
                            <div class="space-25"></div>
                            <h5>Originados en:</h5>
                            <ul class="folder-list m-b-md" style="padding: 0">
                        
<%
if (IDUsuario >  -1){
							var sSQL = "SELECT InsO_ID, InsO_Nombre, InsO_Descripcion, InsO_Icono, Asuntos "
											+ " FROM ( select o.InsO_ID, InsO_Nombre, InsO_Descripcion, InsO_Icono "
											+ " , (select count(*) FROM (SELECT i.Ins_ID from Incidencia i  LEFT JOIN Incidencia_Involucrados p ON i.Ins_ID=p.Ins_ID "
											+ " where i.InsO_ID = o.InsO_ID  "
											+ " and (i.Ins_Usu_Reporta = " + IDUsuario 
											+ " or Ins_Usu_Recibe = " + IDUsuario
											+ " or Ins_Usu_Escalado = " + IDUsuario 
											 if(SegGrupo > -1){
												 sSQL += " OR p.Ins_GrupoID= "+SegGrupo
											 }
											 sSQL +=  " OR p.Ins_UsuarioID=" + IDUsuario+ ")  AND i.Ins_EstatusCG27 <> 4  group by i.Ins_ID) as total) as Asuntos "
											 sSQL +=  " from Incidencia_Originacion o, Incidencia_Usuario u, Incidencia i "
											 sSQL +=  " where (o.InsO_ID = u.InsO_ID  "
											 sSQL +=  " and u.InU_IDUnico = " + IDUsuario
											 sSQL +=  " and i.InsO_ID=o.InsO_ID "
											 sSQL +=  " and o.InsO_Habilitado = 1) OR i.Ins_PuedeVer_ProveedorID > -1  "
											 sSQL +=  " ) as T1  "
											 sSQL +=  " WHERE Asuntos > 0 "
											 sSQL +=  " 	group by  InsO_ID, InsO_Nombre, InsO_Descripcion, InsO_Icono, Asuntos "
						//Response.Write(sSQL)
							var rsIncidencias = AbreTabla(sSQL,1,0)
							while (!rsIncidencias.EOF){
								 InsO_Nombre = rsIncidencias.Fields.Item("InsO_Nombre").Value
								 InsO_Descripcion = rsIncidencias.Fields.Item("InsO_Descripcion").Value
								 InsO_Icono = rsIncidencias.Fields.Item("InsO_Icono").Value
								 InsO_ID = rsIncidencias.Fields.Item("InsO_ID").Value
                                 Asuntos = rsIncidencias.Fields.Item("Asuntos").Value
							%>
   							<li><a  class="btnOrigen" title="<%=InsO_Descripcion%>" 
                                   data-nombre="<%=InsO_Nombre%>"
                                   data-insoid="<%=InsO_ID%>"> 
                                <i class="<%=InsO_Icono%>"></i> <%=InsO_Nombre%> 
                                <span class="label label-warning pull-right"><%=Asuntos%></span> </a></li>
<%	
							     rsIncidencias.MoveNext() 
							}
							rsIncidencias.Close()  
				 
%>
                            </ul>
                            
                            <h5>Tipo:</h5>
                            <ul class="category-list" style="padding: 0"> 
<%
							 var sSQL = "SELECT i.InsT_ID, InsT_Nombre, InsT_Descripcion FROM Incidencia_Tipo t "
											+ "INNER JOIN Incidencia i ON i.InsT_ID = t.InsT_ID "
											+ "LEFT JOIN Incidencia_Involucrados p ON i.Ins_ID=p.Ins_ID "
											+ " WHERE  (i.Ins_Usu_Reporta = " + IDUsuario 
											+ " or Ins_Usu_Recibe = " + IDUsuario
											+ " or Ins_Usu_Escalado = " + IDUsuario 
											 if(SegGrupo > -1){
											 sSQL += " OR p.Ins_GrupoID= "+SegGrupo
											 }
		 									 sSQL += " OR p.Ins_UsuarioID=" + IDUsuario+ ")  AND i.Ins_EstatusCG27 <> 4 "
											 sSQL += " group by  i.InsT_ID, InsT_Nombre, InsT_Descripcion"
										//Response.Write(sSQL)
											 var rsTIncidencias = AbreTabla(sSQL,1,0)
											 while (!rsTIncidencias.EOF){
												 InsT_ID= rsTIncidencias.Fields.Item("InsT_ID").Value
												 InsT_Nombre = rsTIncidencias.Fields.Item("InsT_Nombre").Value
												 InsT_Descripcion = rsTIncidencias.Fields.Item("InsT_Descripcion").Value
												
								sSQL = "SELECT COUNT (*) AS Tipo_total FROM ( SELECT i.Ins_ID"
										 + " FROM Incidencia i LEFT JOIN Incidencia_Involucrados p ON i.Ins_ID=p.Ins_ID "
 										 + " WHERE InsT_ID=" + InsT_ID
										 + " and (Ins_Usu_Reporta = " + IDUsuario 
										 + " or Ins_Usu_Recibe = " + IDUsuario
										 + " or Ins_Usu_Escalado = " + IDUsuario 
										 if(SegGrupo > -1){
										 	sSQL += " OR p.Ins_GrupoID= "+SegGrupo
										 }
									     	sSQL +=  " OR p.Ins_UsuarioID=" + IDUsuario+ ")  AND i.Ins_EstatusCG27 <> 4 GROUP BY i.Ins_ID ) as total "
				  			    		var rsTotal = AbreTabla(sSQL,1,0)
								
										var Total_Tipo= rsTotal.Fields.Item("Tipo_total").Value
	 
%>
<!--                                <li><a href="#"> <i class="fa fa-circle text-navy"></i> Work </a></li>
                                <li><a href="#"> <i class="fa fa-circle text-warning"></i> Documents</a></li>
                                <li><a href="#"> <i class="fa fa-circle text-primary"></i> Social</a></li>
                                <li><a href="#"> <i class="fa fa-circle text-info"></i> Advertising</a></li>-->
                                <li><a href="#" class="btnTipos"  title="<%=InsT_Descripcion%>" data-instid="<%=rsTIncidencias.Fields.Item("InsT_ID").Value%>" data-instnombre="<%=rsTIncidencias.Fields.Item("InsT_Nombre").Value%>"> <i class="fa fa-circle text-danger"></i> <%=InsT_Nombre%>  <span class="label label-warning pull-right"><%=Total_Tipo%></span></a></li>
<%	
							     rsTIncidencias.MoveNext() 
							}
							rsTIncidencias.Close()  
				 
%>
                            </ul>

                            <h5 class="tag-title">Tags</h5>
                            <ul class="tag-list" style="padding: 0">
<%                              
                            var sSQL = "select Tag_ID, Tag_Nombre, Tag_Descripcion "
                                     + " from TAG "
                                     + " WHERE Tag_Publica = 1 "
                                     + " and Tag_UsuarioPropietario = " + IDUsuario
                                     + " and Tag_Habilitado = 1 "

							var rsTAG = AbreTabla(sSQL,1,0)
							while (!rsTAG.EOF){
%>
                                <li><a title="<%=rsTAG.Fields.Item("Tag_Descripcion").Value%>" 
                                       data-nombre="<%=rsTAG.Fields.Item("Tag_Nombre").Value%>"
                                       data-tagid="<%=rsTAG.Fields.Item("Tag_ID").Value%>"
                                       class="tTag">
                                    <i class="fa fa-tag"></i> <%=rsTAG.Fields.Item("Tag_Nombre").Value%></a></li>
<%	
							     rsTAG.MoveNext() 
							}
							rsTAG.Close()  
}
%>
                             </ul>
                            <div class="clearfix"></div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-lg-9 animated fadeInRight">
            <div class="mail-box-header">
                
                <div class="mail-tools tooltip-demo m-t-md">
                
                    <h2 id="asTitulo">Asuntos</h2>
             
                    <div class="btn-group pull-right">
                         <button class="btn btn-white btn-sm" id="btnAbiertos"><i class="fa fa-envelope"></i> Sin atender</button> 
                         <button class="btn btn-white btn-sm"  id="btnPendientes"><i class="fa fa-exclamation"></i> Pendientes</button> 
                         <button class="btn btn-white btn-sm"  id="btnDelegados"><i class="fa fa-user-circle"></i> Asignados</button> 
                          <button class="btn btn-white btn-sm"  id="btnCerrados"><i class="fa fa-handshake-o"></i> Cerrados</button> 
                         <button class="btn btn-white btn-sm"  id="btnAbandonados"><i class="fa fa-arrow-down"></i> Abandonados</button> 
                         <button class="btn btn-white btn-sm" id="btnPrioridad"><i class="fa fa-arrow-up"></i> Alta prioridad</button> 


                    <button class="btn btn-white btn-sm btTodos" 
                            data-toggle="tooltip" 
                            data-placement="left" title="Carga de nuevo los asuntos">
                        <i class="fa fa-refresh"></i> Todos</button>
                    
               <!--     <button class="btn btn-white btn-sm" 
                            data-toggle="tooltip" 
                            data-placement="top" title="Ver leidos">
                        <i class="fa fa-eye"></i> </button>
                    
                    <button class="btn btn-white btn-sm" 
                            data-toggle="tooltip" 
                            data-placement="top" title="Ver nuevos">
                        <i class="fa fa-exclamation"></i> </button>
                    
                    <button class="btn btn-white btn-sm" 
                            data-toggle="tooltip" 
                            data-placement="top" title="Borrar">
                        <i class="fa fa-trash-o"></i> </button>-->
                    </div>                    
                    
                    <br />
                </div>
                
            </div>
                <div class="mail-box" id="divAsuntos"></div>
            </div>
              
        </div>
        
        </div>
 			

        </div>
<script src="/Template/inspina/js/plugins/datapicker/bootstrap-datepicker.js"></script>
<script src="/Template/inspina/js/plugins/iCheck/icheck.min.js"></script>
<script src="/pz/wms/Incidencias/Incidencia/js/incidencia.js"></script>

<script type="application/javascript">

    $(document).ready(function(){
	
<% 
		if(reporta>-1){
%>
	 CargaDescripcion(<%=reporta%>, <%=recibe%>, <%=insid%>)
<%
		}
%>

        $('.btnOrigen').click(function(e) {
            e.preventDefault()
            CargaAsuntos($(this).data("insoid"))
            $("#asTitulo").html( $(this).data("nombre") )
         });

        $('.btnTipos').click(function(e) {
            e.preventDefault()
            CargaAsuntosTipo($(this).data("instid"), $(this).data("instnombre"))
        });

     //   $('.btnCorreo').click(function(e) {
//            e.preventDefault()
//            CargaAsuntos($(this).data("insoid"))
//        });

        $('.btTodos').click(function(e) {
            e.preventDefault()
            CargaAsuntos(-1)
            $("#asTitulo").html( "Asuntos " )
        });

$('#btnPrioridad').click(function(e) {
 e.preventDefault()

$("#asTitulo").html( "Asuntos de alta prioridad " )
var Params = "?Prioridad=1"
	   Params += "&IDUsuario=" + $("#IDUsuario").val()
   	   Params += "&SegGrupo=" + $("#SegGrupo").val()

$("#divAsuntos").load("/pz/wms/Incidencias/CTL_Incidencias_Grid.asp" + Params)        
});

$('#btnAbiertos').click(function(e) {
 e.preventDefault()

$("#asTitulo").html( "Asuntos abiertos " )

var  Params = "?Estatus=" + 1
        Params += "&IDUsuario=" + $("#IDUsuario").val()
   	    Params += "&SegGrupo=" + $("#SegGrupo").val()

$("#divAsuntos").load("/pz/wms/Incidencias/CTL_Incidencias_Grid.asp" + Params)        
});

$('#btnCerrados').click(function(e) {
 e.preventDefault()

$("#asTitulo").html( "Asuntos cerrados " )

var  Params = "?Estatus=" + 4
        Params += "&IDUsuario=" + $("#IDUsuario").val()
   	    Params += "&SegGrupo=" + $("#SegGrupo").val()

$("#divAsuntos").load("/pz/wms/Incidencias/CTL_Incidencias_Grid.asp" + Params)        
});

$('#btnDelegados').click(function(e) {
 e.preventDefault()

$("#asTitulo").html( "Asuntos delegados " )

var  Params = "?Estatus=" + 3
        Params += "&IDUsuario=" + $("#IDUsuario").val()
   	    Params += "&SegGrupo=" + $("#SegGrupo").val()

$("#divAsuntos").load("/pz/wms/Incidencias/CTL_Incidencias_Grid.asp" + Params)        
});

$('#btnPendientes').click(function(e) {
 e.preventDefault()

$("#asTitulo").html( "Asuntos pendientes " )

var  Params = "?Estatus=" + 2
        Params += "&IDUsuario=" + $("#IDUsuario").val()
   	    Params += "&SegGrupo=" + $("#SegGrupo").val()

$("#divAsuntos").load("/pz/wms/Incidencias/CTL_Incidencias_Grid.asp" + Params)        
});

$('#btnAbandonados').click(function(e) {
 e.preventDefault()

$("#asTitulo").html( "Asuntos abandonados " )

var  Params = "?Estatus=" + 5
        Params += "&IDUsuario=" + $("#IDUsuario").val()
    	Params += "&SegGrupo=" + $("#SegGrupo").val()

$("#divAsuntos").load("/pz/wms/Incidencias/CTL_Incidencias_Grid.asp" + Params)        
});

		
$('.tTag').click(function(e) {
	e.preventDefault()
	CargaTags($(this).data("tagid"))
	$("#asTitulo").html( "TAG: " + $(this).data("nombre") )
 });

$('.btnBuscar').click(function(e) {
 e.preventDefault()

$("#asTitulo").html( "Asuntos encontrados " )

var  Params = "?Busqueda=" + 1
  		Params += "&IDUsuario=" + $("#IDUsuario").val()
        Params += "&Buscar=" + $(".inpBuscar").val()
   	    Params += "&SegGrupo=" + $("#SegGrupo").val()

$("#divAsuntos").load("/pz/wms/Incidencias/CTL_Incidencias_Grid.asp" + Params)        
});

<% 
		if(reporta==-1){
%>
        CargaAsuntos(-1)    
		<%
		}
		%>
  });
    
	function ModalAbrir(){
              	$("#mdlIncidencias").modal('hide').remove();

            $.ajax({
                  url: "/pz/wms/Incidencias/Incidencias_Modal.asp"
                , method: "post"
                , async: false
                , data: {
                    //  Tarea: 1 // Modal 
                }
                , success: function(res){
                    $("#wrapper").append(res);
                }
            });

        $("#mdlIncidencias").modal('show');
    }
		function ModalEditar(insid, instid){
              	$("#mdlIncidencias").modal('hide').remove();

            $.ajax({
                  url: "/pz/wms/Incidencias/Incidencias_Modal.asp"
                , method: "post"
                , async: false
                , data: {
                      Ins_ID: insid,
                      InsT_ID: instid 
				}
                , success: function(res){
                    $("#wrapper").append(res);
                }
            });

        $("#mdlIncidencias").modal('show');
    }
    
    function CargaAsuntos(insoid){
        
            var Params = "?InsO_ID=" + insoid
                Params += "&IDUsuario=" + $("#IDUsuario").val()
                Params += "&Lpp=1"  //este parametro limpia el cache
         		Params += "&SegGrupo=" + $("#Grupo").val()

            $("#divAsuntos").load("/pz/wms/Incidencias/CTL_Incidencias_Grid.asp" + Params)        
        
    }
	

	
	    function CargaAsuntosTipo(instid, instnombre){
        
		$("#asTitulo").html( ""+instnombre+"" )
		
         var Params = "?InsT_ID=" + instid
                Params += "&IDUsuario=" + $("#IDUsuario").val()
                Params += "&Lpp=1"  //este parametro limpia el cache
         		Params += "&SegGrupo=" + $("#SegGrupo").val()

               
            $("#divAsuntos").load("/pz/wms/Incidencias/CTL_Incidencias_Grid.asp" + Params)        
        
    }
    
	    function CargaDescripcion(reporta, recibe, insid){
        
		            $.ajax({
                  url: "/pz/wms/Incidencias/Incidencias_Ajax.asp"
                , method: "post"
                , async: false
                , data: {
					   Ins_ID:insid,
					  Usuario: $("#IDUsuario").val(),
                      Tarea: 11 // Modal 
                }
                , success: function(res){
                }
            });
		
            var	Params = "?Ins_ID=" + insid
					Params += "&SegGrupo=" + $("#SegGrupo").val()
					Params += "&IDUsuario=" + $("#IDUsuario").val()
					Params += "&Reporta=" + reporta
					Params += "&Recibe=" + recibe
					Params += "&Lpp=1"  //este parametro limpia el cache
               
            $("#divAsuntos").load("/pz/wms/Incidencias/CTL_Incidencias_Descripcion.asp" + Params)        
        
		
    }
	
	    function BarraLateral(){
        
            $("#divsidebar").load("/pz/wms/Incidencias/BarraLateral.asp?Usuario="+<%=IDUsuario%>)        
    }
	
    function CargaTags(tag){
        
            var Params = "?Tag_ID=" + tag
                Params += "&IDUsuario=" + $("#IDUsuario").val()
        		Params += "&SegGrupo=" + $("#SegGrupo").val()
                Params += "&Lpp=1"  //este parametro limpia el cache
               
            $("#divAsuntos").load("/pz/wms/Incidencias/CTL_Incidencias_Grid.asp" + Params)        
        
    }
    
		
    function VerSubTareas(insid){
	
        
          	  var Params = "?Ins_ID=" + insid
			  var subtareas = $('#Ins_IDTarea').val()
		if(subtareas >-1){
					 Params += "&Ins_IDT=" + subtareas
		}else{
					 Params += "&Ins_IDT=" + $('#Ins_IDT').val()
		}
					Params += "&Subtarea=1"
                	Params += "&Lpp=1"  //este parametro limpia el cache
               
            $("#divAsuntos").load("/pz/wms/Incidencias/Juntas_Incidencias.asp" + Params)        
        
    }

    function CargaInicio(){
        
            var Params = "?Ins_ID=" +$('#Ins_IDTarea').val()
  				   Params += "&Ins_IDT=" + $('#Ins_IDTarea').val()
                   Params += "&Lpp=1"  //este parametro limpia el cache
               
            $("#divAsuntos").load("/pz/wms/Incidencias/Juntas_Incidencias.asp" + Params)        
        
    }
	
	    function GuardaComentario(event){
        
				var keyNum = event.which || event.keyCode;
		  
		if(keyNum== 13 ){

		$.post("/pz/wms/Incidencias/Incidencias_Ajax.asp",
		{Ins_ID:$("#Ins_ID").val(),
		InsCm_Observacion: decodeURIComponent($(".Respuesta").val()),
		ID_Unico:$('#selAsignar').val(), 
		Tarea:2
		},
		function(data){
               var Params = "?Ins_ID=" + $("#Ins_ID").val()
                Params += "&Reporta=" + $("#Reporta").val()
                Params += "&Recibe=" + $("#Recibe").val()
               Params += "&Lpp=1"  //este parametro limpia el cache      
            $("#divAsuntos").load("/pz/wms/Incidencias/CTL_Incidencias_Descripcion.asp" + Params) 
			       
        });
		}
		
    }
   			var FunctionInsert = {
			InsertTarea:function(subtarea, insid){
			var 	Asunto= $('.Asunto').val()
			var Descripcion = $('.Descripcion').val()
			var Asignar = $('#selAsignar').val()
			if(Asunto!= '' && Descripcion != ''){
			$('#divValidaCampos').hide()
		$.ajax({
   				 method: "POST",
  				  url: "/pz/wms/Incidencias/Incidencias_Ajax.asp",
 	   data: { 
	   					   InsT_ID:20,
						   InsO_ID:12,
						   Ins_ID: insid,
	   					   Ins_Usu_Recibe:$('#selAsignar').val(),
						   Ins_Asunto: decodeURIComponent($('.Asunto').val()),
						   Ins_Descripcion:decodeURIComponent($('.Descripcion').val()),
						   Ins_FechaInicio_Tarea:$('#inicio').val(),
						   Ins_FechaEntrega_Tarea:$('#fin').val(),
						   Ins_Usu_Reporta: $('#IDUsuario').val(),
 	     				   Subtarea:subtarea,
						   Tarea:4
		},
    cache: false,
	//async: false    SE OCUPA PARA EVITAR REPETICIONES DE INSERCIONES 
    success: function(data){
			
		
				Avisa(Tipo,"Aviso",sMensaje);
				  var Params = "?Ins_ID="+ $("#Ins_ID").val()
	  			  var subtareas = $('#Ins_IDTarea').val()
					if(subtareas >-1){
								 Params += "&Ins_IDT=" + subtareas
					}else{
								 Params += "&Ins_IDT=" + $('#Ins_IDT').val()
					}
				  $('#divAsuntos').load("/pz/wms/Incidencias/Juntas_Incidencias.asp" + Params)
				  var Tipo = "success"
				var sMensaje = "El registro se ha guardado correctamente "
				$("#divNuevaTarea").show('slow')
				}
		});	
			}else{
				$('#divValidaCampos').show()
				$('#divValidaCampos').html("<font color='#FF0000'>* Los campos asignar a, asunto y descripci&oacute;n son requeridos</font>")	
			}
		}
			
		}
	    function GuardaRespuesta(event, inspadre, permiso){
        
				var keyNum = event.which || event.keyCode;
		  
		if(keyNum== 13 ){
			console.log($(".Respuesta").val())
		if(inspadre=="0"){
			var Respuesta = $(".Respuesta").val()
			var Asignado = $("#selAsignar").val()
			
		}else{
			var Respuesta =decodeURIComponent($(".Respuesta"+inspadre).val())
			var Asignado = ""
			console.log($(".selAsignar"+inspadre).val())
		}
		$.post("/pz/wms/Incidencias/Incidencias_Ajax.asp",
		{Ins_ID:$("#Ins_ID").val(),
		InsCm_Padre:inspadre,
		Asignado:Asignado,
		InsCm_Observacion:decodeURIComponent(Respuesta),
		Usuario:$('#IDUsuario').val(),
		Tarea:2
		},
		function(data){
	$("#divComentarios").load("/pz/wms/Incidencias/CTL_Incidencias_Comentarios.asp?Ins_ID="+ $("#Ins_ID").val()+"&Reporta="+$("#Reporta").val()+ "&Recibe="+$("#Recibe").val()+"&Permiso="+ permiso)
        });
		}
		
    }

    
</script>

<script src="/template/inspina/js/loading.js"></script>