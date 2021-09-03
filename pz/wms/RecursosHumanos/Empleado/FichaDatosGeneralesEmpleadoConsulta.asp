<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include file="../../../../Includes/iqon.asp" -->
<%
   
  var ibIQ4Web = false
   
  var iEmpID = Parametro("Emp_ID",-1)
  var iAcc = Parametro("Acc",1)

  if (ibIQ4Web) { Response.Write("Emp_ID:&nbsp;"+iEmpID + " | Acc: " + iAcc) }
 
  var sSQLEmp  = "SELECT Emp_Nombre, Emp_ApellidoPaterno, Emp_ApellidoMaterno, Emp_NombreCompleto "
      sSQLEmp += ",Emp_FechaNacimiento, CONVERT(NVARCHAR(20),Emp_FechaNacimiento, 103) AS FECNAC "
      sSQLEmp += ",Emp_GeneroCG3, dbo.fn_CatGral_DameDato(3,Emp_GeneroCG3) AS GENERO "
      sSQLEmp += ",Emp_EstadoCivilCG4, dbo.fn_CatGral_DameDato(4,Emp_EstadoCivilCG4) AS EDOCIVIL "
      sSQLEmp += ",Emp_RFC, Emp_CURP, Emp_Telefono, Emp_Email, Emp_NumeroSeguroSocial "
   
      sSQLEmp += ",Emp_NumeroEmpleado, Emp_EstatusCG6, dbo.fn_CatGral_DameDato(6,Emp_EstatusCG6) AS ESTATUS "
      sSQLEmp += ",Emp_FechaIngreso, Emp_FechaSalida"
      sSQLEmp += ",Emp_SueldoMensual, CONVERT(NVARCHAR(20),Emp_FechaIngreso, 103) AS FECING "
      sSQLEmp += ",Emp_SueldoDiario, CONVERT(NVARCHAR(20),Emp_FechaSalida, 103) AS FECSAL "

      sSQLEmp += ",EMP.Com_ID, (SELECT COM.Com_Nombre FROM Compania COM WHERE COM.Com_ID = EMP.Com_ID) AS NOMCOM " 
      sSQLEmp += ",EMP.Dep_ID, (SELECT COMDEP.Dep_Nombre FROM Compania_Departamento COMDEP "
      sSQLEmp += "                     WHERE COMDEP.Com_ID = EMP.Com_ID AND COMDEP.Dep_ID = EMP.Dep_ID) AS NOMDEP "
      sSQLEmp += ",EMP.Pue_ID, (SELECT COMPTO.Pue_Nombre FROM Compania_Puesto COMPTO "
      sSQLEmp += "                     WHERE COMPTO.Com_ID = EMP.Com_ID AND COMPTO.Pue_ID = EMP.Pue_ID) AS NOMPUE "
      sSQLEmp += ",Emp_Usuario "
      sSQLEmp += ",Emp_EsOperador, CASE Emp_EsOperador WHEN 1 THEN 'S&iacute;' WHEN 0 THEN 'No' ELSE '' END AS ESOPERADOR "
   
      sSQLEmp += "FROM Empleado EMP "
      sSQLEmp += "WHERE EMP.Emp_ID = "+iEmpID
   
      bHayParametros = false
      ParametroCargaDeSQL(sSQLEmp,0)

   if (ibIQ4Web) { Response.Write("<br>Consulta - sSQLEmp:&nbsp;"+sSQLEmp) }
   
   
   
%>
<style>
.SoloConsulta{
	border-bottom-color: teal; 
	border-bottom-style: dashed;
	border-bottom-width: 1px;
}
/*
.FichaBtnArriba {
	position: fixed;
  width: 80%;
  z-index: 1000;
  top: 10px;
}
	*/
</style>
    
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
          &nbsp;<button class="btn btn-danger" id="btnBorrar" type="button"><i class="fa fa-eraser"></i> Borrar&nbsp;</button>&nbsp;<button class="btn btn-info" id="btnGuardar" type="button"><i class="fa fa-edit"></i> Editar&nbsp;</button>
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
<input type="hidden" id="Acc" name="Acc" value="<%=iAcc%>">
<div class="ibox divMsjAcc" id="divMensajeAccion" style="display:none">
	<div class="ibox-content" style="padding-bottom: 0px;">
		<div class="form-group" id="mensaje" style="padding:0px 30px 0px 30px;">
			<div class="alert alert-success alert-dismissable">
				<button aria-hidden="true" data-dismiss="alert" class="close" type="button">x</button>
                &nbsp;<i class="fa fa-check-circle"></i>&nbsp;<strong>Aviso!</strong>
				&nbsp;<span id="parrafomsjtxt"></span>
			</div>
		</div>
	</div>
</div>

<div class="ibox-content" style="padding-top: 2px; padding-bottom: 100px;">
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
              <p class="SoloConsulta">
                <%Response.Write(IFAnidado(!EsVacio(Parametro("Emp_Nombre","")),Parametro("Emp_Nombre",""),"&nbsp;"))%>
              </p>
            </div>
            <label class="col-md-offset-0 col-md-2 control-label" id="lblEmp_ApellidoPaterno">Apellido paterno</label>
            <div class="col-md-4"> 
              <p class="SoloConsulta">
                <%Response.Write(IFAnidado(!EsVacio(Parametro("Emp_ApellidoPaterno","")),Parametro("Emp_ApellidoPaterno",""),"&nbsp;"))%>
              </p>
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
              <p class="SoloConsulta">    
                <%Response.Write(IFAnidado(!EsVacio(Parametro("Emp_ApellidoMaterno","")),Parametro("Emp_ApellidoMaterno",""),"&nbsp;"))%>
              </p>
            </div><label class="col-md-offset-0 col-md-2 control-label" id="lblEmp_NombreCompleto">Nombre completo</label>
            <div class="col-md-4">
              <p class="SoloConsulta">
                <%Response.Write(IFAnidado(!EsVacio(Parametro("Emp_NombreCompleto","")),Parametro("Emp_NombreCompleto",""),"&nbsp;"))%>
              </p>
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
              <p class="SoloConsulta">
                <%Response.Write(IFAnidado(!EsVacio(Parametro("FECNAC","")),Parametro("FECNAC",""),"&nbsp;"))%>
              </p>
            </div>
            <label class="col-md-offset-0 col-md-2 control-label" id="lblEmp_GeneroCG3">G&eacute;nero</label>
            <div class="col-md-4"> 
              <p class="SoloConsulta">
                <%Response.Write(IFAnidado(!EsVacio(Parametro("GENERO","")),Parametro("GENERO",""),"&nbsp;"))%>
              </p>
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
              <p class="SoloConsulta">
                <%Response.Write(IFAnidado(!EsVacio(Parametro("EDOCIVIL","")),Parametro("EDOCIVIL",""),"&nbsp;"))%>
              </p>
            </div>
            <label class="col-md-offset-0 col-md-2 control-label" id="lblEmp_RFC">RFC</label>
            <div class="col-md-4">
              <p class="SoloConsulta">
                <%Response.Write(IFAnidado(!EsVacio(Parametro("Emp_RFC","")),Parametro("Emp_RFC",""),"&nbsp;"))%>
              </p>
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
              <p class="SoloConsulta">
                <%Response.Write(IFAnidado(!EsVacio(Parametro("Emp_CURP","")),Parametro("Emp_CURP",""),"&nbsp;"))%>
              </p>
            </div>
            <label class="col-md-offset-0 col-md-2 control-label" id="lblEmp_Telefono">Tel&eacute;fono</label>
            <div class="col-md-4">
              <p class="SoloConsulta">
                <%Response.Write(IFAnidado(!EsVacio(Parametro("Emp_Telefono","")),Parametro("Emp_Telefono",""),"&nbsp;"))%>
              </p>
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
              <p class="SoloConsulta">
                <%Response.Write(IFAnidado(!EsVacio(Parametro("Emp_Email","")),Parametro("Emp_Email",""),"&nbsp;"))%>
              </p>
            </div>
            <label class="col-md-offset-0 col-md-2 control-label" id="lblEmp_NumeroSeguroSocial">N&uacute;mero de seguro social</label>
            <div class="col-md-4">
              <p class="SoloConsulta">  
                <%Response.Write(IFAnidado(!EsVacio(Parametro("Emp_NumeroSeguroSocial","")),Parametro("Emp_NumeroSeguroSocial",""),"&nbsp;"))%>
              </p>
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
              <p class="SoloConsulta">
                <%Response.Write(IFAnidado(!EsVacio(Parametro("Emp_NumeroEmpleado","")),Parametro("Emp_NumeroEmpleado",""),"&nbsp;"))%>
              </p>  
            </div>
            <label class="col-md-offset-0 col-md-2 control-label" id="lblEmp_EstatusCG6">Estatus</label>
            <div class="col-md-4">
              <p class="SoloConsulta">
                <%Response.Write(IFAnidado(!EsVacio(Parametro("ESTATUS","")),Parametro("ESTATUS",""),"&nbsp;"))%>
              </p>  
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
              <p class="SoloConsulta">
                <%Response.Write(IFAnidado(!EsVacio(Parametro("FECING","")),Parametro("FECING",""),"&nbsp;"))%>
              </p>
            </div>
            <label class="col-md-offset-0 col-md-2 control-label" id="lblEmp_FechaSalida">Fecha de salida</label>
            <div class="col-md-4" id="dateEmp_FechaSalida">
              <p class="SoloConsulta">
                <%Response.Write(IFAnidado(!EsVacio(Parametro("FECSAL","")),Parametro("FECSAL",""),"&nbsp;"))%>
              </p>
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
              <p class="SoloConsulta">
                <%Response.Write(IFAnidado(!EsVacio(Parametro("Emp_SueldoMensual","")),FM+" "+formato(Parametro("Emp_SueldoMensual",""),2),"&nbsp;"))%>
              </p>
            </div>
            <label class="col-md-offset-0 col-md-2 control-label" id="lblEmp_SueldoDiario">Sueldo diario</label>
            <div class="col-md-4">
              <p class="SoloConsulta">
                <%Response.Write(IFAnidado(!EsVacio(Parametro("Emp_SueldoDiario","")),FM+" "+formato(Parametro("Emp_SueldoDiario",""),2),"&nbsp;"))%>
              </p>
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
              <p class="SoloConsulta">
                <%Response.Write(IFAnidado(!EsVacio(Parametro("NOMCOM","")),Parametro("NOMCOM",""),"&nbsp;"))%>
              </p>              
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
              <p class="SoloConsulta">
                <%Response.Write(IFAnidado(!EsVacio(Parametro("NOMDEP","")),Parametro("NOMDEP",""),"&nbsp;"))%>
              </p>
            </div> 
            <label class="col-md-offset-0 col-md-2 control-label" id="lblPue_ID">Puesto</label>
            <div class="col-md-4">
              <p class="SoloConsulta">
                <%Response.Write(IFAnidado(!EsVacio(Parametro("NOMPUE","")),Parametro("NOMPUE",""),"&nbsp;"))%>
              </p>
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
              <p class="SoloConsulta">
                <%Response.Write(IFAnidado(!EsVacio(Parametro("Emp_Usuario","")),Parametro("Emp_Usuario",""),"&nbsp;"))%>
              </p>
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
              <p class="SoloConsulta">
                <%Response.Write(IFAnidado(!EsVacio(Parametro("ESOPERADOR","")),Parametro("ESOPERADOR",""),"&nbsp;") + "&nbsp;")%>
                <%Response.Write(IFAnidado(!EsVacio(Parametro("ESOPERADOR","")),"<img src='/Img/Bien.png' width='16' height='16'>","<img src='Img/Mal.png' width='16' height='16'>"))%>
              </p>
            </div>
          </div>
        </div>
      </div>
    </div> 
  </div>
</div>  
  
<script language="javascript" type="text/javascript">
//hide("slow")
    $(document).ready(function() { 

        //console.log("Acc: " + $("#Acc").val());
        MuestraMsj($("#Acc").val());
        
        $("#btnGuardar").click(function (){

            $("#divConsulta").hide();
            $("#divEditar").show();
          
            var sLlave  = "&Com_ID="+$("#Com_ID").val()
                sLlave += "&Dep_ID="+$("#Dep_ID").val()
                sLlave += "&Emp_ID="+$("#Emp_ID").val()
                //console.log("sLlave: " + sLlave);
            $("#divDep_ID").load("/pz/wms/RecursosHumanos/Empleado/DatosGeneralesEmpleado_Ajax.asp?Tarea=4"+sLlave);
          
            var sLlave  = "&Com_ID="+$("#Com_ID").val()
                sLlave += "&Pue_ID="+$("#Pue_ID").val()
                sLlave += "&Emp_ID="+$("#Emp_ID").val()
                //console.log("sLlave: " + sLlave);
             $("#divPue_ID").load("/pz/wms/RecursosHumanos/Empleado/DatosGeneralesEmpleado_Ajax.asp?Tarea=5"+sLlave);
          
            //$("#ConBus").val("");
          
        });

        $("#btnBorrar").click(function (){

            swal({
                title: "Confirmaci\u00f3n requerida",
                text: "El registro ser\u00e1 borrado permanentemente \n Quiere continuar?",
                type: "warning",
                showCancelButton: true,
                cancelButtonText:"No",
                confirmButtonColor: "#1ab394",
                confirmButtonText: "S\u00ed",
                closeOnConfirm: true
            },function () {

            $.post("/pz/wms/RecursosHumanos/Empleado/DatosGeneralesEmpleado_Ajax.asp", { Tarea:3,Emp_ID:$("#Emp_ID").val() },
              function(data){
                if(data == 1){
                  $("#Accion").val("Consulta");
                  $("#Modo").val("Consulta");							
                  $("#divEditar").hide();
                  $("#divConsulta").show();
                  //$("#ConBus").val("");
                  CambiaVentana(19,12700);
                }
              });    

            });	

        });

    });

    function MuestraMsj(ijqAcc){

        /*    
        1 - Consulta, 2 - Guardar y Editar, 3 - Borrar
        */
        //console.log("Accion: " + ijqAcc);
        
        if(ijqAcc == 2){
            
            $("#divMensajeAccion").show();
            $('#parrafomsjtxt').html("El registro fu&eacute; guardado correctamente.");
           
        }
        
        if(ijqAcc == 3){
            
            $("#divMensajeAccion").show();
            $('#parrafomsjtxt').html("El registro fu&eacute; borrado correctamente.");
           
        }        
        
        //$("#ConBus").val("");
    }
        

</script>   
  
