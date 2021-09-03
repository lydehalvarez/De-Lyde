<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include virtual="/Includes/iqon.asp" -->
<%
// HA ID: 1 2020-OCT-06 Surtido: Creación de archivo

var urlBase = "/pz/wms/Almacen/"
var urlBaseTemplate = "/Template/inspina/"
%>
<!-- Loading -->
<script src="<%= urlBaseTemplate %>js/loading.js"></script>

<script type="text/javascript">
    $(document).ready(function(){           
        OrdenMovimiento.ListadoPanelCargar();
    })

    var OrdenMovimiento = {
          url: "/pz/wms/Almacen/OrdenMovimiento/"
        , ListadoPanelCargar: function(){

            Cargando.Iniciar();

            $.ajax({
                url: this.url + "OrdenMovimiento_PanelListado.asp"
                , method: "post"
                , async: true
                , data: {
                    Tarea: 1000
                }  
                , success: function(res){
                    $("#divIOMPanelListado").html(res);
                    Cargando.Finalizar();
                }
                , error: function(){
                    Avisa("error", "Orden Movimiento - Panel", "No se puede cargar el Listado")
                    Cargando.Finalizar();
                }
            })
        }
    }
    
</script>

<div id="wrapper">
    <div class="wrapper wrapper-content">
        <div class="row">
            <div class="col-sm-12">
                <div id="divIOMPanelListado">

                </div>
            </div>
        </div>
    </div>
</div>

