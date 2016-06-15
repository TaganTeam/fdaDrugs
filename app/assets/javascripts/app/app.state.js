angular
    .module('bshcPiv')
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
                .state('drugs', {
                    url: '/',
                    templateUrl: 'assets/app/components/drugs/drugs.tpl.html',
                    controller: 'drugsController',
                    controllerAs: 'drugsCtrl'
                })
                .state('paging', {
                    url: '/drugs?page',
                    templateUrl: 'assets/app/components/drugs/drugs.tpl.html',
                    controller: 'drugsController',
                    controllerAs: 'drugsCtrl'
                });

        }]);