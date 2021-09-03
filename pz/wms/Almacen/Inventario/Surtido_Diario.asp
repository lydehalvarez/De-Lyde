<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include file="../../../../Includes/iqon.asp" -->
<%

   var Cli_ID = Parametro("Cli_ID",-1)
   var Estatus = Parametro("Estatus",-1)
   var Pro_SKU = Parametro("Pro_SKU","")
   var Fecha_Ini = Parametro("FechaInicio","")
   var Fecha_Fin = Parametro("FechaFin","")
   var Pro_ID = -1
   var sMensaje = ""
   var bError = false


%>
<div class="ibox">
    <div class="ibox-title">
        <h5>Inventario diario</h5>
    </div>
    <div class="ibox-content">
        <div class="project-list">
<%
        if (Pro_SKU != ""){

            var sSQL = "SELECT Pro_ID FROM Producto WHERE Pro_SKU='"+Pro_SKU+"'"
            var rsProducto = AbreTabla(sSQL,1,0);
            if (!rsProducto.EOF){
                Pro_ID = rsProducto.Fields.Item("Pro_ID").Value
            } else {
                sMensaje = "No se encontro el SKU " + Pro_SKU + " solicitado"
                bError = true    
            }

        }            
         
        if(!bError) {
%>            
            <table class="table table-hover">
                <tbody>
                <tr>
                 <td class="project-title">
                       <strong> <spa>Fecha surtido</spa></strong>
                       </td>
                        <td class="project-title">
                       <strong> <spa>Piezas</spa></strong>
                       </td>
                       
                       </tr>
<%


			var sSQL =   " select fechasurtido, sum(piezas) as piezas"
							+	" from (select  t1.TA_ID,TA_Folio, estatus, piezas, cast(h.TA_FechaRegistro as date) as fechasurtido"
							+	" from (select t.TA_ID,TA_Folio, Cat_Nombre as estatus, count(*) as piezas"
							+	" from TransferenciaAlmacen t, TransferenciaAlmacen_Articulo_Picking p, Cat_Catalogo c"
							+	" where t.TA_ID = p.TA_ID"
							+	" and t.TA_EstatusCG51 = c.Cat_ID and c.Sec_ID = 51"
                            +   " and t.TA_Cancelada = 0 "
                            +   " and t.TA_EstatusCG51 <> 11 "
							  if(Pro_ID > -1){
								sSQL +=  " and p.Pro_ID = "  + Pro_ID
							  }
							  if(Cli_ID > -1){
								sSQL +=  " AND t.Cli_ID =" + Cli_ID  
							  }
							  if(Estatus > -1){
									sSQL +=  " AND t.TA_EstatusCG51 =" + Estatus  
							   }
									
							 sSQL +=	" group by t.TA_ID, TA_Folio, Cat_Nombre) as t1, TransferenciaAlmacen_Historico h "
							 sSQL +=	" where t1.TA_ID = h.TA_ID "
							 sSQL +=	" and h.TA_EstatusCG51 = 3 "
							   if(Fecha_Ini !="" && Fecha_Fin != ""){
										Fecha_Ini = CambiaFormatoFecha(Fecha_Ini,"dd/mm/yyyy",FORMATOFECHASERVIDOR)
										Fecha_Fin = CambiaFormatoFecha(Fecha_Fin,"dd/mm/yyyy",FORMATOFECHASERVIDOR)

									  sSQL += " AND  CAST(TA_FechaRegistro as date) BETWEEN '"+Fecha_Ini+"' AND '"+Fecha_Fin+"'"
							  }				
							 sSQL +=	" )"
							 sSQL +=	" as t1 "
							 sSQL +=	" group by fechasurtido"
					// Response.Write(sSQL)
						var rsDiario = AbreTabla(sSQL,1,0);
                        while (!rsDiario.EOF){
%>
                <tr>
                    <td class="project-title">
                        <small><%=rsDiario.Fields.Item("fechasurtido").Value%></small>
                    </td>
                   
                    <td class="project-title">
                        <%=rsDiario.Fields.Item("Piezas").Value%>
                     </td>
                    
                </tr>
<%
                        rsDiario.MoveNext();
                    }
                    rsDiario.Close();
%>
                </tbody>
            </table>
<%   } else {  
         Response.Write("<h1>" + sMwensaje + "</h1>")   
      }            
%>           
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



