<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include file="../../../../Includes/iqon.asp" -->
<%
   
  var ibIQ4Web = false

   
   
%>
<link href="/Template/inspina/css/plugins/datapicker/datepicker3.css" rel="stylesheet">  
<link href="/Template/inspina/css/plugins/select2/select2.min.css" rel="stylesheet"/>  
  
<div id="wrapper">
    <div class="row">
        <div class="col-lg-12">
                <div class="ibox float-e-margins">
                <div class="ibox-title"> 
                    <h3 class="text-navy"> <i class="fa fa-search"></i> Buscador de empleados</h3>
                    <div class="ibox-tools"></div>
                    <div class="ibox-content">
                        <div class="form-horizontal">
                            <div class="form-group">
                                <label class="col-sm-2 control-label">Nombre:</label>
                                <div class="col-sm-4">
                                    <input type="text" class="form-control" id="bEmp_NombreCompleto" name="bEmp_NombreCompleto" placeholder="Nombre Completo" value="">
                                </div>
                                <label class="col-sm-3 control-label">Fecha de nacimiento:</label>
                                <!--input type="text" class="form-control" id="Emp_FechaNacimiento" name="Emp_FechaNacimiento" value=""-->
                                <div class="col-md-3" id="dateEmp_FechaNacimiento">
                                  <div class="input-group date">
                                    <span class="input-group-addon"><i class="fa fa-calendar"></i></span> <input class="form-control" id="bEmp_FechaNacimiento" name="bEmp_FechaNacimiento" placeholder="dd/mm/yyyy" type="text" value="">
                                  </div>
                                </div>                                  
                            </div>
                            <div class="form-group">
                                <label class="col-sm-2 control-label">N&uacute;mero de empleado:</label>
                                <div class="col-sm-4">
                                    <input type="text" class="form-control" id="bEmp_NumeroEmpleado" name="bEmp_NumeroEmpleado" placeholder="Numero de empleado" value="">
                                </div>
                                <label class="col-sm-3 control-label">R.F.C.:</label>
                                <div class="col-sm-3">    
                                    <input type="text" class="form-control" id="bEmp_RFC" name="bEmp_RFC" placeholder="R.F.C." value="">
                                </div>   
                            </div>                          
                            <div class="form-group">
                                <label class="col-sm-2 control-label">CURP:</label>
                                <div class="col-sm-4">
                                    <input type="text" class="form-control" id="bEmp_CURP" name="bEmp_CURP" placeholder="CURP" value="">
                                </div>
                                <label class="col-sm-3 control-label">Estatus:</label>
                                <div class="col-sm-3">    
                                    <% 
                                        var sEventos = " class='form-control cbo2' style='width:200px'";
                                        var sCondicion = " Sec_ID = 6 ";
                                        CargaCombo("cbEmp_EstatusCG6", sEventos, "Cat_ID", "Cat_Nombre", "Cat_Catalogo", sCondicion, "Cat_Orden", -1, 0, "Todos", "Editar");
                                    %>
                                </div>   
                            </div>
                            <p></p>  
                            <div class="form-group">
                                <div class="col-sm-12">
                                    <div class="col-sm-6"></div>
                                    <div class="col-sm-2 m-b-xs" style="text-align: left;">
                                        
                                    </div>
                                    <div class="col-sm-2 m-b-xs" style="text-align: left;">
                                      <button class="btn btn-success" type="button" id="btnBuscar"><i class="fa fa-search"></i>&nbsp;&nbsp;<span class="bold">Buscar</span></button>      
                                    </div>                                   
                                    <div class="col-sm-2 m-b-xs" style="text-align: left;">
                                      <a class="btn btn btn-primary" href="javascript:NvoEmpleado(-1);"><i class="fa fa-plus"> </i>&nbsp;Nuevo&nbsp;</a>
                                    </div>        
                                </div>
                            </div>                                   
                        </div>    
                    </div>
                    <input type="hidden" name="Emp_ID" id="Emp_ID" value="-1">  
                    <div class="table-responsive" id="dvGridEmpleado"></div>           
                </div>
            </div>    
        </div>
    </div> 
</div>   
  
<script src="/Template/inspina/js/plugins/datapicker/bootstrap-datepicker.js"></script>
<script src="/Template/inspina/js/plugins/i18next/bootstrap-datepicker.es.min.js"></script>  
<script src="/Template/inspina/js/plugins/select2/select2.full.min.js"></script>  
  
<script type="text/javascript">
    
    $(document).ready(function() {
        
        $('#btnBuscar').click(function(e){
            e.preventDefault();
            //console.log("ENTRO")
            $('#dvGridEmpleado').html(loading);
            CargarGrid();
            
        });   
        
        $('.cbo2').select2();
      
        $('#bEmp_FechaNacimiento').datepicker({  
           format: 'dd/mm/yyyy'
          ,todayBtn: 'linked'
          ,language: 'es'
          ,todayHighlight: true
          ,autoclose: true
        });        

      
      
    });
      
  
    var loading = '<div class="spiner-example">'+
            '<div class="sk-spinner sk-spinner-three-bounce">'+
              '<div class="sk-bounce1"></div>'+
              '<div class="sk-bounce2"></div>'+
              '<div class="sk-bounce3"></div>'+
            '</div>'+
          '</div>'+
          '<div>Cargando informaci&oacute;n, espere un momento...</div>'      
      
    function CargarGrid() {
        
        var datos = {
              Emp_NombreCompleto:$('#bEmp_NombreCompleto').val(),
              Emp_FechaNacimiento:$('#bEmp_FechaNacimiento').val(),
              Emp_NumeroEmpleado:$('#bEmp_NumeroEmpleado').val(),
              Emp_RFC:$('#bEmp_RFC').val(),
              Emp_CURP:$('#bEmp_CURP').val(),
              Emp_EstatusCG6:$('#cbEmp_EstatusCG6').val()          
            }
         
        $('#dvGridEmpleado').hide('slow');
        $("#dvGridEmpleado").html(loading);
        $("#dvGridEmpleado").load("/pz/wms/RecursosHumanos/Empleado/Empleado_Grid.asp",datos);
        $("#dvGridEmpleado").show('slow');
        
  }      
      
  function NvoEmpleado(jqiEmpID){
    $('#Emp_ID').val(jqiEmpID);   
    CambiaSiguienteVentana();    
    
  }
  
      
</script>
  
  