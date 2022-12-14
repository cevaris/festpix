/**
For stateful flash notifications 

message: string message to render in flash element
state: state of the flash notification
 - error
 - success
 - info
fadout: N milliseconds which the flash is to be shown, then fades out

Returns false if no message is provided
e.g. pushFlash({message: 'test', state:'success', fadeOut: 3000});
*/
var pushFlash = function(options){

    var config = {
        state  : false,
        // fadeOut : 3000,
        message : false,
    };

    // Update fields with options
    $.extend(config, options);
    
    var mainContainer  = $("#main-container");
    var flashContainer = $("#flash-container");
    var cancelButton = '<button type="button" class="close" data-dismiss="alert">&times;</button>';
    var customState = '';

    // Remove any stale flashes
    flashContainer.remove();

    // If no message was provided, do not render flash notificaiton
    if (!config.message) return false;

    // Apply custom state to flash notification
    if (config.state) {
        customState = ' alert-'+config.state;
    } 

    // Render the flash notificaiton
    mainContainer.prepend('<div id="flash-container" class="alert'+customState+' alert-float">'+cancelButton+config.message+'</div>');
    // Get access to newly created container
    flashContainer = $("#flash-container");
    
    // Apply custom state to flash notification
    // if (config.fadeOut == undefined) {
    //  config.fadeOut = 3000;
    // } 

    // flashContainer.effect('highlight',{},config.fadeOut);

    if (config.fadeOut != undefined) {
        // Sets timer to fade out in N milliseconds
        window.setInterval( function() {flashContainer.fadeOut('slow');}, config.fadeOut );
    }

    

    return true;
}