<%@LANGUAGE="JAVASCRIPT"  CODEPAGE="949"%>
<!--#include file="../../../Includes/iqon.asp" -->

    <div class="form-horizontal" id="toPrint">
        <div class="wrapper wrapper-content  animated fadeInRight">
            <div class="row">
                <div class="col-lg-12">
                    <div class="ibox">
                        <div class="ibox-title">
                            <h5>Lista incidencias</h5>
                            <div class="ibox-tools">
                                <a href="" class="btn btn-primary btn-s btnAgregar">+ Nuevo tipo de incidencia</a>
                            </div>
                        </div>
                        <div class="ibox-content">

                            <div class="m-b-lg">

                                <div class="input-group">
                                    <input type="text" placeholder="Buscar incidencia por nombre..." class=" form-control Buscar">
                                    <span class="input-group-btn">
                                        <button type="button" class="btn btn-white" onclick = "javascript:BuscaIncidencia();  return false"> Buscar</button>
                                    </span>
                                </div>
                                <!--<div class="m-t-md">

                                    <div class="pull-right">
                                        <button type="button" class="btn btn-sm btn-white"> <i class="fa fa-comments"></i> </button>
                                        <button type="button" class="btn btn-sm btn-white"> <i class="fa fa-user"></i> </button>
                                        <button type="button" class="btn btn-sm btn-white"> <i class="fa fa-list"></i> </button>
                                        <button type="button" class="btn btn-sm btn-white"> <i class="fa fa-pencil"></i> </button>
                                        <button type="button" class="btn btn-sm btn-white"> <i class="fa fa-print"></i> </button>
                                        <button type="button" class="btn btn-sm btn-white"> <i class="fa fa-cogs"></i> </button>
                                    </div>

                              <strong> 61 incidencias encontradas.</strong>


                                </div>-->

                            </div>

                            <div class="table-responsive" id = "divHijos">
                            <table class="table table-hover issue-tracker">
                                <tbody>
                                <%
					    var InsT_Padre = Parametro("InsT_Padre", -1)  
						var InsT_ID_Anterior = 0

						var sSQL = "SELECT *, Cat_Nombre as InsT_Medida, "
										+" (SELECT Cat_Nombre FROM Incidencia_Tipo a INNER JOIN Cat_Catalogo c ON c.Cat_ID=a.InsT_PrioridadCG33 "
										+" WHERE c.Sec_ID = 33 AND a.InsT_Padre = 0 GROUP BY Cat_Nombre) as InsT_Prioridad,"
										+"  (SELECT Cat_Nombre FROM Incidencia_Tipo b INNER JOIN Cat_Catalogo c ON c.Cat_ID=b.InsT_SeveridadCG32 "
										+" WHERE c.Sec_ID = 32 AND b.InsT_Padre = 0 GROUP BY Cat_Nombre) as InsT_Severidad, "
										+" (SELECT Cat_Nombre FROM Incidencia_Tipo h INNER JOIN Cat_Catalogo c ON c.Cat_ID=h.InsT_EstrellasCG33 "
										+" WHERE c.Sec_ID = 33 AND h.InsT_Padre = 0 GROUP BY Cat_Nombre) as InsT_Estrellas, "
										+"  (SELECT Cat_Nombre FROM Incidencia_Tipo d INNER JOIN Cat_Catalogo c ON c.Cat_ID=d.InsT_MoScoWCG24"
										+"  WHERE c.Sec_ID = 24 AND d.InsT_Padre = 0 GROUP BY Cat_Nombre) as InsT_MoScoW,"
										+"  (SELECT Cat_Nombre FROM Incidencia_Tipo e INNER JOIN Cat_Catalogo c ON c.Cat_ID=e.InsT_TallaCG25"
										+"  WHERE c.Sec_ID = 25 AND e.InsT_Padre = 0 GROUP BY Cat_Nombre) as InsT_Talla, "
										+" (SELECT Cat_Nombre FROM Incidencia_Tipo f INNER JOIN Cat_Catalogo c ON c.Cat_ID=f.InsT_TipoCG28"
										+" WHERE c.Sec_ID = 28 AND f.InsT_Padre = 0 GROUP BY Cat_Nombre) as InsT_Tipo"
										+ " FROM Incidencia_Tipo i INNER JOIN Cat_Catalogo c ON c.Cat_ID=i.InsT_TipoMedicionCG29"
								if(InsT_Padre > -1){
										sSQL += " WHERE c.Sec_ID = 29 AND i.InsT_Padre = " + InsT_Padre
								}else{
										sSQL += " WHERE c.Sec_ID = 29 AND i.InsT_Padre = 0"
								}
		
							var rsIncidencias = AbreTabla(sSQL,1,0)
							while (!rsIncidencias.EOF){
								var InsT_ID = rsIncidencias.Fields.Item("InsT_ID").Value
								var Medicion = rsIncidencias.Fields.Item("InsT_TipoMedicionCG29").Value
								var Nombre = rsIncidencias.Fields.Item("InsT_Nombre").Value
%>

                                <tr>
                                    
                                    <td class="project-title">
                                        <a href="#"  class="btnCargaHijos" data-instid="<%=InsT_ID%>">
          								 <%=rsIncidencias.Fields.Item("InsT_Nombre").Value%>
                                        </a>
										<br  />
                                        <small>
          								 <%=rsIncidencias.Fields.Item("InsT_Descripcion").Value%>
                                        </small>
                                    </td>
                                     <td class="project-title">
                                     <%
										if(Medicion == 1){ 
									 %>
                                        <a href="#">
                                        Prioridad
                                        </a>
										<br  />
                                        <small>
          								 <%=rsIncidencias.Fields.Item("InsT_Prioridad").Value%>
                                        </small>
                                        </td>
                                        <td class="project-title">
                                        <a href="#" >
                                        Severidad
                                        </a>
										<br  />
                                        <small>
          								 <%=rsIncidencias.Fields.Item("InsT_Severidad").Value%>
                                        </small>
                                        <%
                                        }
											if(Medicion == 2){ 
									 %>
                                        <a href="#">
                                        Prioridad ABC
                                        </a>
										<br  />
                                        <small>
          								 <%=rsIncidencias.Fields.Item("InsT_PrioridadABC").Value%>
                                        </small>
                                         </td>
                                        <td class="project-title">
                                        <a href="#">
                                        Orden
                                        </a>
										<br  />
                                        <small>
          								 <%=rsIncidencias.Fields.Item("InsT_Orden").Value%>
                                        </small>
                                        <%
                                        }
											if(Medicion == 3){ 
									 %>
                                        <a href="#">
                                        MoScoW
                                        </a>
										<br  />
                                        <small>
          								 <%=rsIncidencias.Fields.Item("InsT_MoScoW").Value%>
                                        </small>
                                        <%
                                        }
											if(Medicion == 4){ 
									 %>
                                        <a href="#">
                                        Estrellas
                                        </a>
										<br  />
                                        <small>
          								 <%=rsIncidencias.Fields.Item("InsT_Estrellas").Value%>
                                        </small>
                                        <%
                                        }	if(Medicion == 5){ 
									 %>
                                        <a href="#">
                                        Talla
                                        </a>
										<br  />
                                        <small>
          								 <%=rsIncidencias.Fields.Item("InsT_Talla").Value%>
                                        </small>
                                        <%
                                        }
										%>
                                     
                                    </td>
                                      <td class="project-title">
                                        <a href="#">
                                        SLA
                                        </a>
										<br  />
                                        <small>
                                         Atencion: <%=rsIncidencias.Fields.Item("InsT_SLAAtencion").Value%> hrs <br />
                                        </small>
                                        <small>
                                         Resolucion: <%=rsIncidencias.Fields.Item("InsT_SLAResolucion").Value%>hrs
                                        </small>
                                    </td>
                                  
                                <td class="text-right">
									    <button class="btn btn-white btn-xs  btnCargaHijos"  data-instid = "<%=InsT_ID%>"> Entrar</button>
                                        <button class="btn btn-white btn-xs btnEditar" data-instid = "<%=InsT_ID%>"> Editar</button>
                                 <!--       <button class="btn btn-white btn-xs"> Mag</button>
                                        <button class="btn btn-white btn-xs"> Rag</button>
-->                                 </td>
                             
                                </tr>
                                <%
								  rsIncidencias.MoveNext() 
							}
							rsIncidencias.Close()  
								%>
                                </tbody>
                            </table>
                            </div>
                        </div>

                    </div>
                </div>
            </div>


        </div>
        

     </div>
          <input  type="hidden" value="<%=InsT_ID_Anterior%>" class="agenda" id="Anterior"/>
          <input  type="hidden" value="" class="agenda" id="Hijos"/>
          <input type="hidden" class="control-label col-md-9 Proviene" id="Proviene" value=""></input>
           <input  type="hidden" value="0" class="agenda Padre" id="Padre"/>

<script>
   $(document).ready(function(){

$('.btnCargaHijos').click(function(e) {   
		e.preventDefault()   	  
            var Params = "?InsT_ID=" + $(this).data('instid')
			 	   Params += "&Procedencia=" + $(this).data('instid')
                   Params += "&Lpp=1"  //este parametro limpia el cache
            
         $("#divHijos").load("/pz/wms/Incidencias/B_Incidencias_Hijos.asp" + Params)        
         $('#Anterior').val($(this).data('instid'))
    });


 

        $('.btnAgregar').click(function(e) {
              e.preventDefault()
			  var Procedencia = $('#Proviene').val()
			  console.log($('#Proviene').val())
			  	if (Procedencia != ""){
			  	Procedencia =  Procedencia.replace(" / ","-")
			  	Procedencia =  Procedencia.replace(" / ","-")
			  	Procedencia =  Procedencia.replace(" / ","-")
			  	Procedencia =  Procedencia.replace(" / ","-")
			  	Procedencia =  Procedencia.replace(" / ","-")
			  	Procedencia =  Procedencia.replace(" / ","-")
			  	Procedencia =  Procedencia.replace(" / ","-")
				}
            $.ajax({ 
                 method: "post"
                , async: false
			    , url: "/pz/wms/Incidencias/Incidencias_Tipo_Modal.asp?"
                , data: {
                      Procedencia: Procedencia,
					  InsT_ID: $("#InsTipo_ID").val(),// Modal 
                }
                , 
				cache: false,
				success: function(res){
                    $("#wrapper").append(res);
                }
            });
        

        $("#mdlIncidencias").modal('show');
		$('.Estrellas').val(0)
  });
   $('.btnEditar').click(function(e) {  
   e.preventDefault()
         
            var Params = "?InsT_ID=" + $(this).data('instid')
               
            $("#Contenido").load("/pz/wms/Incidencias/Incidencias_Tipo_Edicion.asp" + Params)        
       
});
});
function BuscaIncidencia(){
        
            var Params = "?InsT_Nombre=" + $('.Buscar').val()
                   Params += "&Lpp=1"  //este parametro limpia el cache
               
            $("#divHijos").load("/pz/wms/Incidencias/B_Incidencias_Busqueda.asp" + Params)        
       
  }

	 function CargaAnterior(instidant){
//          $('#Anterior').val(instidant)
//            var Params = "?InsT_ID_Anterior=" +  $('#Anterior').val()
//                   Params += "&Lpp=1"  //este parametro limpia el cache
//               
//            $("#divHijos").load("/pz/wms/Incidencias/B_Incidencias_Hijos.asp" + Params)   

		   $('#Contenido').load("/pz/wms/Incidencias/B_Incidencias.asp")
     
         
    }
	</script>