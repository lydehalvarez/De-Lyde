<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include file="../../../Includes/iqon.asp" -->
<%
   
  var ibIQ4Web = false
   
  var iProvID = Parametro("Prov_ID",-1) 
  var iProvUsuID = Parametro("Prov_Usu_ID",-1) 

  if (ibIQ4Web) { Response.Write("Prov_ID:&nbsp;"+iProvID + " | Prov_Usu_ID:" + iProvUsuID) }
   
	var sSQLProvU = "SELECT PU.Prov_ID,PU.Prov_Usu_ID,PU.Usu_Nombre,PU.Usu_Usuario,PU.Usu_Descripcion,PU.Usu_Email "
      sSQLProvU += ",PU.Usu_TipoUsuarioCG61,PU.Usu_Estatus,PU.Usu_Grupo,PU.Usu_Padre"
      //sSQLProvU += ",(SELECT pro.Prov_Nombre FROM Proveedor pro WHERE pro.Prov_ID = PU.Prov_ID) AS PROV "
      sSQLProvU += ",(SELECT CAT.Cat_Nombre FROM Cat_Catalogo CAT WHERE CAT.Sec_ID = 61 AND CAT.Cat_ID = PU.Usu_TipoUsuarioCG61) AS TIPOUSU "
      sSQLProvU += ",(CASE PU.Usu_Estatus WHEN 1 THEN 'Activo' WHEN 0 THEN 'Inactivo' ELSE '' END) AS ESTATUS "
      sSQLProvU += ",ISNULL((SELECT Gru_Nombre FROM SeguridadGrupo WHERE Gru_ID = PU.Usu_Grupo), 'Sin grupo') AS GRUPO "
      sSQLProvU += ",(SELECT Usu_Nombre FROM Proveedor_Usuario PUI WHERE PUI.Prov_ID = PU.Prov_ID AND PUI.Prov_Usu_ID = PU.Usu_Padre) AS DEPENDE "   
      sSQLProvU += "FROM Proveedor_Usuario PU "
      sSQLProvU += "WHERE PU.Prov_ID = "+iProvID
      sSQLProvU += " AND PU.Prov_Usu_ID = "+iProvUsuID
   
      bHayParametros = false
      ParametroCargaDeSQL(sSQLProvU,0)

   if (ibIQ4Web) { Response.Write("Consulta - sSQLProvU:&nbsp;"+sSQLProvU) }
   
   
   
%>



<div class="form-horizontal" id="frmDatosUsuario">  
 <input type="hidden" id="Prov_Usu_ID" name="Prov_Usu_ID" value="<%=iProvUsuID%>"> 
  <div id="divConsulta"></div>  <!---->
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
    <div class="ibox-content" style="padding-top: 2px; padding-bottom: 357px;">
      <div class="ibox">
        <div class="col-md-12 forum-item active">
          <div class="col-md-col-md-offset-0 forum-icon">
            <i class="fa fa-pencil-square-o"></i>
          </div><a class="forum-item-title" href="#" style="pointer-events: none">
          <h3>Informaci&oacute;n General</h3></a>
          <div class="forum-sub-title">
            Informaci&oacute;n General
          </div><!--br-->
          <div class="hr-line-dashed"></div><!-- row&nbsp;1 - renglon -->
          <div class="form-group">
            <div class="col-md-12">
              <div class="row">
                <label class="col-md-offset-0 col-md-2 control-label" id="lblUsu_Nombre">Nombre</label>
                <div class="col-md-4">
                  <input autocomplete="off" class="form-control" id="Usu_Nombre" name="Usu_Nombre" placeholder="" type="text" value="<%=Parametro("Usu_Nombre","")%>">
                </div><label class="col-md-offset-0 col-md-2 control-label" id="lblUsu_Usuario">Usuario</label>
                <div class="col-md-4">
                  <input autocomplete="off" class="form-control" id="Usu_Usuario" name="Usu_Usuario" placeholder="" type="text" value="<%=Parametro("Usu_Usuario","")%>">

                </div>
              </div>
            </div>
          </div><!-- row&nbsp;2 - renglon -->
          <div class="form-group">
            <div class="col-md-12">
              <div class="row">
                <label class="col-md-offset-0 col-md-2 control-label" id="lblUsu_Descripcion">Descripci&oacute;n</label>
                <div class="col-md-4">
                  <textarea class="form-control" id="Usu_Descripcion" name="Usu_Descripcion" placeholder="Descripci&oacute;n"><%=Parametro("Usu_Descripcion","")%></textarea>
                </div><label class="col-md-offset-0 col-md-2 control-label" id="lblUsu_Email">Correo electr&oacute;nico</label>
                <div class="col-md-4">
                  <input autocomplete="off" class="form-control" id="Usu_Email" name="Usu_Email" placeholder="Correo electr&oacute;nico" type="text" value="<%=Parametro("Usu_Email","")%>">
                </div>
              </div>
            </div>
          </div><!-- row&nbsp;3 - renglon -->
          <div class="form-group">
            <div class="col-md-12">
              <div class="row">
                <label class="col-md-offset-0 col-md-2 control-label" id="lblUsu_Grupo">Grupo</label>
                <div class="col-md-4">
                  <% var sEventos = " class='form-control cboII'"
                     var sCond = " Gru_SectorCG60 = 3"
                      CargaCombo("Usu_Grupo",sEventos,"Gru_ID","Gru_Nombre","SeguridadGrupo",sCond,"Gru_Nombre",Parametro("Usu_Grupo",-1),0,"Seleccione","Editar") 
                  %>
                </div>
                <label class="col-md-offset-0 col-md-2 control-label" id="lblUsu_TipoUsuarioCG61">Tipo de usuario</label>
                <div class="col-md-4">
                  <% var sEventos = " class='form-control cboII'"
                     var sCond = ""
                    ComboSeccion("Usu_TipoUsuarioCG61",sEventos,61,Parametro("Usu_TipoUsuarioCG61",-1),0,"Selecciona","Cat_Orden","Editar") 
                  %>                  
                </div>
              </div>
            </div>
          </div><!-- row&nbsp;4 - renglon -->
          <div class="form-group">
            <div class="col-md-12">
              <div class="row">
                <label class="col-md-offset-0 col-md-2 control-label" id="lblUsu_Estatus">Estatus</label>
                <div class="col-md-2">
                  <label class="radio-inline i-checks"></label>
                    <label class="radio-inline i-checks"> 
                      <input id="Usu_Estatus" name="Usu_Estatus" type="radio" value="1" <%if(Parametro("Usu_Estatus",1) == 1){ Response.Write("checked") }%>>
                    </label>
                  <label class="radio-inline i-checks"><i></i>&nbsp;Activo</label>
                  <label class="radio-inline i-checks"></label>
                    <label class="radio-inline i-checks">
                      <input class="" id="Usu_Estatus" name="Usu_Estatus" type="radio" value="0" <%if(Parametro("Usu_Estatus",1) == 0){ Response.Write("checked") }%>>
                    </label>
                  <label class="radio-inline i-checks"><i></i>&nbsp;Inactivo</label>
                </div>
              </div>
            </div>
          </div><!-- row&nbsp;5 - renglon -->
          <div class="form-group">
            <div class="col-md-12">
              <div class="row">
                <label class="col-md-offset-0 col-md-2 control-label" id="lblUsu_Padre">Depende de</label>
                <div class="col-md-4"> 
                  <% var sEventos = " class='form-control cboII'"
                     var sCond = " Prov_ID = " + iProvID + " AND Usu_Borrado = 0"
                     CargaCombo("Usu_Padre",sEventos,"Prov_Usu_ID","Usu_Nombre","Proveedor_Usuario",sCond,"Usu_Nombre",Parametro("Usu_Padre",-1),0,"Seleccione","Editar") 
                  %>                  
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  
  </div>
  
</div>
        
<script type="text/javascript">
  
  $(document).ready(function() {  
    
    /*$('select#Usu_Padre').select2();
    $(".cboII").select2();*/
    
    $('.i-checks').iCheck({  
      radioClass: 'iradio_square-green'  
    });
    
    
    if($("#Prov_Usu_ID").val() > -1) {
		
	  	CargaFichaConsulta(1);
		  
	  } else {
		   //hide("slow") -- show("slow")
	  	$("#divConsulta").hide();
	  	$("#divEditar").show();
		  $("#Usu_Nombre").focus();
	  
	  }

	var sImagenEspera = '<div class="loading-spinner" style="width: 200px; margin-left: 600px;">'	
		 sImagenEspera += '<div class="progress progress-striped active">'
		 sImagenEspera += '<div class="progress-bar progress-bar-danger" style="width: 100%;"></div>'
		 sImagenEspera += '</div>'
		 sImagenEspera += '</div>'    
    
    $("#btnCancelar").click(function (){
    //function AcFCancelar(regresa) {

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
        $("#Accion").val("Consulta");
        $("#Modo").val("Consulta");
        $("#divEditar").hide();
        $("#divConsulta").show();
        if($("#Prov_Usu_ID").val() > -1){
          CargaFichaConsulta(1);
        } else {
          CambiaVentana(19,1036);
        }
        
      });      

    });   

    $("#btnGuardarEdicion").click(function (){
      
      //2 = Editar; 1 = Insertar
      var iTarea = 2;
      if($("#Prov_Usu_ID").val() == -1) {
        iTarea = 1;
      }
      var iValEstatus = $("input:radio[name=Usu_Estatus]:checked").val();
      
      //console.log($("#Usu_Email").val());
      
        $.post("/pz/wms/Proveedor/UsuarioProveedorFicha_Ajax.asp",{
        Tarea:iTarea,Prov_ID:$("#Prov_ID").val(),Prov_Usu_ID:$("#Prov_Usu_ID").val(),Usu_Nombre:$("#Usu_Nombre").val(),
        Usu_Usuario:$("#Usu_Usuario").val(),Usu_Descripcion:$("#Usu_Descripcion").val(),Usu_Email:$("#Usu_Email").val(),
        Usu_Grupo:$("#Usu_Grupo").val(),Usu_TipoUsuarioCG61:$("#Usu_TipoUsuarioCG61").val(),
        Usu_Estatus:iValEstatus, Usu_Padre:$("#Usu_Padre").val(),CondBus:""
                                                                             
      },function(data){
        //alert(data);
        $("#Prov_Usu_ID").val(data);

        $("#divEditar").hide();
        $("#divConsulta").show();
        CargaFichaConsulta(2);
      });
      
    });     
    
    
  });
  
	 
    function CargaFichaConsulta(ijqAcc) {

      var sData  = "Prov_ID="+$("#Prov_ID").val()
          sData += "&Prov_Usu_ID="+$("#Prov_Usu_ID").val();
          sData += "&Acc="+ijqAcc;
          //console.log(sData);
          $("#divConsulta").load("/pz/wms/Proveedor/UsuarioProveedorFichaConsulta.asp?"+sData);	
          //$("#divEditar").hide("slow");

    }   
  
  
</script>    
  
  
  