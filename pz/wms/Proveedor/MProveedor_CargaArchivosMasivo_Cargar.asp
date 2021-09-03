<%@ Language=VBScript %>
<%Option Explicit%>
<!--#include virtual="/pz/wms/Proveedor/MProveedor_CargaArchivosMasivo_Subir.asp" -->
<%

Dim strNombreArchivo
Dim Uploader

Dim fileArchivos
Dim intErrorNumero
Dim strErrorDescripcion
Dim jsonRespuesta
Dim urlBase, urlArchivo, urlTotal

Dim File

strNombreArchivo = Request.QueryString("Doc_Nombre")
fileArchivos = Request.QueryString("file")

urlBase = request.servervariables("APPL_PHYSICAL_PATH")
urlArchivo = "\Media\wms\TransportistasBase\"
urlTotal = urlBase & "\" & urlArchivo & "\"

Set Uploader = New FileUploader

'Inicia el proceso de carga'
Uploader.Upload(strNombreArchivo)
   
If Uploader.Files.Count = 0 Then
	intErrorNumero = 1
	strErrorDescripcion = "No se encontró el archivo"
Else

	For Each File In Uploader.Files.Items

		File.SaveToDisk urlTotal

		If Err.Number <> 0 Then
			intErrorNumero = 1
			strErrorDescripcion = "No se cargo el archivo"
		Else
			intErrorNumero = 0
			strErrorDescripcion = "archivo cargado"
		End If

	Next
	
End If

jsonRespuesta = "{" _
		& """Error"": {" _
			  & """Numero"": """ & intErrorNumero & """ " _
			& ", ""Descripcion"": """ & strErrorDescripcion & """ " _
		& "}" _
	& "}" 

Response.Write(jsonRespuesta)
%>
