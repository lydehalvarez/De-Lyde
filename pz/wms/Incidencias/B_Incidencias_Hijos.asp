<%@LANGUAGE="JAVASCRIPT"  CODEPAGE="949"%>
<!--#include file="../../../Includes/iqon.asp" -->
<%
						var InsT_ID = Parametro("InsT_ID",-1)
						var InsT_ID_Anterior = Parametro("InsT_ID_Anterior",-1)
					 	var Procedencia = Parametro("Procedencia", "")
					 	var Nombre = Parametro("Nombre", "")
						Procedencia = Procedencia.replace("-",",")
						if(Procedencia == 1){
						var Proviene = ""
						}
						if(InsT_ID_Anterior > -1){
							
						var sSQL = "SELECT *, "
										+" (SELECT Cat_Nombre FROM Incidencia_Tipo a INNER JOIN Cat_Catalogo c ON c.Cat_ID=a.InsT_PrioridadCG33 "
										+" WHERE c.Sec_ID = 33 AND  a.InsT_ID = " + InsT_ID_Anterior+ " GROUP BY Cat_Nombre) as InsT_Prioridad,"
										+"  (SELECT Cat_Nombre FROM Incidencia_Tipo b INNER JOIN Cat_Catalogo c ON c.Cat_ID=b.InsT_SeveridadCG32 "
										+" WHERE c.Sec_ID = 32 AND  b.InsT_ID = " + InsT_ID_Anterior+ " GROUP BY Cat_Nombre) as InsT_Severidad, "
										+" (SELECT Cat_Nombre FROM Incidencia_Tipo h INNER JOIN Cat_Catalogo c ON c.Cat_ID=h.InsT_EstrellasCG33 "
										+" WHERE c.Sec_ID = 33 AND  h.InsT_ID = " + InsT_ID_Anterior+ " GROUP BY Cat_Nombre) as InsT_Estrellas, "
										+"  (SELECT Cat_Nombre FROM Incidencia_Tipo d INNER JOIN Cat_Catalogo c ON c.Cat_ID=d.InsT_MoScoWCG24"
										+"  WHERE c.Sec_ID = 24  AND  d.InsT_ID = " + InsT_ID_Anterior+ " GROUP BY Cat_Nombre) as InsT_MoScoW,"
										+"  (SELECT Cat_Nombre FROM Incidencia_Tipo e INNER JOIN Cat_Catalogo c ON c.Cat_ID=e.InsT_TallaCG25"
										+"  WHERE c.Sec_ID = 25 AND  e.InsT_ID = " + InsT_ID_Anterior+ " GROUP BY Cat_Nombre) as InsT_Talla, "
										+" (SELECT Cat_Nombre FROM Incidencia_Tipo f INNER JOIN Cat_Catalogo c ON c.Cat_ID=f.InsT_TipoCG28"
										+" WHERE c.Sec_ID = 28 AND  f.InsT_ID = " + InsT_ID_Anterior+ " GROUP BY Cat_Nombre) as InsT_Tipo,"
										+" (SELECT Cat_Nombre FROM Incidencia_Tipo g INNER JOIN Cat_Catalogo c ON c.Cat_ID=g.InsT_TipoMedicionCG29"
										+"  WHERE c.Sec_ID = 29 AND  g.InsT_ID = " + InsT_ID_Anterior+ " GROUP BY Cat_Nombre) as InsT_Medida "
										+" FROM Incidencia_Tipo i where i.InsT_ID = " + InsT_ID_Anterior
				
				
						var rsIncidencias = AbreTabla(sSQL,1,0)

						InsT_ID = rsIncidencias.Fields.Item("InsT_Padre").Value
						}
					
						var sSQL = "SELECT *, "
										+" (SELECT Cat_Nombre FROM Incidencia_Tipo a INNER JOIN Cat_Catalogo c ON c.Cat_ID=a.InsT_PrioridadCG33 "
										+" WHERE c.Sec_ID = 33 AND a.InsT_ID = " + InsT_ID+ "  GROUP BY Cat_Nombre) as InsT_Prioridad,"
										+"  (SELECT Cat_Nombre FROM Incidencia_Tipo b INNER JOIN Cat_Catalogo c ON c.Cat_ID=b.InsT_SeveridadCG32 "
										+" WHERE c.Sec_ID = 32  AND b.InsT_ID = " + InsT_ID+ "  GROUP BY Cat_Nombre) as InsT_Severidad, "
										+" (SELECT Cat_Nombre FROM Incidencia_Tipo h INNER JOIN Cat_Catalogo c ON c.Cat_ID=h.InsT_EstrellasCG33 "
										+" WHERE c.Sec_ID = 33 AND h.InsT_ID = " + InsT_ID+ "  GROUP BY Cat_Nombre) as InsT_Estrellas, "
										+"  (SELECT Cat_Nombre FROM Incidencia_Tipo d INNER JOIN Cat_Catalogo c ON c.Cat_ID=d.InsT_MoScoWCG24"
										+"  WHERE c.Sec_ID = 24 AND d.InsT_ID = " + InsT_ID+ "  GROUP BY Cat_Nombre) as InsT_MoScoW,"
										+"  (SELECT Cat_Nombre FROM Incidencia_Tipo e INNER JOIN Cat_Catalogo c ON c.Cat_ID=e.InsT_TallaCG25"
										+"  WHERE c.Sec_ID = 25 AND e.InsT_ID = " + InsT_ID+ "  GROUP BY Cat_Nombre) as InsT_Talla, "
										+" (SELECT Cat_Nombre FROM Incidencia_Tipo f INNER JOIN Cat_Catalogo c ON c.Cat_ID=f.InsT_TipoCG28"
										+" WHERE c.Sec_ID = 28 AND f.InsT_ID = " + InsT_ID+ "  GROUP BY Cat_Nombre) as InsT_Tipo,"
										+" (SELECT Cat_Nombre FROM Incidencia_Tipo g INNER JOIN Cat_Catalogo c ON c.Cat_ID=g.InsT_TipoMedicionCG29"
										+"  WHERE c.Sec_ID = 29 AND g.InsT_ID = " + InsT_ID+ "  GROUP BY Cat_Nombre) as InsT_Medida "
							 			+" FROM Incidencia_Tipo i where i.InsT_Padre = " + InsT_ID
			
						var rsIncidencias = AbreTabla(sSQL,1,0)
						
							
			sSQL = "SELECT InsT_ID, InsT_Nombre FROM Incidencia_Tipo WHERE InsT_ID = " + InsT_ID
			var rsInsNombre = AbreTabla(sSQL,1,0)
				
			Procedencia = Procedencia + "," + rsInsNombre.Fields.Item("InsT_ID").Value 
			sSQL = "SELECT InsT_Nombre FROM Incidencia_Tipo WHERE InsT_ID in (" + Procedencia + ") ORDER BY InsT_ID" 
			
			var rsInsProcede = AbreTabla(sSQL,1,0)
			var Proviene = ""
			while(!rsInsProcede.EOF){
			 Proviene = Proviene + " / " + rsInsProcede.Fields.Item("InsT_Nombre").Value
			rsInsProcede.MoveNext() 
			}
			rsInsProcede.Close()  

								
						if(InsT_ID >0){
%>

                        <span class="pull-left"><a  class="text-muted btnRegresar"  onclick="javascript:CargaAnterior(<%=InsT_ID%>);  return false">
                        <i class="fa fa-mail-reply"></i>&nbsp;<strong>Regresar</strong></a>         <br />
                        <label class="control-label col-md-12 Proviene" ><strong><%=Proviene%> </strong></label></span><br />
                        <input type="hidden" class="control-label col-md-9 Proviene" id="Proviene" value="<%=Proviene%>"></input> 
                        <input type="hidden" class="control-label col-md-9 InsTipo_ID" id="InsTipo_ID" value="<%=InsT_ID%>"></input> 

<%
						}
%>

                            <table class="table table-hover issue-tracker">
                                <tbody>
                                <%

						
							while (!rsIncidencias.EOF){
								var InsT_ID = rsIncidencias.Fields.Item("InsT_ID").Value
								var InsT_Anterior = rsIncidencias.Fields.Item("InsT_Padre").Value
								var Medicion = rsIncidencias.Fields.Item("InsT_TipoMedicionCG29").Value

%>
                             <tr>
                                    
                                    <td class="project-title">
                                       <a href="#" class=  "btnCargaHijos" data-instid="<%=InsT_ID%>">
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
                                        <a href="#"  class=  "btnCargaHijos" data-instid="<%=InsT_ID%>">
                                        Prioridad
                                        </a>
										<br  />
                                        <small>
          								 <%=rsIncidencias.Fields.Item("InsT_Prioridad").Value%>
                                        </small>
                                        </td>
                                        <td class="project-title">
                                        <a href="#"  class=  "btnCargaHijos" data-instid="<%=InsT_ID%>">
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
                                        <a href="#"  class=  "btnCargaHijos" data-instid="<%=InsT_ID%>">
                                        Prioridad ABC
                                        </a>
										<br  />
                                        <small>
          								 <%=rsIncidencias.Fields.Item("InsT_PrioridadABC").Value%>
                                        </small>
                                         </td>
                                        <td class="project-title">
                                        <a href="#"  class=  "btnCargaHijos" data-instid="<%=InsT_ID%>">
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
                                        <a href="#"  class=  "btnCargaHijos" data-instid="<%=InsT_ID%>">
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
                                        <a href="#"  class=  "btnCargaHijos" data-instid="<%=InsT_ID%>"> 
                                        Estrellas
                                        </a>
										<br  />
                                        <small>
          								 <%=rsIncidencias.Fields.Item("InsT_Estrellas").Value%>
                                        </small>
                                        <%
                                        }	if(Medicion == 5){ 
									 %>
                                        <a href="#"  class=  "btnCargaHijos" data-instid="<%=InsT_ID%>">
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
                                        <a href="#"  class=  "btnCargaHijos" data-instid="<%=InsT_ID%>">
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
                                        <button class="btn btn-white btn-xs  btnEditar"  data-instid = "<%=InsT_ID%>"> Editar</button>
                                 <!--       <button class="btn btn-white btn-xs"> Mag</button>
                                        <button class="btn btn-white btn-xs"> Rag</button>
-->                                 </td>
                                   <!-- <td class="text-right">
                                        <button class="btn btn-white btn-xs"> Tag</button>
                                        <button class="btn btn-white btn-xs"> Mag</button>
                                        <button class="btn btn-white btn-xs"> Rag</button>
                                    </td>-->
                             
                                </tr>
                              <%
								  rsIncidencias.MoveNext() 
							}
							rsIncidencias.Close()  
								%>
                                </tbody>
                            </table>
                           
<script>
   $(document).ready(function(){

   $('.btnEditar').click(function(e) {  
   e.preventDefault()
         
            var Params = "?InsT_ID=" + $(this).data('instid')
               
            $("#Contenido").load("/pz/wms/Incidencias/Incidencias_Tipo_Edicion.asp" + Params)        
       
});

$('.btnCargaHijos').click(function(e) {   
	
	 var procede = "<%=Procedencia%>"
		
				procede = procede.replace(",","-")
		
		e.preventDefault()   	  
            var Params = "?InsT_ID=" + $(this).data('instid')
			       Params += "&Procedencia=" +procede
                   Params += "&Lpp=1"  //este parametro limpia el cache
               
         $("#divHijos").load("/pz/wms/Incidencias/B_Incidencias_Hijos.asp" + Params)        
         $('#Anterior').val($(this).data('instid'))
    });
});
	</script>
