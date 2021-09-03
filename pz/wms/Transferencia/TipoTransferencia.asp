<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%> 
<!--#include file="../../../Includes/iqon.asp" -->

<div class="col-md-6">
    <div class="ibox">
        <div class="ibox-content product-box">

            <div class="product-imitation">
                &Uacute;nica transferencia
            </div>
            <div class="product-desc">
                <a class="product-name UTrans"> &Uacute;nica transferencia</a>
                <div class="small m-t-xs">
                    Esta acci&oacute;n es para crear solo una transferencia nueva.
                </div>
                <div class="m-t text-righ">
                    <a class="btn btn-xs btn-outline btn-primary UTrans">Adelante&nbsp;<i class="fa fa-long-arrow-right"></i> </a>
                </div>
            </div>
        </div>
    </div>
</div>
<div class="col-md-6">
    <div class="ibox">
        <div class="ibox-content product-box">
            <div class="product-imitation ">
                Multiple transferencia
            </div>
            <div class="product-desc">
                <a class="product-name MTrans">Multiple transferencia</a>
                <div class="small m-t-xs">
                    De ser requerido una multiple transferencia se debe de llenar el layout correspondiente para crear muchas tranferencias al momento.
                </div>
                <div class="m-t text-righ">
                    <a  class="btn btn-xs btn-outline btn-primary MTrans">Adelante&nbsp;<i class="fa fa-long-arrow-right"></i> </a>
                </div>
            </div>
        </div>
    </div>
</div>

<script type="application/javascript">

$('.UTrans').click(function(e) {
	U_Transferencia()
});
$('.MTrans').click(function(e) {
	M_Transferencia()
});
function U_Transferencia(){
	$('#Transferencia').load("/pz/wms/Transferencia/UnicaTransferencia.asp")
	
}
function M_Transferencia(){
	$('#Transferencia').load("/pz/wms/Transferencia/MultipleTransferencia.asp")
}


</script>

