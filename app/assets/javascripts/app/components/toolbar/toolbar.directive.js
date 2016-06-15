(function () {
    'use strict';
    angular
        .module('bshcPiv')
        .directive('toolbar', toolbar);

    function toolbar() {
        return {
            templateUrl: 'assets/app/components/toolbar/toolbar.tpl.html',
            controller: toolbarController,
            controllerAs: 'toolbarCtrl'
        };

        function toolbarController() {
            var vm = this;
            vm.logout = logout;
        }

        function logout() {
            
        }

    }
})();