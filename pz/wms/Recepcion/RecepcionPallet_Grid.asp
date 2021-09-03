<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include file="../../../Includes/iqon.asp" -->

<%
	var CliOC_ID = Parametro("CliOC_ID",-1)
	var Cli_ID = Parametro("Cli_ID",-1)
	var OC_ID = Parametro("OC_ID",-1)
	var Prov_ID = Parametro("Prov_ID",-1)
	var IR_ID = Parametro("IR_ID",-1)
	var CliEnt_ID = Parametro("CliEnt_ID", -1)
	var IDUsuario = Parametro("IDUsuario",-1)	
	var BPM_Pro_ID = Parametro("BPM_Pro_ID",-1)	
	var CliEnt_ID = Parametro("CliEnt_ID",-1)	
	var OV_ID = Parametro("OV_ID",-1)	
	var TA_ID = Parametro("TA_ID",-1)	



	var sSQL = "SELECT a.Pro_ID, p.Pt_ID, Pro_SKU,Pro_Nombre "
			+ " , Pt_Modelo, Pt_Color, Pt_Cantidad,Pt_LPN, Pt_LPNCliente "
			+ ", CONVERT(NVARCHAR(10),Pt_FechaRegistro,103)+' - '+CONVERT(NVARCHAR(10),Pt_FechaRegistro,108)+' hrs' FechaRegistro "
			+ ", ISNULL((SELECT Nombre FROM [dbo].[tuf_Usuario_Informacion](Pt_Usuario)),'Sin datos') Usuario "
			+ ", Cli_Nombre"
			+ ", Pt_MB,Pt_CantidadEsperada,Pt_Cantidad "
			+ ", (SELECT COUNT(*) FROM Recepcion_Series WHERE Pt_ID = p.Pt_ID) Escaneado"
			+ ", p.Pro_ID "
			+ ", p.Pt_EsCuarentena "
			+ ", p.Pt_LPNCliente "
			+ ", p.Pt_Color "
			+ ", p.Pt_PiezaXMB "			
			+ " FROM  Recepcion_Pallet p  "
			+ " INNER JOIN Producto a "
			+ "  ON a.Pro_SKU = p.Pt_SKU "
			+ " INNER JOIN Cliente c "
			+ "  ON p.Cli_ID = c.Cli_ID "
			+ " WHERE IR_ID = " + IR_ID
			//+ " AND p.CliOC_ID = " + CliOC_ID
			+ " ORDER BY Escaneado ASC "
					

	//Response.Write(sSQL)
	var Pallets = AbreTabla(sSQL,1,0)
	var Pt_ID = ""
	var Pt_LPN = ""
	var Pro_SKU = ""
	var Pro_Nombre = ""
	var FechaRegistro = ""
	var Cli_Nombre = ""
	var Usuario = ""
	var Pt_Cantidad = ""
	var Pt_MB = ""
	var Pt_PiezaXMB = ""
	var Pt_CantidadEsperada = ""
	var Escaneado = ""
	var Pro_ID = ""
	var Pt_EsCuarentena = 0
	var Pt_LPNCliente = ""
	var Pt_Color = ""
	
	var TotalPallets = 0
	var TotalPiezas = 0
	var TotalEscaneado = 0
	var TotalRestante = 0
	
	if(!Pallets.EOF){
		while(!Pallets.EOF){
			Pt_ID = Pallets.Fields.Item("Pt_ID").Value
			Pt_LPN = Pallets.Fields.Item("Pt_LPN").Value
			Pro_SKU = Pallets.Fields.Item("Pro_SKU").Value
			Pro_Nombre = Pallets.Fields.Item("Pro_Nombre").Value
			FechaRegistro = Pallets.Fields.Item("FechaRegistro").Value
			Cli_Nombre = Pallets.Fields.Item("Cli_Nombre").Value
			Usuario = Pallets.Fields.Item("Usuario").Value
			Pt_Cantidad = Pallets.Fields.Item("Pt_Cantidad").Value
			Pt_MB = Pallets.Fields.Item("Pt_MB").Value
			Pt_PiezaXMB = Pallets.Fields.Item("Pt_PiezaXMB").Value
			Pt_CantidadEsperada = Pallets.Fields.Item("Pt_CantidadEsperada").Value
			Escaneado = Pallets.Fields.Item("Escaneado").Value
			Pro_ID = Pallets.Fields.Item("Pro_ID").Value
			Pt_EsCuarentena = Pallets.Fields.Item("Pt_EsCuarentena").Value
			Pt_LPNCliente = Pallets.Fields.Item("Pt_LPNCliente").Value
			Pt_Color = Pallets.Fields.Item("Pt_Color").Value
			
			
			
			if(Pt_EsCuarentena == 1){Pt_EsCuarentena = "Si"}else{Pt_EsCuarentena = "No"}
			TotalPallets++
			TotalPiezas = TotalPiezas + Pt_Cantidad
			TotalEscaneado = TotalEscaneado + Escaneado
			
%>
        <div class="ibox-content" id="Pt_dv_<%=Pt_ID%>">
            <div class="table-responsive">
                <table class="table shoping-cart-table"> 
                    <tbody>
                        <tr>
                            <td width="90" style="vertical-align: middle;">
                                <p class="text-danger"><strong><%=Cli_Nombre%></strong></p>
                            </td>
                            <td width="40%" class="desc">
                                <h3><a class="text-navy textCopy"><%=Pt_LPN%></a></h3>
                                <h3><a class="text-navy textCopy"><%=Pro_SKU%></a></h3>
                                <h3><a class="text-navy textCopy"><%=Pro_Nombre%></a></h3>
                                <p><strong>Fecha creacion:</strong> <%=FechaRegistro%></p>
                                <p><strong>Hecho por:</strong> <%=Usuario%></p>
                                <div class="m-t-sm">
                                    <a class="text-muted" onclick='PalletFunctions.Print("<%=Pt_LPN%>")'><i class="fa fa-print"></i> Imprimir LPN</a> | <a class="text-muted" onclick="PalletFunctions.DeletePallet(<%=Pt_ID%>,'<%=Pt_LPN%>')"><i class="fa fa-trash"></i> Eliminar</a> | <a class="text-muted" onclick="PalletFunctions.EditarPallet(<%=Pt_ID%>,<%=Pro_ID%>)"><i class="fa fa-pencil"></i> Editar</a> | <a class="text-muted" onclick="PalletFunctions.EscaneoPallet(<%=Pt_ID%>)"><i class="fa fa-barcode"></i> Escanear</a>
                                    <br />
									<br />
									<a class="text-muted" onclick='PalletFunctions.PrintEtiquetas("<%=Pt_ID%>")'><i class="fa fa-print"></i> Imprimir etiquetas de masters</a>
                                </div>
                            </td>
                            <td width="25%"  class="desc">
                            	<p><strong>Cantidad Masters:</strong> <%=Pt_MB%></p>
                            	<p><strong>Piezas por Master:</strong> <%=Pt_PiezaXMB%></p>
                            	<p><strong>Cantidad piezas esperadas:</strong> <%=Pt_CantidadEsperada%></p>
                            	<p><strong>Cantidad piezas recibidas:</strong> <%=Pt_Cantidad%></p>
                            	<p><strong>Cuarentena:</strong> <%=Pt_EsCuarentena%></p>
                            	<p><strong>LPN Cliente:</strong> <%=Pt_LPNCliente%></p>
                            	<p><strong>Color:</strong> <%=Pt_Color%></p>
                            </td>
                            <td>&nbsp;</td>
                            <td><h3>Escaneado <%=Escaneado%>/<%=Pt_Cantidad%></h3></td>
                            
                        </tr>
                    </tbody>
                </table>
            </div>
        </div>
        <%	Pallets.MoveNext() 
        } 
        Pallets.Close()
		
		TotalRestante = TotalPiezas - TotalEscaneado
		%> 
    <%}else{%>
        <div class="ibox-content">
            <h3><i class="fa fa-info"></i>&nbsp;&nbsp;No hay pallets a&uacute;n, agrega uno nuevo</h3>
        </div>
	<%}%>
	<script type="application/javascript">
        $("#TotalPalets").html(<%=TotalPallets%>)
        $("#TotalPiezas").html(<%=TotalPiezas%>)
        $("#TotalEscaneadas").html(<%=TotalEscaneado%>)
        $("#TotalRestante").html(<%=TotalRestante%>)
    
    </script>  
