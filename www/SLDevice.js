var exec = require('cordova/exec');

exports.isGenuine = function(success, error) {
    exec(success, error, "SLDevice", "isGenuine", []);
};

exports.uuidForDevice = function(success, error) {
    exec(success, error, "SLDevice", "uuidForDevice", []);
};