<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%> 
<!--#include file="../../../Includes/iqon.asp" -->
<% //HA ID: 1 2020-07-29 Cliente Contrato: Creación de Archivo

var rqIntCli_Id = Parametro("Cli_Id", -1)

%>
	<div class="row">
		<div class="col-sm-8">
			<div class="ibox ">
				<div class="ibox-content" style="overflow: auto;">
						<div>
							<div class="tab-content">
								<div id="tab-1" class="tab-pane active">
									<div class="ibox-content" style="padding-top: 2px; padding-bottom: 198px;">
										<div class="ibox">
											<div class="col-md-12 forum-item active">
												<div class="col-md-col-md-offset-0 forum-icon">
													<i class="fa fa-file-text-o"></i>
												</div>
												<a href="#" class="forum-item-title" style="pointer-events: none">
													<h3>Contrato de Servicios</h3>
												</a>
												<div class="forum-sub-title">Informaci&oacute;n del lote y los movimientos realizados.</div>
												
												<!--br-->
												<div class="hr-line-dashed"></div>
												
												<div class="form-group col-md-12 row border-bottom">
													<label class="col-form-label col-md-12">
														<i class="fa fa-list-ul fa-lg"></i> Datos Generales
													</label>
												</div>
                                                
                                                <div class="form-group col-md-12 row">
												
													<label class="col-form-label col-md-2">
														Folio
													</label>
													<div class="col-md-4 classOrigen">
														LT-000014
													</div>
													
													<label class="col-form-label col-md-2 ">
														Fecha
													</label>
													<div class="col-md-4">
														09/07/2020 13:34:58.012
													</div>
													
												</div>
                                                <div class="hr-line-dashed"></div>
                                                <div class="table-responsive col-md-12 row">
                                                    <table class="table table-hover table-striped">
                                                        <tbody>
                                                            <tr>
                                                                <th>#</th>
                                                                <th>Fecha</th>
                                                                <th>Folio</th>
                                                                <th>Tipo de Movimiento</th>
                                                                <th>Cantidad</th>
                                                            </tr>
                                                            <tr>
                                                                <td>1</td>
                                                                <td>10/07/2020 09:20:35.252</td>
                                                                <td>LT-000015</td>
                                                                <td class="text-left form-group row issue-info">
                                                                    <a href="#">
                                                                        <i class="fa fa-file-text-o fa-lg"></i> Transferencia de salida
                                                                    </a>
                                                                    <small>
                                                                        Salida de mercancia al almacen
                                                                    </small>
                                                                </td>
                                                                <td class="text-right font-bold">
                                                                    1,000
                                                                </td>
                                                            </tr>
                                                        </tbody>
                                                    </table>
                                                </div>
										    </div>
									    </div>
								    </div>
							    </div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
        <div class="col-sm-2" id="divAlmacenTotales">
        	d
        </div>
	</div>
