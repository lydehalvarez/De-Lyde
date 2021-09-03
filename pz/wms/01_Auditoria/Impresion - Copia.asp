<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include file="../../../Includes/iqon.asp" -->
<%
   
    var Aud_ID = Parametro("Aud_ID",-1);
   
    var sCondicion = "Aud_ID = " + Aud_ID
    var Aud_FormaConteoCG143 = BuscaSoloUnDato("Aud_FormaConteoCG143","Auditorias_Ciclicas",sCondicion,1,0) 
   
   
%>
<link href="/Template/inspina/css/plugins/select2/select2.min.css" rel="stylesheet"/>    
<link href="/Template/inspina/css/animate.css" rel="stylesheet"/>
<link href="/Template/inspina/css/plugins/daterangepicker/daterangepicker-bs3.css" rel="stylesheet"/>
<!--#include file="./NuevaAuditoriaCiclica_Modal.asp" -->
<div id="wrapper">
    <!-- div class="wrapper wrapper-content"  -->    
        <div class="row">
            <div class="col-lg-12">
                <div class="ibox float-e-margins">
                    <div class="ibox-title">
                        <h5>Filtros de b&uacute;squeda</h5>
                        <div class="ibox-tools">
                        </div>
                        <div class="ibox-content">
                            <div class="col-sm-12 m-b-xs" id="ciclicAuditsFilters">    
                                <div class="row"> 
                                    <label class="col-sm-1 control-label">Tipo conteo:</label>
                                    <div class="col-sm-4 m-b-xs">
                                        <% 
                                            var sEventos = " class='input-sm form-control cbo2'  style='width:200px'";
                                            var sCondicion = " Sec_ID = 143 ";
                                            CargaCombo("cbAudType", sEventos, "Cat_ID", "Cat_Nombre", "Cat_Catalogo", sCondicion, "Cat_Orden", Aud_FormaConteoCG143, 0, "Seleccione", "Editar");
                                        %>
                                    </div>
                                    <label class="col-sm-1 control-label" id="lblPasillo">Pasillo:</label>    
                                    <div class="col-sm-4 m-b-xs">
                                        <% 
                                            var sEventos = " class='input-sm form-control cbo2'  style='width:200px'";
                                            var sCondicion = " Sec_ID = 140 ";
                                            CargaCombo("cbAudType", sEventos, "Cat_ID", "Cat_Nombre", "Cat_Catalogo", sCondicion, "Cat_Orden", -1, 0, "Todos", "Editar");
                                        %>
                                    </div>
                                    <div class="col-sm-1 m-b-xs" style="text-align: left;">  
                                        <button class="btn btn-success btn-sm" type="button" id="btnBuscar"><i class="fa fa-search"></i>&nbsp;&nbsp;<span class="bold">Buscar</span></button>
                                    </div>
                                </div>    
                                <div class="row">
                                    <label class="col-sm-1 control-label">Auditor:</label>    
                                    <div class="col-sm-4 m-b-xs">
                                        <% 
                                            var sEventos = " class='input-sm form-control cbo2'  style='width:200px'";
                                            var sCondicion = "Usu_Habilitado = 1";
                                            CargaCombo("cbAuditor", sEventos, "Usu_ID", "Usu_Nombre", "Usuario", sCondicion, "Usu_ID", -1, 0, "Todos", "Editar");
                                        %>
                                    </div>
                                    <label class="col-sm-1 control-label">Estatus:</label>
                                    <div class="col-sm-4 m-b-xs">
                                        <% 
                                            var sEventos = " class='input-sm form-control cbo2'  style='width:200px'";
                                            var sCondicion = " Sec_ID = 141 ";
                                            CargaCombo("cbEstatus", sEventos, "Cat_ID", "Cat_Nombre", "Cat_Catalogo", sCondicion, "Cat_Orden", -1, 0, "Todos", "Editar");
                                        %>
                                    </div>
                                </div>
                               
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-sm-12 m-b-xs">
                               
                            </div>
                        </div>
                        <div class="table-responsive" id="dvTablaImpresion"></div>  
                    </div>
                </div>
            </div>
        </div>
    <!-- /div  -->                  
</div>

<script src="/Template/inspina/js/plugins/slimscroll/jquery.slimscroll.min.js"></script>
<script src="/Template/inspina/js/plugins/pace/pace.min.js"></script>
<script src="/Template/inspina/js/plugins/select2/select2.full.min.js"></script>

<script type="text/javascript">
   
    $(document).ready(function() {
        
        
        $('#btnBuscar').click(function(e){
            e.preventDefault();
            //console.log("ENTRO")
            CargarGrid();
            
        });   
        
        $('.cbo2').select2();

        CargarGrid();
       
    });
    
    function CargarGrid() {
        
        
        $("#dvTablaImpresion").empty();    
        
        var datos = {
                Lpp:1,
                Aud_ID:$('#Aud_ID').val() 
            }
         
        //console.log("cargando")
        
        $("#dvTablaImpresion").load("/pz/wms/Auditoria/Impresion_Grid.asp",datos);
    }
    
</script>
