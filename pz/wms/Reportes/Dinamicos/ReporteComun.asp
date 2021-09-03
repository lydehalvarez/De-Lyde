<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include file="../../../../Includes/iqon.asp" -->
<%

var Rep_ID = Parametro("CboReporte",-1)
var Rep_ID = Parametro("CboReporte",-1)
var FechaInicio = Parametro("txtFechaDesde","") 
var FechaFinal = Parametro("txtFechaHasta","") 
var Cli_ID = Parametro("Cli_ID",-1)

if(FechaInicio != ""){
	FechaInicio = CambiaFormatoFecha(FechaInicio,"dd/mm/yyyy","yyyy-mm-dd")
}else{
	FechaInicio = "null"
}
if(FechaFinal != ""){
	FechaFinal = CambiaFormatoFecha(FechaFinal,"dd/mm/yyyy","yyyy-mm-dd")
}else{
	FechaFinal = "null"
}


var f = new Date();
var Dia = f.getDate() 
if(Dia < 10){
	Dia = "0"+Dia	
}
var Mes = f.getMonth()
if(Mes < 10){
	Mes = "0"+Mes	
}

var Fecha = Dia+"_"+Mes+"_"+f.getFullYear();

var urlBase = "https://wms.lydeapi.com"

var Titulos = "SELECT Rep_Titulo FROM ReportesCampos WHERE Rep_ID ="+Rep_ID+" ORDER BY Rep_Orden asc"

	var rsRepT = AbreTabla(Titulos,1,0)
var Rep_Nombre = BuscaSoloUnDato("Rep_Nombre","Reportes","Rep_ID = "+Rep_ID,"",0)
%>
<head>

    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title><%=Rep_Nombre +" "+ Fecha%></title>

    <link href="/Template/inspina/css/bootstrap.min.css" rel="stylesheet">

    <link href="/Template/inspina/css/plugins/dataTables/datatables.min.css" rel="stylesheet">

    <link href="/Template/inspina/css/animate.css" rel="stylesheet">
    <link href="/Template/inspina/css/style.css" rel="stylesheet">

</head>

      

<div class="wrapper wrapper-content">
	<div class="row">
        <div class="col-lg-12">
            <div class="ibox float-e-margins">
                <div class="ibox-title">
                    <h3><%=Rep_Nombre%></h3>
                </div>
                <div class="ibox-content">
                    <div class="table-responsive">
                        <table class="table table-hover dataTables-example">
                            <thead>
                                <tr>
                                <%
                                if(!rsRepT.EOF){
									
                                    while (!rsRepT.EOF){
                        
                                %>
                                    <th><%Response.Write(rsRepT.Fields.Item("Rep_Titulo").Value)%></th>
                                <%	
                                    Response.Flush()
                                    rsRepT.MoveNext() 
                                    }
                                    rsRepT.Close()  
                                }
                                %>
                                </tr>
                            </thead>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Mainly scripts -->
<script src="/Template/inspina/js/jquery-3.1.1.min.js"></script>
<script src="/Template/inspina/js/bootstrap.min.js"></script>
<script src="/Template/inspina/js/plugins/metisMenu/jquery.metisMenu.js"></script>
<script src="/Template/inspina/js/plugins/slimscroll/jquery.slimscroll.min.js"></script>

<script src="/Template/inspina/js/plugins/dataTables/datatables.min.js"></script>

<!-- Custom and plugin javascript -->
<script src="/Template/inspina/js/inspinia.js"></script>
<script src="/Template/inspina/js/plugins/pace/pace.min.js"></script>


<script> 
    
	
$(document).ready(function () {

    $.ajax({
        url: "<%=urlBase%>/api/Reporteador",
        method: 'POST',
		data: JSON.stringify({
			Rep_ID:<%=Rep_ID%>,
			Batman:"WMS_Test",
			FechaInicio:"<%=FechaInicio%>",
			FechaFinal:"<%=FechaFinal%>",
			Cli_ID:<%=Cli_ID%>
		}),
		contentType:'application/json',
        dataType: 'json',
        success: function (response) {
			console.log(response)
			if(response.data != null){
				var columns = []
				
				var keyNames = Object.keys(response.data[0]);
				console.log(keyNames)
				for(var i = 0;i<keyNames.length;i++){
					columns.push({"data":keyNames[i]})
				}
				console.log(columns)

				$('.dataTables-example').DataTable({
					dom: '<"html5buttons"B>lTfgitp',
					buttons: [
						{extend: 'csv'},
						{extend: 'excel'},
						{extend: 'pdf'},
						{extend: 'print',
						 customize: function (win){
								$(win.document.body).addClass('white-bg');
								$(win.document.body).css('font-size', '10px');
	
								$(win.document.body).find('table')
										.addClass('compact')
										.css('font-size', 'inherit');
						}
						}
					],
					//paging: false,
					columns:columns,
					data: response.data,
				});
			}
        }
    });

});

</script>
        
        
