angular
    .module('bshcPiv', [
        'ui.router',
        'ngMessages',
        'ngAnimate',
        'angular-storage',
        'ui.bootstrap',
        'ngTouch'
    ])
    .constant('CONFIG',
        {
            APIDevHost: 'http://localhost:3000',
            APIProductionHost: 'http://139.59.172.75/'
        });