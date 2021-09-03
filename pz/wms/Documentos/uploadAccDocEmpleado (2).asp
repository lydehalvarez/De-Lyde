<%@ Language=VBScript %>
<%Option Explicit%>
<%

DIM Emp_ID
	Emp_ID = Request.QueryString("Emp_ID")
	
DIM Doc_ID
	Doc_ID = Request.QueryString("Doc_ID")
	
DIM Docs_ID
	Docs_ID = Request.QueryString("Docs_ID")
	
DIM Doc_Nombre
	Doc_Nombre = Request.QueryString("Doc_Nombre")	
	'Response.Write Doc_Nombre & "<br />"	
	
DIM sfile 
	sfile = Request.QueryString("Doc_Nombre")
	'Response.Write sfile & "<br />"
	
DIM NombreArchivo
    NombreArchivo = sfile
	'Response.Write(sfile)
'DIM NombreArchivo 
   'NombreArchivo = Doc_Nombre
'Response.Write("UploadAcc&nbsp;" & Emp_ID & Docs_ID & Doc_Nombre & NombreArchivo & "<br />")
'Response.End()

DIM sResultado
	sResultado = ""
	'Response.Write("Upload&nbsp;" & Emp_ID & Doc_ID & Doc_Nombre & "<br />")
	'Response.End()
%>
<!--#include file="uploadEmpleado.asp" -->
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
	Response.Write("ERROR")
Else
	For Each File In Uploader.Files.Items    
		File.SaveToDisk "C:\AGT\www\Media\agt\Empleado\"  
		sResultado = "OK|" & Emp_ID & "_" & Doc_ID & "_" & Docs_ID & "_" & sfile
		Response.Write(sResultado)		
	Next
	
End If

%>
