$(function() {
    window.addEventListener('message', function(event) {
        if (event.data.isInCoche) {
            $(".todo").addClass('isInCoche');
            $("#llaveicon").addClass('parpadeo');
            $(".velo").html(Math.round(event.data.speed) + "");
            $(".percent-rpm").css("width", (event.data.rpm) + "%");
            $(".marcha").html(Math.round(event.data.marcha) + "");
            $(".fueltext").html(Math.round(event.data.fuel) + "");
            $(".healtext").html(Math.round(event.data.hp) + "");
        } else {
            $(".todo").removeClass('isInCoche');
        }

        if (event.data.seatbelt) {
            $("#llaveicon").removeClass('parpadeo');
        } else {
            $('#llaveicon').fadeIn('normal');
            $("#llaveicon").addClass('parpadeo');
        }

    });
});