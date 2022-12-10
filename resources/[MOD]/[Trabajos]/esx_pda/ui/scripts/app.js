let showCadSystem = function(){
    $('#police-cad').show();
    $('#computer').show();
    $('#input-plate').focus();
    $("html").show();
    isCadSystemShowed = true;
}

let hideCadSystem = function(){
    $('#police-cad').hide();
    $('#computer').hide();
    $("html").hide();
    isCadSystemShowed = false;
}

document.addEventListener("DOMContentLoaded", () => {
    $("html").hide();
});

document.onkeydown = function (data) {
    if ((data.which == 120 || data.which == 27) && isCadSystemShowed) { // || data.which == 8
        $.post('http://esx_pda/escape');
    }
};

$(document).on('click','.civ-back', function (ev) {
    $('.civilian-details .inputfield').empty();
    $('.civilian-details').hide(300);
    $('.resultinner').show(300);
});

$(function() {
    window.addEventListener('message', function(event) {

        if (event.data.civilianresults){
            $('.tbody-result-users').remove();
            $('.all-found-users').append($('<tbody class="tbody-result-users">'));
            event.data.civilianresults.forEach(function(user){
                $('.tbody-result-users').append($('<tr>').on('click', function(){
                    showExtraUserData(user);
                })
                    .append($('<td>').text(user['firstname']))
                    .append($('<td>').text(user['lastname']))
                    .append($('<td>').text(user['sex']))
                    .append($('<td>').text(user['dateofbirth']))
					.append($('<td>').text(user['name'])));
            })
        }

        if (event.data.crresults){
           createTableCr(event.data.crresults);
        }
        if(event.data.note_deleted){
            playerid = JSON.stringify({ playerid: $('#cr-playerid').val() });
            $.post('http://esx_pda/get-note', playerid );

            noteMessage = $('.note-message');
            noteMessage.empty();
            noteMessage.text('Nota eliminada'); 
            setTimeout(function(){
                noteMessage.empty();
            },2000);


        }
        if(event.data.note_not_deleted){
            noteMessage = $('.note-message');
            noteMessage.empty(); 
            noteMessage.text('Nota fallida');
            setTimeout(function(){
                noteMessage.empty();
            },2000);
        }

        if(event.data.cr_deleted){
            playerid = JSON.stringify({ playerid: $('#cr-playerid').val() });
            $.post('http://esx_pda/get-cr', playerid );

            crMessage = $('.cr-message');
            crMessage.empty();
            crMessage.text('Antecedente eliminado');
            setTimeout(function(){
                crMessage.empty();
            },2000);


        }

        if(event.data.bolo_not_deleted){
            boloMessage = $('.error-bolo');
            boloMessage.empty();
            boloMessage.text('La eliminacion solicitada fallo');
            setTimeout(function(){
                boloMessage.empty();
            },2000);
        }

        if(event.data.bolo_deleted){
            playerid = JSON.stringify({ playerid: $('#cr-playerid').val() });
            $.post('http://esx_pda/get-bolos' );
            boloMessage = $('.bolo-message');
            boloMessage.empty();
            boloMessage.text('ByC eliminada'); 
            setTimeout(function(){
                boloMessage.empty();
            },2000);


        }


        if(event.data.cr_not_deleted){
            crMessage = $('.cr-message');
            crMessage.empty();
            crMessage.text('Intentelo de nuevo');
            setTimeout(function(){
                crMessage.empty();
            },2000);
        }

        if (event.data.noteResults){
            createNoteTable(event.data.noteResults);
        }

        if (event.data.licenseResults){
            createTableLicense(event.data.licenseResults);
        }
        // if (event.data.photoFinish){
        //     createTablePhotoFinish(event.data.photoFinish);
        // }

        if (event.data.showBolos){
            createBoloTable(event.data.showBolos);
        }

        if (event.data.plate){
            $('#plate').empty().append(event.data.plate);
            $('#model').empty().append(event.data.model);
            $('#firstname').empty().append(event.data.firstname);
            $('#lastname').empty().append(event.data.lastname);
        }

        if(event.data.showCadSystem === true){
            showCadSystem();
        }

        if(event.data.showCadSystem === false){
            hideCadSystem();
        }

    });

    document.onkeydown = function (data) {
        if ((data.which == 13)){
            searchPlate();
        }

        if ((data.which == 120 || data.which == 27) && isCadSystemShowed) { // || data.which == 8
            $.post('http://esx_pda/escape');
            hideCadSystem();
        }
    };

    $(document).on('click','#search-for-plate',function(event){
        searchPlate();
    });

    $(document).on('click','.police-cad-close',function(event){
        $.post('http://esx_pda/escape');
        hideCadSystem();
    });

    $(document).on('click','.civ-back', function (ev) {
        $('.resultinner').show(300);
    });

    $(document).on('click','.add-cr', function (ev) {
        $('.modal-add-record').show(300);
        $(".modal-add-note").hide(400);
        $(".modal-add-licencia").hide(400);
        $(".modal-add-photo").hide(400);
    });
     $(document).on('click','.add-licencia', function (ev) {
        $('.modal-add-licencia').show(300);
        $(".modal-add-record").hide(400);
        $(".modal-add-note").hide(400);
        $(".modal-add-photo").hide(400);
    });
      $(document).on('click','.add-photo', function (ev) {
        $('.modal-add-photo').show(300);
        $(".modal-add-record").hide(400);
        $(".modal-add-note").hide(400);
        $(".modal-add-licencia").hide(400);
    });

    $(document).on('click','.add-bolo', function (ev) {
        $('.modal-add-bolos').show(300);
    });

    $(document).on('click','#save-criminal-record', function (ev) {
        if($('#cr-reason').val().length > 2){
            addCR();
            $('.modal-add-record').hide(400);

            playerid = JSON.stringify({ playerid: $('#cr-playerid').val() });
            $.post('http://esx_pda/get-cr', playerid );
        }else{
            $('.error-cr').text('Completa todos los campos');
        }
    });

    $(document).on('click','.add-note', function (ev) {
        $('.modal-add-note').show(300);
        ($('#note-title').val(''));
        ($('#note-content').val(''));
        $(".modal-add-record").hide(400);
        $(".modal-add-licencia").hide(400);
        $(".modal-add-photo").hide(400);
    });


    $(document).on('click','.delete_note' ,function () {
        note = JSON.stringify({ id:  $(this).data('id') });
        $.post('http://esx_pda/delete_note', note);
    });

    $(document).on('click','.delete_cr' ,function () {
        cr = JSON.stringify({ id:  $(this).data('id') });
        $.post('http://esx_pda/delete_cr', cr);
    });


    $(document).on('click','#save-note', function (ev) {
        if($('#note-title').val().length > 1 && $('#note-content').val().length > 1){
            addNote();
            $('.modal-add-note').hide(400);
            playerid = JSON.stringify({ playerid: $('#cr-playerid').val() });
            $.post('http://esx_pda/get-note', playerid );
        }else{
            $('.error-note').text('Completa todos los campos');
        }
    });

     $(document).on('click','#save-licencia', function (ev) {
        if($('#licencia-title').val() == 'vuelo' || $('#licencia-title').val() == 'armas' || $('#licencia-title').val() == 'caza' || $('#licencia-title').val().length == 0){
            addLicencia();
            $('.modal-add-licencia').hide(400);
            playerid = JSON.stringify({ playerid: $('#cr-playerid').val() });
            $.post('http://esx_pda/get-licencia', playerid );
        }else{
            $('.error-licencia').text('No es una licencia válida.');
        }
    });
      $(document).on('click','#save-photo', function (ev) {
            addPhoto();
            $('.modal-add-photo').hide(400);
            playerid = JSON.stringify({ playerid: $('#cr-playerid').val() });
            $.post('http://esx_pda/get-photo', playerid );
    });
    $(document).on('click','#delete-licencia', function (ev) {
        if($('#licencia-title').val() == 'vuelo' || $('#licencia-title').val() == 'armas' || $('#licencia-title').val() == 'caza'){
            removeLicencia();
            $('.modal-add-licencia').hide(400);
            playerid = JSON.stringify({ playerid: $('#cr-playerid').val() });
            $.post('http://esx_pda/get-licencia', playerid );
        }else{
            $('.error-licencia').text('No es una licencia válida.');
        }
    });

    $(document).on('click','#save-bolos', function (ev) {
        bolo = JSON.stringify({
            name: $('#input-bolos-gender').val(),
            lastname: $('#input-bolos-height').val(),
            apperance: $('#input-bolos-age').val(),
            type_of_crime: $('#input-bolos-type-of-crime').val(),
            fine: $('#input-bolos-note').val()
        });

        $.post('http://esx_pda/add-bolo', bolo);
        $('.modal-add-bolos').hide(300);
    });

    $(document).on('click','.delete_bolo' ,function () {
        bolo = JSON.stringify({ id:  $(this).data('id') });
        $.post('http://esx_pda/delete-bolo', bolo);
    });


    $(document).on('click','#search-for-civilian',function(event){
        searchPlayer();
    });

    function searchPlate(){
        plate = JSON.stringify({ plate: $('#input-plate').val() });
        $.post('http://esx_pda/search-plate', plate);
    }

    function addCR(){
        criminalRecord = JSON.stringify({ reason: $('#cr-reason').val(), fine: $('#cr-fine').val(), time: $('#cr-time').val(), playerid: $('#cr-playerid').val() });
        $.post('http://esx_pda/add-cr', criminalRecord);
    }
   function addLicencia(){
        licencia = JSON.stringify({ title: $('#licencia-title').val(), playerid: $('#cr-playerid').val()});
        $.post('http://esx_pda/add-licencia', licencia);
    }
     function addPhoto(){
        photo = JSON.stringify({ title: $('#photo-title').val(), playerid: $('#cr-playerid').val()});
        $.post('http://esx_pda/add-photo', photo);
    }
    function removeLicencia(){
        licencia = JSON.stringify({ title: $('#licencia-title').val(), playerid: $('#cr-playerid').val()});
        $.post('http://esx_pda/remove-licencia', licencia);
    }

    function addNote(){
        note = JSON.stringify({ content: $('#note-content').val(), title: $('#note-title').val(), playerid: $('#cr-playerid').val()});
        $.post('http://esx_pda/add-note', note);
    }

    $(document).on('click', '.police-cad-menu li', function () {
        var id = $(this).data('id');
        $('.active').removeClass('active');
        $(this).addClass('active');

        hidePlateChecker();

        if($(this).data('id') == 'plate-checker'){
            showPlateChecker();
        }
        
        if ( id == 'bolos'){
            $.post('http://esx_pda/get-bolos');
        }

        $('.page').hide();
        $('#'+id).show();
        $('input').focus();
    });
});

function showPlateChecker(){
    $('#plate-checker').show();
}
function hidePlateChecker(){
    $('#plate-checker').hide();
}

function createTableCr(crresults){
    $('#criminal-records tbody').html('');
    crresults.forEach(function(cr){
        $('#criminal-records tbody').append($('<tr>')
            .append($('<td>').text(cr['reason']))
            .append($('<td>').text(cr['fine']))
            .append($('<td>').text(cr['time']))
            .append($('<td>').append($('<span class="delete_cr" data-id="'+ cr['id'] +'">').text('X'))));
    })
}

function createNoteTable(noteResults){
    $('#notes tbody').html('');
    noteResults.forEach(function(notes){
        $('#notes tbody').append($('<tr>')
            .append($('<td>').text(notes['title']))
            .append($('<td>').text(notes['content']))
            .append($('<td>').text(notes['created_at']))
            .append($('<td>').append($('<span class="delete_note" data-id="'+ notes['id'] +'">').text('X')))

        );
    })
}

function createBoloTable(boloResults){
    $('.police-cad-bolos tbody').html('');
    boloResults.forEach(function(bolo){
        $('.police-cad-bolos tbody').append($('<tr>')
            .append($('<td>').text(bolo['name']))
            .append($('<td>').text(bolo['lastname']))
            .append($('<td>').text(bolo['apperance']))
            .append($('<td>').text(bolo['type_of_crime']))
            .append($('<td>').text(bolo['fine']))
            .append($('<td>').append($('<span class="delete_bolo" data-id="'+ bolo['id'] +'">').text('X')))

        );
    })
}

function createTableLicense(licenseResults){
    var prueba = licenseResults.split('+')
    var i;
    for (i = 0 ; i < prueba.length ; i++){
        $('#licenses tbody').append($('<tr>')
            .append($('<td>').text(prueba[i])));
         // $('#licenses tbody').append($('<tr>')
         //     .append($('<td>').text(licenseResults)));
    }
}
// function createTablePhotoFinish(photoFinish){
//     alert(photoFinish)
//      document.getElementById("image").src=photoFinish
// }
function showExtraUserData(user){
    $('#criminal-records tbody').html('');
    $('#licenses tbody').html('');
    $('.resultinner').hide(300);
    $('.civilian-details').show(300);

    $('#cr-playerid').val(user.identifier);
	$('.steam-label').text('Steam');
    $('.steam').text(user.name);
	
    $('.firstname-label').text('Nombre');
    $('.firstname').text(user.firstname);

    $('.lastname-label').text('Apellido');
    $('.lastname').text(user.lastname);

    $('.sex-label').text('Sexo');
    $('.sex').text(user.sex);

    $('.dob-label').text('Fecha de Nacimiento'); 
    $('.dob').text(user.dateofbirth);

    $('.height-label').text('Altura');
    $('.height').text(user.height);

    $('.job-label').text('Trabajo');
    $('.job').text(user.job);
    var persona = user.job
    if (persona == 'banda' || persona == 'banda2' || persona == 'banda3' ||
        persona == 'banda4' || persona == 'banda5'){
                $('.job').text('Desconocido');
    }else{
        $('.job').text( user.job);
    }

	
	$('.bank-label').text('Banco');
    $('.bank').text(user.bank);
	
	$('.phone_number-label').text('Teléfono');
    $('.phone_number').text(user.phone_number);

    document.getElementById("image").src=user.foto
    $('.photo-label').text('Foto');
    $('.photo').text(user.foto);


    playerid = JSON.stringify({ playerid: user.identifier });
    $.post('http://esx_pda/get-cr', playerid );

    $.post('http://esx_pda/get-note', playerid );
    // $.post('http://esx_pda/get-photo', playerid );

    $.post('http://esx_pda/get-license', playerid );

}

function searchPlayer(){
    search = JSON.stringify({ search: $('#search').val() });
    $.post('http://esx_pda/search-players', search);
}





