(function () {
    'use strict';

    angular
        .module('app.core', [
            'ngAnimate', 'ngSanitize',
            'blocks.exception', 'blocks.logger', 'blocks.router',
            'ui.router', 'ngplus', 'ngStorage', 'base64', 'externalServices', 'ngMaterial',
            'uiGmapgoogle-maps', 'duScroll', 'ui.mask', 'ngMessages'
        ])
        .run(designCheckFunctionality);

    designCheckFunctionality.$inject = ['$rootScope'];

    function designCheckFunctionality($rootScope) {

        $rootScope.willGoMobile = function() {
            var minHeight = Math.min(window.screen.height, window.screen.width);
            return minHeight < 768;
        };

    }
})();
