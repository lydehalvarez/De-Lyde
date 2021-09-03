<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<style type="text/css">
/*demo page css*/
body{ font: 62.5% "Trebuchet MS", sans-serif; margin: 50px;}

</style>
<link rel="stylesheet" type="text/css" href="/css/Escuelas/jquery-ui-1.8.11.custom.css"/>
<script type="text/javascript" src="/js/jquery-1.4.4.min.js"></script>
<script type="text/javascript" src="/js/jquery-ui-1.8.11.custom.min.js"></script>
<script type="text/javascript">
			$(function(){
				// Tabs
				$('#tabs').tabs();

			}); 
		</script>
<title>Prueba de tabs tipo Tag1</title>
</head>
<body>
<ul class="ui-tabs" id="tabs" name="tabs" >
	<li><a href="javascript:CambiaVentana(101,10)">Inicio</a></li>
	<li><a href="javascript:CambiaVentana(101,60)">Mi Aula Virtual</a>
		<ul>
			<li><a href="javascript:CambiaVentana(101,70)">Materias</a></li>
			<li><a href="javascript:CambiaVentana(101,80)">Biblioteca</a></li>
			<li><a href="javascript:CambiaVentana(101,100)">Calificaciones</a></li>
			<li><a href="javascript:CambiaVentana(101,110)">Tareas</a></li>
		</ul>
	</li>
	<li><a href="javascript:CambiaVentana(101,140)">Estadísticas</a></li>
	<li><a href="javascript:CambiaVentana(101,150)">Cuadro de Honor</a></li>
	<li><a href="javascript:CambiaVentana(101,160)">Galerías</a>
		<ul>
			<li><a href="javascript:CambiaVentana(101,170)">Galería de Profesores</a></li>
			<li><a href="javascript:CambiaVentana(101,180)">Galería de grupos</a></li>
			<li><a href="javascript:CambiaVentana(101,190)">Galería de fotografías</a></li>
			<li><a href="javascript:CambiaVentana(101,200)">Galería de videos</a></li>
		</ul>
	</li>
	<li><a href="javascript:CambiaVentana(101,210)">Mi Perfil</a>
	<ul>
		<li><a href="javascript:CambiaVentana(101,220)">Datos Generales</a></li>
	</ul>
	</li>
</ul>
<div class="ui-tabs"  id="tabs2">
			<ul>
				<li><a href="#tabs-1">First</a></li>
				<li><a href="#tabs-2">Second</a></li>
				<li><a href="#tabs-3">Third</a></li>
			</ul>
			<div id="tabs-1">Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.</div>
			<div id="tabs-2">Phasellus mattis tincidunt nibh. Cras orci urna, blandit id, pretium vel, aliquet ornare, felis. Maecenas scelerisque sem non nisl. Fusce sed lorem in enim dictum bibendum.</div>
			<div id="tabs-3">Nam dui erat, auctor a, dignissim quis, sollicitudin eu, felis. Pellentesque nisi urna, interdum eget, sagittis et, consequat vestibulum, lacus. Mauris porttitor ullamcorper augue.</div>
		</div>
</body>
</html>