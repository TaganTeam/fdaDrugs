(function () {
    'use strict';
    angular
        .module('bshcPiv')
        .factory('drugsService', drugsService);

    drugsService.$inject = ['$http', 'CONFIG'];

    function drugsService($http, CONFIG) {
        return {
            getDrugs: getDrugs
        };

        function getDrugs(page) {
            return  $http.get(CONFIG.APIHost + '/api/v1/drugs', {
                params:{
                    page: page
                }
            })
        }

    }
})();