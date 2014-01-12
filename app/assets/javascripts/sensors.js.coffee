# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$ ->
	$(".sensors").sortable items: '.sensor', update: ->
		$.ajax url: '/sensors/sort.json', type: 'PATCH', data: $(this).sortable('serialize')

  $(".row.previews").disableSelection()
