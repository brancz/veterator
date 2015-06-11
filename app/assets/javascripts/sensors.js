$(function() {
    $('#language-selector').change(function() {
        $('.code-snippet').hide();
        var selection = $(this).val();
        $('.code-snippet-'+selection).show();
    });

    var removeUser = function(e) {
        var col = $(e.target).parent().parent();
        var row = col.parent();
        var listItem = row.parent();
        listItem.hide();
        var index = row.find('.current_index').val();
        $('<input type="hidden" name="sensor[sensor_accesses_attributes]['+index+'][_destroy]" value="1" />').insertBefore(col);
    };

    $('button.remove-user').click(removeUser);

    $('#user-search').autocomplete({
        source: function (request, response) {
            $.getJSON("/users/search.json?term=" + request.term, function (data) {
                response($.map(data.search, function (value) {
                    return {
                        label: value.email,
                        id: value.id
                    };
                }));
            });
        },
        select: function (e, selection) {
            var newIndex = parseInt($('.user').last().find('.current_index').val()) + 1;
            var accessLevelSelect = $('.access-level-select').first().clone();
            accessLevelSelect.attr('name', 'sensor[sensor_accesses_attributes][' + newIndex + '][access_level]');
            $('<li class="user">' +
            '<div class="row">' +
            '<input type="hidden" class="current_index" value="' + newIndex + '" />' +
            '<input type="hidden" name="sensor[sensor_accesses_attributes][' + newIndex + '][user_id]" value="' + selection.item.id + '" />' +
            '<div class="col-sm-6">' + selection.item.label + '</div>' +
            '<div class="col-sm-4 text-right"><select class="access-level-select form-control" name="sensor[sensor_accesses_attributes][' + newIndex + '][access_level]">' + accessLevelSelect.html() + '</select></div>' +
            '<div class="col-sm-2 text-right"><button type="button" class="remove-user close"><span>&times;</span></button></div>' +
            '</div>' +
            '</li>').insertBefore('#user-search-list-item');
            $('button.remove-user').click(removeUser);
            return false;
        },
        focus: function() {
            $('#user-search').val('');
            return false;
        },
        open: function() {
            $("ul.ui-menu").width($(this).innerWidth());
        }
    });
});
