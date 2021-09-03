<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include file="../../../../Includes/iqon.asp" -->
<%

  var ibIQ4Web = false
   
  var iProvID = Parametro("Prov_ID",-1) 
  var iProvUsuID = Parametro("Prov_Usu_ID",-1) 
  var iAcc = Parametro("Acc",1)

  if (ibIQ4Web) { Response.Write("<br>Prov_ID:&nbsp;"+iProvID + " | Prov_Usu_ID:" + iProvUsuID) }
   
	var sSQLProvU = "SELECT PU.Prov_ID,PU.Prov_Usu_ID,PU.Usu_Nombre,PU.Usu_Usuario,PU.Usu_Descripcion,PU.Usu_Email "
      sSQLProvU += ",PU.Usu_TipoUsuarioCG61,PU.Usu_Estatus,PU.Usu_Grupo,PU.Usu_Padre"
      sSQLProvU += ",(SELECT CAT.Cat_Nombre FROM Cat_Catalogo CAT WHERE CAT.Sec_ID = 61 AND CAT.Cat_ID = PU.Usu_TipoUsuarioCG61) AS TIPOUSU "
      sSQLProvU += ",(CASE PU.Usu_Estatus WHEN 1 THEN 'Activo' WHEN 0 THEN 'Inactivo' ELSE '' END) AS ESTATUS "
      sSQLProvU += ",ISNULL((SELECT Gru_Nombre FROM SeguridadGrupo WHERE Gru_ID = PU.Usu_Grupo), 'Sin grupo') AS GRUPO "
      sSQLProvU += ",(SELECT Usu_Nombre FROM Proveedor_Usuario PUI WHERE PUI.Prov_ID = PU.Prov_ID AND PUI.Prov_Usu_ID = PU.Usu_Padre) AS DEPENDE "   
      sSQLProvU += "FROM Proveedor_Usuario PU "
      sSQLProvU += "WHERE PU.Prov_ID = "+iProvID
      sSQLProvU += "AND PU.Prov_Usu_ID = "+iProvUsuID
   
      bHayParametros = false
      ParametroCargaDeSQL(sSQLProvU,0)

   if (ibIQ4Web) { Response.Write("<br>Consulta - sSQLProvU:&nbsp;"+sSQLProvU) }
  
   
   
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

$(document).ready(function() {
  
    MuestraMsj($("#Acc").val());
  
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

        $.post("/pz/wms/Transportista/Usuarios/UsuarioTransportistaFicha_Ajax.asp", { Tarea:3,Prov_ID:$("#Prov_ID").val(),Prov_Usu_ID:$("#Prov_Usu_ID").val() },
          function(data){
           if(data == 1){
            $("#Accion").val("Consulta");
            $("#Modo").val("Consulta");							
            $("#divEditar").hide();
            $("#divConsulta").show();
            CambiaVentana(19,826);
          }
          });    

      });	

    });

});

    function MuestraMsj(ijqAcc){

        /* 1 - Consulta, 2 - Guardar y Editar, 3 - Borrar */
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
