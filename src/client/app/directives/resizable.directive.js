(function () {
    'use strict';

    angular
        .module('app.widgets')
        .directive('resizable', resizable);

    resizable.$inject = ['config', '$window', '$timeout'];
    /* @ngInject */
    function resizable (config, $window, $timeout) {
        //Usage:
        //<div resizable ng-style="{ width: windowWidth, height: windowHeight }"></div>
        var directive = {
            link: link,
            restrict: 'A'
        };
        return directive;

        function link(scope, element, attrs) {
            scope.initializeWindowSize = function() {
                scope.windowHeight = $window.innerHeight;
                scope.windowWidth  = $window.innerWidth;
            };
            angular.element($window).bind('resize', function() {
                $timeout(function() {
                    scope.initializeWindowSize();
                    scope.$apply();
                }, 10);

            });
            scope.initializeWindowSize();
        }
    }
})();
