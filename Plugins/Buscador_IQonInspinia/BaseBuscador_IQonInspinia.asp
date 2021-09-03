<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%> 
<!--#include file="../../Includes/iqon.asp" -->
<%
 
var biQ4Web = false

var sC = String.fromCharCode(34)  

   if(biQ4Web) {
   		Response.Write("sC&nbsp;=&nbsp;" + sC)
   
   }
   
   
%>
	
	
	<script src="/Template/inspina/js/plugins/select2/select2.full.min.js"></script>
	<link href="/Template/inspina/css/plugins/select2/select2.min.css" rel="stylesheet">
	
	<!-- Select2 -->
	<script src="/Template/inspina/js/plugins/select2/select2.full.min.js"></script>

	<!-- iCheck -->
	<script src="/Template/inspina/js/plugins/iCheck/icheck.min.js"></script>	
	
	
    <!-- Data picker -->
    <script src="/Template/inspina/js/plugins/datapicker/bootstrap-datepicker.js"></script>
	<link href="/Template/inspina/css/plugins/datapicker/datepicker3.css" rel="stylesheet">
	
    <!-- Date range picker -->
    <script src="/Template/inspina/js/plugins/daterangepicker/daterangepicker.js"></script>	
	<link href="/Template/inspina/css/plugins/daterangepicker/daterangepicker-bs3.css" rel="stylesheet">
	
	<script src="/Template/inspina/js/plugins/i18next/bootstrap-datepicker.es.min.js"></script>
	
	
	
	
<div class="ibox-content">
	<form class="form-horizontal">
		
		<div class="form-group">
			<div class="col-md-12">
				<div class="row"> 
					<div class="col-md-offset-6 col-md-5">
						<button class="btn btn-outline btn-danger dim btn-sm" type="button">Limpiar&nbsp;<i class="fa fa-eraser"></i></button>
						<button class="btn btn-outline btn-primary dim btn-sm" type="button" onClick="javascript:AcBuscadorBuscar();">Buscar&nbsp;<i class=" fa fa-search"></i></button>
					</div>
				</div>
			</div>
		</div>
		<!--div class="row">
			<div class="col-md-12">
				<div class="hr-line-dashed"></div>
			</div>
		</div-->
		<!--div class="ibox"-->
		<div class="ibox-content forum-container">
			<div class="forum-item active">
				<div class="forum-icon">
					<i class="fa fa-bolt"></i>
				</div>
				<a href="#" class="forum-item-title"><h3>Secci&oacute;n I</h3></a>
				<div class="forum-sub-title">Talk about sports, entertainment, music, movies, your favorite color, talk about enything.</div>
			</div>
		</div>	
		<!--/div-->	
		<!--// 1 = text box-->
		<div class="form-group">
			<div class="col-md-12">
				<div class="row">
					<label class="col-md-1 control-label">Text1-1</label>
					<div class="col-md-3"><input type="text" placeholder=".col-md-3" class="form-control"><span class="help-block m-b-none"><i class="fa fa-question-circle"></i>&nbsp;A block of help text that breaks onto a new line and may extend beyond one line.</span></div>
					<label class="col-md-1 control-label">Text1-2</label>
					<div class="col-md-3"><input type="text" placeholder=".col-md-3" class="form-control"><span class="help-block m-b-none"><i class="fa fa-question-circle"></i>&nbsp;A block of help text that breaks onto a new line and may extend beyond one line.</span></div>
					<label class="col-md-1 control-label">Text1-3</label>
					<div class="col-md-3"><input type="text" placeholder=".col-md-3" class="form-control"><span class="help-block m-b-none"><i class="fa fa-question-circle"></i>&nbsp;A block of help text that breaks onto a new line and may extend beyond one line.</span></div>
				</div>
			</div>
		</div>
		<div class="row">
			<div class="col-md-12">
				<div class="hr-line-dashed"></div>
			</div>
		</div>
		<!--// 1 = text box-->
		<div class="form-group">
			<div class="col-md-12">
				<div class="row">
					<label class="col-md-1 control-label">Text1-1</label>
					<div class="col-md-2"><input type="text" placeholder=".col-md-2" class="form-control"><span class="help-block m-b-none"><i class="fa fa-question-circle"></i>&nbsp;A block of help text that breaks onto a new line and may extend beyond one line.</span></div>
					<label class="col-md-1 control-label">Text1-2</label>
					<div class="col-md-2"><input type="text" placeholder=".col-md-2" class="form-control"><span class="help-block m-b-none"><i class="fa fa-question-circle"></i>&nbsp;A block of help text that breaks onto a new line and may extend beyond one line.</span></div>
					<label class="col-md-1 control-label">Text1-3</label>
					<div class="col-md-2"><input type="text" placeholder=".col-md-2" class="form-control"><span class="help-block m-b-none"><i class="fa fa-question-circle"></i>&nbsp;A block of help text that breaks onto a new line and may extend beyond one line.</span></div>
					<label class="col-md-1 control-label">Text1-4</label>
					<div class="col-md-2"><input type="text" placeholder=".col-md-2" class="form-control"><span class="help-block m-b-none"><i class="fa fa-question-circle"></i>&nbsp;A block of help text that breaks onto a new line and may extend beyond one line.</span></div>
				</div>
			</div>
		</div>
		<!--div class="row">
			<div class="col-md-12">
				<div class="hr-line-dashed"></div>
			</div>
		</div-->
		<div class="ibox-content forum-container">
			<div class="forum-item active">
				<div class="forum-icon">
					<i class="fa fa-bolt"></i>
				</div>
				<a href="#" class="forum-item-title"><h3>Secci&oacute;n II</h3></a>
				<div class="forum-sub-title">Talk about sports, entertainment, music, movies, your favorite color, talk about enything.</div>
			</div>
		</div>	
		<!--// 2 = option-->
		<div class="form-group">
			<div class="col-md-12">
				<label class="col-md-2 control-label">Inline radios</label>
				<div class="col-md-4">
					<label class="radio-inline i-checks"> <input type="radio" value="option1" name="a"> <i></i>&nbsp;Option 1</label>
					<label class="radio-inline i-checks"> <input type="radio" value="option11" name="a"> <i></i>&nbsp;Option 2</label>
					<span class="help-block m-b-none"><i class="fa fa-question-circle"></i>&nbsp;A block of help text that breaks onto a new line and may extend beyond one line.</span>
				</div>
				<label class="col-md-2 control-label">Inline radios</label>
				<div class="col-md-4">
					<label class="radio-inline i-checks"> <input type="radio" value="option2" name="b"> <i></i>&nbsp;Option 1</label>
					<label class="radio-inline i-checks"> <input type="radio" value="option22" name="b"> <i></i>&nbsp;Option 2</label>
					<span class="help-block m-b-none"><i class="fa fa-question-circle"></i>&nbsp;A block of help text that breaks onto a new line and may extend beyond one line.</span>
				</div>
				<!--div class="radio radio-info radio-inline">
					<input type="radio" id="inlineRadio1" value="option1" name="radioInline" checked="">
					<label for="inlineRadio1"> Inline One </label>
					<input type="radio" id="inlineRadio2" value="option2" name="radioInline">
                    <label for="inlineRadio2"> Inline Two </label>
				</div-->
			</div>
		</div>
		<div class="row">
			<div class="col-md-12">
				<div class="hr-line-dashed"></div>
			</div>
		</div>
		<!--// 3 =-->
		<!--// 4 = combo-->
		<div class="form-group">
			<div class="col-md-12">
				<label class="col-sm-1 control-label">Select 1</label>
				<div class="col-md-3">
					<select class="cboname1 form-control" name="account1">
						<option>Entregado</option>
						<option>Entrega parcial</option>
						<option>Devoluci&oacute;n</option>
						<option>Devoluci&oacute;n parcial</option>
					</select>
					<span class="help-block m-b-none"><i class="fa fa-question-circle"></i>&nbsp;A block of help text that breaks onto a new line and may extend beyond one line.</span>
				</div>
				<label class="col-sm-1 control-label">Select 2</label>
				<div class="col-md-3">
					<select class="cboname2 form-control" name="account2">
						<option>Entregado</option>
						<option>Entrega parcial</option>
						<option>Devoluci&oacute;n</option>
						<option>Devoluci&oacute;n parcial</option>
					</select>
					<span class="help-block m-b-none"><i class="fa fa-question-circle"></i>&nbsp;A block of help text that breaks onto a new line and may extend beyond one line.</span>
				</div>
				<label class="col-sm-1 control-label">Select 3</label>
				<div class="col-md-3">
					<select class="cboname3 form-control" name="account3">
						<option>Entregado</option>
						<option>Entrega parcial</option>
						<option>Devoluci&oacute;n</option>
						<option>Devoluci&oacute;n parcial</option>
					</select>
					<span class="help-block m-b-none"><i class="fa fa-question-circle"></i>&nbsp;A block of help text that breaks onto a new line and may extend beyond one line.</span>
				</div>				
			</div>
		</div>	
		<div class="row">
			<div class="col-md-12">
				<div class="hr-line-dashed"></div>
			</div>
		</div>		
		<!--// 5 = checkbox-->
		<div class="form-group">
			<div class="col-md-12">
				<label class="col-md-2 control-label">Inline checkboxes</label>
				<div class="col-md-4">
					<label class="checkbox-inline i-checks"> <input type="checkbox" value="option1">&nbsp;check 1</label>
					<label class="checkbox-inline i-checks"> <input type="checkbox" value="option2">&nbsp;check 2</label>
					<label class="checkbox-inline i-checks"> <input type="checkbox" value="option3">&nbsp;check 3</label>
					<span class="help-block m-b-none"><i class="fa fa-question-circle"></i>&nbsp;A block of help text that breaks onto a new line and may extend beyond one line.</span>
				</div>
				<label class="col-md-2 control-label">Inline checkboxes</label>
				<div class="col-md-4">
					<label class="checkbox-inline i-checks"> <input type="checkbox" value="option1">&nbsp;check 1</label>
					<label class="checkbox-inline i-checks"> <input type="checkbox" value="option2">&nbsp;check 2</label>
					<label class="checkbox-inline i-checks"> <input type="checkbox" value="option3">&nbsp;check 3</label>
					<span class="help-block m-b-none"><i class="fa fa-question-circle"></i>&nbsp;A block of help text that breaks onto a new line and may extend beyond one line.</span>
				</div>
				<label class="col-md-2 control-label">Inline checkboxes</label>
				<div class="col-md-4">
					<div class="radio radio-info radio-inline">
						<input type="radio" id="inlineRadio1" value="option1" name="radioInline" checked="">
						<label for="inlineRadio1"> Inline One </label>
					</div>
				</div>
			</div>
		</div>		
		<div class="row">
			<div class="col-md-12">
				<div class="hr-line-dashed"></div>
			</div>
		</div>
		<!--// 6 = fecha-->
		<div class="form-group">
			<div class="col-md-12">
				<label class="col-md-1 control-label">Simple data input format</label>
				<div class="col-md-3" id="data_1">
					<div class="input-group date">
						<span class="input-group-addon"><i class="fa fa-calendar"></i></span><input type="text" class="form-control">
					</div>
					<span class="help-block m-b-none"><i class="fa fa-question-circle"></i>&nbsp;A block of help text that breaks onto a new line and may extend beyond one line.</span>
				</div>
				<label class="col-md-1 control-label">Simple data input format</label>
				<div class="col-md-3" id="data_2">
					<div class="input-group date">
						<span class="input-group-addon"><i class="fa fa-calendar"></i></span><input type="text" class="form-control">
					</div>
					<span class="help-block m-b-none"><i class="fa fa-question-circle"></i>&nbsp;A block of help text that breaks onto a new line and may extend beyond one line.</span>
				</div>
				<label class="col-md-1 control-label">Simple data input format</label>
				<div class="col-md-3" id="data_3">
					<div class="input-group date">
						<span class="input-group-addon"><i class="fa fa-calendar"></i></span><input type="text" class="form-control">
					</div>
					<span class="help-block m-b-none"><i class="fa fa-question-circle"></i>&nbsp;A block of help text that breaks onto a new line and may extend beyond one line.</span>
				</div>

			</div>
		</div>
		<div class="row">
			<div class="col-md-12">
				<div class="hr-line-dashed"></div>
			</div>
		</div>
		<!--// 7 = combo Catálogo General-->
		<div class="form-group">
			<div class="col-md-12">
				<label class="col-sm-1 control-label">Select 1</label>
				<div class="col-md-3">
					<select class="cboname1 form-control" name="accountcg1">
						<option>Entregado</option>
						<option>Entrega parcial</option>
						<option>Devoluci&oacute;n</option>
						<option>Devoluci&oacute;n parcial</option>
					</select>
					<span class="help-block m-b-none"><i class="fa fa-question-circle"></i>&nbsp;A block of help text that breaks onto a new line and may extend beyond one line.</span>
				</div>
				<label class="col-sm-1 control-label">Select 2</label>
				<div class="col-md-3">
					<select class="cboname2 form-control" name="accountcg2">
						<option>Entregado</option>
						<option>Entrega parcial</option>
						<option>Devoluci&oacute;n</option>
						<option>Devoluci&oacute;n parcial</option>
					</select>
					<span class="help-block m-b-none"><i class="fa fa-question-circle"></i>&nbsp;A block of help text that breaks onto a new line and may extend beyond one line.</span>
				</div>
				<label class="col-sm-1 control-label">Select 3</label>
				<div class="col-md-3">
					<select class="cboname3 form-control" name="accountcg3">
						<option>Entregado</option>
						<option>Entrega parcial</option>
						<option>Devoluci&oacute;n</option>
						<option>Devoluci&oacute;n parcial</option>
					</select>
					<span class="help-block m-b-none"><i class="fa fa-question-circle"></i>&nbsp;A block of help text that breaks onto a new line and may extend beyond one line.</span>
				</div>				
			</div>
		</div>	
		<div class="row">
			<div class="col-md-12">
				<div class="hr-line-dashed"></div>
			</div>
		</div>		
		<!--// 8 = password-->
		<div class="form-group">
			<div class="col-md-12">
				<div class="row">
					<label class="col-md-1 control-label">Password-1</label>
					<div class="col-md-3"><input type="password" placeholder=".col-md-3" class="form-control"><span class="help-block m-b-none"><i class="fa fa-question-circle"></i>&nbsp;A block of help text that breaks onto a new line and may extend beyond one line.</span></div>
					<label class="col-md-1 control-label">Password-2</label>
					<div class="col-md-3"><input type="password" placeholder=".col-md-3" class="form-control"><span class="help-block m-b-none"><i class="fa fa-question-circle"></i>&nbsp;A block of help text that breaks onto a new line and may extend beyond one line.</span></div>
					<label class="col-md-1 control-label">Password-3</label>
					<div class="col-md-3"><input type="password" placeholder=".col-md-3" class="form-control"><span class="help-block m-b-none"><i class="fa fa-question-circle"></i>&nbsp;A block of help text that breaks onto a new line and may extend beyond one line.</span></div>
				</div>
			</div>
		</div>
		<div class="row">
			<div class="col-md-12">
				<div class="hr-line-dashed"></div>
			</div>
		</div>
		<!--// 9 = Text Area-->
		<div class="form-group">
			<div class="col-md-12">
				<div class="row">
					<label class="col-md-1 control-label">Message-1</label>
					<div class="col-md-3"><textarea class="form-control" id="message1" rows="3" placeholder="Enter a message 1..."></textarea><span class="help-block m-b-none"><i class="fa fa-question-circle"></i>&nbsp;A block of help text that breaks onto a new line and may extend beyond one line.</span></div>
					<label class="col-md-1 control-label">Message-2</label>
					<div class="col-md-3"><textarea class="form-control" id="message2" rows="3" placeholder="Enter a message 2..."></textarea><span class="help-block m-b-none"><i class="fa fa-question-circle"></i>&nbsp;A block of help text that breaks onto a new line and may extend beyond one line.</span></div>
					<label class="col-md-1 control-label">Message-3</label>
					<div class="col-md-3"><textarea class="form-control" id="message3" rows="3" placeholder="Enter a message 3..."></textarea><span class="help-block m-b-none"><i class="fa fa-question-circle"></i>&nbsp;A block of help text that breaks onto a new line and may extend beyond one line.</span></div>
				</div>
			</div>
		</div>
		<div class="row">
			<div class="col-md-12">
				<div class="hr-line-dashed"></div>
			</div>
		</div>
		<!--//	10 = Sí / no-->
		<!--//11 = text box doble para rangos-->
		<!--// 12 = text box doble para rangos fechas-->
		<div class="form-group">
			<div class="col-md-12">
				<div class="row">
					<label class="col-md-1 control-label">Rango de fechas 1</label>
					<div class="col-md-3" id="data_5">
						<div class="input-daterange input-group" id="datepicker">
							<input type="text" class="input-sm form-control" name="start1"/>
							<span class="input-group-addon">a</span>
							<input type="text" class="input-sm form-control" name="end1"/>
						</div>
						<span class="help-block m-b-none"><i class="fa fa-question-circle"></i>&nbsp;A block of help text that breaks onto a new line and may extend beyond one line.</span>
					</div>
					<label class="col-md-1 control-label">Rango de fechas 2</label>
					<div class="col-md-3" id="data_6">
						<div class="input-daterange input-group" id="datepicker">
							<input type="text" class="input-sm form-control" name="start2"/>
							<span class="input-group-addon">a</span>
							<input type="text" class="input-sm form-control" name="end2"/>
						</div>
						<span class="help-block m-b-none"><i class="fa fa-question-circle"></i>&nbsp;A block of help text that breaks onto a new line and may extend beyond one line.</span>
					</div>
				</div>
			</div>
		</div>
		<!--// 13 = div's-->
		<div class="form-group">
			<div class="col-md-12">		
				<div id="divNom" class=""></div>
			</div>
		</div>		
		<div class="row">
			<div class="col-md-12">
				<div class="hr-line-dashed"></div>
			</div>
		</div>
	</form>
</div>
	

<script>
	
	$(document).ready(function () {
		
		$('.i-checks').iCheck({
			checkboxClass: 'icheckbox_square-green',
			radioClass: 'iradio_square-green',
		});
		
		$('#data_1 .input-group.date').datepicker({
			format: "dd/mm/yyyy",
			todayBtn: "linked",
			language: "es",
			todayHighlight: true,
			autoclose: true
		});

		$('#data_2 .input-group.date').datepicker({
			format: "dd/mm/yyyy",
			todayBtn: "linked",
			language: "es",
			todayHighlight: true,
			autoclose: true
		});
		
		$('#data_3 .input-group.date').datepicker({
			format: "dd/mm/yyyy",
			todayBtn: "linked",
			language: "es",
			todayHighlight: true,
			autoclose: true
		});
		
		$('#data_5 .input-daterange').datepicker({
			format: "dd/mm/yyyy",
			todayBtn: "linked",
			language: "es",
			keyboardNavigation: false,
			forceParse: false,
			todayHighlight: true,
			autoclose: true
		});

		$('#data_6 .input-daterange').datepicker({
			format: "dd/mm/yyyy",
			todayBtn: "linked",
			language: "es",
			keyboardNavigation: false,
			forceParse: false,
			todayHighlight: true,
			autoclose: true
		});
		
		
	});
	
	$(".cboname1").select2();
	$(".cboname2").select2();
	$(".cboname3").select2();
	
	
</script>	
	