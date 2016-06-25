(function () {
    'use strict';
    angular
        .module('bshcPiv')
        .controller('drugsController', drugsController);

    drugsController.$inject = ['drugsService', '$location', '$stateParams', '$scope'];

    function drugsController(drugsService, $location, $stateParams, $scope) {
        var vm = this;
        vm.pageChanged = pageChanged;

        vm.maxSize = 10;
        vm.currentPage = $stateParams.page || 1;
        vm.perPage = 25;


        drugsService.getDrugs(vm.currentPage).then(function (response) {
            vm.drugs = response.data.data;
            vm.totalItems = response.data.all_count;
        });

        function pageChanged(page) {
            $location.url('/drugs?page=' + page);
        }


        
    }
})();