(function () {
    'use strict';
    angular
        .module('appName')
        .controller('rootController', rootController);
    
    function rootController() {
        var vm = this;

        vm.message = 'This from angular Ctrl'
    }
})();