<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%> 
<!--#include file="../../../Includes/iqon.asp" -->
<%
	//HA ID: 2	2020-JUN-09 Agregado de impresion: Se agregan Botones para imprimir
    //HA ID: 3  2020-SEP-07 Agregado de Boton de Liberacion de Recepcion

   	var Serie = Parametro("Serie","")
 
    Serie = Serie.replace(" ","+")
   
	var sSQL  = "SELECT Inv_ID, i.Pro_ID "
			  + " FROM Inventario i , Producto p "
              + " WHERE i.Pro_ID = p.Pro_ID  "
              + " AND i.Inv_Serie = '"+Serie +"' OR i.Inv_RFID = '" + Serie +"'"
   

	var rsSerie = AbreTabla(sSQL, 1,0)
   	
	if(rsSerie.EOF){
%>
   <div class="m-b-md">
       <h2>Serie no encontrada: <strong><%=Serie%></strong></h2>
   </div>
   <hr>
<%
	} else {
        var Pro_ID = rsSerie.Fields.Item("Pro_ID").Value 
        var Inv_ID = rsSerie.Fields.Item("Inv_ID").Value 
        
         
        sSQL = "SELECT i.*, p.Pro_SKU, Pro_Nombre, Alm_Nombre, Lot_Folio, Lot_Fecha "
             + " ,A.Alm_ID, i.Cli_ID CliID" 
             + " ,(CONVERT(NVARCHAR(20),Lot_Fecha,103)) as FECHAINGRESO "
             + " ,dbo.fn_CatGral_DameDato(20,Inv_EstatusCG20) as ESTATUS "
             + ", (SELECT Ubi_Nombre FROM Ubicacion u WHERE u.Ubi_ID = i.Ubi_ID) as UBICACION "
             + ", (SELECT Cli_Nombre from Cliente ct WHERE ct.Cli_ID = i.Cli_ID) as CLIENTE "
             + ", (SELECT Pt_LPN from Pallet pt WHERE pt.Pt_ID = i.Pt_ID) as PALLET  "
             //+ ", ISNULL((SELECT Are_ID FROM Ubicacion WHERE Ubi_ID = i.Ubi_ID),'Sin área asignada') as Area  "
             + ", (SELECT count(*) from Inventario dis WHERE dis.Pro_ID = i.Pro_ID AND dis.Cli_ID = i.Cli_ID  "
             + " AND dis.Inv_EstatusCG20= 1 and dis.Inv_EnAlmacen = 1) as DISPONIBLES "
             + " FROM Inventario i, Producto p, Almacen a, Inventario_Lote l"
             + " WHERE Inv_ID =" + Inv_ID   
             + " AND i.Pro_ID = p.Pro_ID "
             + " AND i.Alm_ID = a.Alm_ID "
             + " AND i.Inv_LoteIngreso = l.Lot_ID "
//Response.Write(sSQL)

   var rsProd = AbreTabla(sSQL, 1,0)
   if(!rsProd.EOF){   
   var Cli_ID = rsProd.Fields.Item("CliID").Value
%>      
	<input type="hidden" id="Inv_ID" value=""/>
	<script type="application/javascript">
	<%if(Inv_ID > -1){%>
		$('#Inv_ID').val(<%=Inv_ID%>)
		Serie.TRA_Pedidos(<%=Inv_ID%>);
		Serie.SO_Pedidos(<%=Inv_ID%>);
		<%if(Cli_ID == 6){%>
			Serie.ASN(<%=Inv_ID%>,<%=Cli_ID%>);
		<%}%>	
	<%}%>

    </script>
   <div class="row">
        <div class="col-lg-6">
            <dl class="dl-horizontal">
                <dt class="copyID" title='<%=Inv_ID%>'>Serie:</dt>
                <dd class="textCopy"><%=rsProd.Fields.Item("Inv_Serie").Value %></dd>
                <dt class="copyID" title='<%=Inv_ID%>'>EPC:</dt>
                <dd class="textCopy"><%=rsProd.Fields.Item("Inv_RFID").Value %></dd>
                <dt>Producto:</dt>
                <dd class="textCopy"><%=rsProd.Fields.Item("Pro_Nombre").Value %></dd>
                <dt class="copyID" title='<%=rsProd.Fields.Item("Pro_ID").Value %>'>SKU:</dt>
             	<dd class="textCopy"><%=rsProd.Fields.Item("Pro_SKU").Value %></dd>
            </dl>
        </div>
        <div class="col-lg-6">
           <dl class="dl-horizontal">
             <dt>Estatus:</dt>
             <dd><span class="label label-primary"><%=rsProd.Fields.Item("ESTATUS").Value %></span></dd>
             
           </dl>
        </div>
            <div class="col-lg-12">
            <!--Datos de la Orden de compra-->
                <dl class="dl-horizontal">
                    <dt>Cliente:</dt>
                    <dd><%=rsProd.Fields.Item("CLIENTE").Value %></dd>
                    <dt title='<%=rsProd.Fields.Item("Alm_ID").Value %>'>Almac&eacute;n/Tienda actual:</dt>
                    <dd title='<%=rsProd.Fields.Item("Alm_ID").Value %>'><%=rsProd.Fields.Item("Alm_Nombre").Value %></dd>
                </dl>
            </div>
            <div class="col-lg-6">
                <dl class="dl-horizontal">
                    <dt>Ubicaci&oacute;n:</dt>
                    <dd class="textCopy"><%=rsProd.Fields.Item("UBICACION").Value %></dd>  
<%/*%>                    <dt>&Aacute;era:</dt>
                    <dd class="textCopy"><%=rsProd.Fields.Item("Area").Value %></dd>  
<%*/%>                    
                    <dt>Pallet:</dt>
                    <dd class="textCopy"><%=rsProd.Fields.Item("PALLET").Value %></dd>
                    <dt>Disponibles:</dt>
                    <dd><%=formato(rsProd.Fields.Item("DISPONIBLES").Value,0) %></dd>                     
                </dl>
            </div>
            

            <div class="col-lg-6" id="cluster_info">
                    <dl class="dl-horizontal">
                    <dt>Lote Ingreso:</dt>
                    <dd data-clipboard-text="<%=rsProd.Fields.Item("Lot_Folio").Value%>" class="textCopy"><%=rsProd.Fields.Item("Lot_Folio").Value %></dd>
                    <dt>Fecha Ingreso:</dt>
                    <dd><%=rsProd.Fields.Item("FECHAINGRESO").Value %></dd>
                    </dl>   
            </div>
    </div>
    <div id="dvTA"></div>
    <div id="dvOV"></div>
	<%}
}%>  
