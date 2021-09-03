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

'DIM NombreArchivo 
   'NombreArchivo = Doc_Nombre
'Response.Write("UploadAcc&nbsp;" & Fon_ID & "_" & Con_ID & "_" & Cob_ID & "_" & CobD_ID & "_" & Doc_Nombre & "<br />")
'Response.End()

DIM sResultado
	sResultado = ""
	'Response.Write("Upload&nbsp;" & Cli_ID & Doc_ID & Doc_Nombre & "<br />")
	'Response.End()
%>
<!--#include file="upload.asp" -->
<%
'Response.Write NombreArchivo & "<br />"
'Response.End()
'**********************************************************************************************
' Create the FileUploader
Dim Uploader , File
Set Uploader = New FileUploader
' This starts the upload process
Uploader.Upload(NombreArchivo)
If Uploader.Files.Count = 0 Then
	'Response.Write "No se encontro ning&uacute;n archivo a guardar."
	Response.Write("ERROR|" & NombreArchivo & "|->|" & Ruta)
Else
	For Each File In Uploader.Files.Items
        'Response.Write(Ruta)
		File.SaveToDisk "C:\AGT\www\Media\" & Ruta
		sResultado = "OK|" & NombreCompleto
		Response.Write(sResultado)		
	Next
	
End If

%>
