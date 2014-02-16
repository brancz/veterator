$(document).foundation()

window.setTimeout ( ->
	$('.alert-box a.close').trigger('click.fndtn.alert')
	return
), 3000
