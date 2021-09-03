<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include file="../../../Includes/iqon.asp" -->
    
<%    
    
    var bIQon4Web = false

    var iUsu_ID = Parametro("IDUsuario",-1)
        
	var sSQLUsu = " SELECT U.Usu_ID, U.Usu_Nombre, U.Usu_Usuario, U.Usu_Password, U.Usu_Descripcion, U.Usu_Email "
		sSQLUsu += " FROM Usuario U "
		sSQLUsu += " WHERE U.Usu_ID = dbo.fn_Usuario_DameIDUsuarioConIDUnico(" + iUsu_ID + ")"		
		
		if(bIQon4Web) { Response.Write(sSQLUsu) }
	
	ParametroCargaDeSQL(sSQLUsu,0)
	
	//var sExisteFoto = Parametro("FacUsu_FotoPerfil","")    
    
   
   
    
%>
 
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<div class="form-horizontal" id="frmFicha" name="frmFicha">
    <div class="ibox">
        
            <div class="row">
                <div class="col-md-12">
                    <div class="col-md-3" id="areafunciones">
                        &nbsp;
                    </div>
                </div>
            </div>
            <div class="row">
                <div class="col-md-12">
                    <div class="col-md-offset-6 col-md-5" id="areabotones" style="text-align: right;padding-right:50px;">
                        <button class="btn btn-danger" id="btnCancelar" onclick="javascript:CancelarUsuPerfil();" type="button"><i class="fa fa-reply"></i> Cancelar&nbsp;</button>&nbsp; <button class="btn btn-success" id="btnGuardar" onclick="javascript:GuardarUsuPerfil();" type="button"><i class="fa fa-save"></i> Guardar&nbsp;</button>
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
    
    
    <div class="ibox">
        <div class="col-md-12 forum-item active">
            <div class="col-md-col-md-offset-0 forum-icon">
                <i class="fa fa-user-circle"></i>
            </div><a class="forum-item-title" href="#" style="pointer-events: none">
            <h3>
                Informaci&oacute;n de la cuenta
            </h3></a>
            <div class="forum-sub-title">
                Informaci&oacute;n de la cuenta
            </div><!--br-->
            <div class="hr-line-dashed"></div>
            <!-- row&nbsp;1 - renglon -->
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
            </div>
            <!-- row&nbsp;2 - renglon -->
            <div class="form-group">
                <div class="col-md-12">
                    <div class="row">
                        <label class="col-md-offset-0 col-md-2 control-label" id="lblUsu_Password">Contrase&ntilde;a</label>
                        <div class="col-md-4">
                            <input autocomplete="off" class="form-control" id="Usu_Password" name="Usu_Password" placeholder="" type="text" value="<%=Parametro("Usu_Password","")%>">
                        </div>
                    </div>
                </div>
            </div>
            <!-- row&nbsp;3 - renglon -->
            <div class="form-group">
                <div class="col-md-12">
                    <div class="row">
                        <label class="col-md-offset-0 col-md-2 control-label" id="lblUsu_Descripcion">Descripci&oacute;n</label>
                        <div class="col-md-4">
                            <textarea class="form-control" id="Usu_Descripcion" name="Usu_Descripcion" placeholder=""><%=Parametro("Usu_Descripcion","")%></textarea>
                        </div><label class="col-md-offset-0 col-md-2 control-label" id="lblUsu_Email">Correo electr&oacute;nico</label>
                        <div class="col-md-4">
                            <input autocomplete="off" class="form-control" id="Usu_Email" name="Usu_Email" placeholder="" type="text" value="<%=Parametro("Usu_Email","")%>">
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
    
<script language="jscript" type="application/javascript">

    
var sImagenEspera = '<div class="loading-spinner" style="width: 400px; margin-left: 600px;">'	
	sImagenEspera += '<div class="progress progress-striped active">'
		sImagenEspera += '<div class="progress-bar progress-bar-danger" style="width: 100%;"></div>'
	sImagenEspera += '</div>'
	sImagenEspera += '</div>'    
    
    
    function CancelarUsuPerfil() {

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
            $("#dvPerfilUsu").show();				
            $("#dvPerfilUsu").load("/pz/agt/Home/DatosGralesConsul.asp?" + sDatos);
            
                /*
            if($("#Usu_ID").val() == -1 && regresa > 0) {
                CambiaTab(regresa);	
            } else {
                $('#frmDatos').submit();
            }
                */
        });	

    }    
    
    function GuardarUsuPerfil() {
        
		
			$.post("/pz/agt/Home/DatosGrales_Ajax.asp", { Tarea:1,Usu_ID:$("#IDUsuario").val(),Usu_Nombre:encodeURIComponent($("#Usu_Nombre").val()),Usu_Usuario:encodeURIComponent($("#Usu_Usuario").val()),Usu_Password:encodeURIComponent($("#Usu_Password").val()),Usu_Descripcion:encodeURIComponent($("#Usu_Descripcion").val()),Usu_Email:encodeURIComponent($("#Usu_Email").val())
                                                                                // tbl:Obj.data('tbl'),Campo:Obj.attr('id'),Ente:Obj.data('ente'),Valor:Obj.attr('value'),Valor:sValor,EsFecha:iEsFecha 
                                                                              },
				function(data) {
					
                    var sDatos  =  "IDUsuario="+$("#IDUsuario").val();
                    //console.log("IDUsuario: " + $("#IDUsuario").val());         
                    $("#dvPerfilUsu").show();				
                    $("#dvPerfilUsu").load("/pz/agt/Home/DatosGralesConsul.asp?" + sDatos);
				
				});      
        
        
        
        
        
    }
    
    
    
    
</script>   
    