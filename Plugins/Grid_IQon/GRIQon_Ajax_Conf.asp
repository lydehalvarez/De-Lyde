<!--#include file="../../Includes/iqon.asp" -->
<%
var iPaginaActual   = Parametro("PaginaActual",0)
var iTotalPaginas   = Parametro("TotalPaginas",0)
var iTotalRegistros = Parametro("TotalRegistros",0)
var iRegPorPagina   = Parametro("RegPorPagina",0)

var iRegistroActual = Parametro("Tarea",0)
var Tarea = Parametro("Tarea",0)

var sC = String.fromCharCode(34)
var sResultado = ""


		sResultado = "Cargando Grid " + Tarea



Response.Write(sResultado)

%>