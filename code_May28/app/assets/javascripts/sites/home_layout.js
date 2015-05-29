/**
 * Created by TanNo1 on 12/26/2014.
 */

function mobileGroupAction(){
    var viewportWidth = $(window).width();
    if(viewportWidth <= 430)
    {
        $('.product').hover(
            function(){
                $(this).find('.mobile-btn-group').show('slow');
            }
            , function(){
                $(this).find('.mobile-btn-group').hide('slow');
            });
    }
}

$(document).ready(function(){

    mobileGroupAction();

    $(window).resize(function() {
        mobileGroupAction()
    });


    $('#btn-login').click(function(){
        $('#login-container-fluid').show('slow');
        $('#layer').show('slow');
    });

    $('#layer').click(function(){
        $(this).hide('slow');
        $('#login-container-fluid').hide('slow');
    });

    $('#btn-signup').click(function(){

        $('.introduct').hide('slow');
        $('#btn-signup').hide('slow');
        $('#sign-ups').hide('slow');
        $('#signup-list').hide('slow');
        $('#register-container-fluid').show('slow');
    });

    $('#btn-slose-register-form').click(function(){

        $(this).closest('#register-container-fluid').hide('slow');
        $('.introduct').show('slow');
        $('#btn-signup').show('slow');
        $('#sign-ups').show('slow');
        $('#signup-list').show('slow');

    });
});
