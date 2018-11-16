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

//缩放图片到合适大小,如果宽度>高度，宽度=maxwidth，高度等比缩放，反之亦然
function ResizeImages(){
    var myimg,oldwidth,oldheight;
    var maxwidth=85;
    var maxheight=85;
    var maxwidth1=50;
    var maxheight1=50;
    // img 为 img 图片标签
    // 用户头像
    var imgs = document.getElementById('picture-pane').getElementsByTagName('img');
    for(i=0;i<imgs.length;i++){
        myimg = imgs[i];
        if(myimg.width > myimg.height){
            if(myimg.width > maxwidth)
            {
                oldwidth = myimg.width;
                myimg.height = myimg.height * (maxwidth/oldwidth);
                myimg.width = maxwidth;
            }
        }else{
            if(myimg.height > maxheight)
            {
                oldheight = myimg.height;
                myimg.width = myimg.width * (maxheight/oldheight);
                myimg.height = maxheight;
            }
        }
    }
    // 帖子用户头像
    for(j=0;j<100;j++){
        var img = document.getElementsByClassName('picture')[j].getElementsByTagName('img');
        for(i=0;i<img.length;i++){
            myimg = img[i];
            if(myimg.width > myimg.height){
                if(myimg.width > maxwidth1)
                {
                    oldwidth = myimg.width;
                    myimg.height = myimg.height * (maxwidth1/oldwidth);
                    myimg.width = maxwidth1;
                }
            }else{
                if(myimg.height > maxheight1)
                {
                    oldheight = myimg.height;
                    myimg.width = myimg.width * (maxheight1/oldheight);
                    myimg.height = maxheight1;
                }
            }
        }
    }
}

// 检查是否加精, 加精的后面会有数字 1
function isJing(){
    $(".img1").css("display", "block");
    $(".span1").css("color", "RED");
}

// 发送帖子合法性检测
function preSend() {
    if (document.getElementById("comment").value.length != 0 && document.getElementById("title").value.length != 0) {
        return true;
    }
    alert("标题和内容不能为空，请重新输入");
    return false;
}