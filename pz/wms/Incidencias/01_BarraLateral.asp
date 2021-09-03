<%@LANGUAGE="JAVASCRIPT"  CODEPAGE="1252"%>
<!--#include file="../../../Includes/iqon.asp" -->
<%  
  	var Usuario = Parametro("Usuario",-1)

	var sHTMLTags = "   <label class='font-normal'>Agregar TAG:</label><br>"
                				+  "<p align='left'><select style='padding: 0' data-placeholder='Selecciona...' class='chosen-select' id='SelTag' onchange= 'Tags()'  multiple style='width:100px;' tabindex='1'>"
								+	" <option value=''>Selecciona</option>"

							var sSQL = "select * from TAG "
							var rsTAG = AbreTabla(sSQL,1,0)
							while (!rsTAG.EOF){
								sHTMLTags+= " <option value='"+rsTAG.Fields.Item("Tag_ID").Value+"'>"+rsTAG.Fields.Item("Tag_Nombre").Value+"</option>"
				
							     rsTAG.MoveNext() 
							}
							rsTAG.Close()  
							sHTMLTags+="</select></p>"
	
var sHTMLTagsU = "   <label class='font-normal'>Agregar Involucrados:</label>"
   		   					 +  "<select data-placeholder='Selecciona...' class='chosen-select4'  id='SelUsuarios' onchange='Usuarios()'  multiple style='width:350px;'>"
    						 +  " <option value=''>Selecciona</option>"
						
					sSQL = "SELECT IDUnica, Usu_Nombre AS Nombre FROM Usuario u INNER JOIN Seguridad_Indice s ON u.Usu_ID = s.Usu_ID "
							 + "UNION" 
							 + " SELECT IDUnica, Emp_Nombre AS Nombre FROM Empleado e INNER JOIN Seguridad_Indice s ON e.Emp_ID = s.Emp_ID "
		   	  				var  rsAsignados = AbreTabla(sSQL,1,0)
							while (!rsAsignados.EOF){
								sHTMLTagsU+= " <option value='"+rsAsignados.Fields.Item("IDUnica").Value+"'>"+rsAsignados.Fields.Item("Nombre").Value+"</option>"
				
							     rsAsignados.MoveNext() 
							}
							rsAsignados.Close()  
							sHTMLTagsU+="</select>"
	
var sSQL = "SELECT TOP(5) * from Incidencia i "
         + " INNER JOIN Incidencia_Tipo t ON i.InsT_ID = t.InsT_ID "
	     + " WHERE Ins_Usu_Recibe = " + Usuario 
         + " ORDER BY Ins_FechaRegistro DESC"
var rsIncidencias = AbreTabla(sSQL,1,0)

//SELECT TOP(5) * from Incidencia i
//INNER JOIN Incidencia_Tipo t ON i.InsT_ID=t.InsT_ID 
//WHERE Ins_Usu_Recibe =36 and (InsT_PrioridadCG33 > 3 or InsT_TallaCG25 >4 or 
//InsT_PrioridadABC = 1 or InsT_SeveridadCG32 > 4 or InsT_EstrellasCG33 > 3) 
//ORDER BY Ins_FechaRegistro DESC

var fecha = new Date()

%>


                <ul class="nav nav-tabs navs-3">

                    <li class="active"><a data-toggle="tab" href="#tab-x">
                        Incidencias
                    </a></li>
                    <li><a data-toggle="tab" href="#tab-y">
                        Tags
                    </a></li>
                 </ul>

                <div class="tab-content">


                    <div id="tab-x" class="tab-pane active">

                  <div class="sidebar-title">  
                  <div class="sidebar-message">
	                       <a class="btn btn-block btn-primary compose-mail" href="#" onclick="ModalAbrir()">     <font color="#FFFFFF">+ Nueva incidencia</font></a>
							</div>
                            <h3> <i class="fa fa-comments-o"></i>Ultimas incidencias</h3>
<!--                            <small><i class="fa fa-tim"></i> Tienes 2 nuevas incidencias.</small>
-->                        </div>

                        <div>
                        
<%
                             while( !(rsIncidencias.EOF)){
								 Titulo = rsIncidencias.Fields.Item("Ins_Titulo").Value
								 Descripcion = rsIncidencias.Fields.Item("Ins_Descripcion").Value
								 Fecha = rsIncidencias.Fields.Item("Ins_FechaRegistro").Value
								 reporta = rsIncidencias.Fields.Item("Ins_Usu_Reporta").Value
								 recibe = rsIncidencias.Fields.Item("Ins_Usu_Recibe").Value
								 insid = rsIncidencias.Fields.Item("Ins_ID").Value
								 
								 sSQL = "SELECT  ISNULL(Usu_RutaImg + Usu_Imagen, '') as foto "
								 		  +"FROM Usuario u INNER JOIN Seguridad_Indice s ON s.Usu_ID=u.Usu_ID "
										  + " WHERE s.IDUnica="+reporta
										
								var rsFoto = AbreTabla(sSQL,1,0)
								var Ruta_Imagen=""
								if(!rsFoto.EOF){
								Ruta_Imagen =  rsFoto.Fields.Item("foto").Value
								}
								if(Ruta_Imagen==""){
								var Ruta_Imagen =  "/Media/wms/Perfil/avatar.jpg"
								}
								sSQL="SELECT  dbo.fn_Usuario_DameNombreUsuario( "+reporta+" ) as usuario "
								var rsUsuario = AbreTabla(sSQL,1,0)
								var Usuario =  rsUsuario.Fields.Item("usuario").Value

%>
                          
                       
                            <div class="sidebar-message">
                                <a href="#" onclick="CargaDescripcion(<%=reporta%>,<%=recibe%>,<%=insid%>)">
                              		<div class="pull-left text-center">
                                        <img alt="image" class="img-circle message-avatar" src="<%=Ruta_Imagen%>">

                                        <div class="m-t-xs">
                                 <!--           <i class="fa fa-star text-warning"></i>
                                            <i class="fa fa-star text-warning"></i>-->
                                        </div>
                                    </div>
                                    <div class="media-body">
                                  <strong><%=Usuario%></strong>
									<br />
                    		   	<strong>Incidencia:</strong> <%=Titulo%>
									<br />
                                <strong>Descripcion:</strong> <%=Descripcion%> 
                                    <br>
                                 <small class="text-muted"><%=Fecha%></small>
                                    </div>
                                </a>
                            </div>
<%
                                 rsIncidencias.MoveNext() 
							}
							rsIncidencias.Close()  
%>

                    </div>
                   <center> <a   class="text-muted btnVerMas"><strong>Ver mas </strong></a></center> 
				</div>
                    <div id="tab-y" class="tab-pane">

         					
                        <ul class="sidebar-list">
                          <div class="sidebar-message">
	                            <a class="btn btn-block btn-primary compose-mail" href="#" onclick="AbrirFTAG()">  <font color="#FFFFFF">+ Nuevo TAG</font></a>
							</div>
						<div id="divTAG">
                            <li>
                                <a href="#">
                                <strong>Nombre</strong>
                                <br />
                                       <input  class='form-control' value=""  id="TAGNombre"/>
                                </a>
                            </li>
                         </div>
                            <div id="divFormTAG">
                            <li>
                                <a href="#">
                                <strong>Descripcion</strong>
                                <br />
                                       <input  class='form-control' value=""  id="TAGDescripcion"/>
                                </a>
                            </li>
                            <li>
                                <a href="#">
               				<strong>Origen</strong>
                               </a>
	                        </li>
      						<li>
                           <a href="#">
                            <%
                            var sCondicion = ""//"InsT_Padre = 0"
                            var campo = "InsO_Nombre"
                            
                            CargaCombo("InsO_ID","class='form-control'","InsO_ID",campo,"Incidencia_Originacion",sCondicion,"","Editar",0,"Selecciona")%>
                             </a>
                            </li>
                            <li>
                                <a href="#">
                     					<input type="checkbox"  class="i-checks ChkPublico" checked='checked' onclick="EliminaUsuarios()"> Publico
          	     						<input type="checkbox"  class="i-checks ChkPrivado" checked='' onclick="MostrarUsuarios()"> Privado
                                </a>
                            </li>
                           <li>
                            <div id="divTUsuarios">
                           		   <%=sHTMLTagsU%>
                                </div>
                                  <div id="divUsuarios">
                                   </div>
                                </li>
                        
                            <li>
                                <a href="#">
                                 <button type="button" class="btn btn-white btnCerrar" onclick="Ocultar()">Cerrar</button>
              					  <button type="button" class="btn btn-primary btnTermina">Terminar</button>

                                </a>
                            </li>
                            </div>
                            <li>
                                <a href="#">
<!--                                   folio
-->                                </a>
                            </li>
 							  <li>
                                <a href="#">
                                   <%//sHTMLTags%>
                                   <br/>   
										<div id="divSelTags">                                       
                                   			<%=sHTMLTags%>
										</div>
                      
                                      <%
						//		   var sEventos = "class='form-control combman' style='width:350px;'"
//                             	   var sCondicion = ""
//                                CargaCombo("Tag_ID", sEventos, "Tag_ID","Tag_Nombre","Tag",sCondicion,"","Editar",0,"--Seleccionar--")
//									  %>
              <!--           <select name="chosen-multiple" class="chosen1" data-placeholder="Elige tus colores" multiple  style="width:350px;" tabindex="4">
  <option value="azul">Azul</option>
  <option value="amarillo">Amarillo</option>
  <option value="blanco">Blanco</option>
  <option value="gris">Gris</option>
  <option value="marron">Marrón</option>
  <option value="naranja">Naranja</option>
  <option value="negro">Negro</option>
  <option value="rojo">Rojo</option>
  <option value="verde">Verde</option>
  <option value="violeta">Violeta</option>
</select>-->
 
<div id="divtags"></div>

                                
                                </a>
                            </li>
                             <li>
                               <a href="#">
                                   <div id="divX">
                                   </div>
                                </a>
                            </li>
                        </ul>	
  
                    </div>


                    </div>

                
           
                            <input  type="hidden" value="" class="agenda" id="Tag_ID"/>

    <!-- Custom and plugin javascript -->
<script src="/Template/inspina/js/plugins/chosen/chosen.jquery.js"></script>


<script type="application/javascript">

$(document).ready(function(){
$("#divTUsuarios").hide()
$("#divTAG").hide()
$("#divFormTAG").hide()
$(".ChkPrivado").attr('checked', false);
 $('#divSelTags').hide()
 $("#divtags").hide()
MostrarTags()

//         jQuery.getScript( "//harvesthq.github.io/chosen/chosen.jquery.js" )
//        .done(function( script, textStatus ) {
//            jQuery(".chosen1").chosen();
//          })
//        .fail(function( jqxhr, settings, esxception ) {
//             alert("Error");
//    });
//  
$('.btnVerMas').click(function(e) {
	$("#Contenido").load("/pz/wms/Incidencias/CTL_Incidencias.asp")
});

$('.btnTermina').click(function(e) {
	   if($(".ChkPublico").is(':checked')){
	  var Tag_Publica =1
	  }else{
	  var Tag_Publica =0  
	 }
	$.ajax({
		method: "POST",
		url: "/pz/wms/Incidencias/Incidencias_Ajax.asp?",
		data: {Tag_Descripcion:$("#TAGDescripcion").val(), 
					Tag_Publica:Tag_Publica, 
					Tag_Origen:$("#InsO_ID").val(),
					Tag_ID:$("#Tag_ID").val(),
					Tarea:6
		},
    cache: false,
    success: function (data) {
			
			$("#TAGNombre").prop( "disabled", false );
			$("#TAGNombre").val("");
			$("#divFormTAG").hide()
			$("#divTAG").hide()

	}
		});
	});
	
	$('#TAGNombre').on('keypress',function(e) {
		if(e.which == 13) {
				$.ajax({
    method: "POST",
    url: "/pz/wms/Incidencias/Incidencias_Ajax.asp?",
    data: {Tag_Nombre:$("#TAGNombre").val(), 
				ID_Unico:$("#IDUsuario").val(), 
				Tarea:5
		},
    cache: false,
    success: function (data) {
			var response = JSON.parse(data)
				if(response.tagid != 0){
				$("#Tag_ID").val(response.tagid)
				}
		
			$("#divFormTAG").show()
			
			$("#TAGNombre").prop( "disabled", true );
	}
		});
			}
	});
});      
	var ventana = $("#VentanaIndex").val() 
			if(ventana != 2570||ventana != 2600){
				$('.chosen-select').chosen({width: "100%"});
				$('.chosen-select4').chosen({width: "100%"});
			}
			function AbrirFTAG(){
			$("#TAGNombre").prop( "disabled", false);
			$("#TAGNombre").val("")
			$("#divTAG").show()
			$("#TAGNombre").focus()
			}
			
			
    	function MostrarTags(){
				var ventana = $("#VentanaIndex").val() 
				var params = ""
			if(ventana==2529||ventana==603||ventana==303||ventana==2510||ventana==1560||ventana==405||ventana==2630||ventana==2544||ventana==203||ventana==331||ventana==956||ventana==1052){
 $('#divSelTags').show()
 $("#divtags").show()
}
		if(ventana==2529||ventana==603){
		 params += "&TA_ID=" + $('#TA_ID').val()
		}
	  		if(ventana==303){
				params += "&OV_ID=" + $('#OV_ID').val()
			}
  				if(ventana==2532){
				params += "&Alm_ID="+ $('#Alm_ID').val()
				}
  					if(ventana==1560){
		 				params += "&Pro_ID=" +  $('#Pro_ID').val()
					}
		 params += "&Usuario="+ $('#IDUsuario').val()

		$("#divtags").load("/pz/wms/Incidencias/BarraLateral_html.asp?Tarea=3" + params)

 		$('#SelTag').focus()	
	}
        	function ModalAbrir(){
<%			
        var params = ""
		%>
		var ventana = $("#VentanaIndex").val() 
         if(ventana==2529||ventana==603){
		<%
		params +=  "TA_ID:$('#TA_ID').val(),"
			%>
		}
		
	  		if(ventana==303){
               	<% 
				 	params +=  " OV_ID:$('#OV_ID').val(),"
			%>
			}
 					if(ventana==2510){
            	     	<%
					  	params +=  "Pt_ID:$('#Pt_ID').val(),"
					%>
					}
						if(ventana==1560){
								<%
								params +=  "Pro_ID:$('#Pro_ID').val(),"
							%>
						}
							if(ventana==405){
									<%	
									params +=  "Tag_ID:$('#Tag_ID').val(),"
								%>
							}
									if(ventana==2630){
            	     						<%
											params +=  " Man_ID:$('#Man_ID').val(),"
										%>
									}
											if(ventana==2544){
											 		<%
												params +=  "ManD_ID:$('#ManD_ID').val(),"
												%>
											}
												//	if(ventana==){
//													 	params +=  " Lot_ID:$('#Lot_ID').val(),"
//													}
															if(ventana==203){
													 		<%
																params +=  " Cli_ID:$('#Cli_ID').val(),"
														%>
															}
																	if(ventana==331){
															 		<%
																		params +=  " CliOC_ID:$('#CliOC_ID').val(),"
																%>
																	}
																			if(ventana==956){
																			<%
																				 	params +=  " Prov_ID:$('#Prov_ID').val(),"
																		%>
																			}
																				if(ventana==1052){
																					<%
																						params +=  "OC_ID:$('#OC_ID').val(),"
																				%>
																				}
																				//	if(ventana==1560){
//																			 				params +=  "CCgo_ID:$('#CCgo_ID').val(),"
//																					}

			$.ajax({
                  url: "/pz/wms/Incidencias/Incidencias_Modal.asp"
                , method: "post"
                , async: false
                , data: {
             		<%=params%>
               		Tarea:1
				}
                , success: function(res){
                    $("#wrapper").append(res);
                }
            });
        

        $("#mdlIncidencias").modal('show');
    }
	function MostrarUsuarios(){
		$("#divTUsuarios").show()
		$(".ChkPublico").attr('checked', false);
	}
	function EliminaUsuarios(){
		$(".ChkPrivado").prop('checked', false);
		
		$("#divTUsuarios").hide()
		$.ajax({
    method: "POST",
    url: "/pz/wms/Incidencias/Incidencias_Ajax.asp?",
    data: {Tag_ID:$("#Tag_ID").val(),
				Tarea:7
		},
    cache: false,
    success: function (data) {
			var params = "?Tag_ID="+ $('#Tag_ID').val()
	 		$("#divUsuarios").load("/pz/wms/Incidencias/BarraLateral_html.asp" + params + "&Tarea=4")

	}
	});
	}
		    function CargaDescripcion(reporta, recibe, insid){
        
            var Params = "?insid=" + insid
                Params += "&reporta=" + reporta
                Params += "&recibe=" + recibe
                Params += "&IDUsuario=" + recibe
               Params += ""//este parametro limpia el cache
               
            
			$("#Contenido").load("/pz/wms/Incidencias/CTL_Incidencias.asp" + Params)        
        
    }

	function EliminaTag(tagid, taid,ovid, almid, proid){
		var ventana = $("#VentanaIndex").val() 
		
  		 var params = "?Tag_ID=" +tagid
		 		params += "&TA_ID=" +taid
				params += "&OV_ID=" + ovid
				params += "&Alm_ID="+ almid
		 		params += "&Pro_ID=" +  proid
		 params += "&Usuario="+ $('#IDUsuario').val()

		$("#divSelTags").load("/pz/wms/Incidencias/Incidencias_Ajax.asp" + params+ "&Tarea=9")
		$("#divSelTags").load("/pz/wms/Incidencias/BarraLateral_html.asp"+ params +"&Tarea=1")
		$("#divtags").load("/pz/wms/Incidencias/BarraLateral_html.asp" + params + "&Tarea=3")

 		$('#SelTag').focus()	
	}
	function EliminaUsuario(tagid, usuid){
			var ventana = $("#VentanaIndex").val() 
		
	  		var params = "?Tag_ID=" +tagid
	    	  	   params += "&Usuario="+ usuid

		$("#divX").load("/pz/wms/Incidencias/Incidencias_Ajax.asp" + params+ "&Tarea=7")
		$("#divTUsuarios").load("/pz/wms/Incidencias/BarraLateral_html.asp"+ params +"&Tarea=2")
		$("#divUsuarios").load("/pz/wms/Incidencias/BarraLateral_html.asp" + params + "&Tarea=4")

 		$('#SelTag').focus()	
	}
	function Tags(){
		var ventana = $("#VentanaIndex").val() 
		
		var Tag1 = $('#SelTag').val()
		var Tag2 = $('#SelTag2').val()
		
		
		if(Tag1 >0){
  		var params = "?Tag_ID=" + $('#SelTag').val()
		}
		
		if(Tag2 >0){
  		var params = "?Tag_ID=" + $('#SelTag2').val()
		}
 		if(ventana==2529||ventana==603){
		 params += "&TA_ID=" + $('#TA_ID').val()
		}
	  		if(ventana==303){
				params += "&OV_ID=" + $('#OV_ID').val()
			}
  				if(ventana==2532){
				params += "&Alm_ID="+ $('#Alm_ID').val()
				}
  					if(ventana==1560){
		 				params += "&Pro_ID=" +  $('#Pro_ID').val()
					}
		 params += "&Usuario="+ $('#IDUsuario').val()

		$("#divSelTags").load("/pz/wms/Incidencias/Incidencias_Ajax.asp" + params+ "&Tarea=8")
		$("#divSelTags").load("/pz/wms/Incidencias/BarraLateral_html.asp"+ params +"&Tarea=1")
		$("#divtags").load("/pz/wms/Incidencias/BarraLateral_html.asp" + params + "&Tarea=3")

 		$('#SelTag2').focus()	
	}
		function Usuarios(){
		var ventana = $("#VentanaIndex").val() 
		
		var Tag1 = $('#SelUsuarios').val()
		var Tag2 = $('#SelUsuarios2').val()
		
		
		if(Tag1 >0){
  		var params = "?Usuario=" + $('#SelUsuarios').val()
		}
		
		if(Tag2 >0){
  		var params = "?Usuario=" + $('#SelUsuarios2').val()
		}
		 params += "&Tag_ID="+ $('#Tag_ID').val()

 		$("#divX").load("/pz/wms/Incidencias/Incidencias_Ajax.asp" + params+ "&Tarea=10")
		$("#divTUsuarios").load("/pz/wms/Incidencias/BarraLateral_html.asp" + params+ "&Tarea=2")
		$("#divUsuarios").load("/pz/wms/Incidencias/BarraLateral_html.asp"+ params +"&Tarea=4")

 		$('#SelUsuarios2').focus()	
	}

	

</script>