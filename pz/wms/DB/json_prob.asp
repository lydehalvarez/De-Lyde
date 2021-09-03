<h2>product code</h2>
    <form name="form" action="" method="get">
        <input type="text" name="prod">
        <h2>shelf code</h2>
        <input type="text" name="shelf">
    </form>
    <button onclick="boton()">Prueba</button>
<script>
    var product = null;
    var shelf = null;
    var status = null;
function boton()
{
	product = document.getElementsByName("prod")[0].value;
  	shelf = document.getElementsByName("shelf")[0].value;
  	console.log(product+" "+shelf);
};
</script>