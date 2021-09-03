<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%> 
<!--#include file="../../../../../Includes/iqon.asp" -->
<%	
//	Esta ventana es del BPM
//       Dispara un nuevo proceso y controla solamente los procesos de tipo Orden de compra
//
%>
<!--link href="/Template/inspina/css/plugins/daterangepicker/daterangepicker-bs3.css" rel="stylesheet"-->
<div class="wrapper wrapper-content animated fadeInRight">
<p></p>    
<div class="row">
    <div class="col-md-3">
        <div class="ibox">
        <div class="ibox-content">
            <p class="font-bold">Nueva solicitud de:</p>
            <hr>
            <div>
                <a class="product-name" href="#">Tipo</a>
                <div class="m-t text-righ">
                    <div class="form-group">
                        <div>
                        <%
                        var IDPrimero = -1

                        var sSQL = "SELECT Pro_ID, Pro_Nombre, Pro_Descripcion, Pro_DescripcionCorta "
                            sSQL += " FROM BPM_Proceso "
                            sSQL += " WHERE ProT_ID = 2 "
                            sSQL += " AND Pro_Habilitado = 1 "
                            sSQL += " ORDER BY Pro_Orden "		

                        var rsTpGasto = AbreTabla(sSQL,1,0)
                        while (!rsTpGasto.EOF){
                            if(IDPrimero == -1) {
                                IDPrimero = rsTpGasto.Fields.Item("Pro_ID").Value
                            } 
                        %>
                            <div class="tooltip-demo">
                                <div class="i-checks">
                                    <label data-toggle="tooltip" data-placement="right" title="<%=rsTpGasto.Fields.Item("Pro_Descripcion").Value%>"> 
                                    <input type="radio" value="<%=rsTpGasto.Fields.Item("Pro_ID").Value%>" 
                                       name="a" class="objRdio" > <i></i> <%=rsTpGasto.Fields.Item("Pro_Nombre").Value%> 
                                    </label>
                                </div>
                            </div>
                        <%

                            rsTpGasto.MoveNext() 
                        }
                        rsTpGasto.Close()   %>
                        </div>
                    </div>
                </div>
                <div class="small m-t-xs">Seleccione el tipo orden de compra que necesita registrar</div>                    
            </div>
            <hr>                
        </div>
    </div>
    <!-- div class="ibox">
        <div class="ibox-title">
            <h5>Periodos disponibles</h5>
        </div>
        <div class="ibox-content">
            <hr>
            <span class="text-muted small">*Esta informaci&oacute;n es obtenida de un cat&aacute;logo general</span>
        </div>
    </div -->
    <!-- div class="ibox">
        <div class="ibox-title">
            <h5>Plazos disponibles</h5>
        </div>
        <div class="ibox-content text-center">
            <hr>
            <span class="text-muted small">*Esta informaci&oacute;n es obtenida de un cat&aacute;logo general</span>
        </div>
    </div  -->

    </div>
    <div class="col-md-9" id="dvFormato"></div>
</div>
</div>
<!-- Date range use moment.js same as full calendar plugin -->
<!--script src="/Template/inspina/js/plugins/fullcalendar/moment.min.js"></script-->

<!-- Date range picker -->
<!--script src="/Template/inspina/js/plugins/daterangepicker/daterangepicker.js"></script-->

<script type="text/javascript">

	$(document).ready(function() { 

        $('.i-checks').iCheck({
            //checkboxClass: 'icheckbox_square-green',
            radioClass: 'iradio_square-green'
        });        
        
        $('.objRdio').on('ifChanged', function(event){
			//console.log("seleccionado = " + $(this).val())
			//var NombreRadio = $(this).attr('name');
			//var Valor = $('input:radio[name=' + NombreRadio + ']:checked').val()
			 
			if($(this).is(':checked')){
				CargaFormato($(this).val());
			}
        });
        
        /*
		$(".objRdio").change(function() { 
			var NombreRadio = $(this).attr('name');
			var Valor = $('input:radio[name=' + NombreRadio + ']:checked').val()
			CargaFormato(Valor)
		});
		*/
        // Tooltips demo
        /*$('.tooltip-demo').tooltip({
            selector: "[data-toggle=tooltip]",
            container: "body"
        });*/
        
        $('[data-toggle="tooltip"]').tooltip();        
        
		$("#Prov_ID").val(0);	
		$("#OC_ID").val(0);
				
	});
	 
    function CargaFormato(p){
        //console.log(p);
        var sRuta = "/pz/wms/OC/NuevaOrden/OC/BPM_CargaFormato.asp"
            sRuta += "?ProT_ID=1"
            sRuta += "&Pro_ID=" + p
			$("#Pro_ID").val(p);
         
       $("#dvFormato").load(sRuta)

    }
	
</script>