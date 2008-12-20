$("#addfilter").click(function(){
	var field = "<p><label>Blocked Site: </label><input type='text' class='text' name='user[bad_sites]["+badsites+"]'/></p>";
	badsites++;
	$('#badsites').append(field);
    });