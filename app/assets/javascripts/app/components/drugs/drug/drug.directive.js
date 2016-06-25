(function () {
    'use strict';

    angular
        .module('bshcPiv')
        .directive('drug', drug);

    function drug() {
        return {
            templateUrl: 'drugs/drug/drug.tpl.html',
            scope: {
              drugs: '='  
            },
            controller: drugController,
            controllerAs: 'drugCtrl'
        }
    }

    // drugController.$inject = [];

    function drugController() {
        var vm = this;

    }
})();