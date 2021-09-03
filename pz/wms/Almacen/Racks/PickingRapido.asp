<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%> 
<!--#include file="../../../../Includes/iqon.asp" -->


<style>
.ColorTitulo{
	color: #1ab394;
}
</style>

<div class="wrapper wrapper-content animated fadeInRight">
    <div class="form-horizontal">
        <div class="row">
            <div class="col-lg-6">
                <div class="ibox">
                    <div class="ibox-content">
                        <div class="form-group">
                            <legend class="control-label col-md-5 ColorTitulo">Asignar posici&oacute;n<i class="fa fa-pencil"></i></legend>
                        </div>
                        <div class="form-group">
                            <label class="control-label col-md-5">Colocar c&oacute;digo de rack</label>
                            <div class="col-lg-7">
                                <input value="" autocomplete="off" data-toggle="tooltip" data-placement="bottom" title="Escanea o escribe el c&oacute;digo ubicado en el rack" placeholder="" class="form-control help rackcodigo" type="text">
                            </div>
                        </div>
                    </div>
               </div>
            </div>
            <div class="col-lg-6">
                <div class="ibox">
                    <div class="ibox-content">
                        <div class="form-group">
                            <legend class="control-label col-md-5 ColorTitulo">Consulta SKU<i class="fa fa-search"></i></legend>
                        </div>
                        <div class="form-group">
                            <label class="control-label col-md-5" >Colocar c&oacute;digo de rack</label>
                            <div class="col-lg-7">
                                <input value="" autocomplete="off" data-toggle="tooltip" data-placement="bottom" title="Consulta por SKU para saber la ubicaci&oacute;n actual"  placeholder="" class="form-control rackcodigo help" type="text">
                            </div>
                        </div>
                    </div>
               </div>
            </div> 
        </div>
        <div class="row">
            <div class="col-lg-12">
                <div class="ibox">
                    <div class="ibox-content">
                    	
                    </div>
               </div>
            </div>
        </div>
    </div>
</div>


<script type="application/javascript">

$('.help').tooltip()

</script>
