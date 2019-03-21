$(document).on('turbolinks:load', function(){
    $("button.prev-month").on('click', function(){
        $(this).parent().find("form").submit();
    });
    $("button.next-month").on('click', function(){
        $(this).parent().find("form").submit();
    });
});