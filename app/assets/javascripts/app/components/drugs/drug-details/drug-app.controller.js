(function () {
    'use strict';
    angular
        .module('bshcPiv')
        .controller('drugAppController', drugAppController);

    drugAppController.$inject = ['drugsService', '$stateParams'];

    function drugAppController(drugsService, $stateParams) {
        var vm = this;

        drugsService.getAppDetails($stateParams.id).then(function (response) {
            vm.drugDetails = response.data.data;
        })


    }
})();