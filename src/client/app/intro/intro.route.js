(function() {
    'use strict';

    angular
        .module('app.intro')
        .run(appRun);

    appRun.$inject = ['routerHelper', '$rootScope'];
    /* @ngInject */
    function appRun(routerHelper, $rootScope) {
        routerHelper.configureStates(getStates($rootScope));
    }

    function getStates($rootScope) {

        return [
            {
                state: 'intro',
                config: {
                    url: '/',
                    templateUrl: $rootScope.willGoMobile() ? 'app/intro/intro.html' : 'app/intro/intro_desktop.html',
                    controller: 'IntroController',
                    controllerAs: 'ic',
                    title: 'Introduction',
                    settings: {}
                }
            }
        ];
    }
})();
