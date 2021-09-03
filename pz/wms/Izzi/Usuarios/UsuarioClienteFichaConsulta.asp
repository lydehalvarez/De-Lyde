<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include file="../../../../Includes/iqon.asp" -->
<%

  var ibIQ4Web = false
   
  var iCliID = Parametro("Cli_ID",-1) 
  var iCliUsuID = Parametro("Cli_Usu_ID",-1) 

  if (ibIQ4Web) { Response.Write("Cli_ID:&nbsp;"+iCliID + " | Cli_Usu_ID:" + iCliUsuID) }
   
	var sSQLCliU = "SELECT PU.Cli_ID,PU.Cli_Usu_ID,PU.Usu_Nombre,PU.Usu_Usuario,PU.Usu_Descripcion,PU.Usu_Email "
        sSQLCliU += ",PU.Usu_TipoUsuarioCG61,PU.Usu_Estatus,PU.Usu_Grupo,PU.Usu_Padre"
        sSQLCliU += ",(SELECT CAT.Cat_Nombre FROM Cat_Catalogo CAT WHERE CAT.Sec_ID = 61 AND CAT.Cat_ID = PU.Usu_TipoUsuarioCG61) AS TIPOUSU "
        sSQLCliU += ",(CASE PU.Usu_Estatus WHEN 1 THEN 'Activo' WHEN 0 THEN 'Inactivo' ELSE '' END) AS ESTATUS "
        sSQLCliU += ",ISNULL((SELECT Gru_Nombre FROM SeguridadGrupo WHERE Gru_ID = PU.Usu_Grupo), 'Sin grupo') AS GRUPO "
        sSQLCliU += ",(SELECT Usu_Nombre FROM Cliente_Usuario PUI WHERE PUI.Cli_ID = PU.Cli_ID AND PUI.Cli_Usu_ID = PU.Usu_Padre) AS DEPENDE "   
        sSQLCliU += "FROM Cliente_Usuario PU "
        sSQLCliU += "WHERE PU.Cli_ID = "+iCliID
        sSQLCliU += " AND PU.Cli_Usu_ID = "+iCliUsuID
   
      bHayParametros = false
      ParametroCargaDeSQL(sSQLCliU,0)

   if (ibIQ4Web) { Response.Write("<br>Consulta - sSQLCliU:&nbsp;"+sSQLCliU) }
  
   
   
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
<!--div class="form-horizontal" id="frmFicha" name="frmFicha"-->
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
    <!-- Manejo de las secciones -->
  <div class="ibox-content" style="padding-top: 2px; padding-bottom: 357px;">
		<div class="ibox">
			<div class="col-md-12 forum-item active">
				<div class="col-md-col-md-offset-0 forum-icon">
					<i class="fa fa-pencil-square-o"></i>
				</div><a class="forum-item-title" href="#" style="pointer-events: none">
				<h3>Informaci&oacute;n General</h3></a>
				<div class="forum-sub-title">
					Informaci&oacute;n General
				</div>
				<!--br-->
				<div class="hr-line-dashed"></div><!-- row&nbsp;1 - renglon -->
				<div class="form-group">
					<div class="col-md-12">
						<div class="row">
							<label class="col-md-offset-0 col-md-2 control-label" id="lblUsu_Nombre">Nombre</label>
							<div class="col-md-4"> 
								<p class="SoloConsulta"><%Response.Write(IFAnidado(!EsVacio(Parametro("Usu_Nombre","")),Parametro("Usu_Nombre",""),"&nbsp;"))%></p>
							</div><label class="col-md-offset-0 col-md-2 control-label" id="lblUsu_Usuario">Usuario</label>
							<div class="col-md-4">
								<p class="SoloConsulta"><%Response.Write(IFAnidado(!EsVacio(Parametro("Usu_Usuario","")),Parametro("Usu_Usuario",""),"&nbsp;"))%></p>
							</div> 
						</div>
					</div>
				</div><!-- row&nbsp;2 - renglon -->
				<div class="form-group">
					<div class="col-md-12">
						<div class="row">
							<label class="col-md-offset-0 col-md-2 control-label" id="lblUsu_Descripcion">Descripci&oacute;n</label>
							<div class="col-md-4">
								<p class="SoloConsulta"><%Response.Write(IFAnidado(!EsVacio(Parametro("Usu_Descripcion","")),Parametro("Usu_Descripcion",""),"&nbsp;"))%></p>
							</div><label class="col-md-offset-0 col-md-2 control-label" id="lblUsu_Email">Correo electr&oacute;nico</label>
							<div class="col-md-4">
								<p class="SoloConsulta"><%Response.Write(IFAnidado(!EsVacio(Parametro("Usu_Email","")),Parametro("Usu_Email",""),"&nbsp;"))%></p>
							</div> 
						</div>
					</div>
				</div><!-- row&nbsp;3 - renglon -->
				<div class="form-group">
					<div class="col-md-12">
						<div class="row">
							<label class="col-md-offset-0 col-md-2 control-label" id="lblUsu_Grupo">Grupo</label>
							<div class="col-md-4">
								<p class="SoloConsulta"><%Response.Write(IFAnidado(!EsVacio(Parametro("GRUPO","")),Parametro("GRUPO",""),"&nbsp;"))%></p>
							</div>
							<label class="col-md-offset-0 col-md-2 control-label" id="lblUsu_TipoUsuarioCG61">Tipo de usuario</label>
							<div class="col-md-4">
								<p class="SoloConsulta"><%Response.Write(IFAnidado(!EsVacio(Parametro("TIPOUSU","")),Parametro("TIPOUSU",""),"&nbsp;"))%></p>
							</div>
						</div>
					</div>
				</div><!-- row&nbsp;4 - renglon -->
				<div class="form-group">
					<div class="col-md-12">
						<div class="row">
							<label class="col-md-offset-0 col-md-2 control-label" id="lblUsu_Estatus">Estatus</label>
							<div class="col-md-2">
								<p class="SoloConsulta"><%Response.Write(IFAnidado(!EsVacio(Parametro("ESTATUS","")),Parametro("ESTATUS",""),"&nbsp;"))%></p>
							</div>
						</div>
					</div>
				</div><!-- row&nbsp;5 - renglon -->
				<div class="form-group">
					<div class="col-md-12">
						<div class="row">
							<label class="col-md-offset-0 col-md-2 control-label" id="lblUsu_Padre">Depende de</label>
							<div class="col-md-4">
								<p class="SoloConsulta"><%Response.Write(IFAnidado(!EsVacio(Parametro("DEPENDE","")),Parametro("DEPENDE",""),"&nbsp;"))%></p>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>    
<!--/div-->

  
  
<script language="javascript" type="text/javascript">
//hide("slow")
	$("#btnGuardar").click(function (){
		$("#divConsulta").hide();
		$("#divEditar").show();
	
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
    
    $.post("/pz/wms/Izzi/Usuarios/UsuarioClienteFicha_Ajax.asp", { Tarea:3,Cli_ID:$("#Cli_ID").val(),Cli_Usu_ID:$("#Cli_Usu_ID").val() },
      function(data){
       if(data == 1){
        $("#Accion").val("Consulta");
        $("#Modo").val("Consulta");							
        $("#divEditar").hide();
        $("#divConsulta").show();
        CambiaVentana(29,1500);
      }
      });    
      
	});	
	
});



</script>     
