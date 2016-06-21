(function () {
    'use strict';
    angular
        .module('bshcPiv')
        .controller('drugDetailsController', drugDetailsController);

    drugDetailsController.$inject = ['drugsService', '$stateParams'];
    
    function drugDetailsController(drugsService, $stateParams) {
        var vm = this;

        drugsService.getDrugDetails($stateParams.id).then(function (response) {
                        
            if (Array.isArray(response.data.data)){
                vm.appCollections = response.data.data;

            } else {
                vm.drugDetails = response.data.data;
            }
        })
        
        
    }
})();