<script type="text/javascript">
$(document).ready(function(){

	$('.btn-close').click(function(e){
		e.preventDefault();
		$(this).parent().parent().parent().fadeOut();
	});
	$('.btn-minimize').click(function(e){
		e.preventDefault();
		var $target = $(this).parent().parent().next('.box-content');
		if($target.is(':visible')) $('i',$(this)).removeClass('icon-chevron-up').addClass('icon-chevron-down');
		else 					   $('i',$(this)).removeClass('icon-chevron-down').addClass('icon-chevron-up');
		$target.slideToggle();
	});
	$('.btn-setting').click(function(e){
		var tipo = $(this).attr("data-tipo");
		e.preventDefault();
		$('#myModal').modal('show');
		$(".modal-body").html("tipo = " + tipo )
	});
	
});	
</script>