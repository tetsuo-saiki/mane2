$(document).on('turbolinks:load', function(){
    $('#item_item_type_id').on('change', function(){
        var value = $('#item_item_type_id option:selected').text();
        $('#item_title').val(value);
    });
});