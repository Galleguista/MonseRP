$(function () {

    var duracion_notif_med = 7000;
    var duracion_notif_small = 5000;
    var duracion_notif_important = 15000;

    function runAnimEnter(objeto) {
        objeto.animate({right:'-100%'});
        objeto.animate({right:'0.523vw'});
    }

    function runAnimExit(objeto) {
        objeto.animate({right:'0.523vw'}, 500);
        objeto.animate({right:'-100%'}, {complete: function() {
            objeto.css("min-height", "0vw");
            objeto.animate({padding:'0vw', height:'0vw', marginBottom:'0vw'}, {complete: function() {
                objeto.remove();
            }});
        }});
    }

    function runAnimProgress(objeto) {
        objeto.animate({width:'95%'});
        objeto.animate({width:'0%'}, {duration: duracion_notif_small, complete: function() {
            objeto.fadeOut();
        }});
    }

    function runScroll(objeto, callback) {
        objeto.animate({right:'-100%'});
        objeto.animate({right:'400%'}, {duration: 25000, easing: "linear", complete: callback});
    }

    function ShowNormal(tipo, title, text, length) {

        var notification = $('.medium.' + tipo + '.ref').clone();
        notification.find(".title").html(title);
        notification.find(".msg").html(text);

        notification.removeClass('ref');

        //Contenedor lateral derecho
        $('.contenedor-medium').append(notification);

        runAnimEnter(notification);
        runAnimProgress(notification.find(".progressbar"));

        setTimeout(function(){

            notification.contents().animate({opacity: 0}, 1000);
            runAnimExit(notification);

        }, length || duracion_notif_med);
    }

    function ShowSmall(tipo, text,length) {

        var notification = $('.small.' + tipo + '.ref').clone();
        notification.find(".text p").html(text);

        notification.removeClass('ref');

        //Contenedor lateral derecho
        $('.contenedor-medium').append(notification);

        runAnimEnter(notification);
        runAnimProgress(notification.find(".progressbar"));

        setTimeout(function(){

            notification.contents().animate({opacity: 0}, 1000);
            runAnimExit(notification);
            
        },length || duracion_notif_small);
    }

    function ShowImportant(text) {

        var notification = $('.big.broadcast-important.ref').clone();
        notification.find(".text").html(text);
        notification.removeClass('ref');

        //Contenedor Superior
        $('.contenedor-important').append(notification);

        notification.fadeIn(500);
        notification.find(".title").delay(3000).fadeOut(1000);
        notification.find("img").delay(3000).fadeOut(1000);
        notification.find(".text").delay(4000).fadeIn(500);
        
        runScroll(notification.find(".text"), console.log("asd"));

        setTimeout(function(){

            notification.fadeOut(500, function() {
                notification.remove();    
            });
                        
        }, duracion_notif_important + 1000);
    }

    window.addEventListener('message', function (event) {

        let item = event.data;

        switch(item.size) {
            case 'normal': {
                ShowNormal(item.type, item.title, item.text, item.length);
            } break;

            case 'small': {
                ShowSmall(item.type, item.text);
            } break;

            case 'big': {
                ShowImportant(item.text)
            } break;

            default:
                ShowSmall(item.type, item.text, item.length);
        }

    });
})