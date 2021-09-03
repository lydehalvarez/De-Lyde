<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include file="../../../Includes/iqon.asp" -->

<div class="form-horizontal" id="toPrint">
    <div class="row">
        <div class="col-lg-9">
            <div class="ibox float-e-margins">
               <div class="ibox-content">
                    <div class="form-group">
                        <legend class="control-label col-md-12" style="text-align: left;"><h1>Incidencias</h1></legend> 
                <!--    <div class="col-md-3">
					 <legend class="control-label col-md-12" style="text-align: left;"><h1>Fecha: </h1></legend> 
                    </div>-->
                     </div>
                  
                <div style="overflow-y: scroll; height:655px; width: auto;">
                <%
                   
                                
                %>



    <table class="table">
    <thead>
    <th>Folio</th>
    	<th>SKU</th>
    	<th>Modelo</th>
    	<th>Color</th>
    	<th>LPN</th>
    	<th>Masterbox incompletos</th>
    	    </thead>
    <tbody>	
		<%
var CliOC_ID = Parametro("CliOC_ID",-1)
var TA_ID = Parametro("TA_ID",-1)  
var OC_ID = Parametro("OC_ID",6)
			if(CliOC_ID > -1){
			 	sSQL = "SELECT *  FROM Recepcion_Pallet r  INNER JOIN  Cliente_OrdenCompra c ON r.CliOC_ID=c.CliOC_ID WHERE   "
		   		sSQL += "r.Pt_MBRechazados > 0 AND r.CliOC_ID= "+CliOC_ID