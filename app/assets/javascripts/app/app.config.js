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
            APIProductionHost: 'https://bshcpiv.herokuapp.com/'
        });