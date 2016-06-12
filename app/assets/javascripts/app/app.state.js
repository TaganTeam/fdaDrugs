angular
    .module('appName')
    .config([
        '$stateProvider',
        '$httpProvider',
        '$locationProvider',
        '$urlRouterProvider', function(
            $stateProvider,
            $httpProvider,
            $locationProvider,
            $urlRouterProvider) {

            $locationProvider.html5Mode(true);
            $urlRouterProvider.otherwise('/');

            $stateProvider
                .state('root', {
                    url: '/',
                    templateUrl: 'assets/app/components/root/root.tpl.html',
                    controller: 'rootController',
                    controllerAs: 'rootCtrl'
                });

        }]);