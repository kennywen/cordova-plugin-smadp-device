var exec = require('cordova/exec');

exports.isJailbroken = function(success, error) {
    exec(success, error, "SLDevice", "isJailbroken", []);
};

exports.uuidForDevice = function(success, error) {
    exec(success, error, "SLDevice", "uuidForDevice", []);
};