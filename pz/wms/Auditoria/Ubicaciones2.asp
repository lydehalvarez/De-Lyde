<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252" %>
<!--#include virtual="/Includes/iqon.asp" -->
<%

var Aud_ID = Parametro("Aud_ID", -1);

var strTemplate = "/Template/inspina/"
%>

<link href="<%= strTemplate %>css/plugins/select2/select2.min.css" rel="stylesheet">
<link href="<%= strTemplate %>css/animate.css" rel="stylesheet">
<link href="<%= strTemplate %>css/plugins/daterangepicker/daterangepicker-bs3.css" rel="stylesheet">

<!-- Loading -->
<script src="<%= strTemplate %>js/loading.js"></script>
<script src="<%= strTemplate %>js/plugins/select2/select2.full.min.js"></script>
<script type="text/javascript">

    $(document).ready(function () {

        $('.select2').select2();
        Ubicacion.Buscar.ListadoCargar();

    });

    var Ubicacion = {
          url: "/pz/wms/Auditoria/"
        , Buscar: {
            ListadoCargar: function(){
                
                var intAud_ID = $("#Aud_ID").val();
                var strUbi = $("#inpUbi").val();
                var strSKU = $("#inpSKU").val();
                var strLPN = $("#inpLPN").val();
                var intEst_ID = $("#selEst").val();
                var intRes_ID = $("#selRes").val();

                $.ajax({
                      url: Ubicacion.url + "ubicaciones_grid2.asp"
                    , method: "post"
                    , async: true
                    , data: {
                          Aud_ID: intAud_ID
                        , Ubicacion: strUbi
                        , SKU: strSKU
                        , LPN: strLPN
                        , Est_ID: intEst_ID
                        , Res_ID: intRes_ID
                        , Conteo: $("#cbAudUVeces").val()
                    }
                    , beforeSend: function(){
                        Procesando.Visualizar({Contenedor: "divCar"});
                    }
                    , success: function( res ){
                        $("#divTab").html( res );
                    }
                    , error: function(){
                        Avisa("error", "Auditoria - Listado - Ubicaciones", "Error en la peticion");
                    }
                    , complete: function(){
                        Procesando.Ocultar();
                    }
                });
            }
            , FiltrosLimpiar: function(){
                $("#inpUbi").val("");
                $("#inpSKU").val("");
                $("#inpLPN").val("");
                $("#selEst").val("-1");
                $("#selRes").val("-1");

                $("#select2-selEst-container").text("Todos");
                $("#select2-selRes-container").text("Todos");
            }
        }
        , Escanear: function(event, prmObj){

            var intChr = event.which;
            var strObj = $(prmObj).val();
            var regExp = /[\']/g;

            if(intChr == 13){
                
                var strRemObj = strObj.replace(regExp, "-");
                $(prmObj).val( strRemObj );

                Ubicacion.Buscar.ListadoCargar();

            }
        }
    }

</script>


                <div class="ibox float-e-margins">
                    <div class="ibox-title">
                        <h5>Filtros de b&uacute;squeda</h5>
                        <div class="ibox-tools">
                            <button class="btn btn-white btn-sm" type="button" onclick="Ubicacion.Buscar.FiltrosLimpiar()">
                                <i class="fa fa-trash-o"></i> Limpiar
                            </button>
                            <button class="btn btn-success btn-sm" type="button" onclick="Ubicacion.Buscar.ListadoCargar()">
                                <i class="fa fa-search"></i> Buscar
                            </button>
                        </div>
                    </div>
                    <div class="ibox-content">
                        
                        <div class="row">
                            <label class="col-sm-2 control-label">SKU:</label>
                            <div class="col-sm-4 m-b-xs">
                                <input type="text" class="form-control" id="inpSKU" placeholder="SKU" autocomplete="off"
                                onkeyup="Ubicacion.Escanear(event, $(this))">
                            </div>

                            <label class="col-sm-2 control-label">Conteo:</label>
                                <div class="col-sm-4">
                                    <select name="cbAudUVeces" id="cbAudUVeces" class='input-sm form-control cbo2' style='width:200px'>
                                        <% 
                                            var sArmaCbo = ""
                                            var sCondicion = "Aud_ID = " + Aud_ID
                                            var iVisitaActual = BuscaSoloUnDato("Aud_VisitaActual","Auditorias_Ciclicas",sCondicion,1,0) 
                                            var sEventos = " class='input-sm form-control cbo2'  style='width:200px'"
                                            
                                            sArmaCbo = "<option value='-1' >Todos</option>"
                                            Response.Write(sArmaCbo)
                                           
                                          	for (x=1;x<=iVisitaActual;x++) {
                                                 sArmaCbo = "<option value='"+ x + "'"
                                                 if (iVisitaActual == x) {
                                                     sArmaCbo += " selected "
                                                 }
                                                 sArmaCbo += ">" + x + "</option>"

                                                 Response.Write(sArmaCbo)
                                            }	
                                         %>
                                    </select>
                                </div>
                            
                            
                        </div>
                        <div class="row">
                            <label class="col-sm-2 control-label">Ubicaci&oacute;n:</label>
                            <div class="col-sm-4 m-b-xs">
                                <input type="text" class="form-control" id="inpUbi" placeholder="Ubicacion" autocomplete="off"
                                onkeyup="Ubicacion.Escanear(event, $(this))">
                            </div>

                            <label class="col-sm-2 control-label">LPN:</label>
                            <div class="col-sm-4 m-b-xs">
                                <input type="text" class="form-control" id="inpLPN" placeholder="LPN" autocomplete="off"
                                onkeyup="Ubicacion.Escanear(event, $(this))">
                            </div>
                            
                        </div>
                        <div class="row">
                            <label class="col-sm-2 control-label">Estatus:</label>
                            <div class="col-sm-4 m-b-xs">
<% 
ComboSeccion("selEst","class='form-control select2'",146,-1,0,"Todos","","Editar");
%>
                            </div>

                            <label class="col-sm-2 control-label">Resultado:</label>
                            <div class="col-sm-4 m-b-xs">
<% 
ComboSeccion("selRes","class='form-control select2'",147,-1,0,"Todos","","Editar");
%>
                            </div>
                        </div>
                        <br>
                        <br>
                        <div class="row">
                            <div class="col-sm-12 m-b-xs" id="divTab">

                            </div>
                        </div>
                            
                        <div class="row">
                            <div class="col-sm-12 m-b-xs" id="divCar">

                            </div>
                        </div>
                    </div>
                </div>
            