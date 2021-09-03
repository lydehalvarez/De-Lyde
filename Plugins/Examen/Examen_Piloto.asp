<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html lang="en">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<title>prevae - Seccion Docentes</title>
<meta name="keywords" content="college, school, training" /> 
<link rel="stylesheet" href="/Template/EscuelaDemo/css/stylesDocentes.css" type="text/css" media="screen" >
<link rel="stylesheet" href="/Template/EscuelaDemo/css/styles-print.css" type="text/css" media="print" >

<!--[if lte IE 6]>
<link rel="stylesheet" href="/Template/EscuelaDemo/css/ie6.css" type="text/css" media="screen" >
<![endif]-->
{Variable:sCargaEstilos}
<script type="text/javascript" src="/js/jquery-1.4.4.min.js"></script>
{Variable:sCargaIncludesDeJavaScript}
<SCRIPT type="text/javascript">
<!--


function CambiaVentana(NoSistema,NoVentana) {
	document.frmDatos.VentanaIndex.value = NoVentana;
	document.frmDatos.TabIndex.value = -1
	document.frmDatos.SistemaActual.value = NoSistema;
	document.frmDatos.submit();	
}
	

function CambiaAccion(sAccion,sModo) { 
	document.frmDatos.Accion.value = sAccion;
	document.frmDatos.Modo.value = sModo;
	CambiaVentana({Variable:SistemaActual},{Variable:VentanaIndex});
}


  $(document).ready(function(){
	  
    $('.nav li').hover(function(){
      $(this).addClass('over');
    }, function() {
      $(this).removeClass('over');
    });
	
		{Variable:sCodigoParaELJQuery}
	
	
				
				
  });
  
//--> 
</script>
</head>
<body class="inner" >  
<form name="frmDatos" id="frmDatos" method="post" >
<div id="Escudo"><a href="javascript:CambiaVentana(100,0)"><img src="/Media/SecGral1xalapa/EscudoEscuela.png" width="90" height="86"></a></div>
<div id="headerInt">
    <div id="topBanner">
        <div id="topBannerPadding">
            <div id="NombreEscuela">
              Escuela Secundaria General No 1 <br>
              <div id="NombreEscuelaInt">Sebasti&aacute;n Lerdo de Tejada - Xalapa Veracruz</div>
            </div>
            {Variable:sTmpComodin03}
        </div>
    </div>
    <div id="banner">
        <div id="bannerPadding">
            <div id="innerIntro">
              <h1>M&oacute;dulo Demo Tareas</h1></div>    
        </div>
    </div>
</div>    
    <div id="main">{Variable:sTmpComodin05}<!--Contenido de datos --></div>
    <div id="footer">
        <div id="footerPadding">
             <div class="columnWrapperFooter group">
                    <div class="leftWrapperFooter">
                        <div class="colOneFooter">
                            <h5>Ligas Rápidas</h5>
                            <ul class="footerNav">
                                <li><a href="#">Tareas</a></li>
                                <li><a href="#">Ejemplos</a></li>
                                <li><a href="#">Calificaciones</a></li>
                                <li><a href="#">Biblioteca</a></li>
                            </ul>
                        </div><!-- closes colOneFooter -->
                        <div class="colTwoFooter">
                            <h5>Favoritos</h5>
                            <ul class="footerNav">
                                <li><a href="#">Imagenes</a></li>
                                <li><a href="#">Videos</a></li>
                                <li><a href="#">Temas</a></li>
                                <li><a href="#">Amigos</a></li>
                            </ul>
                        </div><!-- closes colTwoFooter -->
                        <div class="colThreeFooter">
                            <h5>Avisos</h5>
                            <ul class="footerNav">
                                <li><a href="#">Información</a></li>
                                <li><a href="#">Cumpleaños</a></li>
                                <li><a href="#">Comunicados</a></li>
                                <li><a href="#">Eventos</a></li>
                            </ul>
                        </div><!-- closes colThreeFooter -->
                        <div class="colFourFooter">
                            <h5>Ayuda</h5>
                            <ul class="footerNav">
                                <li><a href="#">Ayuda General</a></li>
                                <li><a href="#">Temas</a></li>
                                <li><a href="#">Preguntas Frecuentes</a></li>
                                <li><a href="#">Levantar un ticket</a></li>
                            </ul>
                        </div><!-- closes colFourFooter -->
                    </div><!-- closes leftWrapperFooter -->
                            <div class="rightWrapperFooter">
                                <div class="colFiveFooter">
                                    <p class="footerNav">&nbsp;
                                    </p>
                                    <p class="footerNav">&nbsp;</p>
                                    <p class="footerNav">Este sitio esta desarrollado en la plataforma de PREVAE </p>
                                    <p class="footerNav">Mayor informaci&oacute;n comunicarse con: <br>
                                      Lic. Juan Carlos Hern&aacute;ndez 
                                    Lendechy</p>
                              </div><!-- closes colFiveFooter -->
                            </div><!-- closes rightWrapperFooter -->
             </div><!-- closes columnWrapperFooter group -->
        </div>
    </div>



<input type="hidden" name="SistemaActual" value="{Variable:SistemaActual}">
<input type="hidden" name="VentanaIndex" value="{Variable:VentanaIndex}">
<input type="hidden" name="SiguienteVentana" value="{Variable:sSiguienteVentana}">
<input type="hidden" name="TabIndex" value="{Variable:TabIndex}">
<input type="hidden" name="Modo" value="Consulta">
<input type="hidden" name="Accion" value="Consulta">
</form>

</body>
</html>