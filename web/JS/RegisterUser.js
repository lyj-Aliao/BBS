var key = 0;
function preRegister() {
    if ($('#user')[0].value.length>0 && $('#password')[0].value.length>0 && $('#emailAddress')[0].value.length>0 && $('#captcha')[0].value.length>0 && $('#againPW')[0].value.length>0 && $('#name')[0].value.length>0) {
        if (key) {
            if ($('#againPW')[0].value == $('#password')[0].value){
                if ($("#check")[0].checked) {
                    return true;
                }
                alert("请阅读用户协议");
                return false;
            }
            alert("密码不一致，请重新输入");
        }else {
            alert("密码太弱，请重新输入");
        }
        return false;
    }
    alert("所有内容均为必填项，请重新输入");
    return false;
}

function myFunction2(i,j){
    key = 0;
    if( j<2 || $("#password")[0].value.length<=8 ){
        $("#innerprogress")[0].style.backgroundColor="red";

    }else if( ((i+j)==6) && $("#password")[0].value.length>12 ){

        $("#innerprogress")[0].style.backgroundColor="#2ddf01";
        $("#innerprogress")[0].style.width="100%";
        key = 1;
    }else{
        $("#innerprogress")[0].style.backgroundColor="#ecc122";
        key = 1;
    }
    if((i+j)==1)
        $("#innerprogress")[0].style.width="10%";
    if((i+j)==2)
        $("#innerprogress")[0].style.width="28%";
    if((i+j)==3)
        $("#innerprogress")[0].style.width="46%";
    if((i+j)==4)
        $("#innerprogress")[0].style.width="64%";
    if((i+j)==5)
        $("#innerprogress")[0].style.width="82%";
}
function myFunction3(){
    var i = 0,j = 0;
    var txt = $("#password")[0].value;
    if ( $("#password")[0].value.length>0 ) {
        if (/[a-z]/.test(txt)) {j++}					//小写字母
        if (/[A-Z]/.test(txt)) {j++}					//大写字母
        if (/\d/.test(txt))    {i++}					//数字
        if (/\W/.test(txt))    {i++}					//特殊字符
        if ( !(/(.)\1{1,}/g.test(txt)) && ( $("#password")[0].value.length>2) )   {i++}	 				  //重复字符
        if ( !(/(.{3})(.*)\1+/g.test(txt)) && ( $("#password")[0].value.length>6) ) {i++}					//重复子字符串
    }else{
        $("#innerprogress")[0].style.width="0%";
    }
    return myFunction2(i,j);
}
function check(){
    $("#check").attr("checked","true");
}

//发送验证码按钮自动恢复
function reClick(){
    $.ajax({
        type: "Get",
        url: "LoginServlet?emailAddress="+document.getElementById("emailAddress").value,
        success: function(){
            alert("发送成功，请检查您的邮箱")
        }
    })

    document.getElementById('captcha').disabled=false;
    document.getElementById('sendCode').disabled=true;
    document.getElementById("sendCode").value="10 秒后可再发送";
    x=10;
    timer = setInterval(go, 1000);
}
var timer = null;
var x=10; //利用了全局变量来做倒计时
function go(){
    x--;
    if(x>0){
        document.getElementById("sendCode").value=x+" 秒后可再发送";
    }else{
        document.getElementById("sendCode").value="点击发送";
        document.getElementById('sendCode').disabled=false;
        clearInterval(timer);
    }
}