<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include virtual="/Includes/iqon.asp" -->
<%
// HA ID: 1 2021-FEB-15 Surtido: Creación de archivo

var cxnTipo = 0

var urlBase = "/pz/wms/"
var urlBaseTemplate = "/Template/inspina/";

var intUsu_ID = -1

var sqlUsu = "SELECT Usu_ID "
    + "FROM Seguridad_Indice "
    + "WHERE IDUnica = " + IDUsuario + " "

var rsUsu = AbreTabla(sqlUsu, 1, cxnTipo)

if( !(rsUsu.EOF) ){
    intUsu_ID = rsUsu("Usu_ID").Value
}
rsUsu.Close()

//Pruebas
intUsu_ID = 30
%>

<link href="<%= urlBaseTemplate %>css/plugins/select2/select2.min.css" rel="stylesheet">

<!-- Loading -->
<script src="<%= urlBaseTemplate %>js/loading.js"></script>

<!-- Select2 -->
<script src="<%= urlBaseTemplate %>js/plugins/select2/select2.full.min.js"></script>

<!-- Librerias-->
<script type="text/javascript" src="<%= urlBase %>Almacen/Catalogo/js/Catalogo.js"></script>
<script type="text/javascript" src="<%= urlBase %>Almacen/Ubicacion/js/Ubicacion.js"></script>

<script type="text/javascript" src="<%= urlBase %>Auditoria/AuditoriasPallet/js/AuditoriasPallet.js"></script>
<script type="text/javascript" src="<%= urlBase %>Auditoria/AuditoriasUbicacion/js/AuditoriasUbicacion.js"></script>

<script type="text/javascript">

    $(document).ready(function(){
        
        Catalogo.ComboCargar({
              Contenedor: "selAAABEstatus"
            , SEC_ID: 146
        });

        $("#selAAABEstatus").val("1");

        AuditoriasPallet.UbicacionComboCargar({
            Contenedor: "selAAABUbicacion"
            , Usu_ID: <%= intUsu_ID %>
        });

        AuditoriasPallet.ListadoCargar();

    });

    /*
    $("#selAAABEstatus").select2();
    $("#selAAABUbicacion").select2();
    */

</script>
<div id="wrapper">
    <div class="wrapper wrapper-content">    
        <div class="row">
            <div class="col-sm-12">
                <div class="ibox">
                    <div class="ibox-title">
                        <h5>Filtros de b&uacute;squeda</h5>
                        <div class="ibox-tools">
                            
                            <button class="btn btn-success btn-sm" type="button" id="btnBuscar" onClick="AuditoriasPallet.ListadoCargar()">
                                <i class="fa fa-search"></i> Buscar
                            </button>

                        </div>
                    </div>
                    <div class="ibox-content">
                        <div class="row"> 
                            <div class="col-sm-12 m-b-xs">    
                                
                                <input type="hidden" id="Usu_ID" value="<%= intUsu_ID %>">
                                
                                <div class="form-group row">

                                    <label class="col-sm-2 control-label">Estatus:</label>
                                    <div class="col-sm-4 m-b-xs">
                                        <select id="selAAABEstatus" class="form-control">

                                        </select>
                                    </div>

                                    <label class="col-sm-2 control-label">Ubicacion:</label>
                                    <div class="col-sm-4 m-b-xs">
                                        <select id="selAAABUbicacion" class="form-control">

                                        </select>
                                    </div>
                                   
                                </div>

                            </div>
                        </div>
                    </div>
                </div>
                <div>
                    <div id="divAAABListado">
                        
                    </div>
                </div>
            </div>

        </div>
    </div>
</div>
