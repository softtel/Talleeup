/**
 * Created by TanNo1 on 12/31/2014.
 */

function icon_edit_meta(id,_val) {

    var sss=id.split('-');
    var ele = $("#" + id);

    var metaValue = ele.closest('.pull-right').find('.meta-value');
    var value = _val;//metaValue.find('.value').text();
    var ddd="'"+_val+"'"
    metaValue.html('<input id="value_'+id+'" onkeypress="if (event.keyCode==13){ icon_save_meta('+sss[sss.length-1]+','+ddd+');return false;}" class="form-control" />');

    var textbox = ele.closest('.pull-right').find('.form-control');
    textbox.val(value);
    textbox.focus();

    ele.hide();
    ele.closest('.pull-right').find('.icon-save-meta').show();
}; // end edit-meta-click

function icon_save_meta(id,_val) {

    var ele = $("#" + id);

    var metaValue = ele.closest('.pull-right').find('.meta-value');
    var dataType = metaValue.attr("data-datatype");

    var textbox = ele.closest('.pull-right').find('.form-control');
    if(dataType == "url"){
        metaValue.html('<a class="value" href="' + textbox.val() + '">' + textbox.val() + '</a>');
    }else{
        metaValue.html('<span class="value">' + textbox.val() + '</span>');
    }

    ele.closest('.pull-right').removeClass('form-control');


    var meta_user = {
        id: id,
        value: $("#value_icon-edit-meta-"+id+"").val(),
        authenticity_token: $('#token_my').val()
    };

    $.ajax({
        type: "POST",
        url: '/home/user_meta',
        contentType: "application/json; charset=utf-8",
        dataType: 'json',
        data: JSON.stringify(meta_user),
        success: function (data, status) {
            console.log('success');
            window.location=document.URL;
        },
        error: function (data, status) {
            console.log('error');
        }
    });

    ele.hide();
    ele.closest('.pull-right').find('.icon-edit-meta').show();
};
function icon_edit_meta_select_country(id,type)
{
    var _idcountry=$("#countreyhhhhhh").val();
    var meta_user = {
        id: id,
        value:_idcountry,
        type:type,
        authenticity_token: $('#token_my').val()
    };
    if(id==0) {
        $.ajax({
            type: "POST",
            url: '/home/user_meta_country_city',
            contentType: "application/json; charset=utf-8",
            dataType: 'json',
            data: JSON.stringify(meta_user),
            success: function (data, status) {
                console.log('success');
                window.location = document.URL;
            },
            error: function (data, status) {
                console.log('error');
            }
        });
    }
    else
    {
        $.ajax({
            type: "POST",
            url: '/home/update_user_meta_country_city',
            contentType: "application/json; charset=utf-8",
            dataType: 'json',
            data: JSON.stringify(meta_user),
            success: function (data, status) {
                console.log('success');
                window.location = document.URL;
            },
            error: function (data, status) {
                console.log('error');
            }
        });
    }
}
function icon_edit_meta_select_city(id,type)
{
    var _idcountry=$("#citytybbbbb").val();
    var meta_user = {
        id: id,
        value:_idcountry,
        type:type,
        authenticity_token: $('#token_my').val()
    };
    if(id==0) {
        $.ajax({
            type: "POST",
            url: '/home/user_meta_country_city',
            contentType: "application/json; charset=utf-8",
            dataType: 'json',
            data: JSON.stringify(meta_user),
            success: function (data, status) {
                console.log('success');
                window.location = document.URL;
            },
            error: function (data, status) {
                console.log('error');
            }
        });
    }
    else
    {
        $.ajax({
            type: "POST",
            url: '/home/update_user_meta_country_city',
            contentType: "application/json; charset=utf-8",
            dataType: 'json',
            data: JSON.stringify(meta_user),
            success: function (data, status) {
                console.log('success');
                window.location = document.URL;
            },
            error: function (data, status) {
                console.log('error');
            }
        });
    }
}
function icon_edit(id) {


    var ele = $('#' + id);

    var contentEdit = ele.closest('.wrapper-content-edit').find('.content-edit');
    contentEdit.html('<input class="form-control input-edit-content" value="' + contentEdit.text() + '" />');
    ele.hide();
    ele.closest('.edit-actions').find('.icon-save').show();
    contentEdit.find('.form-control').focus();

};// end icon-edit click

function icon_save(id) {

    var ele = $('#' + id);

    var content = ele.closest('.wrapper-content-edit').find('.form-control').val();
    ele.closest('.wrapper-content-edit').find('.content-edit').html(content);

    var profile = {
        column_name: ele.attr('data-columnname'),
        content: content,
        authenticity_token: $('#token_my').val()
    };



    $.ajax({
        type: "POST",
        url: '/home/update_profile',
        contentType: "application/json; charset=utf-8",
        dataType: 'json',
        data: JSON.stringify(profile),
        success: function (data, status) {
            console.log('success');

        },
        error: function (data, status) {
            console.log('error');
        }
    });

    ele.hide();
    ele.closest('.edit-actions').find('.icon-edit').show();
}; // end icon-save click

//});

function follow() {

    var friendId = $('#btn-follow').attr('data-friendId');

    data = {
        friend_id: friendId,
        authenticity_token: $('#token_my').val()
    };

    $.ajax({
        type: "POST",
        url: '/home/follow',
        contentType: "application/json; charset=utf-8",
        dataType: 'json',
        data: JSON.stringify(data),
        success: function (data, status) {
            if (data['status'] == true) {
                $('#btn-follow').hide();
                $('#btn-unfollow').show();
            }
        },
        error: function (data, status) {
            console.log('error');
        }
    });// end ajax
};// end click

function unfollow() {

    var friendId = $('#btn-unfollow').attr('data-friendId');

    data = {
        friend_id: friendId,
        authenticity_token: $('#token_my').val()
    };

    $.ajax({
        type: "POST",
        url: '/home/unfollow',
        contentType: "application/json; charset=utf-8",
        dataType: 'json',
        data: JSON.stringify(data),
        success: function (data, status) {
            if (data['status'] == true) {
                $('#btn-unfollow').hide();
                $('#btn-follow').show();
//                      $('#btn-follow').text("FOLLOWED").attr('disabled','disabled');
//                      window.location=document.URL;
            }
        },
        error: function (data, status) {
            console.log('error');
        }
    });// end ajax
};// end click
