<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%> 
<!--#include file="../../../Includes/iqon.asp" -->
<%
 	var IR_ID = Parametro("IR_ID",-1)
	var Dia = Parametro("Dia",-1)
	var Tipo = Parametro("Tipo",-1) 
	var Pt_LPN = Parametro("Pt_LPN","")

	var sSQLRecep = "SELECT * "
		sSQLRecep += "FROM Recepcion_Pallet "
		sSQLRecep += " WHERE Pt_LPN = '" +Pt_LPN + "'"
    var rsPallets = AbreTabla(sSQLRecep,1,0)
    if (!rsPallets.EOF){
        var Pt_Color = rsPallets.Fields.Item("Pt_Color").Value 
        var Pt_Modelo = rsPallets.Fields.Item("Pt_Modelo").Value 
        var Pt_SKU = rsPallets.Fields.Item("Pt_SKU").Value 
        var Pt_LPN = rsPallets.Fields.Item("Pt_LPN").Value 
        var Pt_Cantidad = rsPallets.Fields.Item("Pt_Cantidad").Value 
        var Pt_FechaRegistro =  rsPallets.Fields.Item("Pt_FechaRegistro").Value
    }
    rsPallets.Close()
%>
<style media="print">
    @page {
        size: auto;   /* auto is the initial value */
    }
    .page-break  { 
        display:block; 
        page-break-before:always; 
    }

</style>
<link href="/Template/inspina/css/style.css" rel="stylesheet">
<link href="/Template/inspina/css/bootstrap.min.css" rel="stylesheet">
<title>&nbsp;</title>
<body>
    <center>
        <H1>
            Recepci&oacute;n <%=Parametro("Folio","")%>
        </H1>
    </center>
  <br />
  <br />
 <H1><strong>SKU:</strong> <strong> <%=Pt_SKU%></strong></H1></strong></H1>

  <br />

  <br />
    <H1>
        <strong>Modelo: </strong><strong><%=Pt_Modelo%></strong>
          <br />
          <br />

        <strong>Color: </strong>  <strong><%=Pt_Color%></strong>
          <br />
          <br />

        <strong>Cantidad: </strong><strong><%=Pt_Cantidad%></strong>
          <br />
          <br />

      <strong>LPN:</strong>  <strong><%=Pt_LPN%></strong>
          <br />
        <br />

      <strong>FECHA: </strong> <strong><%=Pt_FechaRegistro%></strong>

    </H1>
  
</body>
<footer>&nbsp;</footer>

<script src="/Template/inspina/js/jquery-3.1.1.min.js"></script>
<script type="application/javascript">
    
    $(document).ready(function(e) {
        window.print();    
    });

</script>


