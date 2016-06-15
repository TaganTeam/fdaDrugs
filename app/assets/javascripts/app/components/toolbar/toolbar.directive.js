(function () {
    'use strict';
    angular
        .module('bshcPiv')
        .directive('toolbar', toolbar);

    toolbar.$inject = ['CONFIG', '$http', '$window'];

    function toolbar() {
        return {
            templateUrl: 'assets/app/components/toolbar/toolbar.tpl.html',
            controller: toolbarController,
            controllerAs: 'toolbarCtrl'
        };

        
        function toolbarController(CONFIG, $http, $window) {
            var vm = this;
            vm.logout = logout;

            function logout() {
                $http.delete(CONFIG.APIProductionHost + '/api/v1/logout').then(function (response) {
                    if(response.data.code === 200)
                        $window.location.reload();
                })
            }

            


        }
    }
})();