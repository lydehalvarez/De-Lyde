<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%> 
<!--#include virtual="/Includes/iqon.asp" -->

<%
    var Aud_ID = Parametro("Aud_ID", -1);
    var Pro_SKU = Parametro("SKU", "");
    var Ubi_Nombre = Parametro("Ubicacion", "");
    var Pt_LPN = Parametro("LPN", "");
    var Est_ID = Parametro("Est_ID", -1);
    var Res_ID = Parametro("Res_ID", -1);  
    var Conteo = Parametro("Conteo", -1); 

    var EsCiego = BuscaSoloUnDato("ISNULL(Aud_EsCiego,1)","Auditorias_Ciclicas","Aud_ID = " + Aud_ID ,1,0) 

//var sqlAud = "SELECT ROW_NUMBER() OVER (ORDER BY PT.Pt_ID ASC ) AS ID "
//        + ",pt.Pt_ID "
//        + ", Pro.Pro_SKU "
//        + ", Pro.Pro_Nombre "
//        + ", Pro.Pro_ID "
//        + ", Pro_Descripcion " 
//        + ", pt.Pt_LPN "
//        + ", PT.PT_Cantidad_Actual "
//        + ", Ubi.Ubi_Nombre "
//        + ", CONVERT(NVARCHAR(12),Pt_FechaIngreso,103) as FECHAINGRESO "
//        + ", Lot.Lot_Folio "
//        + ", Are.Are_Nombre "
//        + ", ISNULL(Ubi.Ubi_Etiqueta, '') AS Ubi_Etiqueta "
//        + ", Est.Cat_Nombre as Estatus "
//        + ", Res.Cat_Nombre as Resultado " 
//        + ", pt.Aud_ID "
//        + ", Usu.Usu_Nombre as Auditor "
//    + "FROM Auditorias_Pallet PT "
//        + "LEFT JOIN Auditorias_Ciclicas ac "
//            + "ON ac.Aud_ID = PT.Aud_ID "
//		+ "LEFT JOIN Producto Pro "
//            + "ON PT.Pro_ID = Pro.Pro_ID "
//        + "LEFT JOIN Ubicacion Ubi "
//            + "ON PT.Ubi_ID = Ubi.Ubi_ID "
//        + "LEFT JOIN Ubicacion_Area Are "
//            + "ON Ubi.Are_ID = Are.Are_ID "
//        + "LEFT JOIN Inventario_Lote Lot "
//            + "ON PT.Lot_ID = Lot.Lot_ID "
//        + "LEFT JOIN Auditorias_Ubicacion aub "
//            + "ON pt.Aud_ID = aub.Aud_ID "
//            + "AND pt.Pt_ID = aub.Pt_ID "
//            + "AND ac.Aud_VisitaActual = aub.AudU_Veces "
//        + "LEFT JOIN Usuario Usu "
//            + "ON aub.AudU_AsignadoA = Usu.Usu_ID "
//        + "LEFT JOIN Cat_Catalogo Est "
//            + "ON PT.Pt_EstatusCG146 = Est.Cat_ID "
//            + "AND Est.SEC_ID = 146 "
//        + "LEFT JOIN Cat_Catalogo Res "
//            + "ON pt.Pt_ResultadoCG147 = Res.Cat_ID "
//            + "AND Res.SEC_ID = 147 "
//    + "WHERE aub.AudU_ID = 1 "
//        + "AND pt.Aud_ID = " + Aud_ID 


 var sqlAud = "SELECT ROW_NUMBER() OVER (ORDER BY PT.Pt_ID ASC ) AS ID ,pt.Pt_ID , Pro.Pro_SKU , Pro.Pro_Nombre "
            + " , Pro.Pro_ID , Pro_Descripcion , pt.Pt_LPN , PT.PT_Cantidad_Actual , Ubi.Ubi_Nombre "
            + " , CONVERT(NVARCHAR(12),Pt_FechaIngreso,103) as FECHAINGRESO "
            + " , Are.Are_Nombre ,pt.Pt_VisitaActual "
            + " , ISNULL(Ubi.Ubi_Etiqueta, '') AS Ubi_Etiqueta , Est.Cat_Nombre as Estatus , Res.Cat_Nombre as Resultado , pt.Aud_ID  "
            + " ,ISNULL((select top 1 dbo.fn_Usuario_DameNombreUsuario(aub1.AudU_AsignadoA)  "
                       + " from Auditorias_Ubicacion aub1  "
                      + " where aub1.Aud_ID = pt.Aud_ID and aub1.Pt_ID = pt.PT_ID and aub1.AudU_ConteoInterno = 1),'')  as AuditorInt " 
            + " ,ISNULL((select top 1 dbo.fn_Usuario_DameNombreUsuario(aub1.AudU_AsignadoA)  "
                       + " from Auditorias_Ubicacion aub1  "
                      + " where aub1.Aud_ID = pt.Aud_ID and aub1.Pt_ID = pt.PT_ID and aub1.AudU_ConteoInterno = 0),'')  as AuditorExt  "
            + " FROM Auditorias_Pallet PT  "
            + " LEFT JOIN Auditorias_Ciclicas   ac ON ac.Aud_ID = PT.Aud_ID  "
            + " LEFT JOIN Producto             Pro ON PT.Pro_ID = Pro.Pro_ID  "
            + " LEFT JOIN Ubicacion            Ubi ON PT.Ubi_ID = Ubi.Ubi_ID  "
            + " LEFT JOIN Ubicacion_Area       Are ON Ubi.Are_ID = Are.Are_ID  "
            + " LEFT JOIN Cat_Catalogo         Est ON PT.Pt_EstatusCG146 = Est.Cat_ID AND Est.SEC_ID = 146  "
            + " LEFT JOIN Cat_Catalogo         Res ON pt.Pt_ResultadoCG147 = Res.Cat_ID AND Res.SEC_ID = 147  "
            + " WHERE ac.Aud_ID = " + Aud_ID


    if(Conteo > -1) {
        sqlAud += " AND pt.Pt_VisitaActual = " + Conteo
    }
    if(Pro_SKU != "") {
        sqlAud += " AND Pro_SKU LIKE '%" + Pro_SKU + "%' ";
    }
    if(Ubi_Nombre != "") {
        sqlAud += " AND Ubi.Ubi_Nombre LIKE '%" + Ubi_Nombre + "%' ";
    }
    if(Pt_LPN != "") {
        sqlAud += " AND pt.Pt_LPN LIKE '%" + Pt_LPN + "%' ";
    }
    if( Est_ID > -1) {
        sqlAud += " AND pt.Pt_EstatusCG146 = " + Est_ID  
    }
    if( Res_ID > -1) {
        sqlAud += " AND pt.Pt_ResultadoCG147 = " + Res_ID  
    }
%>

<table class="table table-striped table-bordered">
	<thead>
    	<tr>
            <th>#</th>
        	<th>Producto</th>
        	<th>LPN</th>
        	<% if(EsCiego == 0) { %> <th>Cantidad</th>  <% } %>
        	<th>Auditor</th>
        	<th>Estatus</th>
        	<th>Resultado</th>
        </tr>
    </thead>
    <tbody>
<%    

//Response.Write(sqlAud)
// Response.End()

var rsAud = AbreTabla(sqlAud, 1, 0)

if(!rsAud.EOF) {
	var TotalPallet = 0
	var Pallet_Cantidad = 0
    while(!rsAud.EOF){ 
%>
        <tr>
            <td><%= rsAud("ID").Value %></td>
            <td>
                <a>
                    <i class="fa fa-tag"></i> <span class="textCopy"><%= rsAud("Pro_SKU").Value %></span>
                </a>
                <br>
                <small title="<%= rsAud("Pro_ID").Value %>">
                    <%= rsAud("Pro_Nombre").Value %>    
                </small>
            </td>
            <td>
                <a>
                    <i class="fa fa-inbox"></i> <span class="textCopy"><%= rsAud("Pt_LPN").Value %></span>
                </a>
                <br>
                <small>
                    <i class="fa fa-map"></i> <span class="textCopy"><%=rsAud("Ubi_Nombre").Value%></span>
                    <br>
                    <i class="fa fa-list"></i> <%= rsAud("Are_Nombre").Value %> <%= ( rsAud("Ubi_Etiqueta").Value != "" ) ? "(" + rsAud("Ubi_Etiqueta").Value + ")" : "" %>
                    <i class="fa fa-eye"></i> Conteo: <%= rsAud("Pt_VisitaActual").Value %>
                </small>
            </td>
        <% if(EsCiego == 0) {
			Pallet_Cantidad = rsAud("PT_Cantidad_Actual").Value
			TotalPallet = TotalPallet + Pallet_Cantidad
			 %> 
            <td align="center">
                <%= formato(Pallet_Cantidad, 0) %>
            </td>
        <% } %>                     
            <td><%  Response.Write(rsAud("AuditorInt").Value)
                    if(rsAud("AuditorExt").Value != "") {
                        Response.Write("<br>" + rsAud("AuditorExt").Value)
                        
                    }
                %></td>
            <td><%= rsAud("Estatus").Value %></td>
            <td><%= rsAud("Resultado").Value %></td>
    </tr>
<%
        Response.Flush()
        rsAud.MoveNext()
    } %>
        <tr>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
        <% if(EsCiego == 0) { %> 
            <td>Total</td>
            <td align="center">
                <%= formato(TotalPallet, 0) %>
            </td>
        <% }else{ %>  
            <td>&nbsp;</td>
        <% } %>                     
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
    </tr>
    

<%} else {
%>
        <tr>
            <td colspan="10">No tiene ubicaciones registradas</td>
        </tr>
<%
}
rsAud.Close()
%>
    </tbody>
</table>