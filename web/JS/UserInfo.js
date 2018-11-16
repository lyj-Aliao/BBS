function Reload(){
    // 获取发帖数，评论数
    $.ajax({
        type: "Post",
        url: "UserServlet",
        dataType: "json",
        data: "isOther=0",
        success: function(text){
            setContents(text);
        }
    })
}

// div 不刷新切换
$(function(){
    ui_control(0);  // 0 表示初始显示第一个 div
    $(".tab_content").height($(document).height()-200);
});
function ui_control(aType){    //tabs-start
    $("ul.tab_title li:eq(0)").addClass("select");
    $(".tab_content:eq(0)").show();

    $("ul.tab_title li").each(function(i){
        $(this).click(function(){
            //i=i+1;
            //alert(i);
            $(".tab_content:eq("+i+")").show().siblings().hide();
            $(this).addClass("select").siblings().removeClass("select");
        });
    });
    $("ul.tab_title li:eq("+aType+")").click();
    //tabs_end
}

// 搜索框智能提示
function search(){
    // 获得用户输入
    var content = document.getElementById("search");
    if (content.value == ""){
        clearContent();
        return ;
    }

    // 向服务器通过 ajax 异步发送数据
    $.ajax({
        type: "Post",
        dataType: "json",
        data: "keyword="+content.value,
        url: "SearchServlet",
        success: function (text) {
            var array = new Array();
            var idList = new Array();
            $.each(text,function(i,n){
                array[i] = n["title"];
                idList[i] = n["id"];
            })
            setContent(array, idList);
        }
    })

}

$('#content_table_body').onblur(function () {
    clearContent();
})

// 关联数据的展示，参数是服务器传递过来的关联数据
function setContent(contents, pid){
    // 获得获得关联数据长度，以此确定生成多少行
    var size = contents.length;
    clearContent();
    // 内容
    for (var i=0;i<size;i++){
        // 第 i 个元素
        var nextNode = contents[i];
        var nextLink = pid[i];
        var a = document.createElement("a");
        a.href = "CommentServlet?pid="+nextLink+"&page=1";
        a.style = "text-decoration:none; display:inline-block; width: 100%; height: 30px; line-height: 30px;";
        var tr = document.createElement("tr");
        var td = document.createElement("td");
        var text = document.createTextNode(nextNode);
        a.appendChild(text);
        td.appendChild(a);
        tr.appendChild(td);
        document.getElementById("content_table_body").appendChild(tr);
    }
}

function clearContent() {
    var contentBody = document.getElementById("content_table_body");
    var size = contentBody.childNodes.length;
    for (var i=size-1;i>=0;i--){
        contentBody.removeChild(contentBody.childNodes[i]);
    }
}

function setContents(contents) {

    var td = document.createElement("td");
    var text = document.createTextNode(contents[0]);
    td.appendChild(text);
    document.getElementById("postCount").appendChild(td);
    text = document.createTextNode(contents[1]);
    td = document.createElement("td");
    td.appendChild(text)
    document.getElementById("commentCount").appendChild(td);
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