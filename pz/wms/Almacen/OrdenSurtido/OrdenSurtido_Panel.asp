<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include virtual="/Includes/iqon.asp" -->
<%
// HA ID: 1 2020-OCT-06 Surtido: Creación de archivo

var urlBase = "/pz/wms/Almacen/OrdenSurtido/"
var urlBaseTemplate = "/Template/inspina/";

%>
<!-- Librerias-->
<script type="text/javascript" src="<%= urlBase %>js/OrdenSurtido.js"></script>
<script type="text/javascript">
    var urlBase = "<%= urlBase %>"

    $(document).ready(function(){   
        OrdenSurtido.ListadoPanelCargar();
    })

    setTimeout(function(){ OrdenSurtido.ListadoCargar(); }, 30000); 
    
</script>

<div id="wrapper">
    <div class="wrapper wrapper-content">
        <div class="row">
            <div class="col-sm-12">
                <div class="ibox">
                    <div class="ibox-title">
                        <h5>Ordenes de Surtido</h5>
                    </div>
                    <div class="ibox-content">
                        <div id="divOrdenSurtidoTabla">

                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
