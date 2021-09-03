<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include file="../../../../Includes/iqon.asp" -->
<%
   
  var ibIQ4Web = false
   
  var iEmpID = Parametro("Emp_ID",-1) 

  if (ibIQ4Web) { Response.Write("Emp_ID:&nbsp;"+iEmpID) }
 
  var sSQLEmp  = "SELECT Emp_Nombre, Emp_ApellidoPaterno, Emp_ApellidoMaterno, Emp_NombreCompleto "
      sSQLEmp += ",Emp_FechaNacimiento, CONVERT(NVARCHAR(20),Emp_FechaNacimiento, 103) AS FECNAC "
      sSQLEmp += ",Emp_GeneroCG3, dbo.fn_CatGral_DameDato(3,Emp_GeneroCG3) AS GENERO "
      sSQLEmp += ",Emp_EstadoCivilCG4, dbo.fn_CatGral_DameDato(3,Emp_GeneroCG3) AS EDOCIVIL "
      sSQLEmp += ",Emp_RFC, Emp_CURP, Emp_Telefono, Emp_Email, Emp_NumeroSeguroSocial "
   
      sSQLEmp += ",Emp_NumeroEmpleado, Emp_EstatusCG6 "
      sSQLEmp += ",Emp_FechaIngreso, CONVERT(NVARCHAR(20),Emp_FechaIngreso, 103) AS FECING "
      sSQLEmp += ",Emp_FechaSalida, CONVERT(NVARCHAR(20),Emp_FechaSalida, 103) AS FECSAL "
      sSQLEmp += ",Emp_SueldoMensual, Emp_SueldoDiario "

      sSQLEmp += ",Com_ID, Dep_ID, Pue_ID, Emp_Usuario, Emp_EsOperador "
   
      sSQLEmp += "FROM Empleado EMP "
      sSQLEmp += "WHERE EMP.Emp_ID = "+iEmpID
   
     
   
      bHayParametros = false
      ParametroCargaDeSQL(sSQLEmp,0)

   if (ibIQ4Web) { Response.Write("<br>Consulta - sSQLEmp:&nbsp;"+sSQLEmp) }
   
   
   
%>
<link href="/Template/inspina/css/plugins/datapicker/datepicker3.css" rel="stylesheet">
<link href="/Template/inspina/css/plugins/select2/select2.min.css" rel="stylesheet">
  
<div class="form-horizontal" id="frmDatosUsuario">  
  
  <div id="divConsulta"></div>  
  <div id="divEditar" style="display:none">
      
    <div class="ibox">
      <div class="ibox-content" style="padding-top: 2px; padding-bottom: 31px;">
        <div class="row">
          <div class="col-md-12">
            <div class="col-md-3" id="areafunciones">
              &nbsp;
            </div>
          </div>
        </div>
        <div class="row">
          <div class="col-md-12 CntBtn">
            <div class="col-md-offset-6 col-md-5" id="areabotones" style="text-align: right;padding-right:50px;">
              <button class="btn btn-danger" id="btnCancelar" type="button"><i class="fa fa-reply"></i> Cancelar&nbsp;</button>&nbsp; <button class="btn btn-success" id="btnGuardarEdicion" name="btnGuardarEdicion" type="button"><i class="fa fa-save"></i> Guardar&nbsp;</button>
            </div>
          </div>
        </div>
        <div class="row">
          <div class="col-md-12">
            <div id="areanotificaciones">
              &nbsp;
            </div>
          </div>
        </div>
      </div>
    </div>
    <!-- Manejo de las secciones -->
    <div class="ibox-content" style="padding-top: 2px; padding-bottom: 380px;">
      <div class="ibox">
        <div class="col-md-12 forum-item active">
          <div class="col-md-col-md-offset-0 forum-icon">
            <i class="fa fa fa-user-circle-o"></i>
          </div><a class="forum-item-title" href="#" style="pointer-events: none">
          <h3>
            Datos personales
          </h3></a>
          <div class="forum-sub-title">
            Datos personales
          </div><!--br-->
          <div class="hr-line-dashed"></div>
          <!-- row&nbsp;1 - renglon -->
          <div class="form-group">
            <div class="col-md-12">
              <div class="row">
                <label class="col-md-offset-0 col-md-2 control-label" id="lblEmp_Nombre">Nombre</label>
                <div class="col-md-4"> 
                  <input autocomplete="off" class="form-control cssKeyPress" id="Emp_Nombre" name="Emp_Nombre" placeholder="Nombre" type="text" value="<%=Parametro("Emp_Nombre","")%>">
                </div>
                <label class="col-md-offset-0 col-md-2 control-label" id="lblEmp_ApellidoPaterno">Apellido paterno</label>
                <div class="col-md-4">
                  <input autocomplete="off" class="form-control cssKeyPress" id="Emp_ApellidoPaterno" name="Emp_ApellidoPaterno" placeholder="Apellido paterno" type="text" value="<%=Parametro("Emp_ApellidoPaterno","")%>">
                </div>
              </div>
            </div>
          </div>
          <!-- row&nbsp;2 - renglon -->
          <div class="form-group">
            <div class="col-md-12">
              <div class="row">
                <label class="col-md-offset-0 col-md-2 control-label" id="lblEmp_ApellidoMaterno">Apellido materno</label>
                <div class="col-md-4">
                  <input autocomplete="off" class="form-control cssKeyPress" id="Emp_ApellidoMaterno" name="Emp_ApellidoMaterno" placeholder="Apellido materno" type="text" value="<%=Parametro("Emp_ApellidoMaterno","")%>">
                </div><label class="col-md-offset-0 col-md-2 control-label" id="lblEmp_NombreCompleto">Nombre completo</label>
                <div class="col-md-4">
                  <input autocomplete="off" class="form-control" id="Emp_NombreCompleto" name="Emp_NombreCompleto" placeholder="Nombre completo" readonly type="text" value="<%=Parametro("Emp_NombreCompleto","")%>">
                </div>
              </div>
            </div>
          </div>
          <!-- row&nbsp;3 - renglon -->
          <div class="form-group">
            <div class="col-md-12">
              <div class="row">
                <label class="col-md-offset-0 col-md-2 control-label" id="lblEmp_FechaNacimiento">Fecha de nacimiento</label>
                <div class="col-md-4" id="dateEmp_FechaNacimiento">
                  <div class="input-group date">
                    <span class="input-group-addon"><i class="fa fa-calendar"></i></span> 
                    <input class="form-control" id="Emp_FechaNacimiento" name="Emp_FechaNacimiento" placeholder="dd/mm/yyyy" type="text" value="<%=Parametro("FECNAC","")%>">
                  </div>
                </div>
                <label class="col-md-offset-0 col-md-2 control-label" id="lblEmp_GeneroCG3">G&eacute;nero</label>
                <div class="col-md-4"> 
                  <% var sEventos = " class='form-control cboSelect' style='width: 100%'"
                     var sCond = ""
                     ComboSeccion("Emp_GeneroCG3",sEventos,3,Parametro("Emp_GeneroCG3",-1),0,"Selecciona","Cat_Orden","Editar") 
                  %>
                </div>
              </div>
            </div>
          </div>
          <!-- row&nbsp;4 - renglon -->
          <div class="form-group">
            <div class="col-md-12">
              <div class="row">
                <label class="col-md-offset-0 col-md-2 control-label" id="lblEmp_EstadoCivilCG4">Estado civil</label>
                <div class="col-md-4">
                  <% var sEventos = " class='form-control cboSelect' style='width: 100%'"
                     var sCond = ""
                     ComboSeccion("Emp_EstadoCivilCG4",sEventos,4,Parametro("Emp_EstadoCivilCG4",-1),0,"Selecciona","Cat_Orden","Editar") 
                  %>
                </div>
                <label class="col-md-offset-0 col-md-2 control-label" id="lblEmp_RFC">RFC</label>
                <div class="col-md-4">
                  <input autocomplete="off" class="form-control" id="Emp_RFC" name="Emp_RFC" placeholder="RFC" type="text" value="<%=Parametro("Emp_RFC","")%>">
                </div>
              </div>
            </div>
          </div>
          <!-- row&nbsp;5 - renglon -->
          <div class="form-group">
            <div class="col-md-12">
              <div class="row">
                <label class="col-md-offset-0 col-md-2 control-label" id="lblEmp_CURP">CURP</label>
                <div class="col-md-4">
                  <input autocomplete="off" class="form-control" id="Emp_CURP" name="Emp_CURP" placeholder="CURP" type="text" value="<%=Parametro("Emp_CURP","")%>">
                </div>
                <label class="col-md-offset-0 col-md-2 control-label" id="lblEmp_Telefono">Tel&eacute;fono</label>
                <div class="col-md-4">
                  <input autocomplete="off" class="form-control" id="Emp_Telefono" name="Emp_Telefono" placeholder="Tel&eacute;fono" type="text" value="<%=Parametro("Emp_Telefono","")%>">
                </div>
              </div>
            </div>
          </div>
          <!-- row&nbsp;6 - renglon -->
          <div class="form-group">
            <div class="col-md-12">
              <div class="row">
                <label class="col-md-offset-0 col-md-2 control-label" id="lblEmp_Email">Email</label>
                <div class="col-md-4">
                  <input autocomplete="off" class="form-control" id="Emp_Email" name="Emp_Email" placeholder="Email" type="text" value="<%=Parametro("Emp_Email","")%>">
                </div>
                <label class="col-md-offset-0 col-md-2 control-label" id="lblEmp_NumeroSeguroSocial">N&uacute;mero de seguro social</label>
                <div class="col-md-4">
                  <input autocomplete="off" class="form-control" id="Emp_NumeroSeguroSocial" name="Emp_NumeroSeguroSocial" placeholder="N&uacute;mero de seguro social" type="text" value="<%=Parametro("Emp_NumeroSeguroSocial","")%>">
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
    <div class="ibox-content" style="padding-top: 2px; padding-bottom: 234px;">
      <div class="ibox">
        <div class="col-md-12 forum-item active">
          <div class="col-md-col-md-offset-0 forum-icon">
            <i class="fa fa-edit"></i>
          </div><a class="forum-item-title" href="#" style="pointer-events: none">
          <h3>
            Datos generales
          </h3></a>
          <div class="forum-sub-title">
            Datos generales
          </div><!--br-->
          <div class="hr-line-dashed"></div>
          <!-- row&nbsp;1 - renglon -->
          <div class="form-group">
            <div class="col-md-12">
              <div class="row">
                <label class="col-md-offset-0 col-md-2 control-label" id="lblEmp_NumeroEmpleado">N&uacute;mero de empleado</label>
                <div class="col-md-4">
                  <input autocomplete="off" class="form-control" id="Emp_NumeroEmpleado" name="Emp_NumeroEmpleado" placeholder="N&uacute;mero de empleado" type="text" value="<%=Parametro("Emp_NumeroEmpleado","")%>">
                </div>
                <label class="col-md-offset-0 col-md-2 control-label" id="lblEmp_EstatusCG6">Estatus</label>
                <div class="col-md-4">
                <% var sEventos = " class='form-control' style='width: 100%'"
                   var sCond = ""
                   ComboSeccion("Emp_EstatusCG6",sEventos,6,Parametro("Emp_EstatusCG6",1),0,"Selecciona","Cat_Orden","Editar") 
                %>
                </div>
              </div>
            </div>
          </div>
          <!-- row&nbsp;2 - renglon -->
          <div class="form-group">
            <div class="col-md-12">
              <div class="row">
                <label class="col-md-offset-0 col-md-2 control-label" id="lblEmp_FechaIngreso">Fecha de ingreso</label>
                <div class="col-md-4" id="dateEmp_FechaIngreso">
                  <div class="input-group date">
                    <span class="input-group-addon"><i class="fa fa-calendar"></i></span> <input class="form-control" id="Emp_FechaIngreso" name="Emp_FechaIngreso" placeholder="dd/mm/yyyy" type="text" value="<%=Parametro("FECING","")%>">
                  </div>
                </div>
                <label class="col-md-offset-0 col-md-2 control-label" id="lblEmp_FechaSalida">Fecha de salida</label>
                <div class="col-md-4" id="dateEmp_FechaSalida">
                  <div class="input-group date">
                    <span class="input-group-addon"><i class="fa fa-calendar"></i></span> <input class="form-control" id="Emp_FechaSalida" name="Emp_FechaSalida" placeholder="dd/mm/yyyy" type="text" value="<%=Parametro("FECSAL","")%>">
                  </div>
                </div> 
              </div>
            </div>
          </div>
          <!-- row&nbsp;3 - renglon -->
          <div class="form-group">
            <div class="col-md-12">
              <div class="row">
                <label class="col-md-offset-0 col-md-2 control-label" id="lblEmp_SueldoMensual">Sueldo mensual</label>
                <div class="col-md-4">
                  <input autocomplete="off" class="form-control" id="Emp_SueldoMensual" name="Emp_SueldoMensual" placeholder="" type="text" value="<%=Parametro("Emp_SueldoMensual","")%>">
                </div>
                <label class="col-md-offset-0 col-md-2 control-label" id="lblEmp_SueldoDiario">Sueldo diario</label>
                <div class="col-md-4">
                  <input autocomplete="off" class="form-control" id="Emp_SueldoDiario" name="Emp_SueldoDiario" placeholder="" type="text" value="<%=Parametro("Emp_SueldoDiario","")%>">
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
    <div class="ibox-content" style="padding-top: 2px; padding-bottom: 287px;">
      <div class="ibox">
        <div class="col-md-12 forum-item active">
          <div class="col-md-col-md-offset-0 forum-icon">
            <i class="fa fa-sliders"></i>
          </div><a class="forum-item-title" href="#" style="pointer-events: none">
          <h3>
            Datos de control
          </h3></a>
          <div class="forum-sub-title">
            Datos de control
          </div><!--br-->
          <div class="hr-line-dashed"></div>
          <!-- row&nbsp;1 - renglon -->
          <div class="form-group">
            <div class="col-md-12">
              <div class="row">
                <label class="col-md-offset-0 col-md-2 control-label" id="lblCom_ID">Compa&ntilde;&iacute;a</label>
                <div class="col-md-4">
                  <% var sEventos = " class='form-control cboSelect' style='width: 100%'"
                     var sCond = ""
                     CargaCombo("Com_ID",sEventos,"Com_ID","Com_Nombre","Compania",sCond,"Com_Nombre",Parametro("Com_ID",-1),0,"Seleccione","Editar") 
                  %>                
                </div>
              </div>
            </div>
          </div>
          <!-- row&nbsp;2 - renglon -->
          <div class="form-group">
            <div class="col-md-12">
              <div class="row">
                <label class="col-md-offset-0 col-md-2 control-label" id="lblDep_ID">Departamento</label>
                <div class="col-md-4">
                  <div id="divDep_ID"></div>
                </div> 
                <label class="col-md-offset-0 col-md-2 control-label" id="lblPue_ID">Puesto</label>
                <div class="col-md-4">
                  <div id="divPue_ID"></div>
                </div> 
              </div>
            </div>
          </div>
          <!-- row&nbsp;3 - renglon -->
          <div class="form-group">
            <div class="col-md-12">
              <div class="row">
                <label class="col-md-offset-0 col-md-2 control-label" id="lblEmp_Usuario">Usuario</label>
                <div class="col-md-4">
                  <input autocomplete="off" class="form-control" id="Emp_Usuario" name="Emp_Usuario" placeholder="Usuario" type="text" value="<%=Parametro("Emp_Usuario","")%>">
                </div>
              </div>
            </div>
          </div>
          <!-- row&nbsp;4 - renglon -->
          <div class="form-group">
            <div class="col-md-12">
              <div class="row">
                <label class="col-md-offset-0 col-md-2 control-label" id="lblEmp_EsOperador">Es operador</label>
                <div class="col-md-4">
                  <label class="lblcheckbox-inline i-checks"></label>
                    <input class="checkbox-inline i-checks" id="Emp_EsOperador" name="Emp_EsOperador" type="checkbox" value="1" <%if (Parametro("Emp_EsOperador",0) == 1 ) { Response.Write("checked") } %>>
                </div>
              </div>
            </div>
          </div>
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

    /* 1 - Consulta 2 - Guardar y Editar 3 - Borrar */  
    
    $("select.cboSelect").select2();
    
    
    $('#Emp_FechaNacimiento,#Emp_FechaIngreso,#Emp_FechaSalida').datepicker({  
       format: 'dd/mm/yyyy'
      ,todayBtn: 'linked'
      ,language: 'es'
      ,todayHighlight: true
      ,autoclose: true
    });    

    $('.i-checks').iCheck({
      checkboxClass: 'icheckbox_square-green',
      radioClass: 'iradio_square-green'  
    });
    
    if($("#Emp_ID").val() > -1) {
		
	  	CargaFichaConsulta(1);
		  
	  } if($("#Emp_ID").val() == -1 || $("#Emp_ID").val() == "") {
		  //hide("slow") -- show("slow")
      $("#divConsulta").hide();
      $("#divEditar").show();
      $("#Emp_Nombre").focus();

	  }

	var sImagenEspera = '<div class="loading-spinner" style="width: 200px; margin-left: 600px;">'	
        sImagenEspera += '<div class="progress progress-striped active">'
        sImagenEspera += '<div class="progress-bar progress-bar-danger" style="width: 100%;"></div>'
        sImagenEspera += '</div>'
        sImagenEspera += '</div>'    
    
    $("#btnCancelar").click(function (){
    //function AcFCancelar(regresa) {
      //alert("Cancelar!!");
      swal({
        title: "Confirmaci\u00f3n requerida",
        text: "El registro No ser\u00e1 Guardado y los cambios hechos se perderan. Quiere continuar?",
        type: "warning",
        showCancelButton: true,
        cancelButtonText:"Cancelar",
        confirmButtonColor: "#1ab394",
        confirmButtonText: "Aceptar",
        closeOnConfirm: true
      }, function () {
        $("#areafunciones").html(sImagenEspera);
        $("#areabotones").html("");
        $("#ConBus").val("");
        $("#Accion").val("Consulta");
        $("#Modo").val("Consulta");
        $("#divEditar").hide();
        $("#divConsulta").show();
        //alert("regresmos al grid!! || Emp_ID: " + $("#Emp_ID").val());
        //console.log("#Emp_ID: " + $("#Emp_ID").val());
        if($("#Emp_ID").val() > -1){
          CargaFichaConsulta(1);
        } if($("#Emp_ID").val() == -1 || $("#Emp_ID").val() == "") {
          //$("#ConBus").val("");
          CambiaVentana(19,12700);
        }
        
      });      

    });   

    $("#btnGuardarEdicion").click(function (){
      
      //2 = Editar; 1 = Insertar
      var iTarea = 2;
      if($("#Emp_ID").val() == -1 || $("#Emp_ID").val() == "") {
        iTarea = 1;
      }
      
      var iValEsOperador = $("input:checkbox[name=Emp_EsOperador]:checked").val();
        //alert("Emp_ID: " + $("#Emp_ID").val());
        $.post("/pz/wms/RecursosHumanos/Empleado/DatosGeneralesEmpleado_Ajax.asp",{
          Tarea:iTarea,Emp_ID:$("#Emp_ID").val(),Emp_Nombre:$("#Emp_Nombre").val(),Emp_ApellidoPaterno:$("#Emp_ApellidoPaterno").val(),
          Emp_ApellidoMaterno:$("#Emp_ApellidoMaterno").val(),Emp_NombreCompleto:$("#Emp_NombreCompleto").val(),
          Emp_FechaNacimiento:$("#Emp_FechaNacimiento").val(),Emp_GeneroCG3:$("#Emp_GeneroCG3").val(),
          Emp_EstadoCivilCG4:$("#Emp_EstadoCivilCG4").val(),Emp_RFC:$("#Emp_RFC").val(),Emp_CURP:$("#Emp_CURP").val(),
          Emp_Telefono:$("#Emp_Telefono").val(),Emp_Email:$("#Emp_Email").val(),Emp_NumeroSeguroSocial:$("#Emp_NumeroSeguroSocial").val(),
          Emp_NumeroEmpleado:$("#Emp_NumeroEmpleado").val(),Emp_EstatusCG6:$("#Emp_EstatusCG6").val(),Emp_FechaIngreso:$("#Emp_FechaIngreso").val(),
          Emp_FechaSalida:$("#Emp_FechaSalida").val(),Emp_SueldoMensual:$("#Emp_SueldoMensual").val(),Emp_SueldoDiario:$("#Emp_SueldoDiario").val(),
          Com_ID:$("#Com_ID").val(),Dep_ID:$("#Dep_ID").val(),Pue_ID:$("#Pue_ID").val(),Emp_Usuario:$("#Emp_Usuario").val(),
          Emp_EsOperador:iValEsOperador, 
          ConBus:''
                                                                             
      },function(data){
        
        $("#Emp_ID").val(data);

        $("#divEditar").hide();
        $("#divConsulta").show();
        $("#dvNotificador").html("Información de: " + $("#Emp_NombreCompleto").val());
        //$("#ConBus").val("");  
        CargaFichaConsulta(2);
          
      });

    });     

    
    $("#Com_ID").change(function(){
      //alert($('select[id=Com_ID]').val());
      $('#Com_ID').val($(this).val());

      var sLlave  = "&Com_ID="+$("#Com_ID").val()
          sLlave += "&Dep_ID="+$("#Dep_ID").val()
      
      $("#divDep_ID").load("/pz/wms/RecursosHumanos/Empleado/DatosGeneralesEmpleado_Ajax.asp?Tarea=4"+sLlave);

      var sLlave  = "&Com_ID="+$("#Com_ID").val()
          sLlave += "&Pue_ID="+$("#Pue_ID").val()
      
       $("#divPue_ID").load("/pz/wms/RecursosHumanos/Empleado/DatosGeneralesEmpleado_Ajax.asp?Tarea=5"+sLlave);       
      
   });    


  
  
});
  
	 
  function CargaFichaConsulta(ijqAcc) {

    var sData  = "Emp_ID="+$("#Emp_ID").val();
        sData += "&Acc="+ijqAcc;
        sData += "&ConBus=''";
        //console.log(sData);
      $("#divConsulta").load("/pz/wms/RecursosHumanos/Empleado/FichaDatosGeneralesEmpleadoConsulta.asp?"+sData);	


  }  
  
    
  
  
  
</script>    
  
  
  
  
  
