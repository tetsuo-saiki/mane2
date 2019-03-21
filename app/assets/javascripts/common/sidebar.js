$(document).on('turbolinks:load', function(){
  toggle_icon_change();
  dropdown_icon_change();

  $("#menu-toggle").click(function(e) {
    e.preventDefault();
    $("#wrapper").toggleClass("toggled");

    toggle_icon_change();
  });

  // サイドバートグルボタンの表示変更
  function toggle_icon_change() {
    var is_smart_devise = $(window).width() <= 767;
    if(is_smart_devise){
      if($("#wrapper").hasClass("toggled")){
        $("#menu-toggle").html('<i class="fas fa-angle-left"></i>');
      }else{
        $("#menu-toggle").html('<i class="fas fa-angle-right"></i>');
      }
    }else{
      if($("#wrapper").hasClass("toggled")){
        $("#menu-toggle").html('<i class="fas fa-angle-right"></i>');
      }else{
        $("#menu-toggle").html('<i class="fas fa-angle-left"></i>');
      }
    }
  }

  // ナビバードロップダウンの表示変更
  function dropdown_icon_change() {
    var is_smart_devise = $(window).width() <= 991;
    if(is_smart_devise){
      $(".fa-cog").text(' 設定');
      $(".fa-sign-out-alt").text(' ログアウト');
      $(".fa-sign-in-alt").text(' ログイン');
      $(".fa-user-plus").text(' 登録');
    }else{
      $(".fa-cog").text('');
      $(".fa-sign-out-alt").text('');
      $(".fa-sign-in-alt").text('');
      $(".fa-user-plus").text('');
    }
  }

});