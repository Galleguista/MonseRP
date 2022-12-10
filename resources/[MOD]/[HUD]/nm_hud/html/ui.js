$(document).ready(function() {
    window.addEventListener('message', function(event) {
        var data = event.data;

        if(event.data.showhud == false){
            $('.container').show();
        }

        if (event.data.action == "updateStatus") {
            updateStatus(event.data.st);
        }

        if (data.armor > 0 ) {
            $("#boxArmor").css("width", data.armor + "%"); 
            $('#heal').show(); 
            $('#stamina').show();
            $('#boxHeal').show(); 
            $('#boxStamina').show(); 
            $('#boxArmor').show();
            $('#armor').show(); 
            $('#boxThirst').css('width', (event.data.bebida) + "%");
            $('#boxHunger').css('width', (event.data.comida) + "%");
        }
    else
        if (data.armor == 0 ) {
            $("#boxHeal").css("width", data.health + "%"); 
            $("#boxStamina").css("width", data.stamina + "%");
            $('#boxArmor').hide(); 
            $('#armor').hide();
            $('#heal').show(); 
            $('#stamina').show(); 
            $('#boxHeal').show(); 
            $('#boxStamina').show();
            $('#boxThirst').css('width', (event.data.bebida) + "%");
            $('#boxHunger').css('width', (event.data.comida) + "%");
            }
       
    })
})


