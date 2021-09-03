<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%> 
<!--#include file="../../../../Includes/iqon.asp" -->

<link href="/Template/inspina/css/plugins/iCheck/green.css" rel="stylesheet">

<div class="form-horizontal">
    <div class="row">
        <div class="col-lg-12">
            <div class="ibox float-e-margins">
                <div class="ibox-content">
                    <label><input type="checkbox" class="checkbox" value="1">&nbsp;Ejemplo 1</label><br>
                    <label><input type="checkbox" class="checkbox" value="1">&nbsp;Ejemplo 2</label><br>
                    <label><input type="checkbox" class="checkbox" value="1">&nbsp;Ejemplo 3</label><br>
                    <label><input type="checkbox" class="checkbox" value="1">&nbsp;Ejemplo 4</label><br>
                    <label><input type="checkbox" class="checkbox" value="1">&nbsp;Ejemplo 5</label><br>
                    <label><input type="checkbox" class="checkbox" value="1">&nbsp;Ejemplo 6</label><br>
                    <label><input type="checkbox" class="checkbox" value="1">&nbsp;Ejemplo 7</label><br>
                    <label><input type="checkbox" class="checkbox" value="1">&nbsp;Ejemplo 8</label><br>
                </div>
            </div>
        </div>
    </div>
</div>

<script src="/Template/inspina/js/plugins/iCheck/icheck.min.js"></script>

<script type="application/javascript">

	$(document).ready(function(){
	
		$('.checkbox').iCheck({  checkboxClass: 'icheckbox_square-green' }); 
					   
	}); 
	
</script>