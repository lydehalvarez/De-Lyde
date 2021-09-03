<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include file="../../../../Includes/iqon.asp" -->

<style>

.dimension-fields{
    display: flex;
/*  border: 1px solid #b0c0d6;*/
}
.dimension-fields .dimension-input {
    flex-basis: 33%;
}
.dimension-fields .dimension-seperator {
    padding: 8px 7px;
    color: #ccc;
    background-color: #fff;
    font-size: 12px;
}
.required {
    color: #b94a48;
}
.required:after {
    content: "*";
    color: #b94a48;
}
.Espacio {
    margin-top: 35px;
    margin-bottom: 35px;
}
.ColorTitulo{
	color: #1ab394;
	/*color: #14c5b5;	*/
}
</style>

<div class="form-horizontal">
    <div class="row">
        <div class="col-lg-8">
            <div class="ibox float-e-margins">
                <div class="ibox-content">
<!-------------------Cliente---------------------------------------------------->        
                    <div class="form-group">
                        <legend class="control-label col-md-3 ColorTitulo">Cliente&nbsp;&nbsp;<i class="fa fa-user"></i></legend>
                    </div>
                    <div class="form-group">
                        <label class="control-label col-md-3 required">SKU Cliente</label>
                        <div class="col-lg-8">
                            <input placeholder="SKU Cliente"  value="" autocomplete="off" class="form-control" type="text">
                        </div>
                    </div>
                </div>
                <div class="ibox-content">
<!-------------------Porveedor---------------------------------------------------->        
                    <div class="form-group">
                        <legend class="control-label col-md-3 ColorTitulo">Proveedor&nbsp;&nbsp;<i class="fa fa-user"></i></legend>
                    </div>
                    <div class="form-group">
                        <label class="control-label col-md-3 required">SKU Proveedor</label>
                        <div class="col-lg-8">
                            <input placeholder="SKU Proveedor"  value="" autocomplete="off" class="form-control" type="text">
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>



<script type="application/javascript">

$(document).ready(function(){
	
});

</script>
