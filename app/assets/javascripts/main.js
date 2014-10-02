// $(document).ready(function(){ 

    $( '.clickable' ).on( "click", function() {
        window.location = $(this).attr('data-url');
    });
  // $('.clickable').click(function() {
  //   window.location = $(this).attr('data-url');
  // });

// });