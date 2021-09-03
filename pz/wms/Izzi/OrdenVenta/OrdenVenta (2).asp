<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%> 
<!--#include file="../../../../Includes/iqon.asp" -->

<%

	var sSQL = "  SELECT * "
		sSQL += " FROM Izzi_Orden_Venta"
		
		bHayParametros = false
		ParametroCargaDeSQL(sSQL,0)	
	
	var OCSeg_Paso = Parametro("OCSeg_Paso",0)
	
%>
<link href="/Template/inspina/css/plugins/dataTables/datatables.min.css" rel="stylesheet">
    
<style>
	.SoloConsulta{
		border-bottom-color: #0da8e4f2; 
		border-bottom-style: dashed;
		border-bottom-width: 1px;
		line-height: 30px;
        min-height: 30px;
	}	
</style>

<div class="ibox-content"  id="TablaOrdenVenta"> 
<!--        <div class="Agregar">
        <button type="button" id="btnModal" class="btn btn-success" data-toggle="modal" data-target="#exampleModalCenter">
          <i class="fa fa-plus"></i>&nbsp;&nbsp;Agregar otra actividad&nbsp;
        </button>   
        </div>
--><table class="table table-striped table-bordered table-hover dataTables-example" id="OrdenVenta" >
        <thead>
        <tr> 
        	<th>&nbsp;</th>  
            <th>Orden de venta</th>
            <th>Cantidad</th>
            <th>Direcci&oacute;n</th>
            <th>Ver info</th>
         </tr>
        </thead>
        <tbody>
		<%    
        var rsOrdVen = AbreTabla(sSQL,1,0)
         while (!rsOrdVen.EOF){ 
		 var OC_ID = rsOrdVen.Fields.Item("OC_ID").Value
        %>
        <tr>
            <td><%=rsOrdVen.Fields.Item("CORID").Value%></td>
            <td><%=rsOrdVen.Fields.Item("CUSTOMER_SO").Value%></td>
            <td><%=rsOrdVen.Fields.Item("SHIPPIED_QTY").Value%></td>
            <td><%=rsOrdVen.Fields.Item("SHIPPING_ADDRESS").Value%></td>
            <td><button type="button" class="btn btn-sm btn-info btnVer" value="<%=OC_ID%>" data-toggle="modal" data-target="#InfoOrdenVenta"><i class="fa fa-eye"></i>&nbsp;Ver</button></td>
        </tr>
        <%
			rsOrdVen.MoveNext()
			}
		rsOrdVen.Close()
		%>
        </tbody>
    </table>
</div>


<!-- Modal -->
<div class="modal fade" id="InfoOrdenVenta" tabindex="-1" role="dialog" aria-hidden="true">
    <div class="modal-dialog modal-lg">
      <div class="modal-content">
        <div class="modal-header">
          <button type="button" class="close" data-dismiss="modal">&times;</button>
          <h4 class="modal-title" style="font-weight: initial;">Infomarci&oacute;n orden de venta</h4>
        </div>
            <div class="modal-body" style="background:#f0f8ff17;">
                <div class="form-horizontal" id="ModalCuerpo">                       
                </div>
            </div>
           
            <div class="modal-footer">
                <button type="button" class="btn" data-dismiss="modal" id="CerrarModal">Cerrar</button>
            </div>
        </div>
    </div>
</div>

<input type="hidden" id="OC_ID" name="OC_ID" value="-1"/>

<script src="/Template/inspina/js/plugins/dataTables/datatables.min.js"></script>
 
 <script type="application/javascript">

$(document).ready(function() {
		
		 var otable = $('.dataTables-example').DataTable({
            pageLength: 10
			//serverSide: true,
			//processing: true,
			//ordering: false,
			//ajax: "/pz/agt/Izzi/OrdenVenta/OrdenVenta_Data.asp",
			//scrollY: 500,
			//scroller: {
//				loadingIndicator: true
//			}	
		});
		
		
});
$('.btnVer').click(function(e) {
          //console.log($(this))
          //console.log($(this).val())
		  CargaWizard($(this).val())
		  //$('#ModalCuerpo').html($(this).val())
        });

function CargaWizard(id){
	$.post("/pz/agt/Izzi/OrdenVenta/OrdenVenta_Wizard.asp"
				  , { OC_ID:id 	  
				  }             
				  , function(data){
					  if (data > "") {
						$('#ModalCuerpo').html(data)
					  } else {
                        sTipo = "warning";   
						sMensaje = "Ocurrio un error al guardar el registro";
						Avisa(sTipo,"Aviso",sMensaje);	
					  } 
			});
}

</script>
