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
            // $urlRouterProvider.otherwise('/');

            $stateProvider
                .state('drugs', {
                    url: '/',
                    templateUrl: 'drugs/drugs.tpl.html',
                    controller: 'drugsController',
                    controllerAs: 'drugsCtrl'
                })
                .state('paging', {
                    url: '/drugs?page',
                    templateUrl: 'drugs/drugs.tpl.html',
                    controller: 'drugsController',
                    controllerAs: 'drugsCtrl',
                    params: {
                        page: null
                    }
                })
                .state('drug-detail', {
                    url: '/drugs/:id',
                    templateUrl: 'drugs/drug-details/drug-details.tpl.html',
                    controller: 'drugDetailsController',
                    controllerAs: 'detailsCtrl'
                })
                .state('app-detail', {
                    url: '/drugs/application/:id',
                    templateUrl: 'drugs/drug-details/drug-details.tpl.html',
                    controller: 'drugAppController',
                    controllerAs: 'detailsCtrl',
                    params: {
                        id: null
                    }
                })
                .state('app-detail.patent', {
                    url: '/patent/:productId',
                    templateUrl: 'patent/app-details.patent.tpl.html',
                    controller: 'patentController',
                    controllerAs: 'patentCtrl',
                    params: {
                        productId: null,
                        productNumber: null
                    }
                });

        }]);