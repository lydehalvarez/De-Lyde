<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include file="../../../Includes/iqon.asp" -->


<div class="ibox">
    <div class="ibox-title">
        <h5>Inventario Transferencias</h5>
    </div>
    <div class="ibox-content">
        <div class="project-list">
            <table class="table table-hover">
                <tbody>
                    <%
			   var Cli_ID = Parametro("Cli_ID","")
			   var Pro_SKU = Parametro("Pro_SKU","")
			   var FechaIni = Parametro("FechaInicio","")
			   var FechaFin = Parametro("FechaFin","")

				if (Pro_SKU != ""){
						
					var sSQL = "SELECT Pro_ID FROM Producto WHERE Pro_SKU="+SKU
					 var rsProducto = AbreTabla(sSQL,1,0);

					var Pro_ID = rsProducto.Fields.Item("Pro_ID").Value
				}
			var sSQL =   "select  t1.TA_ID,TA_Folio, estatus, piezas, cast(h.TA_FechaRegistro as date) as fechasurtido"
								+  " from (select t.TA_ID,TA_Folio, Cat_Nombre as estatus, count(*) as piezas"
								+  " from TransferenciaAlmacen t, TransferenciaAlmacen_Articulo_Picking p, Cat_Catalogo c"
								+  " where t.TA_ID = p.TA_ID"
								+  " and t.TA_EstatusCG51 = c.Cat_ID and c.Sec_ID = 51"
								  if(Pro_ID > -1){
									sSQL +=  " and p.Pro_ID = "  + Pro_ID
								  if(Cli_ID > -1){
									sSQL +=  " AND t.Cli_ID =" + Cli_ID  
								  }
								  if(Fecha_Ini !="" && Fecha_Fin != ""){
									  sSQL += " AND TA_FechaRegistro BETWEEN '"+Fecha_Ini+"' AND '"+Fecha_Fin+"'"
								  }
								  
								 sSQL += " group by t.TA_ID, TA_Folio, Cat_Nombre) as t1, TransferenciaAlmacen_Historico h"
								 sSQL += " where t1.TA_ID = h.TA_ID"
								 sSQL +=  " and h.TA_EstatusCG51 = 3"
                        
						var rsTransferencia = AbreTabla(sSQL,1,0);
                        while (!rsTransferencia.EOF){
                    %>
                <tr>
                    <td class="project-status">
                        <span class=""><%=iRenglon%></span>
                    </td>
                    <td class="project-title">
                        <spa>Folio</spa>
                        <br/>
                        <small><%=rsTransferencia.Fields.Item("Folio").Value%></small>
                    </td>
                    <td class="project-status">
                        <span><%=rsTransferencia.Fields.Item("Estatus").Value%></span>
                    </td>
                    <td class="project-title">
                        <span>Piezas</span>
                        <br/>
                        <%=rsTransferencia.Fields.Item("Piezas").Value%>
                      
                    </td>
                   <td class="project-title">
                        <span>Fecha Surtido</span>
                        <br/>
                        <%=rsTransferencia.Fields.Item("Surtido").Value%>
                      
                    </td>

                
                </tr>
                <%
                        rsTransferencia.MoveNext();
                    }
                    rsTransferencia.Close();
                %>
                </tbody>
            </table>
        </div>
    </div>
</div>


<script type="application/javascript">
    
    $(document).ready(function(){


          $('.btnVer').click(function(e) {
            e.preventDefault();
             
         //   $("#Aud_ID").val( $(this).data('audid') )
           
            CambiaSiguienteVentana()
 
        });
        
        
        
        
    });


</script>



