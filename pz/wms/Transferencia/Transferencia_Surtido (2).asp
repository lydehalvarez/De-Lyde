<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%> 
<!--#include file="../../../Includes/iqon.asp" -->
<%
	var TA_ArchivoID = Parametro("TA_ArchivoID",-1)
	var Cli_ID = Parametro("Cli_ID",-1)
	
	var sSQLCli = "SELECT * FROM Cliente WHERE Cli_ID = "+Cli_ID
	
var rsCli = AbreTabla(sSQLCli,1,0)

if(!rsCli.EOF){  
	var Cli_Nombre = rsCli.Fields.Item("Cli_Nombre").Value
}	
%>
<div id="TransferenciaFormato">
</div>
 
<!--<div class="modal fade" id="ModalAutorizacion" tabindex="-1" role="dialog">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
        <h4 class="modal-title">Autorizaci&oacute;n de supervisor</h4>
      </div>
      <div class="modal-body">
        <div class="form-group">
            <label class="control-label col-md-3"><strong>C&oacute;digo del supervisor</strong></label>
            <div class="col-md-6">
                <input type="password" class="form-control" id="Pass" value=""/>
            </div> 
        </div>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-danger" data-dismiss="modal">Cancelar</button>
        <button type="button" class="btn btn-primary btnAutorizaSuper">Autorizar</button>
      </div>
    </div>
  </div>
</div>
<input type="hidden" id="Autoriza_TA"/>
-->
<script type="application/javascript">


$(document).ready(function(e) {
    CargaFormatoTransferencia($('#Cli_ID').val())
});

function CargaFormatoTransferencia(Cli_ID){
	$.post("/pz/wms/Transferencia/Formatos/<%=Cli_Nombre%>/Transferencia_Surtido.asp",
	{
		Cli_ID:Cli_ID,
		TA_ArchivoID:<%=TA_ArchivoID%>
	}
    , function(data){
		$('#TransferenciaFormato').html(data)
	});
}
//
$('.btnAutorizaSuper').click(function(e) {
    e.preventDefault();
	var TA_ID = $('#Autoriza_TA').val();
	var request = {
		Tarea:10,
		TA_ID:TA_ID,
		Batman:$('#Pass').val(),
		IDUsuario:$('#IDUsuario').val()
	}
	NoSeriarializado.AutorizaImpresion(request)
});
$('#Pass').on('keypress',function(e) {
	if(e.which == 13) {
		var TA_ID = $('#Autoriza_TA').val();
		var request = {
			Tarea:10,
			TA_ID:TA_ID,
			Batman:$('#Pass').val(),
			IDUsuario:$('#IDUsuario').val()
		}
	NoSeriarializado.AutorizaImpresion(request)
	}
});

var Autoriza = {
	AutorizaImpresion:function(request){
			$.post("/pz/wms/Transferencia/Transferencia_Ajax.asp",request, function(data){
				var response = JSON.parse(data)
				if(response.result ==1){
					Avisa("success","Avisa","Impresi&oacute;n autorizada")	
					$('#ModalAutorizacion').modal('hide');
					$('#Pass').val("")
				}else{
					Avisa("error","Error",response.message)	
				}
			});
		}
	}
</script>