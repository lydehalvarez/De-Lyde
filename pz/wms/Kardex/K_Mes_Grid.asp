<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include file="../../../Includes/iqon.asp" -->
<%
 
    var iRegistros = 0

    var Cli_ID = Parametro("Cli_ID",-1) 
    var Kdx_ID = Parametro("Kdx_ID",0)
//    var TA_FolioCliente = Parametro("TA_FolioCliente","")
//    var FechaInicio = Parametro("FechaInicio","")
//    var FechaFin = Parametro("FechaFin","")


    var Kdx_Mes = ""
    var Kdx_Anio = ""
    var Kdx_Descripcion = ""

    var sSQLK = ""
    
    var sSQL  = " SELECT * "
        sSQL += " FROM BI_Kardex "
        sSQL += " WHERE Kdx_ID = " + Kdx_ID

    var rsKd = AbreTabla(sSQL,1,0)
    if (!rsKd.EOF){
		Kdx_Mes = rsKd.Fields.Item("Kdx_Mes").Value
        Kdx_Anio = rsKd.Fields.Item("Kdx_Anio").Value
        Kdx_Descripcion = rsKd.Fields.Item("Kdx_Descripcion").Value
        
        sSQLK = "SELECT k.Pro_ID, Pro_SKU, Pro_Nombre, Kdx_Cantidad_Inicial, Kdx_Cantidad_Entradas, Kdx_Cantidad_TA_in"
        sSQLK += " , Kdx_Cantidad_OV_in, Kdx_Cantidad_TA_out, Kdx_Cantidad_OV_out, Kdx_Cantidad_Salidas, Kdx_Cantidad_Final "
        sSQLK += " FROM BI_Kardex_Producto k, Producto p "
        sSQLK += " WHERE Kdx_Mes = " + Kdx_Mes
        sSQLK += " AND Kdx_Anio = " + Kdx_Anio
        sSQLK += " AND k.Pro_ID = p.Pro_ID "
        
        if (Cli_ID > -1) {  
            sSQLK += " AND Cli_ID = " + Cli_ID
        }   

    }

%>
<div class="ibox-title">
    <h5>Kardex - <%=Kdx_Descripcion%></h5>
</div>    
<div class="project-list">
  <table class="table table-hover">
    <tbody>
      <tr>
          <th width="218" class="project-title">Producto</th>
          <th width="191" class="project-title">Saldo Anterior</th>
          <th width="272" class="project-title">Entradas</th>
          <th width="155" class="project-title">Salidas</th>
          <th width="162" class="project-title">Saldo Final</th>
          <th class="project-actions">&nbsp;</th>
      </tr>        
        <%
        var rsKardex = AbreTabla(sSQLK,1,0)
        while (!rsKardex.EOF){
		var Llaves = rsKardex.Fields.Item("Pro_ID").Value
        %>    

      <tr>
         <td class="project-title">
            <%=rsKardex.Fields.Item("Pro_Nombre").Value%>
            <br/>
            <small>SKU: <%=rsKardex.Fields.Item("Pro_SKU").Value%></small>
        </td>
        <td class="project-title">
            <%=rsKardex.Fields.Item("Kdx_Cantidad_Inicial").Value%>
        </td>
        <td class="project-title">
            <%=rsKardex.Fields.Item("Kdx_Cantidad_Entradas").Value%>
        </td>
        <td class="project-title">
           <%=rsKardex.Fields.Item("Kdx_Cantidad_Salidas").Value%>
        </td>
         <td class="project-title">
            <%=rsKardex.Fields.Item("Kdx_Cantidad_Final").Value%>
        </td>
        <td class="project-actions" width="31">
          <!-- a class="btn btn-white btn-sm" href="#" onclick="javascript:CargaCliente(<%=Llaves%>);  return false"><i class="fa fa-folder"></i> Ver</a  -->
        </td>
      </tr>
        <%
            rsKardex.MoveNext() 
            }
        rsKardex.Close()   
        %>       
    </tbody>
  </table>


</div>

<script type="text/javascript">

$(document).ready(function(){    

    $('.tooltip-demo').tooltip({
        selector: "[data-toggle=tooltip]",
        container: "body"
    });    

});
    
    
function CargaCliente(c,t){

    $("#Cli_ID").val(c);
    $("#TA_ID").val(t);    
    CambiaSiguienteVentana();
			
}            
            
            

</script>    
    