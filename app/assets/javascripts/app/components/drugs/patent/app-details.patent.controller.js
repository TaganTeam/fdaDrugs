(function () {
    'use strict';
    angular
        .module('bshcPiv')
        .controller('patentController', patentController);

    patentController.$inject = ['drugsService', '$stateParams', '$state', '$uibModal'];

    function patentController(drugsService, $stateParams, $state, $uibModal) {
        var vm = this;
        vm.patentCodeInfo = patentCodeInfo;
        vm.exclusiveCodeInfo = exclusiveCodeInfo;
        vm.productNumber = $state.params.productNumber;

                
        drugsService.getPatents($stateParams.id, $stateParams.productId).then(function (response) {
            vm.patents = response.data.data[0];
            vm.exclusivities = response.data.data[1];
        });

        function patentCodeInfo(id) {
            $uibModal.open({
                animation: true,
                templateUrl: 'patent-modal/patent-code-modal.tpl.html',
                controller: 'patentCodeController',
                controllerAs: 'patentCodeCtrl',
                resolve: {
                    codeId: function () {
                        return id;
                    }
                }
            });
        }
        
        function exclusiveCodeInfo(id) {
            $uibModal.open({
                animation: true,
                templateUrl: 'exclusive-modal/exclusive-code-modal.tpl.html',
                controller: 'exclusiveCodeController',
                controllerAs: 'exclusiveCodeCtrl',
                resolve: {
                    exCodeId: function () {
                        return id;
                    }
                }
            });
        }
        
        


    }
})();