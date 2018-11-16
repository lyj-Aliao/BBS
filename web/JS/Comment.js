

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

function hideAndDisplay(i){
    if ($("#reply_area"+i).css('display')==('block')){
        $("#reply_area"+i).css("display","none");
    }else{
        $("#reply_area"+i).css("display","block");
    }
}
function hideAndDisplay2(i){
    if ($("#replyDiv"+i).css('display')==('block')){
        $("#replyDiv"+i).css("display","none");
    }else{
        $("#replyDiv"+i).css("display","block");
    }
}

function preSend() {
    if (document.getElementById("comment").value.length != 0) {
        return true;
    }
    alert("输入为空，请重新输入");
    return false;
}