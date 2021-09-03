<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include virtual="/Includes/iqon.asp" -->
<%
    var cxnTipo = 0

     var urlBaseTemplate = "/Template/inspina/"

    var rqIntUbi_ID = Parametro("Ubi_ID", -1)

    var strUbi_Nombre = ""

    var sqlUbi = "SELECT Ubi.Ubi_Nombre "
        + "FROM Ubicacion Ubi "
        + "WHERE Ubi.Ubi_ID = " + rqIntUbi_ID + " "

    var rsUbi = AbreTabla(sqlUbi, 1, cxnTipo)

    if( !(rsUbi.EOF) ){
        strUbi_Nombre = rsUbi("Ubi_Nombre").Value
    }

    rsUbi.Close()

%>
<link href="<%= urlBaseTemplate %>css/bootstrap.min.css" rel="stylesheet">

<script src="<%= urlBaseTemplate %>js/jquery-3.1.1.min.js"></script>
<script src="<%= urlBaseTemplate %>js/plugins/JsBarcode/JsBarcode.all.min.js" charset="utf-8" ></script>

<script type="application/javascript">
    $(document).ready(function(e) {

        JsBarcode("#bcUbiNombre", "<%= strUbi_Nombre %>", {
            width: 3,
            align:"center",
            height: 100,
            fontSize: 1,
            displayValue: false,
            font:"fantasy"
        }); 

        window.print();    
    });
</script>

<center>
    <table border="1" cellpadding="1" cellspacing="1" style="text-align:center;">      
        <tr>
            <td>
                <strong>
                    <svg id="bcUbiNombre">

                    </svg>
                </strong>
            </td>
        </tr>
        <tr>
            <td>
                <h2><strong><%= strUbi_Nombre %></strong></h2>
            </td>
        </tr>
    </table>
</center>