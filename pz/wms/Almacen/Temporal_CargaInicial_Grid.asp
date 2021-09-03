<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include virtual="/Includes/iqon.asp" -->
<%

var rqIntUbi_ID = Parametro("Ubi_ID", 0)
var Ubi_Nombre = Parametro("Ubi_Nombre", "")
   
   
   if(rqIntUbi_ID == 0){
        if(Ubi_Nombre != ""){
           var sCondicion = "Ubi_Nombre = '" + Ubi_Nombre + "'"
               rqIntUbi_ID = BuscaSoloUnDato("Ubi_ID","Ubicacion",sCondicion,-1,0) 
       }
   }

   

        var sqlUbi = "EXEC SPR_Pallet "
              + "@Opcion = 1001 "
            + ", @Ubi_ID = " + rqIntUbi_ID
            + ", @PT_PorBuscar = 0 "
   
  // Response.Write(sqlUbi)
 
        var rsUbi = AbreTabla(sqlUbi, 1, 0) 
%>
    <div class="ibox">
        <div class="ibox-title">
            <h5>LPNs en la Ubicaci&oacute;n</h5>
            <button class="btn btn-white btn-sm" type="button" title="Limpiar Busqueda"
                onkeypress="TemporalCargaInicialCantidad.LimpiaEspacio(event);">
                <i class="fa fa-trash"></i> Limpiar
            </button>
        </div>
        <div class="ibox-content">
             <table class="table table-striped issue-tracker">
                <thead>
                    <tr>
                        <th></th>
                        <th>#</th>
                        <th>LPN</th>
                        <th>Cantidad</th>
                        <th>Acciones</th>
                        
                    </tr>
                </thead>
                <tbody>
<%  
        if( !(rsUbi.EOF) ){

			var ExisteUbicacion = "UPDATE Ubicacion"
						+" SET Ubi_Viva = 1 "
						+" WHERE Ubi_ID = "+rqIntUbi_ID
			Ejecuta(ExisteUbicacion,0)
            var i = 0
			var PT_ID = ""
			var PT_LPN = ""
            var Pro_Sku = ""
			var Pt_Object = ""
            var Pro_ID = -1
			
            while( !(rsUbi.EOF) ){
				PT_ID = rsUbi("PT_ID").Value
				Pt_Object = '{PT_ID: '+PT_ID +'}'
				PT_LPN = rsUbi("PT_LPN").Value
                Pro_ID = rsUbi("Pro_ID").Value
                Pro_Sku = rsUbi("Pro_Sku").Value
%>
                    <tr>
                        <td>
                            <a class="btn btn-success btn-xs" onclick='TemporalCargaInicialCantidad.LPNSeleccionar({LPN: "<%= PT_LPN %>", Cantidad: "<%= rsUbi("PT_ConteoFisico").Value %>",Pro_ID:"<%= rsUbi("Pro_ID").Value %>"});' title="Seleccionar LPN">
                                <i class="fa fa-check-square-o" title="Seleccionar para su Reubicacion"></i>
                            </a>
                        </td>
                        <td><%= ++i %></td>
                        <td class=" col-sm-3 project-title">
                            <a data-clipboard-text="<%=PT_LPN%>" class="textCopy"><%= PT_LPN %></a>
                            <br>
                            <small>
                                <span data-clipboard-text="<%=Pro_Sku%>" class="textCopy">(<%= Pro_Sku %>)</span>&nbsp;-&nbsp;<span data-clipboard-text="<%=rsUbi("Pro_Nombre").Value%>" class="textCopy"><%= rsUbi("Pro_Nombre").Value %></span>
                            </small>
                        </td>
                        <td class="col-sm-1">
                            <input type="text" id="ConteoFisico_<%= PT_ID %>" class="form-control"
                             value="<%= rsUbi("PT_Cantidad_Actual").Value %>">
                        </td>
                        <td class="col-sm-6">
                            <div class="btn-group" role="group" aria-label="Basic example">
                                <a class="btn btn-info btn-sm" title="Actualizar"
                                 onclick='TemporalCargaInicialCantidad.LPNCambiarConteoFisico(<%=Pt_Object%>);'>
                                    <i class="fa fa-refresh"></i> Actualizar
                                </a>
                                <a class="btn btn-danger btn-sm" title="Quitar LPN de la ubicaci&oacute;n"
                                 onclick='TemporalCargaInicialCantidad.LPNPorBuscarPoner(<%=Pt_Object%>)'>
                                    <i class="fa fa-question-circle-o"></i> Quitar
                                </a>
                            </div>
                            <div class="btn-group" role="group" aria-label="Basic example">
                                <a class="btn btn-white btn-sm" title="LPN"
                                 onclick='TemporalCargaInicialCantidad.ImprimirLPN(<%=Pt_Object%>);'>
                                    <i class="fa fa-print"></i> LPN
                                </a>
                                <a class="btn btn-white btn-sm" title="Auditoria"
                                 onclick='TemporalCargaInicialCantidad.ImprimirAuditoria(<%=Pt_Object%>);'>
                                    <i class="fa fa-print"></i> Aud
                                </a>
                            </div>
                            <a class="btn btn-success btn-sm" title="Auditoria"
                             onclick='TemporalCargaInicialCantidad.SeriesModalAbrir({
                                  PT_ID: <%= PT_ID %>
                                , PT_LPN: "<%= PT_LPN %>"
                                , Pro_ID: "<%= Pro_ID %>" 
                                , Pro_Sku: "<%= Pro_Sku %>"
                                , Ubi_ID: <%= rqIntUbi_ID %>
                                , Ubi_Nombre: "<%= rsUbi("Ubi_Nombre").Value %>"
                                });'>
                                <i class="fa fa-address-card-o"></i> Series
                            </a>
                        </td>
                        
                    </tr>
<%
                rsUbi.MoveNext()
            }
        } else {
			
			var ExisteUbicacion = "UPDATE Ubicacion"
						+" SET Ubi_Viva = 0 "
						+" WHERE Ubi_ID = "+rqIntUbi_ID
			Ejecuta(ExisteUbicacion,0)
			
%>
                    <tr>
                        <td colspan="6">
                            <i class="fa fa-exclamation-circle fa-lg"></i> Ubicacion Vacia
                        </td>
                    </tr>               
<%
        }
%>
                </tbody>
            </table>
        </div>
    </div>
    

<script type="application/javascript">
    $(document).ready(function(e) {

        $("#Ubi_ID").val(<%= rqIntUbi_ID %>)
        
        
    });
</script>
    
    
    
    
    