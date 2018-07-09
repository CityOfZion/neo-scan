// Brunch automatically concatenates all files in your
// watched paths. Those paths can be configured at
// config.paths.watched in "brunch-config.js".
//
// However, those files will only be executed if
// explicitly imported. The only exception are files
// in vendor, which are never wrapped in imports and
// therefore are always executed.

// Import dependencies
//
// If you no longer want to use a dependency, remember
// to also remove its path from "config.paths.watched".
import 'phoenix_html'
import 'jquery'

// Import local files
//
// Local files can be imported directly using relative
// paths "./socket" or full ones "web/static/js/socket".

import socket from './home_app'

const moment = require("moment");

const get_local_time = time => {
    return (moment.unix(time).format('DD-MM-YYYY') + ' | ' + moment.unix(time).format('HH:mm:ss'))
}

function isNumber(n) {
    return !isNaN(parseFloat(n)) && isFinite(n);
}

var x = document.getElementsByClassName("utc_time");
var i;
for (i = 0; i < x.length; i++) {
    if(isNumber(x[i].innerHTML)){
        x[i].innerHTML = get_local_time(x[i].innerHTML);
    }
}