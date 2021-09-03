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
<style type="text/css">

    .SoloConsulta{

        border-bottom-color: teal; 
        border-bottom-style: dashed;
        border-bottom-width: 1px;

    }	
		
</style>
    
    
<div class="form-horizontal" id="frmFicha">
    
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
                        &nbsp;<!--button class="btn btn-danger" id="btnBorrar" onclick="javascript:AcFBorrar();" type="button"><i class="fa fa-eraser"></i> Borrar&nbsp;</button-->&nbsp;<button class="btn btn-info" id="btnGuardar" onclick="javascript:EditarUsuPerfil();" type="button"><i class="fa fa-edit"></i> Editar&nbsp;</button>
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
    <!-- Manejo de las secciones -->
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
                <div class="hr-line-dashed"></div><!-- row&nbsp;1 - renglon -->
                <div class="form-group">
                    <div class="col-md-12">
                        <div class="row">
                            <label class="col-md-offset-0 col-md-2 control-label" id="lblUsu_Nombre">Nombre</label>
                            <div class="col-md-4">
                                <p class="SoloConsulta"><%=Parametro("Usu_Nombre","")%></p>
                            </div><label class="col-md-offset-0 col-md-2 control-label" id="lblUsu_Usuario">Usuario</label>
                            <div class="col-md-4">
                                <p class="SoloConsulta"><%=Parametro("Usu_Usuario","")%></p>
                            </div>
                        </div>
                    </div>
                </div><!-- row&nbsp;2 - renglon -->
                <div class="form-group">
                    <div class="col-md-12">
                        <div class="row">
                            <label class="col-md-offset-0 col-md-2 control-label" id="lblUsu_Password">Contrase&ntilde;a</label>
                            <div class="col-md-4">
                                <p class="SoloConsulta"><%=Parametro("Usu_Password","")%></p>
                            </div>
                        </div>
                    </div>
                </div><!-- row&nbsp;3 - renglon -->
                <div class="form-group">
                    <div class="col-md-12">
                        <div class="row">
                            <label class="col-md-offset-0 col-md-2 control-label" id="lblUsu_Descripcion">Descripci&oacute;n</label>
                            <div class="col-md-4">
                                <p class="SoloConsulta"><%=Parametro("Usu_Descripcion","")%></p>
                            </div><label class="col-md-offset-0 col-md-2 control-label" id="lblUsu_Email">Correo electr&oacute;nico</label>
                            <div class="col-md-4">
                                <p class="SoloConsulta"><%=Parametro("Usu_Email","")%></p>
                            </div>
                        </div>
                    </div>
                </div><!-- row&nbsp;4 - renglon -->
            </div>
        </div>
    
</div> 
    
   <script language="jscript" type="application/javascript">
    
    /*
        $(".btnPerfil").click(function(evento){
            //elimino el comportamiento por defecto del enlace
            //alert("Listo!!!");
            evento.preventDefault(); 
            var sDatos  = "IDUsuario="+$("#IDUsuario").val();

            //$("#dvPerfilUsu").html('<div id="espera" style="position:absolute; top:50%; left: 50%; margin-top: 200px; margin-left: -100px; height:auto; width:auto;"><img src="/images/ajax-engranes.gif">');
            $("#dvPerfilUsu").show();				
            $("#dvPerfilUsu").load("/pz/agt/Home/DatosGralesConsul.asp?" + sDatos);	  
            
        });	    
    */
       
        function EditarUsuPerfil() {
            
            var sDatos  =  "IDUsuario="+$("#IDUsuario").val();
                //console.log("IDUsuario: " + $("#IDUsuario").val());         
                $("#dvPerfilUsu").show();				
                $("#dvPerfilUsu").load("/pz/agt/Home/DatosGrales.asp?" + sDatos);	            
            
        }
    
    
    
    
</script> 
    
    
    
    
    