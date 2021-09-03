<%@ Language=VBScript %>
<%Option Explicit%>
<%

DIM Prov_ID
	Prov_ID = Request.QueryString("Prov_ID")
	
DIM OC_ID
	OC_ID = Request.QueryString("OC_ID")
	
DIM Doc_ID
	Doc_ID = Request.QueryString("Doc_ID")
	
DIM Docs_ID
	Docs_ID = Request.QueryString("Docs_ID")	
	
DIM Doc_Nombre
	Doc_Nombre = Request.QueryString("Doc_Nombre")	
	
DIM sfile 
	sfile = Request.QueryString("Doc_Nombre")
	
DIM NombreArchivo
    NombreArchivo = Doc_Nombre

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
	Response.Write("ERROR|" & Prov_ID & "_" & OC_ID & "_" & Doc_ID & "_" & Docs_ID & "_" & Doc_Nombre)
Else
	For Each File In Uploader.Files.Items
		'File.SaveToDisk "C:\Factoraje\www\Media\fnd\Pagos" 
		File.SaveToDisk "C:\MoneyHolding\www\Media\mms\OrdenCompra\"
		sResultado = "OK|" & Prov_ID & "_" & OC_ID & "_" & Doc_ID & "_" & Docs_ID & "_" & Doc_Nombre
		Response.Write(sResultado)		
	Next
	
End If

%>
