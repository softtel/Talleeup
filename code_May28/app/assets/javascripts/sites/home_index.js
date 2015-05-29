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

    changeLogo();

    $(window).resize(function() {
        changeLogo();
    });




});
/*
$('#btn-login').click(function(){

    $('#login-container-fluid').show('slow');
    $('#layer').show('slow');

    $('#Email').focus();
});*/
function login()
{
    $('#login-container-fluid').slideToggle("slow");
    $('#layer').slideToggle("slow");

    $('#Email').focus();
}
/*
$('#layer').click(function(){
    $(this).hide('slow');
    $('#login-container-fluid').hide('slow');
});*/
function layer()
{
    $("#layer").slideToggle('slow');
    $('#login-container-fluid').slideToggle('slow');
}
function changeLogo(){


    var width = $(window).width();

    if (width <= 480) {
        $('#logo').attr('src', '/assets/userprofile/logo-mobile.png')
    }else{
        $('#logo').attr('src', '/assets/userprofile/logo.png')
    }
};

/*
$('#btn-signup').click(function(){
    alert("ok")
    $('.introduct').hide('slow');
    $('#btn-signup').hide('slow');
    $('#sign-ups').hide('slow');
    $('#signup-list').hide('slow');
    $('#register-container-fluid').show('slow');
});*/
function signup()
{
    $('.introduct').hide('slow');
    $('#btn-signup').hide('slow');
    $('#sign-ups').hide('slow');
    $('#signup-list').hide('slow');
    $('#register-container-fluid').show('slow');
}
/*
$('#btn-slose-register-form').click(function(){

    $(this).closest('#register-container-fluid').hide('slow');
    $('.introduct').show('slow');
    $('#btn-signup').show('slow');
    $('#sign-ups').show('slow');
    $('#signup-list').show('slow');

});*/
function btnsloseregisterform()
{
    $("#btn-slose-register-form").closest('#register-container-fluid').hide('slow');
    $('.introduct').show('slow');
    $('#btn-signup').show('slow');
    $('#sign-ups').show('slow');
    $('#signup-list').show('slow');
}
/*
$('#btn-seefull-index').click(function(){

    $('#login-container-fluid').show('slow');
    $('#layer').show('slow');

    $('#Email').focus();
});*/
function btnseefullindex()
{
    $('#login-container-fluid').show('slow');
    $('#layer').show('slow');

    $('#Email').focus();
}
