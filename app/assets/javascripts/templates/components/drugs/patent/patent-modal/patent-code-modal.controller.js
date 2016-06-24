(function () {
    'use strict';
    angular
        .module('bshcPiv')
        .controller('patentCodeController', patentCodeController);

    patentCodeController.$inject = ['drugsService', '$stateParams', '$state', '$uibModal', 'codeId'];

    function patentCodeController(drugsService, $stateParams, $state, $uibModal, codeId) {
        var vm = this;


        drugsService.getPatentCode(codeId).then(function (response) {
            vm.patentCode = response.data.data
        })
    }
})();