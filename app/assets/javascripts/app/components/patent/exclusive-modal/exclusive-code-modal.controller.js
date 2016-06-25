(function () {
    'use strict';
    angular
        .module('bshcPiv')
        .controller('exclusiveCodeController', exclusiveCodeController);

    exclusiveCodeController.$inject = ['drugsService', '$stateParams', '$state', '$uibModal', 'exCodeId'];

    function exclusiveCodeController(drugsService, $stateParams, $state, $uibModal, exCodeId) {
        var vm = this;


        drugsService.getExclusivityCode(exCodeId).then(function (response) {
            vm.exclusivityCode = response.data.data
        })
    }
})();