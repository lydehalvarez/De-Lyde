<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include file="../../../Includes/iqon.asp" -->
	
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />	
    
    
    
<script src="/Template/inspina/js/jquery-3.1.1.min.js"></script> 

    
<div class="ibox">
    <div class="ibox-content">
        <div class="row">
            <div class="row m-t-lg">
                <div class="col-lg-12">
                    <div class="tabs-container">
                        <ul class="nav nav-tabs">
                            <!--li class="active">
                                <a data-toggle="tab" href="#tab-1"><i class="fa fa-vcard-o"></i>&nbsp;Vista general</a>
                            </li-->
                            <li class="active">
                                <a data-toggle="tab" href="#tab-2" class="btnPerfil"><i class="fa fa-user-circle"></i>&nbsp;Perfil</a>
                            </li>
                            <li class="">
                                <a data-toggle="tab" href="#tab-3" class="btnAlertas"><i class="fa fa-bullhorn"></i>&nbsp;Alertas</a>
                            </li>
                            <li class="">
                                <a data-toggle="tab" href="#tab-4" class="btnComentarios"><i class="fa fa-comments-o"></i>&nbsp;Comentarios</a>
                            </li>
                        </ul>
                        <div class="tab-content">
                            <!--div class="tab-pane active" id="tab-1">
                                <div class="panel-body">
                                    <strong>Vista general</strong>
                                    <p>
                                        A wonderful serenity has taken possession of my entire soul, like these sweet mornings of spring which I enjoy with my whole heart. I am alone, and feel the charm of existence in this spot, which was created for the bliss of souls like mine.
                                    </p>
                                    <p>
                                        I am so happy, my dear friend, so absorbed in the exquisite sense of mere tranquil existence, that I neglect my talents. I should be incapable of drawing a single stroke at the present moment; and yet I feel that I never was a greater artist than now. When.
                                    </p>
                                </div>
                            </div-->
                            <div class="tab-pane active" id="tab-2">
                                <div class="panel-body">
                                    <!--strong>Datos personales</strong-->
                                    <div id="dvPerfilUsu"></div>
                                </div>
                            </div>
                            <div class="tab-pane" id="tab-3">
                                <div class="panel-body">
                                    <strong>Alertas</strong>
                                    <p>
                                        Thousand unknown plants are noticed by me: when I hear the buzz of the little world among the stalks, and grow familiar with the countless indescribable forms of the insects and flies, then I feel the presence of the Almighty, who formed us in his own image, and the breath
                                    </p>
                                    <p>
                                        I am alone, and feel the charm of existence in this spot, which was created for the bliss of souls like mine. I am so happy, my dear friend, so absorbed in the exquisite sense of mere tranquil existence, that I neglect my talents. I should be incapable of drawing a single stroke at the present moment; and yet.
                                    </p>
                                </div>
                            </div>
                            <div class="tab-pane" id="tab-4">
                                <div class="panel-body">
                                    <strong>Comentarios</strong>
                                    <p>
                                        Thousand unknown plants are noticed by me: when I hear the buzz of the little world among the stalks, and grow familiar with the countless indescribable forms of the insects and flies, then I feel the presence of the Almighty, who formed us in his own image, and the breath
                                    </p>
                                    <p>
                                        I am alone, and feel the charm of existence in this spot, which was created for the bliss of souls like mine. I am so happy, my dear friend, so absorbed in the exquisite sense of mere tranquil existence, that I neglect my talents. I should be incapable of drawing a single stroke at the present moment; and yet.
                                    </p>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
    
<script language="jscript" type="application/javascript">
    
    
        $(".btnPerfil").click(function(evento){
            //elimino el comportamiento por defecto del enlace
            //alert("Listo!!!");
            evento.preventDefault(); 
            var sDatos  = "IDUsuario="+$("#IDUsuario").val();

            //$("#dvPerfilUsu").html('<div id="espera" style="position:absolute; top:50%; left: 50%; margin-top: 200px; margin-left: -100px; height:auto; width:auto;"><img src="/images/ajax-engranes.gif">');
            $("#dvPerfilUsu").show();				
            $("#dvPerfilUsu").load("/pz/agt/Home/DatosGralesConsul.asp?" + sDatos);	  
            
        });	    
    
    
        var sDatos  =  "IDUsuario="+$("#IDUsuario").val();
            //console.log("IDUsuario: " + $("#IDUsuario").val());         
            $("#dvPerfilUsu").show();				
            $("#dvPerfilUsu").load("/pz/agt/Home/DatosGralesConsul.asp?" + sDatos);	
            
    
    
    
    
    
</script>
    
    
    
