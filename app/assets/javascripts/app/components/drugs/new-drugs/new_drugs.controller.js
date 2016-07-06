(function () {
    'use strict';
    
    angular
        .module('bshcPiv')
        .controller('newDrugsController', newDrugsController);

    newDrugsController.$inject = ['drugsService'];
    
    function newDrugsController(drugsService) {
        var vm = this;



        drugsService.getNewDrugsByMonth().then(function (response) {
            console.log(response.data.data)
            vm.newDrugs = response.data.data;
            vm.currentMonth = response.data.current_month;
        })
        
    }
})();