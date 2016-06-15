(function () {
    'use strict';
    angular
        .module('bshcPiv')
        .controller('drugsController', drugsController);

    drugsController.$inject = ['drugsService', '$location', '$stateParams'];

    function drugsController(drugsService, $location, $stateParams) {
        var vm = this;
        vm.pageChanged = pageChanged;

        vm.maxSize = 5;
        vm.currentPage = $stateParams.page || 1;
        vm.numPages = 25;


        drugsService.getDrugs(vm.currentPage).then(function (response) {
            vm.drugs = response.data.data;
            vm.totalItems = response.data.all_count;
        });

        function pageChanged() {
            $location.url('/drugs?page=' + vm.currentPage)
        }


        
    }
})();