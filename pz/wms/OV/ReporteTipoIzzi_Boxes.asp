<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include file="../../../Includes/iqon.asp" -->
        
<%
	
	var Datos = new Array("Recibidos","Packing","Transito","Primer Intento","Segundo Intento","Tercer Intento","Fallido","Entregado")
	var DatosNum = new Array(1,3,5,6,7,8,9,10)

%>
<style>

.FiltraPorEstatus {
	color: #f5f5f5;
    text-decoration: none;
}
.FiltraPorEstatus:hover {
	color: #00C;
}
</style>
<%	
var leng = Datos.length
for(var i = 0; i < leng; i++){

	var sSQLRTI = "SELECT COUNT(*) Cantidad "
		sSQLRTI += " FROM Orden_Venta p "
		sSQLRTI += " WHERE OV_Cancelada = 0 "
		sSQLRTI += " AND OV_Test = 0 "
		sSQLRTI += " AND OV_EstatusCG51 = "+DatosNum[i]
		
	var rsRTI = AbreTabla(sSQLRTI,1,0)
	var Cantidad = 0
	var Estilo = ""
	if(!rsRTI.EOF){
		Cantidad = rsRTI.Fields.Item("Cantidad").Value
		if(DatosNum[i] != 10){
			if(Cantidad >= 0 && Cantidad <= 99){
				Estilo = "lazur-bg"
			}else if(Cantidad > 100 && Cantidad <= 199){
				Estilo = "yellow-bg"
			}else if(Cantidad > 200){
				Estilo = "red-bg"
			}
		}else{
			Estilo = "navy-bg"
		}
	}

%>
<div class="col-xs-3">
    <div class="widget <%=Estilo%>">
        <div class="row">
         <a class="FiltraPorEstatus" data-estatus="<%=DatosNum[i]%>">
            <div class="col-xs-4">
                <i class="fa fa-truck fa-3x"></i>
            </div>
            <div class="col-xs-8 text-right">
                <span><%=Datos[i]%></span>
                <h2 class="font-bold"><%=Cantidad%></h2>
            </div>
            </a>
        </div>
    </div>
</div>
<%
}
%>

