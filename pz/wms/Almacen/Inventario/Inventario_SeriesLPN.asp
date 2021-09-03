<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%> 
<!--#include file="../../../../Includes/iqon.asp" -->

<%
    var Pt_ID = Parametro("Pt_ID",-1)
    var SKU = Parametro("SKU",-1)
 

    var iReg = 1
	var sSQL = "SELECT Inv_Serie, Cat_Nombre as ESTATUS, Inv_LoteIngreso, Inv_IMEI2, Inv_RFID, Inv_MasterBox "
             + ", Convert(nvarchar(12),Lot_Fecha , 113) as FechaIngreso "
             + " FROM Inventario i, Cat_Catalogo c, Inventario_Lote il "
             + " WHERE i.Inv_EstatusCG20 = c.Cat_ID AND c.Sec_ID = 20 " 
             + " AND il.Lot_ID = i.Inv_LoteIngreso "
             + " AND i.Inv_Estatuscg20 in (1,2,3,4,10) "
			 + " AND i.inv_EnAlmacen = 1 "
             + " AND Pt_ID = " + Pt_ID
             + " Order by Inv_MasterBox " 
	
	// Response.Write(sSQL)
	var rsInv = AbreTabla(sSQL,1,0)
	var SeriesTotal = rsInv.RecordCount

	if(!rsInv.EOF){
%>

<table width="553" class="table table-striped table-bordered" id="Tbl<%=Pt_ID%>">
	<thead>
    	<tr>
       	<th colspan="6" align="left">Total: <%=SeriesTotal%></th>
        <th align="right"><button class="btn btn-danger btnOculta btn-xs" data-ptid="<%=Pt_ID%>">Ocultar series</button></th>
    	<tr>
        	<th width="50">Num</th>
        	<th width="120">Serie</th>
            <th width="120">Serie 2</th>
            <th width="120">EPC</th>
            <th width="120">Estatus</th>
            <th width="50">Masterbox</th>
            <th width="80">Fecha Ingreso</th>
            <th width="80">Lote Ingreso</th>
            
        </tr>
    </thead>
    <tbody>
<%

		while(!rsInv.EOF){ 
       
%>
	<tr>
	   	<td align="center"><%=iReg%></td>
	   	<td align="center"><%=rsInv.Fields.Item("Inv_Serie").Value%></td>
        <td align="center"><%=rsInv.Fields.Item("Inv_IMEI2").Value%></td>    
        <td align="center"><%=rsInv.Fields.Item("Inv_RFID").Value%></td>    
	   	<td align="center"><%=rsInv.Fields.Item("ESTATUS").Value%></td>
        <td align="center"><%=rsInv.Fields.Item("Inv_MasterBox").Value%></td>    
	   	<td align="center"><%=rsInv.Fields.Item("FechaIngreso").Value%></td> 
        <td align="center">LT-<%=rsInv.Fields.Item("Inv_LoteIngreso").Value%></td> 
        
    </tr>
	<%
            iReg++
            rsInv.MoveNext()
        } 
    rsInv.Close()
    if(iReg > 10){
%>
	<tr>
	  <td align="center">&nbsp;</td>
   	  <td align="center">&nbsp;</td>
	  <td align="center">&nbsp;</td>
	  <td align="center">&nbsp;</td>
	  <td align="center">&nbsp;</td>
	  <td align="center">&nbsp;</td>
	  <td align="center">&nbsp;</td>
	  <td align="center"><button class="btn btn-danger btnOculta btn-xs" data-ptid="<%=Pt_ID%>">Ocultar series</button></td>
	  </tr>

<% }
	} else {
	%>
	<tr>
    	<td colspan="7">No tiene series registradas</td>
    </tr>
	<%
	}
    %>
    </tbody>
</table>
    
<script type="application/javascript">
    

         $('.btnOculta').click(function(e) {
            e.preventDefault();
            var Pt_ID = $(this).data("ptid");
            $("#btnSerieVer_" + Pt_ID).show("slow");    
            $("#td_" + Pt_ID).hide("slow");
            $("#td_" + Pt_ID).empty();
            $("#tr_" + Pt_ID).empty().remove();

        });

</script>
