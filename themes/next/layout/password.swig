<script src="https://cdn.staticfile.org/jquery/3.1.1/jquery.min.js"></script>
<script>
    //暂时储存文章中的内容
    var div = $('.post-body');
    //暂时储存目录的内容
    var toc=$('.post-toc')
    function password() {
        if('{{ page.password }}'){
            //将文章内容删除
            div.remove();
            //将目录删除
            toc.remove();
            //将文章删除后，向原来文章的地方添加，应该出现的提示用户输入密码的样式
            //下面这里的第一个用textarea是因为如果在手机端的时候只能显示一部分文字，
            //只是拓展:input里面的字只能显示一行，不会自动换行，目前上网搜索没有发现好的办法，所以用了textarea，右下角的小三角通过resize:none 去掉。
            $('.post-header').after(
            '<span class="description" value="请输入密码，然后按 Enter 键阅读" style="font-style: oblique;font-weight: bold;border: none;display: block;'+
            'width: 60%;margin: 0 auto;text-align: center;outline: none;margin-bottom: 40px;resize:none ">'+
            '<i class="fa fa-heartbeat" id="myheartbeat"></i>'+
            '请输入密码，然后按 Enter 键阅读' +
            '<i class="fa fa-heartbeat" id="myheartbeat"></i>'+
            '</span>' +
            '<div class="qiang" style="height: 100px;width: 60%;margin:0 auto">' +
            '<input class="password"  type="password" autocomplete="new-password" autofocus="autofocus" value="" style="border-radius: 5px;height: 30px;border: none;display: block;border-bottom: 1px solid #ccc;' +
            'margin: 0 auto;outline: none;width:95%"/>' +
            '</div>')
            //绑定点击事件，如果是点击的.password 这个div就改变样式，如果是document中除了div之外的其他任何元素，就变回原来的样式。
            document.onclick = function (event) {
                var e = event || window.event;
                var elem = e.srcElement || e.target;

                while (elem) {
                    if (elem != document) {
                        if (elem.className == "password") {
                            //$(".password").animate({paddingTop:"30px",width:"100%",borderWidth:"2px"},300)
                            return;
                        }
                        elem = elem.parentNode;
                    } else {
                        //$(".password").animate({paddingTop:"0px",width:"95%",borderWidth:"1px"},300)
                        return;
                    }
                }
            }
            //绑定enter键按下后离开的事件
            $(document).keyup(function(event){
                if(event.keyCode ==13&&$('.password').length>0){
                    //console.log($('.password').val())
                    //console.log('{{ page.password }}')
                    if ($('.password').val() == '{{ page.password }}') {
                        //恢复文章内容
                        (div).appendTo($(".post-header"))
                        //恢复目录
                        toc.appendTo($(".sidebar-inner"))
                        //删除本页面的输入密码组件
                        $(".description").remove();
                        $(".qiang").remove();
                        $(".password").remove();

                        //重新处理pjax事件,如果没有加pjax的从下面这行起到下面的else之间的代码需要去掉。
                        //图片懒加载，没有加入此功能的这个函数需要去掉
                        $('img').lazyload({
                            placeholder: '/images/loading.gif',
                            effect: 'fadeIn',
                            threshold : 100,
                            failure_limit : 20,
                            skip_invisible : false
                        });
                        //pjax后出现文章不显示，没有pjax的下面四行需要去掉
                        $(".post-block").css({opacity:1});
                        $(".post-header").css({opacity:1});
                        $(".post-body").css({opacity:1});
                        $(".pagination").css({opacity:1});
                    }else {
                        alert("对不起，密码输入错误。")
                    }
                }
                //将document的keyup移除，防止在pjax的情况下会重复绑定事件
            });
        }
    }
    password();
</script>