<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%> 
<!--#include file="../../../../Includes/iqon.asp" -->

<div class="form-horizontal" >
    <div class="row">
        <div class="col-lg-12">
            <div class="ibox float-e-margins">
                <div class="ibox-content">
                    <div class="form-group" id="CargaSerie">
                        <label class="control-label col-md-4"><strong>Serie de caja master</strong></label>
                        <div class="col-md-6"><input type="text" class="form-control Serie" placeholder="Serie de caja master"/></div>
                    </div> 
                    <div class="spiner-example" id="Cargando">
                        <div class="sk-spinner sk-spinner-rotating-plane"></div>
                        <div style="text-align:center;margin-top:25px">Cargando imagen de rayos x...</div>
                    </div>
                    
                </div>
            </div>
        </div>
    </div>
</div>



<script type="application/javascript">
$('#Cargando').hide()

$('.Serie').on('keypress',function(e) {
	if(e.which == 13) {
		$('.Serie').prop('disabled',true)
		$('#CargaSerie').hide('slow')
		$('#Cargando').show('slow')
		setTimeout(function(){$('#CargaSerie').show('slow')
		$('#Cargando').hide('slow')
		$('.Serie').prop('disabled',false)
		$('.Serie').val("")
		$('.Serie').focus()
		},1500)
	}
});
</script>