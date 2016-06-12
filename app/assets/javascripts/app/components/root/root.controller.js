(function () {
    'use strict';
    angular
        .module('appName')
        .controller('rootController', rootController);

    rootController.$inject = ['$uibModal']
    
    function rootController($uibModal) {
        var vm = this;
        vm.openModal = openModal;

        vm.message = 'This from angular Ctrl'

        function openModal() {
            $uibModal.open({
                animation: true,
                templateUrl: 'assets/app/components/root/modal.tpl.html'
            });
        }
    }
})();