<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include file="../../../Includes/iqon.asp" -->
<%
	
	var bDebug = false
	var Usu_ID = Parametro("IDUsuario",-1)

%>

	
<div class="row border-bottom white-bg dashboard-header" style="min-height: -webkit-fill-available;">
	<div class="col-md-8" id="dvNotificaciones" style="display:none"></div>
    <div class="col-md-8" id="dvCalendario" style="min-height:450px;">


    <div class="ibox float-e-margins">
    <div class="ibox-title" style="border-style:none !important">
      <h2>Situaci&oacute;n actual&nbsp;&nbsp;<!--small class="m-l-sm"--><!--i class="fa fa-calendar-o"></i--><!--/small--></h2>
        <div class="ibox-tools">
                <a class="collapse-link">
                        <i class="fa fa-chevron-up"></i>
                </a>
                <a class="dropdown-toggle" data-toggle="dropdown" href="#">
                        <i class="fa fa-wrench"></i>
                </a>
                <ul class="dropdown-menu dropdown-user">
                        <li><a href="#">Pro entregas</a></li>
                        <li><a href="#">Por Tiendas</a></li>
                </ul>
							<!--a class="close-link">
									<i class="fa fa-times"></i>
							</a-->
					</div>
			</div>
			<div class="ibox-content">
					<!--span class="text-muted small pull-right">&Uacute;ltima modificaci&oacute;n: <i class="fa fa-clock-o"></i> 10:10 pm - 06.06.2018</span-->
						<!--div class="ibox-content"-->
							<div id="dvEntregas"></div>
						<!--/div-->
			</div>
        </div>


    </div>
    <div class="col-md-4 white-bg " id="dvAvisos" style="min-height:450px;"></div>

</div>


<script language="javascript" type="text/javascript">

    $(document).ready(function() {

		$("#dvAvisos").load("/pz/wms/Inicio/Avisos.asp?IDUnico=" + $("#IDUsuario").val() + "&Prov_ID=" + $("#Prov_ID").val() )
	    $("#dvEntregas").load("/pz/wms/Proveedor/MProveedor_Dashboard.asp?IDUnico=" + $("#IDUsuario").val() + "&Prov_ID=" + $("#Prov_ID").val() )
    });

</script>