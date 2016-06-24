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
            getAppDetails: getAppDetails,
            getPatents: getPatents,
            getPatentCode: getPatentCode,
            getExclusivityCode: getExclusivityCode
        };

        function getDrugs(page) {
            return  $http.get(CONFIG.APIDevHost + '/api/v1/drugs', {
                params:{
                    page: page
                }
            })
        }
        
        function getDrugDetails(drugId) {
            return  $http.get(CONFIG.APIDevHost + '/api/v1/drugs/' + drugId)
        }

        function getAppDetails(appId) {
            return  $http.get(CONFIG.APIDevHost + '/api/v1/drugs/application/' + appId)
        }
        
        function getPatents(appId, productId) {
            return  $http.get(CONFIG.APIDevHost + '/api/v1/drugs/application/' + appId + '/patent/' + productId)
        }

        function getPatentCode(codeId) {
            return  $http.get(CONFIG.APIDevHost + '/api/v1/drugs/patent-code/' + codeId)
        }
        
        function getExclusivityCode(exCodeId) {
            return  $http.get(CONFIG.APIDevHost + '/api/v1/drugs/exclusivity-code/' + exCodeId)
        }

    }
})();