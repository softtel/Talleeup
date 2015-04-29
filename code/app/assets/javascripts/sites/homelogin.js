$(document).ready(function(){
    //alert(window.innerWidth)
})
function additem(_id,_type)
{
    var _listdatata=$("#listdatata").val();


    var _itemtext = $("#item-component_" + _id + "").text();
    var _html = "";
    _html += "<div class='item-nnnn' id='remove-id-" + _id + "'>";
    _html += "<div class='cls-input-auto' ><div class='text-select-item'>" + _itemtext + "</div><div onclick='closeritem(" + _id + ")' class='cls-close-menu'>x</div></div>";
    _html += "</div>";
    $("#show-data-select").append(_html)

    var _kq = _listdatata + _id+"@"+_type + ";";
    $("#listdatata").val(_kq);

    $("#searcformrr").submit()

}
function closeritem(_id,_type)
{
    var _listdatata=$("#listdatata").val();
    if(_listdatata!="") {
        var _slpit=_listdatata.split(';')
        _listdatata= $.grep(_slpit, function (n, i) {

            if(n!="")
                return n !=_id+"@"+_type;
        });
        var chkd="";
        for(var i=0;i<_listdatata.length;i++)
        {
            chkd=chkd+_listdatata[i]+";";
        }
        var _kq = chkd ;
        $("#listdatata").val(_kq);

    }

    $("#remove-"+_type+"-id-"+_id+"").remove();

    $("#searcformrr").submit()
}
function hovermenu()
{
    $("#menu-filter").toggle("slide");
}
function sendmailaction(_id)
{
    var _email=$("#recipient-name-"+_id+"").val();
    var _message=$("#message-text-"+_id+"").val();
    var _link=$("#link-name-"+_id+"").val();

    if(_email=="")
    {
       $("#error-email-"+_id+"").html("Please input Email !");
        return false;
    }
    if(_email.indexOf('@')==-1 || _email.indexOf('.')==-1)
    {
        $("#error-email-"+_id+"").html("Email is malformed !");
        return false;
    }
    else
    {
        $("#error-email-"+_id+"").html("");
    }
    if(_message=="")
    {
        $("#error-message-"+_id+"").html("Please input message !");
        return;

    }
    else {
        $("#showloadding_"+_id+"").show();
        $("#error-message-"+_id+"").html("");
        $.post("/home/actionSendMail", {email:_email,message:_message,link:_link}, function () {

        }).success(function (data) {

            $("#myModal"+_id+"").modal('hide');
            $("#showloadding_"+_id+"").hide();
        });
    }
}
