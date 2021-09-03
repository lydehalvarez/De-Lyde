<%@LANGUAGE="JAVASCRIPT"  CODEPAGE="949"%>
<!--#include file="../../../Includes/iqon.asp" -->


                            <table class="table table-hover issue-tracker">
                                <tbody>
                                <%
						var InsT_Nombre = Parametro("InsT_Nombre","")

						var sSQL = "SELECT *, "
										+" (SELECT Cat_Nombre FROM Incidencia_Tipo a INNER JOIN Cat_Catalogo c ON c.Cat_ID=a.InsT_PrioridadCG33 "
										+" WHERE c.Sec_ID = 33 GROUP BY Cat_Nombre) as InsT_Prioridad,"
										+"  (SELECT Cat_Nombre FROM Incidencia_Tipo b INNER JOIN Cat_Catalogo c ON c.Cat_ID=b.InsT_SeveridadCG32 "
										+" WHERE c.Sec_ID = 32 GROUP BY Cat_Nombre) as InsT_Severidad, "
										+" (SELECT Cat_Nombre FROM Incidencia_Tipo h INNER JOIN Cat_Catalogo c ON c.Cat_ID=h.InsT_EstrellasCG33 "
										+" WHERE c.Sec_ID = 33 GROUP BY Cat_Nombre) as InsT_Estrellas, "
										+"  (SELECT Cat_Nombre FROM Incidencia_Tipo d INNER JOIN Cat_Catalogo c ON c.Cat_ID=d.InsT_MoScoWCG24"
										+"  WHERE c.Sec_ID = 24 GROUP BY Cat_Nombre) as InsT_MoScoW,"
										+"  (SELECT Cat_Nombre FROM Incidencia_Tipo e INNER JOIN Cat_Catalogo c ON c.Cat_ID=e.InsT_TallaCG25"
										+"  WHERE c.Sec_ID = 25 GROUP BY Cat_Nombre) as InsT_Talla, "
										+" (SELECT Cat_Nombre FROM Incidencia_Tipo f INNER JOIN Cat_Catalogo c ON c.Cat_ID=f.InsT_TipoCG28"
										+" WHERE c.Sec_ID = 28 GROUP BY Cat_Nombre) as InsT_Tipo,"
										+" (SELECT Cat_Nombre FROM Incidencia_Tipo g INNER JOIN Cat_Catalogo c ON c.Cat_ID=g.InsT_TipoMedicionCG29"
										+"  WHERE c.Sec_ID = 29 GROUP BY Cat_Nombre) as InsT_Medida "
										+ " FROM Incidencia_Tipo i  where i.InsT_Nombre LIKE '%" + InsT_Nombre + "%' OR i.InsT_Descripcion LIKE '%"+InsT_Nombre+"%'"
										
							var rsIncidencias = AbreTabla(sSQL,1,0)
							while (!rsIncidencias.EOF){
								var InsT_ID = rsIncidencias.Fields.Item("InsT_ID").Value
								var Medicion = rsIncidencias.Fields.Item("InsT_TipoMedicionCG29").Value
%>

                                <tr>
                                    
                                    <td class="project-title">
                                        <a href="#"  class=  "btnCargaHijos" data-instid="<%=InsT_ID%>">
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
                                        <a href="#"  class=  "btnCargaHijos" data-instid="<%=InsT_ID%>"><!-- onclick="javascript:CargaIncidencia(<%=InsT_ID%>);  return false"-->
                                        SLA
                                        </a>
										<br  />
                                        <small>
                                         Atencion: <%=rsIncidencias.Fields.Item("InsT_SLAAtencion").Value%> hrs <br />
                                        </small>
                                        <small>
                                         Resolucion: <%=rsIncidencias.Fields.Item("InsT_SALResolucion").Value%>hrs
                                        </small>
                                    </td>
                                      <td class="text-right">
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
});
 function CargaIncidencias(instid){
        
            var Params = "?InsT_ID=" + instid
                   Params += "&Lpp=1"  //este parametro limpia el cache
               
            $("#divHijos").load("/pz/wms/Incidencias/B_Incidencias_Hijos.asp" + Params)        
        
    }
	</script>