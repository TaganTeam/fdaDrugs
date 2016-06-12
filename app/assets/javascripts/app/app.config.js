angular
    .module('appName', [
        'ui.router',
        'ngMessages',
        'ngAnimate',
        'angular-storage'
        // 'ui.bootstrap'
        // 'ngTouch'
    ])
    .constant('CONFIG',
        {
            APIHost: 'http://localhost:3000'
        });