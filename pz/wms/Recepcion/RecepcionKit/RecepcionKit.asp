<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%> 
<!--#include file="../../../../Includes/iqon.asp" -->

<%
	var IR_ID = Parametro("IR_ID",986)
	var rsKit = null
	
	var sSQLRecp = "SELECT * "+
				   " FROM Inventario_Recepcion "+
				   " WHERE IR_ID = "+IR_ID
				   
	Response.Write(sSQLRecp)
    var rsIR = AbreTabla(sSQLRecp,1,0)	
	if(!rsIR.EOF){
		var Cli_ID = rsIR.Fields.Item("Cli_ID").Value 
		var CliOC_ID = rsIR.Fields.Item("CliOC_ID").Value 
		
		var sSQLKit = "SELECT CliEnt_SKU,Pro_ID "
			sSQLKit += " FROM Cliente_OrdenCompra_Entrega a, Cliente_OrdenCompra_EntregaProducto b"
			sSQLKit += " WHERE a.CliOC_ID = "+CliOC_ID
			sSQLKit += " AND a.CliOC_ID = b.CliOC_ID "
			sSQLKit += " AND a.CliEnt_ID = b.CliEnt_ID "
			sSQLKit += " AND a.CliEnt_EstatusCG68 = 1 "
			
		rsKit = AbreTabla(sSQLKit,1,0)	
	}
	 
%>

<div class="wrapper wrapper-content animated fadeInRight">
    <div class="row">
        <div class="col-lg-12">
            <div class="ibox">
                <div class="ibox-title">
                    <h5>Recepcion de Kit</h5>
                    <div class="ibox-tools">
                        <a onClick="Kit.NuevoKit()" class="btn btn-primary btn-xs"><i class="fa fa-plus"></i>&nbsp;Nuevo kit</a>
                    </div>
                </div>
                <div class="ibox-content">
                    <div class="m-b-lg">
                        <div class="input-group">
                            <input type="text" placeholder="Ingresa el UPC" class="form-control">
                        </div>
                        <div class="m-t-md">
                            <div class="pull-right">
                                <button type="button" class="btn btn-sm btn-white"><i class="fa fa-comments"></i> </button>
                                <button type="button" class="btn btn-sm btn-white"><i class="fa fa-user"></i> </button>
                                <button type="button" class="btn btn-sm btn-white"><i class="fa fa-list"></i> </button>
                                <button type="button" class="btn btn-sm btn-white"><i class="fa fa-pencil"></i> </button>
                                <button type="button" class="btn btn-sm btn-white"><i class="fa fa-print"></i> </button>
                                <button type="button" class="btn btn-sm btn-white"><i class="fa fa-cogs"></i> </button>
                            </div>
                            <strong>&nbsp;</strong>
                        </div>
                    </div>

                    <div class="table-responsive">
                    <table class="table table-hover table-striped">
                    	<thead>
                        	<tr>
                            	<th width="20%">Kit</th>
                            	<th width="60%">Pallet</th>
                            	<th width="20%">Acciones</th>
                            </tr>
                        </thead>
                        <tbody>
						<%
						var Renglon = 0
						if(rsKit != null){
                            while (!rsKit.EOF){
                                        
                        %>
                            <tr>
                                <td>
                                    <h3>Tarima <%++Renglon%>
                                    <br>
                                    <%=rsIR.Fields.Item("CliEnt_SKU").Value%>
                                    <br>
                                    Nombre</h3>
                                </td>
                                <td>
                                    <div class="col-xs-1 text-center"><a class="btn btn-primary btn-md">15</a><br><small>Pallet 1</small></div>
                                    <div class="col-xs-1 text-center"><a class="btn btn-primary btn-md">15</a><br><small>Pallet 1</small></div>
                                    <div class="col-xs-1 text-center"><a class="btn btn-primary btn-md">15</a><br><small>Pallet 1</small></div>
                                    <div class="col-xs-1 text-center"><a class="btn btn-primary btn-md">15</a><br><small>Pallet 1</small></div>
                                    <div class="col-xs-1 text-center"><a class="btn btn-primary btn-md">15</a><br><small>Pallet 1</small></div>
                                    <div class="col-xs-1 text-center"><a class="btn btn-primary btn-md">15</a><br><small>Pallet 1</small></div>
                                    <div class="col-xs-1 text-center"><a class="btn btn-primary btn-md">15</a><br><small>Pallet 1</small></div>
                                    <div class="col-xs-1 text-center"><a class="btn btn-primary btn-md">15</a><br><small>Pallet 1</small></div>
                                </td>
                                <td>
                                    <button class="btn btn-white btn-sm"> Tag</button>
                                </td>
                            </tr>
						<%	
                            rsKit.MoveNext() 
                        }
                        rsKit.Close()   
						}else{
                        %>
                            <tr>
                                <td colspan="3" align="center">No hay datos</td>
                            </tr>
                        <%}%>                        
                        </tbody>
                    </table>
                    </div>
                </div>

            </div>
        </div>
    </div>
</div>



<script type="application/javascript">


var Kit = {
	NuevoKit:function(){
		
		
	}
	
	
}

</script>