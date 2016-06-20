(function () {
    'use strict';
    angular
        .module('bshcPiv')
        .factory('drugsService', drugsService);

    drugsService.$inject = ['$http', 'CONFIG'];

    function drugsService($http, CONFIG) {
        return {
            getDrugs: getDrugs,
            getDrugDetails: getDrugDetails,
            getAppDetails: getAppDetails
        };

        function getDrugs(page) {
            return  $http.get(CONFIG.APIProductionHost + '/api/v1/drugs', {
                params:{
                    page: page
                }
            })
        }
        
        function getDrugDetails(drugId) {
            return  $http.get(CONFIG.APIProductionHost + '/api/v1/drugs/' + drugId)
        }

        function getAppDetails(appId) {
            return  $http.get(CONFIG.APIProductionHost + '/api/v1/drugs/application/' + appId)
        }

    }
})();