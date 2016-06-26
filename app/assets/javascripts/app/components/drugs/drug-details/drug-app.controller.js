(function () {
    'use strict';
    angular
        .module('bshcPiv')
        .controller('drugAppController', drugAppController);

    drugAppController.$inject = ['drugsService', '$stateParams', '$state', '$scope'];

    function drugAppController(drugsService, $stateParams, $state, $scope) {
        var vm = this;
        vm.openPatentInfo = openPatentInfo;
        vm.isActive = isActive;

        drugsService.getAppDetails($stateParams.id).then(function (response) {
            vm.drugDetails = response.data.data;
        });

        function isActive(product) {
            return $scope.selected === product;
        }

        function openPatentInfo(productId, productNumber, product) {
            $scope.selected = product;
            $state.go('app-detail.patent', {
                productId: productId,
                productNumber: productNumber
            })
        }

    }
})();
