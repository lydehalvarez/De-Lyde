<%@ Language=VBScript %>
<%Option Explicit%>
<%

DIM llaves
	llaves = Request.QueryString("llaves")	
	
DIM Ruta
	Ruta = Request.QueryString("Ruta")		
	
DIM NombreArchivo
    NombreArchivo = Request.QueryString("NombreArchivo")	
	
DIM NombreCompleto
    NombreCompleto = llaves & "_" & NombreArchivo

DIM sResultado
	sResultado = ""

%>
<!--#include file="upload.asp" -->
<%
'Response.Write NombreArchivo & "<br />"
'**********************************************************************************************
' Create the FileUploader
Dim Uploader , File
Set Uploader = New FileUploader
' This starts the upload process
Uploader.Upload(NombreArchivo)
'Response.Write "Count " & Uploader.Files.Count & "<br>"
If Uploader.Files.Count = 0 Then
	'Response.Write "No se encontro ning&uacute;n archivo a guardar."
	Response.Write("ERROR|" & NombreArchivo & "|->|" & Ruta)
Else
	For Each File In Uploader.Files.Items
        'Response.Write(Ruta)  C:\AGT\www\Media\agt\Cliente\
		File.SaveToDisk "C:\AURA\www\Media\aura\" & Ruta & "\"
		sResultado = "OK|" & NombreCompleto
		Response.Write(sResultado)		
	Next
	
End If

%>
