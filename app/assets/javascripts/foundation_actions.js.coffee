ready = ->
  $(document).foundation()

  window.setTimeout ( ->
    $('.alert-box a.close').trigger('click.fndtn.alert')
    return
  ), 3000

  $(".sensors").sortable items: '.sensor', update: ->
    $.ajax url: '/sensors/sort.json', type: 'PATCH', data: $(this).sortable('serialize')

  $(".row.previews").disableSelection()

  $('.datepicker').datepicker({prevText: "", nextText: ""})

  plot uri, selector if uri? && selector?
  plot_graphs()
  $(window).resize ->
    chart_preview = $(".chart-preview")
    svg = $(".chart-preview > svg")
    svg.width( chart_preview.width() - 15 )

$(document).on 'page:load', ->
  ready()

$ ->
  ready()
