<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%> 
<!--#include file="../../../../Includes/iqon.asp" -->
<%
	var TA_ArchivoID = Parametro("TA_ArchivoID",-1);
	var Linea = Parametro("Linea",-1);
	
	
	
%>
<div class="row">
    <div class="col-md-12">
    <table class="table">
        <thead>
            <tr>
                <th width="20%">Linea</th>
                <th width="20%">Configuraci&oacute;n</th>
                <th width="60%">Organizaci&oacute;n</th>
            </tr>
        </thead>
        <tbody>
            <%for(var i = 1;i<=Linea;i++){%>
            <tr>
                <td><%=i%></td>
                <td><button type="button" value="<%=i%>" class="btn btn-success btnConfig"><i class="fa fa-plus"></i>&nbsp;&nbsp;A&ntilde;adir</button></td>
                <td><div id="Linea_<%=i%>"></div></td>
            </tr>
            <%}%>
        </tbody>
    </table>
    </div>
</div>

<script type="application/javascript">

$('.btnConfig').click(function(e) {
	e.preventDefault();
	Planificacion.Configuracion($(this).val())
	
});

</script>




