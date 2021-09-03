<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include file="../../../../Includes/iqon.asp" -->


<div class="ibox">
    <div class="ibox-title">
        <h5>Inventario Transferencias</h5>
    </div>
    <div class="ibox-content">
        <div class="project-list">
    		    
            <table class="table table-hover">
                <tbody>
                 <tr>
              		   <td class="project-title">
                       <strong> <spa>Folio</spa></strong>
                       </td>
              		   <td class="project-title">
                       <strong> <spa>Estatus</spa></strong>
                       </td>
                       <td class="project-title">
                       <strong> <spa>Piezas</spa></strong>
                       </td>
              		   <td class="project-title">
                       <strong> <spa>Fecha surtido</spa></strong>
                       </td>

                       
                       </tr>
<%
           var Cli_ID = Parametro("Cli_ID",-1)
           var Estatus = Parametro("Estatus",-1)
           var Pro_SKU = Parametro("Pro_SKU","")
           var Fecha_Ini = Parametro("FechaInicio","")
           var Fecha_Fin = Parametro("FechaFin","")

            if (Pro_SKU != ""){

                var sSQL = "SELECT Pro_ID FROM Producto WHERE Pro_SKU='"+Pro_SKU+"'"
                 var rsProducto = AbreTabla(sSQL,1,0);

                var Pro_ID = rsProducto.Fields.Item("Pro_ID").Value
            }
			var sSQL = "select  t1.TA_ID,TA_Folio, estatus, piezas, cast(h.TA_FechaRegistro as date) as fechasurtido"
                    +  " from (select t.TA_ID,TA_Folio, Cat_Nombre as estatus, count(*) as piezas"
                    +  " from TransferenciaAlmacen t, TransferenciaAlmacen_Articulo_Picking p, Cat_Catalogo c "
                    +  " where t.TA_ID = p.TA_ID"
                    +  " and t.TA_EstatusCG51 = c.Cat_ID and c.Sec_ID = 51"
                    +  " and t.TA_Cancelada = 0 "
                    +  " and t.TA_EstatusCG51 <> 11 "
                      if(Pro_ID > -1){ 
                        sSQL +=  " and p.Pro_ID = "  + Pro_ID
                      }
                      if(Cli_ID > -1){
                        sSQL +=  " AND t.Cli_ID =" + Cli_ID  
                      }
                       if(Estatus > -1){
                        sSQL +=  " AND t.TA_EstatusCG51 =" + Estatus  
                      }
                      if(Fecha_Ini !="" && Fecha_Fin != ""){
                        Fecha_Ini = CambiaFormatoFecha(Fecha_Ini,"dd/mm/yyyy",FORMATOFECHASERVIDOR)
                        Fecha_Fin = CambiaFormatoFecha(Fecha_Fin,"dd/mm/yyyy",FORMATOFECHASERVIDOR)

                          sSQL += " AND  CAST(TA_FechaRegistro as date) BETWEEN '"+Fecha_Ini+"' AND '"+Fecha_Fin+"'"
                      }

                     sSQL += " group by t.TA_ID, TA_Folio, Cat_Nombre) as t1, TransferenciaAlmacen_Historico h"
                     sSQL += " where t1.TA_ID = h.TA_ID "
                     sSQL +=  " and h.TA_EstatusCG51 = 3 "
                       // Response.Write(sSQL)
					if(Fecha_Ini !="" && Fecha_Fin != ""){
								
						var rsTransferencia = AbreTabla(sSQL,1,0);
                        while (!rsTransferencia.EOF){
%>
                <tr>
                    <td class="project-title">
                        <small><%=rsTransferencia.Fields.Item("TA_Folio").Value%></small>
                    </td>
                    <td class="project-status">
                        <strong><span><%=rsTransferencia.Fields.Item("estatus").Value%></span></strong>
                    </td>
                    <td class="project-title">
                        <%=rsTransferencia.Fields.Item("Piezas").Value%>
                      
                    </td>
                   <td class="project-title">
                        <%=rsTransferencia.Fields.Item("fechasurtido").Value%>
                      
                    </td>

                
                </tr>
 <%
                        rsTransferencia.MoveNext();
                    }
                    rsTransferencia.Close();
                  } else {
                    Response.Write("Es necesario seleccionar un rango de fechas")  
                  }
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



