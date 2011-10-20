var page = new WebPage();
page.evaluate(function(){
     var el = document.createElement("div");
     el.innerHTML = "HELLO WORLD";
     document.body.appendChild(el);
});
page.render(phantom.args[1]);
phantom.exit();
/*

function waitFor(testFx, onReady, timeOutMillis) {
    var maxtimeOutMillis = timeOutMillis ? timeOutMillis : 30000, //< Default Max Timout is 3s
        start = new Date().getTime(),
        condition = false,
        interval = setInterval(function() {
            if ( (new Date().getTime() - start < maxtimeOutMillis) && !condition ) {
                // If not time-out yet and condition not yet fulfilled
                condition = (typeof(testFx) === "string" ? eval(testFx) : testFx()); //< defensive code
            } else {
                if(!condition) {
                    // If condition still not fulfilled (timeout but condition is 'false')
                    console.log("'waitFor()' timeout");
                    phantom.exit(1);
                } else {
                    // Condition fulfilled (timeout and/or condition is 'true')
                    console.log("'waitFor()' finished in " + (new Date().getTime() - start) + "ms.");
                    typeof(onReady) === "string" ? eval(onReady) : onReady(); //< Do what it's supposed to do once the condition is fulfilled
                    clearInterval(interval); //< Stop this interval
                }
            }
        }, 10); //< repeat check every 250ms
};


var input = phantom.args[0],
    output = phantom.args[1],
    start = new Date().getTime(),
    page = new WebPage();

page.open(input, function (status) {
    // Check for page load success
    if (status !== "success") {
        console.log("Unable to access network");
    } else {
        // Wait for 'signin-dropdown' to be visible
        waitFor(function() {
            // Check in the page if a specific element is now visible
            return page.evaluate(function() { return typeof RG_READY != "undefined" && RG_READY; });
        }, function() {
           console.log("rendering, total execution time: " + (new Date().getTime() - start) + "ms.");
           page.render(output);
           phantom.exit();
        });        
    }
});
*/