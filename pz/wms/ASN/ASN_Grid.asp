<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include file="../../../Includes/iqon.asp" -->
<%
 
    var iRegistros = 0

    var Cli_ID = Parametro("Cli_ID",-1) 
    var ASN_Folio = Parametro("ASN_Folio","")
    var FolioCita = Parametro("FolioCita","")
    var ASN_FolioCliente = Parametro("ASN_FolioCliente","")
    var FechaInicio = Parametro("FechaInicio","")
    var FechaFin = Parametro("FechaFin","")
    var ASN_EstatusCG120 = Parametro("ASN_EstatusCG120",-1)
    
    var bHayParams = false

    var sSQL  = " SELECT ASN_ID, ASN_AlmacenDestino, ASN_FolioCliente, ASN_FolioCita, ASN_Folio "
        sSQL += " , ASN_EstatusCG120, dbo.fn_CatGral_DameDato(120, ASN_EstatusCG120) as ESTATUS "
        sSQL += " , ISNULL(ASN_FolioDocumento,'') FolioDoc "
        sSQL += " , ASN_Cancelado, ASN_CancelacionFecha, ASN_Recibida, a.IR_ID, a.Lot_ID, a.Cli_ID "
        sSQL += " , CProv_ID, Transp_ID, ASN_FechaInicio, ASN_FechaTerminacion, ASN_FechaRegistro "
        sSQL += " , (SELECT Cli_Nombre FROM Cliente c WHERE c.Cli_ID = a.Cli_ID) as CLIENTE "
        sSQL += " , CONVERT(NVARCHAR(20),ASN_FechaRegistro,103) as FechaRegistro "
        sSQL += " , IR_Folio, IR_FolioCliente, ASN_CantidadArticulos, ASN_CantidadArticulosRecibidos, ASN_CantidadSKU, ASN_CantidadSKURecibidos "
        sSQL += " , CONVERT(NVARCHAR(20),IR_FechaEntrega,13) as FechaEntrega "
        sSQL += " , ISNULL((SELECT CliPrv_Nombre FROM Cliente_Proveedor cp "
	    sSQL +=            " WHERE cp.Cli_ID = a.Cli_ID AND cp.CliPrv_ID = a.CProv_ID ),'') as Proveedor "
        sSQL += " FROM ASN a, Inventario_Recepcion ir "
        sSQL += " WHERE a.IR_ID = ir.IR_ID "

    var sCondicion = ""
   

    if (Cli_ID > -1) {  
        sCondicion = " AND a.Cli_ID = "+ Cli_ID
        bHayParams = true
    }   
    
    if (ASN_EstatusCG120 > -1) {  
        sCondicion = " AND a.ASN_EstatusCG120 = "+ ASN_EstatusCG120
        bHayParams = true
    }       
        
    if (ASN_Folio != "") { 
        bHayParams = true
        sCondicion += " AND ASN_Folio like '%"+ ASN_Folio + "%'"
    }   
        
    if (FolioCita != "") {
        bHayParams = true
        sCondicion += " AND (IR_Folio like '%"+ FolioCita + "%'"
        sCondicion += " OR IR_FolioCliente like '%"+ FolioCita + "%' )"        
    }           
    
    if (ASN_FolioCliente != "") {
        bHayParams = true
        sCondicion += " AND ASN_FolioCliente like '%"+ ASN_FolioCliente + "%'"   
    }

    if (FechaInicio == "" && FechaFin == "") {
        if(!bHayParams){
            FechaInicio = CambiaFormatoFecha(FechaInicio,"dd/mm/yyyy",FORMATOFECHASERVIDOR)
            sCondicion += " AND CAST(ASN_FechaRegistro as date)  >= dateadd(day,-15,getdate()) "
        }
    } else {   
        if(FechaInicio == "" ) {
            if(FechaFin != "" ) {
                FechaFin = CambiaFormatoFecha(FechaFin,"dd/mm/yyyy",FORMATOFECHASERVIDOR)
                sCondicion += " AND CAST(ASN_FechaRegistro as date)  <= '" + FechaFin + "'"
            }
        } else {
            FechaInicio = CambiaFormatoFecha(FechaInicio,"dd/mm/yyyy",FORMATOFECHASERVIDOR)
            if(FechaFin == "" ) {
                sCondicion += " AND CAST(ASN_FechaRegistro as date)  >= '" + FechaFin + "'"
            } else {
                FechaFin = CambiaFormatoFecha(FechaFin,"dd/mm/yyyy",FORMATOFECHASERVIDOR)
                sCondicion += " AND CAST(ASN_FechaRegistro as date) between  '" + FechaInicio + "' and '" + FechaFin + "' "  
            }
        }
    }
        
    if(sCondicion == "") {       
        sSQL += " AND MONTH(ASN_FechaRegistro) = MONTH(getdate()) and YEAR(ASN_FechaRegistro) = YEAR(getdate()) "
    } else {
        sSQL += sCondicion
    }
	sSQL += " ORDER BY a.ASN_FechaRegistro desc"

    
%>
<div class="ibox-title">
    <h5>ASN</h5>
</div>    
<div class="project-list">
  <table class="table table-hover">
    <tbody>
<%
   var rsASN = AbreTabla(sSQL,1,0)
   if(rsASN.EOF){   %>
<div class="ibox-title">
    <h5>No se encontr&oacute; alg&uacute;n ASN con la informaci&oacute;n proporcionada</h5>
</div> 
   <%    }
   
   var ASN_FolioDocumento = ""
   var FolioCliente = ""
   var Folio = ""
   var ASN_ID = ""
   var Llaves = ""
   var ASN_EstatusCG120 = ""
   var IR_Folio = ""
   var Proveedor = ""
   
   
   while (!rsASN.EOF){
	   	ASN_FolioDocumento = rsASN.Fields.Item("FolioDoc").Value
		FolioCliente = rsASN.Fields.Item("ASN_FolioCliente").Value
		Folio = rsASN.Fields.Item("ASN_Folio").Value
	    ASN_ID = rsASN.Fields.Item("ASN_ID").Value
		Llaves = rsASN.Fields.Item("Cli_ID").Value + ", " + ASN_ID
        ASN_EstatusCG120 = rsASN.Fields.Item("ASN_EstatusCG120").Value
		IR_Folio = rsASN.Fields.Item("IR_Folio").Value
		Proveedor = rsASN.Fields.Item("Proveedor").Value
        var sEstilo = "danger"
        if ( ASN_EstatusCG120 == 2 ){
            sEstilo = "warning"
        }
        if ( ASN_EstatusCG120 == 3 ){
            sEstilo = "primary"
        }  
		if(ASN_FolioDocumento == ""){
			ASN_FolioDocumento = "Pendiente"
		}
        %>    
      <tr>
         <td class="project-title">
            <a href="#" onclick="javascript:CargaCliente(<%=Llaves%>);  return false"><%=rsASN.Fields.Item("CLIENTE").Value%></a>
             <br/>
             <span class="label label-<%=sEstilo%>"><%=rsASN.Fields.Item("ESTATUS").Value%></span>
        </td>
        <td class="project-title">
            <a data-clipboard-text="<%=FolioCliente%>" class="textCopy"><%=FolioCliente%></a>
            <br/>
            
            <small>Registro: <%=rsASN.Fields.Item("FechaRegistro").Value%></small>
        </td>
        <td class="project-title">
            <a data-clipboard-text="<%=Folio%>" class="textCopy" title="Folio Lyde"><%=Folio%></a>
            <br/>
             <span data-clipboard-text="<%=IR_Folio%>" class="textCopy">Folio Cita: <%=IR_Folio%></span> / 
                <%=rsASN.Fields.Item("IR_FolioCliente").Value%> <br/>
            <small> Fecha Cita: <%=rsASN.Fields.Item("FechaEntrega").Value%></small>
        </td>
        <td class="project-title">
            <a href="#" title="Cantidad de art&iacute;culos">Articulos: <%=rsASN.Fields.Item("ASN_CantidadArticulos").Value%></a>
            <br/>
            <small>Recibidos: <%=rsASN.Fields.Item("ASN_CantidadArticulosRecibidos").Value%></small>
        </td>
            <td class="project-title">
            <a href="#" title="Cantidad de art&iacute;culos">Cantidad SKU: <%=rsASN.Fields.Item("ASN_CantidadSKU").Value%></a>
            <br/>
            <small> Recibidos:<%=rsASN.Fields.Item("ASN_CantidadSKURecibidos").Value%></small>
        </td>
         <td class="project-title">
            <a data-clipboard-text="<%=Proveedor%>" class="textCopy"><%=Proveedor%></a>
            <br/>
            <small>Proveedor </small>
        </td>
         <td class="project-title">
            <a href="#">Folio de documento: <%=ASN_FolioDocumento%></a>
        </td>
        <td class="project-actions" width="31">
		  <%if(ASN_FolioDocumento == "Pendiente"){%>
             <a class="btn btn-white btn-sm" href="#" onclick='ASNFunction.Recibo(<%=ASN_ID%>,"<%=FolioCliente%>");'><i class="fa fa-folder"></i> Genera documento</a>
		  <%}else{%>
          <a class="btn btn-white btn-sm" href="#" onclick='ASNFunction.VerDocumento("Recibo_<%=ASN_FolioDocumento%>_<%=FolioCliente%>.pdf");'><i class="fa fa-folder"></i> Ver</a>

		  <%}%>
<!--         <a class="btn btn-white btn-sm btnDespliegaOC" href="#" data-asnid= "<%=ASN_ID%>"><i class="fa fa-credit-card-alt"></i> Ordenes de compra</a>
-->          <a class="btn btn-white btn-sm btnDespliegaEnt" href="#" data-asnid= "<%=ASN_ID%>"><i class="fa fa-truck"></i> Entregas</a>
       				<button class="btn btn-danger btnCierraASN btn-xs" id="btnCASN<%=ASN_ID%>" 
                        data-asnid="<%=ASN_ID%>" >Cierra</button>

        </td>
      </tr>
        <%
            rsASN.MoveNext() 
            }
        rsASN.Close()   
        %>       
    </tbody>
  </table>


</div>

<script type="text/javascript">
var loading = '<div class="spiner-example">'
					+'<div class="sk-spinner sk-spinner-three-bounce">'
						+'<div class="sk-bounce1"></div>'
						+'<div class="sk-bounce2"></div>'
						+'<div class="sk-bounce3"></div>'
					+'</div>'
				+'</div>'

$(document).ready(function(){    

    $('.tooltip-demo').tooltip({
        selector: "[data-toggle=tooltip]",
        container: "body"
    }); 
	
	        $('.btnCierraASN').hide()
		
            $('.btnCierraASN').click(function(e) {
            e.preventDefault();
            $(this).hide('slow')
            var ASN = $(this).data('asnid')
            $('.btnDespliegaEnt').show('slow')
            $('#tr_'+ASN).hide('slow')

            setTimeout(function(){
                $('#tr_'+ASN).remove()
            },800)
        });

	   
//$('.btnDespliegaOC').click(function(e) {
//            e.preventDefault();
//            $(this).hide('slow')
//            var ASN = $(this).data('asnid')
//
//            $('<tr id="tr_'+ASN+'"><td colspan="12" id="td_'+ASN+'">'+loading+'</td></tr>').insertAfter($(this).closest('tr'));
//            var dato = {
//                ASN_ID:ASN
//            }
//            $("#td_"+ASN).load("/pz/wms/ASN/ASN_ClienteOC.asp", dato);  
//        });
		
		$('.btnDespliegaEnt').click(function(e) {
            e.preventDefault();
            $(this).hide('slow')
            var ASN = $(this).data('asnid')
            $('#btnCASN'+ASN).show('slow')

            $('<tr id="tr_'+ASN+'"><td colspan="12" id="td_'+ASN+'">'+loading+'</td></tr>').insertAfter($(this).closest('tr'));
            var dato = {
                ASN_ID:ASN
            }
            $("#td_"+ASN).load("/pz/wms/ASN/ASN_ClienteOC_Entregas.asp", dato);  
        });
		
});
    
    
function CargaCliente(c,t){

   
			
}            

function CargaASN(c,t){

    
			
}        
    
    

</script>    
    