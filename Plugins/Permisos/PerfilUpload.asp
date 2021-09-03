<%@ Language=VBScript %>
<%Option Explicit%>
<%
DIM Usu_ID
	Usu_ID = Request.QueryString("Usu_ID")	
	
DIM Usu_NombreLogoArchivo
	Usu_NombreLogoArchivo = Request.QueryString("Usu_NombreLogoArchivo")	
		
DIM sfile 
	sfile = Request.QueryString("Usu_NombreLogoArchivo")
	'Response.Write(sfile)
DIM NombreArchivo
    NombreArchivo = sfile
	'Response.Write(sfile)
'DIM NombreArchivo
   'NombreArchivo = Usu_NombreLogoArchivo

DIM sResultado
	sResultado = ""
	'Response.Write("Upload&nbsp;" & Usu_ID & Usu_NombreLogoArchivo & "<br />")
	'Response.End()
%>
<!--#include file="Perfil_upload.asp" -->
<%
'Response.Write NombreArchivo & "<br />"
'Response.End()
'**********************************************************************************************
' Create the FileUploader
Dim Uploader , File
Set Uploader = New FileUploader
' This starts the upload process
Uploader.Upload(NombreArchivo)
'Response.Write Uploader.Files.Count & "<br />"
'If Uploader.Files.Count > 0 Then
'End if
If Uploader.Files.Count = 0 Then
	'Response.Write "No se encontro ning&uacute;n archivo a guardar."
	Response.Write("ERROR")
Else
	For Each File In Uploader.Files.Items
		
		File.SaveToDisk "C:\MoneyHolding\www\Media\mh\Perfil\PerfilImagen\" 
		sResultado = "OK"
		'sResultado = sResultado & "|" Usu_ID & "_" & sfile
		sResultado = sResultado & "|" & Usu_ID & "_" & sfile
		Response.Write(sResultado)		
	Next
	
End If

%>
