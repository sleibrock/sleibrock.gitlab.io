// a very empty javascript library

// easy var to check for to see if library is loaded
var STOVELIB = 1;

var $ = function(id) {
    return window.document.getElementById(id);
};

var rand = function() {
    return Math.random();
};

var randp = function(low, high) {
    var r = low < high;
    var l = r ? low : high;
    var h = r ? high : low;
    return Math.round(l + (Math.random()*(h-l)));
};

// end
