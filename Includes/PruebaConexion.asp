<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include file="Connection.asp" -->
<% 
var iqCli_ConexionStr = ""
var bContinuar = true
 	try {	
		Response.Write("<br>================ Conexion basica =============================")
		var sConsultaSQL = "Select iqCli_ConexionStr from iqCliente where iqCli_ID = 200"
		
		var conn = Server.CreateObject("ADODB.Connection")
		conn.connectionString = sSQLCONStr02
		conn.ConnectionTimeout = 180
		conn.Open()
		var rs = Server.CreateObject("ADODB.Recordset")
		rs.ActiveConnection =  conn 
		rs.CursorType = 0
		rs.Source = sConsultaSQL
		rs.Open()
		Response.Write("<br>Conecto OK ")
		if(!rs.EOF){ 
			Response.Write("<br>Datos OK ")
			var iqCli_ConexionStr = "" + rs.Fields.Item("iqCli_ConexionStr").Value
		}
		rs.Close()
	} catch(err) {	
		bContinuar = false  
		Response.Write("<br>Error al conectar =============================================")
		Response.Write("<br>Parametro de entrada " + sConsultaSQL)
		Response.Write("<br>Error description " + err.description)
		Response.Write("<br>Error number " + err.number)
		Response.Write("<br>Error message " + err.message)

   }
	if(bContinuar) {
		try {	
			Response.Write("<br>================ Conexion Acceso =============================")
			var sConsultaSQL = "Select * from UsuarioAcceso "
			
			var conn = Server.CreateObject("ADODB.Connection")
			conn.connectionString = sSQLCONStr03
			conn.ConnectionTimeout = 180
			conn.Open()
			var rs = Server.CreateObject("ADODB.Recordset")
			rs.ActiveConnection =  conn 
			rs.CursorType = 0
			rs.Source = sConsultaSQL
			rs.Open()
			Response.Write("<br>Conecto OK ")
			if(!rs.EOF){ 
				Response.Write("<br>Datos OK ")
			}
			rs.Close()
		} catch(err) {	
			bContinuar = false  
			Response.Write("<br>Error al conectar =============================================")
			Response.Write("<br>Parametro de entrada " + sConsultaSQL)
			Response.Write("<br>Error description " + err.description)
			Response.Write("<br>Error number " + err.number)
			Response.Write("<br>Error message " + err.message)
		
		}
	}
	if(bContinuar) {
		try {	
			Response.Write("<br>================ Conexion Cliente =============================")
			var sConsultaSQL = "Select * from Usuario  "
			
			var conn = Server.CreateObject("ADODB.Connection")
			conn.connectionString = iqCli_ConexionStr
			conn.ConnectionTimeout = 180
			conn.Open()
			var rs = Server.CreateObject("ADODB.Recordset")
			rs.ActiveConnection =  conn 
			rs.CursorType = 0
			rs.Source = sConsultaSQL
			rs.Open()
			Response.Write("<br>Conecto OK ")
			if(!rs.EOF){ 
				Response.Write("<br>Datos OK ")
			}
			rs.Close()
		} catch(err) {	
			bContinuar = false  
			Response.Write("<br>Error al conectar =============================================")
			Response.Write("<br>Parametro de entrada " + sConsultaSQL)
			Response.Write("<br>Error description " + err.description)
			Response.Write("<br>Error number " + err.number)
			Response.Write("<br>Error message " + err.message)
		
		}
	}
	
	

%>
