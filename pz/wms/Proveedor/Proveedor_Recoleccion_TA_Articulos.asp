<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include virtual="/Includes/iqon.asp" -->
<%
// HA ID: 1 2020-NOV-03 Recoleccion: Recoleccion de Articulos de Transferencia

var cxnTipo = 0

var urlBase = "/pz/wms/"
var urlBaseTemplate = "/Template/inspina/";

var rqIntTA_ID = Parametro("TA_ID", -1)
%>

    <link href="<%= urlBaseTemplate %>css/bootstrap.min.css" rel="stylesheet">
    <link href="<%= urlBaseTemplate %>font-awesome/css/font-awesome.css" rel="stylesheet">
    <link href="<%= urlBaseTemplate %>css/plugins/dropzone/basic.css" rel="stylesheet">
    <link href="<%= urlBaseTemplate %>css/plugins/dropzone/dropzone.css" rel="stylesheet">
    <link href="<%= urlBaseTemplate %>css/plugins/jasny/jasny-bootstrap.min.css" rel="stylesheet">
    <link href="<%= urlBaseTemplate %>css/style.css" rel="stylesheet">

    <script src="<%= urlBaseTemplate %>js/jquery-3.1.1.min.js"></script>
    <script src="<%= urlBaseTemplate %>js/bootstrap.min.js"></script>
    <script src="<%= urlBaseTemplate %>js/inspinia.js"></script>
    <!-- DROPZONE -->
    <script src="<%= urlBaseTemplate %>js/plugins/dropzone/dropzone.js"></script>

<script type="text/javascript">

    var Recoleccion = {
          url: "/pz/wms/Proveedor/"
        , Solicitar: function(){
            var bolError = false;
            var arrError = [];

            var arrInv_IDs = [];
            var strInv_IDs = "";

            $(".cssInv_ID:checked").each(function(){
                arrInv_IDs.push($(this).val());
            });

            var intTA_ID = $("#hidRcoTA_ID").val()
            var strComentario = $("#txaRcoComentario").val().trim();
            var intIDUsuario = $("#IDUsuario").val();

            if( intTA_ID == ""){
                arrError.push("- IDentificador de Transferencia no permitido");
                bolError = true;
            }

            if( arrInv_IDs.length == 0 ){
                arrError.push("- Seleccionar al menos un articulo a recolectar");
                bolError = true;
            } else {
                strInv_IDs = arrInv_IDs.join(",");
            }

            if( bolError ){
                Avisa("warning","Recoleccion de Articulos","Verificar Formulario<br>"+arrError.join("<br>"));
            } else {

                

                $.ajax({
                    url: Recoleccion.url + "Proveedor_Recoleccion_ajax.asp"
                    , method: "post"
                    , async: true
                    , dataType: "json"
                    , data: {
                          Tarea: 3000
                        , IDUsuario: intIDUsuario
                        , Rco_Comentario: strComentario
                        , Inv_IDs: arrInv_IDs
                    }
                    , success: function( res ){
                        if( res.Error.Numero == 0){
                            Avisa("success", "Recoleccion de Articulos", res.Error.Descripcion);
                        } else {
                            Avisa("warning", "Recoleccion de Articulos", res.Error.Descripcion);
                        }
                    }
                    , error: function(){
                        Avisa("error", "Recoleccion de Articulos", "No se puede ejecutar el proceso de Recoleccion");
                    }
                })
            }

        } 
        , ArticuloSeleccionar: function(){
            var jsonPrm = ( !(arguments[0] == undefined) ) ? arguments[0] : {};
            var intPro_ID = ( !(jsonPrm.Pro_ID == undefined) ) ? jsonPrm.Pro_ID : -1;
            var intInv_ID = ( !(jsonPrm.Inv_ID == undefined) ) ? jsonPrm.Inv_ID : -1;

            var bolProductoChecked = $(".cssPro_ID_" + intPro_ID + ":checked").length == $(".cssPro_ID_" + intPro_ID + "").length;
            $("#chbPro_ID_" + intPro_ID).prop("checked", bolProductoChecked);

            var bolTodosChecked =  $(".cssTodos:checked").length == $(".cssTodos").length;
            $("#chbTodos").prop("checked", bolTodosChecked);     
            
        }
        
        , ProductoSeleccionar: function(){
            var jsonPrm = ( !(arguments[0] == undefined) ) ? arguments[0] : {};
            var intPro_ID = ( !(jsonPrm.Pro_ID == undefined) ) ? jsonPrm.Pro_ID : -1;

            var bolProductoChecked = $("#chbPro_ID_" + intPro_ID).is(":checked");
            $(".cssPro_ID_" + intPro_ID).prop("checked", bolProductoChecked);

            var bolTodosChecked =  $(".cssTodos:checked").length == $(".cssTodos").length;
            $("#chbTodos").prop("checked", bolTodosChecked);

        }
        , TodosSeleccionar: function(){
            var bolTodosChecked = $("#chbTodos").is(":checked");

            $(".cssTodos").prop("checked", bolTodosChecked);
        }
    }
    

</script>

<div class="ibox">
    <div class="ibox-title">
        <h4> Articulos a Recolectar</h4>
        <div class="ibox-tools">
            <button type="button" class="btn btn-succcess btn-sm" onclick="Recoleccion.Solicitar()">
                <i class="fa fa-hand-paper-o"></i> Solictar Recolecci&oacute;n
            </button>
        </div>
    </div>
    <div class="ibpx-content sk-loading">

        <input type="hidden" id="hidRcoTA_ID" value="<%= rqIntTA_ID %>">

        <div class="row">
            <label class="col-sm-2 control-label">
                Comentario
            </label>
            <div class="col-sm-8">
                <textarea id="txaRcoComentario" placeholder="Comentario" class="form-control"
                 ></textarea>
            </div>
        </div>

        <div class="row">
<%
    var sqlRec = "EXEC SPR_Recoleccion "
          + "@Opcion = 1000 "
        + ", @TA_ID = " + rqIntTA_ID + " "

    var rsRec = AbreTabla(sqlRec, 1, cxnTipo)

%>
            <div class="ibox">
                <div class="ibox-title">
                    <h4>Articulos</h4>
                    <div class="ibox-tools">
                        <label class="full-right control-label">
                            Seleccionados <span id="spanSeleccionados"> </span>
                        </label>
                    </div>
                </div>

                <div class="ibox-content">
                    <div class="row">
                        <div class="col-sm-12">
                            <table class="table table-hover">
                                <thead>
                                    <tr>
                                        <th>
                                            <input type="checkbox" id="chbTodos" onclick="Recoleccion.TodosSeleccionar()">
                                        </th>
                                        <th>&nbsp;</th>
                                        <th>Articulo</th>
                                    </tr>
                                </thead>
                                <tbody>
<%
    var intPro_ID = -1;
    var i = 0;

    while( !(rsRec.EOF) ){
        
        if( intPro_ID != rsRec("Pro_ID").Value ){
%>
                                    <tr>
                                        <td>
                                            <input type="checkbox" id="chbPro_ID_<%= rsRec("Pro_ID").Value %>" class="cssTodos"
                                            onclick='Recoleccion.ProductoSeleccionar({Pro_ID: <%= rsRec("Pro_ID").Value %>})'>
                                        </td>
                                        <td colspan="2" class="project-title">
                                            <a>
                                                <%= rsRec("Pro_SKU").Value %>
                                            </a>
                                            <br>
                                            <small>
                                                <%= rsRec("Pro_Nombre") %>
                                            </small>
                                        </td>
                                        <td>
                                    </tr>
<%
            i = 0
        }
%>
                                    <tr>
                                        <td><%= ++i %><td>
                                        <td>
                                            <input type="checkbox" id="Inv_ID_<%= rsRec("Inv_ID").Value %>" class="cssTodos cssPro_ID_<%= rsRec("Pro_ID").Value %> cssInv_ID" value="<%= rsRec("Inv_ID").Value %>"
                                            onclick='Recoleccion.ArticuloSeleccionar({Pro_ID: <%= rsRec("Pro_ID").Value %>, Inv_ID: <%= rsRec("Inv_ID").Value %>})'>
                                        </td>
                                        <td>
                                            <%= rsRec("Tas_Serie").Value %>
                                        </td>
                                    </tr>
<%
        intPro_ID = rsRec("Pro_ID").Value

        rsRec.MoveNext()
    }
%>
                                </tbody>
                            </table>
<%
    rsRec.Close()
%>
                        </div>
                    </div>
                </div>
            </div>
        </div>

    </div>
</div>
